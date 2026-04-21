import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class HourlySalesPage extends ConsumerStatefulWidget {
  const HourlySalesPage({super.key});

  @override
  ConsumerState<HourlySalesPage> createState() => _HourlySalesPageState();
}

class _HourlySalesPageState extends ConsumerState<HourlySalesPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(hourlySalesProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
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
      title: l10n.sidebarHourlySales,
      filterPanel: ReportFilterPanel(
        filters: _filters,
        onFiltersChanged: _onFiltersChanged,
        onRefresh: _loadData,
        showStaffFilter: true,
        showPaymentMethodFilter: true,
        showOrderStatus: true,
      ),
      body: switch (state) {
        HourlySalesInitial() || HourlySalesLoading() => PosLoadingSkeleton.list(),
        HourlySalesError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        HourlySalesLoaded(:final hours) =>
          hours.isEmpty
              ? Center(
                  child: PosEmptyState(title: l10n.reportsNoHourlyData, icon: Icons.schedule),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Peak hour highlight + KPIs
                    if (hours.isNotEmpty) ...[
                      Builder(
                        builder: (context) {
                          final peak = hours.reduce((a, b) => (a['total_revenue'] as num) > (b['total_revenue'] as num) ? a : b);
                          final totalRevenue = hours.fold<double>(
                            0,
                            (sum, h) => sum + (double.tryParse(h['total_revenue'].toString()) ?? 0.0),
                          );
                          final totalOrders = hours.fold<int>(0, (sum, h) => sum + (h['total_orders'] as int? ?? 0));
                          return Column(
                            children: [
                              context.isPhone
                                  ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ReportKpiCard(
                                                label: l10n.reportsPeakHour,
                                                value: _formatHour(peak['hour'] as int),
                                                icon: Icons.whatshot_rounded,
                                                color: AppColors.warning,
                                                subtitle: formatCurrency(peak['total_revenue'] as num),
                                              ),
                                            ),
                                            AppSpacing.gapW12,
                                            Expanded(
                                              child: ReportKpiCard(
                                                label: l10n.totalRevenue,
                                                value: formatCurrency(totalRevenue),
                                                icon: Icons.trending_up_rounded,
                                                color: AppColors.success,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppSpacing.gapH12,
                                        ReportKpiCard(
                                          label: l10n.staffTotalOrders,
                                          value: '$totalOrders',
                                          icon: Icons.receipt_long_rounded,
                                          color: AppColors.info,
                                        ),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        Expanded(
                                          child: ReportKpiCard(
                                            label: l10n.reportsPeakHour,
                                            value: _formatHour(peak['hour'] as int),
                                            icon: Icons.whatshot_rounded,
                                            color: AppColors.warning,
                                            subtitle: formatCurrency(peak['total_revenue'] as num),
                                          ),
                                        ),
                                        AppSpacing.gapW12,
                                        Expanded(
                                          child: ReportKpiCard(
                                            label: l10n.totalRevenue,
                                            value: formatCurrency(totalRevenue),
                                            icon: Icons.trending_up_rounded,
                                            color: AppColors.success,
                                          ),
                                        ),
                                        AppSpacing.gapW12,
                                        Expanded(
                                          child: ReportKpiCard(
                                            label: l10n.staffTotalOrders,
                                            value: '$totalOrders',
                                            icon: Icons.receipt_long_rounded,
                                            color: AppColors.info,
                                          ),
                                        ),
                                      ],
                                    ),
                              AppSpacing.gapH24,
                            ],
                          );
                        },
                      ),
                    ],

                    // Hourly Chart
                    ReportSectionHeader(title: l10n.reportsHourlyPattern, icon: Icons.schedule_rounded),
                    ReportDataCard(
                      child: ReportHourlyChart(data: hours, valueKey: 'total_revenue'),
                    ),
                    AppSpacing.gapH24,

                    ReportSectionHeader(title: l10n.reportsRevenueByHour, icon: Icons.bar_chart_rounded),
                    ReportDataCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          for (int i = 0; i < hours.length; i++) ...[
                            if (i > 0) AppSpacing.gapH8,
                            _HourRow(
                              hour: _formatHour(hours[i]['hour'] as int),
                              revenue: double.tryParse(hours[i]['total_revenue'].toString()) ?? 0.0,
                              orders: hours[i]['total_orders'] as int? ?? 0,
                              maxRevenue: hours.fold<double>(0, (max, h) {
                                final r = double.tryParse(h['total_revenue'].toString()) ?? 0.0;
                                return r > max ? r : max;
                              }),
                              isDark: isDark,
                            ),
                          ],
                        ],
                      ),
                    ),
                    AppSpacing.gapH20,
                  ],
                ),
      },
    );
  }
}

class _HourRow extends StatelessWidget {

  const _HourRow({
    required this.hour,
    required this.revenue,
    required this.orders,
    required this.maxRevenue,
    required this.isDark,
  });
  final String hour;
  final double revenue;
  final int orders;
  final double maxRevenue;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
        AppSpacing.gapW12,
        Expanded(
          child: ReportBar(value: revenue, maxValue: maxRevenue, color: AppColors.primary, height: 24),
        ),
        AppSpacing.gapW12,
        SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(formatCurrency(revenue), style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              Text(
                l10n.reportNOrders(orders.toString()),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 10, color: AppColors.mutedFor(context)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
