import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/refund.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';

// ─── Payments Provider ──────────────────────────────────────────

final paymentsProvider = StateNotifierProvider<PaymentsNotifier, PaymentsState>((ref) {
  return PaymentsNotifier(ref.watch(paymentRepositoryProvider));
});

class PaymentsNotifier extends StateNotifier<PaymentsState> {
  PaymentsNotifier(this._repo) : super(const PaymentsInitial());
  final PaymentRepository _repo;

  String? _method;
  String? _status;
  String? _startDate;
  String? _endDate;
  String? _search;

  Future<void> load({int page = 1, String? method, String? status, String? startDate, String? endDate, String? search}) async {
    _method = method;
    _status = status;
    _startDate = startDate;
    _endDate = endDate;
    _search = search;
    state = const PaymentsLoading();
    try {
      final result = await _repo.listPayments(
        page: page,
        method: _method,
        status: _status,
        startDate: _startDate,
        endDate: _endDate,
        search: _search,
      );
      state = PaymentsLoaded(
        payments: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = PaymentsError(message: _extractError(e));
    } catch (e) {
      state = PaymentsError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! PaymentsLoaded || !current.hasMore) return;
    try {
      final result = await _repo.listPayments(
        page: current.currentPage + 1,
        method: _method,
        status: _status,
        startDate: _startDate,
        endDate: _endDate,
        search: _search,
      );
      state = PaymentsLoaded(
        payments: [...current.payments, ...result.items],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = PaymentsError(message: _extractError(e));
    }
  }

  Future<void> createPayment(Map<String, dynamic> data) async {
    try {
      await _repo.createPayment(data);
      await load(method: _method, status: _status, startDate: _startDate, endDate: _endDate, search: _search);
    } on DioException catch (e) {
      state = PaymentsError(message: _extractError(e));
    }
  }
}

// ─── Cash Sessions Provider ─────────────────────────────────────

final cashSessionsProvider = StateNotifierProvider<CashSessionsNotifier, CashSessionsState>((ref) {
  return CashSessionsNotifier(ref.watch(paymentRepositoryProvider));
});

class CashSessionsNotifier extends StateNotifier<CashSessionsState> {
  CashSessionsNotifier(this._repo) : super(const CashSessionsInitial());
  final PaymentRepository _repo;

  Future<void> load({int page = 1}) async {
    state = const CashSessionsLoading();
    try {
      final result = await _repo.listCashSessions(page: page);
      state = CashSessionsLoaded(
        sessions: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = CashSessionsError(message: _extractError(e));
    } catch (e) {
      state = CashSessionsError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! CashSessionsLoaded || !current.hasMore) return;
    try {
      final result = await _repo.listCashSessions(page: current.currentPage + 1);
      state = CashSessionsLoaded(
        sessions: [...current.sessions, ...result.items],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = CashSessionsError(message: _extractError(e));
    }
  }

  Future<void> openSession(Map<String, dynamic> data) async {
    try {
      await _repo.openCashSession(data);
      await load();
    } on DioException catch (e) {
      state = CashSessionsError(message: _extractError(e));
    }
  }

  Future<void> closeSession(String id, Map<String, dynamic> data) async {
    try {
      await _repo.closeCashSession(id, data);
      await load();
    } on DioException catch (e) {
      state = CashSessionsError(message: _extractError(e));
    }
  }

  Future<void> createCashEvent(Map<String, dynamic> data) async {
    try {
      await _repo.createCashEvent(data);
      await load();
    } on DioException catch (e) {
      state = CashSessionsError(message: _extractError(e));
    }
  }
}

// ─── Expenses Provider ──────────────────────────────────────────

final expensesProvider = StateNotifierProvider<ExpensesNotifier, ExpensesState>((ref) {
  return ExpensesNotifier(ref.watch(paymentRepositoryProvider));
});

class ExpensesNotifier extends StateNotifier<ExpensesState> {
  ExpensesNotifier(this._repo) : super(const ExpensesInitial());
  final PaymentRepository _repo;

  String? _startDate;
  String? _endDate;
  String? _category;

  Future<void> load({int page = 1, String? startDate, String? endDate, String? category}) async {
    _startDate = startDate;
    _endDate = endDate;
    _category = category;
    state = const ExpensesLoading();
    try {
      final result = await _repo.listExpenses(page: page, startDate: _startDate, endDate: _endDate, category: _category);
      state = ExpensesLoaded(
        expenses: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    } catch (e) {
      state = ExpensesError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ExpensesLoaded || !current.hasMore) return;
    try {
      final result = await _repo.listExpenses(
        page: current.currentPage + 1,
        startDate: _startDate,
        endDate: _endDate,
        category: _category,
      );
      state = ExpensesLoaded(
        expenses: [...current.expenses, ...result.items],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    }
  }

  Future<void> createExpense(Map<String, dynamic> data) async {
    try {
      await _repo.createExpense(data);
      await load(startDate: _startDate, endDate: _endDate, category: _category);
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    }
  }

  Future<void> updateExpense(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateExpense(id, data);
      await load(startDate: _startDate, endDate: _endDate, category: _category);
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    }
  }

  Future<void> deleteExpense(String id) async {
    try {
      await _repo.deleteExpense(id);
      // Optimistic removal from current state
      final current = state;
      if (current is ExpensesLoaded) {
        final updated = current.expenses.where((e) => e.id != id).toList();
        state = ExpensesLoaded(
          expenses: updated,
          total: current.total - 1,
          currentPage: current.currentPage,
          lastPage: current.lastPage,
          perPage: current.perPage,
        );
      }
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    }
  }
}

// ─── Gift Card Action Provider ──────────────────────────────────

final giftCardProvider = StateNotifierProvider<GiftCardNotifier, GiftCardState>((ref) {
  return GiftCardNotifier(ref.watch(paymentRepositoryProvider));
});

class GiftCardNotifier extends StateNotifier<GiftCardState> {
  GiftCardNotifier(this._repo) : super(const GiftCardInitial());
  final PaymentRepository _repo;

  Future<void> issueGiftCard(Map<String, dynamic> data) async {
    state = const GiftCardLoading();
    try {
      final card = await _repo.issueGiftCard(data);
      state = GiftCardReady(lastIssued: card);
    } on DioException catch (e) {
      state = GiftCardError(message: _extractError(e));
    } catch (e) {
      state = GiftCardError(message: e.toString());
    }
  }

  Future<void> checkBalance(String code) async {
    state = const GiftCardLoading();
    try {
      final balance = await _repo.checkGiftCardBalance(code);
      state = GiftCardReady(lastBalance: balance);
    } on DioException catch (e) {
      state = GiftCardError(message: _extractError(e));
    } catch (e) {
      state = GiftCardError(message: e.toString());
    }
  }

  Future<void> redeemGiftCard(String code, double amount) async {
    state = const GiftCardLoading();
    try {
      final card = await _repo.redeemGiftCard(code, amount);
      state = GiftCardReady(lastIssued: card);
    } on DioException catch (e) {
      state = GiftCardError(message: _extractError(e));
    } catch (e) {
      state = GiftCardError(message: e.toString());
    }
  }
}

// ─── Gift Card List Provider ────────────────────────────────────

final giftCardListProvider = StateNotifierProvider<GiftCardListNotifier, GiftCardListState>((ref) {
  return GiftCardListNotifier(ref.watch(paymentRepositoryProvider));
});

class GiftCardListNotifier extends StateNotifier<GiftCardListState> {
  GiftCardListNotifier(this._repo) : super(const GiftCardListInitial());
  final PaymentRepository _repo;

  String? _status;

  Future<void> load({int page = 1, String? status}) async {
    _status = status;
    state = const GiftCardListLoading();
    try {
      final result = await _repo.listGiftCards(page: page, status: _status);
      state = GiftCardListLoaded(
        cards: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = GiftCardListError(message: _extractError(e));
    } catch (e) {
      state = GiftCardListError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! GiftCardListLoaded || !current.hasMore) return;
    try {
      final result = await _repo.listGiftCards(page: current.currentPage + 1, status: _status);
      state = GiftCardListLoaded(
        cards: [...current.cards, ...result.items],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = GiftCardListError(message: _extractError(e));
    }
  }

  Future<GiftCard?> deactivate(String code) async {
    try {
      final updated = await _repo.deactivateGiftCard(code);
      final current = state;
      if (current is GiftCardListLoaded) {
        final cards = current.cards.map((c) => c.code == code ? updated : c).toList();
        state = GiftCardListLoaded(
          cards: cards,
          total: current.total,
          currentPage: current.currentPage,
          lastPage: current.lastPage,
          perPage: current.perPage,
        );
      }
      return updated;
    } on DioException catch (e) {
      state = GiftCardListError(message: _extractError(e));
      return null;
    }
  }
}

// ─── Refunds Provider ───────────────────────────────────────────

final refundsProvider = StateNotifierProvider<RefundsNotifier, RefundsState>((ref) {
  return RefundsNotifier(ref.watch(paymentRepositoryProvider));
});

class RefundsNotifier extends StateNotifier<RefundsState> {
  RefundsNotifier(this._repo) : super(const RefundsInitial());
  final PaymentRepository _repo;

  String? _startDate;
  String? _endDate;
  String? _status;
  String? _method;

  Future<void> load({int page = 1, String? startDate, String? endDate, String? status, String? method}) async {
    _startDate = startDate;
    _endDate = endDate;
    _status = status;
    _method = method;
    state = const RefundsLoading();
    try {
      final result = await _repo.listRefunds(
        page: page,
        startDate: _startDate,
        endDate: _endDate,
        status: _status,
        method: _method,
      );
      state = RefundsLoaded(
        refunds: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = RefundsError(message: _extractError(e));
    } catch (e) {
      state = RefundsError(message: e.toString());
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! RefundsLoaded || !current.hasMore) return;
    try {
      final result = await _repo.listRefunds(
        page: current.currentPage + 1,
        startDate: _startDate,
        endDate: _endDate,
        status: _status,
        method: _method,
      );
      state = RefundsLoaded(
        refunds: [...current.refunds, ...result.items],
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = RefundsError(message: _extractError(e));
    }
  }

  Future<Refund?> createRefund(String paymentId, Map<String, dynamic> data) async {
    try {
      final refund = await _repo.createRefund(paymentId, data);
      // Prepend to current list
      final current = state;
      if (current is RefundsLoaded) {
        state = RefundsLoaded(
          refunds: [refund, ...current.refunds],
          total: current.total + 1,
          currentPage: current.currentPage,
          lastPage: current.lastPage,
          perPage: current.perPage,
        );
      }
      return refund;
    } on DioException catch (e) {
      state = RefundsError(message: _extractError(e));
      return null;
    }
  }
}

// ─── Daily Summary Provider ─────────────────────────────────────

final dailySummaryProvider = StateNotifierProvider<DailySummaryNotifier, DailySummaryState>((ref) {
  return DailySummaryNotifier(ref.watch(paymentRepositoryProvider));
});

class DailySummaryNotifier extends StateNotifier<DailySummaryState> {
  DailySummaryNotifier(this._repo) : super(const DailySummaryInitial());
  final PaymentRepository _repo;

  Future<void> load({String? date}) async {
    state = const DailySummaryLoading();
    try {
      final data = await _repo.getDailySummary(date: date);
      state = DailySummaryLoaded(data: data);
    } on DioException catch (e) {
      state = DailySummaryError(message: _extractError(e));
    } catch (e) {
      state = DailySummaryError(message: e.toString());
    }
  }
}

// ─── Reconciliation Provider ────────────────────────────────────

final reconciliationProvider = StateNotifierProvider<ReconciliationNotifier, ReconciliationState>((ref) {
  return ReconciliationNotifier(ref.watch(paymentRepositoryProvider));
});

class ReconciliationNotifier extends StateNotifier<ReconciliationState> {
  ReconciliationNotifier(this._repo) : super(const ReconciliationInitial());
  final PaymentRepository _repo;

  Future<void> load({String? startDate, String? endDate}) async {
    state = const ReconciliationLoading();
    try {
      final data = await _repo.getReconciliation(startDate: startDate, endDate: endDate);
      state = ReconciliationLoaded(data: data);
    } on DioException catch (e) {
      state = ReconciliationError(message: _extractError(e));
    } catch (e) {
      state = ReconciliationError(message: e.toString());
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
