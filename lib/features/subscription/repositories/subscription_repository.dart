import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/errors/app_exception.dart';
import 'package:thawani_pos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:thawani_pos/features/subscription/models/invoice.dart';
import 'package:thawani_pos/features/subscription/models/store_subscription.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(subscriptionApiServiceProvider));
});

/// Repository that orchestrates subscription API calls with error mapping.
class SubscriptionRepository {
  final SubscriptionApiService _apiService;

  SubscriptionRepository(this._apiService);

  // ─── Plans ─────────────────────────────────────────────────────

  Future<List<SubscriptionPlan>> listPlans({bool activeOnly = true}) async {
    try {
      return await _apiService.listPlans(activeOnly: activeOnly);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<SubscriptionPlan> getPlan(String planId) async {
    try {
      return await _apiService.getPlan(planId);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<SubscriptionPlan> getPlanBySlug(String slug) async {
    try {
      return await _apiService.getPlanBySlug(slug);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> comparePlans(List<String> planIds) async {
    try {
      return await _apiService.comparePlans(planIds);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Subscription Lifecycle ────────────────────────────────────

  Future<StoreSubscription?> getCurrentSubscription() async {
    try {
      return await _apiService.getCurrentSubscription();
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<StoreSubscription> subscribe({required String planId, String billingCycle = 'monthly', String? paymentMethod}) async {
    try {
      return await _apiService.subscribe(planId: planId, billingCycle: billingCycle, paymentMethod: paymentMethod);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<StoreSubscription> changePlan({required String planId, String billingCycle = 'monthly'}) async {
    try {
      return await _apiService.changePlan(planId: planId, billingCycle: billingCycle);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<StoreSubscription> cancelSubscription({String? reason}) async {
    try {
      return await _apiService.cancelSubscription(reason: reason);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<StoreSubscription> resumeSubscription() async {
    try {
      return await _apiService.resumeSubscription();
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Usage & Enforcement ───────────────────────────────────────

  Future<List<Map<String, dynamic>>> getUsageSummary() async {
    try {
      return await _apiService.getUsageSummary();
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<bool> checkFeature(String featureKey) async {
    try {
      return await _apiService.checkFeature(featureKey);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<Map<String, dynamic>> checkLimit(String limitKey) async {
    try {
      return await _apiService.checkLimit(limitKey);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Invoices ──────────────────────────────────────────────────

  Future<List<Invoice>> getInvoices({int page = 1, int perPage = 20}) async {
    try {
      return await _apiService.getInvoices(page: page, perPage: perPage);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<Invoice> getInvoice(String invoiceId) async {
    try {
      return await _apiService.getInvoice(invoiceId);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Invoice PDF ───────────────────────────────────────────────

  Future<String?> getInvoicePdfUrl(String invoiceId) async {
    try {
      return await _apiService.getInvoicePdfUrl(invoiceId);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Sync Entitlements ─────────────────────────────────────────

  Future<Map<String, dynamic>> syncEntitlements() async {
    try {
      return await _apiService.syncEntitlements();
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Store Add-Ons ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getStoreAddOns() async {
    try {
      return await _apiService.getStoreAddOns();
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Plan Add-Ons ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> listAddOns({bool activeOnly = true}) async {
    try {
      return await _apiService.listAddOns(activeOnly: activeOnly);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Error Mapping ─────────────────────────────────────────────

  AppException _mapError(dynamic error) {
    if (error is AppException) return error;

    if (error is DioException) {
      final data = error.response?.data;
      final statusCode = error.response?.statusCode;
      String message = 'An unexpected error occurred.';

      if (data is Map<String, dynamic>) {
        message = data['message'] as String? ?? message;
      }

      return SubscriptionException(message: message, statusCode: statusCode, originalError: error);
    }

    return SubscriptionException(message: error.toString(), originalError: error);
  }
}

/// Custom exception for subscription-related errors.
class SubscriptionException extends AppException {
  final int? statusCode;

  const SubscriptionException({required super.message, this.statusCode, super.originalError});

  @override
  String toString() => 'SubscriptionException: $message (status: $statusCode)';
}
