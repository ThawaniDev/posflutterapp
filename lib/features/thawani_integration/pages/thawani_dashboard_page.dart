import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:thawani_pos/features/thawani_integration/providers/thawani_state.dart';

class ThawaniDashboardPage extends ConsumerStatefulWidget {
  const ThawaniDashboardPage({super.key});

  @override
  ConsumerState<ThawaniDashboardPage> createState() => _ThawaniDashboardPageState();
}

class _ThawaniDashboardPageState extends ConsumerState<ThawaniDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(thawaniStatsProvider.notifier).load();
      ref.read(thawaniConfigProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(thawaniStatsProvider);
    final actionState = ref.watch(thawaniActionProvider);

    ref.listen<ThawaniActionState>(thawaniActionProvider, (prev, next) {
      if (next is ThawaniActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
        ref.read(thawaniActionProvider.notifier).reset();
        ref.read(thawaniStatsProvider.notifier).load();
        ref.read(thawaniConfigProvider.notifier).load();
      } else if (next is ThawaniActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.thawaniIntegration),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(thawaniStatsProvider.notifier).load();
              ref.read(thawaniConfigProvider.notifier).load();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.thawaniOverview),
            Tab(text: AppLocalizations.of(context)!.thawaniSettings),
            Tab(text: AppLocalizations.of(context)!.thawaniOrders),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildOverview(statsState), _buildSettings(actionState), _buildOrders()],
      ),
    );
  }

  Widget _buildOverview(ThawaniStatsState state) {
    return switch (state) {
      ThawaniStatsInitial() || ThawaniStatsLoading() => Center(child: PosLoadingSkeleton.list()),
      ThawaniStatsError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(thawaniStatsProvider.notifier).load(),
      ),
      ThawaniStatsLoaded(
        :final isConnected,
        :final thawaniStoreId,
        :final totalOrders,
        :final totalProductsMapped,
        :final totalCategoriesMapped,
        :final totalSettlements, // ignore: unused_local_variable
        :final pendingOrders,
        :final pendingSyncItems,
        :final syncLogsToday,
        :final failedSyncsToday,
      ) =>
        ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Connection status banner
            Card(
              elevation: 0,
              color: isConnected ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
                side: BorderSide(
                  color: isConnected ? AppColors.success.withValues(alpha: 0.3) : AppColors.warning.withValues(alpha: 0.3),
                ),
              ),
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    Icon(
                      isConnected ? Icons.link : Icons.link_off,
                      color: isConnected ? AppColors.success : AppColors.warning,
                      size: 32,
                    ),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isConnected
                                ? AppLocalizations.of(context)!.thawaniConnected
                                : AppLocalizations.of(context)!.thawaniNotConnected,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isConnected ? AppColors.success : AppColors.warning,
                            ),
                          ),
                          if (thawaniStoreId != null)
                            Text(
                              AppLocalizations.of(context)!.thawaniStoreId(thawaniStoreId),
                              style: const TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.gapH16,
            // Stats grid - row 1
            Row(
              children: [
                _statCard(AppLocalizations.of(context)!.thawaniTotalOrders, '$totalOrders', Icons.receipt, AppColors.info),
                AppSpacing.gapW12,
                _statCard(
                  AppLocalizations.of(context)!.thawaniProducts,
                  '$totalProductsMapped',
                  Icons.inventory,
                  AppColors.purple,
                ),
              ],
            ),
            AppSpacing.gapH12,
            // Stats grid - row 2
            Row(
              children: [
                _statCard('Categories', '$totalCategoriesMapped', Icons.category, AppColors.success),
                AppSpacing.gapW12,
                _statCard(AppLocalizations.of(context)!.thawaniPendingOrders, '$pendingOrders', Icons.pending, AppColors.warning),
              ],
            ),
            AppSpacing.gapH12,
            // Stats grid - row 3 (sync stats)
            Row(
              children: [
                _statCard('Pending Sync', '$pendingSyncItems', Icons.sync, AppColors.info),
                AppSpacing.gapW12,
                _statCard('Syncs Today', '$syncLogsToday', Icons.today, AppColors.purple),
              ],
            ),
            if (failedSyncsToday > 0) ...[
              AppSpacing.gapH12,
              Card(
                elevation: 0,
                color: AppColors.error.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  side: BorderSide(color: AppColors.error.withValues(alpha: 0.3)),
                ),
                child: ListTile(
                  leading: Icon(Icons.warning_amber, color: AppColors.error),
                  title: Text(
                    '$failedSyncsToday failed syncs today',
                    style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
                  ),
                  trailing: TextButton(onPressed: () => context.push(Routes.thawaniSyncLogs), child: const Text('View Logs')),
                ),
              ),
            ],
            AppSpacing.gapH24,
            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            AppSpacing.gapH12,
            _actionTile(
              icon: Icons.sync,
              title: 'Sync Management',
              subtitle: 'Push/pull products & categories',
              color: AppColors.info,
              onTap: () => context.push(Routes.thawaniSync),
            ),
            _actionTile(
              icon: Icons.category,
              title: 'Category Mappings',
              subtitle: '$totalCategoriesMapped categories mapped',
              color: AppColors.purple,
              onTap: () => context.push(Routes.thawaniCategoryMappings),
            ),
            _actionTile(
              icon: Icons.history,
              title: 'Sync Logs',
              subtitle: '$syncLogsToday operations today',
              color: AppColors.success,
              onTap: () => context.push(Routes.thawaniSyncLogs),
            ),
          ],
        ),
    };
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: Theme.of(context).dividerColor),
        ),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              AppSpacing.gapH8,
              Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
              AppSpacing.gapH4,
              Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettings(ThawaniActionState actionState) {
    final configState = ref.watch(thawaniConfigProvider);
    final isLoading = actionState is ThawaniActionLoading;

    return switch (configState) {
      ThawaniConfigInitial() || ThawaniConfigLoading() => Center(child: PosLoadingSkeleton.list()),
      ThawaniConfigError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(thawaniConfigProvider.notifier).load(),
      ),
      ThawaniConfigLoaded(:final config) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.thawaniAutoSyncProducts),
            subtitle: Text(AppLocalizations.of(context)!.thawaniAutoSyncProductsDesc),
            value: config?['auto_sync_products'] == true,
            onChanged: isLoading ? null : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_sync_products': v}),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.thawaniAutoSyncInventory),
            subtitle: Text(AppLocalizations.of(context)!.thawaniAutoSyncInventoryDesc),
            value: config?['auto_sync_inventory'] == true,
            onChanged: isLoading ? null : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_sync_inventory': v}),
          ),
          const Divider(),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.thawaniAutoAcceptOrders),
            subtitle: Text(AppLocalizations.of(context)!.thawaniAutoAcceptOrdersDesc),
            value: config?['auto_accept_orders'] == true,
            onChanged: isLoading ? null : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_accept_orders': v}),
          ),
          const Divider(),
          ListTile(
            title: Text(AppLocalizations.of(context)!.thawaniCommissionRate),
            subtitle: Text('${config?['commission_rate'] ?? 'Not set'}%'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const SizedBox(height: 24),
          if (config?['is_connected'] == true)
            OutlinedButton.icon(
              onPressed: isLoading ? null : () => ref.read(thawaniActionProvider.notifier).disconnect(),
              icon: Icon(Icons.link_off, color: AppColors.error),
              label: Text(AppLocalizations.of(context)!.thawaniDisconnect, style: TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.error)),
            ),
        ],
      ),
    };
  }

  Widget _buildOrders() {
    return PosEmptyState(title: AppLocalizations.of(context)!.thawaniOrdersPlaceholder, icon: Icons.receipt_long);
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
