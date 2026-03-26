import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminAnalyticsRevenuePage extends ConsumerStatefulWidget {
  const AdminAnalyticsRevenuePage({super.key});

  @override
  ConsumerState<AdminAnalyticsRevenuePage> createState() => _AdminAnalyticsRevenuePageState();
}

class _AdminAnalyticsRevenuePageState extends ConsumerState<AdminAnalyticsRevenuePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(analyticsRevenueProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsRevenueProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Revenue',
            onPressed: () => ref.read(analyticsExportProvider.notifier).exportRevenue(),
          ),
        ],
      ),
      body: switch (state) {
        AnalyticsRevenueLoading() => const Center(child: CircularProgressIndicator()),
        AnalyticsRevenueLoaded(
          mrr: final mrr,
          arr: final arr,
          revenueByPlan: final byPlan,
          failedPaymentsCount: final failed,
          upcomingRenewals: final renewals,
          revenueTrend: final trend,
        ) =>
          RefreshIndicator(
            onRefresh: () => ref.read(analyticsRevenueProvider.notifier).load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // MRR & ARR cards
                Row(
                  children: [
                    Expanded(child: _metricCard('MRR', '\$${mrr.toStringAsFixed(2)}', AppColors.success)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _metricCard('ARR', '\$${arr.toStringAsFixed(2)}', AppColors.info)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(child: _metricCard('Failed Payments', '$failed', AppColors.error)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: _metricCard('Upcoming Renewals', '$renewals', AppColors.warning)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),

                // Revenue by Plan
                const Text('Revenue by Plan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                if (byPlan.isEmpty)
                  const Card(
                    child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No plan data available')),
                  )
                else
                  ...byPlan.map(
                    (p) => Card(
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Icon(Icons.workspace_premium, color: Colors.white),
                        ),
                        title: Text(p['plan_name'] as String? ?? 'Unknown'),
                        subtitle: Text('${p['active_count'] ?? 0} active stores'),
                        trailing: Text(
                          '\$${(p['mrr'] as num? ?? 0).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: AppSpacing.lg),

                // Revenue Trend
                const Text('Revenue Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                if (trend.isEmpty)
                  const Card(
                    child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No trend data')),
                  )
                else
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: trend.length,
                      itemBuilder: (context, index) {
                        final t = trend[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text('\$${(t['mrr'] as num? ?? 0).toStringAsFixed(0)}', style: const TextStyle(fontSize: 10)),
                              Container(
                                width: 30,
                                height: ((t['mrr'] as num? ?? 0).toDouble() / (mrr > 0 ? mrr : 1) * 120).clamp(4.0, 150.0),
                                color: AppColors.primary.withValues(alpha: 0.7),
                              ),
                              const SizedBox(height: 4),
                              Text((t['date'] as String? ?? '').substring(5), style: const TextStyle(fontSize: 8)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        AnalyticsRevenueError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error: $msg'),
              const SizedBox(height: AppSpacing.sm),
              ElevatedButton(onPressed: () => ref.read(analyticsRevenueProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        _ => const Center(child: Text('Loading revenue data...')),
      },
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
