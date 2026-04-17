import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
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
        // Reload data
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
    icon: Icons.receipt_long, onPressed: () => context.go(Routes.billingHistory), tooltip: l10n.subscriptionBillingHistory,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.card_membership, size: 64, color: AppColors.textSecondary),
          AppSpacing.verticalLg,
          Text(l10n.subscriptionNoActiveSubscription, style: Theme.of(context).textTheme.titleLarge),
          AppSpacing.verticalSm,
          Text(l10n.subscriptionChoosePlan),
          AppSpacing.verticalLg,
          PosButton(
            onPressed: () => context.go(Routes.planSelection),
            icon: Icons.rocket_launch,
            label: l10n.subscriptionBrowsePlans,
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionDetails(SubscriptionLoaded subState, UsageState usageState) {
    final sub = subState.subscription!;
    final isGracePeriod = sub.status.name == 'grace' || sub.status.name == 'past_due';
    final isExpired = sub.status.name == 'expired';

    return RefreshIndicator(
      onRefresh: () async {
        ref.read(subscriptionProvider.notifier).loadCurrent();
        ref.read(usageProvider.notifier).loadUsage();
      },
      child: ListView(
        padding: AppSpacing.paddingAllMd,
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

          // Status card
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAllMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.subscriptionCurrentPlan, style: Theme.of(context).textTheme.titleMedium),
                      SubscriptionBadge(status: sub.status.name),
                    ],
                  ),
                  AppSpacing.verticalSm,
                  Text(
                    sub.plan?.name ?? sub.subscriptionPlanId,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  AppSpacing.verticalSm,
                  Text('Billing: ${sub.billingCycle?.name ?? 'monthly'}'),
                  if (sub.currentPeriodStart != null && sub.currentPeriodEnd != null)
                    Text('Period: ${_formatDate(sub.currentPeriodStart!)} — ${_formatDate(sub.currentPeriodEnd!)}'),
                  if (sub.trialEndsAt != null)
                    Text('Trial ends: ${_formatDate(sub.trialEndsAt!)}', style: TextStyle(color: AppColors.warning)),
                  if (sub.gracePeriodEndsAt != null && isGracePeriod)
                    Text('Grace period ends: ${_formatDate(sub.gracePeriodEndsAt!)}', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
          ),

          AppSpacing.verticalMd,

          // Usage section
          if (usageState is UsageLoaded && usageState.usageItems.isNotEmpty) ...[
            Text(l10n.subscriptionPlanUsage, style: Theme.of(context).textTheme.titleMedium),
            AppSpacing.verticalSm,
            ...usageState.usageItems.map(
              (item) => UsageProgress(
                label: (item['limit_key'] as String?) ?? '',
                current: (item['current'] as num?)?.toInt() ?? 0,
                limit: (item['limit'] as num?)?.toInt(),
                percentage: (item['percentage'] != null ? double.tryParse(item['percentage'].toString()) : null) ?? 0,
              ),
            ),
          ],

          AppSpacing.verticalLg,

          // Actions
          Text(l10n.actions, style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.verticalSm,

          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: Text(l10n.subscriptionChangePlan),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.planSelection),
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: Text(l10n.subscriptionComparePlans),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.planComparison),
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: Text(l10n.subscriptionAddOns),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.subscriptionAddOns),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(l10n.subscriptionBillingHistory),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.billingHistory),
          ),

          AppSpacing.verticalMd,

          if (sub.status.name == 'cancelled' || sub.status.name == 'grace')
            PosButton(
              onPressed: () => ref.read(subscriptionProvider.notifier).resume(),
              icon: Icons.play_arrow,
              label: l10n.subscriptionResumeSubscription,
            )
          else
            OutlinedButton.icon(
              onPressed: _confirmCancel,
              icon: Icon(Icons.cancel, color: AppColors.error),
              label: Text(l10n.subscriptionCancelSubscription, style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error)),
            ),
        ],
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
            AppSpacing.verticalMd,
            TextField(
              controller: reasonController,
              decoration: InputDecoration(labelText: l10n.subscriptionCancelReasonLabel, border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.subscriptionKeepPlan),
          PosButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(subscriptionProvider.notifier)
                  .cancel(reason: reasonController.text.isNotEmpty ? reasonController.text : null);
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
