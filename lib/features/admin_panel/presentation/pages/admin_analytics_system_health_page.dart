import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsSystemHealthPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSystemHealthPage({super.key});

  @override
  ConsumerState<AdminAnalyticsSystemHealthPage> createState() => _AdminAnalyticsSystemHealthPageState();
}

class _AdminAnalyticsSystemHealthPageState extends ConsumerState<AdminAnalyticsSystemHealthPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsSystemHealthProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsSystemHealthProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsSystemHealthProvider);

    return PosListPage(
  title: l10n.analyticsSystemHealth,
  showSearch: false,
    child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Expanded(
            child: switch (state) {
              AnalyticsSystemHealthLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsSystemHealthLoaded(
                storesMonitored: final monitored,
                storesWithErrors: final withErrors,
                totalErrorsToday: final errors,
                syncStatusBreakdown: final syncStatus,
              ) =>
                RefreshIndicator(
                  onRefresh: () => ref.read(analyticsSystemHealthProvider.notifier).load(storeId: _storeId),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // KPI cards
                      PosKpiGrid(
                        desktopCols: 3,
                        mobileCols: 2,
                        cards: [
                          PosKpiCard(
                            label: l10n.adminMonitored,
                            value: '$monitored',
                            iconColor: AppColors.info,
                            icon: Icons.monitor_heart,
                          ),
                          PosKpiCard(label: l10n.adminWithErrors, value: '$withErrors', iconColor: AppColors.error, icon: Icons.error),
                          PosKpiCard(
                            label: l10n.adminTotalErrorsToday,
                            value: '$errors',
                            iconColor: AppColors.warning,
                            icon: Icons.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Sync status breakdown
                      Text(l10n.syncStatus, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (syncStatus.isEmpty)
                        PosCard(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(l10n.adminNoSyncData)),
                        )
                      else
                        ...syncStatus.entries.map((e) {
                          final isOk = e.key == 'ok' || e.key == 'synced';
                          return PosCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: ListTile(
                              leading: Icon(
                                isOk ? Icons.check_circle : Icons.sync_problem,
                                color: isOk ? AppColors.success : AppColors.warning,
                              ),
                              title: Text(e.key.toUpperCase()),
                              trailing: Text('${e.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              AnalyticsSystemHealthError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.genericError(msg)),
                    const SizedBox(height: AppSpacing.sm),
                    PosButton(
                      onPressed: () => ref.read(analyticsSystemHealthProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => Center(child: Text(l10n.adminLoadingSystemHealth)),
            },
          ),
        ],
      ),
);
  }
}
