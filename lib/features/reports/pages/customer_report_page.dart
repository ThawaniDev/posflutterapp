import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';

class CustomerReportPage extends ConsumerStatefulWidget {
  const CustomerReportPage({super.key});

  @override
  ConsumerState<CustomerReportPage> createState() => _CustomerReportPageState();
}

class _CustomerReportPageState extends ConsumerState<CustomerReportPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(topCustomersProvider.notifier).load(filters: _filters);
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        ref.read(topCustomersProvider.notifier).load(filters: _filters);
      case 1:
      case 2:
      case 3:
        ref.read(customerRetentionProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _onTabChanged(_currentTab);
  }

  // tabs 1-3 share retention data; only tab 0 (top customers) has an export type
  String? get _exportType => _currentTab == 0 ? 'top_customers' : null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PermissionGuardPage(
      permission: Permissions.reportsCustomers,
      child: PosListPage(
        title: l10n.customerReportsTitle,
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
                  _onTabChanged(i);
                }),
                tabs: [
                  PosTabItem(label: l10n.customerReportsTopCustomers),
                  PosTabItem(label: l10n.customerReportsRetention),
                  PosTabItem(label: l10n.customerReportsNewVsReturning),
                  PosTabItem(label: l10n.customerReportsLoyalty),
                ],
              ),
            ),
            ReportFilterPanel(
              filters: _filters,
              onFiltersChanged: _onFiltersChanged,
              onRefresh: () => _onTabChanged(_currentTab),
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: const [_TopCustomersTab(), _RetentionTab(), _NewVsReturningTab(), _LoyaltyTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Top Customers Tab ───────────────────────────────────────

class _TopCustomersTab extends ConsumerWidget {
  const _TopCustomersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(topCustomersProvider);

    return switch (state) {
      TopCustomersInitial() || TopCustomersLoading() => PosLoadingSkeleton.list(),
      TopCustomersError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(topCustomersProvider.notifier).load(),
      ),
      TopCustomersLoaded(:final customers) => RefreshIndicator(
        onRefresh: () => ref.read(topCustomersProvider.notifier).load(),
        child: customers.isEmpty
            ? ListView(
                children: [PosEmptyState(title: l10n.reportsNoCustomerData, icon: Icons.people)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ReportKpiGrid(
                    cards: [
                      ReportKpiCard(
                        label: l10n.reportsTopCustomers,
                        value: '${customers.length}',
                        icon: Icons.people_rounded,
                        color: AppColors.primary,
                      ),
                      ReportKpiCard(
                        label: l10n.reportsTotalSpend,
                        value: formatCurrency(
                          customers.fold<double>(0, (s, c) => s + (c['total_spend'] as num? ?? 0).toDouble()),
                        ),
                        icon: Icons.attach_money_rounded,
                        color: AppColors.success,
                      ),
                    ],
                  ),

                  // Bar Chart — Top customers by spend
                  if (customers.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    ReportSectionHeader(title: l10n.reportsSpendByCustomer, icon: Icons.bar_chart_rounded),
                    ReportDataCard(
                      child: ReportBarChart(
                        data: customers.take(10).toList(),
                        labelKey: 'name',
                        valueKey: 'total_spend',
                        barColor: AppColors.success,
                        horizontal: true,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  ReportSectionHeader(title: l10n.reportsRankedBySpend, icon: Icons.leaderboard_rounded),
                  ReportDataCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: List.generate(customers.length, (i) {
                        final c = customers[i];
                        final totalSpend = (c['total_spend'] != null ? double.tryParse(c['total_spend'].toString()) : null) ?? 0;
                        final visits = (c['visit_count'] as num?)?.toInt() ?? 0;
                        final avgSpend =
                            (c['avg_spend_per_visit'] != null ? double.tryParse(c['avg_spend_per_visit'].toString()) : null) ?? 0;
                        final loyalty = (c['loyalty_points'] as num?)?.toInt() ?? 0;

                        return Column(
                          children: [
                            if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                            ReportRankedItem(
                              rank: i + 1,
                              title: c['name'] as String? ?? '',
                              subtitle: l10n.reportNVisitsAvg(visits.toString(), formatCurrency(avgSpend)),
                              trailingValue: formatCurrency(totalSpend),
                              trailingSubtitle: l10n.reportNPts(loyalty.toString()),
                              trailingColor: AppColors.success,
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

// ─── Retention Tab ───────────────────────────────────────────

class _RetentionTab extends ConsumerWidget {
  const _RetentionTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerRetentionProvider);

    return switch (state) {
      CustomerRetentionInitial() || CustomerRetentionLoading() => PosLoadingSkeleton.list(),
      CustomerRetentionError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(customerRetentionProvider.notifier).load(),
      ),
      CustomerRetentionLoaded(:final data) => RefreshIndicator(
        onRefresh: () => ref.read(customerRetentionProvider.notifier).load(),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: l10n.reportsTotalCustomers,
                  value: '${data['total_customers'] ?? 0}',
                  icon: Icons.people_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: l10n.reportsRepeatRate,
                  value: formatPercent((data['repeat_rate'] as num?) ?? 0),
                  icon: Icons.repeat_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: l10n.reportsRepeatCustomers,
                  value: '${data['repeat_customers'] ?? 0}',
                  icon: Icons.loyalty_rounded,
                  color: AppColors.purple,
                ),
                ReportKpiCard(
                  label: l10n.reportsNew30d,
                  value: '${data['new_customers_30d'] ?? 0}',
                  icon: Icons.person_add_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: l10n.reportsActive30d,
                  value: '${data['active_customers_30d'] ?? 0}',
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: l10n.reportsLoyaltyPoints,
                  value: formatCompact((data['total_loyalty_points'] as num?) ?? 0),
                  icon: Icons.stars_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            ReportSectionHeader(title: l10n.reportsAverages, icon: Icons.analytics_rounded),
            ReportDataCard(
              child: Column(
                children: [
                  ReportStatRow(label: l10n.reportsAvgVisits, value: (data['avg_visits'] as num?)?.toStringAsFixed(1) ?? '0'),
                  ReportStatRow(label: l10n.reportsAvgSpend, value: formatCurrency((data['avg_spend'] as num?) ?? 0)),
                  ReportStatRow(
                    label: l10n.reportsAvgLoyaltyPoints,
                    value: '${(data['avg_loyalty_points'] as num?)?.toStringAsFixed(0) ?? '0'} pts',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    };
  }
}

// ─── New vs Returning Tab ────────────────────────────────────

class _NewVsReturningTab extends ConsumerWidget {
  const _NewVsReturningTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerRetentionProvider);

    return switch (state) {
      CustomerRetentionInitial() || CustomerRetentionLoading() => PosLoadingSkeleton.list(),
      CustomerRetentionError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(customerRetentionProvider.notifier).load(),
      ),
      CustomerRetentionLoaded(:final data) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ReportKpiGrid(
            cards: [
              ReportKpiCard(
                label: l10n.reportsNew30d,
                value: '${data['new_customers_30d'] ?? 0}',
                icon: Icons.person_add_rounded,
                color: AppColors.success,
              ),
              ReportKpiCard(
                label: l10n.reportsReturning30d,
                value: '${data['returning_customers_30d'] ?? data['active_customers_30d'] ?? 0}',
                icon: Icons.person_rounded,
                color: AppColors.info,
              ),
              ReportKpiCard(
                label: l10n.reportsRepeatCustomers,
                value: '${data['repeat_customers'] ?? 0}',
                icon: Icons.repeat_rounded,
                color: AppColors.purple,
              ),
              ReportKpiCard(
                label: l10n.reportsRepeatRate,
                value: formatPercent((data['repeat_rate'] as num?) ?? 0),
                icon: Icons.trending_up_rounded,
                color: AppColors.warning,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.customerReportsNewVsReturning, icon: Icons.pie_chart_rounded),
          ReportDataCard(
            child: ReportPieChart(
              data: [
                {'label': l10n.reportsNew30d, 'value': data['new_customers_30d'] ?? 0},
                {
                  'label': l10n.reportsReturning30d,
                  'value': data['returning_customers_30d'] ?? data['active_customers_30d'] ?? 0,
                },
              ],
              labelKey: 'label',
              valueKey: 'value',
              donut: false,
            ),
          ),
        ],
      ),
    };
  }
}

// ─── Loyalty Points Tab ──────────────────────────────────────

class _LoyaltyTab extends ConsumerWidget {
  const _LoyaltyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerRetentionProvider);

    return switch (state) {
      CustomerRetentionInitial() || CustomerRetentionLoading() => PosLoadingSkeleton.list(),
      CustomerRetentionError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(customerRetentionProvider.notifier).load(),
      ),
      CustomerRetentionLoaded(:final data) => ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ReportKpiGrid(
            cards: [
              ReportKpiCard(
                label: l10n.reportsLoyaltyBalance,
                value: formatCompact((data['total_loyalty_points'] as num?) ?? 0),
                icon: Icons.stars_rounded,
                color: AppColors.warning,
              ),
              ReportKpiCard(
                label: l10n.reportsLoyaltyRedeemed,
                value: formatCompact((data['loyalty_points_redeemed'] as num?) ?? 0),
                icon: Icons.redeem_rounded,
                color: AppColors.error,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.customerReportsLoyalty, icon: Icons.loyalty_rounded),
          ReportDataCard(
            child: Column(
              children: [
                ReportStatRow(
                  label: l10n.reportsLoyaltyBalance,
                  value: formatCompact((data['total_loyalty_points'] as num?) ?? 0),
                ),
                ReportStatRow(
                  label: l10n.reportsLoyaltyRedeemed,
                  value: formatCompact((data['loyalty_points_redeemed'] as num?) ?? 0),
                ),
                ReportStatRow(
                  label: l10n.reportsAvgLoyaltyPoints,
                  value: '${(data['avg_loyalty_points'] as num?)?.toStringAsFixed(0) ?? '0'} pts',
                ),
              ],
            ),
          ),
        ],
      ),
    };
  }
}
