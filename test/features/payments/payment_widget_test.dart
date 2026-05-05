// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/payments/data/remote/payment_api_service.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/enums/refund_status.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';
import 'package:wameedpos/features/payments/pages/cash_management_page.dart';
import 'package:wameedpos/features/payments/pages/daily_summary_page.dart';
import 'package:wameedpos/features/payments/pages/expenses_page.dart';
import 'package:wameedpos/features/payments/pages/gift_cards_page.dart';
import 'package:wameedpos/features/payments/pages/payment_list_page.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';
import 'package:wameedpos/features/security/enums/session_status.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake dependency chain (never used — overridden methods are all no-ops)
// ─────────────────────────────────────────────────────────────────────────────

final _stubRepo = PaymentRepository(apiService: PaymentApiService(Dio()));

// ─────────────────────────────────────────────────────────────────────────────
// Fake Notifiers — extend real notifiers, seed state, override async to no-op
// ─────────────────────────────────────────────────────────────────────────────

class _FakePaymentsNotifier extends PaymentsNotifier {
  _FakePaymentsNotifier(PaymentsState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({int page = 1, String? method, String? status, String? startDate, String? endDate, String? search}) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<void> createPayment(Map<String, dynamic> data) async {}
}

class _FakeCashSessionsNotifier extends CashSessionsNotifier {
  _FakeCashSessionsNotifier(CashSessionsState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({int page = 1}) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<void> openSession(Map<String, dynamic> data) async {}
  @override
  Future<void> closeSession(String id, Map<String, dynamic> data) async {}
  @override
  Future<void> createCashEvent(Map<String, dynamic> data) async {}
}

class _FakeExpensesNotifier extends ExpensesNotifier {
  _FakeExpensesNotifier(ExpensesState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({int page = 1, String? startDate, String? endDate, String? category}) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<void> createExpense(Map<String, dynamic> data) async {}
  @override
  Future<void> updateExpense(String id, Map<String, dynamic> data) async {}
  @override
  Future<void> deleteExpense(String id) async {}
}

class _FakeGiftCardListNotifier extends GiftCardListNotifier {
  _FakeGiftCardListNotifier(GiftCardListState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({int page = 1, String? status}) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<GiftCard?> deactivate(String code) async => null;
}

class _FakeGiftCardNotifier extends GiftCardNotifier {
  _FakeGiftCardNotifier(GiftCardState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> issueGiftCard(Map<String, dynamic> data) async {}
  @override
  Future<void> checkBalance(String code) async {}
  @override
  Future<void> redeemGiftCard(String code, double amount) async {}
}

class _FakeRefundsNotifier extends RefundsNotifier {
  _FakeRefundsNotifier(RefundsState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({int page = 1, String? startDate, String? endDate, String? status, String? method}) async {}
  @override
  Future<void> loadMore() async {}
  @override
  Future<Refund?> createRefund(String paymentId, Map<String, dynamic> data) async => null;
}

class _FakeDailySummaryNotifier extends DailySummaryNotifier {
  _FakeDailySummaryNotifier(DailySummaryState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({String? date}) async {}
}

class _FakeReconciliationNotifier extends ReconciliationNotifier {
  _FakeReconciliationNotifier(ReconciliationState initial) : super(_stubRepo) {
    state = initial;
  }
  @override
  Future<void> load({String? startDate, String? endDate}) async {}
}

// ─────────────────────────────────────────────────────────────────────────────
// Sample data factories
// ─────────────────────────────────────────────────────────────────────────────

Payment _payment({
  String id = 'pay-1',
  PaymentMethodKey method = PaymentMethodKey.cash,
  double amount = 120.0,
  String transactionId = 'TXN-001',
}) => Payment(id: id, transactionId: transactionId, method: method, amount: amount, createdAt: DateTime(2024, 1, 15));

CashSession _openSession({String id = 'cs-1'}) => const CashSession(
  id: 'cs-1',
  storeId: 'store-1',
  openedBy: 'user-1',
  openingFloat: 200.0,
  status: SessionStatus.open,
  openedAt: null,
);

CashSession _closedSession({String id = 'cs-closed'}) => CashSession(
  id: id,
  storeId: 'store-1',
  openedBy: 'user-1',
  closedBy: 'user-2',
  openingFloat: 200.0,
  expectedCash: 350.0,
  actualCash: 348.0,
  variance: -2.0,
  status: SessionStatus.closed,
  openedAt: DateTime(2024, 1, 15, 8),
  closedAt: DateTime(2024, 1, 15, 18),
);

Expense _expense({String id = 'exp-1', ExpenseCategory category = ExpenseCategory.supplies, double amount = 75.0}) => Expense(
  id: id,
  storeId: 'store-1',
  amount: amount,
  category: category,
  recordedBy: 'user-1',
  expenseDate: DateTime(2024, 1, 15),
  createdAt: DateTime(2024, 1, 15, 9),
  updatedAt: DateTime(2024, 1, 15, 9),
);

GiftCard _giftCard({
  String id = 'gc-1',
  String code = 'GC-ABCD-1234',
  GiftCardStatus? status = GiftCardStatus.active,
  double balance = 75.0,
}) => GiftCard(
  id: id,
  organizationId: 'org-1',
  code: code,
  initialAmount: 100.0,
  balance: balance,
  status: status,
  issuedBy: 'user-1',
  issuedAtStore: 'store-1',
  createdAt: DateTime(2024, 1, 10),
);

Refund _refund({String id = 'ref-1', RefundStatus? status = RefundStatus.completed, double amount = 40.0}) => Refund(
  id: id,
  returnId: 'ret-1',
  paymentId: 'pay-1',
  method: PaymentMethodKey.cash,
  amount: amount,
  status: status,
  processedBy: 'user-1',
  createdAt: DateTime(2024, 1, 15, 11),
);

// ─────────────────────────────────────────────────────────────────────────────
// Widget wrapper
// ─────────────────────────────────────────────────────────────────────────────

Widget _wrap(Widget child, {required List<Override> overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

List<Override> _allProviderOverrides({
  PaymentsState? payments,
  CashSessionsState? sessions,
  ExpensesState? expenses,
  GiftCardListState? giftCardList,
  GiftCardState? giftCard,
  RefundsState? refunds,
  DailySummaryState? dailySummary,
  ReconciliationState? reconciliation,
}) => [
  paymentsProvider.overrideWith((ref) => _FakePaymentsNotifier(payments ?? const PaymentsInitial())),
  cashSessionsProvider.overrideWith((ref) => _FakeCashSessionsNotifier(sessions ?? const CashSessionsInitial())),
  expensesProvider.overrideWith((ref) => _FakeExpensesNotifier(expenses ?? const ExpensesInitial())),
  giftCardListProvider.overrideWith((ref) => _FakeGiftCardListNotifier(giftCardList ?? const GiftCardListInitial())),
  giftCardProvider.overrideWith((ref) => _FakeGiftCardNotifier(giftCard ?? const GiftCardInitial())),
  refundsProvider.overrideWith((ref) => _FakeRefundsNotifier(refunds ?? const RefundsInitial())),
  dailySummaryProvider.overrideWith((ref) => _FakeDailySummaryNotifier(dailySummary ?? const DailySummaryInitial())),
  reconciliationProvider.overrideWith((ref) => _FakeReconciliationNotifier(reconciliation ?? const ReconciliationInitial())),
];

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // PaymentListPage
  // ═══════════════════════════════════════════════════════════════════════════

  group('PaymentListPage', () {
    testWidgets('shows loading indicator while loading', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentListPage(), overrides: _allProviderOverrides(payments: const PaymentsLoading())),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows page title', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentListPage(), overrides: _allProviderOverrides(payments: const PaymentsLoading())),
      );
      await tester.pump();
      expect(find.text('Payment History'), findsOneWidget);
    });

    testWidgets('shows empty state when no payments', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PaymentListPage(),
          overrides: _allProviderOverrides(
            payments: const PaymentsLoaded(payments: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('No payments found'), findsOneWidget);
    });

    testWidgets('shows payment items when loaded', (tester) async {
      final payments = [
        _payment(id: 'p1', method: PaymentMethodKey.cash, amount: 120.0),
        _payment(id: 'p2', method: PaymentMethodKey.cardMada, amount: 250.0),
      ];
      await tester.pumpWidget(
        _wrap(
          const PaymentListPage(),
          overrides: _allProviderOverrides(
            payments: PaymentsLoaded(payments: payments, total: 2, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('TXN-001'), findsWidgets);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PaymentListPage(),
          overrides: _allProviderOverrides(payments: const PaymentsError(message: 'Network error')),
        ),
      );
      await tester.pump();
      expect(find.text('Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('filter toggle button is present', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentListPage(), overrides: _allProviderOverrides(payments: const PaymentsInitial())),
      );
      await tester.pump();
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('tapping filter button expands filter panel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const PaymentListPage(),
          overrides: _allProviderOverrides(
            payments: const PaymentsLoaded(payments: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      expect(find.byIcon(Icons.filter_list_off), findsOneWidget);
    });

    testWidgets('info tooltip button is present', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentListPage(), overrides: _allProviderOverrides(payments: const PaymentsInitial())),
      );
      await tester.pump();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CashManagementPage
  // ═══════════════════════════════════════════════════════════════════════════

  group('CashManagementPage', () {
    testWidgets('shows page title', (tester) async {
      await tester.pumpWidget(
        _wrap(const CashManagementPage(), overrides: _allProviderOverrides(sessions: const CashSessionsLoading())),
      );
      await tester.pump();
      expect(find.text('Cash Management'), findsOneWidget);
    });

    testWidgets('shows loading while sessions load', (tester) async {
      await tester.pumpWidget(
        _wrap(const CashManagementPage(), overrides: _allProviderOverrides(sessions: const CashSessionsLoading())),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows Open Cash Session button when no active session', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(
            sessions: CashSessionsLoaded(sessions: [_closedSession()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Open Cash Session'), findsOneWidget);
    });

    testWidgets('shows active session card when session is open', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(
            sessions: CashSessionsLoaded(sessions: [_openSession()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Active Session'), findsOneWidget);
    });

    testWidgets('shows Cash In and Cash Out buttons for active session', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(
            sessions: CashSessionsLoaded(sessions: [_openSession()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Cash In'), findsOneWidget);
      expect(find.text('Cash Out'), findsOneWidget);
    });

    testWidgets('shows Close Session button for active session', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(
            sessions: CashSessionsLoaded(sessions: [_openSession()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Close Session'), findsOneWidget);
    });

    testWidgets('shows session history section', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(
            sessions: CashSessionsLoaded(sessions: [_closedSession()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Session History'), findsOneWidget);
    });

    testWidgets('denomination counter section is visible', (tester) async {
      await tester.pumpWidget(
        _wrap(const CashManagementPage(), overrides: _allProviderOverrides(sessions: const CashSessionsInitial())),
      );
      await tester.pump();
      expect(find.text('Cash Count'), findsOneWidget);
    });

    testWidgets('shows error message on session load failure', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const CashManagementPage(),
          overrides: _allProviderOverrides(sessions: const CashSessionsError(message: 'Could not load sessions')),
        ),
      );
      await tester.pump();
      expect(find.text('Could not load sessions'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ExpensesPage
  // ═══════════════════════════════════════════════════════════════════════════

  group('ExpensesPage', () {
    testWidgets('shows page title', (tester) async {
      await tester.pumpWidget(_wrap(const ExpensesPage(), overrides: _allProviderOverrides(expenses: const ExpensesLoading())));
      await tester.pump();
      expect(find.text('Expenses'), findsOneWidget);
    });

    testWidgets('shows loading indicator while loading', (tester) async {
      await tester.pumpWidget(_wrap(const ExpensesPage(), overrides: _allProviderOverrides(expenses: const ExpensesLoading())));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no expenses', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(
            expenses: const ExpensesLoaded(expenses: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('No expenses recorded'), findsOneWidget);
    });

    testWidgets('shows expense items when loaded', (tester) async {
      final expenses = [
        _expense(id: 'e1', category: ExpenseCategory.supplies, amount: 75.0),
        _expense(id: 'e2', category: ExpenseCategory.food, amount: 30.0),
      ];
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(
            expenses: ExpensesLoaded(expenses: expenses, total: 2, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      // Each expense renders category in both title and subtitle
      expect(find.text('supplies'), findsWidgets);
      expect(find.text('food'), findsWidgets);
    });

    testWidgets('shows error with retry', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(expenses: const ExpensesError(message: 'Failed to load expenses')),
        ),
      );
      await tester.pump();
      expect(find.text('Failed to load expenses'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('New Expense button is visible', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(
            expenses: const ExpensesLoaded(expenses: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('New Expense'), findsOneWidget);
    });

    testWidgets('filter bar with date range picker is present', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(
            expenses: ExpensesLoaded(expenses: [_expense()], total: 1, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      // Filter bar has a date range icon
      expect(find.byIcon(Icons.date_range), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GiftCardsPage
  // ═══════════════════════════════════════════════════════════════════════════

  group('GiftCardsPage', () {
    testWidgets('shows page title', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.text('Gift Cards'), findsOneWidget);
    });

    testWidgets('shows Issue tab by default', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.text('Issue'), findsOneWidget);
    });

    testWidgets('shows Check Balance tab', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.text('Check Balance'), findsOneWidget);
    });

    testWidgets('shows Redeem tab', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.text('Redeem'), findsOneWidget);
    });

    testWidgets('shows Manage tab', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.text('Manage'), findsOneWidget);
    });

    testWidgets('switching to Manage tab shows gift card list', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const GiftCardsPage(),
          overrides: _allProviderOverrides(
            giftCardList: GiftCardListLoaded(
              cards: [
                _giftCard(),
                _giftCard(id: 'gc-2', code: 'GC-WXYZ-5678'),
              ],
              total: 2,
              currentPage: 1,
              lastPage: 1,
              perPage: 20,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Manage'));
      await tester.pump();
      expect(find.text('GC-ABCD-1234'), findsOneWidget);
      expect(find.text('GC-WXYZ-5678'), findsOneWidget);
    });

    testWidgets('Manage tab shows empty state when no cards', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const GiftCardsPage(),
          overrides: _allProviderOverrides(
            giftCardList: const GiftCardListLoaded(cards: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Manage'));
      await tester.pump();
      expect(find.text('No gift cards found'), findsOneWidget);
    });

    testWidgets('info tooltip button is present', (tester) async {
      await tester.pumpWidget(_wrap(const GiftCardsPage(), overrides: _allProviderOverrides()));
      await tester.pump();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // DailySummaryPage
  // ═══════════════════════════════════════════════════════════════════════════

  group('DailySummaryPage', () {
    testWidgets('shows page title', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailySummaryPage(), overrides: _allProviderOverrides(dailySummary: const DailySummaryInitial())),
      );
      await tester.pump();
      expect(find.text('Daily Summary'), findsOneWidget);
    });

    testWidgets('shows loading indicator while loading', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailySummaryPage(), overrides: _allProviderOverrides(dailySummary: const DailySummaryLoading())),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows date navigation buttons', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailySummaryPage(), overrides: _allProviderOverrides(dailySummary: const DailySummaryInitial())),
      );
      await tester.pump();
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const DailySummaryPage(),
          overrides: _allProviderOverrides(dailySummary: const DailySummaryError(message: 'Could not load summary')),
        ),
      );
      await tester.pump();
      expect(find.text('Could not load summary'), findsOneWidget);
    });

    testWidgets('shows summary data when loaded', (tester) async {
      final now = DateTime.now();
      await tester.pumpWidget(
        _wrap(
          const DailySummaryPage(),
          overrides: _allProviderOverrides(
            dailySummary: DailySummaryLoaded(
              data: {
                'date': '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}',
                'total_revenue': 1500.00,
                'total_transactions': 12,
                'total_refunds': 150.00,
                'total_expenses': 80.00,
                'net_revenue': 1270.00,
                'payment_breakdown': {'cash': 800.00, 'card_mada': 700.00},
              },
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Gross Revenue'), findsOneWidget);
    });

    testWidgets('shows info tooltip button', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailySummaryPage(), overrides: _allProviderOverrides(dailySummary: const DailySummaryInitial())),
      );
      await tester.pump();
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // State-driven rendering: sealed class switch behaviour
  // ═══════════════════════════════════════════════════════════════════════════

  group('State rendering coverage', () {
    testWidgets('PaymentsInitial renders without crash', (tester) async {
      await tester.pumpWidget(
        _wrap(const PaymentListPage(), overrides: _allProviderOverrides(payments: const PaymentsInitial())),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('CashSessionsInitial renders without crash', (tester) async {
      await tester.pumpWidget(
        _wrap(const CashManagementPage(), overrides: _allProviderOverrides(sessions: const CashSessionsInitial())),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('ExpensesInitial renders without crash', (tester) async {
      await tester.pumpWidget(_wrap(const ExpensesPage(), overrides: _allProviderOverrides(expenses: const ExpensesInitial())));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('DailySummaryInitial renders without crash', (tester) async {
      await tester.pumpWidget(
        _wrap(const DailySummaryPage(), overrides: _allProviderOverrides(dailySummary: const DailySummaryInitial())),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('GiftCardsPage renders without crash with GiftCardListLoading', (tester) async {
      await tester.pumpWidget(
        _wrap(const GiftCardsPage(), overrides: _allProviderOverrides(giftCardList: const GiftCardListLoading())),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('GiftCardListError shown in Manage tab', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const GiftCardsPage(),
          overrides: _allProviderOverrides(giftCardList: const GiftCardListError(message: 'Failed to load gift cards')),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Manage'));
      await tester.pump();
      expect(find.text('Failed to load gift cards'), findsOneWidget);
    });

    testWidgets('multiple payments list scrolls without crash', (tester) async {
      final payments = List.generate(15, (i) => _payment(id: 'p$i', transactionId: 'TXN-${i.toString().padLeft(3, '0')}'));
      await tester.pumpWidget(
        _wrap(
          const PaymentListPage(),
          overrides: _allProviderOverrides(
            payments: PaymentsLoaded(payments: payments, total: 15, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('multiple expenses rendered without crash', (tester) async {
      final expenses = [
        _expense(id: 'e1', category: ExpenseCategory.supplies),
        _expense(id: 'e2', category: ExpenseCategory.food),
        _expense(id: 'e3', category: ExpenseCategory.transport),
        _expense(id: 'e4', category: ExpenseCategory.maintenance),
        _expense(id: 'e5', category: ExpenseCategory.utility),
      ];
      await tester.pumpWidget(
        _wrap(
          const ExpensesPage(),
          overrides: _allProviderOverrides(
            expenses: ExpensesLoaded(expenses: expenses, total: 5, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
    });

    testWidgets('gift cards with all statuses render without crash', (tester) async {
      final cards = [
        _giftCard(id: 'gc-1', status: GiftCardStatus.active),
        _giftCard(id: 'gc-2', status: GiftCardStatus.redeemed),
        _giftCard(id: 'gc-3', status: GiftCardStatus.expired),
        _giftCard(id: 'gc-4', status: GiftCardStatus.deactivated),
      ];
      await tester.pumpWidget(
        _wrap(
          const GiftCardsPage(),
          overrides: _allProviderOverrides(
            giftCardList: GiftCardListLoaded(cards: cards, total: 4, currentPage: 1, lastPage: 1, perPage: 20),
          ),
        ),
      );
      await tester.pump();
      await tester.tap(find.text('Manage'));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
