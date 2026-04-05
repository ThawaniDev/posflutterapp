import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

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

    return ReportPageScaffold(
      title: 'Staff Performance',
      dateRange: _dateRange,
      onPickDate: _pickDateRange,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
      body: switch (state) {
        StaffPerformanceInitial() || StaffPerformanceLoading() => PosLoadingSkeleton.list(),
        StaffPerformanceError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        StaffPerformanceLoaded(:final staff) =>
          staff.isEmpty ? const PosEmptyState(title: 'No staff performance data', icon: Icons.people) : _StaffList(staff: staff),
      },
    );
  }
}

class _StaffList extends StatelessWidget {
  final List<Map<String, dynamic>> staff;

  const _StaffList({required this.staff});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalRevenue = staff.fold<double>(0, (sum, s) => sum + (double.tryParse(s['total_revenue'].toString()) ?? 0.0));
    final totalOrders = staff.fold<int>(0, (sum, s) => sum + (s['total_orders'] as num).toInt());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(label: 'Staff Members', value: '${staff.length}', icon: Icons.people_rounded, color: AppColors.primary),
            ReportKpiCard(
              label: 'Total Revenue',
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: 'Total Orders',
              value: formatCompact(totalOrders),
              icon: Icons.receipt_long_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: 'Avg per Staff',
              value: staff.isNotEmpty ? formatCurrency(totalRevenue / staff.length) : '\u00810',
              icon: Icons.person_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        const SizedBox(height: 24),
        const ReportSectionHeader(title: 'Staff Ranked by Revenue', icon: Icons.leaderboard_rounded),

        ReportDataCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: List.generate(staff.length, (i) {
              final s = staff[i];
              final name = s['staff_name'] as String? ?? 'Unknown';
              final revenue = double.tryParse(s['total_revenue'].toString()) ?? 0.0;
              final orders = (s['total_orders'] as num).toInt();
              final avgOrder = double.tryParse(s['avg_order_value'].toString()) ?? 0.0;
              final discounts = double.tryParse(s['total_discounts_given'].toString()) ?? 0.0;
              final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

              return Column(
                children: [
                  if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: i < 3
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : (isDark ? AppColors.hoverDark : AppColors.backgroundLight),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: i < 3 ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (i < 3) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '#${i + 1}',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                  ],
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 6,
                                children: [
                                  ReportBadge(label: '$orders orders', color: AppColors.info),
                                  ReportBadge(label: 'Avg ${formatCurrency(avgOrder)}', color: AppColors.primary),
                                  if (discounts > 0)
                                    ReportBadge(label: '-${formatCurrency(discounts)}', color: AppColors.warning),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          formatCurrency(revenue),
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.success),
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
