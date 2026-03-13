import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
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
        HourlySalesInitial() || HourlySalesLoading() => const Center(child: CircularProgressIndicator()),
        HourlySalesError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadData, child: const Text('Retry')),
            ],
          ),
        ),
        HourlySalesLoaded(:final hours) =>
          hours.isEmpty
              ? const Center(child: Text('No hourly data for selected period'))
              : ListView(
                  padding: const EdgeInsets.all(16),
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
                    const SizedBox(height: 8),

                    // Visual bar chart
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
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: barWidth.toDouble(),
                                      minHeight: 24,
                                      backgroundColor: Colors.grey.shade100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
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
                                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: Colors.grey.shade600),
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
