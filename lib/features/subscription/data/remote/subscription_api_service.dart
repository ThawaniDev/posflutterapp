import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';

final subscriptionApiServiceProvider = Provider<SubscriptionApiService>((ref) {
  return SubscriptionApiService(ref.watch(dioClientProvider));
});

/// Remote API service for subscription endpoints.
class SubscriptionApiService {
  SubscriptionApiService(this._dio);
  final Dio _dio;

  // ─── Plans ─────────────────────────────────────────────────────

  Future<List<SubscriptionPlan>> listPlans({bool activeOnly = true}) async {
    final response = await _dio.get(ApiEndpoints.subscriptionPlans, queryParameters: {'active_only': activeOnly ? 1 : 0});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((e) => SubscriptionPlan.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<SubscriptionPlan> getPlan(String planId) async {
    final response = await _dio.get('${ApiEndpoints.subscriptionPlans}/$planId');

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return SubscriptionPlan.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<SubscriptionPlan> getPlanBySlug(String slug) async {
    final response = await _dio.get('${ApiEndpoints.subscriptionPlans}/slug/$slug');

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return SubscriptionPlan.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> comparePlans(List<String> planIds) async {
    final response = await _dio.post('${ApiEndpoints.subscriptionPlans}/compare', data: {'plan_ids': planIds});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Subscription Lifecycle ────────────────────────────────────

  Future<StoreSubscription?> getCurrentSubscription() async {
    final response = await _dio.get(ApiEndpoints.subscriptionCurrent);

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    if (apiResponse.data == null) return null;
    return StoreSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreSubscription> subscribe({
    required String planId,
    String billingCycle = 'monthly',
    String? paymentMethod,
    String? discountCode,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.subscriptionSubscribe,
      data: {'plan_id': planId, 'billing_cycle': billingCycle, 'payment_method': paymentMethod, 'discount_code': discountCode}
        ..removeWhere((_, v) => v == null),
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreSubscription> changePlan({required String planId, String billingCycle = 'monthly'}) async {
    final response = await _dio.put(
      ApiEndpoints.subscriptionChangePlan,
      data: {'plan_id': planId, 'billing_cycle': billingCycle},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreSubscription> cancelSubscription({String? reason, String? reasonCategory}) async {
    final response = await _dio.post(
      ApiEndpoints.subscriptionCancel,
      data: {'reason': reason, 'reason_category': reasonCategory}..removeWhere((_, v) => v == null),
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StoreSubscription> resumeSubscription() async {
    final response = await _dio.post(ApiEndpoints.subscriptionResume);

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StoreSubscription.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Usage & Enforcement ───────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUsageSummary() async {
    final response = await _dio.get(ApiEndpoints.subscriptionUsage);

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    if (apiResponse.data == null) return [];
    final list = apiResponse.dataList;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<bool> checkFeature(String featureKey) async {
    final response = await _dio.get('${ApiEndpoints.subscriptionCheckFeature}/$featureKey');

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return data['is_enabled'] as bool;
  }

  Future<Map<String, dynamic>> checkLimit(String limitKey) async {
    final response = await _dio.get('${ApiEndpoints.subscriptionCheckLimit}/$limitKey');

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Discount Code Validation ──────────────────────────────────

  /// Validate a discount code and return pricing preview.
  /// Returns a map with: code, type, value, original_price, discount_amount,
  /// final_price, currency, billing_cycle.
  Future<Map<String, dynamic>> validateDiscount({
    required String code,
    required String planId,
    String billingCycle = 'monthly',
  }) async {
    final response = await _dio.post(
      ApiEndpoints.subscriptionValidateDiscount,
      data: {'code': code, 'plan_id': planId, 'billing_cycle': billingCycle},
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Invoices ──────────────────────────────────────────────────

  Future<List<Invoice>> getInvoices({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.subscriptionInvoices, queryParameters: {'page': page, 'per_page': perPage});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final envelope = apiResponse.data as Map<String, dynamic>;
    final list = envelope['data'] as List<dynamic>;
    return list.map((e) => Invoice.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Invoice> getInvoice(String invoiceId) async {
    final response = await _dio.get('${ApiEndpoints.subscriptionInvoices}/$invoiceId');

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return Invoice.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Invoice PDF ───────────────────────────────────────────────

  /// Get the PDF URL for an invoice. Returns the URL string.
  Future<String?> getInvoicePdfUrl(String invoiceId) async {
    final response = await _dio.get(ApiEndpoints.subscriptionInvoicePdf(invoiceId));

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>?;
    return data?['pdf_url'] as String?;
  }

  // ─── Sync Entitlements ─────────────────────────────────────────

  /// Fetch full entitlement snapshot for offline caching.
  Future<Map<String, dynamic>> syncEntitlements() async {
    final response = await _dio.get(ApiEndpoints.subscriptionSyncEntitlements);

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return (apiResponse.data as Map<String, dynamic>?) ?? {};
  }

  // ─── Store Add-Ons ─────────────────────────────────────────────

  /// List active add-ons for the current store.
  Future<List<Map<String, dynamic>>> getStoreAddOns() async {
    final response = await _dio.get(ApiEndpoints.subscriptionStoreAddOns);

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    if (apiResponse.data == null) return [];
    final list = apiResponse.dataList;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  /// Activate an add-on for the current store.
  Future<Map<String, dynamic>> activateAddOn(String addOnId) async {
    final response = await _dio.post(ApiEndpoints.subscriptionActivateAddOn(addOnId));

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  /// Remove (deactivate) an add-on from the current store.
  Future<void> removeAddOn(String addOnId) async {
    await _dio.delete(ApiEndpoints.subscriptionRemoveAddOn(addOnId));
  }

  // ─── Plan Add-Ons (public) ─────────────────────────────────────

  /// List available plan add-ons (public, no auth needed).
  Future<List<Map<String, dynamic>>> listAddOns({bool activeOnly = true}) async {
    final response = await _dio.get(ApiEndpoints.subscriptionAddOns, queryParameters: {'active_only': activeOnly ? 1 : 0});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    if (apiResponse.data == null) return [];
    final list = apiResponse.dataList;
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }
}
