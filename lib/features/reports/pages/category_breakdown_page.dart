import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Category Breakdown'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        CategoryBreakdownInitial() || CategoryBreakdownLoading() => PosLoadingSkeleton.list(),
        CategoryBreakdownError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        CategoryBreakdownLoaded(:final categories) =>
          categories.isEmpty
              ? const PosEmptyState(title: 'No category data for selected period', icon: Icons.category)
              : ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final c = categories[index];
                    final totalRevenue = categories.fold<double>(0, (sum, cat) => sum + (cat['total_revenue'] as num).toDouble());
                    final pct = totalRevenue > 0 ? (c['total_revenue'] as num) / totalRevenue : 0.0;

                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: BorderSide(color: theme.dividerColor),
                      ),
                      child: Padding(
                        padding: AppSpacing.paddingAll16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(c['category_name'] as String? ?? '', style: theme.textTheme.titleSmall),
                                      if (c['category_name_ar'] != null)
                                        Text(c['category_name_ar'] as String, style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${(c['total_revenue'] as num).toStringAsFixed(2)}',
                                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    Text('${(pct * 100).toStringAsFixed(1)}% of total', style: theme.textTheme.bodySmall),
                                  ],
                                ),
                              ],
                            ),
                            AppSpacing.gapH8,
                            ClipRRect(
                              borderRadius: BorderRadius.circular(AppRadius.xs),
                              child: LinearProgressIndicator(
                                value: pct.toDouble(),
                                backgroundColor: AppColors.primary5,
                                color: AppColors.primary,
                              ),
                            ),
                            AppSpacing.gapH8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${c['product_count']} products', style: theme.textTheme.bodySmall),
                                Text('Qty: ${(c['total_quantity'] as num).toStringAsFixed(0)}', style: theme.textTheme.bodySmall),
                                Text(
                                  'Profit: \$${(c['profit'] as num).toStringAsFixed(2)}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: (c['profit'] as num) >= 0 ? AppColors.success : AppColors.error,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      },
    );
  }
}
