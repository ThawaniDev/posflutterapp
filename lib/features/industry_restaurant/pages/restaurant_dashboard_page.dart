import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_providers.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_state.dart';
import 'package:wameedpos/features/industry_restaurant/widgets/table_grid_tile.dart';
import 'package:wameedpos/features/industry_restaurant/widgets/kitchen_ticket_card.dart';
import 'package:wameedpos/features/industry_restaurant/widgets/reservation_card.dart';
import 'package:wameedpos/features/industry_restaurant/widgets/open_tab_card.dart';
import 'package:wameedpos/features/industry_restaurant/pages/table_form_page.dart';
import 'package:wameedpos/features/industry_restaurant/pages/reservation_form_page.dart';
import 'package:wameedpos/features/industry_restaurant/pages/open_tab_form_page.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class RestaurantDashboardPage extends ConsumerStatefulWidget {
  const RestaurantDashboardPage({super.key});

  @override
  ConsumerState<RestaurantDashboardPage> createState() => _RestaurantDashboardPageState();
}

class _RestaurantDashboardPageState extends ConsumerState<RestaurantDashboardPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(restaurantProvider.notifier).load());
  }

  void _onFabPressed() {
    final page = switch (_currentTab) {
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
    final isLoading = state is RestaurantInitial || state is RestaurantLoading;
    final hasError = state is RestaurantError;
    final showAdd = _currentTab != 1;

    return PosListPage(
      title: l10n.restaurantTitle,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(restaurantProvider.notifier).load(),
      actions: showAdd ? [PosButton(label: l10n.add, icon: Icons.add, onPressed: _onFabPressed)] : const [],
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.restaurantTables),
              PosTabItem(label: 'Kitchen'),
              PosTabItem(label: l10n.restaurantReservations),
              PosTabItem(label: l10n.restaurantOpenTabs),
            ],
          ),
          Expanded(
            child: state is RestaurantLoaded
                ? IndexedStack(
                    index: _currentTab,
                    children: [
                      state.tables.isEmpty
                          ? const PosEmptyState(title: 'No tables configured', icon: Icons.table_bar)
                          : GridView.builder(
                              padding: const EdgeInsets.all(16),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                              ),
                              itemCount: state.tables.length,
                              itemBuilder: (context, i) {
                                final t = state.tables[i];
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
                      state.kitchenTickets.isEmpty
                          ? const PosEmptyState(title: 'No kitchen tickets', icon: Icons.restaurant)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.kitchenTickets.length,
                              itemBuilder: (context, i) {
                                final k = state.kitchenTickets[i];
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
                      state.reservations.isEmpty
                          ? const PosEmptyState(title: 'No reservations', icon: Icons.event_seat)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.reservations.length,
                              itemBuilder: (context, i) {
                                final r = state.reservations[i];
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
                      state.openTabs.isEmpty
                          ? const PosEmptyState(title: 'No open tabs', icon: Icons.receipt_long)
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: state.openTabs.length,
                              itemBuilder: (context, i) {
                                final tab = state.openTabs[i];
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
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
