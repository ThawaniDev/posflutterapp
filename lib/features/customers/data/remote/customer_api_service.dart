import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/models/digital_receipt_log.dart';
import 'package:wameedpos/features/customers/models/loyalty_config.dart';
import 'package:wameedpos/features/customers/models/loyalty_transaction.dart';
import 'package:wameedpos/features/customers/models/store_credit_transaction.dart';

final customerApiServiceProvider = Provider<CustomerApiService>((ref) {
  return CustomerApiService(ref.watch(dioClientProvider));
});

/// Wraps the `/customers/*` endpoints exposed by `routes/api/customers.php`
/// (Laravel) and the desktop `/pos/customers/sync` delta endpoint.
class CustomerApiService {
  CustomerApiService(this._dio);
  final Dio _dio;

  // ─── Customers CRUD ───────────────────────────────────────────

  Future<PaginatedResult<Customer>> listCustomers({
    int page = 1,
    int perPage = 20,
    String? search,
    String? groupId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.customers,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (groupId != null) 'group_id': groupId,
      },
    );
    final api = ApiResponse.fromJson(response.data, (d) => d);
    final map = api.data as Map<String, dynamic>;
    final items = (map['data'] as List)
        .map((j) => Customer.fromJson(j as Map<String, dynamic>))
        .toList();
    return PaginatedResult(
      items: items,
      total: (map['total'] as num?)?.toInt() ?? items.length,
      currentPage: (map['current_page'] as num?)?.toInt() ?? page,
      lastPage: (map['last_page'] as num?)?.toInt() ?? 1,
      perPage: (map['per_page'] as num?)?.toInt() ?? perPage,
    );
  }

  Future<Customer> getCustomer(String id) async {
    final r = await _dio.get('${ApiEndpoints.customers}/$id');
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return Customer.fromJson(api.data as Map<String, dynamic>);
  }

  Future<Customer> createCustomer(Map<String, dynamic> data) async {
    final r = await _dio.post(ApiEndpoints.customers, data: data);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return Customer.fromJson(api.data as Map<String, dynamic>);
  }

  Future<Customer> updateCustomer(String id, Map<String, dynamic> data) async {
    final r = await _dio.put('${ApiEndpoints.customers}/$id', data: data);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return Customer.fromJson(api.data as Map<String, dynamic>);
  }

  Future<void> deleteCustomer(String id) async {
    await _dio.delete('${ApiEndpoints.customers}/$id');
  }

  // ─── Search & Sync ────────────────────────────────────────────

  Future<List<Customer>> searchCustomers(String query, {int limit = 10}) async {
    final r = await _dio.get(
      ApiEndpoints.customersSearch,
      queryParameters: {'q': query, 'limit': limit},
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return api.dataList
        .map((j) => Customer.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  /// `since` is an ISO 8601 timestamp. Returns the raw envelope so the sync
  /// service can grab `server_time` (used to advance the local cursor).
  Future<({List<Customer> data, String serverTime, int count})> syncDelta({
    String? since,
    int limit = 500,
  }) async {
    final r = await _dio.get(
      ApiEndpoints.customersSync,
      queryParameters: {
        if (since != null) 'since': since,
        'limit': limit,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    final map = api.data as Map<String, dynamic>;
    final items = (map['data'] as List? ?? [])
        .map((j) => Customer.fromJson(j as Map<String, dynamic>))
        .toList();
    return (
      data: items,
      serverTime: map['server_time'] as String? ?? '',
      count: (map['count'] as num?)?.toInt() ?? items.length,
    );
  }

  // ─── Orders & Receipts ────────────────────────────────────────

  Future<Map<String, dynamic>> getCustomerOrders(String id, {int perPage = 20}) async {
    final r = await _dio.get(
      ApiEndpoints.customerOrders(id),
      queryParameters: {'per_page': perPage},
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return api.data as Map<String, dynamic>;
  }

  Future<DigitalReceiptLog> sendReceipt(
    String customerId, {
    required String orderId,
    required String channel,
    String? destination,
  }) async {
    final r = await _dio.post(
      ApiEndpoints.customerReceipt(customerId),
      data: {
        'order_id': orderId,
        'channel': channel,
        if (destination != null && destination.isNotEmpty) 'destination': destination,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return DigitalReceiptLog.fromJson(api.data as Map<String, dynamic>);
  }

  // ─── Groups ───────────────────────────────────────────────────

  Future<List<CustomerGroup>> listGroups() async {
    final r = await _dio.get(ApiEndpoints.customerGroups);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return api.dataList
        .map((j) => CustomerGroup.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<CustomerGroup> createGroup(Map<String, dynamic> data) async {
    final r = await _dio.post(ApiEndpoints.customerGroupsCrud, data: data);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return CustomerGroup.fromJson(api.data as Map<String, dynamic>);
  }

  Future<CustomerGroup> updateGroup(String id, Map<String, dynamic> data) async {
    final r = await _dio.put('${ApiEndpoints.customerGroupsCrud}/$id', data: data);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return CustomerGroup.fromJson(api.data as Map<String, dynamic>);
  }

  Future<void> deleteGroup(String id) async {
    await _dio.delete('${ApiEndpoints.customerGroupsCrud}/$id');
  }

  // ─── Loyalty config ───────────────────────────────────────────

  Future<LoyaltyConfig?> getLoyaltyConfig() async {
    final r = await _dio.get('${ApiEndpoints.loyalty}/config');
    final api = ApiResponse.fromJson(r.data, (d) => d);
    if (api.data == null) return null;
    return LoyaltyConfig.fromJson(api.data as Map<String, dynamic>);
  }

  Future<LoyaltyConfig> saveLoyaltyConfig(Map<String, dynamic> data) async {
    final r = await _dio.put('${ApiEndpoints.loyalty}/config', data: data);
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return LoyaltyConfig.fromJson(api.data as Map<String, dynamic>);
  }

  // ─── Loyalty transactions ─────────────────────────────────────

  Future<List<LoyaltyTransaction>> getLoyaltyLog(String customerId) async {
    final r = await _dio.get(ApiEndpoints.customerLoyaltyLog(customerId));
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return api.dataList
        .map((j) => LoyaltyTransaction.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<LoyaltyTransaction> adjustLoyalty(
    String customerId, {
    required int points,
    required String type, // earn | redeem | adjust
    String? notes,
    String? orderId,
  }) async {
    final r = await _dio.post(
      ApiEndpoints.customerLoyaltyAdjust(customerId),
      data: {
        'points': points,
        'type': type,
        if (notes != null) 'notes': notes,
        if (orderId != null) 'order_id': orderId,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return LoyaltyTransaction.fromJson(api.data as Map<String, dynamic>);
  }

  Future<LoyaltyTransaction> redeemLoyalty(
    String customerId, {
    required int points,
    String? orderId,
  }) async {
    final r = await _dio.post(
      ApiEndpoints.customerLoyaltyRedeem(customerId),
      data: {
        'points': points,
        if (orderId != null) 'order_id': orderId,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return LoyaltyTransaction.fromJson(api.data as Map<String, dynamic>);
  }

  // ─── Store credit ─────────────────────────────────────────────

  Future<List<StoreCreditTransaction>> getStoreCreditLog(String customerId) async {
    final r = await _dio.get(ApiEndpoints.customerCreditLog(customerId));
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return api.dataList
        .map((j) => StoreCreditTransaction.fromJson(j as Map<String, dynamic>))
        .toList();
  }

  Future<StoreCreditTransaction> topUpCredit(
    String customerId, {
    required double amount,
    String? notes,
  }) async {
    final r = await _dio.post(
      ApiEndpoints.customerCreditTopUp(customerId),
      data: {
        'amount': amount,
        if (notes != null) 'notes': notes,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return StoreCreditTransaction.fromJson(api.data as Map<String, dynamic>);
  }

  Future<StoreCreditTransaction> adjustCredit(
    String customerId, {
    required double amount,
    String? notes,
  }) async {
    final r = await _dio.post(
      ApiEndpoints.customerCreditAdjust(customerId),
      data: {
        'amount': amount,
        if (notes != null) 'notes': notes,
      },
    );
    final api = ApiResponse.fromJson(r.data, (d) => d);
    return StoreCreditTransaction.fromJson(api.data as Map<String, dynamic>);
  }
}
