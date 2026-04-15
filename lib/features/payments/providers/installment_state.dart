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
  final List<InstallmentProviderConfig> providers;
  const InstallmentAdminLoaded({required this.providers});
}

class InstallmentAdminError extends InstallmentAdminState {
  final String message;
  const InstallmentAdminError({required this.message});
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
  final List<StoreInstallmentConfig> configs;
  final List<Map<String, dynamic>> availableProviders;
  const StoreInstallmentConfigLoaded({required this.configs, required this.availableProviders});
}

class StoreInstallmentConfigError extends StoreInstallmentConfigState {
  final String message;
  const StoreInstallmentConfigError({required this.message});
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
  final List<CheckoutProviderOption> providers;
  const InstallmentCheckoutProvidersLoaded({required this.providers});
}

class InstallmentCheckoutCreated extends InstallmentCheckoutState {
  final InstallmentPayment payment;
  const InstallmentCheckoutCreated({required this.payment});
}

class InstallmentCheckoutCompleted extends InstallmentCheckoutState {
  final InstallmentPayment payment;
  const InstallmentCheckoutCompleted({required this.payment});
}

class InstallmentCheckoutCancelled extends InstallmentCheckoutState {
  const InstallmentCheckoutCancelled();
}

class InstallmentCheckoutFailed extends InstallmentCheckoutState {
  final String message;
  const InstallmentCheckoutFailed({required this.message});
}

class InstallmentCheckoutError extends InstallmentCheckoutState {
  final String message;
  const InstallmentCheckoutError({required this.message});
}
