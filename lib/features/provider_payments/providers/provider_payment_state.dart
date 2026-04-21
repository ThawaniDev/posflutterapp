import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';

// ─── Payments List State ─────────────────────────────────────
sealed class ProviderPaymentsListState {
  const ProviderPaymentsListState();
}

class ProviderPaymentsListInitial extends ProviderPaymentsListState {
  const ProviderPaymentsListInitial();
}

class ProviderPaymentsListLoading extends ProviderPaymentsListState {
  const ProviderPaymentsListLoading();
}

class ProviderPaymentsListLoaded extends ProviderPaymentsListState {
  const ProviderPaymentsListLoaded({required this.payments});
  final List<ProviderPayment> payments;
}

class ProviderPaymentsListError extends ProviderPaymentsListState {
  const ProviderPaymentsListError({required this.message});
  final String message;
}

// ─── Payment Detail State ────────────────────────────────────
sealed class ProviderPaymentDetailState {
  const ProviderPaymentDetailState();
}

class ProviderPaymentDetailInitial extends ProviderPaymentDetailState {
  const ProviderPaymentDetailInitial();
}

class ProviderPaymentDetailLoading extends ProviderPaymentDetailState {
  const ProviderPaymentDetailLoading();
}

class ProviderPaymentDetailLoaded extends ProviderPaymentDetailState {
  const ProviderPaymentDetailLoaded({required this.payment});
  final ProviderPayment payment;
}

class ProviderPaymentDetailError extends ProviderPaymentDetailState {
  const ProviderPaymentDetailError({required this.message});
  final String message;
}

// ─── Payment Action State ────────────────────────────────────
sealed class ProviderPaymentActionState {
  const ProviderPaymentActionState();
}

class ProviderPaymentActionIdle extends ProviderPaymentActionState {
  const ProviderPaymentActionIdle();
}

class ProviderPaymentActionLoading extends ProviderPaymentActionState {
  const ProviderPaymentActionLoading();
}

class ProviderPaymentActionSuccess extends ProviderPaymentActionState {
  const ProviderPaymentActionSuccess({required this.message, this.payment});
  final String message;
  final ProviderPayment? payment;
}

class ProviderPaymentActionError extends ProviderPaymentActionState {
  const ProviderPaymentActionError({required this.message});
  final String message;
}

// ─── Statistics State ────────────────────────────────────────
sealed class PaymentStatisticsState {
  const PaymentStatisticsState();
}

class PaymentStatisticsInitial extends PaymentStatisticsState {
  const PaymentStatisticsInitial();
}

class PaymentStatisticsLoading extends PaymentStatisticsState {
  const PaymentStatisticsLoading();
}

class PaymentStatisticsLoaded extends PaymentStatisticsState {
  const PaymentStatisticsLoaded({required this.statistics});
  final Map<String, dynamic> statistics;
}

class PaymentStatisticsError extends PaymentStatisticsState {
  const PaymentStatisticsError({required this.message});
  final String message;
}
