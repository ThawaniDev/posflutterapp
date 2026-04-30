import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsSystemHealthPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSystemHealthPage({super.key});
  @override
  ConsumerState<AdminAnalyticsSystemHealthPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsSystemHealthPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(analyticsSystemHealthProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsSystemHealthProvider);

    return PosListPage(
      title: l10n.analyticsSystemHealth,
      showSearch: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          tooltip: l10n.retry,
          onPressed: () => ref.read(analyticsSystemHealthProvider.notifier).load(),
        ),
      ],
      child: switch (state) {
        AnalyticsSystemHealthLoading() => PosLoadingSkeleton.list(),
        AnalyticsSystemHealthLoaded(
          storesMonitored: final monitored,
          storesWithErrors: final withErrors,
          totalErrorsToday: final totalErrors,
          syncStatusBreakdown: final breakdown,
        ) => RefreshIndicator(
          onRefresh: () async => ref.read(analyticsSystemHealthProvider.notifier).load(),
          child: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
            // Health banner
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: (withErrors == 0 ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (withErrors == 0 ? AppColors.success : AppColors.error).withValues(alpha: 0.3),
                ),
              ),
              child: Row(children: [
                Icon(
                  withErrors == 0 ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: withErrors == 0 ? AppColors.success : AppColors.error,
                  size: 32,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    withErrors == 0 ? l10n.analyticsSystemHealthy : l10n.analyticsSystemHasErrors,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: withErrors == 0 ? AppColors.success : AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(l10n.analyticsMonitoringStores(monitored), style: const TextStyle(fontSize: 13)),
                ])),
              ]),
            ),
            const SizedBox(height: AppSpacing.md),
            // KPIs
            PosKpiGrid(desktopCols: 3, mobileCols: 2, cards: [
              PosKpiCard(label: l10n.analyticsStoresMonitored, value: '$monitored', icon: Icons.monitor_heart_outlined, iconColor: AppColors.info),
              PosKpiCard(label: l10n.analyticsStoresWithErrors, value: '$withErrors', icon: Icons.error_outline, iconColor: withErrors > 0 ? AppColors.error : AppColors.success),
              PosKpiCard(label: l10n.analyticsTotalErrorsToday, value: '$totalErrors', icon: Icons.bug_report_outlined, iconColor: AppColors.warning),
            ]),
            const SizedBox(height: AppSpacing.xl),
            // Sync status breakdown
            Text(l10n.analyticsSyncStatusBreakdown, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            PosCard(
              child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: breakdown.isEmpty
                ? PosEmptyState(title: l10n.adminNoHealthData)
                : ReportPieChart(
                    data: breakdown.entries.map((e) => {'status': e.key, 'count': e.value}).toList(),
                    labelKey: 'status', valueKey: 'count', height: 200,
                  )),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Status legend
            if (breakdown.isNotEmpty) ...[
              Text(l10n.analyticsStatusDetails, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.sm),
              ...breakdown.entries.map((e) {
                final status = e.key.toString();
                final count  = e.value;
                final isOk   = status == 'ok';
                return PosCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: ListTile(
                    leading: Icon(
                      isOk ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                      color: isOk ? AppColors.success : AppColors.error,
                    ),
                    title: Text(status.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (isOk ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text('$count stores', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isOk ? AppColors.success : AppColors.error,
                      )),
                    ),
                  ),
                );
              }),
            ],
          ]),
        ),
        AnalyticsSystemHealthError(message: final msg) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          PosErrorState(message: msg), const SizedBox(height: AppSpacing.sm),
          PosButton(onPressed: () => ref.read(analyticsSystemHealthProvider.notifier).load(), label: l10n.retry),
        ])),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
