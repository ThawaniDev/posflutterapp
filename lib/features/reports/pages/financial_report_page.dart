import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/models/report_filters.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_charts.dart';
import 'package:thawani_pos/features/reports/widgets/report_filter_panel.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class FinancialReportPage extends ConsumerStatefulWidget {
  const FinancialReportPage({super.key});

  @override
  ConsumerState<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends ConsumerState<FinancialReportPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentTab());
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _loadCurrentTab();
    });
  }

  void _loadCurrentTab() {
    switch (_tabController.index) {
      case 0:
        ref.read(financialDailyPlProvider.notifier).load(filters: _filters);
      case 1:
        ref.read(financialExpensesProvider.notifier).load(filters: _filters);
      case 2:
        ref.read(cashVarianceProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadCurrentTab();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: const Text('Financial Reports'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Daily P&L'),
            Tab(text: 'Expenses'),
            Tab(text: 'Cash Variance'),
          ],
        ),
      ),
      body: Column(
        children: [
          ReportFilterPanel(
            filters: _filters,
            onFiltersChanged: _onFiltersChanged,
            onRefresh: _loadCurrentTab,
            showGranularity: true,
            showStaffFilter: true,
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: const [_DailyPlTab(), _ExpensesTab(), _CashVarianceTab()]),
          ),
        ],
      ),
    );
  }
}

// ─── Daily P&L Tab ───────────────────────────────────────────

class _DailyPlTab extends ConsumerWidget {
  const _DailyPlTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financialDailyPlProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      FinancialDailyPlInitial() || FinancialDailyPlLoading() => PosLoadingSkeleton.list(),
      FinancialDailyPlError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(financialDailyPlProvider.notifier).load(),
      ),
      FinancialDailyPlLoaded(:final totals, :final daily) => RefreshIndicator(
        onRefresh: () => ref.read(financialDailyPlProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: 'Total Revenue',
                  value: formatCurrency((totals['total_revenue'] as num?) ?? 0),
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Total Expenses',
                  value: formatCurrency((totals['total_expenses'] as num?) ?? 0),
                  icon: Icons.trending_down_rounded,
                  color: AppColors.error,
                ),
                ReportKpiCard(
                  label: 'Net Profit',
                  value: formatCurrency((totals['total_net_profit'] as num?) ?? 0),
                  icon: Icons.account_balance_rounded,
                  color: ((totals['total_net_profit'] as num?) ?? 0) >= 0 ? AppColors.success : AppColors.error,
                ),
              ],
            ),

            // P&L Area Chart
            if (daily.length > 1) ...[
              const SizedBox(height: 20),
              const ReportSectionHeader(title: 'P&L Trend', icon: Icons.area_chart_rounded),
              ReportDataCard(
                child: ReportAreaChart(
                  data: daily,
                  xKey: 'date',
                  revenueKey: 'revenue',
                  costKey: 'cost_of_goods',
                  profitKey: 'net_profit',
                ),
              ),
            ],

            const SizedBox(height: 24),
            const ReportSectionHeader(title: 'Daily Breakdown', icon: Icons.calendar_today_rounded),
            if (daily.isEmpty)
              const PosEmptyState(title: 'No data for period', icon: Icons.bar_chart)
            else
              ...daily.map((d) {
                final revenue = (d['revenue'] != null ? double.tryParse(d['revenue'].toString()) : null) ?? 0;
                final cogs = (d['cost_of_goods'] != null ? double.tryParse(d['cost_of_goods'].toString()) : null) ?? 0;
                final expenses = (d['expenses'] != null ? double.tryParse(d['expenses'].toString()) : null) ?? 0;
                final netProfit = (d['net_profit'] != null ? double.tryParse(d['net_profit'].toString()) : null) ?? 0;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ReportDataCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          d['date'] as String? ?? '',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        ReportStatRow(label: 'Revenue', value: formatCurrency(revenue), valueColor: AppColors.success),
                        ReportStatRow(label: 'COGS', value: formatCurrency(cogs), valueColor: AppColors.warning),
                        ReportStatRow(label: 'Expenses', value: formatCurrency(expenses), valueColor: AppColors.error),
                        Divider(height: 16, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ReportStatRow(
                          label: 'Net Profit',
                          value: formatCurrency(netProfit),
                          valueColor: netProfit >= 0 ? AppColors.success : AppColors.error,
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    };
  }
}

// ─── Expenses Tab ────────────────────────────────────────────

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(financialExpensesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return switch (state) {
      FinancialExpensesInitial() || FinancialExpensesLoading() => PosLoadingSkeleton.list(),
      FinancialExpensesError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(financialExpensesProvider.notifier).load(),
      ),
      FinancialExpensesLoaded(:final totalExpenses, :final categories) => RefreshIndicator(
        onRefresh: () => ref.read(financialExpensesProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiCard(
              label: 'Total Expenses',
              value: formatCurrency(totalExpenses),
              icon: Icons.receipt_long_rounded,
              color: AppColors.error,
            ),

            // Expense Category Pie
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 20),
              const ReportSectionHeader(title: 'Expense Distribution', icon: Icons.donut_large_rounded),
              ReportDataCard(
                child: ReportPieChart(data: categories, labelKey: 'category', valueKey: 'total_amount', donut: true),
              ),
            ],

            const SizedBox(height: 24),
            const ReportSectionHeader(title: 'By Category', icon: Icons.category_rounded),
            if (categories.isEmpty)
              const PosEmptyState(title: 'No expenses recorded', icon: Icons.receipt_long)
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate(categories.length, (i) {
                    final c = categories[i];
                    final amount = (c['total_amount'] != null ? double.tryParse(c['total_amount'].toString()) : null) ?? 0;
                    final pct = totalExpenses > 0 ? amount / totalExpenses * 100 : 0.0;
                    final txCount = c['expense_count'] ?? 0;

                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.category_rounded, color: AppColors.warning, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (c['category'] as String? ?? '').replaceAll('_', ' ').toUpperCase(),
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '$txCount transactions',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatCurrency(amount),
                                    style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  ReportBadge(label: formatPercent(pct), color: AppColors.warning),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
          ],
        ),
      ),
    };
  }
}

