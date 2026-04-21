import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/industry_restaurant/models/restaurant_table.dart';
import 'package:wameedpos/features/industry_restaurant/models/kitchen_ticket.dart';
import 'package:wameedpos/features/industry_restaurant/models/table_reservation.dart';
import 'package:wameedpos/features/industry_restaurant/models/open_tab.dart';

final restaurantApiServiceProvider = Provider<RestaurantApiService>((ref) {
  return RestaurantApiService(ref.watch(dioClientProvider));
});

class RestaurantApiService {
  RestaurantApiService(this._dio);
  final Dio _dio;

  // Tables
  Future<List<RestaurantTable>> listTables({int perPage = 50}) async {
    final response = await _dio.get(ApiEndpoints.restaurantTables, queryParameters: {'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => RestaurantTable.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<RestaurantTable> createTable(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.restaurantTables, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RestaurantTable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<RestaurantTable> updateTable(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.restaurantTable(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RestaurantTable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<RestaurantTable> updateTableStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.restaurantTableStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return RestaurantTable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // Kitchen Tickets
  Future<List<KitchenTicket>> listKitchenTickets({String? status, int perPage = 50}) async {
    final response = await _dio.get(
      ApiEndpoints.restaurantKitchenTickets,
      queryParameters: {'per_page': perPage, 'status': ?status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => KitchenTicket.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<KitchenTicket> createKitchenTicket(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.restaurantKitchenTickets, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return KitchenTicket.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<KitchenTicket> updateKitchenTicketStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.restaurantKitchenTicketStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return KitchenTicket.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // Reservations
  Future<List<TableReservation>> listReservations({String? status, String? date, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.restaurantReservations,
      queryParameters: {'per_page': perPage, 'status': ?status, 'date': ?date},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => TableReservation.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<TableReservation> createReservation(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.restaurantReservations, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TableReservation.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<TableReservation> updateReservation(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.restaurantReservation(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TableReservation.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<TableReservation> updateReservationStatus(String id, String status) async {
    final response = await _dio.patch(ApiEndpoints.restaurantReservationStatus(id), data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TableReservation.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // Open Tabs
  Future<List<OpenTab>> listTabs({int perPage = 50}) async {
    final response = await _dio.get(ApiEndpoints.restaurantTabs, queryParameters: {'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => OpenTab.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<OpenTab> openTab(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.restaurantTabs, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return OpenTab.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<OpenTab> closeTab(String id) async {
    final response = await _dio.patch(ApiEndpoints.restaurantTabClose(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return OpenTab.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
