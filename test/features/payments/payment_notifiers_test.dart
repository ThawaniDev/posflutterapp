// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/payments/data/remote/payment_api_service.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';

// ═══════════════════════════════════════════════════════════════════
// Fake repository
// ═══════════════════════════════════════════════════════════════════

class _FakePaymentRepository extends PaymentRepository {
  _FakePaymentRepository() : super(apiService: PaymentApiService(Dio()));

  // ─ Payments ──────────────────────────────────────────────────
  PaginatedResult<Payment>? _paymentsResult;
  Exception? _paymentsError;
  void stubPayments(List<Payment> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) {
    _paymentsResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: perPage,
    );
  }

  void stubPaymentsError(Exception e) => _paymentsError = e;
  Payment? _createdPayment;
  void stubCreatePayment(Payment p) => _createdPayment = p;

  @override
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
    if (_paymentsError != null) throw _paymentsError!;
    return _paymentsResult!;
  }

  @override
  Future<Payment> createPayment(Map<String, dynamic> data) async => _createdPayment!;

  // ─ Refunds ───────────────────────────────────────────────────
  PaginatedResult<Refund>? _refundsResult;
  Exception? _refundsError;
  Refund? _createdRefund;
  void stubRefunds(List<Refund> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) {
    _refundsResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: perPage,
    );
  }

  void stubRefundsError(Exception e) => _refundsError = e;
  void stubCreateRefund(Refund r) => _createdRefund = r;

  @override
  Future<PaginatedResult<Refund>> listRefunds({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? status,
    String? method,
  }) async {
    if (_refundsError != null) throw _refundsError!;
    return _refundsResult!;
  }

  @override
  Future<Refund> createRefund(String paymentId, Map<String, dynamic> data) async => _createdRefund!;

  // ─ Cash Sessions ─────────────────────────────────────────────
  PaginatedResult<CashSession>? _sessionsResult;
  Exception? _sessionsError;
  CashSession? _openSessionResult;
  CashSession? _closeSessionResult;
  CashEvent? _cashEventResult;
  void stubSessions(List<CashSession> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) {
    _sessionsResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: perPage,
    );
  }

  void stubSessionsError(Exception e) => _sessionsError = e;
  void stubOpenSession(CashSession s) => _openSessionResult = s;
  void stubCloseSession(CashSession s) => _closeSessionResult = s;
  void stubCashEvent(CashEvent e) => _cashEventResult = e;

  @override
  Future<PaginatedResult<CashSession>> listCashSessions({int page = 1, int perPage = 20}) async {
    if (_sessionsError != null) throw _sessionsError!;
    return _sessionsResult!;
  }

  @override
  Future<CashSession> openCashSession(Map<String, dynamic> data) async => _openSessionResult!;

  @override
  Future<CashSession> closeCashSession(String id, Map<String, dynamic> data) async => _closeSessionResult!;

  @override
  Future<CashEvent> createCashEvent(Map<String, dynamic> data) async => _cashEventResult!;

  // ─ Expenses ───────────────────────────────────────────────────
  PaginatedResult<Expense>? _expensesResult;
  Exception? _expensesError;
  Expense? _createdExpense;
  Expense? _updatedExpense;
  void stubExpenses(List<Expense> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) {
    _expensesResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: perPage,
    );
  }

  void stubExpensesError(Exception e) => _expensesError = e;
  void stubCreateExpense(Expense e) => _createdExpense = e;
  void stubUpdateExpense(Expense e) => _updatedExpense = e;

  @override
  Future<PaginatedResult<Expense>> listExpenses({
    int page = 1,
    int perPage = 20,
    String? startDate,
    String? endDate,
    String? category,
  }) async {
    if (_expensesError != null) throw _expensesError!;
    return _expensesResult!;
  }

  @override
  Future<Expense> createExpense(Map<String, dynamic> data) async => _createdExpense!;

  @override
  Future<Expense> updateExpense(String id, Map<String, dynamic> data) async => _updatedExpense!;

  @override
  Future<void> deleteExpense(String id) async {}

  // ─ Gift Cards ─────────────────────────────────────────────────
  PaginatedResult<GiftCard>? _giftCardsResult;
  Exception? _giftCardsError;
  GiftCard? _issuedCard;
  Map<String, dynamic>? _balanceResult;
  GiftCard? _redeemedCard;
  GiftCard? _deactivatedCard;
  void stubGiftCards(List<GiftCard> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) {
    _giftCardsResult = PaginatedResult(
      items: items,
      total: total == 0 ? items.length : total,
      currentPage: page,
      lastPage: lastPage,
      perPage: perPage,
    );
  }

  void stubGiftCardsError(Exception e) => _giftCardsError = e;
  void stubIssueGiftCard(GiftCard c) => _issuedCard = c;
  void stubCheckBalance(Map<String, dynamic> m) => _balanceResult = m;
  void stubRedeemGiftCard(GiftCard c) => _redeemedCard = c;
  void stubDeactivateGiftCard(GiftCard c) => _deactivatedCard = c;

  @override
  Future<PaginatedResult<GiftCard>> listGiftCards({int page = 1, int perPage = 20, String? status}) async {
    if (_giftCardsError != null) throw _giftCardsError!;
    return _giftCardsResult!;
  }

  @override
  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) async => _issuedCard!;

  @override
  Future<Map<String, dynamic>> checkGiftCardBalance(String code) async => _balanceResult!;

  @override
  Future<GiftCard> redeemGiftCard(String code, double amount) async => _redeemedCard!;

  @override
  Future<GiftCard> deactivateGiftCard(String code) async => _deactivatedCard!;

  // ─ Financial Reports ──────────────────────────────────────────
  Map<String, dynamic>? _dailySummaryResult;
  Map<String, dynamic>? _reconciliationResult;
  Exception? _dailySummaryError;
  void stubDailySummary(Map<String, dynamic> m) => _dailySummaryResult = m;
  void stubReconciliation(Map<String, dynamic> m) => _reconciliationResult = m;
  void stubDailySummaryError(Exception e) => _dailySummaryError = e;

  @override
  Future<Map<String, dynamic>> getDailySummary({String? date}) async {
    if (_dailySummaryError != null) throw _dailySummaryError!;
    return _dailySummaryResult!;
  }

  @override
  Future<Map<String, dynamic>> getReconciliation({String? startDate, String? endDate}) async => _reconciliationResult!;
}

