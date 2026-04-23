import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_terminal_state.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

// ─── Sessions Provider ──────────────────────────────────────────

final posSessionsProvider = StateNotifierProvider<PosSessionsNotifier, PosSessionsState>((ref) {
  return PosSessionsNotifier(ref.watch(posTerminalRepositoryProvider));
});

class PosSessionsNotifier extends StateNotifier<PosSessionsState> {
  PosSessionsNotifier(this._repo) : super(const PosSessionsInitial());
  final PosTerminalRepository _repo;
  int _perPage = 20;

  Future<void> load({int page = 1}) async {
    state = const PosSessionsLoading();
    try {
      final result = await _repo.listSessions(page: page, perPage: _perPage);
      state = PosSessionsLoaded(
        sessions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = PosSessionsError(message: _extractError(e));
    } catch (e) {
      state = PosSessionsError(message: e.toString());
    }
  }

  Future<void> nextPage() async {
    final loaded = state;
    if (loaded is! PosSessionsLoaded || !loaded.hasMore) return;
    await load(page: loaded.currentPage + 1);
  }

  Future<void> previousPage() async {
    final loaded = state;
    if (loaded is! PosSessionsLoaded || loaded.currentPage <= 1) return;
    await load(page: loaded.currentPage - 1);
  }

  void setPerPage(int perPage) {
    _perPage = perPage;
    load(page: 1);
  }

  Future<void> openSession(Map<String, dynamic> data) async {
    try {
      await _repo.openSession(data);
      await load();
    } on DioException catch (e) {
      state = PosSessionsError(message: _extractError(e));
    } catch (e) {
      state = PosSessionsError(message: e.toString());
    }
  }

  Future<void> closeSession(String id, Map<String, dynamic> data) async {
    try {
      await _repo.closeSession(id, data);
      await load();
    } on DioException catch (e) {
      state = PosSessionsError(message: _extractError(e));
    } catch (e) {
      state = PosSessionsError(message: e.toString());
    }
  }
}

// ─── Transactions Provider ──────────────────────────────────────

final transactionsProvider = StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  return TransactionsNotifier(ref.watch(posTerminalRepositoryProvider));
});

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  TransactionsNotifier(this._repo) : super(const TransactionsInitial());
  final PosTerminalRepository _repo;

  Future<void> load({int page = 1, String? sessionId, String? search}) async {
    state = const TransactionsLoading();
    try {
      final result = await _repo.listTransactions(page: page, sessionId: sessionId, search: search);
      state = TransactionsLoaded(
        transactions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = TransactionsError(message: _extractError(e));
    } catch (e) {
      state = TransactionsError(message: e.toString());
    }
  }

  Future<void> voidTransaction(String id, {required String reason, String? approvalToken}) async {
    try {
      await _repo.voidTransaction(id, reason: reason, approvalToken: approvalToken);
      await load();
    } on DioException catch (e) {
      state = TransactionsError(message: _extractError(e));
    } catch (e) {
      state = TransactionsError(message: e.toString());
    }
  }
}

// ─── Held Carts Provider ────────────────────────────────────────

final heldCartsProvider = StateNotifierProvider<HeldCartsNotifier, HeldCartsState>((ref) {
  return HeldCartsNotifier(ref.watch(posTerminalRepositoryProvider));
});

class HeldCartsNotifier extends StateNotifier<HeldCartsState> {
  HeldCartsNotifier(this._repo) : super(const HeldCartsInitial());
  final PosTerminalRepository _repo;

  Future<void> load() async {
    state = const HeldCartsLoading();
    try {
      final carts = await _repo.listHeldCarts();
      state = HeldCartsLoaded(carts: carts);
    } on DioException catch (e) {
      state = HeldCartsError(message: _extractError(e));
    } catch (e) {
      state = HeldCartsError(message: e.toString());
    }
  }

  Future<void> holdCart(Map<String, dynamic> data) async {
    try {
      await _repo.holdCart(data);
      await load();
    } on DioException catch (e) {
      state = HeldCartsError(message: _extractError(e));
    } catch (e) {
      state = HeldCartsError(message: e.toString());
    }
  }

