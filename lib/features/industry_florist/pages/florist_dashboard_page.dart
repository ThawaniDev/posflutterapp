import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_florist/providers/florist_providers.dart';
import 'package:thawani_pos/features/industry_florist/providers/florist_state.dart';

class FloristDashboardPage extends ConsumerStatefulWidget {
  const FloristDashboardPage({super.key});

  @override
  ConsumerState<FloristDashboardPage> createState() => _FloristDashboardPageState();
}

class _FloristDashboardPageState extends ConsumerState<FloristDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() => ref.read(floristProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(floristProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Florist'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Arrangements'),
            Tab(text: 'Freshness'),
            Tab(text: 'Subscriptions'),
          ],
        ),
      ),
      body: switch (state) {
        FloristInitial() || FloristLoading() => const Center(child: CircularProgressIndicator()),
        FloristError(:final message) => Center(child: Text(message)),
        FloristLoaded(:final arrangements, :final freshnessLogs, :final subscriptions) => TabBarView(
          controller: _tabController,
          children: [
            arrangements.isEmpty
                ? const Center(child: Text('No arrangements'))
                : ListView.builder(
                    itemCount: arrangements.length,
                    itemBuilder: (context, i) {
                      final a = arrangements[i];
                      return ListTile(
                        title: Text(a.name),
                        subtitle: Text(a.occasion ?? 'General'),
                        trailing: Text('${a.totalPrice.toStringAsFixed(2)} OMR'),
                        leading: a.isTemplate == true
                            ? const Icon(Icons.bookmark, color: Colors.amber)
                            : const Icon(Icons.local_florist),
                      );
                    },
                  ),
            freshnessLogs.isEmpty
                ? const Center(child: Text('No freshness logs'))
                : ListView.builder(
                    itemCount: freshnessLogs.length,
                    itemBuilder: (context, i) {
                      final l = freshnessLogs[i];
                      return ListTile(
                        title: Text('Product ${l.productId} • Qty: ${l.quantity}'),
                        subtitle: Text('Vase life: ${l.expectedVaseLifeDays} days • ${l.status?.value ?? 'fresh'}'),
                        trailing: Icon(
                          l.status?.value == 'disposed'
                              ? Icons.delete
                              : l.status?.value == 'marked_down'
                              ? Icons.trending_down
                              : Icons.eco,
                          color: l.status?.value == 'disposed'
                              ? Colors.red
                              : l.status?.value == 'marked_down'
                              ? Colors.orange
                              : Colors.green,
                        ),
                      );
                    },
                  ),
            subscriptions.isEmpty
                ? const Center(child: Text('No subscriptions'))
                : ListView.builder(
                    itemCount: subscriptions.length,
                    itemBuilder: (context, i) {
                      final s = subscriptions[i];
                      return ListTile(
                        title: Text('${s.frequency.value} — ${s.deliveryAddress}'),
                        subtitle: Text('${s.pricePerDelivery.toStringAsFixed(2)} OMR/delivery'),
                        trailing: s.isActive == true
                            ? const Chip(label: Text('Active'), backgroundColor: Colors.green)
                            : const Chip(label: Text('Inactive')),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
