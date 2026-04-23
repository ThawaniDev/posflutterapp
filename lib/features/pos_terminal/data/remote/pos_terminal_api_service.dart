import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/models/held_cart.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';

final posTerminalApiServiceProvider = Provider<PosTerminalApiService>((ref) {
  return PosTerminalApiService(ref.watch(dioClientProvider));
});

class PosTerminalApiService {
  PosTerminalApiService(this._dio);
  final Dio _dio;

  // ─── Sessions ─────────────────────────────────────────────────

  Future<PaginatedResult<PosSession>> listSessions({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.posSessions, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => PosSession.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<PosSession> openSession(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.posSessions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return PosSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// All shifts currently open for the authenticated cashier across any
  /// register. Backend enforces the same one-open-session-per-user rule when
  /// a new shift is opened; this call lets the client surface the existing
  /// shifts up front so the user doesn't even try.
  Future<List<PosSession>> listMyOpenSessions() async {
    final response = await _dio.get('${ApiEndpoints.posSessions}/mine/open');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List? ?? const [];
    return list.map((j) => PosSession.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<PosSession> getSession(String sessionId) async {
    final response = await _dio.get('${ApiEndpoints.posSessions}/$sessionId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return PosSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<PosSession> closeSession(String sessionId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.posSessions}/$sessionId/close', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return PosSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Transactions ─────────────────────────────────────────────

  Future<PaginatedResult<Transaction>> listTransactions({
    int page = 1,
    int perPage = 20,
    String? sessionId,
    String? type,
    String? status,
    String? search,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.transactions,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'session_id': ?sessionId,
        'type': ?type,
        'status': ?status,
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Transaction.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Transaction> createTransaction(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.transactions, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Transaction> getTransaction(String transactionId) async {
    final response = await _dio.get('${ApiEndpoints.transactions}/$transactionId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Transaction> voidTransaction(String transactionId, {required String reason, String? approvalToken}) async {
    final response = await _dio.post(
      '${ApiEndpoints.transactions}/$transactionId/void',
      data: {
        'reason': reason,
        if (approvalToken != null) 'approval_token': approvalToken,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Transaction> getTransactionByNumber(String number) async {
    final response = await _dio.get('${ApiEndpoints.transactions}/by-number/$number');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Transaction> returnTransaction(Map<String, dynamic> data) async {
    final response = await _dio.post('${ApiEndpoints.transactions}/return', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── POS Products ────────────────────────────────────────────

  Future<PaginatedResult<Product>> listPosProducts({
    int page = 1,
    int perPage = 50,
    String? search,
    String? categoryId,
    String? barcode,
  }) async {
    final response = await _dio.get(
      '${ApiEndpoints.posBase}/products',
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        'category_id': ?categoryId,
        if (barcode != null && barcode.isNotEmpty) 'barcode': barcode,
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

  // ─── POS Customers ───────────────────────────────────────────

  Future<PaginatedResult<Customer>> listPosCustomers({int page = 1, int perPage = 20, String? search}) async {
    final response = await _dio.get(
      '${ApiEndpoints.posBase}/customers',
      queryParameters: {'page': page, 'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
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

  // ─── Held Carts ───────────────────────────────────────────────

  Future<List<HeldCart>> listHeldCarts() async {
    final response = await _dio.get(ApiEndpoints.heldCarts);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => HeldCart.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<HeldCart> holdCart(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.heldCarts, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return HeldCart.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<HeldCart> recallCart(String cartId) async {
    final response = await _dio.put('${ApiEndpoints.heldCarts}/$cartId/recall');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return HeldCart.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteHeldCart(String cartId) async {
    await _dio.delete('${ApiEndpoints.heldCarts}/$cartId');
  }

  // ─── Active Registers (for cashier shift opening) ──────────────

  Future<List<Register>> listActiveRegisters() async {
    final response = await _dio.get(ApiEndpoints.posRegisters);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List;
    return list.map((j) => Register.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Terminals (Registers) ────────────────────────────────────

  Future<PaginatedResult<Register>> listTerminals({int page = 1, int perPage = 20, String? search}) async {
    final response = await _dio.get(
      ApiEndpoints.posTerminals,
      queryParameters: {'page': page, 'per_page': perPage, if (search != null && search.isNotEmpty) 'search': search},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => Register.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<Register> createTerminal(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.posTerminals, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Register.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Register> getTerminal(String terminalId) async {
    final response = await _dio.get('${ApiEndpoints.posTerminals}/$terminalId');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Register.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Register> updateTerminal(String terminalId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.posTerminals}/$terminalId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Register.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteTerminal(String terminalId) async {
    await _dio.delete('${ApiEndpoints.posTerminals}/$terminalId');
  }

  Future<Register> toggleTerminalStatus(String terminalId) async {
    final response = await _dio.post('${ApiEndpoints.posTerminals}/$terminalId/toggle-status');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Register.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Cash Events (drop / payout / paid-in) ─────────────────

  Future<List<Map<String, dynamic>>> listCashEvents(String sessionId) async {
    final response = await _dio.get('${ApiEndpoints.posSessions}/$sessionId/cash-events');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ((apiResponse.data as List?) ?? const []).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<Map<String, dynamic>> recordCashEvent(String sessionId, Map<String, dynamic> data) async {
    final response = await _dio.post('${ApiEndpoints.posSessions}/$sessionId/cash-events', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  // ─── Reports (X / Z) ───────────────────────────────────────

  Future<Map<String, dynamic>> xReport(String sessionId) async {
    final response = await _dio.get('${ApiEndpoints.posSessions}/$sessionId/x-report');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  Future<Map<String, dynamic>> zReport(String sessionId) async {
    final response = await _dio.get('${ApiEndpoints.posSessions}/$sessionId/z-report');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  // ─── Exchange ──────────────────────────────────────────────

  Future<Transaction> exchangeTransaction(Map<String, dynamic> data) async {
    final response = await _dio.post('${ApiEndpoints.transactions}/exchange', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Transaction.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Receipt ───────────────────────────────────────────────

  Future<Map<String, dynamic>> getReceipt(String transactionId) async {
    final response = await _dio.get('${ApiEndpoints.transactions}/$transactionId/receipt');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  // ─── Offline sync / step-up auth ────────────────────────────

  /// Idempotently send a batch of queued transactions. Each entry must
  /// include `client_uuid` so the backend dedupes retries.
  Future<Map<String, dynamic>> batchTransactions(Map<String, dynamic> payload) async {
    final response = await _dio.post('${ApiEndpoints.transactions}/batch', data: payload);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  /// Fetch product + inventory deltas since the supplied timestamp (ISO-8601).
  Future<Map<String, dynamic>> productChanges({required DateTime since}) async {
    final response = await _dio.get(
      '/pos/products/changes',
      queryParameters: {'since': since.toUtc().toIso8601String()},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  /// Apply a batch of inventory adjustments. Each entry needs `client_uuid`.
  Future<Map<String, dynamic>> applyInventoryAdjustments(Map<String, dynamic> payload) async {
    final response = await _dio.post('/pos/inventory/adjustments', data: payload);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }

  /// Quick-add walk-in customer from the POS register.
  Future<Customer> quickAddCustomer(Map<String, dynamic> payload) async {
    final response = await _dio.post(ApiEndpoints.posCustomers, data: payload);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Customer.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// Verify a manager PIN for a step-up action; returns
  /// `{approval_token, approver_id, expires_in}`.
  Future<Map<String, dynamic>> verifyManagerPin({required String pin, required String action}) async {
    final response = await _dio.post('/pos/auth/verify-pin', data: {'pin': pin, 'action': action});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Map<String, dynamic>.from(apiResponse.data as Map);
  }
}
