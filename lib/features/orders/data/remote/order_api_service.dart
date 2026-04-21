import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/models/sale_return.dart';

final orderApiServiceProvider = Provider<OrderApiService>((ref) {
  return OrderApiService(ref.watch(dioClientProvider));
});

class OrderApiService {

  OrderApiService(this._dio);
  final Dio _dio;

  // ─── Orders ───────────────────────────────────────────────────

  Future<PaginatedResult<Order>> listOrders({
    int page = 1,
    int perPage = 20,
    String? status,
    String? source,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.orders,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'status': ?status,
        'source': ?source,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Order.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Order> getOrder(String orderId) async {
    final response = await _dio.get('${ApiEndpoints.orders}/$orderId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Order.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Order> createOrder(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.orders, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Order.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Order> updateOrderStatus(String orderId, String status) async {
    final response = await _dio.put('${ApiEndpoints.orders}/$orderId/status', data: {'status': status});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Order.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Order> voidOrder(String orderId) async {
    final response = await _dio.put('${ApiEndpoints.orders}/$orderId/void');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Order.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Returns ──────────────────────────────────────────────────

  Future<PaginatedResult<SaleReturn>> listReturns({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.returns, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => SaleReturn.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<SaleReturn> createReturn(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.returns, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return SaleReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<SaleReturn> getReturn(String returnId) async {
    final response = await _dio.get('${ApiEndpoints.returns}/$returnId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return SaleReturn.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
