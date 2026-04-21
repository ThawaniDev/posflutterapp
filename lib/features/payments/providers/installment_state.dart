import 'package:wameedpos/features/payments/models/checkout_provider_option.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/models/installment_provider_config.dart';
import 'package:wameedpos/features/payments/models/store_installment_config.dart';

// ═══════════════════════════════════════════════════════════════
// Platform Admin — Provider Management State
// ═══════════════════════════════════════════════════════════════

sealed class InstallmentAdminState {
  const InstallmentAdminState();
}

class InstallmentAdminInitial extends InstallmentAdminState {
  const InstallmentAdminInitial();
}

class InstallmentAdminLoading extends InstallmentAdminState {
  const InstallmentAdminLoading();
}

class InstallmentAdminLoaded extends InstallmentAdminState {
  const InstallmentAdminLoaded({required this.providers});
  final List<InstallmentProviderConfig> providers;
}

class InstallmentAdminError extends InstallmentAdminState {
  const InstallmentAdminError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// Store Config State
// ═══════════════════════════════════════════════════════════════

sealed class StoreInstallmentConfigState {
  const StoreInstallmentConfigState();
}

class StoreInstallmentConfigInitial extends StoreInstallmentConfigState {
  const StoreInstallmentConfigInitial();
}

class StoreInstallmentConfigLoading extends StoreInstallmentConfigState {
  const StoreInstallmentConfigLoading();
}

class StoreInstallmentConfigLoaded extends StoreInstallmentConfigState {
  const StoreInstallmentConfigLoaded({required this.configs, required this.availableProviders});
  final List<StoreInstallmentConfig> configs;
  final List<Map<String, dynamic>> availableProviders;
}

class StoreInstallmentConfigError extends StoreInstallmentConfigState {
  const StoreInstallmentConfigError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// POS Checkout — Provider Selection State
// ═══════════════════════════════════════════════════════════════

sealed class InstallmentCheckoutState {
  const InstallmentCheckoutState();
}

class InstallmentCheckoutInitial extends InstallmentCheckoutState {
  const InstallmentCheckoutInitial();
}

class InstallmentCheckoutLoading extends InstallmentCheckoutState {
  const InstallmentCheckoutLoading();
}

class InstallmentCheckoutProvidersLoaded extends InstallmentCheckoutState {
  const InstallmentCheckoutProvidersLoaded({required this.providers});
  final List<CheckoutProviderOption> providers;
}

class InstallmentCheckoutCreated extends InstallmentCheckoutState {
  const InstallmentCheckoutCreated({required this.payment});
  final InstallmentPayment payment;
}

class InstallmentCheckoutCompleted extends InstallmentCheckoutState {
  const InstallmentCheckoutCompleted({required this.payment});
  final InstallmentPayment payment;
}

class InstallmentCheckoutCancelled extends InstallmentCheckoutState {
  const InstallmentCheckoutCancelled();
}

class InstallmentCheckoutFailed extends InstallmentCheckoutState {
  const InstallmentCheckoutFailed({required this.message});
  final String message;
}

class InstallmentCheckoutError extends InstallmentCheckoutState {
  const InstallmentCheckoutError({required this.message});
  final String message;
}
