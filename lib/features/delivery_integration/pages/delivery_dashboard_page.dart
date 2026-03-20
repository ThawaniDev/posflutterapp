import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final statsState = ref.watch(deliveryStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.deliveryIntegration),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(deliveryStatsProvider.notifier).load();
              ref.read(deliveryConfigsProvider.notifier).load();
              ref.read(deliveryOrdersProvider.notifier).load();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.deliveryOverview),
            Tab(text: AppLocalizations.of(context)!.deliveryPlatforms),
            Tab(text: AppLocalizations.of(context)!.deliveryOrders),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_buildOverview(statsState), _buildPlatforms(), _buildOrders()]),
    );
  }

  Widget _buildOverview(DeliveryStatsState state) {
    return switch (state) {
      DeliveryStatsInitial() || DeliveryStatsLoading() => const Center(child: CircularProgressIndicator()),
      DeliveryStatsError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      DeliveryStatsLoaded(
        :final totalPlatforms,
        :final activePlatforms,
        :final totalOrders,
        :final pendingOrders,
        :final completedOrders,
      ) =>
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                _statCard(
                  AppLocalizations.of(context)!.deliveryPlatforms,
                  '$activePlatforms/$totalPlatforms',
                  Icons.delivery_dining,
                  Colors.blue,
                ),
                const SizedBox(width: 12),
                _statCard(AppLocalizations.of(context)!.deliveryTotalOrders, '$totalOrders', Icons.receipt_long, Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _statCard(AppLocalizations.of(context)!.deliveryPending, '$pendingOrders', Icons.pending, Colors.orange),
                const SizedBox(width: 12),
                _statCard(AppLocalizations.of(context)!.deliveryCompleted, '$completedOrders', Icons.check_circle, Colors.green),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.deliverySupportedPlatforms,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _platformTile('Talabat', 'talabat', Icons.delivery_dining, Colors.orange),
            _platformTile('Deliveroo', 'deliveroo', Icons.pedal_bike, Colors.teal),
            _platformTile('Careem', 'careem', Icons.local_taxi, Colors.green),
            _platformTile('Toters', 'toters', Icons.shopping_bag, Colors.purple),
            _platformTile('Jahez', 'jahez', Icons.fastfood, Colors.red),
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
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _platformTile(String name, String key, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(name),
        subtitle: Text(AppLocalizations.of(context)!.deliveryConnectAccount(name)),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }

  Widget _buildPlatforms() {
    final configsState = ref.watch(deliveryConfigsProvider);

    return switch (configsState) {
      DeliveryConfigsInitial() || DeliveryConfigsLoading() => const Center(child: CircularProgressIndicator()),
      DeliveryConfigsError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      DeliveryConfigsLoaded(:final configs) =>
        configs.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.link_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.deliveryNoPlatforms,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.deliveryConfigurePlatform, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: configs.length,
                itemBuilder: (context, index) {
                  final config = configs[index];
                  final isEnabled = config['is_enabled'] == true;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isEnabled ? Colors.green.withValues(alpha: 0.15) : Colors.grey.withValues(alpha: 0.15),
                        child: Icon(Icons.delivery_dining, color: isEnabled ? Colors.green : Colors.grey),
                      ),
                      title: Text(config['platform'] as String? ?? ''),
                      subtitle: Text(
                        isEnabled ? 'Active • Auto-accept: ${config['auto_accept'] == true ? 'On' : 'Off'}' : 'Disabled',
                      ),
                      trailing: Switch(
                        value: isEnabled,
                        onChanged: (_) {
                          final id = config['id'] as String? ?? '';
                          if (id.isNotEmpty) ref.read(deliveryConfigsProvider.notifier).toggle(id);
                        },
                      ),
                    ),
                  );
                },
              ),
    };
  }

  Widget _buildOrders() {
    final ordersState = ref.watch(deliveryOrdersProvider);

    return switch (ordersState) {
      DeliveryOrdersInitial() || DeliveryOrdersLoading() => const Center(child: CircularProgressIndicator()),
      DeliveryOrdersError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      DeliveryOrdersLoaded(:final orders) =>
        orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.deliveryNoOrders,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final status = order['delivery_status'] as String? ?? 'pending';
                  final statusColor = switch (status) {
                    'pending' => Colors.orange,
                    'accepted' => Colors.blue,
                    'preparing' => Colors.amber,
                    'ready' => Colors.teal,
                    'picked_up' => Colors.purple,
                    'delivered' => Colors.green,
                    'cancelled' => Colors.red,
                    _ => Colors.grey,
                  };
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: statusColor.withValues(alpha: 0.15),
                        child: Icon(Icons.receipt, color: statusColor),
                      ),
                      title: Text(order['platform_order_id'] as String? ?? 'Order'),
                      subtitle: Text(order['platform'] as String? ?? ''),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(status.replaceAll('_', ' '), style: TextStyle(fontSize: 11, color: statusColor)),
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
