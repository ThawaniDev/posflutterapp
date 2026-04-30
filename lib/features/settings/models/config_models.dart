/// Security policy defaults returned by /config/security-policies
class SecurityPolicy {
  const SecurityPolicy({
    required this.sessionTimeoutMinutes,
    required this.requireReauthOnWake,
    required this.pinMinLength,
    required this.pinComplexity,
    required this.requireUniquePins,
    required this.pinExpiryDays,
    required this.biometricEnabledDefault,
    required this.biometricCanReplacePin,
    required this.maxFailedLoginAttempts,
    required this.lockoutDurationMinutes,
    required this.failedAttemptAlertToOwner,
    required this.deviceRegistrationPolicy,
    required this.maxDevicesPerStore,
  });

  factory SecurityPolicy.fromJson(Map<String, dynamic> json) {
    return SecurityPolicy(
      sessionTimeoutMinutes: (json['session_timeout_minutes'] as num?)?.toInt() ?? 30,
      requireReauthOnWake: json['require_reauth_on_wake'] as bool? ?? true,
      pinMinLength: (json['pin_min_length'] as num?)?.toInt() ?? 4,
      pinComplexity: json['pin_complexity'] as String? ?? 'numeric_only',
      requireUniquePins: json['require_unique_pins'] as bool? ?? true,
      pinExpiryDays: (json['pin_expiry_days'] as num?)?.toInt() ?? 0,
      biometricEnabledDefault: json['biometric_enabled_default'] as bool? ?? true,
      biometricCanReplacePin: json['biometric_can_replace_pin'] as bool? ?? false,
      maxFailedLoginAttempts: (json['max_failed_login_attempts'] as num?)?.toInt() ?? 5,
      lockoutDurationMinutes: (json['lockout_duration_minutes'] as num?)?.toInt() ?? 15,
      failedAttemptAlertToOwner: json['failed_attempt_alert_to_owner'] as bool? ?? true,
      deviceRegistrationPolicy: json['device_registration_policy'] as String? ?? 'open',
      maxDevicesPerStore: (json['max_devices_per_store'] as num?)?.toInt() ?? 10,
    );
  }

  final int sessionTimeoutMinutes;
  final bool requireReauthOnWake;
  final int pinMinLength;
  final String pinComplexity;
  final bool requireUniquePins;
  final int pinExpiryDays;
  final bool biometricEnabledDefault;
  final bool biometricCanReplacePin;
  final int maxFailedLoginAttempts;
  final int lockoutDurationMinutes;
  final bool failedAttemptAlertToOwner;
  final String deviceRegistrationPolicy;
  final int maxDevicesPerStore;

  /// True if PIN never expires.
  bool get pinsNeverExpire => pinExpiryDays == 0;

  Map<String, dynamic> toJson() => {
    'session_timeout_minutes': sessionTimeoutMinutes,
    'require_reauth_on_wake': requireReauthOnWake,
    'pin_min_length': pinMinLength,
    'pin_complexity': pinComplexity,
    'require_unique_pins': requireUniquePins,
    'pin_expiry_days': pinExpiryDays,
    'biometric_enabled_default': biometricEnabledDefault,
    'biometric_can_replace_pin': biometricCanReplacePin,
    'max_failed_login_attempts': maxFailedLoginAttempts,
    'lockout_duration_minutes': lockoutDurationMinutes,
    'failed_attempt_alert_to_owner': failedAttemptAlertToOwner,
    'device_registration_policy': deviceRegistrationPolicy,
    'max_devices_per_store': maxDevicesPerStore,
  };
}

/// Response from /config/maintenance
class MaintenanceStatus {
  const MaintenanceStatus({required this.isActive, this.message, this.messageAr, this.startsAt, this.endsAt, this.allowedIps});

  factory MaintenanceStatus.fromJson(Map<String, dynamic> json) {
    return MaintenanceStatus(
      isActive: json['is_active'] as bool? ?? false,
      message: json['message'] as String?,
      messageAr: json['message_ar'] as String?,
      startsAt: json['starts_at'] != null ? DateTime.parse(json['starts_at'] as String) : null,
      endsAt: json['ends_at'] != null ? DateTime.parse(json['ends_at'] as String) : null,
      allowedIps: (json['allowed_ips'] as List<dynamic>?)?.cast<String>(),
    );
  }

  final bool isActive;
  final String? message;
  final String? messageAr;
  final DateTime? startsAt;
  final DateTime? endsAt;
  final List<String>? allowedIps;

  Map<String, dynamic> toJson() => {
    'is_active': isActive,
    if (message != null) 'message': message,
    if (messageAr != null) 'message_ar': messageAr,
    if (startsAt != null) 'starts_at': startsAt!.toIso8601String(),
    if (endsAt != null) 'ends_at': endsAt!.toIso8601String(),
    if (allowedIps != null) 'allowed_ips': allowedIps,
  };
}

/// Response from /config/tax
class TaxConfig {
  const TaxConfig({
    required this.vatEnabled,
    required this.vatRate,
    this.vatNumber,
    this.inclusivePricing,
    this.exemptCategories,
  });

  factory TaxConfig.fromJson(Map<String, dynamic> json) {
    return TaxConfig(
      vatEnabled: json['vat_enabled'] as bool? ?? true,
      vatRate: (json['vat_rate'] as num?)?.toDouble() ?? 15.0,
      vatNumber: json['vat_number'] as String?,
      inclusivePricing: json['inclusive_pricing'] as bool? ?? false,
      exemptCategories: (json['exempt_categories'] as List<dynamic>?)?.cast<String>(),
    );
  }

  final bool vatEnabled;
  final double vatRate;
  final String? vatNumber;
  final bool? inclusivePricing;
  final List<String>? exemptCategories;

  Map<String, dynamic> toJson() => {
    'vat_enabled': vatEnabled,
    'vat_rate': vatRate,
    if (vatNumber != null) 'vat_number': vatNumber,
    if (inclusivePricing != null) 'inclusive_pricing': inclusivePricing,
    if (exemptCategories != null) 'exempt_categories': exemptCategories,
  };
}

/// Response from /config/translations/version
class TranslationVersionInfo {
  const TranslationVersionInfo({required this.version, required this.hash, this.publishedAt, this.locales});

  factory TranslationVersionInfo.fromJson(Map<String, dynamic> json) {
    return TranslationVersionInfo(
      version: (json['version'] as num?)?.toInt() ?? 0,
      hash: json['hash'] as String? ?? '',
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at'] as String) : null,
      locales: (json['locales'] as List<dynamic>?)?.cast<String>(),
    );
  }

  final int version;
  final String hash;
  final DateTime? publishedAt;
  final List<String>? locales;

  Map<String, dynamic> toJson() => {
    'version': version,
    'hash': hash,
    if (publishedAt != null) 'published_at': publishedAt!.toIso8601String(),
    if (locales != null) 'locales': locales,
  };
}
