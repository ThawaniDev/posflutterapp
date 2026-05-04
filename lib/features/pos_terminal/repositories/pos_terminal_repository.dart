import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:wameedpos/features/pos_terminal/models/held_cart.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';

final posTerminalRepositoryProvider = Provider<PosTerminalRepository>((ref) {
  return PosTerminalRepository(apiService: ref.watch(posTerminalApiServiceProvider));
});

class PosTerminalRepository {
  PosTerminalRepository({required PosTerminalApiService apiService}) : _apiService = apiService;
  final PosTerminalApiService _apiService;

  // Sessions
  Future<PaginatedResult<PosSession>> listSessions({int page = 1, int perPage = 20}) =>
      _apiService.listSessions(page: page, perPage: perPage);
  Future<PosSession> openSession(Map<String, dynamic> data) => _apiService.openSession(data);
  Future<List<PosSession>> listMyOpenSessions() => _apiService.listMyOpenSessions();
  Future<PosSession> getSession(String id) => _apiService.getSession(id);
  Future<PosSession> closeSession(String id, Map<String, dynamic> data) => _apiService.closeSession(id, data);

  // Transactions
  Future<PaginatedResult<Transaction>> listTransactions({
    int page = 1,
    int perPage = 20,
    String? sessionId,
    String? type,
    String? status,
    String? search,
  }) => _apiService.listTransactions(
    page: page,
    perPage: perPage,
    sessionId: sessionId,
    type: type,
    status: status,
    search: search,
  );
  Future<Transaction> createTransaction(Map<String, dynamic> data) => _apiService.createTransaction(data);
  Future<Transaction> getTransaction(String id) => _apiService.getTransaction(id);
  Future<Transaction> voidTransaction(String id, {required String reason, String? approvalToken}) =>
      _apiService.voidTransaction(id, reason: reason, approvalToken: approvalToken);
  Future<Transaction> getTransactionByNumber(String number) => _apiService.getTransactionByNumber(number);
  Future<Transaction> returnTransaction(Map<String, dynamic> data) => _apiService.returnTransaction(data);

  /// Suggested per-method refund split for a sale, optionally for a partial
  /// amount. Returned shape: `{transaction_id, refund_amount, suggested: [...]}`
  Future<Map<String, dynamic>> getRefundMethods(String transactionId, {double? amount}) =>
      _apiService.getRefundMethods(transactionId, amount: amount);

  /// Live state payload for the Customer-Facing Display attached to a session.
  Future<Map<String, dynamic>> getCfdDisplay(String sessionId) => _apiService.getCfdDisplay(sessionId);

  // POS Products
  Future<PaginatedResult<Product>> listPosProducts({
    int page = 1,
    int perPage = 50,
    String? search,
    String? categoryId,
    String? barcode,
  }) => _apiService.listPosProducts(page: page, perPage: perPage, search: search, categoryId: categoryId, barcode: barcode);

  // POS Customers
  Future<PaginatedResult<Customer>> listPosCustomers({int page = 1, int perPage = 20, String? search}) =>
      _apiService.listPosCustomers(page: page, perPage: perPage, search: search);

  // Held Carts
  Future<List<HeldCart>> listHeldCarts() => _apiService.listHeldCarts();
  Future<HeldCart> holdCart(Map<String, dynamic> data) => _apiService.holdCart(data);
  Future<HeldCart> recallCart(String id) => _apiService.recallCart(id);
  Future<void> deleteHeldCart(String id) => _apiService.deleteHeldCart(id);

  // Terminals (Registers)
  Future<List<Register>> listActiveRegisters() => _apiService.listActiveRegisters();
  Future<PaginatedResult<Register>> listTerminals({int page = 1, int perPage = 20, String? search}) =>
      _apiService.listTerminals(page: page, perPage: perPage, search: search);
  Future<Register> createTerminal(Map<String, dynamic> data) => _apiService.createTerminal(data);
  Future<Register> getTerminal(String id) => _apiService.getTerminal(id);
  Future<Register> updateTerminal(String id, Map<String, dynamic> data) => _apiService.updateTerminal(id, data);
  Future<void> deleteTerminal(String id) => _apiService.deleteTerminal(id);
  Future<Register> toggleTerminalStatus(String id) => _apiService.toggleTerminalStatus(id);

  // Cash events / Reports / Exchange / Receipt
  Future<List<Map<String, dynamic>>> listCashEvents(String sessionId) => _apiService.listCashEvents(sessionId);
  Future<Map<String, dynamic>> recordCashEvent(String sessionId, Map<String, dynamic> data) =>
      _apiService.recordCashEvent(sessionId, data);
  Future<Map<String, dynamic>> xReport(String sessionId) => _apiService.xReport(sessionId);
  Future<Map<String, dynamic>> zReport(String sessionId) => _apiService.zReport(sessionId);
  Future<Transaction> exchangeTransaction(Map<String, dynamic> data) => _apiService.exchangeTransaction(data);
  Future<Map<String, dynamic>> getReceipt(String transactionId) => _apiService.getReceipt(transactionId);
}
