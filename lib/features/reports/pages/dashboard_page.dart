import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(dashboardProvider.notifier).load())],
      ),
      body: switch (state) {
        DashboardInitial() || DashboardLoading() => PosLoadingSkeleton.list(),
        DashboardError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(dashboardProvider.notifier).load(),
        ),
        DashboardLoaded(:final today, :final yesterday, :final topProducts) => RefreshIndicator(
          onRefresh: () => ref.read(dashboardProvider.notifier).load(),
          child: ListView(
            padding: AppSpacing.paddingAll16,
            children: [
              // Quick navigation to detailed reports
              Text('Reports', style: theme.textTheme.titleLarge),
              AppSpacing.gapH12,
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _ReportTile(
                      icon: Icons.receipt_long,
                      label: 'Sales',
                      color: AppColors.success,
                      onTap: () => context.go(Routes.reportsSalesSummary),
                    ),
                    AppSpacing.gapW8,
                    _ReportTile(
                      icon: Icons.inventory_2,
                      label: 'Products',
                      color: AppColors.info,
                      onTap: () => context.go(Routes.reportsProductPerformance),
                    ),
                    AppSpacing.gapW8,
                    _ReportTile(
                      icon: Icons.category,
                      label: 'Categories',
                      color: AppColors.warning,
                      onTap: () => context.go(Routes.reportsCategoryBreakdown),
                    ),
                    AppSpacing.gapW8,
                    _ReportTile(
                      icon: Icons.people,
                      label: 'Staff',
                      color: AppColors.purple,
                      onTap: () => context.go(Routes.reportsStaffPerformance),
                    ),
                    AppSpacing.gapW8,
                    _ReportTile(
                      icon: Icons.access_time,
                      label: 'Hourly',
                      color: AppColors.primary,
                      onTap: () => context.go(Routes.reportsHourlySales),
                    ),
                    AppSpacing.gapW8,
                    _ReportTile(
                      icon: Icons.payment,
                      label: 'Payments',
                      color: AppColors.successDark,
                      onTap: () => context.go(Routes.reportsPaymentMethods),
                    ),
                  ],
                ),
              ),

              AppSpacing.gapH24,
              Text('Today', style: theme.textTheme.titleLarge),
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Revenue',
                      value: '\$${(today['total_revenue'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.trending_up,
                      color: AppColors.success,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _KpiCard(
                      label: 'Transactions',
                      value: '${today['total_transactions'] ?? 0}',
                      icon: Icons.receipt_long,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Net Revenue',
                      value: '\$${(today['net_revenue'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.account_balance_wallet,
                      color: AppColors.successDark,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _KpiCard(
                      label: 'Customers',
                      value: '${today['unique_customers'] ?? 0}',
                      icon: Icons.people,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(
                    child: _KpiCard(
                      label: 'Avg Basket',
                      value: '\$${(today['avg_basket_size'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.shopping_basket,
                      color: AppColors.purple,
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _KpiCard(
                      label: 'Refunds',
                      value: '\$${(today['total_refunds'] as num? ?? 0).toStringAsFixed(2)}',
                      icon: Icons.undo,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),

              AppSpacing.gapH24,
              Text('vs Yesterday', style: theme.textTheme.titleMedium),
              AppSpacing.gapH8,
              _ComparisonRow(
                label: 'Revenue',
                todayVal: (today['total_revenue'] as num? ?? 0).toDouble(),
                yesterdayVal: (yesterday['total_revenue'] as num? ?? 0).toDouble(),
              ),
              _ComparisonRow(
                label: 'Transactions',
                todayVal: (today['total_transactions'] as num? ?? 0).toDouble(),
                yesterdayVal: (yesterday['total_transactions'] as num? ?? 0).toDouble(),
              ),

              AppSpacing.gapH24,
              Text('Top Products Today', style: theme.textTheme.titleMedium),
              AppSpacing.gapH8,
              if (topProducts.isEmpty)
                const PosEmptyState(title: 'No sales data yet today', icon: Icons.trending_up)
              else
                ...topProducts.map(
                  (p) => Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary10,
                        foregroundColor: AppColors.primary,
                        child: Text('${topProducts.indexOf(p) + 1}'),
                      ),
                      title: Text(p['product_name'] as String? ?? ''),
                      subtitle: Text('Qty: ${(p['quantity_sold'] as num? ?? 0).toStringAsFixed(1)}'),
                      trailing: Text(
                        '\$${(p['revenue'] as num? ?? 0).toStringAsFixed(2)}',
                        style: theme.textTheme.titleSmall?.copyWith(color: AppColors.success),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      },
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            AppSpacing.gapH8,
            Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapH4,
            Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  final String label;
  final double todayVal;
  final double yesterdayVal;

  const _ComparisonRow({required this.label, required this.todayVal, required this.yesterdayVal});

  @override
  Widget build(BuildContext context) {
    final diff = yesterdayVal > 0 ? ((todayVal - yesterdayVal) / yesterdayVal * 100) : 0.0;
    final isPositive = diff >= 0;
    final changeColor = isPositive ? AppColors.success : AppColors.error;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        title: Text(label),
        subtitle: Text('Today: ${todayVal.toStringAsFixed(2)} | Yesterday: ${yesterdayVal.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(isPositive ? Icons.arrow_upward : Icons.arrow_downward, color: changeColor, size: 18),
            Text(
              '${diff.toStringAsFixed(1)}%',
              style: TextStyle(color: changeColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ReportTile({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: SizedBox(
          width: 88,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              AppSpacing.gapH4,
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
