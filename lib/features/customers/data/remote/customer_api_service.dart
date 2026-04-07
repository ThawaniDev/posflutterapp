import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/customers/models/customer.dart';
import 'package:thawani_pos/features/customers/models/customer_group.dart';
import 'package:thawani_pos/features/customers/models/loyalty_transaction.dart';

final customerApiServiceProvider = Provider<CustomerApiService>((ref) {
  return CustomerApiService(ref.watch(dioClientProvider));
});

class CustomerApiService {
  final Dio _dio;

  CustomerApiService(this._dio);

  // ─── Customers ────────────────────────────────────────────────

  Future<PaginatedResult<Customer>> listCustomers({int page = 1, int perPage = 20, String? search, String? groupId}) async {
    final response = await _dio.get(
      ApiEndpoints.customers,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (groupId != null) 'group_id': groupId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Customer.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Customer> getCustomer(String customerId) async {
    final response = await _dio.get('${ApiEndpoints.customers}/$customerId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Customer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Customer> createCustomer(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.customers, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Customer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Customer> updateCustomer(String customerId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.customers}/$customerId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Customer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteCustomer(String customerId) async {
    await _dio.delete('${ApiEndpoints.customers}/$customerId');
  }

  // ─── Groups ───────────────────────────────────────────────────

  Future<List<CustomerGroup>> listGroups() async {
    final response = await _dio.get(ApiEndpoints.customerGroups);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => CustomerGroup.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<CustomerGroup> createGroup(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.customerGroups, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CustomerGroup.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CustomerGroup> updateGroup(String groupId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.customerGroups}/$groupId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CustomerGroup.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteGroup(String groupId) async {
    await _dio.delete('${ApiEndpoints.customerGroups}/$groupId');
  }

  // ─── Loyalty ──────────────────────────────────────────────────

  Future<Map<String, dynamic>> getLoyaltyConfig() async {
    final response = await _dio.get('${ApiEndpoints.loyalty}/config');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<void> saveLoyaltyConfig(Map<String, dynamic> data) async {
    await _dio.put('${ApiEndpoints.loyalty}/config', data: data);
  }

  Future<void> earnPoints(String customerId, Map<String, dynamic> data) async {
    await _dio.post('${ApiEndpoints.loyalty}/$customerId/earn', data: data);
  }

  Future<void> redeemPoints(String customerId, Map<String, dynamic> data) async {
    await _dio.post('${ApiEndpoints.loyalty}/$customerId/redeem', data: data);
  }

  Future<List<LoyaltyTransaction>> getLoyaltyLog(String customerId) async {
    final response = await _dio.get('${ApiEndpoints.loyalty}/$customerId/log');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => LoyaltyTransaction.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<void> topUpCredit(String customerId, Map<String, dynamic> data) async {
    await _dio.post('${ApiEndpoints.loyalty}/$customerId/credit/top-up', data: data);
  }
}