  Future<void> recallCart(String id) async {
    try {
      await _repo.recallCart(id);
      await load();
    } on DioException catch (e) {
      state = HeldCartsError(message: _extractError(e));
    } catch (e) {
      state = HeldCartsError(message: e.toString());
    }
  }

  Future<void> deleteCart(String id) async {
    try {
      await _repo.deleteHeldCart(id);
      await load();
    } on DioException catch (e) {
      state = HeldCartsError(message: _extractError(e));
    } catch (e) {
      state = HeldCartsError(message: e.toString());
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}

// ─── Active Registers Provider (for cashier shift opening) ──────

final activeRegistersProvider = FutureProvider<List<Register>>((ref) async {
  final repo = ref.watch(posTerminalRepositoryProvider);
  return repo.listActiveRegisters();
});

/// Shifts currently open for the authenticated cashier. Surfaced in the
/// open-shift dialog to block opening a second register while one is already
/// live.
final myOpenSessionsProvider = FutureProvider.autoDispose<List<PosSession>>((ref) async {
  final repo = ref.watch(posTerminalRepositoryProvider);
  return repo.listMyOpenSessions();
});

// ─── Terminals Provider ─────────────────────────────────────────

final terminalsProvider = StateNotifierProvider<TerminalsNotifier, TerminalsState>((ref) {
  return TerminalsNotifier(ref.watch(posTerminalRepositoryProvider));
});

class TerminalsNotifier extends StateNotifier<TerminalsState> {
  TerminalsNotifier(this._repo) : super(const TerminalsInitial());
  final PosTerminalRepository _repo;
  String? _currentSearch;
  int _perPage = 20;

  Future<void> load({int page = 1, String? search}) async {
    _currentSearch = search ?? _currentSearch;
    state = const TerminalsLoading();
    try {
      final result = await _repo.listTerminals(page: page, perPage: _perPage, search: _currentSearch);
      state = TerminalsLoaded(
        terminals: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        search: _currentSearch,
      );
    } on DioException catch (e) {
      state = TerminalsError(message: _extractError(e));
    } catch (e) {
      state = TerminalsError(message: e.toString());
    }
  }

  Future<void> search(String query) async {
    _currentSearch = query.isEmpty ? null : query;
    await load(page: 1);
  }

  Future<void> nextPage() async {
    final loaded = state;
    if (loaded is! TerminalsLoaded || !loaded.hasMore) return;
    await load(page: loaded.currentPage + 1, search: loaded.search);
  }

  Future<void> previousPage() async {
    final loaded = state;
    if (loaded is! TerminalsLoaded || loaded.currentPage <= 1) return;
    await load(page: loaded.currentPage - 1, search: loaded.search);
  }

  void setPerPage(int perPage) {
    _perPage = perPage;
    load(page: 1);
  }

  Future<bool> createTerminal(Map<String, dynamic> data) async {
    try {
      await _repo.createTerminal(data);
      await load(page: 1);
      return true;
    } on DioException catch (e) {
      state = TerminalsError(message: _extractError(e));
      return false;
    } catch (e) {
      state = TerminalsError(message: e.toString());
      return false;
    }
  }

  Future<bool> updateTerminal(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateTerminal(id, data);
      await load(page: 1);
      return true;
    } on DioException catch (e) {
      state = TerminalsError(message: _extractError(e));
      return false;
    } catch (e) {
      state = TerminalsError(message: e.toString());
      return false;
    }
  }

  Future<bool> deleteTerminal(String id) async {
    try {
      await _repo.deleteTerminal(id);
      await load(page: 1);
      return true;
    } on DioException catch (e) {
      state = TerminalsError(message: _extractError(e));
      return false;
    } catch (e) {
      state = TerminalsError(message: e.toString());
      return false;
    }
  }

  Future<bool> toggleTerminalStatus(String id) async {
    try {
      await _repo.toggleTerminalStatus(id);
      await load(page: 1);
      return true;
    } on DioException catch (e) {
      state = TerminalsError(message: _extractError(e));
      return false;
    } catch (e) {
      state = TerminalsError(message: e.toString());
      return false;
    }
  }
}
