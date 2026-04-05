import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';
import 'package:thawani_pos/features/delivery_integration/widgets/delivery_stats_widget.dart';
import 'package:thawani_pos/features/delivery_integration/widgets/delivery_platform_card.dart';
import 'package:thawani_pos/features/delivery_integration/widgets/delivery_order_card.dart';

class DeliveryDashboardPage extends ConsumerStatefulWidget {
  const DeliveryDashboardPage({super.key});

  @override
  ConsumerState<DeliveryDashboardPage> createState() => _DeliveryDashboardPageState();
}

class _DeliveryDashboardPageState extends ConsumerState<DeliveryDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(deliveryStatsProvider.notifier).load();
      ref.read(deliveryConfigsProvider.notifier).load();
      ref.read(deliveryOrdersProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryIntegration),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: l10n.deliveryMenuSync,
            onPressed: () => context.push(Routes.deliveryMenuSync),
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshAll),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.deliveryOverview),
            Tab(text: l10n.deliveryPlatforms),
            Tab(text: l10n.deliveryOrders),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_buildOverview(statsState), _buildPlatforms(), _buildOrders()]),
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
                    _tabController.animateTo(2);
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
                        child: OutlinedButton.icon(
                          onPressed: () => context.push(Routes.deliveryConfig),
                          icon: const Icon(Icons.add),
                          label: Text(l10n.deliveryAddPlatform),
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.deliveryEnterRejectionReason, border: const OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.deliveryCancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text), child: Text(l10n.deliveryReject)),
        ],
      ),
    );
  }
}

// ─── Supporting Widgets ─────────────────────────────────

class _PlatformBreakdownTile extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PlatformBreakdownTile({required this.data});

  @override
  Widget build(BuildContext context) {
    final name = data['label'] as String? ?? data['platform'] as String? ?? '';
    final orders = data['orders'] as int? ?? 0;
    final revenue = (data['revenue'] != null ? double.tryParse(data['revenue'].toString()) : null) ?? 0.0;
    final isActive = data['is_active'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: AppSpacing.paddingAll12,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: isActive ? AppColors.success : AppColors.textSecondary, shape: BoxShape.circle),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Text(
            AppLocalizations.of(context)!.deliveryOrdersCount(orders),
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          AppSpacing.gapW16,
          Text('${revenue.toStringAsFixed(2)} \u0081', style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({required this.label, required this.isSelected, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.full),
          border: Border.all(color: isSelected ? chipColor : Theme.of(context).dividerColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? chipColor : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
