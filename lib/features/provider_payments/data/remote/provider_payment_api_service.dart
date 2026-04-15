import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';

final providerPaymentApiServiceProvider = Provider<ProviderPaymentApiService>((ref) {
  return ProviderPaymentApiService(ref.watch(dioClientProvider));
});

class ProviderPaymentApiService {
  final Dio _dio;

  ProviderPaymentApiService(this._dio);

  Future<List<ProviderPayment>> listPayments({int? page, int? perPage, String? status, String? purpose}) async {
    final response = await _dio.get(
      ApiEndpoints.providerPayments,
      queryParameters: {
        if (page != null) 'page': page,
        if (perPage != null) 'per_page': perPage,
        if (status != null) 'status': status,
        if (purpose != null) 'purpose': purpose,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((e) => ProviderPayment.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<ProviderPayment> getPayment(String id) async {
    final response = await _dio.get(ApiEndpoints.providerPaymentById(id));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ProviderPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  /// Initiate a payment. Returns a [ProviderPayment] with [redirectUrl] set.
  ///
  /// Maps [subscriptionPlanId] or [addOnId] to the server's `purpose_reference_id`.
  /// The server computes tax automatically, so [taxAmount] is not sent.
  Future<ProviderPayment> initiatePayment({
    required String purpose,
    required String purposeLabel,
    required double amount,
    String? currency,
    double? taxAmount,
    String? subscriptionPlanId,
    String? addOnId,
    String? notes,
  }) async {
    // Map subscription/addon IDs to purpose_reference_id
    final purposeReferenceId = subscriptionPlanId ?? addOnId;

    final response = await _dio.post(
      ApiEndpoints.providerPaymentsInitiate,
      data: {
        'purpose': purpose,
        'purpose_label': purposeLabel,
        'amount': amount,
        if (currency != null) 'currency': currency,
        if (purposeReferenceId != null) 'purpose_reference_id': purposeReferenceId,
        if (notes != null) 'notes': notes,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ProviderPayment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final response = await _dio.get(ApiEndpoints.providerPaymentsStatistics);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<void> resendEmail(String paymentId) async {
    await _dio.post(ApiEndpoints.providerPaymentResendEmail(paymentId));
  }
}
