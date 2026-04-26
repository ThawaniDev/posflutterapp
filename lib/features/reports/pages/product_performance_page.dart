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
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProductPerformancePage extends ConsumerStatefulWidget {
  const ProductPerformancePage({super.key});

  @override
  ConsumerState<ProductPerformancePage> createState() => _ProductPerformancePageState();
}

class _ProductPerformancePageState extends ConsumerState<ProductPerformancePage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCurrentTab());
  }

  void _loadCurrentTab() {
    switch (_currentTab) {
      case 0:
        ref.read(productPerformanceProvider.notifier).load(filters: _filters);
      case 1:
        ref.read(slowMoversProvider.notifier).load(filters: _filters);
      case 2:
        ref.read(productMarginProvider.notifier).load(filters: _filters);
      case 3:
        ref.read(categoryBreakdownProvider.notifier).load(filters: _filters);
    }
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadCurrentTab();
  }

  String get _exportType => const [
    'product_performance',
    'slow_movers',
    'product_margin',
    'category_breakdown',
  ][_currentTab];

  @override
  Widget build(BuildContext context) {
    return PermissionGuardPage(
      permission: Permissions.reportsSales,
      child: PosListPage(
        title: l10n.sidebarProductPerformance,
        showSearch: false,
        actions: [
          PosButton.icon(
            icon: Icons.download_rounded,
            tooltip: l10n.reportsExportFormatTitle,
            variant: PosButtonVariant.ghost,
            onPressed: () => showReportExportSheet(
              context: context,
              reportType: _exportType,
              filters: _filters,
            ),
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
                  PosTabItem(label: l10n.reportsBestSellers),
                  PosTabItem(label: l10n.reportsSlowMoversTab),
                  PosTabItem(label: l10n.reportsMarginAnalysis),
                  PosTabItem(label: l10n.reportsCategoryContribution),
                ],
              ),
            ),
            ReportFilterPanel(
              filters: _filters,
              onFiltersChanged: _onFiltersChanged,
              onRefresh: _loadCurrentTab,
              showCategoryFilter: true,
              showSortOptions: true,
            ),
            Expanded(
              child: IndexedStack(
                index: _currentTab,
                children: const [
                  _BestSellersTab(),
                  _SlowMoversTab(),
                  _MarginAnalysisTab(),
                  _CategoryContributionTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Best Sellers Tab ────────────────────────────────────────

class _BestSellersTab extends ConsumerWidget {
  const _BestSellersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(productPerformanceProvider);
    return switch (state) {
      ProductPerformanceInitial() || ProductPerformanceLoading() => PosLoadingSkeleton.list(),
      ProductPerformanceError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(productPerformanceProvider.notifier).load(),
      ),
      ProductPerformanceLoaded(:final products) => products.isEmpty
          ? PosEmptyState(title: l10n.reportsNoProductData, icon: Icons.inventory_2)
          : _ProductList(products: products),
    };
  }
}

// ─── Slow Movers Tab ─────────────────────────────────────────

class _SlowMoversTab extends ConsumerWidget {
  const _SlowMoversTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(slowMoversProvider);
    return switch (state) {
      SlowMoversInitial() || SlowMoversLoading() => PosLoadingSkeleton.list(),
      SlowMoversError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(slowMoversProvider.notifier).load(),
      ),
      SlowMoversLoaded(:final products) => products.isEmpty
          ? PosEmptyState(title: l10n.reportsNoSlowMovers, icon: Icons.hourglass_empty)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ReportKpiCard(
                  label: l10n.reportsSlowMoversCount(products.length),
                  value: '${products.length}',
                  icon: Icons.hourglass_bottom_rounded,
                  color: AppColors.warning,
                ),
                const SizedBox(height: 20),
                ReportSectionHeader(title: l10n.reportsSlowMoversTab, icon: Icons.trending_down_rounded),
                ReportDataCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: List.generate(products.length, (i) {
                      final p = products[i];
                      final qty = (p['quantity_sold'] as num?)?.toInt() ?? 0;
                      final days = (p['days_since_last_sale'] as num?)?.toInt() ?? 0;
                      final stock = (p['current_stock'] as num?)?.toInt() ?? 0;
                      return Column(
                        children: [
                          if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                          ReportRankedItem(
                            rank: i + 1,
                            title: p['product_name'] as String? ?? '',
                            subtitle: p['sku'] as String?,
                            trailingValue: l10n.reportNDays(days),
                            trailingColor: days > 30 ? AppColors.error : AppColors.warning,
                            badges: [
                              ReportBadge(label: l10n.reportNSold(qty.toString()), color: AppColors.info),
                              ReportBadge(label: l10n.reportNInStock(stock), color: AppColors.warning),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
    };
  }
}

// ─── Margin Analysis Tab ─────────────────────────────────────

class _MarginAnalysisTab extends ConsumerWidget {
  const _MarginAnalysisTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PermissionGuardPage(
      permission: Permissions.reportsViewMargin,
      child: _MarginAnalysisContent(l10n: l10n),
    );
  }
}

class _MarginAnalysisContent extends ConsumerWidget {
  const _MarginAnalysisContent({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productMarginProvider);
    return switch (state) {
      ProductMarginInitial() || ProductMarginLoading() => PosLoadingSkeleton.list(),
      ProductMarginError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(productMarginProvider.notifier).load(),
      ),
      ProductMarginLoaded(:final products) => products.isEmpty
          ? PosEmptyState(title: l10n.reportsNoMarginData, icon: Icons.percent)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ReportKpiGrid(
                  cards: [
                    ReportKpiCard(
                      label: l10n.reportsAvgMargin,
                      value: formatPercent(
                        products.isEmpty ? 0 : products.fold<double>(0, (s, p) => s + (double.tryParse(p['margin_percent'].toString()) ?? 0)) / products.length,
                      ),
                      icon: Icons.percent_rounded,
                      color: AppColors.primary,
                    ),
                    ReportKpiCard(
                      label: l10n.reportsTotalProfit,
                      value: formatCurrency(
                        products.fold<double>(0, (s, p) => s + (double.tryParse(p['total_profit'].toString()) ?? 0)),
                      ),
                      icon: Icons.trending_up_rounded,
                      color: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ReportSectionHeader(title: l10n.reportsMarginAnalysis, icon: Icons.analytics_rounded),
                ReportDataCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: List.generate(products.length, (i) {
                      final p = products[i];
                      final marginPct = double.tryParse(p['margin_percent'].toString()) ?? 0;
                      final revenue = double.tryParse(p['total_revenue'].toString()) ?? 0;
                      final profit = double.tryParse(p['total_profit'].toString()) ?? 0;
                      final marginColor = marginPct >= 30
                          ? AppColors.success
                          : marginPct >= 15
                          ? AppColors.warning
                          : AppColors.error;
                      return Column(
                        children: [
                          if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                          ReportRankedItem(
                            rank: i + 1,
                            title: p['product_name'] as String? ?? '',
                            subtitle: p['sku'] as String?,
                            trailingValue: formatPercent(marginPct),
                            trailingColor: marginColor,
                            badges: [
                              ReportBadge(label: formatCurrency(revenue), color: AppColors.primary),
                              ReportBadge(label: l10n.reportProfitAmount(formatCurrency(profit)), color: AppColors.success),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
    };
  }
}

// ─── Category Contribution Tab ───────────────────────────────

class _CategoryContributionTab extends ConsumerWidget {
  const _CategoryContributionTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(categoryBreakdownProvider);
    return switch (state) {
      CategoryBreakdownInitial() || CategoryBreakdownLoading() => PosLoadingSkeleton.list(),
      CategoryBreakdownError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(categoryBreakdownProvider.notifier).load(),
      ),
      CategoryBreakdownLoaded(:final categories) => categories.isEmpty
          ? PosEmptyState(title: l10n.reportsNoCategoryData, icon: Icons.category)
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                if (categories.isNotEmpty) ...[
                  ReportSectionHeader(title: l10n.reportsCategoryContribution, icon: Icons.donut_large_rounded),
                  ReportDataCard(
                    child: ReportPieChart(
                      data: categories,
                      labelKey: 'category_name',
                      valueKey: 'total_revenue',
                      donut: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                ReportSectionHeader(title: l10n.reportsCategories, icon: Icons.list_rounded),
                ReportDataCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: List.generate(categories.length, (i) {
                      final c = categories[i];
                      final revenue = double.tryParse(c['total_revenue'].toString()) ?? 0;
                      final qty = (c['quantity_sold'] as num?)?.toInt() ?? 0;
                      final totalRev = categories.fold<double>(0, (s, x) => s + (double.tryParse(x['total_revenue'].toString()) ?? 0));
                      final pct = totalRev > 0 ? revenue / totalRev * 100 : 0.0;
                      return Column(
                        children: [
                          if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                          ReportRankedItem(
                            rank: i + 1,
                            title: c['category_name'] as String? ?? '',
                            subtitle: l10n.reportNSold(qty.toString()),
                            trailingValue: formatCurrency(revenue),
                            trailingColor: AppColors.success,
                            badges: [ReportBadge(label: formatPercent(pct), color: AppColors.primary)],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
    };
  }
}

class _ProductList extends StatelessWidget {

  const _ProductList({required this.products});
  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final totalRevenue = products.fold<double>(0, (sum, p) => sum + (double.tryParse(p['total_revenue'].toString()) ?? 0.0));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: l10n.products,
              value: '${products.length}',
              icon: Icons.inventory_2_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: l10n.totalRevenue,
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: l10n.reportsTotalQtySold,
              value: formatCompact(products.fold<num>(0, (s, p) => s + (p['total_quantity'] as num))),
              icon: Icons.shopping_cart_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: l10n.reportsTotalProfit,
              value: formatCurrency(products.fold<double>(0, (s, p) => s + (double.tryParse(p['profit'].toString()) ?? 0.0))),
              icon: Icons.trending_up_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        // Bar Chart — Top 10 products by revenue
        if (products.isNotEmpty) ...[
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.reportsTopProductsByRevenue, icon: Icons.bar_chart_rounded),
          ReportDataCard(
            child: ReportBarChart(
              data: products.take(10).toList(),
              labelKey: 'product_name',
              valueKey: 'total_revenue',
              barColor: AppColors.primary,
              secondaryValueKey: 'profit',
              secondaryBarColor: AppColors.success,
            ),
          ),
        ],

        const SizedBox(height: 24),
        ReportSectionHeader(title: l10n.reportsProductsRankedByRevenue, icon: Icons.leaderboard_rounded),

        ReportDataCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(products.length, (i) {
              final p = products[i];
              final revenue = double.tryParse(p['total_revenue'].toString()) ?? 0.0;
              final qty = (p['total_quantity'] as num).toInt();
              final profit = double.tryParse(p['profit'].toString()) ?? 0.0;
              final cost = double.tryParse(p['total_cost'].toString()) ?? 0.0;
              final returns = (p['total_returns'] as num?)?.toInt() ?? 0;

              return Column(
                children: [
                  if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
                  ReportRankedItem(
                    rank: i + 1,
                    title: p['product_name'] as String? ?? '',
                    subtitle: p['sku'] as String?,
                    trailingValue: formatCurrency(revenue),
                    trailingSubtitle: l10n.reportNSold(qty.toString()),
                    trailingColor: AppColors.success,
                    badges: [
                      ReportBadge(
                        label: l10n.reportProfitAmount(formatCurrency(profit)),
                        color: profit >= 0 ? AppColors.success : AppColors.error,
                      ),
                      ReportBadge(label: l10n.reportCostAmount(formatCurrency(cost)), color: AppColors.warning),
                      if (returns > 0) ReportBadge(label: l10n.reportNReturns(returns.toString()), color: AppColors.error),
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
