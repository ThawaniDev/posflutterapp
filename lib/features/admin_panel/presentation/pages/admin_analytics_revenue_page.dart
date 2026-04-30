import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsRevenuePage extends ConsumerStatefulWidget {
  const AdminAnalyticsRevenuePage({super.key});

  @override
  ConsumerState<AdminAnalyticsRevenuePage> createState() => _AdminAnalyticsRevenuePageState();
}

class _AdminAnalyticsRevenuePageState extends ConsumerState<AdminAnalyticsRevenuePage> {
  String _dateFrom = _defaultFrom();
  String _dateTo   = _defaultTo();

  static String _defaultFrom() {
    final d = DateTime.now().subtract(const Duration(days: 30));
    return d.toIso8601String().substring(0, 10);
  }
  static String _defaultTo() => DateTime.now().toIso8601String().substring(0, 10);

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  void _load() => ref.read(analyticsRevenueProvider.notifier).load(dateFrom: _dateFrom, dateTo: _dateTo);

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final range = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (range != null && mounted) {
      setState(() {
        _dateFrom = range.start.toIso8601String().substring(0, 10);
        _dateTo   = range.end.toIso8601String().substring(0, 10);
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsRevenueProvider);

    return PosListPage(
      title: l10n.analyticsRevenue,
      showSearch: false,
      actions: [
        IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: _pickDateRange, tooltip: l10n.analyticsSelectDateRange),
        IconButton(
          icon: const Icon(Icons.download_outlined),
          tooltip: l10n.adminExportRevenue,
          onPressed: () => ref.read(analyticsExportProvider.notifier).exportRevenue(dateFrom: _dateFrom, dateTo: _dateTo),
        ),
      ],
      child: switch (state) {
        AnalyticsRevenueLoading() => PosLoadingSkeleton.list(),
        AnalyticsRevenueLoaded(
          mrr: final mrr, arr: final arr, revenueByPlan: final byPlan,
          failedPaymentsCount: final failed, upcomingRenewals: final renewals,
          revenueTrend: final trend,
        ) =>
          RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // date range chip
                Wrap(children: [
                  Chip(
                    avatar: const Icon(Icons.date_range, size: 14),
                    label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
                    onDeleted: () => setState(() { _dateFrom = _defaultFrom(); _dateTo = _defaultTo(); }),
                  ),
                ]),
                const SizedBox(height: AppSpacing.sm),

                // KPI grid
                PosKpiGrid(desktopCols: 4, mobileCols: 2, cards: [
                  PosKpiCard(label: l10n.adminMRR, value: 'SAR ${mrr.toStringAsFixed(0)}', icon: Icons.payments_outlined, iconColor: AppColors.success),
                  PosKpiCard(label: l10n.adminARR, value: 'SAR ${arr.toStringAsFixed(0)}', icon: Icons.trending_up, iconColor: AppColors.info),
                  PosKpiCard(label: l10n.failedPayments, value: '$failed', icon: Icons.error_outline, iconColor: AppColors.error),
                  PosKpiCard(label: l10n.adminUpcomingRenewals, value: '$renewals', icon: Icons.autorenew, iconColor: AppColors.warning),
                ]),
                const SizedBox(height: AppSpacing.xl),

                // Revenue Trend chart
                Text(l10n.reportsRevenueTrend, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                PosCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: trend.isEmpty
                        ? PosEmptyState(title: l10n.adminNoTrendData)
                        : ReportLineChart(
                            data: trend,
                            xKey: 'date',
                            yKeys: const ['mrr', 'gmv'],
                            yLabels: [l10n.adminMRR, l10n.analyticsTotalGmv],
                            colors: const [AppColors.success, AppColors.info],
                            height: 240,
                            showArea: true,
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Revenue by Plan
                Text(l10n.adminRevenueByPlan, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                if (byPlan.isEmpty)
                  PosEmptyState(title: l10n.adminNoPlanDataAvailable)
                else ...[
                  PosCard(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ReportPieChart(
                        data: byPlan,
                        labelKey: 'plan_name',
                        valueKey: 'mrr',
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...byPlan.map((p) => PosCard(
                    margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                        child: const Icon(Icons.workspace_premium, color: AppColors.primary, size: 18),
                      ),
                      title: Text(p['plan_name'] as String? ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${p['active_count'] ?? 0} active stores'),
                      trailing: Text(
                        'SAR ${(p['mrr'] as num? ?? 0).toStringAsFixed(0)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 14),
                      ),
                    ),
                  )),
                ],
              ],
            ),
          ),
        AnalyticsRevenueError(message: final msg) => Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            PosErrorState(message: msg),
            const SizedBox(height: AppSpacing.sm),
            PosButton(onPressed: _load, label: l10n.retry),
          ]),
        ),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
