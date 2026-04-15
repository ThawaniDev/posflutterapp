import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';

// ─── Payments Provider ──────────────────────────────────────────

final paymentsProvider = StateNotifierProvider<PaymentsNotifier, PaymentsState>((ref) {
  return PaymentsNotifier(ref.watch(paymentRepositoryProvider));
});

class PaymentsNotifier extends StateNotifier<PaymentsState> {
  final PaymentRepository _repo;

  PaymentsNotifier(this._repo) : super(const PaymentsInitial());

  Future<void> load({int page = 1, String? method}) async {
    state = const PaymentsLoading();
    try {
      final result = await _repo.listPayments(page: page, method: method);
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

  Future<void> createPayment(Map<String, dynamic> data) async {
    try {
      await _repo.createPayment(data);
      await load();
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
  final PaymentRepository _repo;

  CashSessionsNotifier(this._repo) : super(const CashSessionsInitial());

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
      await load(); // Refresh sessions to reflect updated expected_cash
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
  final PaymentRepository _repo;

  ExpensesNotifier(this._repo) : super(const ExpensesInitial());

  Future<void> load({int page = 1}) async {
    state = const ExpensesLoading();
    try {
      final result = await _repo.listExpenses(page: page);
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

  Future<void> createExpense(Map<String, dynamic> data) async {
    try {
      await _repo.createExpense(data);
      await load();
    } on DioException catch (e) {
      state = ExpensesError(message: _extractError(e));
    }
  }
}

// ─── Gift Card Provider ─────────────────────────────────────────

final giftCardProvider = StateNotifierProvider<GiftCardNotifier, GiftCardState>((ref) {
  return GiftCardNotifier(ref.watch(paymentRepositoryProvider));
});

class GiftCardNotifier extends StateNotifier<GiftCardState> {
  final PaymentRepository _repo;

  GiftCardNotifier(this._repo) : super(const GiftCardInitial());

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

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
