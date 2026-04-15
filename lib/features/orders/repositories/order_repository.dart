import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/orders/data/remote/order_api_service.dart';
import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/models/sale_return.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepository(apiService: ref.watch(orderApiServiceProvider));
});

class OrderRepository {
  final OrderApiService _apiService;

  OrderRepository({required OrderApiService apiService}) : _apiService = apiService;

  // Orders
  Future<PaginatedResult<Order>> listOrders({int page = 1, int perPage = 20, String? status, String? source, String? search}) =>
      _apiService.listOrders(page: page, perPage: perPage, status: status, source: source, search: search);
  Future<Order> getOrder(String id) => _apiService.getOrder(id);
  Future<Order> createOrder(Map<String, dynamic> data) => _apiService.createOrder(data);
  Future<Order> updateOrderStatus(String id, String status) => _apiService.updateOrderStatus(id, status);
  Future<Order> voidOrder(String id) => _apiService.voidOrder(id);

  // Returns
  Future<PaginatedResult<SaleReturn>> listReturns({int page = 1, int perPage = 20}) =>
      _apiService.listReturns(page: page, perPage: perPage);
  Future<SaleReturn> createReturn(Map<String, dynamic> data) => _apiService.createReturn(data);
  Future<SaleReturn> getReturn(String id) => _apiService.getReturn(id);
}
