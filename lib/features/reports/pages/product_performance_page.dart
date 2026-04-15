import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';

class ProductPerformancePage extends ConsumerStatefulWidget {
  const ProductPerformancePage({super.key});

  @override
  ConsumerState<ProductPerformancePage> createState() => _ProductPerformancePageState();
}

class _ProductPerformancePageState extends ConsumerState<ProductPerformancePage> {
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(productPerformanceProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productPerformanceProvider);

    return ReportPageScaffold(
      title: 'Product Performance',
      filterPanel: ReportFilterPanel(
        filters: _filters,
        onFiltersChanged: _onFiltersChanged,
        onRefresh: _loadData,
        showCategoryFilter: true,
        showSortOptions: true,
      ),
      body: switch (state) {
        ProductPerformanceInitial() || ProductPerformanceLoading() => PosLoadingSkeleton.list(),
        ProductPerformanceError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        ProductPerformanceLoaded(:final products) =>
          products.isEmpty
              ? const PosEmptyState(title: 'No product data for selected period', icon: Icons.inventory_2)
              : _ProductList(products: products),
      },
    );
  }
}

class _ProductList extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const _ProductList({required this.products});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalRevenue = products.fold<double>(0, (sum, p) => sum + (double.tryParse(p['total_revenue'].toString()) ?? 0.0));

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: 'Products',
              value: '${products.length}',
              icon: Icons.inventory_2_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: 'Total Revenue',
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: 'Total Qty Sold',
              value: formatCompact(products.fold<num>(0, (s, p) => s + (p['total_quantity'] as num))),
              icon: Icons.shopping_cart_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: 'Total Profit',
              value: formatCurrency(products.fold<double>(0, (s, p) => s + (double.tryParse(p['profit'].toString()) ?? 0.0))),
              icon: Icons.trending_up_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        // Bar Chart — Top 10 products by revenue
        if (products.isNotEmpty) ...[
          const SizedBox(height: 20),
          const ReportSectionHeader(title: 'Top Products by Revenue', icon: Icons.bar_chart_rounded),
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
        const ReportSectionHeader(title: 'Products Ranked by Revenue', icon: Icons.leaderboard_rounded),

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
                  if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ReportRankedItem(
                    rank: i + 1,
                    title: p['product_name'] as String? ?? '',
                    subtitle: p['sku'] as String?,
                    trailingValue: formatCurrency(revenue),
                    trailingSubtitle: '$qty sold',
                    trailingColor: AppColors.success,
                    badges: [
                      ReportBadge(
                        label: 'Profit ${formatCurrency(profit)}',
                        color: profit >= 0 ? AppColors.success : AppColors.error,
                      ),
                      ReportBadge(label: 'Cost ${formatCurrency(cost)}', color: AppColors.warning),
                      if (returns > 0) ReportBadge(label: '$returns returns', color: AppColors.error),
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
