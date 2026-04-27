import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

class ThawaniDashboardPage extends ConsumerStatefulWidget {
  const ThawaniDashboardPage({super.key});

  @override
  ConsumerState<ThawaniDashboardPage> createState() => _ThawaniDashboardPageState();
}

class _ThawaniDashboardPageState extends ConsumerState<ThawaniDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(thawaniStatsProvider.notifier).load();
      ref.read(thawaniConfigProvider.notifier).load();
    });
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

    return PosListPage(
      title: AppLocalizations.of(context)!.thawaniIntegration,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.refresh,
          onPressed: () {
            ref.read(thawaniStatsProvider.notifier).load();
            ref.read(thawaniConfigProvider.notifier).load();
          },
        ),
      ],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: AppLocalizations.of(context)!.thawaniOverview),
              PosTabItem(label: AppLocalizations.of(context)!.thawaniSettings),
              PosTabItem(label: AppLocalizations.of(context)!.thawaniOrders),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [_buildOverview(statsState), _buildSettings(actionState), _buildOrders()],
            ),
          ),
        ],
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
            PosCard(
              elevation: 0,
              color: isConnected ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: AppRadius.borderMd,
              border: Border.fromBorderSide(
                BorderSide(
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
            // KPI grid
            PosStatsGrid(
              children: [
                PosKpiCard(label: l10n.thawaniTotalOrders, value: '$totalOrders', icon: Icons.receipt, iconColor: AppColors.info),
                PosKpiCard(
                  label: l10n.thawaniProducts,
                  value: '$totalProductsMapped',
                  icon: Icons.inventory,
                  iconColor: AppColors.purple,
                ),
                PosKpiCard(
                  label: l10n.categories,
                  value: '$totalCategoriesMapped',
                  icon: Icons.category,
                  iconColor: AppColors.success,
                ),
                PosKpiCard(
                  label: l10n.thawaniPendingOrders,
                  value: '$pendingOrders',
                  icon: Icons.pending,
                  iconColor: AppColors.warning,
                ),
                PosKpiCard(
                  label: l10n.thawaniPendingSync,
                  value: '$pendingSyncItems',
                  icon: Icons.sync,
                  iconColor: AppColors.info,
                ),
                PosKpiCard(
                  label: l10n.thawaniSyncsToday,
                  value: '$syncLogsToday',
                  icon: Icons.today,
                  iconColor: AppColors.purple,
                ),
              ],
            ),
            if (failedSyncsToday > 0) ...[
              AppSpacing.gapH12,
              PosInfoBanner(
                variant: PosInfoBannerVariant.error,
                message: l10n.thawaniFailedSyncsTodayCount(failedSyncsToday),
                actionLabel: l10n.thawaniViewLogs,
                action: () => context.push(Routes.thawaniSyncLogs),
              ),
            ],
            AppSpacing.gapH24,
            // Quick Actions
            Text(
              l10n.deliveryQuickActions,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            AppSpacing.gapH12,
            _actionTile(
              icon: Icons.sync,
              title: l10n.syncManagement,
              subtitle: l10n.thawaniPushPullCatsProds,
              color: AppColors.info,
              onTap: () => context.push(Routes.thawaniSync),
            ),
            _actionTile(
              icon: Icons.receipt_long,
              title: l10n.thawaniOrdersQueue,
              subtitle: l10n.thawaniOrdersManage,
              color: AppColors.warning,
              onTap: () => context.push(Routes.thawaniOrders),
            ),
            _actionTile(
              icon: Icons.restaurant_menu,
              title: l10n.thawaniMenuManagement,
              subtitle: l10n.thawaniMenuManage,
              color: AppColors.primary,
              onTap: () => context.push(Routes.thawaniMenu),
            ),
            _actionTile(
              icon: Icons.payments_outlined,
              title: l10n.thawaniSettlementsTitle,
              subtitle: l10n.thawaniSettlementsManage,
              color: AppColors.success,
              onTap: () => context.push(Routes.thawaniSettlements),
            ),
            _actionTile(
              icon: Icons.category,
              title: l10n.categoryMappings,
              subtitle: l10n.thawaniCategoriesMapped(totalCategoriesMapped.toString()),
              color: AppColors.purple,
              onTap: () => context.push(Routes.thawaniCategoryMappings),
            ),
            _actionTile(
              icon: Icons.history,
              title: l10n.syncLogs,
              subtitle: l10n.thawaniOpsToday(syncLogsToday.toString()),
              color: AppColors.success,
              onTap: () => context.push(Routes.thawaniSyncLogs),
            ),
          ],
        ),
    };
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
        padding: AppSpacing.paddingAll16,
        children: [
          PosFormCard(
            title: l10n.thawaniSettings,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PosToggle(
                  value: config?['auto_sync_products'] == true,
                  onChanged: isLoading
                      ? (_) {}
                      : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_sync_products': v}),
                  label: l10n.thawaniAutoSyncProducts,
                  subtitle: l10n.thawaniAutoSyncProductsDesc,
                ),
                AppSpacing.gapH12,
                PosToggle(
                  value: config?['auto_sync_inventory'] == true,
                  onChanged: isLoading
                      ? (_) {}
                      : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_sync_inventory': v}),
                  label: l10n.thawaniAutoSyncInventory,
                  subtitle: l10n.thawaniAutoSyncInventoryDesc,
                ),
                AppSpacing.gapH12,
                PosToggle(
                  value: config?['auto_accept_orders'] == true,
                  onChanged: isLoading
                      ? (_) {}
                      : (v) => ref.read(thawaniActionProvider.notifier).saveConfig({'auto_accept_orders': v}),
                  label: l10n.thawaniAutoAcceptOrders,
                  subtitle: l10n.thawaniAutoAcceptOrdersDesc,
                ),
                AppSpacing.gapH12,
                Row(
                  children: [
                    Expanded(child: Text(l10n.thawaniCommissionRate)),
                    Text('${config?['commission_rate'] ?? l10n.thawaniNotSet}%'),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          // Store Availability
          PosFormCard(
            title: l10n.thawaniStoreAvailability,
            child: Consumer(
              builder: (context, ref, _) {
                final availState = ref.watch(thawaniStoreAvailabilityProvider);
                // Initialize from config on first load
                if (availState is ThawaniStoreAvailabilityInitial && config != null) {
                  Future.microtask(() => ref.read(thawaniStoreAvailabilityProvider.notifier).initFromConfig(config));
                }
                final isOpen = availState is ThawaniStoreAvailabilityLoaded
                    ? availState.isOpen
                    : (config?['is_store_open'] as bool? ?? true);
                final closedReason = availState is ThawaniStoreAvailabilityLoaded ? availState.closedReason : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PosToggle(
                      value: isOpen,
                      onChanged: availState is ThawaniStoreAvailabilityLoading
                          ? (_) {}
                          : (v) => ref.read(thawaniStoreAvailabilityProvider.notifier).updateAvailability(v),
                      label: isOpen ? l10n.thawaniStoreOpen : l10n.thawaniStoreClosed,
                    ),
                    if (!isOpen && closedReason != null && closedReason.isNotEmpty) ...[
                      AppSpacing.gapH8,
                      Text(
                        '${l10n.thawaniClosedReason}: $closedReason',
                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                );
              },
            ),
          ),
          if (config?['is_connected'] == true) ...[
            AppSpacing.gapH16,
            PosButton(
              label: l10n.thawaniDisconnect,
              icon: Icons.link_off,
              variant: PosButtonVariant.danger,
              isFullWidth: true,
              onPressed: isLoading ? null : () => ref.read(thawaniActionProvider.notifier).disconnect(),
            ),
          ],
        ],
      ),
    };
  }

  Widget _buildOrders() {
    final ordersState = ref.watch(thawaniOrdersProvider);

    // Load orders when tab is shown
    if (ordersState is ThawaniOrdersInitial) {
      Future.microtask(() => ref.read(thawaniOrdersProvider.notifier).load(perPage: 5));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(l10n.thawaniOrdersQueue, style: AppTypography.headlineSmall),
              PosButton(
                label: l10n.thawaniViewAllOrders,
                icon: Icons.arrow_forward,
                variant: PosButtonVariant.ghost,
                onPressed: () => context.push(Routes.thawaniOrders),
              ),
            ],
          ),
          AppSpacing.gapH12,
          switch (ordersState) {
            ThawaniOrdersLoading() => const Center(child: CircularProgressIndicator()),
            ThawaniOrdersError() => PosEmptyState(
              title: l10n.thawaniNoOrders,
              subtitle: l10n.thawaniNoOrdersDesc,
              icon: Icons.receipt_long,
            ),
            ThawaniOrdersLoaded(:final orders) when orders.isEmpty => PosEmptyState(
              title: l10n.thawaniNoOrders,
              subtitle: l10n.thawaniNoOrdersDesc,
              icon: Icons.receipt_long,
            ),
            ThawaniOrdersLoaded(:final orders) => Column(
              children: orders.take(5).map((raw) {
                final o = raw as Map<String, dynamic>;
                final status = o['status'] as String? ?? '';
                final variant = switch (status) {
                  'new' => PosStatusBadgeVariant.warning,
                  'accepted' => PosStatusBadgeVariant.info,
                  'preparing' => PosStatusBadgeVariant.info,
                  'ready' => PosStatusBadgeVariant.success,
                  'dispatched' => PosStatusBadgeVariant.info,
                  'completed' => PosStatusBadgeVariant.success,
                  'rejected' => PosStatusBadgeVariant.error,
                  _ => PosStatusBadgeVariant.neutral,
                };
                return PosCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    dense: true,
                    leading: const Icon(Icons.receipt_long_outlined),
                    title: Text(o['thawani_order_number'] as String? ?? '-'),
                    subtitle: Text(o['customer_name'] as String? ?? '-'),
                    trailing: PosStatusBadge(label: status, variant: variant),
                    onTap: () => context.push(Routes.thawaniOrders),
                  ),
                );
              }).toList(),
            ),
            _ => const SizedBox.shrink(),
          },
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return PosCard(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      borderRadius: AppRadius.borderMd,
      border: Border.fromBorderSide(BorderSide(color: Theme.of(context).dividerColor)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: AppColors.mutedFor(context))),
        trailing: Icon(Icons.chevron_right, color: AppColors.mutedFor(context)),
        onTap: onTap,
      ),
    );
  }
}