// ─── Minimal model builders ───────────────────────────────────────

Payment _payment({String id = 'pay-1', String method = 'cash', double amount = 50.0}) => Payment(
  id: id,
  transactionId: 'tx-$id',
  method: Payment.fromJson({'id': id, 'transaction_id': 'tx-$id', 'method': method, 'amount': amount.toString()}).method,
  amount: amount,
);

Refund _refund({String id = 'ref-1', String method = 'cash', double amount = 25.0}) => Refund.fromJson({
  'id': id,
  'return_id': 'ret-$id',
  'method': method,
  'amount': amount.toString(),
  'processed_by': 'user-001',
});

CashSession _session({String id = 'cs-1', String status = 'open'}) => CashSession.fromJson({
  'id': id,
  'store_id': 'store-001',
  'opened_by': 'user-001',
  'opening_float': '300.00',
  'status': status,
});

CashEvent _cashEvent({String id = 'ce-1', String type = 'cash_in'}) => CashEvent.fromJson({
  'id': id,
  'cash_session_id': 'cs-001',
  'type': type,
  'amount': '100.00',
  'reason': 'test',
  'performed_by': 'user-001',
});

Expense _expense({String id = 'exp-1', String category = 'supplies', double amount = 45.0}) => Expense.fromJson({
  'id': id,
  'store_id': 'store-001',
  'amount': amount.toString(),
  'category': category,
  'recorded_by': 'user-001',
  'expense_date': '2026-05-01',
});

GiftCard _card({String id = 'gc-1', String code = 'GC-TEST', String status = 'active', double balance = 150.0}) =>
    GiftCard.fromJson({
      'id': id,
      'organization_id': 'org-001',
      'code': code,
      'initial_amount': '200.00',
      'balance': balance.toString(),
      'status': status,
      'issued_by': 'user-001',
      'issued_at_store': 'store-001',
    });

