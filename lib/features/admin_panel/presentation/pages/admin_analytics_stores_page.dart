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

class AdminAnalyticsStoresPage extends ConsumerStatefulWidget {
  const AdminAnalyticsStoresPage({super.key});

  @override
  ConsumerState<AdminAnalyticsStoresPage> createState() => _AdminAnalyticsStoresPageState();
}

class _AdminAnalyticsStoresPageState extends ConsumerState<AdminAnalyticsStoresPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(analyticsStoresProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    ref.read(analyticsStoresProvider.notifier).load(storeId: _storeId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsStoresProvider);
    final exportState = ref.watch(analyticsExportProvider);

    return PosListPage(
  title: l10n.analyticsStores,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.download, onPressed: () => ref.read(analyticsExportProvider.notifier).exportStores(), tooltip: 'Export Stores',
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          if (exportState is AnalyticsExportSuccess)
            MaterialBanner(
              content: Text('Export ready: ${exportState.recordCount} records'),
              backgroundColor: AppColors.success.withValues(alpha: 0.08),
              actions: [
                PosButton(
                  onPressed: () => ref.read(analyticsExportProvider.notifier).exportStores(),
                  variant: PosButtonVariant.ghost,
                  label: 'Export Again',
                ),
              ],
            ),
          Expanded(
            child: switch (state) {
              AnalyticsStoresLoading() => const Center(child: CircularProgressIndicator()),
              AnalyticsStoresLoaded(
                totalStores: final total,
                activeStores: final active,
                topStores: final stores,
                healthSummary: final health,
              ) =>
                RefreshIndicator(
                  onRefresh: () => ref.read(analyticsStoresProvider.notifier).load(storeId: _storeId),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    children: [
                      // Overview cards
                      PosKpiGrid(
                        desktopCols: 3,
                        mobileCols: 2,
                        cards: [
                          PosKpiCard(label: 'Total Stores', value: '$total', iconColor: AppColors.info),
                          PosKpiCard(label: l10n.active, value: '$active', iconColor: AppColors.success),
                          PosKpiCard(label: l10n.inactive, value: '${total - active}', iconColor: AppColors.textSecondary),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),

                      // Health Summary
                      const Text('Health Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (health.isEmpty)
                        const PosCard(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No health data today')),
                        )
                      else
                        ...health.entries.map(
                          (e) => PosCard(
                            margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: ListTile(
                              leading: Icon(
                                e.key == 'ok' ? Icons.check_circle : Icons.warning,
                                color: e.key == 'ok' ? AppColors.success : AppColors.warning,
                              ),
                              title: Text(e.key.toUpperCase()),
                              trailing: Text('${e.value}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),

                      const SizedBox(height: AppSpacing.lg),

                      // Top Stores
                      const Text('Top Stores', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      ...stores.map(
                        (s) => PosCard(
                          margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: (s['is_active'] == true)
                                  ? AppColors.success.withValues(alpha: 0.08)
                                  : AppColors.textSecondary.withValues(alpha: 0.08),
                              child: Icon(
                                Icons.store,
                                color: (s['is_active'] == true) ? AppColors.success : AppColors.textSecondary,
                              ),
                            ),
                            title: Text(s['name'] as String? ?? 'Store #${s['id']}'),
                            trailing: Icon(
                              (s['is_active'] == true) ? Icons.check_circle : Icons.cancel,
                              color: (s['is_active'] == true) ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              AnalyticsStoresError(message: final msg) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: $msg'),
                    const SizedBox(height: AppSpacing.sm),
                    PosButton(
                      onPressed: () => ref.read(analyticsStoresProvider.notifier).load(storeId: _storeId),
                      label: l10n.retry,
                    ),
                  ],
                ),
              ),
              _ => const Center(child: Text('Loading store analytics...')),
            },
          ),
        ],
      ),
);
  }
}
