import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
      _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) => _loadData());
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _loadData() {
    ref.read(dashboardProvider.notifier).load();
    ref.read(hourlySalesProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    ref.read(hourlySalesProvider.notifier).load(filters: _filters);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PermissionGuardPage(
      permission: Permissions.reportsView,
      child: PosListPage(
        title: l10n.featureInfoReportsTitle,
        showSearch: false,
        actions: [
          PosButton.icon(
            icon: Icons.info_outline,
            tooltip: l10n.featureInfoTooltip,
            onPressed: () => showReportsDashboardInfo(context),
            variant: PosButtonVariant.ghost,
          ),
          PosButton.icon(
            icon: Icons.refresh_rounded,
            tooltip: l10n.commonRefresh,
            onPressed: _loadData,
            variant: PosButtonVariant.ghost,
          ),
        ],
        child: Column(
          children: [
            ReportFilterPanel(filters: _filters, onFiltersChanged: _onFiltersChanged, onRefresh: _loadData),
            Expanded(
              child: switch (state) {
                DashboardInitial() || DashboardLoading() => PosLoadingSkeleton.list(),
                DashboardError(:final message) => PosErrorState(message: message, onRetry: _loadData),
                DashboardLoaded(:final today, :final yesterday, :final topProducts) => RefreshIndicator(
                  onRefresh: () async => _loadData(),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _ReportNavGrid(isDark: isDark),
                      const SizedBox(height: 28),

                    ReportSectionHeader(title: l10n.reportsTodaysOverview, icon: Icons.today_rounded),
                    ReportKpiGrid(
                      cards: [
                        ReportKpiCard(
                          label: l10n.reportsRevenue,
                          value: formatCurrency(today['total_revenue'] as num? ?? 0),
                          icon: Icons.trending_up_rounded,
                          color: AppColors.success,
                        ),
                        ReportKpiCard(
                          label: l10n.transactions,
                          value: '${today['total_transactions'] ?? 0}',
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.info,
                        ),
                        ReportKpiCard(
                          label: l10n.netRevenue,
                          value: formatCurrency(today['net_revenue'] as num? ?? 0),
                          icon: Icons.account_balance_wallet_rounded,
                          color: AppColors.primary,
                        ),
                        ReportKpiCard(
                          label: l10n.txStatsAvgBasket,
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
                            label: l10n.customers,
                            value: '${today['unique_customers'] ?? 0}',
                            icon: Icons.people_rounded,
                            color: AppColors.purple,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ReportKpiCard(
                            label: l10n.posRefunds,
                            value: formatCurrency(today['total_refunds'] as num? ?? 0),
                            icon: Icons.undo_rounded,
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Hourly Sales Mini Chart
                    _HourlySalesMiniChart(),

                    ReportSectionHeader(title: l10n.reportsVsYesterday, icon: Icons.compare_arrows_rounded),
                    ReportDataCard(
                      child: Column(
                        children: [
                          ReportComparisonRow(
                            label: l10n.reportsRevenue,
                            todayVal: (today['total_revenue'] as num? ?? 0).toDouble(),
                            yesterdayVal: (yesterday['total_revenue'] as num? ?? 0).toDouble(),
                          ),
                          Divider(color: AppColors.borderFor(context)),
                          ReportComparisonRow(
                            label: l10n.transactions,
                            todayVal: (today['total_transactions'] as num? ?? 0).toDouble(),
                            yesterdayVal: (yesterday['total_transactions'] as num? ?? 0).toDouble(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    ReportSectionHeader(title: l10n.reportsTopProductsToday, icon: Icons.star_rounded),
                    if (topProducts.isEmpty)
                      ReportDataCard(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Center(child: Text(l10n.noSalesDataYetToday)),
                        ),
                      )
                    else ...[
                      // Mini bar chart for top products
                      ReportDataCard(
                        child: ReportBarChart(
                          data: topProducts.take(5).toList(),
                          labelKey: 'product_name',
                          valueKey: 'revenue',
                          barColor: AppColors.success,
                          height: 180,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ReportDataCard(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            for (int i = 0; i < topProducts.length; i++) ...[
                              if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                              ReportRankedItem(
                                rank: i + 1,
                                title: topProducts[i]['product_name'] as String? ?? '',
                                subtitle: l10n.reportQtyPrefix((topProducts[i]['quantity_sold'] as num? ?? 0).toStringAsFixed(0)),
                                trailingValue: formatCurrency(topProducts[i]['revenue'] as num? ?? 0),
                                trailingColor: AppColors.success,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            },
          ),
        ],
      ),
      ),
    );
  }
}

class _HourlySalesMiniChart extends ConsumerWidget {
  const _HourlySalesMiniChart();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(hourlySalesProvider);
    if (state case HourlySalesLoaded(:final hours) when hours.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReportSectionHeader(title: l10n.sidebarHourlySales, icon: Icons.schedule_rounded),
          ReportDataCard(
            child: ReportBarChart(
              data: hours,
              labelKey: 'hour_label',
              valueKey: 'revenue',
              barColor: AppColors.info,
              height: 160,
            ),
          ),
          const SizedBox(height: 28),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

class _ReportNavGrid extends StatelessWidget {
  const _ReportNavGrid({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _NavItem(l10n.reportNavSales, Icons.receipt_long_rounded, AppColors.success, Routes.reportsSalesSummary),
      _NavItem(l10n.reportNavProducts, Icons.inventory_2_rounded, AppColors.info, Routes.reportsProductPerformance),
      _NavItem(l10n.reportNavCategories, Icons.category_rounded, AppColors.warning, Routes.reportsCategoryBreakdown),
      _NavItem(l10n.reportNavStaff, Icons.badge_rounded, AppColors.purple, Routes.reportsStaffPerformance),
      _NavItem(l10n.reportNavHourly, Icons.schedule_rounded, AppColors.primary, Routes.reportsHourlySales),
      _NavItem(l10n.reportNavPayments, Icons.payment_rounded, AppColors.successDark, Routes.reportsPaymentMethods),
      _NavItem(l10n.reportNavInventory, Icons.warehouse_rounded, const Color(0xFF6366F1), Routes.reportsInventory),
      _NavItem(l10n.reportNavFinancial, Icons.account_balance_rounded, AppColors.error, Routes.reportsFinancial),
      _NavItem(l10n.reportNavCustomers, Icons.group_rounded, const Color(0xFFEC4899), Routes.reportsCustomers),
      _NavItem(l10n.reportsScheduledTitle, Icons.calendar_today_rounded, AppColors.primary, Routes.reportsScheduled),
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
          borderRadius: AppRadius.borderLg,
          child: InkWell(
            onTap: () => context.go(item.route),
            borderRadius: AppRadius.borderLg,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.borderFor(context)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: item.color.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
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
  const _NavItem(this.label, this.icon, this.color, this.route);
  final String label;
  final IconData icon;
  final Color color;
  final String route;
}
