import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';

class HourlySalesPage extends ConsumerStatefulWidget {
  const HourlySalesPage({super.key});

  @override
  ConsumerState<HourlySalesPage> createState() => _HourlySalesPageState();
}

class _HourlySalesPageState extends ConsumerState<HourlySalesPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(hourlySalesProvider.notifier)
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

  String _formatHour(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final suffix = hour < 12 ? 'AM' : 'PM';
    return '$h $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hourlySalesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hourly Sales'),
        actions: [
          IconButton(icon: const Icon(Icons.date_range), onPressed: _pickDateRange),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: switch (state) {
        HourlySalesInitial() || HourlySalesLoading() => PosLoadingSkeleton.list(),
        HourlySalesError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        HourlySalesLoaded(:final hours) =>
          hours.isEmpty
              ? const PosEmptyState(title: 'No hourly data for selected period', icon: Icons.access_time)
              : ListView(
                  padding: AppSpacing.paddingAll16,
                  children: [
                    if (_dateRange != null)
                      Chip(
                        label: Text(
                          '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_dateRange!.end)}',
                        ),
                        onDeleted: () {
                          setState(() => _dateRange = null);
                          _loadData();
                        },
                      ),
                    AppSpacing.gapH8,

                    ...hours.map((h) {
                      final maxRevenue = hours.fold<double>(0, (max, item) {
                        final rev = (item['total_revenue'] as num).toDouble();
                        return rev > max ? rev : max;
                      });
                      final revenue = (h['total_revenue'] as num).toDouble();
                      final barWidth = maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 56,
                              child: Text(
                                _formatHour(h['hour'] as int),
                                style: theme.textTheme.bodySmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            AppSpacing.gapW8,
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(AppRadius.xs),
                                child: LinearProgressIndicator(
                                  value: barWidth.toDouble(),
                                  minHeight: 24,
                                  backgroundColor: AppColors.primary5,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            AppSpacing.gapW8,
                            SizedBox(
                              width: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${revenue.toStringAsFixed(0)}',
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${h['total_orders']} orders',
                                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
      },
    );
  }
}
