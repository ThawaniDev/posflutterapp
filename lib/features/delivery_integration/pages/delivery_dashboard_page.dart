import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';
import 'package:wameedpos/features/delivery_integration/widgets/delivery_stats_widget.dart';
import 'package:wameedpos/features/delivery_integration/widgets/delivery_platform_card.dart';
import 'package:wameedpos/features/delivery_integration/widgets/delivery_order_card.dart';

class DeliveryDashboardPage extends ConsumerStatefulWidget {
  const DeliveryDashboardPage({super.key});

  @override
  ConsumerState<DeliveryDashboardPage> createState() => _DeliveryDashboardPageState();
}

class _DeliveryDashboardPageState extends ConsumerState<DeliveryDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(deliveryStatsProvider.notifier).load();
      ref.read(deliveryConfigsProvider.notifier).load();
      ref.read(deliveryOrdersProvider.notifier).load();
    });
  }

  void _refreshAll() {
    ref.read(deliveryStatsProvider.notifier).load();
    ref.read(deliveryConfigsProvider.notifier).load();
    ref.read(deliveryOrdersProvider.notifier).load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statsState = ref.watch(deliveryStatsProvider);

    return PosListPage(
      title: l10n.deliveryIntegration,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showDeliveryDashboardInfo(context),
        ),
        PosButton.icon(icon: Icons.sync, tooltip: l10n.deliveryMenuSync, onPressed: () => context.push(Routes.deliveryMenuSync)),
        PosButton.icon(icon: Icons.refresh, onPressed: _refreshAll),
      ],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.deliveryOverview),
              PosTabItem(label: l10n.deliveryPlatforms),
              PosTabItem(label: l10n.deliveryOrders),
            ],
          ),
          Expanded(
            child: IndexedStack(index: _currentTab, children: [_buildOverview(statsState), _buildPlatforms(), _buildOrders()]),
          ),
        ],
      ),
    );
  }

  Widget _buildOverview(DeliveryStatsState state) {
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      DeliveryStatsInitial() || DeliveryStatsLoading() => Center(child: PosLoadingSkeleton.list()),
      DeliveryStatsError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(deliveryStatsProvider.notifier).load(),
      ),
      DeliveryStatsLoaded(
        :final totalPlatforms,
        :final activePlatforms,
        // ignore: unused_local_variable
        :final totalOrders,
        :final pendingOrders,
        :final completedOrders,
        :final todayOrders,
        :final todayRevenue,
        :final activeOrders,
        :final platformBreakdown,
      ) =>
        RefreshIndicator(
          onRefresh: () => ref.read(deliveryStatsProvider.notifier).load(),
          child: ListView(
            padding: AppSpacing.paddingAll16,
            children: [
              DeliveryStatsWidget(
                todayOrders: todayOrders,
                todayRevenue: todayRevenue,
                activeOrders: activeOrders,
                pendingOrders: pendingOrders,
                completedOrders: completedOrders,
                activePlatforms: activePlatforms,
                totalPlatforms: totalPlatforms,
              ),
              if (platformBreakdown.isNotEmpty) ...[
                AppSpacing.gapH24,
                Text(l10n.deliveryPlatformBreakdown, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                AppSpacing.gapH12,
                ...platformBreakdown.map((p) => _PlatformBreakdownTile(data: p)),
              ],
              AppSpacing.gapH24,
              Text(l10n.deliveryQuickActions, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.add_circle_outline,
                      label: l10n.deliveryAddPlatform,
                      color: AppColors.primary,
                      onTap: () => context.push(Routes.deliveryConfig),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.sync,
                      label: l10n.deliveryMenuSync,
                      color: AppColors.info,
                      onTap: () => context.push(Routes.deliveryMenuSync),
                    ),
                  ),
                ],
              ),
              if (pendingOrders > 0) ...[
                AppSpacing.gapH12,
                _ActionCard(
                  icon: Icons.pending_actions,
                  label: '${l10n.deliveryViewPending} ($pendingOrders)',
                  color: AppColors.warning,
                  onTap: () {
                    setState(() => _currentTab = 2);
                    ref.read(deliveryOrdersProvider.notifier).load(status: 'pending');
                  },
                ),
              ],
              AppSpacing.gapH12,
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.webhook,
                      label: l10n.deliveryWebhookLogs,
                      color: AppColors.purple,
                      onTap: () => context.push(Routes.deliveryWebhookLogs),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: _ActionCard(
                      icon: Icons.send,
                      label: l10n.deliveryStatusPushLogs,
                      color: AppColors.rose,
                      onTap: () => context.push(Routes.deliveryStatusPushLogs),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    };
  }

  Widget _buildPlatforms() {
    final l10n = AppLocalizations.of(context)!;
    final configsState = ref.watch(deliveryConfigsProvider);

    return switch (configsState) {
      DeliveryConfigsInitial() || DeliveryConfigsLoading() => Center(child: PosLoadingSkeleton.list()),
      DeliveryConfigsError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(deliveryConfigsProvider.notifier).load(),
      ),
      DeliveryConfigsLoaded(:final configs) =>
        configs.isEmpty
            ? PosEmptyState(
                title: l10n.deliveryNoPlatforms,
                subtitle: l10n.deliveryConfigurePlatform,
                icon: Icons.link_off,
                actionLabel: l10n.deliveryAddPlatform,
                onAction: () => context.push(Routes.deliveryConfig),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(deliveryConfigsProvider.notifier).load(),
                child: ListView.builder(
                  padding: AppSpacing.paddingAll16,
                  itemCount: configs.length + 1,
                  itemBuilder: (context, index) {
                    if (index == configs.length) {
                      return Padding(
                        padding: AppSpacing.paddingV16,
                        child: PosButton(
                          onPressed: () => context.push(Routes.deliveryConfig),
                          variant: PosButtonVariant.outline,
                          icon: Icons.add,
                          label: l10n.deliveryAddPlatform,
                        ),
                      );
                    }
                    final config = configs[index];
                    final id = '${config['id'] ?? ''}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: DeliveryPlatformCard(
                        config: config,
                        onToggle: id.isNotEmpty ? () => ref.read(deliveryConfigsProvider.notifier).toggle(id) : null,
                        onTap: () => context.push('${Routes.deliveryConfig}/$id'),
                        onTestConnection: id.isNotEmpty ? () => _testConnection(id) : null,
                      ),
                    );
                  },
                ),
              ),
    };
  }

  Widget _buildOrders() {
    final l10n = AppLocalizations.of(context)!;
    final ordersState = ref.watch(deliveryOrdersProvider);

    return Column(
      children: [
        // Filter bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _FilterChip(
                label: l10n.deliveryAll,
                isSelected: ref.read(deliveryOrdersProvider.notifier).statusFilter == null,
                onTap: () => ref.read(deliveryOrdersProvider.notifier).load(),
              ),
              AppSpacing.gapW8,
              _FilterChip(
                label: l10n.deliveryPending,
                isSelected: ref.read(deliveryOrdersProvider.notifier).statusFilter == 'pending',
                onTap: () => ref.read(deliveryOrdersProvider.notifier).load(status: 'pending'),
                color: AppColors.warning,
              ),
              AppSpacing.gapW8,
              _FilterChip(
                label: l10n.deliveryActive,
                isSelected: ref.read(deliveryOrdersProvider.notifier).statusFilter == 'accepted',
                onTap: () => ref.read(deliveryOrdersProvider.notifier).loadActive(),
                color: AppColors.info,
              ),
              AppSpacing.gapW8,
              _FilterChip(
                label: l10n.deliveryCompleted,
                isSelected: ref.read(deliveryOrdersProvider.notifier).statusFilter == 'delivered',
                onTap: () => ref.read(deliveryOrdersProvider.notifier).load(status: 'delivered'),
                color: AppColors.success,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: switch (ordersState) {
            DeliveryOrdersInitial() || DeliveryOrdersLoading() => Center(child: PosLoadingSkeleton.list()),
            DeliveryOrdersError(:final message) => PosErrorState(
              message: message,
              onRetry: () => ref.read(deliveryOrdersProvider.notifier).load(),
            ),
            DeliveryOrdersLoaded(:final orders) =>
              orders.isEmpty
                  ? PosEmptyState(title: l10n.deliveryNoOrders, icon: Icons.receipt_long)
                  : RefreshIndicator(
                      onRefresh: () => ref
                          .read(deliveryOrdersProvider.notifier)
                          .load(
                            platform: ref.read(deliveryOrdersProvider.notifier).platformFilter,
                            status: ref.read(deliveryOrdersProvider.notifier).statusFilter,
                          ),
                      child: ListView.builder(
                        padding: AppSpacing.paddingAll16,
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          final orderId = '${order['id'] ?? ''}';
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: DeliveryOrderCard(
                              order: order,
                              onTap: orderId.isNotEmpty ? () => context.push('${Routes.deliveryOrderDetail}/$orderId') : null,
                              onStatusAction: orderId.isNotEmpty ? (status) => _updateOrderStatus(orderId, status) : null,
                            ),
                          );
                        },
                      ),
                    ),
          },
        ),
      ],
    );
  }

  Future<void> _testConnection(String configId) async {
    ref.read(deliveryConnectionTestProvider.notifier).test(configId);

    if (!mounted) return;
    final state = ref.read(deliveryConnectionTestProvider);
    final msg = switch (state) {
      DeliveryConnectionTestSuccess(:final message) => message,
      DeliveryConnectionTestFailure(:final message) => message,
      _ => null,
    };
    if (msg != null) {
      showPosInfoSnackbar(context, msg);
    }
  }

  Future<void> _updateOrderStatus(String orderId, String status) async {
    if (status == 'rejected') {
      final reason = await _showRejectDialog();
      if (reason == null) return;
      await ref.read(deliveryOrdersProvider.notifier).updateOrderStatus(orderId, status: status, rejectionReason: reason);
    } else {
      await ref.read(deliveryOrdersProvider.notifier).updateOrderStatus(orderId, status: status);
    }
    ref.read(deliveryStatsProvider.notifier).load();
  }

  Future<String?> _showRejectDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deliveryRejectOrder),
        content: PosTextField(controller: controller, hint: l10n.deliveryEnterRejectionReason, maxLines: 3),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.deliveryCancel),
          PosButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            variant: PosButtonVariant.danger,
            label: l10n.deliveryReject,
          ),
        ],
      ),
    );
  }
}

