import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(thawaniActionProvider.notifier).reset();
        ref.read(thawaniStatsProvider.notifier).load();
        ref.read(thawaniConfigProvider.notifier).load();
      } else if (next is ThawaniActionError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message), backgroundColor: Colors.red));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.thawaniPay),
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
      ThawaniStatsInitial() || ThawaniStatsLoading() => const Center(child: CircularProgressIndicator()),
      ThawaniStatsError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      ThawaniStatsLoaded(
        :final isConnected,
        :final thawaniStoreId,
        :final totalOrders,
        :final totalProductsMapped,
        :final totalSettlements,
        :final pendingOrders,
      ) =>
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Connection status banner
            Card(
              color: isConnected ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(isConnected ? Icons.link : Icons.link_off, color: isConnected ? Colors.green : Colors.orange, size: 32),
                    const SizedBox(width: 12),
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
                              color: isConnected ? Colors.green : Colors.orange,
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
            const SizedBox(height: 16),
            // Stats grid
            Row(
              children: [
                _statCard(AppLocalizations.of(context)!.thawaniTotalOrders, '$totalOrders', Icons.receipt, Colors.blue),
                const SizedBox(width: 12),
                _statCard(AppLocalizations.of(context)!.thawaniProducts, '$totalProductsMapped', Icons.inventory, Colors.purple),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _statCard(
                  AppLocalizations.of(context)!.thawaniSettlements,
                  '$totalSettlements',
                  Icons.account_balance,
                  Colors.teal,
                ),
                const SizedBox(width: 12),
                _statCard(AppLocalizations.of(context)!.thawaniPendingOrders, '$pendingOrders', Icons.pending, Colors.orange),
              ],
            ),
          ],
        ),
    };
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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
      ThawaniConfigInitial() || ThawaniConfigLoading() => const Center(child: CircularProgressIndicator()),
      ThawaniConfigError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
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
              icon: const Icon(Icons.link_off, color: Colors.red),
              label: Text(AppLocalizations.of(context)!.thawaniDisconnect, style: const TextStyle(color: Colors.red)),
              style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.red)),
            ),
        ],
      ),
    };
  }

  Widget _buildOrders() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.thawaniOrdersPlaceholder, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(AppLocalizations.of(context)!.thawaniOrdersDesc, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
