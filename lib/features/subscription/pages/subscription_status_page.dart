import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_providers.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/subscription/widgets/grace_period_banner.dart';
import 'package:thawani_pos/features/subscription/widgets/subscription_badge.dart';
import 'package:thawani_pos/features/subscription/widgets/usage_progress.dart';

/// Page showing the current subscription status, usage, and management actions.
class SubscriptionStatusPage extends ConsumerStatefulWidget {
  const SubscriptionStatusPage({super.key});

  @override
  ConsumerState<SubscriptionStatusPage> createState() => _SubscriptionStatusPageState();
}

class _SubscriptionStatusPageState extends ConsumerState<SubscriptionStatusPage> {
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.success));
        // Reload data
        ref.read(subscriptionProvider.notifier).loadCurrent();
        ref.read(usageProvider.notifier).loadUsage();
      } else if (next is SubscriptionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: AppColors.error));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subscription'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Billing History',
            onPressed: () => context.go(Routes.billingHistory),
          ),
        ],
      ),
      body: _buildBody(subState, usageState),
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
          Text('No Active Subscription', style: Theme.of(context).textTheme.titleLarge),
          AppSpacing.verticalSm,
          const Text('Choose a plan to get started with your POS.'),
          AppSpacing.verticalLg,
          ElevatedButton.icon(
            onPressed: () => context.go(Routes.planSelection),
            icon: const Icon(Icons.rocket_launch),
            label: const Text('Browse Plans'),
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
          Card(
            child: Padding(
              padding: AppSpacing.paddingAllMd,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Current Plan', style: Theme.of(context).textTheme.titleMedium),
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
            Text('Plan Usage', style: Theme.of(context).textTheme.titleMedium),
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
          Text('Actions', style: Theme.of(context).textTheme.titleMedium),
          AppSpacing.verticalSm,

          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Change Plan'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.planSelection),
          ),
          ListTile(
            leading: const Icon(Icons.compare_arrows),
            title: const Text('Compare Plans'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.planComparison),
          ),
          ListTile(
            leading: const Icon(Icons.extension),
            title: const Text('Add-Ons'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.subscriptionAddOns),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Billing History'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go(Routes.billingHistory),
          ),

          AppSpacing.verticalMd,

          if (sub.status.name == 'cancelled' || sub.status.name == 'grace')
            ElevatedButton.icon(
              onPressed: () => ref.read(subscriptionProvider.notifier).resume(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Resume Subscription'),
            )
          else
            OutlinedButton.icon(
              onPressed: _confirmCancel,
              icon: Icon(Icons.cancel, color: AppColors.error),
              label: Text('Cancel Subscription', style: TextStyle(color: AppColors.error)),
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
        title: const Text('Cancel Subscription?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Are you sure you want to cancel? You may lose access to premium features.'),
            AppSpacing.verticalMd,
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason (optional)', border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Keep Plan')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(ctx);
              ref
                  .read(subscriptionProvider.notifier)
                  .cancel(reason: reasonController.text.isNotEmpty ? reasonController.text : null);
            },
            child: const Text('Cancel Subscription'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
