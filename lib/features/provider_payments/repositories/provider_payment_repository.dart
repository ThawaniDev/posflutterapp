import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/errors/app_exception.dart';
import 'package:wameedpos/features/provider_payments/data/remote/provider_payment_api_service.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';

final providerPaymentRepositoryProvider = Provider<ProviderPaymentRepository>((ref) {
  return ProviderPaymentRepository(ref.watch(providerPaymentApiServiceProvider));
});

class ProviderPaymentRepository {
  ProviderPaymentRepository(this._apiService);
  final ProviderPaymentApiService _apiService;

  Future<List<ProviderPayment>> listPayments({int? page, int? perPage, String? status, String? purpose}) async {
    try {
      return await _apiService.listPayments(page: page, perPage: perPage, status: status, purpose: purpose);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<ProviderPayment> getPayment(String id) async {
    try {
      return await _apiService.getPayment(id);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<ProviderPayment> initiatePayment({
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
    try {
      return await _apiService.initiatePayment(
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
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _apiService.getStatistics();
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> resendEmail(String paymentId) async {
    try {
      await _apiService.resendEmail(paymentId);
    } catch (e) {
      throw _mapError(e);
    }
  }

  AppException _mapError(dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final data = error.response?.data;
      final statusCode = error.response?.statusCode;
      String message = 'An unexpected error occurred.';
      if (data is Map<String, dynamic>) {
        message = data['message'] as String? ?? message;
      }
      return ProviderPaymentException(message: message, statusCode: statusCode, originalError: error);
    }
    return ProviderPaymentException(message: error.toString(), originalError: error);
  }
}

class ProviderPaymentException extends AppException {
  const ProviderPaymentException({required super.message, this.statusCode, super.originalError});
  final int? statusCode;

  @override
  String toString() => 'ProviderPaymentException($statusCode): $message';
}
