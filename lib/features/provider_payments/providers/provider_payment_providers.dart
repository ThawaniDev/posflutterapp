import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_state.dart';
import 'package:wameedpos/features/provider_payments/repositories/provider_payment_repository.dart';

// ─── Payments List ──────────────────────────────────────────
final providerPaymentsListProvider = StateNotifierProvider<ProviderPaymentsListNotifier, ProviderPaymentsListState>((ref) {
  return ProviderPaymentsListNotifier(ref.watch(providerPaymentRepositoryProvider));
});

class ProviderPaymentsListNotifier extends StateNotifier<ProviderPaymentsListState> {
  ProviderPaymentsListNotifier(this._repository) : super(const ProviderPaymentsListInitial());
  final ProviderPaymentRepository _repository;

  Future<void> loadPayments({String? status, String? purpose}) async {
    state = const ProviderPaymentsListLoading();
    try {
      final payments = await _repository.listPayments(status: status, purpose: purpose);
      state = ProviderPaymentsListLoaded(payments: payments);
    } catch (e) {
      state = ProviderPaymentsListError(message: _extractMessage(e));
    }
  }

  Future<void> refresh() async {
    try {
      final payments = await _repository.listPayments();
      state = ProviderPaymentsListLoaded(payments: payments);
    } catch (e) {
      state = ProviderPaymentsListError(message: _extractMessage(e));
    }
  }

  String _extractMessage(dynamic e) {
    if (e is ProviderPaymentException) return e.message;
    return e.toString();
  }
}

// ─── Payment Detail ─────────────────────────────────────────
final providerPaymentDetailProvider = StateNotifierProvider<ProviderPaymentDetailNotifier, ProviderPaymentDetailState>((ref) {
  return ProviderPaymentDetailNotifier(ref.watch(providerPaymentRepositoryProvider));
});

class ProviderPaymentDetailNotifier extends StateNotifier<ProviderPaymentDetailState> {
  ProviderPaymentDetailNotifier(this._repository) : super(const ProviderPaymentDetailInitial());
  final ProviderPaymentRepository _repository;

  Future<void> loadPayment(String id) async {
    state = const ProviderPaymentDetailLoading();
    try {
      final payment = await _repository.getPayment(id);
      state = ProviderPaymentDetailLoaded(payment: payment);
    } catch (e) {
      state = ProviderPaymentDetailError(message: _extractMessage(e));
    }
  }

  String _extractMessage(dynamic e) {
    if (e is ProviderPaymentException) return e.message;
    return e.toString();
  }
}

// ─── Payment Action (initiate, resend email) ────────────────
final providerPaymentActionProvider = StateNotifierProvider<ProviderPaymentActionNotifier, ProviderPaymentActionState>((ref) {
  return ProviderPaymentActionNotifier(ref.watch(providerPaymentRepositoryProvider));
});

class ProviderPaymentActionNotifier extends StateNotifier<ProviderPaymentActionState> {
  ProviderPaymentActionNotifier(this._repository) : super(const ProviderPaymentActionIdle());
  final ProviderPaymentRepository _repository;

  Future<void> initiatePayment(
    AppLocalizations l10n, {
    required String purpose,
    required String purposeLabel,
    required double amount,
    double? taxAmount,
    String? subscriptionPlanId,
    String? addOnId,
    String? purposeReferenceId,
    String? currency,
    String? billingCycle,
    String? discountCode,
    String? notes,
  }) async {
    state = const ProviderPaymentActionLoading();
    try {
      final payment = await _repository.initiatePayment(
        purpose: purpose,
        purposeLabel: purposeLabel,
        amount: amount,
        taxAmount: taxAmount,
        subscriptionPlanId: subscriptionPlanId,
        addOnId: addOnId,
        purposeReferenceId: purposeReferenceId,
        currency: currency,
        billingCycle: billingCycle,
        discountCode: discountCode,
        notes: notes,
      );
      state = ProviderPaymentActionSuccess(message: l10n.providerPaymentInitiated, payment: payment);
    } catch (e) {
      state = ProviderPaymentActionError(message: _extractMessage(e));
    }
  }

  Future<void> resendEmail(AppLocalizations l10n, String paymentId) async {
    state = const ProviderPaymentActionLoading();
    try {
      await _repository.resendEmail(paymentId);
      state = ProviderPaymentActionSuccess(message: l10n.providerEmailResent);
    } catch (e) {
      state = ProviderPaymentActionError(message: _extractMessage(e));
    }
  }

  void reset() {
    state = const ProviderPaymentActionIdle();
  }

  String _extractMessage(dynamic e) {
    if (e is ProviderPaymentException) return e.message;
    return e.toString();
  }
}

// ─── Statistics ─────────────────────────────────────────────
final paymentStatisticsProvider = StateNotifierProvider<PaymentStatisticsNotifier, PaymentStatisticsState>((ref) {
  return PaymentStatisticsNotifier(ref.watch(providerPaymentRepositoryProvider));
});

class PaymentStatisticsNotifier extends StateNotifier<PaymentStatisticsState> {
  PaymentStatisticsNotifier(this._repository) : super(const PaymentStatisticsInitial());
  final ProviderPaymentRepository _repository;

  Future<void> loadStatistics() async {
    state = const PaymentStatisticsLoading();
    try {
      final stats = await _repository.getStatistics();
      state = PaymentStatisticsLoaded(statistics: stats);
    } catch (e) {
      state = PaymentStatisticsError(message: e is ProviderPaymentException ? e.message : e.toString());
    }
  }
}
