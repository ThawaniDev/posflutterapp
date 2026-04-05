import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class CategoryBreakdownPage extends ConsumerStatefulWidget {
  const CategoryBreakdownPage({super.key});

  @override
  ConsumerState<CategoryBreakdownPage> createState() => _CategoryBreakdownPageState();
}

class _CategoryBreakdownPageState extends ConsumerState<CategoryBreakdownPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(categoryBreakdownProvider.notifier)
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
    final state = ref.watch(categoryBreakdownProvider);

    return ReportPageScaffold(
      title: 'Category Breakdown',
      dateRange: _dateRange,
      onPickDate: _pickDateRange,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
      body: switch (state) {
        CategoryBreakdownInitial() || CategoryBreakdownLoading() => PosLoadingSkeleton.list(),
        CategoryBreakdownError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        CategoryBreakdownLoaded(:final categories) =>
          categories.isEmpty
              ? const PosEmptyState(title: 'No category data for selected period', icon: Icons.category)
              : _CategoryList(categories: categories),
      },
    );
  }
}

class _CategoryList extends StatelessWidget {
  final List<Map<String, dynamic>> categories;

  const _CategoryList({required this.categories});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalRevenue = categories.fold<double>(0, (sum, c) => sum + (double.tryParse(c['total_revenue'].toString()) ?? 0.0));
    final maxRevenue = categories.isEmpty
        ? 1.0
        : categories.map((c) => double.tryParse(c['total_revenue'].toString()) ?? 0.0).reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: 'Categories',
              value: '${categories.length}',
              icon: Icons.category_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: 'Total Revenue',
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
          ],
        ),

        const SizedBox(height: 24),
        const ReportSectionHeader(title: 'Revenue by Category', icon: Icons.pie_chart_rounded),

        ReportDataCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(categories.length, (i) {
              final c = categories[i];
              final revenue = double.tryParse(c['total_revenue'].toString()) ?? 0.0;
              final pct = totalRevenue > 0 ? revenue / totalRevenue : 0.0;
              final profit = double.tryParse(c['profit'].toString()) ?? 0.0;
              final qty = (c['total_quantity'] as num).toInt();

              return Column(
                children: [
                  if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${i + 1}',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c['category_name'] as String? ?? '',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  if (c['category_name_ar'] != null)
                                    Text(
                                      c['category_name_ar'] as String,
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
                                  formatCurrency(revenue),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  formatPercent(pct * 100),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ReportBar(value: revenue, maxValue: maxRevenue, color: AppColors.primary),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: [
                            ReportBadge(label: '${c['product_count']} products', color: AppColors.info),
                            ReportBadge(label: '$qty sold', color: AppColors.primary),
                            ReportBadge(
                              label: 'Profit ${formatCurrency(profit)}',
                              color: profit >= 0 ? AppColors.success : AppColors.error,
                            ),
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
    );
  }
}
