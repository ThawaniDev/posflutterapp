import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class FinancialReportPage extends ConsumerStatefulWidget {
  const FinancialReportPage({super.key});

  @override
  ConsumerState<FinancialReportPage> createState() => _FinancialReportPageState();
}

class _FinancialReportPageState extends ConsumerState<FinancialReportPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentTab());
  }

  void _loadCurrentTab() {
    switch (_currentTab) {
      case 0:
        ref.read(financialDailyPlProvider.notifier).load(filters: _filters);
      case 1:
        ref.read(financialExpensesProvider.notifier).load(filters: _filters);
      case 2:
        ref.read(paymentMethodsProvider.notifier).load(filters: _filters);
      case 3:
        ref.read(deliveryCommissionProvider.notifier).load(filters: _filters);
      case 4:
        ref.read(cashVarianceProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadCurrentTab();
  }

  // null = payment_methods and cash_variance have no backend export type
  String? get _exportType =>
      const ['financial_pl', 'financial_expenses', null, 'financial_delivery_commission', null][_currentTab];

  @override
  Widget build(BuildContext context) {
    return PermissionGuardPage(
      permission: Permissions.reportsViewFinancial,
      child: PosListPage(
        title: l10n.reportsFinancial,
        showSearch: false,
        actions: [
          if (_exportType != null)
            PosButton.icon(
              icon: Icons.download_rounded,
              tooltip: l10n.reportsExportFormatTitle,
              variant: PosButtonVariant.ghost,
              onPressed: () => showReportExportSheet(context: context, reportType: _exportType!, filters: _filters),
            ),
        ],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: PosTabs(
                selectedIndex: _currentTab,
                onChanged: (i) => setState(() {
                  _currentTab = i;
                  _loadCurrentTab();
                }),
                tabs: [
                  PosTabItem(label: l10n.reportsDailyPl),
                  PosTabItem(label: l10n.expenses),
                  PosTabItem(label: l10n.paymentMethods),
                  PosTabItem(label: l10n.reportsDeliveryCommission),
                  PosTabItem(label: l10n.cashVariance),
                ],
              ),
            ),
            ReportFilterPanel(
              filters: _filters,
              onFiltersChanged: _onFiltersChanged,
              onRefresh: _loadCurrentTab,
              showGranularity: true,
              showStaffFilter: true,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: const [
                  _DailyPlTab(),
                  _ExpensesTab(),
                  _PaymentMethodSummaryTab(),
                  _DeliveryCommissionTab(),
                  _CashVarianceTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Daily P&L Tab ───────────────────────────────────────────

class _DailyPlTab extends ConsumerWidget {
  const _DailyPlTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(financialDailyPlProvider);

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
                  label: l10n.totalRevenue,
                  value: formatCurrency((totals['total_revenue'] as num?) ?? 0),
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: l10n.totalExpenses,
                  value: formatCurrency((totals['total_expenses'] as num?) ?? 0),
                  icon: Icons.trending_down_rounded,
                  color: AppColors.error,
                ),
                ReportKpiCard(
                  label: l10n.reportsNetProfit,
                  value: formatCurrency((totals['total_net_profit'] as num?) ?? 0),
                  icon: Icons.account_balance_rounded,
                  color: ((totals['total_net_profit'] as num?) ?? 0) >= 0 ? AppColors.success : AppColors.error,
                ),
              ],
            ),

            // P&L Area Chart
            if (daily.length > 1) ...[
              const SizedBox(height: 20),
              ReportSectionHeader(title: l10n.reportsPnlTrend, icon: Icons.area_chart_rounded),
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
            ReportSectionHeader(title: l10n.reportsDailyBreakdown, icon: Icons.calendar_today_rounded),
            if (daily.isEmpty)
              PosEmptyState(title: l10n.reportsNoDataForPeriod, icon: Icons.bar_chart)
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
                        ReportStatRow(label: l10n.reportsRevenue, value: formatCurrency(revenue), valueColor: AppColors.success),
                        ReportStatRow(label: l10n.reportsCogs, value: formatCurrency(cogs), valueColor: AppColors.warning),
                        ReportStatRow(label: l10n.expenses, value: formatCurrency(expenses), valueColor: AppColors.error),
                        Divider(height: 16, color: AppColors.borderFor(context)),
                        ReportStatRow(
                          label: l10n.reportsNetProfit,
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(financialExpensesProvider);

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
              label: l10n.totalExpenses,
              value: formatCurrency(totalExpenses),
              icon: Icons.receipt_long_rounded,
              color: AppColors.error,
            ),

            // Expense Category Pie
            if (categories.isNotEmpty) ...[
              const SizedBox(height: 20),
              ReportSectionHeader(title: l10n.reportsExpenseDistribution, icon: Icons.donut_large_rounded),
              ReportDataCard(
                child: ReportPieChart(data: categories, labelKey: 'category', valueKey: 'total_amount', donut: true),
              ),
            ],

            const SizedBox(height: 24),
            ReportSectionHeader(title: l10n.reportsByCategory, icon: Icons.category_rounded),
            if (categories.isEmpty)
              PosEmptyState(title: l10n.noExpensesRecorded, icon: Icons.receipt_long)
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
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.1),
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: const Icon(Icons.category_rounded, color: AppColors.warning, size: 18),
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
                                      l10n.reportNTransactions(txCount.toString()),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
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
    final l10n = AppLocalizations.of(context)!;
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
                  label: l10n.sidebarSessions,
                  value: '${data['sessions_count'] ?? 0}',
                  icon: Icons.point_of_sale_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: l10n.reportsTotalVariance,
                  value: formatCurrency((data['total_variance'] as num?) ?? 0),
                  icon: Icons.compare_arrows_rounded,
                  color: ((data['total_variance'] as num?) ?? 0) >= 0 ? AppColors.success : AppColors.error,
                ),
                ReportKpiCard(
                  label: l10n.reportsOverPlus,
                  value: '${data['positive_variance_count'] ?? 0}',
                  icon: Icons.arrow_upward_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: l10n.reportsShortMinus,
                  value: '${data['negative_variance_count'] ?? 0}',
                  icon: Icons.arrow_downward_rounded,
                  color: AppColors.error,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ReportSectionHeader(title: l10n.sidebarSessions, icon: Icons.list_rounded),
            if ((data['sessions'] as List?)?.isEmpty ?? true)
              PosEmptyState(title: l10n.reportsNoClosedSessions, icon: Icons.point_of_sale)
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
                      borderRadius: AppRadius.borderLg,
                      border: Border.all(color: color.withValues(alpha: 0.25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                              child: Icon(
                                isShort ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                                color: color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                l10n.reportOpenedAt(s['opened_at']?.toString() ?? ''),
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
                        ReportStatRow(label: l10n.reportsExpected, value: formatCurrency(expected)),
                        ReportStatRow(label: l10n.reportsActual, value: formatCurrency(actual)),
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

// ─── Delivery Commission Tab ─────────────────────────────────

class _DeliveryCommissionTab extends ConsumerWidget {
  const _DeliveryCommissionTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryCommissionProvider);

    return switch (state) {
      DeliveryCommissionInitial() || DeliveryCommissionLoading() => PosLoadingSkeleton.list(),
      DeliveryCommissionError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(deliveryCommissionProvider.notifier).load(),
      ),
      DeliveryCommissionLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(deliveryCommissionProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Summary KPIs
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: l10n.reportsDeliveryOrders,
                  value: '${(data['totals'] as Map?)?.cast<String, dynamic>()['total_orders'] ?? 0}',
                  icon: Icons.delivery_dining_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: l10n.reportsDeliveryGross,
                  value: formatCurrency((data['totals'] as Map?)?.cast<String, dynamic>()['total_gross'] ?? 0),
                  icon: Icons.attach_money_rounded,
                  color: AppColors.primary,
                ),
                ReportKpiCard(
                  label: l10n.reportsDeliveryFee,
                  value: formatCurrency((data['totals'] as Map?)?.cast<String, dynamic>()['total_commission'] ?? 0),
                  icon: Icons.percent_rounded,
                  color: AppColors.warning,
                ),
                ReportKpiCard(
                  label: l10n.reportsDeliveryNet,
                  value: formatCurrency((data['totals'] as Map?)?.cast<String, dynamic>()['total_net'] ?? 0),
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.success,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ReportSectionHeader(title: l10n.reportsDeliveryPlatform, icon: Icons.storefront_rounded),
            if ((data['platforms'] as List?)?.isEmpty ?? true)
              PosEmptyState(title: l10n.reportsNoDeliveryData, icon: Icons.delivery_dining)
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: List.generate((data['platforms'] as List).length, (i) {
                    final p = (data['platforms'] as List).cast<Map<String, dynamic>>()[i];
                    final gross = (p['gross_sales'] as num?)?.toDouble() ?? 0;
                    final commission = (p['total_commission'] as num?)?.toDouble() ?? 0;
                    final net = (p['net_settlement'] as num?)?.toDouble() ?? 0;
                    final rate = (p['commission_rate'] as num?)?.toDouble() ?? 0;
                    final orders = (p['order_count'] as num?)?.toInt() ?? 0;

                    return Column(
                      children: [
                        if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.1),
                                      borderRadius: AppRadius.borderMd,
                                    ),
                                    child: const Icon(Icons.delivery_dining_rounded, color: AppColors.primary, size: 18),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['platform'] as String? ?? '',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          l10n.reportNTransactions(orders.toString()),
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ReportBadge(label: formatPercent(rate), color: AppColors.warning),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ReportStatRow(label: l10n.reportsDeliveryGross, value: formatCurrency(gross)),
                              ReportStatRow(
                                label: l10n.reportsDeliveryFee,
                                value: '-${formatCurrency(commission)}',
                                valueColor: AppColors.error,
                              ),
                              ReportStatRow(
                                label: l10n.reportsDeliveryNet,
                                value: formatCurrency(net),
                                valueColor: AppColors.success,
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

// ─── Payment Method Summary Tab ──────────────────────────────

class _PaymentMethodSummaryTab extends ConsumerWidget {
  const _PaymentMethodSummaryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(paymentMethodsProvider);

    return switch (state) {
      PaymentMethodsInitial() || PaymentMethodsLoading() => PosLoadingSkeleton.list(),
      PaymentMethodsError(:final message) => ReportErrorBody(
        message: message,
        featureKey: 'reports_basic',
        featureName: l10n.paymentMethods,
        onRetry: () => ref.read(paymentMethodsProvider.notifier).load(),
      ),
      PaymentMethodsLoaded(:final methods) when methods.isEmpty => PosEmptyState(
        title: l10n.reportsNoPaymentData,
        icon: Icons.payment,
      ),
      PaymentMethodsLoaded(:final methods) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ReportSectionHeader(title: l10n.reportsBreakdownByMethod, icon: Icons.pie_chart_outline_rounded),
          if (methods.isNotEmpty) ...[
            const SizedBox(height: 12),
            ReportDataCard(
              child: ReportPieChart(data: methods, labelKey: 'method', valueKey: 'total_amount', donut: true),
            ),
            const SizedBox(height: 16),
          ],
          ...methods.map((m) {
            final method = m['method'] as String? ?? '';
            final amount = (m['total_amount'] as num?)?.toDouble() ?? 0;
            final txCount = (m['transaction_count'] as num?)?.toInt() ?? 0;
            final avg = (m['avg_amount'] as num?)?.toDouble() ?? 0;
            return ReportDataCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.payment_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(method, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        formatCurrency(amount),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ReportStatRow(label: l10n.transactions, value: '$txCount'),
                  ReportStatRow(label: l10n.reportsAvgPerTx, value: formatCurrency(avg)),
                ],
              ),
            );
          }),
        ],
      ),
    };
  }
}
