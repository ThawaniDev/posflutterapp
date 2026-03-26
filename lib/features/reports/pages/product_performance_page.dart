import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Performance'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        ProductPerformanceInitial() || ProductPerformanceLoading() => PosLoadingSkeleton.list(),
        ProductPerformanceError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        ProductPerformanceLoaded(:final products) =>
          products.isEmpty
              ? const PosEmptyState(title: 'No product data for selected period', icon: Icons.inventory_2)
              : ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final p = products[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        side: BorderSide(color: theme.dividerColor),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppColors.primary10,
                                  foregroundColor: AppColors.primary,
                                  child: Text('${index + 1}'),
                                ),
                                AppSpacing.gapW12,
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p['product_name'] as String? ?? '', style: theme.textTheme.titleSmall),
                                      Text('SKU: ${p['sku'] ?? '-'}', style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '\$${(p['total_revenue'] as num).toStringAsFixed(2)}',
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.success,
                                      ),
                                    ),
                                    Text(
                                      'Qty: ${(p['total_quantity'] as num).toStringAsFixed(1)}',
                                      style: theme.textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            AppSpacing.gapH8,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _MetricChip(
                                  label: 'Profit',
                                  value: '\$${(p['profit'] as num).toStringAsFixed(2)}',
                                  color: (p['profit'] as num) >= 0 ? AppColors.success : AppColors.error,
                                ),
                                _MetricChip(
                                  label: 'Cost',
                                  value: '\$${(p['total_cost'] as num).toStringAsFixed(2)}',
                                  color: AppColors.textSecondary,
                                ),
                                _MetricChip(
                                  label: 'Returns',
                                  value: '${(p['total_returns'] as num).toStringAsFixed(0)}',
                                  color: (p['total_returns'] as num) > 0 ? AppColors.warning : AppColors.textSecondary,
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

class _MetricChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.2),
        child: Icon(Icons.circle, size: 8, color: color),
      ),
      label: Text('$label: $value'),
    );
  }
}