// ─── Supporting Widgets ─────────────────────────────────

class _PlatformBreakdownTile extends StatelessWidget {
  const _PlatformBreakdownTile({required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final name = data['label'] as String? ?? data['platform'] as String? ?? '';
    final orders = data['orders'] as int? ?? 0;
    final revenue = (data['revenue'] != null ? double.tryParse(data['revenue'].toString()) : null) ?? 0.0;
    final isActive = data['is_active'] == true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = AppColors.mutedFor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppSpacing.paddingAll12,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: isActive ? AppColors.success : mutedColor, shape: BoxShape.circle),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(AppLocalizations.of(context)!.deliveryOrdersCount(orders), style: TextStyle(fontSize: 12, color: mutedColor)),
          AppSpacing.gapW16,
          Text('${revenue.toStringAsFixed(2)} \u0081', style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {

  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      elevation: 0,
      borderRadius: AppRadius.borderLg,
      border: Border.fromBorderSide(BorderSide(color: color.withValues(alpha: 0.3))),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Row(
            children: [
              Icon(icon, color: color),
              AppSpacing.gapW12,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(fontWeight: FontWeight.w500, color: color),
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {

  const _FilterChip({required this.label, required this.isSelected, required this.onTap, this.color});
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = AppColors.mutedFor(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: AppRadius.borderFull,
          border: Border.all(color: isSelected ? chipColor : Theme.of(context).dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? chipColor : mutedColor,
          ),
        ),
      ),
    );
  }
}
