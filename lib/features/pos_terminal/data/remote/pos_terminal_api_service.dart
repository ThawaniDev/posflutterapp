import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/customers/models/customer.dart';
import 'package:thawani_pos/features/pos_terminal/models/held_cart.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';
import 'package:thawani_pos/features/pos_terminal/models/register.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';

final posTerminalApiServiceProvider = Provider<PosTerminalApiService>((ref) {
  return PosTerminalApiService(ref.watch(dioClientProvider));
});

class PosTerminalApiService {
  final Dio _dio;

  PosTerminalApiService(this._dio);

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
        if (sessionId != null) 'session_id': sessionId,
        if (type != null) 'type': type,
        if (status != null) 'status': status,
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

  Future<Transaction> voidTransaction(String transactionId) async {
    final response = await _dio.put('${ApiEndpoints.transactions}/$transactionId/void');
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
        if (categoryId != null) 'category_id': categoryId,
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
}
