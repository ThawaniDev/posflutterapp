import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class SalesSummaryPage extends ConsumerStatefulWidget {
  const SalesSummaryPage({super.key});

  @override
  ConsumerState<SalesSummaryPage> createState() => _SalesSummaryPageState();
}

class _SalesSummaryPageState extends ConsumerState<SalesSummaryPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(salesSummaryProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesSummaryProvider);

    return PermissionGuardPage(
      permission: Permissions.reportsSales,
      child: ReportPageScaffold(
        title: l10n.sidebarSalesSummary,
        actions: [
          PosButton.icon(
            icon: Icons.download_rounded,
            tooltip: l10n.reportsExportFormatTitle,
            variant: PosButtonVariant.ghost,
            onPressed: () => showReportExportSheet(
              context: context,
              reportType: 'sales_summary',
              filters: _filters,
            ),
          ),
        ],
        filterPanel: ReportFilterPanel(
          filters: _filters,
          onFiltersChanged: _onFiltersChanged,
          onRefresh: _loadData,
          showStaffFilter: true,
          showPaymentMethodFilter: true,
          showAmountRange: true,
          showOrderStatus: true,
          showOrderSourceFilter: true,
          showGranularity: true,
          showCompare: true,
        ),
        body: switch (state) {
          SalesSummaryInitial() || SalesSummaryLoading() => PosLoadingSkeleton.list(),
          SalesSummaryError(:final message) => PosErrorState(message: message, onRetry: _loadData),
          SalesSummaryLoaded(:final totals, :final daily, :final previousPeriod) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ReportKpiGrid(
                cards: [
                  ReportKpiCard(
                    label: l10n.totalRevenue,
                    value: formatCurrency(totals['total_revenue'] as num),
                    icon: Icons.trending_up_rounded,
                    color: AppColors.success,
                  ),
                  ReportKpiCard(
                    label: l10n.netRevenue,
                    value: formatCurrency(totals['net_revenue'] as num),
                    icon: Icons.account_balance_wallet_rounded,
                    color: AppColors.primary,
                  ),
                  ReportKpiCard(
                    label: l10n.transactions,
                    value: '${totals['total_transactions']}',
                    icon: Icons.receipt_long_rounded,
                    color: AppColors.info,
                  ),
                  ReportKpiCard(
                    label: l10n.txStatsAvgBasket,
                    value: formatCurrency(totals['avg_basket_size'] as num),
                    icon: Icons.shopping_basket_rounded,
                    color: AppColors.warning,
                  ),
                ],
              ),

              // Period comparison section
              if (_filters.compare && previousPeriod != null) ...[
                const SizedBox(height: 20),
                _PreviousPeriodSection(current: totals, previous: previousPeriod, l10n: l10n),
              ],

              const SizedBox(height: 20),

              // Revenue Trend Chart
              if (daily.length > 1) ...[
                ReportSectionHeader(title: l10n.reportsRevenueTrend, icon: Icons.show_chart_rounded),
                ReportDataCard(
                  child: ReportLineChart(
                    data: daily,
                    xKey: 'period',
                    yKeys: const ['total_revenue', 'net_revenue'],
                    yLabels: [l10n.reportRevenue, l10n.netRevenue],
                    colors: [AppColors.primary, AppColors.success],
                    showArea: true,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              ReportSectionHeader(title: l10n.reportsBreakdown, icon: Icons.pie_chart_rounded),
              ReportDataCard(
                child: Column(
                  children: [
                    ReportStatRow(label: l10n.reportsCostOfGoods, value: formatCurrency(totals['total_cost'] as num)),
                    ReportStatRow(
                      label: l10n.discounts,
                      value: formatCurrency(totals['total_discount'] as num),
                      valueColor: AppColors.warning,
                    ),
                    ReportStatRow(label: l10n.reportsTaxCollected, value: formatCurrency(totals['total_tax'] as num)),
                    ReportStatRow(
                      label: l10n.posRefunds,
                      value: formatCurrency(totals['total_refunds'] as num),
                      valueColor: AppColors.error,
                    ),
                    const Divider(height: 24),
                    ReportStatRow(label: l10n.reportsCashRevenue, value: formatCurrency(totals['cash_revenue'] as num)),
                    ReportStatRow(label: l10n.reportsCardRevenue, value: formatCurrency(totals['card_revenue'] as num)),
                    ReportStatRow(label: l10n.reportsOtherRevenue, value: formatCurrency(totals['other_revenue'] as num)),
                    ReportStatRow(label: l10n.promotionsUniqueCustomers, value: '${totals['unique_customers']}'),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              ReportSectionHeader(title: l10n.reportsDailyBreakdown, icon: Icons.calendar_month_rounded),
              if (daily.isEmpty)
                ReportDataCard(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: Text(l10n.noDataForSelectedPeriod)),
                  ),
                )
              else
                ReportDataCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      for (int i = 0; i < daily.length; i++) ...[
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (daily[i]['period'] ?? daily[i]['date'] ?? '') as String,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      l10n.reportNOrders(daily[i]['total_transactions'].toString()),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppColors.mutedFor(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatCurrency(daily[i]['total_revenue'] as num),
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    l10n.reportNetPrefix(formatCurrency(daily[i]['net_revenue'] as num)),
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              const SizedBox(height: 20),
            ],
          ),
        },
      ),
    );
  }
}

// ─── Previous Period Comparison Section ──────────────────────

class _PreviousPeriodSection extends StatelessWidget {
  const _PreviousPeriodSection({
    required this.current,
    required this.previous,
    required this.l10n,
  });
  final Map<String, dynamic> current;
  final Map<String, dynamic> previous;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSectionHeader(title: l10n.reportsComparePeriod, icon: Icons.compare_arrows_rounded),
        ReportDataCard(
          child: Column(
            children: [
              ReportComparisonRow(
                label: l10n.totalRevenue,
                todayVal: (current['total_revenue'] as num? ?? 0).toDouble(),
                yesterdayVal: (previous['total_revenue'] as num? ?? 0).toDouble(),
              ),
              Divider(height: 1, color: AppColors.borderFor(context)),
              ReportComparisonRow(
                label: l10n.transactions,
                todayVal: (current['total_transactions'] as num? ?? 0).toDouble(),
                yesterdayVal: (previous['total_transactions'] as num? ?? 0).toDouble(),
              ),
              Divider(height: 1, color: AppColors.borderFor(context)),
              ReportComparisonRow(
                label: l10n.txStatsAvgBasket,
                todayVal: (current['avg_basket_size'] as num? ?? 0).toDouble(),
                yesterdayVal: (previous['avg_basket_size'] as num? ?? 0).toDouble(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
