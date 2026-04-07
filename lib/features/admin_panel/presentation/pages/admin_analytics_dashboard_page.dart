import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminAnalyticsDashboardPage extends ConsumerStatefulWidget {
  const AdminAnalyticsDashboardPage({super.key});

  @override
  ConsumerState<AdminAnalyticsDashboardPage> createState() => _AdminAnalyticsDashboardPageState();
}

class _AdminAnalyticsDashboardPageState extends ConsumerState<AdminAnalyticsDashboardPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsDashboardProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsDashboardProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsDashboardProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Dashboard'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsDashboardLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsDashboardLoaded(kpi: final kpi, recentActivity: final activity) => RefreshIndicator(
                onRefresh: () => ref.read(analyticsDashboardProvider.notifier).load(storeId: _storeId),
                child: ListView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  children: [
                    // KPI Cards
                    const Text('Key Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    _buildKpiGrid(kpi),
                    const SizedBox(height: AppSpacing.lg),

                    // Recent Activity
                    const Text('Recent Activity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: AppSpacing.sm),
                    ...activity.map(
                      (a) => Card(
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        child: ListTile(
                          leading: const Icon(Icons.history, color: AppColors.primary),
                          title: Text(a['action'] as String? ?? ''),
                          subtitle: Text(a['entity_type'] as String? ?? ''),
                          trailing: Text(
                            _formatDate(a['created_at']),
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AnalyticsDashboardError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $msg'),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () => ref.read(analyticsDashboardProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading analytics...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKpiGrid(Map<String, dynamic> kpi) {
    final items = [
      _KpiItem('Active Stores', '${kpi['total_active_stores'] ?? 0}', Icons.store, AppColors.info),
      _KpiItem('MRR', '\u0081${(kpi['mrr'] as num? ?? 0).toStringAsFixed(2)}', Icons.attach_money, AppColors.success),
      _KpiItem('New Signups', '${kpi['new_signups_this_month'] ?? 0}', Icons.person_add, AppColors.warning),
      _KpiItem('Churn Rate', '${kpi['churn_rate'] ?? 0}%', Icons.trending_down, AppColors.error),
      _KpiItem('Total Orders', '${kpi['total_orders'] ?? 0}', Icons.shopping_cart, AppColors.purple),
      _KpiItem('Total GMV', '\u0081${(kpi['total_gmv'] as num? ?? 0).toStringAsFixed(2)}', Icons.payments, AppColors.info),
      _KpiItem('ZATCA Compliance', '${kpi['zatca_compliance_rate'] ?? 100}%', Icons.verified, AppColors.info),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.6,
        crossAxisSpacing: AppSpacing.sm,
        mainAxisSpacing: AppSpacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.icon, color: item.color, size: 24),
                const SizedBox(height: 4),
                Text(
                  item.value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: item.color),
                ),
                Text(item.label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(dynamic date) {
    if (date == null) return '';
    return date.toString().substring(0, 10);
  }
}

class _KpiItem {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _KpiItem(this.label, this.value, this.icon, this.color);
}
