import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';

class ThawaniApiService {
  final Dio _dio;

  ThawaniApiService(this._dio);

  /// GET /thawani/stats
  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.thawaniStats);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/config
  Future<Map<String, dynamic>> getConfig() async {
    final response = await _dio.get(ApiEndpoints.thawaniConfig);
    return response.data as Map<String, dynamic>;
  }

  /// POST /thawani/config
  Future<Map<String, dynamic>> saveConfig(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.thawaniConfig, data: data);
    return response.data as Map<String, dynamic>;
  }

  /// PUT /thawani/disconnect
  Future<Map<String, dynamic>> disconnect() async {
    final response = await _dio.put(ApiEndpoints.thawaniDisconnect);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/orders
  Future<Map<String, dynamic>> getOrders({String? status, int? perPage}) async {
    final params = <String, dynamic>{};
    if (status != null) params['status'] = status;
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.thawaniOrders, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/product-mappings
  Future<Map<String, dynamic>> getProductMappings() async {
    final response = await _dio.get(ApiEndpoints.thawaniProductMappings);
    return response.data as Map<String, dynamic>;
  }

  /// GET /thawani/settlements
  Future<Map<String, dynamic>> getSettlements({int? perPage}) async {
    final params = <String, dynamic>{};
    if (perPage != null) params['per_page'] = perPage;

    final response = await _dio.get(ApiEndpoints.thawaniSettlements, queryParameters: params);
    return response.data as Map<String, dynamic>;
  }
}

final thawaniApiServiceProvider = Provider<ThawaniApiService>((ref) {
  return ThawaniApiService(ref.watch(dioClientProvider));
});
