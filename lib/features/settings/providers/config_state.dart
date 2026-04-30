import 'package:wameedpos/features/settings/models/certified_hardware.dart';
import 'package:wameedpos/features/settings/models/config_models.dart';
import 'package:wameedpos/features/settings/models/feature_flag.dart';
import 'package:wameedpos/features/settings/models/payment_method.dart';
import 'package:wameedpos/features/settings/models/supported_locale.dart';

// ─── Feature Flags ────────────────────────────────────────────────────────

sealed class ConfigFeatureFlagsState {
  const ConfigFeatureFlagsState();
}

final class ConfigFeatureFlagsInitial extends ConfigFeatureFlagsState {
  const ConfigFeatureFlagsInitial();
}

final class ConfigFeatureFlagsLoading extends ConfigFeatureFlagsState {
  const ConfigFeatureFlagsLoading();
}

final class ConfigFeatureFlagsLoaded extends ConfigFeatureFlagsState {
  const ConfigFeatureFlagsLoaded(this.flags);
  final List<FeatureFlag> flags;

  bool isEnabled(String key) => flags.any((f) => f.flagKey == key && (f.isEnabled ?? false));
}

final class ConfigFeatureFlagsError extends ConfigFeatureFlagsState {
  const ConfigFeatureFlagsError(this.message);
  final String message;
}

// ─── Maintenance ──────────────────────────────────────────────────────────

sealed class ConfigMaintenanceState {
  const ConfigMaintenanceState();
}

final class ConfigMaintenanceInitial extends ConfigMaintenanceState {
  const ConfigMaintenanceInitial();
}

final class ConfigMaintenanceLoading extends ConfigMaintenanceState {
  const ConfigMaintenanceLoading();
}

final class ConfigMaintenanceLoaded extends ConfigMaintenanceState {
  const ConfigMaintenanceLoaded(this.status);
  final MaintenanceStatus status;
}

final class ConfigMaintenanceError extends ConfigMaintenanceState {
  const ConfigMaintenanceError(this.message);
  final String message;
}

// ─── Tax ──────────────────────────────────────────────────────────────────

sealed class ConfigTaxState {
  const ConfigTaxState();
}

final class ConfigTaxInitial extends ConfigTaxState {
  const ConfigTaxInitial();
}

final class ConfigTaxLoading extends ConfigTaxState {
  const ConfigTaxLoading();
}

final class ConfigTaxLoaded extends ConfigTaxState {
  const ConfigTaxLoaded(this.taxConfig);
  final TaxConfig taxConfig;
}

final class ConfigTaxError extends ConfigTaxState {
  const ConfigTaxError(this.message);
  final String message;
}

// ─── Payment Methods ──────────────────────────────────────────────────────

sealed class ConfigPaymentMethodsState {
  const ConfigPaymentMethodsState();
}

final class ConfigPaymentMethodsInitial extends ConfigPaymentMethodsState {
  const ConfigPaymentMethodsInitial();
}

final class ConfigPaymentMethodsLoading extends ConfigPaymentMethodsState {
  const ConfigPaymentMethodsLoading();
}

final class ConfigPaymentMethodsLoaded extends ConfigPaymentMethodsState {
  const ConfigPaymentMethodsLoaded(this.methods);
  final List<PaymentMethod> methods;
}

final class ConfigPaymentMethodsError extends ConfigPaymentMethodsState {
  const ConfigPaymentMethodsError(this.message);
  final String message;
}

// ─── Hardware Catalog ─────────────────────────────────────────────────────

sealed class ConfigHardwareCatalogState {
  const ConfigHardwareCatalogState();
}

final class ConfigHardwareCatalogInitial extends ConfigHardwareCatalogState {
  const ConfigHardwareCatalogInitial();
}

final class ConfigHardwareCatalogLoading extends ConfigHardwareCatalogState {
  const ConfigHardwareCatalogLoading();
}

final class ConfigHardwareCatalogLoaded extends ConfigHardwareCatalogState {
  const ConfigHardwareCatalogLoaded(this.items);
  final List<CertifiedHardware> items;
}

final class ConfigHardwareCatalogError extends ConfigHardwareCatalogState {
  const ConfigHardwareCatalogError(this.message);
  final String message;
}

// ─── Translation Version ──────────────────────────────────────────────────

sealed class ConfigTranslationVersionState {
  const ConfigTranslationVersionState();
}

final class ConfigTranslationVersionInitial extends ConfigTranslationVersionState {
  const ConfigTranslationVersionInitial();
}

final class ConfigTranslationVersionLoading extends ConfigTranslationVersionState {
  const ConfigTranslationVersionLoading();
}

final class ConfigTranslationVersionLoaded extends ConfigTranslationVersionState {
  const ConfigTranslationVersionLoaded(this.info);
  final TranslationVersionInfo info;
}

final class ConfigTranslationVersionError extends ConfigTranslationVersionState {
  const ConfigTranslationVersionError(this.message);
  final String message;
}

// ─── Locales ──────────────────────────────────────────────────────────────

sealed class ConfigLocalesState {
  const ConfigLocalesState();
}

final class ConfigLocalesInitial extends ConfigLocalesState {
  const ConfigLocalesInitial();
}

final class ConfigLocalesLoading extends ConfigLocalesState {
  const ConfigLocalesLoading();
}

final class ConfigLocalesLoaded extends ConfigLocalesState {
  const ConfigLocalesLoaded(this.locales);
  final List<SupportedLocale> locales;
}

final class ConfigLocalesError extends ConfigLocalesState {
  const ConfigLocalesError(this.message);
  final String message;
}

// ─── Security Policies ────────────────────────────────────────────────────

sealed class ConfigSecurityPoliciesState {
  const ConfigSecurityPoliciesState();
}

final class ConfigSecurityPoliciesInitial extends ConfigSecurityPoliciesState {
  const ConfigSecurityPoliciesInitial();
}

final class ConfigSecurityPoliciesLoading extends ConfigSecurityPoliciesState {
  const ConfigSecurityPoliciesLoading();
}

final class ConfigSecurityPoliciesLoaded extends ConfigSecurityPoliciesState {
  const ConfigSecurityPoliciesLoaded(this.policy);
  final SecurityPolicy policy;
}

final class ConfigSecurityPoliciesError extends ConfigSecurityPoliciesState {
  const ConfigSecurityPoliciesError(this.message);
  final String message;
}

// ─── Translations ─────────────────────────────────────────────────────────

sealed class ConfigTranslationsState {
  const ConfigTranslationsState();
}

final class ConfigTranslationsInitial extends ConfigTranslationsState {
  const ConfigTranslationsInitial();
}

final class ConfigTranslationsLoading extends ConfigTranslationsState {
  const ConfigTranslationsLoading();
}

final class ConfigTranslationsLoaded extends ConfigTranslationsState {
  const ConfigTranslationsLoaded(this.locale, this.strings);
  final String locale;
  final Map<String, String> strings;
}

final class ConfigTranslationsError extends ConfigTranslationsState {
  const ConfigTranslationsError(this.message);
  final String message;
}
