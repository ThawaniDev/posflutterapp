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
  final List<ProviderPayment> payments;
  const ProviderPaymentsListLoaded({required this.payments});
}

class ProviderPaymentsListError extends ProviderPaymentsListState {
  final String message;
  const ProviderPaymentsListError({required this.message});
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
  final ProviderPayment payment;
  const ProviderPaymentDetailLoaded({required this.payment});
}

class ProviderPaymentDetailError extends ProviderPaymentDetailState {
  final String message;
  const ProviderPaymentDetailError({required this.message});
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
  final String message;
  final ProviderPayment? payment;
  const ProviderPaymentActionSuccess({required this.message, this.payment});
}

class ProviderPaymentActionError extends ProviderPaymentActionState {
  final String message;
  const ProviderPaymentActionError({required this.message});
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
  final Map<String, dynamic> statistics;
  const PaymentStatisticsLoaded({required this.statistics});
}

class PaymentStatisticsError extends PaymentStatisticsState {
  final String message;
  const PaymentStatisticsError({required this.message});
}
