import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/widgets/grace_period_banner.dart';
import 'package:wameedpos/features/subscription/widgets/subscription_badge.dart';
import 'package:wameedpos/features/subscription/widgets/usage_progress.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Page showing the current subscription status, usage, and management actions.
class SubscriptionStatusPage extends ConsumerStatefulWidget {
  const SubscriptionStatusPage({super.key});

  @override
  ConsumerState<SubscriptionStatusPage> createState() => _SubscriptionStatusPageState();
}

class _SubscriptionStatusPageState extends ConsumerState<SubscriptionStatusPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(subscriptionProvider.notifier).loadCurrent();
      ref.read(usageProvider.notifier).loadUsage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final subState = ref.watch(subscriptionProvider);
    final usageState = ref.watch(usageProvider);

    // Listen for action results
    ref.listen<SubscriptionState>(subscriptionProvider, (prev, next) {
      if (next is SubscriptionActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(subscriptionProvider.notifier).loadCurrent();
        ref.read(usageProvider.notifier).loadUsage();
      } else if (next is SubscriptionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return PosListPage(
      title: l10n.subscriptionMySubscription,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.receipt_long,
          onPressed: () => context.go(Routes.billingHistory),
          tooltip: l10n.subscriptionBillingHistory,
        ),
      ],
      child: _buildBody(subState, usageState),
    );
  }

  Widget _buildBody(SubscriptionState subState, UsageState usageState) {
    if (subState is SubscriptionLoading) {
      return Center(child: PosLoadingSkeleton.list());
    }

    if (subState is SubscriptionError) {
      return PosErrorState(message: subState.message, onRetry: () => ref.read(subscriptionProvider.notifier).loadCurrent());
    }

    if (subState is SubscriptionLoaded) {
      if (subState.subscription == null) {
        return _buildNoSubscription();
      }
      return _buildSubscriptionDetails(subState, usageState);
    }

    return const SizedBox.shrink();
  }

  Widget _buildNoSubscription() {
    return PosEmptyState(
      icon: Icons.card_membership,
      title: l10n.subscriptionNoActiveSubscription,
      subtitle: l10n.subscriptionChoosePlan,
      actionLabel: l10n.subscriptionBrowsePlans,
      onAction: () => context.go(Routes.planSelection),
    );
  }

  Widget _buildSubscriptionDetails(SubscriptionLoaded subState, UsageState usageState) {
    final sub = subState.subscription!;
    final isGracePeriod = sub.status.name == 'grace' || sub.status.name == 'past_due';
    final isExpired = sub.status.name == 'expired';
    final isTrial = sub.status.name == 'trial';

    // Calculate days remaining in current period
    final daysRemaining = sub.currentPeriodEnd != null ? sub.currentPeriodEnd!.difference(DateTime.now()).inDays : 0;

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(subscriptionProvider.notifier).loadCurrent();
        ref.read(usageProvider.notifier).loadUsage();
      },
      child: ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // Grace period / expiry banner
          if (isGracePeriod && sub.gracePeriodEndsAt != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GracePeriodBanner(
                gracePeriodEndsAt: sub.gracePeriodEndsAt!,
                onRenewPressed: () => context.go(Routes.planSelection),
              ),
            ),
          if (isExpired)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: GracePeriodBanner(
                gracePeriodEndsAt: DateTime.now(),
                isExpired: true,
                onRenewPressed: () => context.go(Routes.planSelection),
              ),
            ),

          // ── KPI Row: Plan, Status, Days Remaining, Billing ──
          _buildKpiRow(sub, daysRemaining, isTrial),

          AppSpacing.gapH16,

          // ── Plan Details Card ──
          _buildPlanDetailsCard(sub, isTrial, isGracePeriod),

          AppSpacing.gapH16,

          // ── Limits & Usage Section ──
          _buildLimitsAndUsageCard(sub, usageState),
          AppSpacing.gapH16,

          // ── SoftPOS Progress ──
          _buildSoftPosProgress(),

          // ── Included Features ──
          if (sub.plan?.features != null && sub.plan!.features!.isNotEmpty) ...[_buildFeaturesCard(sub), AppSpacing.gapH16],

          // ── Quick Actions Grid ──
          _buildActionsSection(sub),

          AppSpacing.gapH24,

          // ── Cancel / Resume Button ──
          if (sub.status.name == 'cancelled' || sub.status.name == 'grace')
            PosButton(
              onPressed: () => ref.read(subscriptionProvider.notifier).resume(l10n),
              icon: Icons.play_arrow,
              label: l10n.subscriptionResumeSubscription,
              isFullWidth: true,
              size: PosButtonSize.lg,
            )
          else
            PosButton(
              onPressed: _confirmCancel,
              icon: Icons.cancel,
              label: l10n.subscriptionCancelSubscription,
              variant: PosButtonVariant.danger,
              isFullWidth: true,
              size: PosButtonSize.lg,
            ),
          AppSpacing.gapH16,
        ],
      ),
    );
  }

  Widget _buildKpiRow(StoreSubscription sub, int daysRemaining, bool isTrial) {
    return Row(
      children: [
        Expanded(
          child: PosKpiCard(
            label: l10n.subscriptionCurrentPlan,
            value: sub.plan?.localizedName(Localizations.localeOf(context).languageCode) ?? '—',
            icon: Icons.workspace_premium,
            iconColor: AppColors.primary,
            iconBgColor: AppColors.primary.withValues(alpha: 0.10),
          ),
        ),
        AppSpacing.gapW12,
        Expanded(
          child: PosKpiCard(
            label: l10n.subDaysRemaining,
            value: daysRemaining > 0 ? '$daysRemaining' : '—',
            icon: Icons.calendar_today,
            iconColor: daysRemaining <= 7
                ? AppColors.error
                : daysRemaining <= 14
                ? AppColors.warning
                : AppColors.info,
            iconBgColor:
                (daysRemaining <= 7
                        ? AppColors.error
                        : daysRemaining <= 14
                        ? AppColors.warning
                        : AppColors.info)
                    .withValues(alpha: 0.10),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanDetailsCard(StoreSubscription sub, bool isTrial, bool isGracePeriod) {
    final price = sub.billingCycle?.name == 'yearly'
        ? (sub.plan?.annualPrice ?? sub.plan?.monthlyPrice ?? 0.0)
        : (sub.plan?.monthlyPrice ?? 0.0);
    final period = sub.billingCycle?.name == 'yearly' ? l10n.subPerYear : l10n.subPerMonth;

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.subPlanDetails,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                SubscriptionBadge(status: sub.status.name),
              ],
            ),

            AppSpacing.gapH16,
            const PosDivider(),
            AppSpacing.gapH16,

            // Plan name + price
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.10), borderRadius: AppRadius.borderLg),
                  child: const Icon(Icons.workspace_premium, color: AppColors.primary, size: 28),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sub.plan?.localizedName(Localizations.localeOf(context).languageCode) ?? sub.subscriptionPlanId,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      AppSpacing.gapH4,
                      Row(
                        children: [
                          Text(
                            '${price.toStringAsFixed(3)} ',
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            period,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            AppSpacing.gapH16,
            const PosDivider(),
            AppSpacing.gapH12,

            // Detail rows
            _buildDetailRow(Icons.sync, l10n.subBillingLabel(sub.billingCycle?.name ?? l10n.subBillingCycleMonthly)),
            if (sub.currentPeriodStart != null && sub.currentPeriodEnd != null)
              _buildDetailRow(
                Icons.date_range,
                l10n.subPeriodLabel(_formatDate(sub.currentPeriodStart!), _formatDate(sub.currentPeriodEnd!)),
              ),
            if (sub.currentPeriodEnd != null)
              _buildDetailRow(Icons.event, '${l10n.subNextBillingDate}: ${_formatDate(sub.currentPeriodEnd!)}'),
            if (sub.paymentMethod != null) _buildDetailRow(Icons.payment, '${l10n.subPaymentMethod}: ${sub.paymentMethod!.name}'),
            if (isTrial && sub.trialEndsAt != null)
              _buildDetailRow(Icons.hourglass_bottom, l10n.subTrialEnds(_formatDate(sub.trialEndsAt!)), color: AppColors.warning),
            if (isGracePeriod && sub.gracePeriodEndsAt != null)
              _buildDetailRow(
                Icons.warning_amber,
                l10n.subGracePeriodEnds(_formatDate(sub.gracePeriodEndsAt!)),
                color: AppColors.error,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color ?? AppColors.mutedFor(context)),
          AppSpacing.gapW8,
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildLimitsAndUsageCard(StoreSubscription sub, UsageState usageState) {
    final limits = sub.plan?.limits;
    final usageItems = usageState is UsageLoaded ? usageState.usageItems : <Map<String, dynamic>>[];

    // Build a map of usage by limit_key for quick lookup
    final usageByKey = <String, Map<String, dynamic>>{};
    for (final item in usageItems) {
      final key = item['limit_key'] as String? ?? '';
      if (key.isNotEmpty) usageByKey[key] = item;
    }

    // If we have neither plan limits nor usage data, hide the card
    if ((limits == null || limits.isEmpty) && usageItems.isEmpty) {
      return const SizedBox.shrink();
    }

    // Merge: iterate plan limits first, then any usage keys not in plan limits
    final mergedKeys = <String>[];
    if (limits != null) {
      for (final l in limits) {
        final key = l['limit_key'] as String? ?? '';
        if (key.isNotEmpty) mergedKeys.add(key);
      }
    }
    for (final key in usageByKey.keys) {
      if (!mergedKeys.contains(key)) mergedKeys.add(key);
    }

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.subscriptionPlanUsage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppSpacing.gapH12,
            ...mergedKeys.map((key) {
              final usage = usageByKey[key];
              final planLimit = limits?.firstWhere((l) => l['limit_key'] == key, orElse: () => <String, dynamic>{});

              final current = (usage?['current'] as num?)?.toInt() ?? 0;
              final limitVal = usage != null ? (usage['limit'] as num?)?.toInt() : (planLimit?['limit_value'] as num?)?.toInt();
              final isUnlimited = (usage?['is_unlimited'] == true) || (limitVal != null && limitVal < 0);
              final percentage = usage != null ? (double.tryParse(usage['percentage'].toString()) ?? 0) : 0.0;

              return UsageProgress(label: key, current: current, limit: isUnlimited ? null : limitVal, percentage: percentage);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturesCard(StoreSubscription sub) {
    final features = sub.plan!.features as List<Map<String, dynamic>>;
    final enabledFeatures = features.where((f) => f['is_enabled'] == true).toList();

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.subIncludedFeatures,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                PosBadge(
                  label: l10n.subFeaturesIncluded(enabledFeatures.length),
                  variant: PosBadgeVariant.primary,
                  isSmall: true,
                ),
              ],
            ),
            AppSpacing.gapH12,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: enabledFeatures.map((f) {
                final name = SubscriptionPlan.featureName(f, Localizations.localeOf(context).languageCode);
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.08),
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle, size: 14, color: AppColors.successDark),
                      AppSpacing.gapW4,
                      Text(
                        name,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: AppColors.successDark, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(StoreSubscription sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.subQuickActions, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        AppSpacing.gapH12,
        // First row: 2 cards
        Row(
          children: [
            Expanded(
              child: _buildActionCard(Icons.swap_horiz, l10n.subscriptionChangePlan, () => context.go(Routes.planSelection)),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: _buildActionCard(
                Icons.compare_arrows,
                l10n.subscriptionComparePlans,
                () => context.go(Routes.planComparison),
              ),
            ),
          ],
        ),
        AppSpacing.gapH12,
        // Second row: 2 cards
        Row(
          children: [
            Expanded(
              child: _buildActionCard(Icons.extension, l10n.subscriptionAddOns, () => context.go(Routes.subscriptionAddOns)),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: _buildActionCard(
                Icons.receipt_long,
                l10n.subscriptionBillingHistory,
                () => context.go(Routes.billingHistory),
              ),
            ),
          ],
        ),
        AppSpacing.gapH12,
        // Third row: Provider Payments
        _buildActionCard(Icons.payments, l10n.subViewPayments, () => context.go(Routes.providerPayments)),
      ],
    );
  }

  Widget _buildActionCard(IconData icon, String label, VoidCallback onTap) {
    return PosCard(
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            Container(
              padding: AppSpacing.paddingAll8,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            AppSpacing.gapH8,
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoftPosProgress() {
    final featureGate = ref.read(featureGateServiceProvider);
    final softPosInfo = featureGate.softPosInfo;

    if (softPosInfo == null || softPosInfo['is_eligible'] != true) {
      return const SizedBox.shrink();
    }

    final isFree = softPosInfo['is_free'] as bool? ?? false;
    final currentCount = (softPosInfo['current_count'] as num?)?.toInt() ?? 0;
    final threshold = (softPosInfo['threshold'] as num?)?.toInt() ?? 0;
    final remaining = (softPosInfo['remaining'] as num?)?.toInt() ?? 0;
    final percentage = (softPosInfo['percentage'] as num?)?.toDouble() ?? 0.0;
    final savingsAmount = (softPosInfo['savings_amount'] as num?)?.toDouble() ?? 0.0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PosCard(
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isFree ? Icons.check_circle : Icons.phone_android,
                    color: isFree ? AppColors.success : AppColors.primary,
                    size: 24,
                  ),
                  AppSpacing.gapW8,
                  Text(
                    l10n.softPosFreeTier,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              AppSpacing.gapH8,
              if (isFree) ...[
                Text(
                  l10n.softPosFreeActive,
                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.w600),
                ),
                if (savingsAmount > 0)
                  Text(l10n.softPosSaving(savingsAmount.toStringAsFixed(0)), style: const TextStyle(color: AppColors.success)),
              ] else ...[
                Text(l10n.softPosReachThreshold(threshold)),
                AppSpacing.gapH8,
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (percentage / 100).clamp(0.0, 1.0),
                    minHeight: 10,
                    backgroundColor: AppColors.mutedFor(context).withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(percentage >= 80 ? AppColors.success : AppColors.primary),
                  ),
                ),
                AppSpacing.gapH4,
                Text(
                  '$currentCount / $threshold ${l10n.softPosTransactions} ($remaining ${l10n.softPosRemaining})',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _confirmCancel() {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.subscriptionCancelConfirmTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.subscriptionCancelConfirmMessage),
            AppSpacing.gapH12,
            PosTextField(controller: reasonController, label: l10n.subscriptionCancelReasonLabel, maxLines: 2),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.subscriptionKeepPlan),
          PosButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(subscriptionProvider.notifier)
                  .cancel(l10n, reason: reasonController.text.isNotEmpty ? reasonController.text : null);
            },
            label: l10n.subscriptionCancelSubscription,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
