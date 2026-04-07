import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/models/report_filters.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_charts.dart';
import 'package:thawani_pos/features/reports/widgets/report_filter_panel.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class CustomerReportPage extends ConsumerStatefulWidget {
  const CustomerReportPage({super.key});

  @override
  ConsumerState<CustomerReportPage> createState() => _CustomerReportPageState();
}

class _CustomerReportPageState extends ConsumerState<CustomerReportPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(topCustomersProvider.notifier).load(filters: _filters);
    });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) _onTabChanged(_tabController.index);
    });
  }

  void _onTabChanged(int index) {
    switch (index) {
      case 0:
        ref.read(topCustomersProvider.notifier).load(filters: _filters);
      case 1:
        ref.read(customerRetentionProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _onTabChanged(_tabController.index);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        title: Text(l10n.customerReportsTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.customerReportsTopCustomers),
            Tab(text: l10n.customerReportsRetention),
          ],
        ),
      ),
      body: Column(
        children: [
          ReportFilterPanel(
            filters: _filters,
            onFiltersChanged: _onFiltersChanged,
            onRefresh: () => _onTabChanged(_tabController.index),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: const [_TopCustomersTab(), _RetentionTab()]),
          ),
        ],
      ),
    );
  }
}

// ─── Top Customers Tab ───────────────────────────────────────

class _TopCustomersTab extends ConsumerWidget {
  const _TopCustomersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(topCustomersProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                children: const [PosEmptyState(title: 'No customer data', icon: Icons.people)],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ReportKpiGrid(
                    cards: [
                      ReportKpiCard(
                        label: 'Top Customers',
                        value: '${customers.length}',
                        icon: Icons.people_rounded,
                        color: AppColors.primary,
                      ),
                      ReportKpiCard(
                        label: 'Total Spend',
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
                    const ReportSectionHeader(title: 'Spend by Customer', icon: Icons.bar_chart_rounded),
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
                  const ReportSectionHeader(title: 'Ranked by Spend', icon: Icons.leaderboard_rounded),
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
                            if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ReportRankedItem(
                              rank: i + 1,
                              title: c['name'] as String? ?? '',
                              subtitle: '$visits visits · Avg ${formatCurrency(avgSpend)}',
                              trailingValue: formatCurrency(totalSpend),
                              trailingSubtitle: '$loyalty pts',
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
                  label: 'Total Customers',
                  value: '${data['total_customers'] ?? 0}',
                  icon: Icons.people_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: 'Repeat Rate',
                  value: formatPercent((data['repeat_rate'] as num?) ?? 0),
                  icon: Icons.repeat_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Repeat Customers',
                  value: '${data['repeat_customers'] ?? 0}',
                  icon: Icons.loyalty_rounded,
                  color: AppColors.purple,
                ),
                ReportKpiCard(
                  label: 'New (30d)',
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
                  label: 'Active (30d)',
                  value: '${data['active_customers_30d'] ?? 0}',
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Loyalty Points',
                  value: formatCompact((data['total_loyalty_points'] as num?) ?? 0),
                  icon: Icons.stars_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const ReportSectionHeader(title: 'Averages', icon: Icons.analytics_rounded),
            ReportDataCard(
              child: Column(
                children: [
                  ReportStatRow(label: 'Avg Visits', value: (data['avg_visits'] as num?)?.toStringAsFixed(1) ?? '0'),
                  ReportStatRow(label: 'Avg Spend', value: formatCurrency((data['avg_spend'] as num?) ?? 0)),
                  ReportStatRow(
                    label: 'Avg Loyalty Points',
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
