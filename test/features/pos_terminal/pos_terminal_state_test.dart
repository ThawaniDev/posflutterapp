import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/pos_terminal/models/held_cart.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';
import 'package:thawani_pos/features/pos_terminal/models/transaction.dart';
import 'package:thawani_pos/features/pos_terminal/enums/transaction_type.dart';
import 'package:thawani_pos/features/pos_terminal/enums/transaction_status.dart';
import 'package:thawani_pos/features/security/enums/session_status.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // PosSessionsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('PosSessionsState', () {
    test('PosSessionsInitial is default state', () {
      const state = PosSessionsInitial();
      expect(state, isA<PosSessionsState>());
    });

    test('PosSessionsLoading indicates loading', () {
      const state = PosSessionsLoading();
      expect(state, isA<PosSessionsState>());
    });

    test('PosSessionsLoaded holds sessions and pagination', () {
      final sessions = [
        PosSession(id: 's1', storeId: 'st1', registerId: 'r1', cashierId: 'c1', status: SessionStatus.open, openingCash: 100.0),
        PosSession(id: 's2', storeId: 'st1', registerId: 'r2', cashierId: 'c2', status: SessionStatus.closed, openingCash: 200.0),
      ];

      final state = PosSessionsLoaded(sessions: sessions, total: 50, currentPage: 1, lastPage: 3, perPage: 25);

      expect(state, isA<PosSessionsState>());
      expect(state.sessions, hasLength(2));
      expect(state.total, 50);
      expect(state.currentPage, 1);
      expect(state.hasMore, true);
    });

    test('PosSessionsLoaded hasMore is false on last page', () {
      final state = PosSessionsLoaded(sessions: [], total: 5, currentPage: 1, lastPage: 1, perPage: 25);
      expect(state.hasMore, false);
    });

    test('PosSessionsLoaded copyWith replaces fields', () {
      final state = PosSessionsLoaded(
        sessions: [
          PosSession(id: 's1', storeId: 'st1', registerId: 'r1', cashierId: 'c1', status: SessionStatus.open, openingCash: 100.0),
        ],
        total: 10,
        currentPage: 1,
        lastPage: 2,
        perPage: 25,
      );

      final updated = state.copyWith(currentPage: 2);
      expect(updated.currentPage, 2);
      expect(updated.sessions.first.id, 's1');
    });

    test('PosSessionsError holds message', () {
      const state = PosSessionsError(message: 'Connection failed');
      expect(state, isA<PosSessionsState>());
      expect(state.message, 'Connection failed');
    });

    test('sealed class exhaustive switch', () {
      PosSessionsState state = const PosSessionsLoading();
      final result = switch (state) {
        PosSessionsInitial() => 'initial',
        PosSessionsLoading() => 'loading',
        PosSessionsLoaded(:final sessions) => 'loaded:${sessions.length}',
        PosSessionsError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // TransactionsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('TransactionsState', () {
    test('all subtypes are TransactionsState', () {
      expect(const TransactionsInitial(), isA<TransactionsState>());
      expect(const TransactionsLoading(), isA<TransactionsState>());
      expect(const TransactionsError(message: 'e'), isA<TransactionsState>());
    });

    test('TransactionsLoaded holds transactions and pagination', () {
      final txns = [
        Transaction(
          id: 't1',
          organizationId: 'o1',
          storeId: 'st1',
          registerId: 'r1',
          posSessionId: 'ps1',
          cashierId: 'c1',
          transactionNumber: 'TXN-001',
          type: TransactionType.sale,
          status: TransactionStatus.completed,
          subtotal: 10.0,
          taxAmount: 1.5,
          totalAmount: 11.5,
        ),
      ];

      final state = TransactionsLoaded(transactions: txns, total: 100, currentPage: 2, lastPage: 5, perPage: 20);

      expect(state.transactions, hasLength(1));
      expect(state.total, 100);
      expect(state.hasMore, true);
    });

    test('TransactionsLoaded hasMore false on last page', () {
      final state = TransactionsLoaded(transactions: [], total: 5, currentPage: 1, lastPage: 1, perPage: 20);
      expect(state.hasMore, false);
    });

    test('TransactionsLoaded copyWith', () {
      final state = TransactionsLoaded(transactions: [], total: 10, currentPage: 1, lastPage: 2, perPage: 20);
      final updated = state.copyWith(currentPage: 2, total: 20);
      expect(updated.currentPage, 2);
      expect(updated.total, 20);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // HeldCartsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('HeldCartsState', () {
    test('all subtypes are HeldCartsState', () {
      expect(const HeldCartsInitial(), isA<HeldCartsState>());
      expect(const HeldCartsLoading(), isA<HeldCartsState>());
      expect(const HeldCartsError(message: 'err'), isA<HeldCartsState>());
    });

    test('HeldCartsLoaded holds carts list', () {
      final carts = [
        HeldCart(id: 'h1', storeId: 'st1', registerId: 'r1', cashierId: 'c1', cartData: {'items': []}, label: 'Quick hold'),
      ];

      final state = HeldCartsLoaded(carts: carts);
      expect(state.carts, hasLength(1));
      expect(state.carts.first.label, 'Quick hold');
    });

    test('sealed class switch for HeldCartsState', () {
      HeldCartsState state = const HeldCartsError(message: 'timeout');
      final result = switch (state) {
        HeldCartsInitial() => 'initial',
        HeldCartsLoading() => 'loading',
        HeldCartsLoaded(:final carts) => 'loaded:${carts.length}',
        HeldCartsError(:final message) => 'error:$message',
      };
      expect(result, 'error:timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Model Enum Tests
  // ═══════════════════════════════════════════════════════════════

  group('POS Terminal Enums', () {
    test('SessionStatus values', () {
      expect(SessionStatus.open.value, 'open');
      expect(SessionStatus.closed.value, 'closed');
      expect(SessionStatus.fromValue('open'), SessionStatus.open);
      expect(SessionStatus.fromValue('closed'), SessionStatus.closed);
    });

    test('TransactionType values', () {
      expect(TransactionType.sale.value, 'sale');
      expect(TransactionType.returnValue.value, 'return');
      expect(TransactionType.voidValue.value, 'void');
      expect(TransactionType.exchange.value, 'exchange');
    });

    test('TransactionStatus values', () {
      expect(TransactionStatus.completed.value, 'completed');
      expect(TransactionStatus.voided.value, 'voided');
      expect(TransactionStatus.pending.value, 'pending');
    });
  });
}
