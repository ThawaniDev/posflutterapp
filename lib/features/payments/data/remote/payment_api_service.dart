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
import 'package:wameedpos/features/payments/models/refund.dart';

final paymentApiServiceProvider = Provider<PaymentApiService>((ref) {
  return PaymentApiService(ref.watch(dioClientProvider));
});

class PaymentApiService {
  PaymentApiService(this._dio);
  final Dio _dio;

  // ─── Payments ─────────────────────────────────────────────────

  Future<PaginatedResult<Payment>> listPayments({
    int page = 1,
    int perPage = 20,
    String? method,
    String? transactionId,
    String? status,
    String? startDate,
    String? endDate,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.payments,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (method != null) 'method': method,
        if (transactionId != null) 'transaction_id': transactionId,
        if (status != null) 'status': status,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (search != null) 'search': search,
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

  // ─── Refunds ──────────────────────────────────────────────────

  Future<PaginatedResult<Refund>> listRefunds({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? status,
    String? method,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.paymentRefunds,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (status != null) 'status': status,
        if (method != null) 'method': method,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Refund.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<PaginatedResult<Refund>> listPaymentRefunds(String paymentId, {int page = 1}) async {
    final response = await _dio.get(
      ApiEndpoints.paymentRefundsById(paymentId),
      queryParameters: {'page': page},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Refund.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? 20,
    );
  }

  Future<Refund> createRefund(String paymentId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.paymentRefund(paymentId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Refund.fromJson(apiResponse.data as Map<String, dynamic>);
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
    final response = await _dio.put(ApiEndpoints.cashSessionClose(id), data: data);
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

  Future<PaginatedResult<Expense>> listExpenses({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? category,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.expenses,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
        if (category != null) 'category': category,
      },
    );
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

  Future<Expense> updateExpense(String id, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.expenseById(id), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Expense.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteExpense(String id) async {
    await _dio.delete(ApiEndpoints.expenseById(id));
  }

  // ─── Gift Cards ───────────────────────────────────────────────

  Future<PaginatedResult<GiftCard>> listGiftCards({
    int page = 1,
    int perPage = 20,
    String? status,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.giftCards,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (status != null) 'status': status,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => GiftCard.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.giftCards, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GiftCard.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> checkGiftCardBalance(String code) async {
    final response = await _dio.get(ApiEndpoints.giftCardBalance(code));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<GiftCard> redeemGiftCard(String code, double amount) async {
    final response = await _dio.post(ApiEndpoints.giftCardRedeem(code), data: {'amount': amount});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GiftCard.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<GiftCard> deactivateGiftCard(String code) async {
    final response = await _dio.put(ApiEndpoints.giftCardDeactivate(code));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return GiftCard.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Financial Reports ────────────────────────────────────────

  Future<Map<String, dynamic>> dailySummary({String? date}) async {
    final response = await _dio.get(
      ApiEndpoints.financeDailySummary,
      queryParameters: {
        if (date != null) 'date': date,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> reconciliation({String? startDate, String? endDate}) async {
    final response = await _dio.get(
      ApiEndpoints.financeReconciliation,
      queryParameters: {
        if (startDate != null) 'start_date': startDate,
        if (endDate != null) 'end_date': endDate,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }
}

