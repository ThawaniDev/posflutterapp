import 'package:thawani_pos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:thawani_pos/features/industry_restaurant/models/kitchen_ticket.dart';
import 'package:thawani_pos/features/industry_restaurant/models/table_reservation.dart';
import 'package:thawani_pos/features/industry_restaurant/models/open_tab.dart';

sealed class RestaurantState {
  const RestaurantState();
}

class RestaurantInitial extends RestaurantState {
  const RestaurantInitial();
}

class RestaurantLoading extends RestaurantState {
  const RestaurantLoading();
}

class RestaurantLoaded extends RestaurantState {
  final List<RestaurantTable> tables;
  final List<KitchenTicket> kitchenTickets;
  final List<TableReservation> reservations;
  final List<OpenTab> openTabs;

  const RestaurantLoaded({
    required this.tables,
    required this.kitchenTickets,
    required this.reservations,
    required this.openTabs,
  });

  RestaurantLoaded copyWith({
    List<RestaurantTable>? tables,
    List<KitchenTicket>? kitchenTickets,
    List<TableReservation>? reservations,
    List<OpenTab>? openTabs,
  }) => RestaurantLoaded(
    tables: tables ?? this.tables,
    kitchenTickets: kitchenTickets ?? this.kitchenTickets,
    reservations: reservations ?? this.reservations,
    openTabs: openTabs ?? this.openTabs,
  );
}

class RestaurantError extends RestaurantState {
  final String message;
  const RestaurantError({required this.message});
}
