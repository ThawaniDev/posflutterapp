import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';

final paymentApiServiceProvider = Provider<PaymentApiService>((ref) {
  return PaymentApiService(ref.watch(dioClientProvider));
});

class PaymentApiService {
  final Dio _dio;

  PaymentApiService(this._dio);

  // ─── Payments ─────────────────────────────────────────────────

  Future<PaginatedResult<Payment>> listPayments({int page = 1, int perPage = 20, String? method, String? transactionId}) async {
    final response = await _dio.get(
      ApiEndpoints.payments,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (method != null) 'method': method,
        if (transactionId != null) 'transaction_id': transactionId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Payment.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Payment> createPayment(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.payments, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Payment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Cash Sessions ────────────────────────────────────────────

  Future<PaginatedResult<CashSession>> listCashSessions({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.cashSessions, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => CashSession.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<CashSession> openCashSession(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.cashSessions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CashSession> getCashSession(String id) async {
    final response = await _dio.get('${ApiEndpoints.cashSessions}/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<CashSession> closeCashSession(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.cashSessions}/$id/close', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Cash Events ──────────────────────────────────────────────

  Future<CashEvent> createCashEvent(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.cashEvents, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CashEvent.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Expenses ─────────────────────────────────────────────────

  Future<PaginatedResult<Expense>> listExpenses({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.expenses, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Expense.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Expense> createExpense(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.expenses, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Expense.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Gift Cards ───────────────────────────────────────────────

  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.giftCards, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GiftCard.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> checkGiftCardBalance(String code) async {
    final response = await _dio.get('${ApiEndpoints.giftCards}/$code/balance');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<GiftCard> redeemGiftCard(String code, double amount) async {
    final response = await _dio.post('${ApiEndpoints.giftCards}/$code/redeem', data: {'amount': amount});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GiftCard.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Financial Reports ────────────────────────────────────────

  Future<Map<String, dynamic>> dailySummary({String? date}) async {
    final response = await _dio.get(ApiEndpoints.financeDailySummary, queryParameters: {if (date != null) 'date': date});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> reconciliation({String? startDate, String? endDate}) async {
    final response = await _dio.get(
      ApiEndpoints.financeReconciliation,
      queryParameters: {if (startDate != null) 'start_date': startDate, if (endDate != null) 'end_date': endDate},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }
}
