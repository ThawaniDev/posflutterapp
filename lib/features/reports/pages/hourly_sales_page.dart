import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

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

  Future<void> _pickDate() async {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ReportPageScaffold(
      title: 'Hourly Sales',
      dateRange: _dateRange,
      onPickDate: _pickDate,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
      body: switch (state) {
        HourlySalesInitial() || HourlySalesLoading() => PosLoadingSkeleton.list(),
        HourlySalesError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        HourlySalesLoaded(:final hours) =>
          hours.isEmpty
              ? const Center(
                  child: PosEmptyState(title: 'No hourly data for selected period', icon: Icons.schedule),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Peak hour highlight
                    if (hours.isNotEmpty) ...[
                      Builder(
                        builder: (context) {
                          final peak = hours.reduce((a, b) => (a['total_revenue'] as num) > (b['total_revenue'] as num) ? a : b);
                          final totalRevenue = hours.fold<double>(0, (sum, h) => sum + (h['total_revenue'] as num).toDouble());
                          final totalOrders = hours.fold<int>(0, (sum, h) => sum + (h['total_orders'] as int? ?? 0));
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: ReportKpiCard(
                                      label: 'Peak Hour',
                                      value: _formatHour(peak['hour'] as int),
                                      icon: Icons.whatshot_rounded,
                                      color: AppColors.warning,
                                      subtitle: formatCurrency(peak['total_revenue'] as num),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ReportKpiCard(
                                      label: 'Total Revenue',
                                      value: formatCurrency(totalRevenue),
                                      icon: Icons.trending_up_rounded,
                                      color: AppColors.success,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ReportKpiCard(
                                      label: 'Total Orders',
                                      value: '$totalOrders',
                                      icon: Icons.receipt_long_rounded,
                                      color: AppColors.info,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                            ],
                          );
                        },
                      ),
                    ],

                    const ReportSectionHeader(title: 'Revenue by Hour', icon: Icons.bar_chart_rounded),
                    ReportDataCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (int i = 0; i < hours.length; i++) ...[
                            if (i > 0) const SizedBox(height: 8),
                            _HourRow(
                              hour: _formatHour(hours[i]['hour'] as int),
                              revenue: (hours[i]['total_revenue'] as num).toDouble(),
                              orders: hours[i]['total_orders'] as int? ?? 0,
                              maxRevenue: hours.fold<double>(0, (max, h) {
                                final r = (h['total_revenue'] as num).toDouble();
                                return r > max ? r : max;
                              }),
                              isDark: isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
      },
    );
  }
}

class _HourRow extends StatelessWidget {
  final String hour;
  final double revenue;
  final int orders;
  final double maxRevenue;
  final bool isDark;

  const _HourRow({
    required this.hour,
    required this.revenue,
    required this.orders,
    required this.maxRevenue,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 52,
          child: Text(
            hour,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ReportBar(value: revenue, maxValue: maxRevenue, color: AppColors.primary, height: 24),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatCurrency(revenue), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                '$orders orders',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