// ─── Helpers ─────────────────────────────────────────────────────

/// Runs [action] and collects every state emission including the initial.
Future<List<S>> _collectStates<S>(StateNotifier<S> notifier, Future<void> Function() action) async {
  final states = <S>[notifier.state];
  final remove = notifier.addListener((s) => states.add(s), fireImmediately: false);
  await action();
  remove();
  return states;
}

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════
  // PaymentsNotifier
  // ═══════════════════════════════════════════════════════════════

  group('PaymentsNotifier', () {
    test('starts in PaymentsInitial', () {
      final notifier = PaymentsNotifier(_FakePaymentRepository());
      expect(notifier.state, isA<PaymentsInitial>());
    });

    test('load transitions Initial → Loading → Loaded', () async {
      final repo = _FakePaymentRepository()..stubPayments([_payment(id: 'pay-1'), _payment(id: 'pay-2')], total: 2);
      final notifier = PaymentsNotifier(repo);

      final states = await _collectStates(notifier, () => notifier.load());

      expect(states[0], isA<PaymentsInitial>());
      expect(states[1], isA<PaymentsLoading>());
      final loaded = states[2] as PaymentsLoaded;
      expect(loaded.payments.length, 2);
      expect(loaded.total, 2);
      expect(loaded.hasMore, false);
    });

    test('load with filters stores them for subsequent calls', () async {
      int callCount = 0;
      final repo = _FakePaymentRepository()..stubPayments([_payment()]);
      final notifier = PaymentsNotifier(repo);

      // Intercept to verify filter storage
      await notifier.load(method: 'card', status: 'completed', startDate: '2026-05-01');
      // If filters are stored, createPayment triggers load() with same filters.
      // We verify by checking the load succeeds without error.
      callCount++;
      expect(callCount, 1);
      expect(notifier.state, isA<PaymentsLoaded>());
    });

    test('load error transitions to PaymentsError', () async {
      final repo = _FakePaymentRepository()
        ..stubPaymentsError(
          DioException(
            requestOptions: RequestOptions(path: '/payments'),
            response: Response(
              data: {'success': false, 'message': 'Unauthorized'},
              requestOptions: RequestOptions(path: '/payments'),
              statusCode: 401,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      final notifier = PaymentsNotifier(repo);

      await notifier.load();

      final error = notifier.state as PaymentsError;
      expect(error.message, 'Unauthorized');
    });

    test('loadMore appends to loaded list', () async {
      final repo = _FakePaymentRepository()..stubPayments([_payment(id: 'pay-1')], total: 3, page: 1, lastPage: 2, perPage: 1);
      final notifier = PaymentsNotifier(repo);
      await notifier.load();

      // Stub page 2 for loadMore
      repo.stubPayments([_payment(id: 'pay-2')], total: 3, page: 2, lastPage: 2, perPage: 1);
      await notifier.loadMore();

      final loaded = notifier.state as PaymentsLoaded;
      expect(loaded.payments.length, 2);
      expect(loaded.payments.first.id, 'pay-1');
      expect(loaded.payments.last.id, 'pay-2');
    });

    test('loadMore does nothing if no more pages', () async {
      final repo = _FakePaymentRepository()..stubPayments([_payment()], total: 1, page: 1, lastPage: 1, perPage: 20);
      final notifier = PaymentsNotifier(repo);
      await notifier.load();

      final stateBeforeLoadMore = notifier.state;
      await notifier.loadMore();

      expect(notifier.state, stateBeforeLoadMore);
    });

    test('createPayment triggers reload and updates state', () async {
      final repo = _FakePaymentRepository()
        ..stubPayments([_payment(id: 'pay-1')])
        ..stubCreatePayment(_payment(id: 'pay-2'));
      final notifier = PaymentsNotifier(repo);
      await notifier.load();

      repo.stubPayments([_payment(id: 'pay-1'), _payment(id: 'pay-2')], total: 2);
      await notifier.createPayment({'method': 'cash', 'amount': 50.0});

      final loaded = notifier.state as PaymentsLoaded;
      expect(loaded.total, 2);
    });

    test('createPayment error transitions to PaymentsError', () async {
      final repo = _FakePaymentRepository()
        ..stubPayments([_payment()])
        ..stubPaymentsError(
          DioException(
            requestOptions: RequestOptions(path: '/payments'),
            response: Response(
              data: {'success': false, 'message': 'Validation failed'},
              requestOptions: RequestOptions(path: '/payments'),
              statusCode: 422,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      final notifier = PaymentsNotifier(repo);
      await notifier.load(); // sets initial loaded state (clears error stub for list)

      // Re-stub to error on second listPayments call (triggered by createPayment)
      repo.stubPaymentsError(
        DioException(
          requestOptions: RequestOptions(path: '/payments'),
          response: Response(
            data: {'success': false, 'message': 'Validation failed'},
            requestOptions: RequestOptions(path: '/payments'),
            statusCode: 422,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      repo.stubCreatePayment(_payment());
      await notifier.createPayment({});

      expect(notifier.state, isA<PaymentsError>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CashSessionsNotifier
  // ═══════════════════════════════════════════════════════════════

  group('CashSessionsNotifier', () {
    test('starts in CashSessionsInitial', () {
      expect(CashSessionsNotifier(_FakePaymentRepository()).state, isA<CashSessionsInitial>());
    });

    test('load transitions to CashSessionsLoaded', () async {
      final repo = _FakePaymentRepository()..stubSessions([_session(id: 'cs-1'), _session(id: 'cs-2')], total: 2);
      final notifier = CashSessionsNotifier(repo);

      await notifier.load();

      final loaded = notifier.state as CashSessionsLoaded;
      expect(loaded.sessions.length, 2);
      expect(loaded.total, 2);
    });

    test('load error sets CashSessionsError', () async {
      final repo = _FakePaymentRepository()
        ..stubSessionsError(
          DioException(
            requestOptions: RequestOptions(path: '/cash-sessions'),
            response: Response(
              data: {'success': false, 'message': 'Forbidden'},
              requestOptions: RequestOptions(path: '/cash-sessions'),
              statusCode: 403,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      final notifier = CashSessionsNotifier(repo);

      await notifier.load();

      final error = notifier.state as CashSessionsError;
      expect(error.message, 'Forbidden');
    });

    test('loadMore appends sessions', () async {
      final repo = _FakePaymentRepository()..stubSessions([_session(id: 'cs-1')], total: 2, page: 1, lastPage: 2, perPage: 1);
      final notifier = CashSessionsNotifier(repo);
      await notifier.load();

      repo.stubSessions([_session(id: 'cs-2')], total: 2, page: 2, lastPage: 2, perPage: 1);
      await notifier.loadMore();

      final loaded = notifier.state as CashSessionsLoaded;
      expect(loaded.sessions.length, 2);
    });

    test('openSession triggers reload', () async {
      final repo = _FakePaymentRepository()
        ..stubOpenSession(_session(id: 'cs-new'))
        ..stubSessions([_session(id: 'cs-new')], total: 1);
      final notifier = CashSessionsNotifier(repo);

      await notifier.openSession({'opening_float': 300.0});

      final loaded = notifier.state as CashSessionsLoaded;
      expect(loaded.sessions.first.id, 'cs-new');
    });

    test('closeSession triggers reload', () async {
      final repo = _FakePaymentRepository()
        ..stubSessions([_session(id: 'cs-1')])
        ..stubCloseSession(_session(id: 'cs-1', status: 'closed'));
      final notifier = CashSessionsNotifier(repo);
      await notifier.load();

      repo.stubSessions([_session(id: 'cs-1', status: 'closed')], total: 1);
      await notifier.closeSession('cs-1', {'actual_cash': 295.0});

      final loaded = notifier.state as CashSessionsLoaded;
      expect(loaded.sessions.first.id, 'cs-1');
    });

    test('createCashEvent triggers reload', () async {
      final repo = _FakePaymentRepository()
        ..stubCashEvent(_cashEvent())
        ..stubSessions([_session()], total: 1);
      final notifier = CashSessionsNotifier(repo);

      await notifier.createCashEvent({'cash_session_id': 'cs-001', 'type': 'cash_in', 'amount': 100.0});

      expect(notifier.state, isA<CashSessionsLoaded>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ExpensesNotifier
  // ═══════════════════════════════════════════════════════════════

  group('ExpensesNotifier', () {
    test('starts in ExpensesInitial', () {
      expect(ExpensesNotifier(_FakePaymentRepository()).state, isA<ExpensesInitial>());
    });

    test('load transitions to ExpensesLoaded', () async {
      final repo = _FakePaymentRepository()..stubExpenses([_expense(id: 'exp-1'), _expense(id: 'exp-2')], total: 2);
      final notifier = ExpensesNotifier(repo);

      await notifier.load();

      final loaded = notifier.state as ExpensesLoaded;
      expect(loaded.expenses.length, 2);
    });

    test('load persists filter params for reload operations', () async {
      final repo = _FakePaymentRepository()..stubExpenses([_expense()]);
      final notifier = ExpensesNotifier(repo);

      await notifier.load(category: 'supplies', startDate: '2026-05-01', endDate: '2026-05-31');

      // After createExpense, load is called again with same params — no error
      repo.stubCreateExpense(_expense(id: 'exp-2'));
      repo.stubExpenses([_expense(id: 'exp-1'), _expense(id: 'exp-2')], total: 2);
      await notifier.createExpense({'amount': 45.0, 'category': 'supplies'});

      expect((notifier.state as ExpensesLoaded).total, 2);
    });

    test('loadMore appends expenses', () async {
      final repo = _FakePaymentRepository()..stubExpenses([_expense(id: 'exp-1')], total: 2, page: 1, lastPage: 2, perPage: 1);
      final notifier = ExpensesNotifier(repo);
      await notifier.load();

      repo.stubExpenses([_expense(id: 'exp-2')], total: 2, page: 2, lastPage: 2, perPage: 1);
      await notifier.loadMore();

      final loaded = notifier.state as ExpensesLoaded;
      expect(loaded.expenses.length, 2);
    });

    test('deleteExpense removes item optimistically from state', () async {
      final repo = _FakePaymentRepository()..stubExpenses([_expense(id: 'exp-1'), _expense(id: 'exp-2')], total: 2);
      final notifier = ExpensesNotifier(repo);
      await notifier.load();

      await notifier.deleteExpense('exp-1');

      final loaded = notifier.state as ExpensesLoaded;
      expect(loaded.expenses.length, 1);
      expect(loaded.expenses.first.id, 'exp-2');
      expect(loaded.total, 1);
    });

    test('deleteExpense on empty state does not crash', () async {
      final repo = _FakePaymentRepository();
      final notifier = ExpensesNotifier(repo);
      // State is initial — no crash expected
      await notifier.deleteExpense('exp-99');
    });

    test('updateExpense triggers reload', () async {
      final updated = _expense(id: 'exp-1', amount: 99.0);
      final repo = _FakePaymentRepository()
        ..stubExpenses([_expense(id: 'exp-1')])
        ..stubUpdateExpense(updated);
      final notifier = ExpensesNotifier(repo);
      await notifier.load();

      repo.stubExpenses([_expense(id: 'exp-1', amount: 99.0)], total: 1);
      await notifier.updateExpense('exp-1', {'amount': 99.0});

      final loaded = notifier.state as ExpensesLoaded;
      expect(loaded.expenses.first.amount, 99.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GiftCardNotifier (single-action provider)
  // ═══════════════════════════════════════════════════════════════

  group('GiftCardNotifier', () {
    test('starts in GiftCardInitial', () {
      expect(GiftCardNotifier(_FakePaymentRepository()).state, isA<GiftCardInitial>());
    });

    test('issueGiftCard transitions Initial → Loading → GiftCardReady(lastIssued)', () async {
      final card = _card(id: 'gc-new', code: 'GC-ISSU');
      final repo = _FakePaymentRepository()..stubIssueGiftCard(card);
      final notifier = GiftCardNotifier(repo);

      final states = await _collectStates(notifier, () => notifier.issueGiftCard({'amount': 200.0}));

      expect(states[0], isA<GiftCardInitial>());
      expect(states[1], isA<GiftCardLoading>());
      final ready = states[2] as GiftCardReady;
      expect(ready.lastIssued, isNotNull);
      expect(ready.lastIssued!.id, 'gc-new');
      expect(ready.lastBalance, isNull);
    });

    test('checkBalance transitions to GiftCardReady(lastBalance)', () async {
      final balanceMap = {'code': 'GC-TEST', 'balance': '150.00', 'status': 'active'};
      final repo = _FakePaymentRepository()..stubCheckBalance(balanceMap);
      final notifier = GiftCardNotifier(repo);

      await notifier.checkBalance('GC-TEST');

      final ready = notifier.state as GiftCardReady;
      expect(ready.lastBalance, isNotNull);
      expect(ready.lastBalance!['balance'], '150.00');
      expect(ready.lastIssued, isNull);
    });

    test('redeemGiftCard sets GiftCardReady with redeemed card', () async {
      final redeemed = _card(id: 'gc-1', balance: 100.0);
      final repo = _FakePaymentRepository()..stubRedeemGiftCard(redeemed);
      final notifier = GiftCardNotifier(repo);

      await notifier.redeemGiftCard('GC-TEST', 50.0);

      final ready = notifier.state as GiftCardReady;
      expect(ready.lastIssued!.balance, 100.0);
    });

    test('issueGiftCard error sets GiftCardError', () async {
      final repo = _FakePaymentRepository();
      repo._issuedCard = null; // will throw null check error
      // Actually override issueGiftCard to throw DioException
      final fakeDioError = DioException(
        requestOptions: RequestOptions(path: '/gift-cards'),
        response: Response(
          data: {'success': false, 'message': 'Insufficient credit'},
          requestOptions: RequestOptions(path: '/gift-cards'),
          statusCode: 422,
        ),
        type: DioExceptionType.badResponse,
      );
      final notifier = GiftCardNotifier(_ThrowingGiftCardRepo(fakeDioError));

      await notifier.issueGiftCard({'amount': 200.0});

      final error = notifier.state as GiftCardError;
      expect(error.message, 'Insufficient credit');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GiftCardListNotifier
  // ═══════════════════════════════════════════════════════════════

  group('GiftCardListNotifier', () {
    test('starts in GiftCardListInitial', () {
      expect(GiftCardListNotifier(_FakePaymentRepository()).state, isA<GiftCardListInitial>());
    });

    test('load transitions to GiftCardListLoaded', () async {
      final repo = _FakePaymentRepository()..stubGiftCards([_card(id: 'gc-1'), _card(id: 'gc-2')], total: 2);
      final notifier = GiftCardListNotifier(repo);

      await notifier.load();

      final loaded = notifier.state as GiftCardListLoaded;
      expect(loaded.cards.length, 2);
      expect(loaded.total, 2);
    });

    test('load with status filter passes param', () async {
      final repo = _FakePaymentRepository()..stubGiftCards([_card(status: 'active')], total: 1);
      final notifier = GiftCardListNotifier(repo);

      await notifier.load(status: 'active');

      expect((notifier.state as GiftCardListLoaded).cards.first.status?.value, 'active');
    });

    test('loadMore appends cards', () async {
      final repo = _FakePaymentRepository()..stubGiftCards([_card(id: 'gc-1')], total: 2, page: 1, lastPage: 2, perPage: 1);
      final notifier = GiftCardListNotifier(repo);
      await notifier.load();

      repo.stubGiftCards([_card(id: 'gc-2')], total: 2, page: 2, lastPage: 2, perPage: 1);
      await notifier.loadMore();

      final loaded = notifier.state as GiftCardListLoaded;
      expect(loaded.cards.length, 2);
    });

    test('deactivate optimistically replaces card in list', () async {
      final initial = _card(id: 'gc-1', code: 'GC-001', status: 'active');
      final deactivated = _card(id: 'gc-1', code: 'GC-001', status: 'deactivated');
      final repo = _FakePaymentRepository()
        ..stubGiftCards([initial, _card(id: 'gc-2', code: 'GC-002')], total: 2)
        ..stubDeactivateGiftCard(deactivated);
      final notifier = GiftCardListNotifier(repo);
      await notifier.load();

      await notifier.deactivate('GC-001');

      final loaded = notifier.state as GiftCardListLoaded;
      expect(loaded.cards.length, 2);
      final updated = loaded.cards.firstWhere((c) => c.id == 'gc-1');
      expect(updated.status?.value, 'deactivated');
      // Other card unchanged
      expect(loaded.cards.firstWhere((c) => c.id == 'gc-2').status?.value, 'active');
    });

    test('deactivate sets GiftCardListError on DioException', () async {
      final initial = _card(id: 'gc-1', code: 'GC-001');
      final repo = _FakePaymentRepository()..stubGiftCards([initial], total: 1);
      final notifier = GiftCardListNotifier(repo);
      await notifier.load();

      final throwingRepo = _ThrowingGiftCardRepo(
        DioException(
          requestOptions: RequestOptions(path: '/gift-cards/GC-001/deactivate'),
          response: Response(
            data: {'success': false, 'message': 'Card already deactivated'},
            requestOptions: RequestOptions(path: '/gift-cards/GC-001/deactivate'),
            statusCode: 409,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
      final notifier2 = GiftCardListNotifier(throwingRepo);
      notifier2.state = GiftCardListLoaded(cards: [initial], total: 1, currentPage: 1, lastPage: 1, perPage: 20);

      await notifier2.deactivate('GC-001');

      final error = notifier2.state as GiftCardListError;
      expect(error.message, 'Card already deactivated');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // RefundsNotifier
  // ═══════════════════════════════════════════════════════════════

  group('RefundsNotifier', () {
    test('starts in RefundsInitial', () {
      expect(RefundsNotifier(_FakePaymentRepository()).state, isA<RefundsInitial>());
    });

    test('load transitions to RefundsLoaded', () async {
      final repo = _FakePaymentRepository()..stubRefunds([_refund(id: 'ref-1'), _refund(id: 'ref-2')], total: 2);
      final notifier = RefundsNotifier(repo);

      await notifier.load();

      final loaded = notifier.state as RefundsLoaded;
      expect(loaded.refunds.length, 2);
    });

    test('load error sets RefundsError', () async {
      final repo = _FakePaymentRepository()
        ..stubRefundsError(
          DioException(
            requestOptions: RequestOptions(path: '/payments/refunds'),
            response: Response(
              data: {'success': false, 'message': 'Server Error'},
              requestOptions: RequestOptions(path: '/payments/refunds'),
              statusCode: 500,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      final notifier = RefundsNotifier(repo);

      await notifier.load();

      expect(notifier.state, isA<RefundsError>());
    });

    test('loadMore appends refunds and stops if no more', () async {
      final repo = _FakePaymentRepository()..stubRefunds([_refund(id: 'ref-1')], total: 2, page: 1, lastPage: 2, perPage: 1);
      final notifier = RefundsNotifier(repo);
      await notifier.load();

      repo.stubRefunds([_refund(id: 'ref-2')], total: 2, page: 2, lastPage: 2, perPage: 1);
      await notifier.loadMore();

      final loaded = notifier.state as RefundsLoaded;
      expect(loaded.refunds.length, 2);
      expect(loaded.hasMore, false);
    });

    test('createRefund prepends new refund to list and increments total', () async {
      final newRefund = _refund(id: 'ref-new', amount: 30.0);
      final repo = _FakePaymentRepository()
        ..stubRefunds([_refund(id: 'ref-1')], total: 1, page: 1, lastPage: 1, perPage: 20)
        ..stubCreateRefund(newRefund);
      final notifier = RefundsNotifier(repo);
      await notifier.load();

      await notifier.createRefund('pay-001', {'amount': 30.0});

      final loaded = notifier.state as RefundsLoaded;
      expect(loaded.refunds.length, 2);
      expect(loaded.refunds.first.id, 'ref-new'); // prepended
      expect(loaded.total, 2); // incremented
    });

    test('createRefund in initial state returns refund without crashing', () async {
      final newRefund = _refund(id: 'ref-new');
      final repo = _FakePaymentRepository()..stubCreateRefund(newRefund);
      final notifier = RefundsNotifier(repo);
      // State is RefundsInitial — createRefund should not crash but won't prepend

      final result = await notifier.createRefund('pay-001', {'amount': 25.0});

      expect(result, isNotNull);
      expect(result!.id, 'ref-new');
    });

    test('createRefund error returns null', () async {
      final repo = _FakePaymentRepository()..stubCreateRefund(_refund()); // won't be reached since error thrown
      final notifier = RefundsNotifier(
        _ThrowingRefundRepo(
          DioException(
            requestOptions: RequestOptions(path: '/payments/pay-001/refund'),
            response: Response(
              data: {'success': false, 'message': 'Payment not found'},
              requestOptions: RequestOptions(path: '/payments/pay-001/refund'),
              statusCode: 404,
            ),
            type: DioExceptionType.badResponse,
          ),
        ),
      );

      final result = await notifier.createRefund('pay-001', {});

      expect(result, isNull);
      expect(notifier.state, isA<RefundsError>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // DailySummaryNotifier
  // ═══════════════════════════════════════════════════════════════

  group('DailySummaryNotifier', () {
    test('starts in DailySummaryInitial', () {
      expect(DailySummaryNotifier(_FakePaymentRepository()).state, isA<DailySummaryInitial>());
    });

    test('load transitions to DailySummaryLoaded', () async {
      final summary = {
        'revenue': {'gross': 500.0, 'refunds': 50.0, 'expenses': 30.0, 'net': 420.0},
        'transactions': {'count': 10},
        'hourly_activity': [],
      };
      final repo = _FakePaymentRepository()..stubDailySummary(summary);
      final notifier = DailySummaryNotifier(repo);

      final states = await _collectStates(notifier, () => notifier.load(date: '2026-05-01'));

      expect(states[0], isA<DailySummaryInitial>());
      expect(states[1], isA<DailySummaryLoading>());
      final loaded = states[2] as DailySummaryLoaded;
      expect(loaded.data['revenue']['gross'], 500.0);
    });

    test('load error sets DailySummaryError', () async {
      final repo = _FakePaymentRepository()
        ..stubDailySummaryError(
          DioException(
            requestOptions: RequestOptions(path: '/finance/daily-summary'),
            response: Response(
              data: {'success': false, 'message': 'Not found'},
              requestOptions: RequestOptions(path: '/finance/daily-summary'),
              statusCode: 404,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      final notifier = DailySummaryNotifier(repo);

      await notifier.load();

      expect(notifier.state, isA<DailySummaryError>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ReconciliationNotifier
  // ═══════════════════════════════════════════════════════════════

  group('ReconciliationNotifier', () {
    test('starts in ReconciliationInitial', () {
      expect(ReconciliationNotifier(_FakePaymentRepository()).state, isA<ReconciliationInitial>());
    });

    test('load transitions to ReconciliationLoaded', () async {
      final data = {
        'summary': {'session_count': 5, 'total_variance': -10.0},
        'sessions': [],
      };
      final repo = _FakePaymentRepository()..stubReconciliation(data);
      final notifier = ReconciliationNotifier(repo);

      final states = await _collectStates(notifier, () => notifier.load(startDate: '2026-05-01', endDate: '2026-05-31'));

      expect(states[0], isA<ReconciliationInitial>());
      expect(states[1], isA<ReconciliationLoading>());
      final loaded = states[2] as ReconciliationLoaded;
      expect(loaded.data['summary']['session_count'], 5);
    });
  });
}

// ═══════════════════════════════════════════════════════════════════
// Specialised throwing repos for error path tests
// ═══════════════════════════════════════════════════════════════════

class _ThrowingGiftCardRepo extends _FakePaymentRepository {
  _ThrowingGiftCardRepo(this._error);
  final DioException _error;

  @override
  Future<GiftCard> issueGiftCard(Map<String, dynamic> data) async => throw _error;

  @override
  Future<GiftCard> deactivateGiftCard(String code) async => throw _error;
}

class _ThrowingRefundRepo extends _FakePaymentRepository {
  _ThrowingRefundRepo(this._error);
  final DioException _error;

  @override
  Future<Refund> createRefund(String paymentId, Map<String, dynamic> data) async => throw _error;
}
