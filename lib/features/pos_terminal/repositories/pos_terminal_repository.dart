import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:thawani_pos/features/pos_terminal/models/held_cart.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';

final posTerminalRepositoryProvider = Provider<PosTerminalRepository>((ref) {
  return PosTerminalRepository(apiService: ref.watch(posTerminalApiServiceProvider));
});

class PosTerminalRepository {
  final PosTerminalApiService _apiService;

  PosTerminalRepository({required PosTerminalApiService apiService}) : _apiService = apiService;

  // Sessions
  Future<PaginatedResult<PosSession>> listSessions({int page = 1, int perPage = 20}) =>
      _apiService.listSessions(page: page, perPage: perPage);
  Future<PosSession> openSession(Map<String, dynamic> data) => _apiService.openSession(data);
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
  Future<Transaction> voidTransaction(String id) => _apiService.voidTransaction(id);

  // Held Carts
  Future<List<HeldCart>> listHeldCarts() => _apiService.listHeldCarts();
  Future<HeldCart> holdCart(Map<String, dynamic> data) => _apiService.holdCart(data);
  Future<HeldCart> recallCart(String id) => _apiService.recallCart(id);
  Future<void> deleteHeldCart(String id) => _apiService.deleteHeldCart(id);
}
