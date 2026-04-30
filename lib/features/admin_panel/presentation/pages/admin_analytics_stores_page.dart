import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsStoresPage extends ConsumerStatefulWidget {
  const AdminAnalyticsStoresPage({super.key});
  @override
  ConsumerState<AdminAnalyticsStoresPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsStoresPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(analyticsStoresProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n  = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsStoresProvider);

    return PosListPage(
      title: l10n.analyticsStorePerformance,
      showSearch: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.download_outlined),
          tooltip: l10n.adminExportStores,
          onPressed: () => ref.read(analyticsExportProvider.notifier).exportStores(),
        ),
      ],
      child: switch (state) {
        AnalyticsStoresLoading() => PosLoadingSkeleton.list(),
        AnalyticsStoresLoaded(
          totalStores: final total,
          activeStores: final active,
          topStores: final topList,
          healthSummary: final health,
        ) => RefreshIndicator(
          onRefresh: () async => ref.read(analyticsStoresProvider.notifier).load(),
          child: ListView(padding: const EdgeInsets.all(AppSpacing.md), children: [
            PosKpiGrid(desktopCols: 3, mobileCols: 2, cards: [
              PosKpiCard(label: l10n.analyticsTotalStores, value: '$total', icon: Icons.storefront_outlined, iconColor: AppColors.info),
              PosKpiCard(label: l10n.analyticsActiveStores, value: '$active', icon: Icons.store_outlined, iconColor: AppColors.success),
              PosKpiCard(label: l10n.analyticsInactiveStores, value: '${total - active}', icon: Icons.store, iconColor: AppColors.textSecondary),
            ]),
            const SizedBox(height: AppSpacing.xl),
            // Health summary pie
            Text(l10n.analyticsStoreHealthSummary, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            PosCard(
              child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: health.isEmpty
                ? PosEmptyState(title: l10n.adminNoHealthData)
                : ReportPieChart(
                    data: health.entries.map((e) => {'status': e.key, 'count': e.value}).toList(),
                    labelKey: 'status', valueKey: 'count', height: 200,
                  )),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Top stores list
            Text(l10n.analyticsTopStores, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            if (topList.isEmpty)
              PosEmptyState(title: l10n.adminNoStoresData)
            else
              PosCard(
                child: Column(children: [
                  ...topList.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final s = entry.value;
                    return Column(children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: idx == 0
                            ? AppColors.warning.withValues(alpha: 0.2)
                            : AppColors.primary.withValues(alpha: 0.1),
                          child: Text('${idx + 1}', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: idx == 0 ? AppColors.warning : AppColors.primary,
                          )),
                        ),
                        title: Text(s['name'] as String? ?? 'Store', style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: s['last_activity'] != null
                          ? Text(s['last_activity'] as String, style: const TextStyle(fontSize: 12))
                          : null,
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: (s['is_active'] == true ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            s['is_active'] == true ? l10n.analyticsActive : l10n.analyticsInactive,
                            style: TextStyle(
                              fontSize: 11,
                              color: s['is_active'] == true ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      if (idx < topList.length - 1) const Divider(height: 1, indent: 56),
                    ]);
                  }),
                ]),
              ),
          ]),
        ),
        AnalyticsStoresError(message: final msg) => Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          PosErrorState(message: msg), const SizedBox(height: AppSpacing.sm),
          PosButton(onPressed: () => ref.read(analyticsStoresProvider.notifier).load(), label: l10n.retry),
        ])),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }
}
