import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: const Text('Reports & Analytics'),
        actions: [
          IconButton.filled(
            onPressed: () => ref.read(dashboardProvider.notifier).load(),
            icon: const Icon(Icons.refresh_rounded, size: 20),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              foregroundColor: AppColors.primary,
            ),
          ),
          const SizedBox(width: 8),
        ],
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
            padding: const EdgeInsets.all(20),
            children: [
              _ReportNavGrid(isDark: isDark),
              const SizedBox(height: 28),

              const ReportSectionHeader(title: "Today's Overview", icon: Icons.today_rounded),
              ReportKpiGrid(
                cards: [
                  ReportKpiCard(
                    label: 'Revenue',
                    value: formatCurrency(today['total_revenue'] as num? ?? 0),
                    icon: Icons.trending_up_rounded,
                    color: AppColors.success,
                  ),
                  ReportKpiCard(
                    label: 'Transactions',
                    value: '${today['total_transactions'] ?? 0}',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.info,
                  ),
                  ReportKpiCard(
                    label: 'Net Revenue',
                    value: formatCurrency(today['net_revenue'] as num? ?? 0),
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                  ),
                  ReportKpiCard(
                    label: 'Avg Basket',
                    value: formatCurrency(today['avg_basket_size'] as num? ?? 0),
                    icon: Icons.shopping_basket_rounded,
                    color: AppColors.warning,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ReportKpiCard(
                      label: 'Customers',
                      value: '${today['unique_customers'] ?? 0}',
                      icon: Icons.people_rounded,
                      color: AppColors.purple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ReportKpiCard(
                      label: 'Refunds',
                      value: formatCurrency(today['total_refunds'] as num? ?? 0),
                      icon: Icons.undo_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              const ReportSectionHeader(title: 'vs Yesterday', icon: Icons.compare_arrows_rounded),
              ReportDataCard(
                child: Column(
                  children: [
                    ReportComparisonRow(
                      label: 'Revenue',
                      todayVal: (today['total_revenue'] as num? ?? 0).toDouble(),
                      yesterdayVal: (yesterday['total_revenue'] as num? ?? 0).toDouble(),
                    ),
                    Divider(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ReportComparisonRow(
                      label: 'Transactions',
                      todayVal: (today['total_transactions'] as num? ?? 0).toDouble(),
                      yesterdayVal: (yesterday['total_transactions'] as num? ?? 0).toDouble(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              const ReportSectionHeader(title: 'Top Products Today', icon: Icons.star_rounded),
              if (topProducts.isEmpty)
                const ReportDataCard(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text('No sales data yet today')),
                  ),
                )
              else
                ReportDataCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < topProducts.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ReportRankedItem(
                          rank: i + 1,
                          title: topProducts[i]['product_name'] as String? ?? '',
                          subtitle: 'Qty: ${(topProducts[i]['quantity_sold'] as num? ?? 0).toStringAsFixed(0)}',
                          trailingValue: formatCurrency(topProducts[i]['revenue'] as num? ?? 0),
                          trailingColor: AppColors.success,
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      },
    );
  }
}

class _ReportNavGrid extends StatelessWidget {
  final bool isDark;
  const _ReportNavGrid({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem('Sales', Icons.receipt_long_rounded, AppColors.success, Routes.reportsSalesSummary),
      _NavItem('Products', Icons.inventory_2_rounded, AppColors.info, Routes.reportsProductPerformance),
      _NavItem('Categories', Icons.category_rounded, AppColors.warning, Routes.reportsCategoryBreakdown),
      _NavItem('Staff', Icons.badge_rounded, AppColors.purple, Routes.reportsStaffPerformance),
      _NavItem('Hourly', Icons.schedule_rounded, AppColors.primary, Routes.reportsHourlySales),
      _NavItem('Payments', Icons.payment_rounded, AppColors.successDark, Routes.reportsPaymentMethods),
      _NavItem('Inventory', Icons.warehouse_rounded, const Color(0xFF6366F1), Routes.reportsInventory),
      _NavItem('Financial', Icons.account_balance_rounded, AppColors.error, Routes.reportsFinancial),
      _NavItem('Customers', Icons.group_rounded, const Color(0xFFEC4899), Routes.reportsCustomers),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.3,
      children: items.map((item) {
        return Material(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: InkWell(
            onTap: () => context.go(item.route),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(item.icon, color: item.color, size: 22),
                  ),
                  const SizedBox(height: 8),
                  Text(item.label, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final Color color;
  final String route;
  const _NavItem(this.label, this.icon, this.color, this.route);
}
