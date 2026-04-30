import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/auto_update/models/app_release.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/features/settings/enums/translation_category.dart';
import 'package:wameedpos/features/settings/models/config_models.dart';
import 'package:wameedpos/features/settings/providers/config_state.dart';

void main() {
  // ═══════════════ AppRelease model ══════════════════════════════════════════

  group('AppRelease.fromJson', () {
    test('parses all required fields', () {
      final json = {
        'id': 'release-001',
        'version_number': '2.3.1',
        'platform': 'ios',
        'channel': 'stable',
        'download_url': 'https://cdn.example.com/app.ipa',
        'store_url': 'https://apps.apple.com/app',
        'build_number': '231',
        'is_force_update': true,
        'rollout_percentage': 75,
        'is_active': true,
        'released_at': '2025-06-01T10:00:00.000Z',
        'checksum': 'abc123def456',
        'file_size_bytes': 52428800,
        'created_at': '2025-05-28T09:00:00.000Z',
        'updated_at': '2025-06-01T10:00:00.000Z',
      };

      final release = AppRelease.fromJson(json);

      expect(release.id, 'release-001');
      expect(release.versionNumber, '2.3.1');
      expect(release.platform, 'ios');
      expect(release.channel, 'stable');
      expect(release.buildNumber, '231');
      expect(release.isForceUpdate, isTrue);
      expect(release.rolloutPercentage, 75);
      expect(release.fileChecksum, 'abc123def456');
      expect(release.fileSizeBytes, 52428800);
      expect(release.createdAt, isNotNull);
      expect(release.updatedAt, isNotNull);
    });

    test('handles build_number sent as integer from older API versions', () {
      final json = {
        'id': 'r',
        'version_number': '1.0.0',
        'platform': 'android',
        'build_number': 100, // int — should be converted to String
      };
      final release = AppRelease.fromJson(json);
      expect(release.buildNumber, '100');
    });

    test('handles missing optional fields gracefully', () {
      final json = {'id': 'r', 'version_number': '1.0.0', 'platform': 'android'};
      final release = AppRelease.fromJson(json);
      expect(release.fileChecksum, isNull);
      expect(release.fileSizeBytes, isNull);
      expect(release.createdAt, isNull);
      expect(release.updatedAt, isNull);
      expect(release.isForceUpdate, isFalse);
      expect(release.isActive, isTrue);
    });

    test('accepts file_checksum key from older responses', () {
      final json = {'id': 'r', 'version_number': '1.0.0', 'platform': 'ios', 'file_checksum': 'sha256_xyz'};
      final release = AppRelease.fromJson(json);
      expect(release.fileChecksum, 'sha256_xyz');
    });

    test('toJson round-trips core fields', () {
      final json = {
        'id': 'r',
        'version_number': '2.0.0',
        'platform': 'ios',
        'channel': 'beta',
        'is_force_update': false,
        'rollout_percentage': 50,
        'is_active': true,
      };
      final release = AppRelease.fromJson(json);
      final out = release.toJson();
      expect(out['version_number'], '2.0.0');
      expect(out['platform'], 'ios');
      expect(out['rollout_percentage'], 50);
    });
  });

  // ═══════════════ Config API Endpoints ══════════════════════════════════════

  group('Config API endpoints', () {
    test('configFeatureFlags', () {
      expect(ApiEndpoints.configFeatureFlags, '/config/feature-flags');
    });

    test('configMaintenance', () {
      expect(ApiEndpoints.configMaintenance, '/config/maintenance');
    });

    test('configTax', () {
      expect(ApiEndpoints.configTax, '/config/tax');
    });

    test('configAgeRestrictions', () {
      expect(ApiEndpoints.configAgeRestrictions, '/config/age-restrictions');
    });

    test('configPaymentMethods', () {
      expect(ApiEndpoints.configPaymentMethods, '/config/payment-methods');
    });

    test('configHardwareCatalog', () {
      expect(ApiEndpoints.configHardwareCatalog, '/config/hardware-catalog');
    });

    test('configTranslationVersion', () {
      expect(ApiEndpoints.configTranslationVersion, '/config/translations/version');
    });

    test('configTranslations() builds correct URL', () {
      expect(ApiEndpoints.configTranslations('ar'), '/config/translations/ar');
      expect(ApiEndpoints.configTranslations('en'), '/config/translations/en');
      expect(ApiEndpoints.configTranslations('ur'), '/config/translations/ur');
      expect(ApiEndpoints.configTranslations('bn'), '/config/translations/bn');
    });

    test('configLocales', () {
      expect(ApiEndpoints.configLocales, '/config/locales');
    });

    test('configSecurityPolicies', () {
      expect(ApiEndpoints.configSecurityPolicies, '/config/security-policies');
    });

    // Verify the old admin-facing featureFlags constant is gone / corrected
    test('admin featureFlags is separate from config flags', () {
      expect(ApiEndpoints.adminFeatureFlags, startsWith('/admin/'));
      expect(ApiEndpoints.configFeatureFlags, startsWith('/config/'));
    });
  });

  // ═══════════════ TranslationCategory enum ══════════════════════════════════

  group('TranslationCategory', () {
    test('includes common case', () {
      final cat = TranslationCategory.fromValue('common');
      expect(cat, TranslationCategory.common);
      expect(cat.value, 'common');
    });

    test('includes pos case', () {
      final cat = TranslationCategory.fromValue('pos');
      expect(cat, TranslationCategory.pos);
      expect(cat.value, 'pos');
    });

    test('existing cases still work', () {
      expect(TranslationCategory.fromValue('ui'), TranslationCategory.ui);
      expect(TranslationCategory.fromValue('receipt'), TranslationCategory.receipt);
      expect(TranslationCategory.fromValue('notification'), TranslationCategory.notification);
      expect(TranslationCategory.fromValue('report'), TranslationCategory.report);
    });

    test('tryFromValue returns null for unknown', () {
      expect(TranslationCategory.tryFromValue('unknown_category'), isNull);
      expect(TranslationCategory.tryFromValue(null), isNull);
    });

    test('fromValue throws for unknown', () {
      expect(() => TranslationCategory.fromValue('not_real'), throwsArgumentError);
    });
  });

  // ═══════════════ Config Models ═════════════════════════════════════════════

  group('SecurityPolicy model', () {
    test('parses all fields with sensible defaults', () {
      final policy = SecurityPolicy.fromJson({
        'session_timeout_minutes': 45,
        'require_reauth_on_wake': false,
        'pin_min_length': 6,
        'pin_complexity': 'alphanumeric',
        'require_unique_pins': false,
        'pin_expiry_days': 90,
        'biometric_enabled_default': true,
        'biometric_can_replace_pin': true,
        'max_failed_login_attempts': 3,
        'lockout_duration_minutes': 30,
        'failed_attempt_alert_to_owner': false,
        'device_registration_policy': 'restricted',
        'max_devices_per_store': 5,
      });

      expect(policy.sessionTimeoutMinutes, 45);
      expect(policy.pinComplexity, 'alphanumeric');
      expect(policy.pinExpiryDays, 90);
      expect(policy.pinsNeverExpire, isFalse);
      expect(policy.maxDevicesPerStore, 5);
    });

    test('uses sensible defaults on empty JSON', () {
      final policy = SecurityPolicy.fromJson({});
      expect(policy.sessionTimeoutMinutes, 30);
      expect(policy.pinMinLength, 4);
      expect(policy.maxFailedLoginAttempts, 5);
      expect(policy.pinsNeverExpire, isTrue); // pinExpiryDays = 0
    });

    test('toJson round-trips', () {
      final policy = SecurityPolicy.fromJson({'session_timeout_minutes': 60});
      final json = policy.toJson();
      expect(json['session_timeout_minutes'], 60);
    });
  });

  group('MaintenanceStatus model', () {
    test('parses active maintenance with message', () {
      final status = MaintenanceStatus.fromJson({
        'is_active': true,
        'message': 'System maintenance in progress',
        'message_ar': 'صيانة النظام جارية',
        'starts_at': '2025-06-01T00:00:00.000Z',
        'ends_at': '2025-06-01T03:00:00.000Z',
      });
      expect(status.isActive, isTrue);
      expect(status.message, contains('maintenance'));
      expect(status.startsAt, isNotNull);
      expect(status.endsAt, isNotNull);
    });

    test('defaults to inactive when missing fields', () {
      final status = MaintenanceStatus.fromJson({});
      expect(status.isActive, isFalse);
      expect(status.message, isNull);
    });
  });

  group('TaxConfig model', () {
    test('parses VAT config', () {
      final tax = TaxConfig.fromJson({
        'vat_enabled': true,
        'vat_rate': 15.0,
        'vat_number': '300000000000003',
        'inclusive_pricing': false,
      });
      expect(tax.vatEnabled, isTrue);
      expect(tax.vatRate, 15.0);
      expect(tax.vatNumber, '300000000000003');
    });

    test('defaults to 15% VAT', () {
      final tax = TaxConfig.fromJson({});
      expect(tax.vatRate, 15.0);
      expect(tax.vatEnabled, isTrue);
    });
  });

  group('TranslationVersionInfo model', () {
    test('parses version info', () {
      final info = TranslationVersionInfo.fromJson({
        'version': 42,
        'hash': 'sha256:abc123',
        'published_at': '2025-05-01T12:00:00.000Z',
        'locales': ['ar', 'en'],
      });
      expect(info.version, 42);
      expect(info.hash, 'sha256:abc123');
      expect(info.publishedAt, isNotNull);
      expect(info.locales, contains('ar'));
    });

    test('defaults to version 0 and empty hash', () {
      final info = TranslationVersionInfo.fromJson({});
      expect(info.version, 0);
      expect(info.hash, '');
    });
  });

  // ═══════════════ Config State sealed classes ════════════════════════════════

  group('ConfigFeatureFlagsState', () {
    test('initial', () {
      expect(const ConfigFeatureFlagsInitial(), isA<ConfigFeatureFlagsState>());
    });

    test('loading', () {
      expect(const ConfigFeatureFlagsLoading(), isA<ConfigFeatureFlagsState>());
    });

    test('loaded with isEnabled helper', () {
      const state = ConfigFeatureFlagsLoaded([]);
      expect(state, isA<ConfigFeatureFlagsState>());
      expect(state.isEnabled('some_flag'), isFalse);
    });

    test('error carries message', () {
      const state = ConfigFeatureFlagsError('403 Forbidden');
      expect(state.message, '403 Forbidden');
    });
  });

  group('ConfigMaintenanceState', () {
    test('loaded with active status', () {
      const status = MaintenanceStatus(isActive: true);
      const state = ConfigMaintenanceLoaded(status);
      expect(state.status.isActive, isTrue);
    });
  });

  group('ConfigTaxState', () {
    test('loaded with tax config', () {
      const config = TaxConfig(vatEnabled: true, vatRate: 15.0);
      const state = ConfigTaxLoaded(config);
      expect(state.taxConfig.vatRate, 15.0);
    });
  });

  group('ConfigSecurityPoliciesState', () {
    test('loaded with security policy', () {
      final policy = SecurityPolicy.fromJson({'session_timeout_minutes': 60});
      final state = ConfigSecurityPoliciesLoaded(policy);
      expect(state.policy.sessionTimeoutMinutes, 60);
    });

    test('error', () {
      const state = ConfigSecurityPoliciesError('Server Error');
      expect(state.message, 'Server Error');
    });
  });

  group('ConfigTranslationsState', () {
    test('loaded with strings', () {
      const state = ConfigTranslationsLoaded('ar', {'key': 'قيمة'});
      expect(state.locale, 'ar');
      expect(state.strings['key'], 'قيمة');
    });

    test('error', () {
      const state = ConfigTranslationsError('Locale not found');
      expect(state.message, 'Locale not found');
    });
  });

  // ═══════════════ UpdateCheckState (extended) ════════════════════════════════

  group('UpdateCheckState — extended', () {
    test('loaded with checksum from release', () {
      // Simulate release with real checksum
      final json = {
        'id': 'r',
        'version_number': '3.0.0',
        'platform': 'android',
        'checksum': 'deadbeef1234',
        'file_size_bytes': 30000000,
      };
      final release = AppRelease.fromJson(json);
      expect(release.fileChecksum, 'deadbeef1234');
      expect(release.fileSizeBytes, 30000000);
    });

    test('rollout percentage defaults to 0 if missing', () {
      final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'ios'});
      expect(release.rolloutPercentage, 0);
    });
  });
}
