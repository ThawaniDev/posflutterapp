import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/thawani_integration/data/remote/thawani_api_service.dart';

class ThawaniRepository {
  ThawaniRepository(this._apiService);
  final ThawaniApiService _apiService;

  Future<Map<String, dynamic>> getStats() => _apiService.getStats();
  Future<Map<String, dynamic>> getConfig() => _apiService.getConfig();
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) => _apiService.saveConfig(data);
  Future<Map<String, dynamic>> disconnect() => _apiService.disconnect();
  Future<Map<String, dynamic>> getOrders({String? status, int? perPage}) =>
      _apiService.getOrders(status: status, perPage: perPage);
  Future<Map<String, dynamic>> getProductMappings() => _apiService.getProductMappings();
  Future<Map<String, dynamic>> getSettlements({int? perPage}) => _apiService.getSettlements(perPage: perPage);
  Future<Map<String, dynamic>> testConnection() => _apiService.testConnection();
  Future<Map<String, dynamic>> pushProducts() => _apiService.pushProducts();
  Future<Map<String, dynamic>> pullProducts() => _apiService.pullProducts();
  Future<Map<String, dynamic>> getCategoryMappings() => _apiService.getCategoryMappings();
  Future<Map<String, dynamic>> pushCategories() => _apiService.pushCategories();
  Future<Map<String, dynamic>> pullCategories() => _apiService.pullCategories();
  Future<Map<String, dynamic>> getColumnMappings() => _apiService.getColumnMappings();
  Future<Map<String, dynamic>> seedColumnDefaults() => _apiService.seedColumnDefaults();
  Future<Map<String, dynamic>> getSyncLogs({String? entityType, String? status, int? perPage}) =>
      _apiService.getSyncLogs(entityType: entityType, status: status, perPage: perPage);
  Future<Map<String, dynamic>> getQueueStats() => _apiService.getQueueStats();
  Future<Map<String, dynamic>> processQueue() => _apiService.processQueue();

  // Order Management
  Future<Map<String, dynamic>> getOrderDetail(String id) => _apiService.getOrderDetail(id);
  Future<Map<String, dynamic>> acceptOrder(String id) => _apiService.acceptOrder(id);
  Future<Map<String, dynamic>> rejectOrder(String id, String reason) => _apiService.rejectOrder(id, reason);
  Future<Map<String, dynamic>> updateOrderStatus(String id, String status) => _apiService.updateOrderStatus(id, status);

  // Online Menu
  Future<Map<String, dynamic>> getProducts({String? search, bool? isPublished, int? perPage, int? page}) =>
      _apiService.getProducts(search: search, isPublished: isPublished, perPage: perPage, page: page);
  Future<Map<String, dynamic>> publishProduct(String id, {required bool isPublished, double? onlinePrice, int? displayOrder}) =>
      _apiService.publishProduct(id, isPublished: isPublished, onlinePrice: onlinePrice, displayOrder: displayOrder);
  Future<Map<String, dynamic>> bulkPublishProducts(List<String> productIds, bool isPublished) =>
      _apiService.bulkPublishProducts(productIds, isPublished);

  // Store Availability
  Future<Map<String, dynamic>> updateStoreAvailability(bool isOpen, {String? closedReason}) =>
      _apiService.updateStoreAvailability(isOpen, closedReason: closedReason);

  // Inventory Sync
  Future<Map<String, dynamic>> syncInventory() => _apiService.syncInventory();
}

final thawaniRepositoryProvider = Provider<ThawaniRepository>((ref) {
  return ThawaniRepository(ref.watch(thawaniApiServiceProvider));
});
