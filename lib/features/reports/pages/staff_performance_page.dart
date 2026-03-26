import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class StaffPerformancePage extends ConsumerStatefulWidget {
  const StaffPerformancePage({super.key});

  @override
  ConsumerState<StaffPerformancePage> createState() => _StaffPerformancePageState();
}

class _StaffPerformancePageState extends ConsumerState<StaffPerformancePage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(staffPerformanceProvider.notifier)
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
    final state = ref.watch(staffPerformanceProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Performance'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        StaffPerformanceInitial() || StaffPerformanceLoading() => PosLoadingSkeleton.list(),
        StaffPerformanceError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        StaffPerformanceLoaded(:final staff) =>
          staff.isEmpty
              ? const PosEmptyState(title: 'No staff performance data', icon: Icons.people)
              : ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: staff.length,
                  itemBuilder: (context, index) {
                    final s = staff[index];
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
                                CircleAvatar(
                                  backgroundColor: AppColors.primary10,
                                  foregroundColor: AppColors.primary,
                                  child: Text((s['staff_name'] as String? ?? 'U').substring(0, 1).toUpperCase()),
                                ),
                                AppSpacing.gapW12,
                                Expanded(child: Text(s['staff_name'] as String? ?? '', style: theme.textTheme.titleSmall)),
                                Text(
                                  '\$${(s['total_revenue'] as num).toStringAsFixed(2)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH12,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _StatCol(label: 'Orders', value: '${s['total_orders']}'),
                                _StatCol(label: 'Avg Order', value: '\$${(s['avg_order_value'] as num).toStringAsFixed(2)}'),
                                _StatCol(
                                  label: 'Discounts',
                                  value: '\$${(s['total_discounts_given'] as num).toStringAsFixed(2)}',
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

class _StatCol extends StatelessWidget {
  final String label;
  final String value;

  const _StatCol({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}
