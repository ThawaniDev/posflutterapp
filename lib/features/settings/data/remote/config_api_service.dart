import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final configApiServiceProvider = Provider<ConfigApiService>((ref) {
  return ConfigApiService(ref.watch(dioClientProvider));
});

/// Handles all provider-facing /config/* endpoints.
///
/// These are consumed by the Flutter POS app using a store Sanctum token.
/// The admin /settings/* routes are handled by admin-panel requests.
class ConfigApiService {
  ConfigApiService(this._dio);
  final Dio _dio;

  // ─── Feature Flags ──────────────────────────────────────────────────────────

  /// GET /config/feature-flags
  /// Returns which flags are enabled for the authenticated store/plan,
  /// considering rollout bucket assignment.
  Future<Response> getFeatureFlags() {
    return _dio.get(ApiEndpoints.configFeatureFlags);
  }

  // ─── Maintenance ────────────────────────────────────────────────────────────

  /// GET /config/maintenance
  /// Public — no auth required. Returns current maintenance window status.
  Future<Response> getMaintenanceStatus() {
    return _dio.get(ApiEndpoints.configMaintenance);
  }

  // ─── Tax ────────────────────────────────────────────────────────────────────

  /// GET /config/tax
  /// Returns VAT / tax configuration active for this store's country/plan.
  Future<Response> getTaxConfig() {
    return _dio.get(ApiEndpoints.configTax);
  }

  // ─── Age Restrictions ───────────────────────────────────────────────────────

  /// GET /config/age-restrictions
  /// Returns product categories that require age verification and their rules.
  Future<Response> getAgeRestrictions() {
    return _dio.get(ApiEndpoints.configAgeRestrictions);
  }

  // ─── Payment Methods ────────────────────────────────────────────────────────

  /// GET /config/payment-methods
  /// Returns the list of active payment methods with descriptions, fees,
  /// min/max amounts, and supported currencies.
  Future<Response> getPaymentMethods() {
    return _dio.get(ApiEndpoints.configPaymentMethods);
  }

  // ─── Hardware Catalog ───────────────────────────────────────────────────────

  /// GET /config/hardware-catalog
  /// Returns all certified hardware items (printers, scanners, drawers, etc.)
  /// that the platform officially supports.
  Future<Response> getHardwareCatalog() {
    return _dio.get(ApiEndpoints.configHardwareCatalog);
  }

  // ─── Translations ───────────────────────────────────────────────────────────

  /// GET /config/translations/version
  /// Returns the latest published translation snapshot version + hash.
  /// Used for client-side cache invalidation.
  Future<Response> getTranslationVersion() {
    return _dio.get(ApiEndpoints.configTranslationVersion);
  }

  /// GET /config/translations/{locale}
  /// Returns all published translation strings for [locale].
  /// [locale] example: 'ar', 'en', 'ur', 'bn'
  Future<Response> getTranslations(String locale) {
    return _dio.get(ApiEndpoints.configTranslations(locale));
  }

  // ─── Locales ────────────────────────────────────────────────────────────────

  /// GET /config/locales
  /// Returns the list of enabled locales and their metadata.
  Future<Response> getLocales() {
    return _dio.get(ApiEndpoints.configLocales);
  }

  // ─── Security Policies ──────────────────────────────────────────────────────

  /// GET /config/security-policies
  /// Returns default security policy configuration:
  /// PIN rules, session timeout, biometric settings, device limits, etc.
  Future<Response> getSecurityPolicies() {
    return _dio.get(ApiEndpoints.configSecurityPolicies);
  }
}
