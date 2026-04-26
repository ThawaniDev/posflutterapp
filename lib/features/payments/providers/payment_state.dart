import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';

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
  const PaymentsLoaded({
    required this.payments,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<Payment> payments;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class PaymentsError extends PaymentsState {
  const PaymentsError({required this.message});
  final String message;
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
  const CashSessionsLoaded({
    required this.sessions,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<CashSession> sessions;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class CashSessionsError extends CashSessionsState {
  const CashSessionsError({required this.message});
  final String message;
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
  const ExpensesLoaded({
    required this.expenses,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<Expense> expenses;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class ExpensesError extends ExpensesState {
  const ExpensesError({required this.message});
  final String message;
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
  const GiftCardReady({this.lastIssued, this.lastBalance});
  final GiftCard? lastIssued;
  final Map<String, dynamic>? lastBalance;
}

class GiftCardError extends GiftCardState {
  const GiftCardError({required this.message});
  final String message;
}

// ─── Gift Card List State ────────────────────────────────────────

sealed class GiftCardListState {
  const GiftCardListState();
}

class GiftCardListInitial extends GiftCardListState {
  const GiftCardListInitial();
}

class GiftCardListLoading extends GiftCardListState {
  const GiftCardListLoading();
}

class GiftCardListLoaded extends GiftCardListState {
  const GiftCardListLoaded({
    required this.cards,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<GiftCard> cards;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class GiftCardListError extends GiftCardListState {
  const GiftCardListError({required this.message});
  final String message;
}

// ─── Refunds State ─────────────────────────────────────────────

sealed class RefundsState {
  const RefundsState();
}

class RefundsInitial extends RefundsState {
  const RefundsInitial();
}

class RefundsLoading extends RefundsState {
  const RefundsLoading();
}

class RefundsLoaded extends RefundsState {
  const RefundsLoaded({
    required this.refunds,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<Refund> refunds;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;
}

class RefundsError extends RefundsState {
  const RefundsError({required this.message});
  final String message;
}

// ─── Daily Summary State ────────────────────────────────────────

sealed class DailySummaryState {
  const DailySummaryState();
}

class DailySummaryInitial extends DailySummaryState {
  const DailySummaryInitial();
}

class DailySummaryLoading extends DailySummaryState {
  const DailySummaryLoading();
}

class DailySummaryLoaded extends DailySummaryState {
  const DailySummaryLoaded({required this.data});
  final Map<String, dynamic> data;
}

class DailySummaryError extends DailySummaryState {
  const DailySummaryError({required this.message});
  final String message;
}

// ─── Reconciliation State ───────────────────────────────────────

sealed class ReconciliationState {
  const ReconciliationState();
}

class ReconciliationInitial extends ReconciliationState {
  const ReconciliationInitial();
}

class ReconciliationLoading extends ReconciliationState {
  const ReconciliationLoading();
}

class ReconciliationLoaded extends ReconciliationState {
  const ReconciliationLoaded({required this.data});
  final Map<String, dynamic> data;
}

class ReconciliationError extends ReconciliationState {
  const ReconciliationError({required this.message});
  final String message;
}
