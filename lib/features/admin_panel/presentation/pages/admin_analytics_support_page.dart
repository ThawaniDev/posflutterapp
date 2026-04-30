import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsSupportPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSupportPage({super.key});
  @override
  ConsumerState<AdminAnalyticsSupportPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsSupportPage> {
  late String _dateFrom;
  late String _dateTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateTo = now.toIso8601String().substring(0, 10);
    _dateFrom = now.subtract(const Duration(days: 30)).toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() => ref.read(analyticsSupportProvider.notifier).load(dateFrom: _dateFrom, dateTo: _dateTo);

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (r != null && mounted) {
      setState(() {
        _dateFrom = r.start.toIso8601String().substring(0, 10);
        _dateTo = r.end.toIso8601String().substring(0, 10);
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsSupportProvider);

    return PosListPage(
      title: l10n.analyticsSupportDashboard,
      showSearch: false,
      actions: [
        IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: _pickRange, tooltip: l10n.analyticsSelectDateRange),
      ],
      child: switch (state) {
        AnalyticsSupportLoading() => PosLoadingSkeleton.list(),
        AnalyticsSupportLoaded(
          totalTickets: final total,
          openTickets: final open,
          inProgressTickets: final inProgress,
          resolvedTickets: final resolved,
          closedTickets: final closed,
          slaComplianceRate: final slaRate,
          slaBreached: final slaBreached,
          avgFirstResponseHours: final avgResponse,
          avgResolutionHours: final avgResolution,
          byCategory: final byCategory,
          byPriority: final byPriority,
        ) =>
          RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Chip(
                  avatar: const Icon(Icons.date_range, size: 14),
                  label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: AppSpacing.md),
                // Ticket status row
                PosKpiGrid(
                  desktopCols: 4,
                  mobileCols: 2,
                  cards: [
                    PosKpiCard(
                      label: l10n.adminTotalTickets,
                      value: '$total',
                      icon: Icons.confirmation_number_outlined,
                      iconColor: AppColors.info,
                    ),
                    PosKpiCard(
                      label: l10n.adminOpenTickets,
                      value: '$open',
                      icon: Icons.radio_button_unchecked,
                      iconColor: AppColors.warning,
                    ),
                    PosKpiCard(
                      label: l10n.adminInProgressTickets,
                      value: '$inProgress',
                      icon: Icons.pending_outlined,
                      iconColor: AppColors.primary,
                    ),
                    PosKpiCard(
                      label: l10n.adminResolvedTickets,
                      value: '$resolved',
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PosKpiGrid(
                  desktopCols: 4,
                  mobileCols: 2,
                  cards: [
                    PosKpiCard(
                      label: l10n.adminClosedTickets,
                      value: '$closed',
                      icon: Icons.cancel_outlined,
                      iconColor: AppColors.textSecondary,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsSlaCompliance,
                      value: '${slaRate.toStringAsFixed(1)}%',
                      icon: Icons.verified_outlined,
                      iconColor: AppColors.success,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsSlaBreached,
                      value: '$slaBreached',
                      icon: Icons.gpp_bad_outlined,
                      iconColor: AppColors.error,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsAvgFirstResponse,
                      value: '${avgResponse.toStringAsFixed(1)}h',
                      icon: Icons.reply_outlined,
                      iconColor: AppColors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PosKpiGrid(
                  desktopCols: 2,
                  mobileCols: 2,
                  cards: [
                    PosKpiCard(
                      label: l10n.analyticsAvgResolution,
                      value: '${avgResolution.toStringAsFixed(1)}h',
                      icon: Icons.timer_outlined,
                      iconColor: AppColors.info,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // By Category
                Text(l10n.analyticsByCategory, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                PosCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: byCategory.isEmpty
                        ? PosEmptyState(title: l10n.adminNoDataAvailable)
                        : ReportPieChart(
                            data: byCategory.entries.map((e) => {'category': e.key, 'count': e.value}).toList(),
                            labelKey: 'category',
                            valueKey: 'count',
                            height: 200,
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // By Priority
                Text(l10n.analyticsByPriority, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                PosCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: byPriority.isEmpty
                        ? PosEmptyState(title: l10n.adminNoDataAvailable)
                        : Column(
                            children: [
                              ReportPieChart(
                                data: byPriority.entries.map((e) => {'priority': e.key, 'count': e.value}).toList(),
                                labelKey: 'priority',
                                valueKey: 'count',
                                height: 200,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              // Priority legend
                              ...byPriority.entries.map((e) {
                                final priority = e.key.toString().toLowerCase();
                                final color = priority == 'urgent' || priority == 'critical'
                                    ? AppColors.error
                                    : priority == 'high'
                                    ? AppColors.warning
                                    : priority == 'medium'
                                    ? AppColors.info
                                    : AppColors.textSecondary;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(e.key.toString(), style: const TextStyle(fontWeight: FontWeight.w500)),
                                      ),
                                      Text(
                                        '${e.value}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: color),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        AnalyticsSupportError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosErrorState(message: msg),
              const SizedBox(height: AppSpacing.sm),
              PosButton(onPressed: _load, label: l10n.retry),
            ],
          ),
        ),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
