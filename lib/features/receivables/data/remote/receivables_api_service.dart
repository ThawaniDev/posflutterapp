import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/receivables/models/receivable.dart';

final receivablesApiServiceProvider = Provider<ReceivablesApiService>((ref) {
  return ReceivablesApiService(ref.watch(dioClientProvider));
});

class ReceivablesApiService {
  final Dio _dio;

  ReceivablesApiService(this._dio);

  // ─── List Receivables ──────────────────────────────────────────────

  Future<PaginatedResult<Receivable>> listReceivables({
    int page = 1,
    int perPage = 25,
    String? customerId,
    String? storeId,
    String? status,
    String? receivableType,
    String? source,
    String? search,
    String? dateFrom,
    String? dateTo,
    bool? overdue,
    String? sortBy,
    String? sortDir,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.receivables,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (customerId != null) 'customer_id': customerId,
        if (storeId != null) 'store_id': storeId,
        if (status != null) 'status': status,
        if (receivableType != null) 'receivable_type': receivableType,
        if (source != null) 'source': source,
        if (search != null && search.isNotEmpty) 'search': search,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (overdue == true) 'overdue': 1,
        if (sortBy != null) 'sort_by': sortBy,
        if (sortDir != null) 'sort_dir': sortDir,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Receivable.fromJson(j as Map<String, dynamic>)).toList();

    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  // ─── Get Single Receivable ─────────────────────────────────────────

  Future<Receivable> getReceivable(String receivableId) async {
    final response = await _dio.get(ApiEndpoints.receivableById(receivableId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Receivable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Create Receivable ─────────────────────────────────────────────

  Future<Receivable> createReceivable({
    required String customerId,
    required String receivableType,
    required String source,
    required double amount,
    String? dueDate,
    String? description,
    String? descriptionAr,
    String? notes,
    String? referenceNumber,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.receivables,
      data: {
        'customer_id': customerId,
        'receivable_type': receivableType,
        'source': source,
        'amount': amount,
        if (dueDate != null) 'due_date': dueDate,
        if (description != null) 'description': description,
        if (descriptionAr != null) 'description_ar': descriptionAr,
        if (notes != null) 'notes': notes,
        if (referenceNumber != null) 'reference_number': referenceNumber,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Receivable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Update Receivable ─────────────────────────────────────────────

  Future<Receivable> updateReceivable(String receivableId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.receivableById(receivableId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return Receivable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Delete Receivable ─────────────────────────────────────────────

  Future<void> deleteReceivable(String receivableId) async {
    await _dio.delete(ApiEndpoints.receivableById(receivableId));
  }

  // ─── Record Payment ────────────────────────────────────────────────

  Future<ReceivablePayment> recordPayment({
    required String receivableId,
    required double amount,
    String? orderId,
    String? paymentMethod,
    String? notes,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.receivablePayments(receivableId),
      data: {
        'amount': amount,
        if (orderId != null) 'order_id': orderId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (notes != null) 'notes': notes,
      },
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ReceivablePayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── List Payments ─────────────────────────────────────────────────

  Future<List<ReceivablePayment>> listPayments(String receivableId) async {
    final response = await _dio.get(ApiEndpoints.receivablePayments(receivableId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ReceivablePayment.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Add Note ──────────────────────────────────────────────────────

  Future<Receivable> addNote({required String receivableId, required String note}) async {
    final response = await _dio.post(ApiEndpoints.receivableNotes(receivableId), data: {'note': note});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Receivable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Get Logs ──────────────────────────────────────────────────────

  Future<List<ReceivableLog>> getLogs(String receivableId) async {
    final response = await _dio.get(ApiEndpoints.receivableLogs(receivableId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ReceivableLog.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Reverse Receivable ────────────────────────────────────────────

  Future<Receivable> reverseReceivable(String receivableId, {String? reason}) async {
    final response = await _dio.post(
      ApiEndpoints.receivableReverse(receivableId),
      data: {if (reason != null && reason.isNotEmpty) 'reason': reason},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Receivable.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Customer Balance ─────────────────────────────────────────────

  Future<double> getCustomerReceivableBalance(String customerId) async {
    final response = await _dio.get(ApiEndpoints.receivableCustomerBalance(customerId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return double.tryParse(data['receivable_balance'].toString()) ?? 0.0;
  }

  // ─── Customer Receivables ─────────────────────────────────────────

  Future<List<Receivable>> getCustomerReceivables(String customerId) async {
    final response = await _dio.get(ApiEndpoints.receivableCustomerList(customerId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => Receivable.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Summary ──────────────────────────────────────────────────────

  Future<ReceivableSummary> getSummary() async {
    final response = await _dio.get(ApiEndpoints.receivablesSummary);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ReceivableSummary.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
