import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';

// ─── Payments State ─────────────────────────────────────────────

sealed class PaymentsState {
  const PaymentsState();
}

class PaymentsInitial extends PaymentsState {
  const PaymentsInitial();
}

class PaymentsLoading extends PaymentsState {
  const PaymentsLoading();
}

class PaymentsLoaded extends PaymentsState {
  final List<Payment> payments;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const PaymentsLoaded({
    required this.payments,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;
}

class PaymentsError extends PaymentsState {
  final String message;
  const PaymentsError({required this.message});
}

// ─── Cash Sessions State ────────────────────────────────────────

sealed class CashSessionsState {
  const CashSessionsState();
}

class CashSessionsInitial extends CashSessionsState {
  const CashSessionsInitial();
}

class CashSessionsLoading extends CashSessionsState {
  const CashSessionsLoading();
}

class CashSessionsLoaded extends CashSessionsState {
  final List<CashSession> sessions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const CashSessionsLoaded({
    required this.sessions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;
}

class CashSessionsError extends CashSessionsState {
  final String message;
  const CashSessionsError({required this.message});
}

// ─── Expenses State ─────────────────────────────────────────────

sealed class ExpensesState {
  const ExpensesState();
}

class ExpensesInitial extends ExpensesState {
  const ExpensesInitial();
}

class ExpensesLoading extends ExpensesState {
  const ExpensesLoading();
}

class ExpensesLoaded extends ExpensesState {
  final List<Expense> expenses;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const ExpensesLoaded({
    required this.expenses,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;
}

class ExpensesError extends ExpensesState {
  final String message;
  const ExpensesError({required this.message});
}

// ─── Gift Card State ────────────────────────────────────────────

sealed class GiftCardState {
  const GiftCardState();
}

class GiftCardInitial extends GiftCardState {
  const GiftCardInitial();
}

class GiftCardLoading extends GiftCardState {
  const GiftCardLoading();
}

class GiftCardReady extends GiftCardState {
  final GiftCard? lastIssued;
  final Map<String, dynamic>? lastBalance;

  const GiftCardReady({this.lastIssued, this.lastBalance});
}

class GiftCardError extends GiftCardState {
  final String message;
  const GiftCardError({required this.message});
}
