import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_export_sheet.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class StaffPerformancePage extends ConsumerStatefulWidget {
  const StaffPerformancePage({super.key});

  @override
  ConsumerState<StaffPerformancePage> createState() => _StaffPerformancePageState();
}

class _StaffPerformancePageState extends ConsumerState<StaffPerformancePage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(staffPerformanceProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffPerformanceProvider);

    return PermissionGuardPage(
      permission: Permissions.reportsStaff,
      child: ReportPageScaffold(
        title: l10n.sidebarStaffPerformance,
        actions: [
          PosButton.icon(
            icon: Icons.download_rounded,
            tooltip: l10n.reportsExportFormatTitle,
            variant: PosButtonVariant.ghost,
            onPressed: () => showReportExportSheet(context: context, reportType: 'staff_performance', filters: _filters),
          ),
        ],
        filterPanel: ReportFilterPanel(
          filters: _filters,
          onFiltersChanged: _onFiltersChanged,
          onRefresh: _loadData,
          showStaffFilter: true,
          showPaymentMethodFilter: true,
          showAmountRange: true,
          showOrderStatus: true,
          showSortOptions: true,
        ),
        body: switch (state) {
          StaffPerformanceInitial() || StaffPerformanceLoading() => PosLoadingSkeleton.list(),
          StaffPerformanceError(:final message) => PosErrorState(message: message, onRetry: _loadData),
          StaffPerformanceLoaded(:final staff) =>
            staff.isEmpty ? PosEmptyState(title: l10n.reportsNoStaffData, icon: Icons.people) : _StaffList(staff: staff),
        },
      ),
    );
  }
}

class _StaffList extends StatelessWidget {
  const _StaffList({required this.staff});
  final List<Map<String, dynamic>> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalRevenue = staff.fold<double>(0, (sum, s) => sum + (double.tryParse(s['total_revenue'].toString()) ?? 0.0));
    final totalOrders = staff.fold<int>(0, (sum, s) => sum + (s['total_orders'] as num).toInt());

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: l10n.staffMembers,
              value: '${staff.length}',
              icon: Icons.people_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: l10n.totalRevenue,
              value: formatCurrency(totalRevenue),
              icon: Icons.attach_money_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: l10n.staffTotalOrders,
              value: formatCompact(totalOrders),
              icon: Icons.receipt_long_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: l10n.reportsAvgPerStaff,
              value: staff.isNotEmpty ? formatCurrency(totalRevenue / staff.length) : '\u00810',
              icon: Icons.person_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        // Bar Chart — Staff revenue comparison
        if (staff.isNotEmpty) ...[
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.reportsRevenueByStaff, icon: Icons.bar_chart_rounded),
          ReportDataCard(
            child: ReportBarChart(
              data: staff.take(10).toList(),
              labelKey: 'staff_name',
              valueKey: 'total_revenue',
              barColor: AppColors.primary,
              secondaryValueKey: 'total_orders',
              secondaryBarColor: AppColors.info,
              horizontal: true,
            ),
          ),
        ],

        const SizedBox(height: 24),
        ReportSectionHeader(title: l10n.reportsStaffRankedByRevenue, icon: Icons.leaderboard_rounded),

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
              final hoursWorked = (s['hours_worked'] as num?)?.toDouble() ?? 0.0;
              final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

              return Column(
                children: [
                  if (i > 0) Divider(height: 1, color: AppColors.borderFor(context)),
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
                            borderRadius: AppRadius.borderLg,
                          ),
                          child: Center(
                            child: Text(
                              initials,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: i < 3 ? AppColors.primary : (AppColors.mutedFor(context)),
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
                                        borderRadius: AppRadius.borderSm,
                                      ),
                                      child: Text(
                                        '#${i + 1}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
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
                                  ReportBadge(label: l10n.reportNOrders(orders.toString()), color: AppColors.info),
                                  ReportBadge(label: l10n.reportAvgAmount(formatCurrency(avgOrder)), color: AppColors.primary),
                                  if (discounts > 0)
                                    ReportBadge(label: '-${formatCurrency(discounts)}', color: AppColors.warning),
                                  if (hoursWorked > 0)
                                    ReportBadge(label: '${hoursWorked.toStringAsFixed(1)}h', color: AppColors.info),
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
