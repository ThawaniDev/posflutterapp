import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminAnalyticsSubscriptionsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSubscriptionsPage({super.key});

  @override
  ConsumerState<AdminAnalyticsSubscriptionsPage> createState() => _AdminAnalyticsSubscriptionsPageState();
}

class _AdminAnalyticsSubscriptionsPageState extends ConsumerState<AdminAnalyticsSubscriptionsPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId);
  }

  Color _statusColor(String status) {
    return switch (status) {
      'active' => AppColors.success,
      'trial' => AppColors.info,
      'cancelled' => AppColors.error,
      'past_due' => AppColors.warning,
      'expired' => AppColors.textSecondary,
      _ => AppColors.info,
    };
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsSubscriptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Subscriptions',
            onPressed: () => ref.read(analyticsExportProvider.notifier).exportSubscriptions(),
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsSubscriptionsLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsSubscriptionsLoaded(
                statusCounts: final counts,
                averageSubscriptionAgeDays: final avgAge,
                totalChurnInPeriod: final churn,
                trialToPaidConversionRate: final conversion,
                lifecycleTrend: final trend,
              ) =>
                RefreshIndicator(
                  onRefresh: () => ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // Conversion & Churn highlights
                      Row(
                        children: [
                          Expanded(child: _metricCard('Conversion Rate', '${conversion.toStringAsFixed(1)}%', AppColors.success)),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(child: _metricCard('Churn (Period)', '$churn', AppColors.error)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _metricCard('Avg Sub Age', '${avgAge.toStringAsFixed(0)} days', AppColors.info),
                      const SizedBox(height: AppSpacing.lg),

                      // Status breakdown
                      const Text('Status Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      ...counts.entries.map(
                        (e) => Card(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _statusColor(e.key).withValues(alpha: 0.2),
                              child: Icon(Icons.circle, color: _statusColor(e.key), size: 16),
                            ),
                            title: Text(e.key.toUpperCase()),
                            trailing: Text('${e.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      // Lifecycle trend
                      const Text('Lifecycle Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (trend.isEmpty)
                        const Card(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No trend data')),
                        )
                      else
                        ...trend.map(
                          (t) => Card(
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: ListTile(
                              title: Text(t['date'] as String? ?? ''),
                              subtitle: Text(
                                'Active: ${t['active'] ?? 0} | Trial: ${t['trial'] ?? 0} | Churned: ${t['churned'] ?? 0}',
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              AnalyticsSubscriptionsError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $msg'),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () => ref.read(analyticsSubscriptionsProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading subscription analytics...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
