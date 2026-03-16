import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_restaurant/providers/restaurant_providers.dart';
import 'package:thawani_pos/features/industry_restaurant/providers/restaurant_state.dart';

class RestaurantDashboardPage extends ConsumerStatefulWidget {
  const RestaurantDashboardPage({super.key});

  @override
  ConsumerState<RestaurantDashboardPage> createState() => _RestaurantDashboardPageState();
}

class _RestaurantDashboardPageState extends ConsumerState<RestaurantDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() => ref.read(restaurantProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Tables'),
            Tab(text: 'Kitchen'),
            Tab(text: 'Reservations'),
            Tab(text: 'Open Tabs'),
          ],
        ),
      ),
      body: switch (state) {
        RestaurantInitial() || RestaurantLoading() => const Center(child: CircularProgressIndicator()),
        RestaurantError(:final message) => Center(child: Text(message)),
        RestaurantLoaded(:final tables, :final kitchenTickets, :final reservations, :final openTabs) => TabBarView(
          controller: _tabController,
          children: [
            tables.isEmpty
                ? const Center(child: Text('No tables'))
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: tables.length,
                    itemBuilder: (context, i) {
                      final t = tables[i];
                      final color = switch (t.status?.value) {
                        'occupied' => Colors.red.shade100,
                        'reserved' => Colors.amber.shade100,
                        'cleaning' => Colors.blue.shade100,
                        _ => Colors.green.shade100,
                      };
                      return Card(
                        color: color,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(t.displayName ?? t.tableNumber, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text('${t.seats} seats'),
                              if (t.zone != null) Text(t.zone!, style: const TextStyle(fontSize: 11)),
                              Text(t.status?.value ?? 'available', style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
            kitchenTickets.isEmpty
                ? const Center(child: Text('No kitchen tickets'))
                : ListView.builder(
                    itemCount: kitchenTickets.length,
                    itemBuilder: (context, i) {
                      final k = kitchenTickets[i];
                      return ListTile(
                        leading: CircleAvatar(child: Text('#${k.ticketNumber}')),
                        title: Text('Order ${k.orderId}${k.station != null ? ' • ${k.station}' : ''}'),
                        subtitle: Text('Course ${k.courseNumber ?? 1}'),
                        trailing: Chip(label: Text(k.status?.value ?? 'pending')),
                      );
                    },
                  ),
            reservations.isEmpty
                ? const Center(child: Text('No reservations'))
                : ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, i) {
                      final r = reservations[i];
                      return ListTile(
                        title: Text('${r.customerName} — Party of ${r.partySize}'),
                        subtitle: Text(
                          '${r.reservationTime}'
                          '${r.durationMinutes != null ? ' • ${r.durationMinutes}min' : ''}',
                        ),
                        trailing: Chip(label: Text(r.status?.value ?? 'confirmed')),
                      );
                    },
                  ),
            openTabs.isEmpty
                ? const Center(child: Text('No open tabs'))
                : ListView.builder(
                    itemCount: openTabs.length,
                    itemBuilder: (context, i) {
                      final tab = openTabs[i];
                      return ListTile(
                        title: Text(tab.customerName),
                        subtitle: Text('Order ${tab.orderId}'),
                        trailing: Chip(label: Text(tab.status?.value ?? 'open')),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
