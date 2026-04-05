import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/predefined_catalog/models/predefined_category.dart';
import 'package:thawani_pos/features/predefined_catalog/models/predefined_product.dart';

final predefinedCatalogApiServiceProvider = Provider<PredefinedCatalogApiService>((ref) {
  return PredefinedCatalogApiService(ref.watch(dioClientProvider));
});

/// Remote API service for browsing and cloning predefined products & categories.
class PredefinedCatalogApiService {
  final Dio _dio;

  PredefinedCatalogApiService(this._dio);

  // ─── Categories ───────────────────────────────────────────

  /// GET /predefined-catalog/categories
  Future<PaginatedResult<PredefinedCategory>> listCategories({
    int page = 1,
    int perPage = 25,
    String? businessTypeId,
    String? search,
    bool? isActive,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.predefinedCategories,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (businessTypeId != null) 'business_type_id': businessTypeId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (isActive != null) 'is_active': isActive ? 1 : 0,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => PredefinedCategory.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// GET /predefined-catalog/categories/tree?business_type_id=X
  Future<List<PredefinedCategory>> getCategoryTree(String businessTypeId) async {
    final response = await _dio.get(ApiEndpoints.predefinedCategoryTree, queryParameters: {'business_type_id': businessTypeId});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => PredefinedCategory.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /predefined-catalog/categories/:id
  Future<PredefinedCategory> getCategory(String categoryId) async {
    final response = await _dio.get(ApiEndpoints.predefinedCategoryById(categoryId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return PredefinedCategory.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /predefined-catalog/categories/:id/clone
  Future<Map<String, dynamic>> cloneCategory(String categoryId) async {
    final response = await _dio.post(ApiEndpoints.predefinedCategoryClone(categoryId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Products ─────────────────────────────────────────────

  /// GET /predefined-catalog/products
  Future<PaginatedResult<PredefinedProduct>> listProducts({
    int page = 1,
    int perPage = 25,
    String? businessTypeId,
    String? predefinedCategoryId,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortDir,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.predefinedProducts,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (businessTypeId != null) 'business_type_id': businessTypeId,
        if (predefinedCategoryId != null) 'predefined_category_id': predefinedCategoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (isActive != null) 'is_active': isActive ? 1 : 0,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortDir != null) 'sort_dir': sortDir,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => PredefinedProduct.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// GET /predefined-catalog/products/:id
  Future<PredefinedProduct> getProduct(String productId) async {
    final response = await _dio.get(ApiEndpoints.predefinedProductById(productId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return PredefinedProduct.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /predefined-catalog/products/:id/clone
  Future<Map<String, dynamic>> cloneProduct(String productId, {String? categoryId}) async {
    final response = await _dio.post(
      ApiEndpoints.predefinedProductClone(productId),
      data: {if (categoryId != null) 'category_id': categoryId},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  /// POST /predefined-catalog/clone-all
  Future<Map<String, dynamic>> cloneAll(String businessTypeId) async {
    final response = await _dio.post(ApiEndpoints.predefinedCloneAll, data: {'business_type_id': businessTypeId});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }
}
