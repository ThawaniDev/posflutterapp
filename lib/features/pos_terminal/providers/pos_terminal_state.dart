import 'package:wameedpos/features/pos_terminal/models/held_cart.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/register.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';

// ─── POS Sessions State ─────────────────────────────────────────

sealed class PosSessionsState {
  const PosSessionsState();
}

class PosSessionsInitial extends PosSessionsState {
  const PosSessionsInitial();
}

class PosSessionsLoading extends PosSessionsState {
  const PosSessionsLoading();
}

class PosSessionsLoaded extends PosSessionsState {
  final List<PosSession> sessions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const PosSessionsLoaded({
    required this.sessions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;

  PosSessionsLoaded copyWith({List<PosSession>? sessions, int? total, int? currentPage, int? lastPage, int? perPage}) =>
      PosSessionsLoaded(
        sessions: sessions ?? this.sessions,
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
      );
}

class PosSessionsError extends PosSessionsState {
  final String message;
  const PosSessionsError({required this.message});
}

// ─── Transactions State ─────────────────────────────────────────

sealed class TransactionsState {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

class TransactionsLoaded extends TransactionsState {
  final List<Transaction> transactions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const TransactionsLoaded({
    required this.transactions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;

  TransactionsLoaded copyWith({List<Transaction>? transactions, int? total, int? currentPage, int? lastPage, int? perPage}) =>
      TransactionsLoaded(
        transactions: transactions ?? this.transactions,
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        perPage: perPage ?? this.perPage,
      );
}

class TransactionsError extends TransactionsState {
  final String message;
  const TransactionsError({required this.message});
}

// ─── Held Carts State ───────────────────────────────────────────

sealed class HeldCartsState {
  const HeldCartsState();
}

class HeldCartsInitial extends HeldCartsState {
  const HeldCartsInitial();
}

class HeldCartsLoading extends HeldCartsState {
  const HeldCartsLoading();
}

class HeldCartsLoaded extends HeldCartsState {
  final List<HeldCart> carts;
  const HeldCartsLoaded({required this.carts});

  HeldCartsLoaded copyWith({List<HeldCart>? carts}) => HeldCartsLoaded(carts: carts ?? this.carts);
}

class HeldCartsError extends HeldCartsState {
  final String message;
  const HeldCartsError({required this.message});
}

// ─── Terminals (Registers) State ────────────────────────────────

sealed class TerminalsState {
  const TerminalsState();
}

class TerminalsInitial extends TerminalsState {
  const TerminalsInitial();
}

class TerminalsLoading extends TerminalsState {
  const TerminalsLoading();
}

class TerminalsLoaded extends TerminalsState {
  final List<Register> terminals;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? search;

  const TerminalsLoaded({
    required this.terminals,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.search,
  });

  bool get hasMore => currentPage < lastPage;

  TerminalsLoaded copyWith({
    List<Register>? terminals,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? search,
  }) => TerminalsLoaded(
    terminals: terminals ?? this.terminals,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    search: search ?? this.search,
  );
}

class TerminalsError extends TerminalsState {
  final String message;
  const TerminalsError({required this.message});
}
