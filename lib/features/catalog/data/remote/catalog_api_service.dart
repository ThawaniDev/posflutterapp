import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/modifier_group.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/product_barcode.dart';
import 'package:wameedpos/features/catalog/models/product_supplier.dart';
import 'package:wameedpos/features/catalog/models/product_variant.dart';
import 'package:wameedpos/features/catalog/models/store_price.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';

final catalogApiServiceProvider = Provider<CatalogApiService>((ref) {
  return CatalogApiService(ref.watch(dioClientProvider));
});

/// Remote API service for catalog endpoints (products, categories, suppliers).
class CatalogApiService {

  CatalogApiService(this._dio);
  final Dio _dio;

  // ─── Products ─────────────────────────────────────────────────

  /// GET /catalog/products
  Future<PaginatedResult<Product>> listProducts({
    int page = 1,
    int perPage = 25,
    String? categoryId,
    String? search,
    bool? isActive,
    String? sortBy,
    String? sortDir,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.products,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'category_id': ?categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        if (isActive != null) 'is_active': isActive ? 1 : 0,
        'sort_by': ?sortBy,
        'sort_dir': ?sortDir,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// GET /catalog/products/:id
  Future<Product> getProduct(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Product.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /catalog/products
  Future<Product> createProduct(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.products, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Product.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /catalog/products/:id
  Future<Product> updateProduct(String productId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.products}/$productId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Product.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /catalog/products/:id
  Future<void> deleteProduct(String productId) async {
    await _dio.delete('${ApiEndpoints.products}/$productId');
  }

  /// GET /catalog/products/catalog (full active catalog for POS sync)
  Future<List<Product>> getCatalog() async {
    final response = await _dio.get('${ApiEndpoints.products}/catalog');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /catalog/products/changes?since=X (delta sync)
  Future<List<Product>> getChanges(int sinceVersion) async {
    final response = await _dio.get('${ApiEndpoints.products}/changes', queryParameters: {'since': sinceVersion});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => Product.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// POST /catalog/products/:id/barcode (generate barcode)
  Future<String> generateBarcode(String productId) async {
    final response = await _dio.post('${ApiEndpoints.products}/$productId/barcode');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return (apiResponse.data as Map<String, dynamic>)['barcode'] as String;
  }

  /// POST /catalog/products/bulk-action
  Future<void> bulkAction({required List<String> productIds, required String action, String? categoryId}) async {
    await _dio.post(
      '${ApiEndpoints.products}/bulk-action',
      data: {'product_ids': productIds, 'action': action, 'category_id': ?categoryId},
    );
  }

  /// POST /catalog/products/:id/duplicate
  Future<Product> duplicateProduct(String productId) async {
    final response = await _dio.post('${ApiEndpoints.products}/$productId/duplicate');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Product.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// GET /catalog/products/:id/store-prices
  Future<List<StorePrice>> getStorePrices(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/store-prices');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => StorePrice.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// PUT /catalog/products/:id/store-prices
  Future<void> syncStorePrices(String productId, List<Map<String, dynamic>> prices) async {
    await _dio.put('${ApiEndpoints.products}/$productId/store-prices', data: {'prices': prices});
  }

  /// GET /catalog/products/:id/suppliers
  Future<List<ProductSupplier>> getProductSuppliers(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/suppliers');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ProductSupplier.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// PUT /catalog/products/:id/suppliers
  Future<void> syncProductSuppliers(String productId, List<Map<String, dynamic>> suppliers) async {
    await _dio.put('${ApiEndpoints.products}/$productId/suppliers', data: {'suppliers': suppliers});
  }

  /// GET /catalog/products/:id/modifiers
  Future<List<ModifierGroup>> getModifiers(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/modifiers');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ModifierGroup.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// POST /catalog/products/:id/modifiers (sync)
  Future<void> syncModifiers(String productId, List<Map<String, dynamic>> groups) async {
    await _dio.post('${ApiEndpoints.products}/$productId/modifiers', data: {'groups': groups});
  }

  /// GET /catalog/products/:id/variants
  Future<List<ProductVariant>> getVariants(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/variants');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ProductVariant.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// POST /catalog/products/:id/variants (sync)
  Future<void> syncVariants(String productId, List<Map<String, dynamic>> variants) async {
    await _dio.post('${ApiEndpoints.products}/$productId/variants', data: {'variants': variants});
  }

  /// GET /catalog/products/:id/barcodes
  Future<List<ProductBarcode>> getBarcodes(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/barcodes');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ProductBarcode.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Combo Products ──────────────────────────────────────────

  /// GET /catalog/products/:id/combo
  Future<ComboDefinition> getCombo(String productId) async {
    final response = await _dio.get('${ApiEndpoints.products}/$productId/combo');
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return ComboDefinition.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /catalog/products/:id/combo
  Future<ComboDefinition> syncCombo(
    String productId, {
    String? name,
    double? comboPrice,
    required List<ComboItemPayload> items,
  }) async {
    final response = await _dio.put(
      '${ApiEndpoints.products}/$productId/combo',
      data: {
        'name': ?name,
        'combo_price': ?comboPrice,
        'items': items.map((i) => i.toJson()).toList(),
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return ComboDefinition.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /catalog/products/:id/combo
  Future<void> clearCombo(String productId) async {
    await _dio.delete('${ApiEndpoints.products}/$productId/combo');
  }

  // ─── Categories ───────────────────────────────────────────────

  /// GET /catalog/categories (tree)
  Future<List<Category>> getCategoryTree({bool activeOnly = false}) async {
    final response = await _dio.get(ApiEndpoints.categories, queryParameters: {if (activeOnly) 'active_only': 1});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => Category.fromJson(j as Map<String, dynamic>)).toList();
  }

  /// GET /catalog/categories/:id
  Future<Category> getCategory(String categoryId) async {
    final response = await _dio.get('${ApiEndpoints.categories}/$categoryId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Category.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /catalog/categories
  Future<Category> createCategory(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.categories, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Category.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /catalog/categories/:id
  Future<Category> updateCategory(String categoryId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.categories}/$categoryId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Category.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /catalog/categories/:id
  Future<void> deleteCategory(String categoryId) async {
    await _dio.delete('${ApiEndpoints.categories}/$categoryId');
  }

  // ─── Suppliers ────────────────────────────────────────────────

  /// GET /catalog/suppliers
  Future<PaginatedResult<Supplier>> listSuppliers({int page = 1, int perPage = 25, String? search}) async {
    final response = await _dio.get(
      ApiEndpoints.suppliers,
      queryParameters: {'page': page, 'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Supplier.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  /// POST /catalog/suppliers
  Future<Supplier> createSupplier(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.suppliers, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Supplier.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// PUT /catalog/suppliers/:id
  Future<Supplier> updateSupplier(String supplierId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.suppliers}/$supplierId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Supplier.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// DELETE /catalog/suppliers/:id
  Future<void> deleteSupplier(String supplierId) async {
    await _dio.delete('${ApiEndpoints.suppliers}/$supplierId');
  }

  // ─── Bulk Import ──────────────────────────────────────────────

  /// POST /catalog/products/import-preview
  ///
  /// Uploads the file once to obtain header row + a small preview of
  /// the data so the user can map columns before triggering the real
  /// import. Returns a record with `header`, `preview` (first 10 rows)
  /// and `totalRows`.
  Future<ImportPreview> importPreview(String filePath, String fileName) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
    });
    final response = await _dio.post(
      '${ApiEndpoints.products}/import-preview',
      data: formData,
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return ImportPreview.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// POST /catalog/products/bulk-import
  ///
  /// Streams the file to the server with a [mapping] of canonical
  /// product field name → 0-based CSV column index. Returns the
  /// import outcome including the list of failed rows.
  Future<ImportResult> bulkImport({
    required String filePath,
    required String fileName,
    required Map<String, int> mapping,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath, filename: fileName),
      ...{for (final entry in mapping.entries) 'mapping[${entry.key}]': entry.value},
    });
    final response = await _dio.post(
      '${ApiEndpoints.products}/bulk-import',
      data: formData,
    );
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return ImportResult.fromJson(
      apiResponse.data as Map<String, dynamic>,
      message: apiResponse.message,
    );
  }
}

class ImportPreview {
  const ImportPreview({
    required this.header,
    required this.preview,
    required this.totalRows,
    required this.availableFields,
  });

  factory ImportPreview.fromJson(Map<String, dynamic> map) {
    final rawHeader = map['header'];
    final rawPreview = map['preview'];
    final rawAvail = map['available_fields'];
    return ImportPreview(
      header: rawHeader is List
          ? rawHeader.map((e) => e?.toString() ?? '').toList()
          : const <String>[],
      preview: rawPreview is List
          ? rawPreview
              .whereType<List>()
              .map((row) => row.map((c) => c?.toString() ?? '').toList())
              .toList()
          : const <List<String>>[],
      totalRows: _asInt(map['total_rows']) ?? 0,
      availableFields: rawAvail is List
          ? rawAvail.map((e) => e?.toString() ?? '').toList()
          : const <String>[],
    );
  }

  final List<String> header;
  final List<List<String>> preview;
  final int totalRows;
  final List<String> availableFields;
}

class ImportResult {
  const ImportResult({
    required this.created,
    required this.failed,
    required this.errors,
    this.message,
  });

  factory ImportResult.fromJson(Map<String, dynamic> map, {String? message}) {
    final rawErrors = map['errors'];
    return ImportResult(
      created: _asInt(map['created']) ?? 0,
      failed: _asInt(map['failed']) ?? 0,
      errors: rawErrors is List
          ? rawErrors
              .whereType<Map<String, dynamic>>()
              .map(ImportError.fromJson)
              .toList()
          : const <ImportError>[],
      message: message,
    );
  }

  final int created;
  final int failed;
  final List<ImportError> errors;
  final String? message;
}

class ImportError {
  const ImportError({required this.row, required this.message});

  factory ImportError.fromJson(Map<String, dynamic> json) => ImportError(
        row: _asInt(json['row']) ?? 0,
        message: json['message']?.toString() ?? '',
      );

  final int row;
  final String message;
}

/// In-memory representation of a combo definition returned by
/// `GET /catalog/products/:id/combo` and `PUT .../combo`. Built to be
/// resilient to the server returning `combo: null` when the product
/// is not yet flagged as a combo.
class ComboDefinition {
  const ComboDefinition({
    required this.isCombo,
    required this.id,
    required this.name,
    required this.comboPrice,
    required this.items,
  });

  factory ComboDefinition.fromJson(Map<String, dynamic> json) {
    final combo = json['combo'];
    if (combo is! Map<String, dynamic>) {
      return const ComboDefinition(
        isCombo: false,
        id: null,
        name: null,
        comboPrice: null,
        items: <ComboItem>[],
      );
    }
    final rawItems = combo['items'];
    final parsedItems = rawItems is List
        ? rawItems.map((e) => ComboItem.fromJson(e as Map<String, dynamic>)).toList()
        : <ComboItem>[];
    return ComboDefinition(
      isCombo: json['is_combo'] == true,
      id: combo['id']?.toString(),
      name: combo['name']?.toString(),
      comboPrice: _asDouble(combo['combo_price']),
      items: parsedItems,
    );
  }

  final bool isCombo;
  final String? id;
  final String? name;
  final double? comboPrice;
  final List<ComboItem> items;
}

class ComboItem {
  const ComboItem({
    this.id,
    required this.productId,
    required this.productName,
    required this.productNameAr,
    required this.quantity,
    required this.isOptional,
  });

  factory ComboItem.fromJson(Map<String, dynamic> json) => ComboItem(
        id: json['id']?.toString(),
        productId: json['product_id']?.toString() ?? '',
        productName: json['product_name']?.toString(),
        productNameAr: json['product_name_ar']?.toString(),
        quantity: _asDouble(json['quantity']) ?? 1,
        isOptional: json['is_optional'] == true,
      );

  final String? id;
  final String productId;
  final String? productName;
  final String? productNameAr;
  final double quantity;
  final bool isOptional;
}

class ComboItemPayload {
  const ComboItemPayload({
    required this.productId,
    required this.quantity,
    this.isOptional = false,
  });

  final String productId;
  final double quantity;
  final bool isOptional;

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        'is_optional': isOptional,
      };
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

int? _asInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString());
}

/// Generic paginated result for list endpoints.
class PaginatedResult<T> {

  const PaginatedResult({
    required this.items,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<T> items;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}
