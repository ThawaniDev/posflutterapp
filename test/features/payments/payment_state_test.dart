import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/payments/enums/cash_event_type.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/security/enums/session_status.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // PaymentsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('PaymentsState', () {
    test('PaymentsInitial is default state', () {
      const state = PaymentsInitial();
      expect(state, isA<PaymentsState>());
    });

    test('PaymentsLoading indicates loading', () {
      const state = PaymentsLoading();
      expect(state, isA<PaymentsState>());
    });

    test('PaymentsLoaded holds payments and pagination', () {
      final payments = [
        const Payment(id: 'p1', transactionId: 't1', method: PaymentMethodKey.cash, amount: 100.0),
        const Payment(id: 'p2', transactionId: 't2', method: PaymentMethodKey.cardVisa, amount: 200.0),
      ];

      final state = PaymentsLoaded(payments: payments, total: 50, currentPage: 1, lastPage: 3, perPage: 20);

      expect(state, isA<PaymentsState>());
      expect(state.payments, hasLength(2));
      expect(state.total, 50);
      expect(state.hasMore, true);
    });

    test('PaymentsLoaded hasMore false on last page', () {
      const state = PaymentsLoaded(payments: [], total: 5, currentPage: 1, lastPage: 1, perPage: 20);
      expect(state.hasMore, false);
    });

    test('PaymentsLoaded pagination check', () {
      const state = PaymentsLoaded(payments: [], total: 10, currentPage: 1, lastPage: 2, perPage: 20);
      expect(state.hasMore, true);

      const state2 = PaymentsLoaded(payments: [], total: 10, currentPage: 2, lastPage: 2, perPage: 20);
      expect(state2.hasMore, false);
    });

    test('PaymentsError holds message', () {
      const state = PaymentsError(message: 'Payment failed');
      expect(state, isA<PaymentsState>());
      expect(state.message, 'Payment failed');
    });

    test('sealed class switch', () {
      const PaymentsState state = PaymentsLoading();
      final result = switch (state) {
        PaymentsInitial() => 'initial',
        PaymentsLoading() => 'loading',
        PaymentsLoaded(:final payments) => 'loaded:${payments.length}',
        PaymentsError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CashSessionsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CashSessionsState', () {
    test('all subtypes are CashSessionsState', () {
      expect(const CashSessionsInitial(), isA<CashSessionsState>());
      expect(const CashSessionsLoading(), isA<CashSessionsState>());
      expect(const CashSessionsError(message: 'e'), isA<CashSessionsState>());
    });

    test('CashSessionsLoaded holds sessions and pagination', () {
      final sessions = [const CashSession(id: 'cs1', storeId: 's1', openedBy: 'u1', openingFloat: 500.0, status: SessionStatus.open)];

      final state = CashSessionsLoaded(sessions: sessions, total: 10, currentPage: 1, lastPage: 1, perPage: 20);

      expect(state.sessions, hasLength(1));
      expect(state.hasMore, false);
    });

    test('CashSessionsLoaded pagination', () {
      const state = CashSessionsLoaded(sessions: [], total: 5, currentPage: 1, lastPage: 2, perPage: 20);
      expect(state.hasMore, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ExpensesState Tests
  // ═══════════════════════════════════════════════════════════════

  group('ExpensesState', () {
    test('all subtypes', () {
      expect(const ExpensesInitial(), isA<ExpensesState>());
      expect(const ExpensesLoading(), isA<ExpensesState>());
      expect(const ExpensesError(message: 'e'), isA<ExpensesState>());
    });

    test('ExpensesLoaded holds expenses and pagination', () {
      final expenses = [
        Expense(
          id: 'e1',
          storeId: 's1',
          amount: 25.5,
          category: ExpenseCategory.supplies,
          recordedBy: 'u1',
          expenseDate: DateTime(2024, 6, 1),
        ),
      ];

      final state = ExpensesLoaded(expenses: expenses, total: 1, currentPage: 1, lastPage: 1, perPage: 20);

      expect(state.expenses, hasLength(1));
      expect(state.expenses.first.category, ExpenseCategory.supplies);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GiftCardState Tests
  // ═══════════════════════════════════════════════════════════════

  group('GiftCardState', () {
    test('all subtypes', () {
      expect(const GiftCardInitial(), isA<GiftCardState>());
      expect(const GiftCardLoading(), isA<GiftCardState>());
      expect(const GiftCardError(message: 'e'), isA<GiftCardState>());
    });

    test('GiftCardReady holds optional gift card and balance', () {
      const gc = GiftCard(
        id: 'gc1',
        organizationId: 'o1',
        code: 'GC-TEST1234',
        initialAmount: 100.0,
        balance: 75.0,
        issuedBy: 'u1',
        issuedAtStore: 's1',
        status: GiftCardStatus.active,
      );

      const state = GiftCardReady(lastIssued: gc);
      expect(state.lastIssued?.code, 'GC-TEST1234');
      expect(state.lastIssued?.balance, 75.0);
      expect(state.lastBalance, isNull);
    });

    test('GiftCardReady with balance check', () {
      const state = GiftCardReady(lastBalance: {'code': 'GC-12345', 'balance': 50.0, 'status': 'active'});
      expect(state.lastBalance?['balance'], 50.0);
      expect(state.lastIssued, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Payment Enums Tests
  // ═══════════════════════════════════════════════════════════════

  group('Payment Enums', () {
    test('PaymentMethodKey values', () {
      expect(PaymentMethodKey.cash.value, 'cash');
      expect(PaymentMethodKey.cardMada.value, 'card_mada');
      expect(PaymentMethodKey.giftCard.value, 'gift_card');
      expect(PaymentMethodKey.fromValue('cash'), PaymentMethodKey.cash);
    });

    test('CashEventType values', () {
      expect(CashEventType.cashIn.value, 'cash_in');
      expect(CashEventType.cashOut.value, 'cash_out');
    });

    test('ExpenseCategory values', () {
      expect(ExpenseCategory.supplies.value, 'supplies');
      expect(ExpenseCategory.food.value, 'food');
      expect(ExpenseCategory.other.value, 'other');
    });

    test('GiftCardStatus values', () {
      expect(GiftCardStatus.active.value, 'active');
      expect(GiftCardStatus.redeemed.value, 'redeemed');
      expect(GiftCardStatus.expired.value, 'expired');
      expect(GiftCardStatus.deactivated.value, 'deactivated');
    });
  });
}
