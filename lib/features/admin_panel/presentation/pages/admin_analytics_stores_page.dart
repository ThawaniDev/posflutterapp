import 'package:flutter/material.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminAnalyticsStoresPage extends ConsumerStatefulWidget {
  const AdminAnalyticsStoresPage({super.key});

  @override
  ConsumerState<AdminAnalyticsStoresPage> createState() => _AdminAnalyticsStoresPageState();
}

class _AdminAnalyticsStoresPageState extends ConsumerState<AdminAnalyticsStoresPage> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Analytics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            tooltip: 'Export Stores',
            onPressed: () => ref.read(analyticsExportProvider.notifier).exportStores(),
          ),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          if (exportState is AnalyticsExportSuccess)
            MaterialBanner(
              content: Text('Export ready: ${exportState.recordCount} records'),
              backgroundColor: AppColors.success.withValues(alpha: 0.08),
              actions: [
                TextButton(
                  onPressed: () => ref.read(analyticsExportProvider.notifier).exportStores(),
                  child: const Text('Export Again'),
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
                      context.isPhone
                          ? Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
                              children: [
                                _metricCard('Total Stores', '$total', AppColors.info),
                                _metricCard('Active', '$active', AppColors.success),
                                _metricCard('Inactive', '${total - active}', AppColors.textSecondary),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(child: _metricCard('Total Stores', '$total', AppColors.info)),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(child: _metricCard('Active', '$active', AppColors.success)),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(child: _metricCard('Inactive', '${total - active}', AppColors.textSecondary)),
                              ],
                            ),
                      const SizedBox(height: AppSpacing.lg),

                      // Health Summary
                      const Text('Health Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: AppSpacing.sm),
                      if (health.isEmpty)
                        const Card(
                          child: Padding(padding: EdgeInsets.all(AppSpacing.md), child: Text('No health data today')),
                        )
                      else
                        ...health.entries.map(
                          (e) => Card(
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
                        (s) => Card(
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
                    ElevatedButton(
                      onPressed: () => ref.read(analyticsStoresProvider.notifier).load(storeId: _storeId),
                      child: const Text('Retry'),
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

  Widget _metricCard(String label, String value, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
