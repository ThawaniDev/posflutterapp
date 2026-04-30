import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/settings/data/remote/config_api_service.dart';
import 'package:wameedpos/features/settings/models/certified_hardware.dart';
import 'package:wameedpos/features/settings/models/config_models.dart';
import 'package:wameedpos/features/settings/models/feature_flag.dart';
import 'package:wameedpos/features/settings/models/payment_method.dart';
import 'package:wameedpos/features/settings/models/supported_locale.dart';
import 'package:wameedpos/features/settings/providers/config_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Feature Flags
// ─────────────────────────────────────────────────────────────────────────────

final configFeatureFlagsProvider = StateNotifierProvider<ConfigFeatureFlagsNotifier, ConfigFeatureFlagsState>(
  (ref) => ConfigFeatureFlagsNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigFeatureFlagsNotifier extends StateNotifier<ConfigFeatureFlagsState> {
  ConfigFeatureFlagsNotifier(this._api) : super(const ConfigFeatureFlagsInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigFeatureFlagsLoading();
    try {
      final res = await _api.getFeatureFlags();
      final data = res.data as Map<String, dynamic>;
      final list = (data['flags'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(FeatureFlag.fromJson)
          .toList();
      state = ConfigFeatureFlagsLoaded(list);
    } catch (e) {
      state = ConfigFeatureFlagsError(e.toString());
    }
  }

  /// Quick check if [key] is enabled. Returns false when not loaded.
  bool isEnabled(String key) {
    final s = state;
    return s is ConfigFeatureFlagsLoaded && s.isEnabled(key);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Maintenance
// ─────────────────────────────────────────────────────────────────────────────

final configMaintenanceProvider = StateNotifierProvider<ConfigMaintenanceNotifier, ConfigMaintenanceState>(
  (ref) => ConfigMaintenanceNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigMaintenanceNotifier extends StateNotifier<ConfigMaintenanceState> {
  ConfigMaintenanceNotifier(this._api) : super(const ConfigMaintenanceInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigMaintenanceLoading();
    try {
      final res = await _api.getMaintenanceStatus();
      final data = res.data as Map<String, dynamic>;
      state = ConfigMaintenanceLoaded(MaintenanceStatus.fromJson(data));
    } catch (e) {
      state = ConfigMaintenanceError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tax
// ─────────────────────────────────────────────────────────────────────────────

final configTaxProvider = StateNotifierProvider<ConfigTaxNotifier, ConfigTaxState>(
  (ref) => ConfigTaxNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigTaxNotifier extends StateNotifier<ConfigTaxState> {
  ConfigTaxNotifier(this._api) : super(const ConfigTaxInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigTaxLoading();
    try {
      final res = await _api.getTaxConfig();
      final data = res.data as Map<String, dynamic>;
      state = ConfigTaxLoaded(TaxConfig.fromJson(data));
    } catch (e) {
      state = ConfigTaxError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Payment Methods
// ─────────────────────────────────────────────────────────────────────────────

final configPaymentMethodsProvider = StateNotifierProvider<ConfigPaymentMethodsNotifier, ConfigPaymentMethodsState>(
  (ref) => ConfigPaymentMethodsNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigPaymentMethodsNotifier extends StateNotifier<ConfigPaymentMethodsState> {
  ConfigPaymentMethodsNotifier(this._api) : super(const ConfigPaymentMethodsInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigPaymentMethodsLoading();
    try {
      final res = await _api.getPaymentMethods();
      final data = res.data as Map<String, dynamic>;
      final list = (data['methods'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(PaymentMethod.fromJson)
          .toList();
      state = ConfigPaymentMethodsLoaded(list);
    } catch (e) {
      state = ConfigPaymentMethodsError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hardware Catalog
// ─────────────────────────────────────────────────────────────────────────────

final configHardwareCatalogProvider = StateNotifierProvider<ConfigHardwareCatalogNotifier, ConfigHardwareCatalogState>(
  (ref) => ConfigHardwareCatalogNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigHardwareCatalogNotifier extends StateNotifier<ConfigHardwareCatalogState> {
  ConfigHardwareCatalogNotifier(this._api) : super(const ConfigHardwareCatalogInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigHardwareCatalogLoading();
    try {
      final res = await _api.getHardwareCatalog();
      final data = res.data as Map<String, dynamic>;
      final list = (data['items'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(CertifiedHardware.fromJson)
          .toList();
      state = ConfigHardwareCatalogLoaded(list);
    } catch (e) {
      state = ConfigHardwareCatalogError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Translation Version
// ─────────────────────────────────────────────────────────────────────────────

final configTranslationVersionProvider = StateNotifierProvider<ConfigTranslationVersionNotifier, ConfigTranslationVersionState>(
  (ref) => ConfigTranslationVersionNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigTranslationVersionNotifier extends StateNotifier<ConfigTranslationVersionState> {
  ConfigTranslationVersionNotifier(this._api) : super(const ConfigTranslationVersionInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigTranslationVersionLoading();
    try {
      final res = await _api.getTranslationVersion();
      final data = res.data as Map<String, dynamic>;
      state = ConfigTranslationVersionLoaded(TranslationVersionInfo.fromJson(data));
    } catch (e) {
      state = ConfigTranslationVersionError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Locales
// ─────────────────────────────────────────────────────────────────────────────

final configLocalesProvider = StateNotifierProvider<ConfigLocalesNotifier, ConfigLocalesState>(
  (ref) => ConfigLocalesNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigLocalesNotifier extends StateNotifier<ConfigLocalesState> {
  ConfigLocalesNotifier(this._api) : super(const ConfigLocalesInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigLocalesLoading();
    try {
      final res = await _api.getLocales();
      final data = res.data as Map<String, dynamic>;
      final list = (data['locales'] as List<dynamic>? ?? data['data'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>()
          .map(SupportedLocale.fromJson)
          .toList();
      state = ConfigLocalesLoaded(list);
    } catch (e) {
      state = ConfigLocalesError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Security Policies
// ─────────────────────────────────────────────────────────────────────────────

final configSecurityPoliciesProvider = StateNotifierProvider<ConfigSecurityPoliciesNotifier, ConfigSecurityPoliciesState>(
  (ref) => ConfigSecurityPoliciesNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigSecurityPoliciesNotifier extends StateNotifier<ConfigSecurityPoliciesState> {
  ConfigSecurityPoliciesNotifier(this._api) : super(const ConfigSecurityPoliciesInitial());
  final ConfigApiService _api;

  Future<void> load() async {
    state = const ConfigSecurityPoliciesLoading();
    try {
      final res = await _api.getSecurityPolicies();
      final data = res.data as Map<String, dynamic>;
      state = ConfigSecurityPoliciesLoaded(SecurityPolicy.fromJson(data));
    } catch (e) {
      state = ConfigSecurityPoliciesError(e.toString());
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Translations (locale-keyed)
// ─────────────────────────────────────────────────────────────────────────────

final configTranslationsProvider = StateNotifierProvider<ConfigTranslationsNotifier, ConfigTranslationsState>(
  (ref) => ConfigTranslationsNotifier(ref.watch(configApiServiceProvider)),
);

class ConfigTranslationsNotifier extends StateNotifier<ConfigTranslationsState> {
  ConfigTranslationsNotifier(this._api) : super(const ConfigTranslationsInitial());
  final ConfigApiService _api;

  Future<void> load(String locale) async {
    state = const ConfigTranslationsLoading();
    try {
      final res = await _api.getTranslations(locale);
      final data = res.data as Map<String, dynamic>;
      // The API returns { "locale": "ar", "strings": { "key": "value", ... } }
      final strings = (data['strings'] as Map<String, dynamic>? ?? (data['data'] as Map<String, dynamic>?) ?? {})
          .cast<String, String>();
      state = ConfigTranslationsLoaded(locale, strings);
    } catch (e) {
      state = ConfigTranslationsError(e.toString());
    }
  }
}
