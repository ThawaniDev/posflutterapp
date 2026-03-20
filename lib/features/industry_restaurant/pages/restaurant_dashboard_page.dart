import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/industry_restaurant/providers/restaurant_providers.dart';
import 'package:thawani_pos/features/industry_restaurant/providers/restaurant_state.dart';
import 'package:thawani_pos/features/industry_restaurant/widgets/table_grid_tile.dart';
import 'package:thawani_pos/features/industry_restaurant/widgets/kitchen_ticket_card.dart';
import 'package:thawani_pos/features/industry_restaurant/widgets/reservation_card.dart';
import 'package:thawani_pos/features/industry_restaurant/widgets/open_tab_card.dart';
import 'package:thawani_pos/features/industry_restaurant/pages/table_form_page.dart';
import 'package:thawani_pos/features/industry_restaurant/pages/reservation_form_page.dart';
import 'package:thawani_pos/features/industry_restaurant/pages/open_tab_form_page.dart';

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
    _tabController.addListener(() => setState(() {}));
    Future.microtask(() => ref.read(restaurantProvider.notifier).load());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onFabPressed() {
    final page = switch (_tabController.index) {
      0 => const TableFormPage(),
      2 => const ReservationFormPage(),
      3 => const OpenTabFormPage(),
      _ => null,
    };
    if (page == null) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page)).then((_) {
      ref.read(restaurantProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(restaurantProvider);
    final showFab = _tabController.index != 1; // No FAB for Kitchen tab

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
      floatingActionButton: showFab ? FloatingActionButton(onPressed: _onFabPressed, child: const Icon(Icons.add)) : null,
      body: switch (state) {
        RestaurantInitial() || RestaurantLoading() => const PosLoadingSkeleton(),
        RestaurantError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(restaurantProvider.notifier).load(),
        ),
        RestaurantLoaded(:final tables, :final kitchenTickets, :final reservations, :final openTabs) => TabBarView(
          controller: _tabController,
          children: [
            // --- Tables (GridView) ---
            tables.isEmpty
                ? const PosEmptyState(message: 'No tables configured', icon: Icons.table_bar)
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
                      return TableGridTile(
                        table: t,
                        onTap: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (_) => TableFormPage(table: t)))
                              .then((_) => ref.read(restaurantProvider.notifier).load());
                        },
                      );
                    },
                  ),
            // --- Kitchen Tickets ---
            kitchenTickets.isEmpty
                ? const PosEmptyState(message: 'No kitchen tickets', icon: Icons.restaurant)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: kitchenTickets.length,
                    itemBuilder: (context, i) {
                      final k = kitchenTickets[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: KitchenTicketCard(
                          ticket: k,
                          onStatusChange: (newStatus) {
                            ref.read(restaurantProvider.notifier).updateKitchenTicketStatus(k.id, newStatus.value);
                          },
                        ),
                      );
                    },
                  ),
            // --- Reservations ---
            reservations.isEmpty
                ? const PosEmptyState(message: 'No reservations', icon: Icons.event_seat)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: reservations.length,
                    itemBuilder: (context, i) {
                      final r = reservations[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: ReservationCard(
                          reservation: r,
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => ReservationFormPage(reservation: r)))
                                .then((_) => ref.read(restaurantProvider.notifier).load());
                          },
                        ),
                      );
                    },
                  ),
            // --- Open Tabs ---
            openTabs.isEmpty
                ? const PosEmptyState(message: 'No open tabs', icon: Icons.receipt_long)
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: openTabs.length,
                    itemBuilder: (context, i) {
                      final tab = openTabs[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OpenTabCard(
                          tab: tab,
                          onClose: () {
                            ref.read(restaurantProvider.notifier).closeTab(tab.id);
                          },
                        ),
                      );
                    },
                  ),
          ],
        ),
      },
    );
  }
}
