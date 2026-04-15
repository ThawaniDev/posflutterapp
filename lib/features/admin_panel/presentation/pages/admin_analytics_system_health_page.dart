import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminAnalyticsSystemHealthPage extends ConsumerStatefulWidget {
  const AdminAnalyticsSystemHealthPage({super.key});

  @override
  ConsumerState<AdminAnalyticsSystemHealthPage> createState() => _AdminAnalyticsSystemHealthPageState();
}

class _AdminAnalyticsSystemHealthPageState extends ConsumerState<AdminAnalyticsSystemHealthPage> {
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

    return Scaffold(
      appBar: AppBar(title: const Text('System Health'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
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
                            label: 'Monitored',
                            value: '$monitored',
                            iconColor: AppColors.info,
                            icon: Icons.monitor_heart,
                          ),
                          PosKpiCard(label: 'With Errors', value: '$withErrors', iconColor: AppColors.error, icon: Icons.error),
                          PosKpiCard(
                            label: 'Total Errors Today',
                            value: '$errors',
                            iconColor: AppColors.warning,
                            icon: Icons.warning,
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Sync status breakdown
                      const Text('Sync Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (syncStatus.isEmpty)
                        const Card(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No sync data')),
                        )
                      else
                        ...syncStatus.entries.map((e) {
                          final isOk = e.key == 'ok' || e.key == 'synced';
                          return Card(
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
                    Text('Error: $msg'),
                    const SizedBox(height: AppSpacing.sm),
                    ElevatedButton(
                      onPressed: () => ref.read(analyticsSystemHealthProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading system health...')),
            },
          ),
        ],
      ),
    );
  }
}
