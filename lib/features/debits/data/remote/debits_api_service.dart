import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/debits/models/debit.dart';

final debitsApiServiceProvider = Provider<DebitsApiService>((ref) {
  return DebitsApiService(ref.watch(dioClientProvider));
});

class DebitsApiService {

  DebitsApiService(this._dio);
  final Dio _dio;

  // ─── List Debits ──────────────────────────────────────────────

  Future<PaginatedResult<Debit>> listDebits({
    int page = 1,
    int perPage = 25,
    String? customerId,
    String? storeId,
    String? status,
    String? debitType,
    String? source,
    String? search,
    String? dateFrom,
    String? dateTo,
    String? sortBy,
    String? sortDir,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.debits,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'customer_id': ?customerId,
        'store_id': ?storeId,
        'status': ?status,
        'debit_type': ?debitType,
        'source': ?source,
        if (search != null && search.isNotEmpty) 'search': search,
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
        'sort_by': ?sortBy,
        'sort_dir': ?sortDir,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Debit.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  // ─── Get Single Debit ─────────────────────────────────────────

  Future<Debit> getDebit(String debitId) async {
    final response = await _dio.get(ApiEndpoints.debitById(debitId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Debit.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Create Debit ─────────────────────────────────────────────

  Future<Debit> createDebit({
    required String customerId,
    required String debitType,
    required String source,
    required double amount,
    String? description,
    String? descriptionAr,
    String? notes,
    String? referenceNumber,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.debits,
      data: {
        'customer_id': customerId,
        'debit_type': debitType,
        'source': source,
        'amount': amount,
        'description': ?description,
        'description_ar': ?descriptionAr,
        'notes': ?notes,
        'reference_number': ?referenceNumber,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Debit.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Update Debit ─────────────────────────────────────────────

  Future<Debit> updateDebit(String debitId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.debitById(debitId), data: data);

    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return Debit.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Delete Debit ─────────────────────────────────────────────

  Future<void> deleteDebit(String debitId) async {
    await _dio.delete(ApiEndpoints.debitById(debitId));
  }

  // ─── Allocate Debit ───────────────────────────────────────────

  Future<DebitAllocation> allocateDebit({
    required String debitId,
    required String orderId,
    required double amount,
    String? notes,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.debitAllocate(debitId),
      data: {'order_id': orderId, 'amount': amount, 'notes': ?notes},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DebitAllocation.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── List Allocations ─────────────────────────────────────────

  Future<List<DebitAllocation>> listAllocations(String debitId) async {
    final response = await _dio.get(ApiEndpoints.debitAllocations(debitId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => DebitAllocation.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Reverse Debit ────────────────────────────────────────────

  Future<Debit> reverseDebit(String debitId, {String? reason}) async {
    final response = await _dio.post(
      ApiEndpoints.debitReverse(debitId),
      data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Debit.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Customer Balance ─────────────────────────────────────────

  Future<double> getCustomerDebitBalance(String customerId) async {
    final response = await _dio.get(ApiEndpoints.debitCustomerBalance(customerId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return double.tryParse(data['debit_balance'].toString()) ?? 0.0;
  }

  // ─── Customer Debits ──────────────────────────────────────────

  Future<List<Debit>> getCustomerDebits(String customerId) async {
    final response = await _dio.get(ApiEndpoints.debitCustomerDebits(customerId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => Debit.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Summary ──────────────────────────────────────────────────

  Future<DebitSummary> getSummary() async {
    final response = await _dio.get(ApiEndpoints.debitsSummary);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return DebitSummary.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