// ─── Cash Variance Tab ───────────────────────────────────────

class _CashVarianceTab extends ConsumerWidget {
  const _CashVarianceTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cashVarianceProvider);

    return switch (state) {
      CashVarianceInitial() || CashVarianceLoading() => PosLoadingSkeleton.list(),
      CashVarianceError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(cashVarianceProvider.notifier).load(),
      ),
      CashVarianceLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(cashVarianceProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: 'Sessions',
                  value: '${data['sessions_count'] ?? 0}',
                  icon: Icons.point_of_sale_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: 'Total Variance',
                  value: formatCurrency((data['total_variance'] as num?) ?? 0),
                  icon: Icons.compare_arrows_rounded,
                  color: ((data['total_variance'] as num?) ?? 0) >= 0 ? AppColors.success : AppColors.error,
                ),
                ReportKpiCard(
                  label: 'Over (+)',
                  value: '${data['positive_variance_count'] ?? 0}',
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Short (-)',
                  value: '${data['negative_variance_count'] ?? 0}',
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ReportSectionHeader(title: 'Sessions', icon: Icons.list_rounded),
            if ((data['sessions'] as List?)?.isEmpty ?? true)
              const PosEmptyState(title: 'No closed sessions', icon: Icons.point_of_sale)
            else
              ...((data['sessions'] as List).cast<Map<String, dynamic>>()).map((s) {
                final variance = (s['variance'] != null ? double.tryParse(s['variance'].toString()) : null) ?? 0;
                final expected = (s['expected_cash'] != null ? double.tryParse(s['expected_cash'].toString()) : null) ?? 0;
                final actual = (s['actual_cash'] != null ? double.tryParse(s['actual_cash'].toString()) : null) ?? 0;
                final isShort = variance < 0;
                final color = isShort ? AppColors.error : AppColors.success;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: color.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: color.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isShort ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Opened: ${s['opened_at'] ?? ''}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              '${isShort ? '' : '+'}${formatCurrency(variance)}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ReportStatRow(label: 'Expected', value: formatCurrency(expected)),
                        ReportStatRow(label: 'Actual', value: formatCurrency(actual)),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    };
  }
}
