import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsSubscriptionsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSubscriptionsPage({super.key});
  @override
  ConsumerState<AdminAnalyticsSubscriptionsPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsSubscriptionsPage> {
  late String _dateFrom;
  late String _dateTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateTo   = now.toIso8601String().substring(0, 10);
    _dateFrom = now.subtract(const Duration(days: 30)).toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() => ref.read(analyticsSubscriptionsProvider.notifier).load(dateFrom: _dateFrom, dateTo: _dateTo);

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (r != null && mounted) {
      setState(() {
        _dateFrom = r.start.toIso8601String().substring(0, 10);
        _dateTo   = r.end.toIso8601String().substring(0, 10);
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsSubscriptionsProvider);

    return PosListPage(
      title: l10n.analyticsSubscriptions,
      showSearch: false,
      actions: [
        IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: _pickRange, tooltip: l10n.analyticsSelectDateRange),
        IconButton(
          icon: const Icon(Icons.download_outlined),
          tooltip: l10n.adminExportSubscriptions,
          onPressed: () => ref.read(analyticsExportProvider.notifier).exportSubscriptions(dateFrom: _dateFrom, dateTo: _dateTo),
        ),
      ],
      child: switch (state) {
        AnalyticsSubscriptionsLoading() => PosLoadingSkeleton.list(),
        AnalyticsSubscriptionsLoaded(
          statusCounts: final counts,
          lifecycleTrend: final trend,
        ) => RefreshIndicator(
          onRefresh: () async => _load(),
          child: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
            // ignore: prefer_const_constructors
            Chip(
              avatar: const Icon(Icons.date_range, size: 14),
              // ignore: prefer_const_constructors
              label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: AppSpacing.md),
            PosKpiGrid(desktopCols: 4, mobileCols: 2, cards: [
              PosKpiCard(label: l10n.analyticsActiveSubscriptions, value: '\${counts["active"] ?? 0}', icon: Icons.check_circle_outline, iconColor: AppColors.success),
              PosKpiCard(label: l10n.analyticsTrialSubscriptions, value: '\${counts["trial"] ?? 0}', icon: Icons.hourglass_bottom, iconColor: AppColors.warning),
              PosKpiCard(label: l10n.analyticsChurnInPeriod, value: '\$churn', icon: Icons.trending_down, iconColor: AppColors.error),
              PosKpiCard(label: l10n.analyticsConversionRate, value: '\${convRate.toStringAsFixed(1)}%', icon: Icons.swap_horiz, iconColor: AppColors.info),
              PosKpiCard(label: l10n.analyticsAvgSubscriptionAge, value: '\${avgAge.toStringAsFixed(1)} days', icon: Icons.schedule, iconColor: AppColors.purple),
            ]),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.analyticsSubscriptionLifecycle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            PosCard(
              child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: trend.isEmpty
                ? PosEmptyState(title: l10n.adminNoTrendData)
                : ReportLineChart(
                    data: trend, xKey: 'date',
                    yKeys: const ['active', 'trial', 'churned'],
                    yLabels: [l10n.analyticsActive, l10n.analyticsTrial, l10n.analyticsChurned],
                    colors: const [AppColors.success, AppColors.warning, AppColors.error],
                    height: 240,
                  )),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(l10n.analyticsSubscriptionStatus, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            PosCard(
              child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: counts.isEmpty
                ? PosEmptyState(title: l10n.adminNoTrendData)
                : ReportPieChart(
                    data: counts.entries.map((e) => {'status': e.key, 'count': e.value}).toList(),
                    labelKey: 'status', valueKey: 'count', height: 200,
                  )),
            ),
          ]),
        ),
        AnalyticsSubscriptionsError(message: final msg) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          PosErrorState(message: msg), const SizedBox(height: AppSpacing.sm),
          PosButton(onPressed: _load, label: l10n.retry),
        ])),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
