import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/industry_restaurant/providers/restaurant_state.dart';
import 'package:wameedpos/features/industry_restaurant/repositories/restaurant_repository.dart';

final restaurantProvider = StateNotifierProvider<RestaurantNotifier, RestaurantState>((ref) {
  return RestaurantNotifier(ref.watch(restaurantRepositoryProvider));
});

class RestaurantNotifier extends StateNotifier<RestaurantState> {
  RestaurantNotifier(this._repo) : super(const RestaurantInitial());
  final RestaurantRepository _repo;

  Future<void> load() async {
    state = const RestaurantLoading();
    try {
      final tables = await _repo.listTables();
      final tickets = await _repo.listKitchenTickets();
      final reservations = await _repo.listReservations();
      final tabs = await _repo.listTabs();
      state = RestaurantLoaded(tables: tables, kitchenTickets: tickets, reservations: reservations, openTabs: tabs);
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    } catch (e) {
      state = RestaurantError(message: e.toString());
    }
  }

  Future<void> createTable(Map<String, dynamic> data) async {
    try {
      await _repo.createTable(data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> updateTable(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateTable(id, data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> updateTableStatus(String id, String status) async {
    try {
      await _repo.updateTableStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> createKitchenTicket(Map<String, dynamic> data) async {
    try {
      await _repo.createKitchenTicket(data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> updateKitchenTicketStatus(String id, String status) async {
    try {
      await _repo.updateKitchenTicketStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> createReservation(Map<String, dynamic> data) async {
    try {
      await _repo.createReservation(data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> updateReservation(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateReservation(id, data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> updateReservationStatus(String id, String status) async {
    try {
      await _repo.updateReservationStatus(id, status);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> openTab(Map<String, dynamic> data) async {
    try {
      await _repo.openTab(data);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }

  Future<void> closeTab(String id) async {
    try {
      await _repo.closeTab(id);
      await load();
    } on DioException catch (e) {
      state = RestaurantError(message: _extractError(e));
    }
  }
}

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
