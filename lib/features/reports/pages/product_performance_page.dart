import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class ProductPerformancePage extends ConsumerStatefulWidget {
  const ProductPerformancePage({super.key});

  @override
  ConsumerState<ProductPerformancePage> createState() => _ProductPerformancePageState();
}

class _ProductPerformancePageState extends ConsumerState<ProductPerformancePage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(productPerformanceProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.end) : null,
        );
  }

  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productPerformanceProvider);

    return ReportPageScaffold(
      title: 'Product Performance',
      dateRange: _dateRange,
      onPickDate: _pickDateRange,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
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
    final totalRevenue = products.fold<double>(0, (sum, p) => sum + (p['total_revenue'] as num).toDouble());

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
              value: formatCurrency(products.fold<double>(0, (s, p) => s + (p['profit'] as num).toDouble())),
              icon: Icons.trending_up_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        const SizedBox(height: 24),
        const ReportSectionHeader(title: 'Products Ranked by Revenue', icon: Icons.leaderboard_rounded),

        ReportDataCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(products.length, (i) {
              final p = products[i];
              final revenue = (p['total_revenue'] as num).toDouble();
              final qty = (p['total_quantity'] as num).toInt();
              final profit = (p['profit'] as num).toDouble();
              final cost = (p['total_cost'] as num).toDouble();
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
