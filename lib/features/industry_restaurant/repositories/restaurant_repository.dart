import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/industry_restaurant/data/remote/restaurant_api_service.dart';
import 'package:thawani_pos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:thawani_pos/features/industry_restaurant/models/kitchen_ticket.dart';
import 'package:thawani_pos/features/industry_restaurant/models/table_reservation.dart';
import 'package:thawani_pos/features/industry_restaurant/models/open_tab.dart';

final restaurantRepositoryProvider = Provider<RestaurantRepository>((ref) {
  return RestaurantRepository(apiService: ref.watch(restaurantApiServiceProvider));
});

class RestaurantRepository {
  final RestaurantApiService _apiService;
  RestaurantRepository({required RestaurantApiService apiService}) : _apiService = apiService;

  Future<List<RestaurantTable>> listTables({int perPage = 50}) => _apiService.listTables(perPage: perPage);
  Future<RestaurantTable> createTable(Map<String, dynamic> data) => _apiService.createTable(data);
  Future<RestaurantTable> updateTable(String id, Map<String, dynamic> data) => _apiService.updateTable(id, data);
  Future<RestaurantTable> updateTableStatus(String id, String status) => _apiService.updateTableStatus(id, status);

  Future<List<KitchenTicket>> listKitchenTickets({String? status, int perPage = 50}) =>
      _apiService.listKitchenTickets(status: status, perPage: perPage);
  Future<KitchenTicket> createKitchenTicket(Map<String, dynamic> data) => _apiService.createKitchenTicket(data);
  Future<KitchenTicket> updateKitchenTicketStatus(String id, String status) => _apiService.updateKitchenTicketStatus(id, status);

  Future<List<TableReservation>> listReservations({String? status, String? date, int perPage = 20}) =>
      _apiService.listReservations(status: status, date: date, perPage: perPage);
  Future<TableReservation> createReservation(Map<String, dynamic> data) => _apiService.createReservation(data);
  Future<TableReservation> updateReservation(String id, Map<String, dynamic> data) => _apiService.updateReservation(id, data);
  Future<TableReservation> updateReservationStatus(String id, String status) => _apiService.updateReservationStatus(id, status);

  Future<List<OpenTab>> listTabs({int perPage = 50}) => _apiService.listTabs(perPage: perPage);
  Future<OpenTab> openTab(Map<String, dynamic> data) => _apiService.openTab(data);
  Future<OpenTab> closeTab(String id) => _apiService.closeTab(id);
}
