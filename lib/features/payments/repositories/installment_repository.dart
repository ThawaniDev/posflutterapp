import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/payments/data/remote/installment_api_service.dart';
import 'package:wameedpos/features/payments/models/checkout_provider_option.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/models/installment_provider_config.dart';
import 'package:wameedpos/features/payments/models/store_installment_config.dart';

final installmentRepositoryProvider = Provider<InstallmentRepository>((ref) {
  return InstallmentRepository(apiService: ref.watch(installmentApiServiceProvider));
});

class InstallmentRepository {
  final InstallmentApiService _apiService;

  InstallmentRepository({required InstallmentApiService apiService}) : _apiService = apiService;

  // ─── Platform Admin ────────────────────────────────────────────
  Future<List<InstallmentProviderConfig>> listProviders() => _apiService.listProviders();
  Future<InstallmentProviderConfig> showProvider(String id) => _apiService.showProvider(id);
  Future<InstallmentProviderConfig> updateProvider(String id, Map<String, dynamic> data) => _apiService.updateProvider(id, data);
  Future<InstallmentProviderConfig> toggleProvider(String id) => _apiService.toggleProvider(id);
  Future<InstallmentProviderConfig> setMaintenance(String id, Map<String, dynamic> data) => _apiService.setMaintenance(id, data);

  // ─── Store Admin ───────────────────────────────────────────────
  Future<List<Map<String, dynamic>>> getAvailableProviders() => _apiService.getAvailableProviders();
  Future<List<StoreInstallmentConfig>> listStoreConfigs() => _apiService.listStoreConfigs();
  Future<StoreInstallmentConfig> showStoreConfig(String provider) => _apiService.showStoreConfig(provider);
  Future<StoreInstallmentConfig> upsertStoreConfig(Map<String, dynamic> data) => _apiService.upsertStoreConfig(data);
  Future<StoreInstallmentConfig> toggleStoreConfig(String provider) => _apiService.toggleStoreConfig(provider);
  Future<void> deleteStoreConfig(String provider) => _apiService.deleteStoreConfig(provider);
  Future<Map<String, dynamic>> testConnection(String provider) => _apiService.testConnection(provider);

  // ─── POS Checkout ──────────────────────────────────────────────
  Future<List<CheckoutProviderOption>> getCheckoutProviders({required double amount, String currency = 'SAR'}) =>
      _apiService.getCheckoutProviders(amount: amount, currency: currency);
  Future<Map<String, dynamic>> tamaraPreCheck(Map<String, dynamic> data) => _apiService.tamaraPreCheck(data);
  Future<InstallmentPayment> createCheckout(Map<String, dynamic> data) => _apiService.createCheckout(data);
  Future<InstallmentPayment> confirmPayment(String id, {Map<String, dynamic>? providerData}) =>
      _apiService.confirmPayment(id, providerData: providerData);
  Future<InstallmentPayment> cancelPayment(String id) => _apiService.cancelPayment(id);
  Future<InstallmentPayment> failPayment(String id, {String? errorCode, String? errorMessage}) =>
      _apiService.failPayment(id, errorCode: errorCode, errorMessage: errorMessage);
  Future<InstallmentPayment> showPayment(String id) => _apiService.showPayment(id);
}
