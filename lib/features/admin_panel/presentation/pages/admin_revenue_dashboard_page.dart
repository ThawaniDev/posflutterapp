import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminRevenueDashboardPage extends ConsumerStatefulWidget {
  const AdminRevenueDashboardPage({super.key});

  @override
  ConsumerState<AdminRevenueDashboardPage> createState() => _AdminRevenueDashboardPageState();
}

class _AdminRevenueDashboardPageState extends ConsumerState<AdminRevenueDashboardPage> {
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(revenueDashboardProvider.notifier).loadDashboard(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(revenueDashboardProvider.notifier).loadDashboard(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(revenueDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Revenue Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(revenueDashboardProvider.notifier).loadDashboard(storeId: _storeId),
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              RevenueDashboardLoading() => const Center(child: CircularProgressIndicator()),
              RevenueDashboardLoaded() => SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // MRR / ARR Cards
                    Row(
                      children: [
                        Expanded(
                          child: _metricCard(
                            'MRR',
                            '${state.mrr.toStringAsFixed(2)} \u0081',
                            Icons.trending_up,
                            AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _metricCard(
                            'ARR',
                            '${state.arr.toStringAsFixed(2)} \u0081',
                            Icons.calendar_today,
                            AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Invoice stats
                    context.isPhone
                        ? Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              _metricCard('Total Invoices', '${state.totalInvoices}', Icons.receipt, AppColors.info),
                              _metricCard('Paid', '${state.paidInvoices}', Icons.check_circle, AppColors.success),
                              _metricCard('Failed', '${state.failedInvoices}', Icons.error, AppColors.error),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _metricCard('Total Invoices', '${state.totalInvoices}', Icons.receipt, AppColors.info),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: _metricCard('Paid', '${state.paidInvoices}', Icons.check_circle, AppColors.success),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(child: _metricCard('Failed', '${state.failedInvoices}', Icons.error, AppColors.error)),
                            ],
                          ),
                    const SizedBox(height: AppSpacing.md),

                    // Additional metrics
                    Row(
                      children: [
                        Expanded(
                          child: _metricCard('Upcoming Renewals', '${state.upcomingRenewals}', Icons.event, AppColors.warning),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: _metricCard(
                            'Hardware Revenue',
                            '${state.hardwareRevenue.toStringAsFixed(2)} \u0081',
                            Icons.devices,
                            AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    _metricCard(
                      'Implementation Revenue',
                      '${state.implementationRevenue.toStringAsFixed(2)} \u0081',
                      Icons.build_circle,
                      AppColors.info,
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    // Revenue by Status
                    Text('Revenue by Status', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    ...state.revenueByStatus.map(
                      (item) => Card(
                        child: ListTile(
                          leading: Icon(Icons.circle, color: _statusColor(item['status'] ?? '')),
                          title: Text((item['status'] as String? ?? '').toUpperCase()),
                          subtitle: Text('${item['count']} invoices'),
                          trailing: Text('${item['revenue']} \u0081', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RevenueDashboardError(message: final msg) => Center(child: Text('Error: $msg')),
              _ => const Center(child: Text('Loading...')),
            },
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      'paid' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.error,
      'refunded' => AppColors.purple,
      _ => AppColors.textSecondary,
    };
  }
}
