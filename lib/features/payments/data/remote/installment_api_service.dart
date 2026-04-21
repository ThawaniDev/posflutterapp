import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/payments/models/checkout_provider_option.dart';
import 'package:wameedpos/features/payments/models/installment_payment.dart';
import 'package:wameedpos/features/payments/models/installment_provider_config.dart';
import 'package:wameedpos/features/payments/models/store_installment_config.dart';

final installmentApiServiceProvider = Provider<InstallmentApiService>((ref) {
  return InstallmentApiService(ref.watch(dioClientProvider));
});

class InstallmentApiService {
  InstallmentApiService(this._dio);
  final Dio _dio;

  // ═══════════════════════════════════════════════════════════════
  // Platform Admin — Provider Management
  // ═══════════════════════════════════════════════════════════════

  Future<List<InstallmentProviderConfig>> listProviders() async {
    final response = await _dio.get('/admin/installment-providers');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List<dynamic>;
    return list.map((j) => InstallmentProviderConfig.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<InstallmentProviderConfig> showProvider(String id) async {
    final response = await _dio.get('/admin/installment-providers/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentProviderConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentProviderConfig> updateProvider(String id, Map<String, dynamic> data) async {
    final response = await _dio.put('/admin/installment-providers/$id', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentProviderConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentProviderConfig> toggleProvider(String id) async {
    final response = await _dio.post('/admin/installment-providers/$id/toggle');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentProviderConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentProviderConfig> setMaintenance(String id, Map<String, dynamic> data) async {
    final response = await _dio.post('/admin/installment-providers/$id/maintenance', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentProviderConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ═══════════════════════════════════════════════════════════════
  // Store Admin — Installment Configuration
  // ═══════════════════════════════════════════════════════════════

  Future<List<Map<String, dynamic>>> getAvailableProviders() async {
    final response = await _dio.get('/installments/config/available');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List<dynamic>;
    return list.map((j) => j as Map<String, dynamic>).toList();
  }

  Future<List<StoreInstallmentConfig>> listStoreConfigs() async {
    final response = await _dio.get('/installments/config');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List<dynamic>;
    return list.map((j) => StoreInstallmentConfig.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<StoreInstallmentConfig> showStoreConfig(String provider) async {
    final response = await _dio.get('/installments/config/$provider');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreInstallmentConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreInstallmentConfig> upsertStoreConfig(Map<String, dynamic> data) async {
    final response = await _dio.post('/installments/config', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return StoreInstallmentConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreInstallmentConfig> toggleStoreConfig(String provider) async {
    final response = await _dio.post('/installments/config/$provider/toggle');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreInstallmentConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteStoreConfig(String provider) async {
    await _dio.delete('/installments/config/$provider');
  }

  Future<Map<String, dynamic>> testConnection(String provider) async {
    final response = await _dio.post('/installments/config/$provider/test');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>? ?? {};
  }

  // ═══════════════════════════════════════════════════════════════
  // POS Checkout — Installment Payments
  // ═══════════════════════════════════════════════════════════════

  Future<List<CheckoutProviderOption>> getCheckoutProviders({required double amount, String currency = ''}) async {
    final response = await _dio.get('/installments/providers', queryParameters: {'amount': amount, 'currency': currency});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.data as List<dynamic>;
    return list.map((j) => CheckoutProviderOption.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<Map<String, dynamic>> tamaraPreCheck(Map<String, dynamic> data) async {
    final response = await _dio.post('/installments/tamara-precheck', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>? ?? {};
  }

  Future<InstallmentPayment> createCheckout(Map<String, dynamic> data) async {
    final response = await _dio.post('/installments/checkout', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentPayment> confirmPayment(String id, {Map<String, dynamic>? providerData}) async {
    final response = await _dio.post('/installments/$id/confirm', data: {'provider_data': ?providerData});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentPayment> cancelPayment(String id) async {
    final response = await _dio.post('/installments/$id/cancel');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentPayment> failPayment(String id, {String? errorCode, String? errorMessage}) async {
    final response = await _dio.post('/installments/$id/fail', data: {'error_code': ?errorCode, 'error_message': ?errorMessage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<InstallmentPayment> showPayment(String id) async {
    final response = await _dio.get('/installments/$id');
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return InstallmentPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
