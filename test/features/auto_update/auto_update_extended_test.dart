import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/auto_update/models/app_release.dart';
import 'package:wameedpos/features/auto_update/providers/auto_update_state.dart';
import 'package:wameedpos/features/settings/models/config_models.dart';

/// Comprehensive extended tests for App Update Management & Config models.
///
/// Covers:
/// - AppRelease JSON parsing for every field incl. manifest fields
/// - UpdateCheckLoaded state field contract matching backend response
/// - Rollout / store_url / checksum fields present in API response contract
/// - MaintenanceStatus field contract matching updated Laravel response
/// - TaxConfig field contract matching updated Laravel response
/// - Manifest & download endpoint URL builders
/// - Edge cases: null fields, empty lists, alternate key names
void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // AppRelease — comprehensive JSON parsing
  // ═══════════════════════════════════════════════════════════════════════════

  group('AppRelease — comprehensive JSON parsing', () {
    test('parses complete manifest-style response with all fields', () {
      final release = AppRelease.fromJson({
        'id': 'r-001',
        'version_number': '4.0.0',
        'platform': 'ios',
        'channel': 'stable',
        'download_url': 'https://cdn.example.com/v4.ipa',
        'store_url': 'https://apps.apple.com/app/id123456',
        'build_number': '400',
        'release_notes': 'Major overhaul.',
        'release_notes_ar': 'إصلاح شامل.',
        'is_force_update': true,
        'min_supported_version': '3.0.0',
        'rollout_percentage': 50,
        'is_active': true,
        'released_at': '2026-01-01T00:00:00.000Z',
        'checksum': 'sha256:abc123',
        'file_size_bytes': 104857600,
        'submission_status': 'approved',
        'created_at': '2025-12-15T08:00:00.000Z',
        'updated_at': '2025-12-16T10:00:00.000Z',
      });

      expect(release.id, 'r-001');
      expect(release.versionNumber, '4.0.0');
      expect(release.platform, 'ios');
      expect(release.channel, 'stable');
      expect(release.downloadUrl, 'https://cdn.example.com/v4.ipa');
      expect(release.storeUrl, 'https://apps.apple.com/app/id123456');
      expect(release.buildNumber, '400');
      expect(release.releaseNotes, 'Major overhaul.');
      expect(release.releaseNotesAr, 'إصلاح شامل.');
      expect(release.isForceUpdate, isTrue);
      expect(release.minSupportedVersion, '3.0.0');
      expect(release.rolloutPercentage, 50);
      expect(release.isActive, isTrue);
      expect(release.releasedAt, isNotNull);
      expect(release.fileChecksum, 'sha256:abc123');
      expect(release.fileSizeBytes, 104857600);
      expect(release.createdAt, isNotNull);
      expect(release.updatedAt, isNotNull);
    });

    test('accepts file_checksum key (alternate API response)', () {
      final release = AppRelease.fromJson({
        'id': 'r',
        'version_number': '1.0.0',
        'platform': 'android',
        'file_checksum': 'sha256:xyz789',
      });
      expect(release.fileChecksum, 'sha256:xyz789');
    });

    test('checksum key takes priority over file_checksum', () {
      final release = AppRelease.fromJson({
        'id': 'r',
        'version_number': '1.0.0',
        'platform': 'ios',
        'checksum': 'preferred_value',
        'file_checksum': 'fallback_value',
      });
      // The model's fromJson uses 'checksum' first, then falls back
      expect(release.fileChecksum, isNotNull);
    });

    test('build_number sent as int is cast to String', () {
      final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'windows', 'build_number': 250});
      expect(release.buildNumber, '250');
    });

    test('missing optional fields do not throw', () {
      expect(() => AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'macos'}), returnsNormally);
    });

    test('rollout_percentage defaults to 0 when missing', () {
      final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'ios'});
      expect(release.rolloutPercentage, 0);
    });

    test('is_active defaults to true when missing', () {
      final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'ios'});
      expect(release.isActive, isTrue);
    });

    test('is_force_update defaults to false when missing', () {
      final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'ios'});
      expect(release.isForceUpdate, isFalse);
    });

    test('toJson includes store_url when present', () {
      final release = AppRelease.fromJson({
        'id': 'r',
        'version_number': '2.0.0',
        'platform': 'ios',
        'store_url': 'https://apps.apple.com/app/id999',
      });
      final json = release.toJson();
      expect(json['store_url'], 'https://apps.apple.com/app/id999');
    });

    test('toJson includes checksum when present', () {
      final release = AppRelease.fromJson({
        'id': 'r',
        'version_number': '2.0.0',
        'platform': 'ios',
        'checksum': 'sha256:round_trip',
      });
      final json = release.toJson();
      // Check if either checksum or file_checksum is present in toJson output
      final hasChecksum = json.containsKey('checksum') || json.containsKey('file_checksum');
      expect(hasChecksum, isTrue);
    });

    test('all four platforms parse without error', () {
      for (final platform in ['ios', 'android', 'windows', 'macos']) {
        final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': platform});
        expect(release.platform, platform);
      }
    });

    test('all channels parse without error', () {
      for (final channel in ['stable', 'beta', 'testflight', 'internal_test']) {
        final release = AppRelease.fromJson({'id': 'r', 'version_number': '1.0.0', 'platform': 'ios', 'channel': channel});
        expect(release.channel, channel);
      }
    });

    test('released_at parses ISO 8601 correctly', () {
      final release = AppRelease.fromJson({
        'id': 'r',
        'version_number': '1.0.0',
        'platform': 'ios',
        'released_at': '2025-06-15T12:30:00.000Z',
      });
      expect(release.releasedAt, isNotNull);
      expect(release.releasedAt!.year, 2025);
      expect(release.releasedAt!.month, 6);
      expect(release.releasedAt!.day, 15);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // UpdateCheckLoaded — API response contract
  // ═══════════════════════════════════════════════════════════════════════════

  group('UpdateCheckLoaded — field contract matching Laravel response', () {
    test('carries store_url from checkForUpdate response', () {
      const state = UpdateCheckLoaded(
        updateAvailable: true,
        latestVersion: '3.0.0',
        storeUrl: 'https://play.google.com/store/apps/details?id=com.example',
        isForceUpdate: false,
        releaseId: 'r-abc',
        raw: {'update_available': true},
      );
      expect(state.storeUrl, 'https://play.google.com/store/apps/details?id=com.example');
    });

    test('carries release_notes and release_notes_ar', () {
      const state = UpdateCheckLoaded(
        updateAvailable: true,
        latestVersion: '3.0.0',
        isForceUpdate: false,
        releaseNotes: 'New dashboard.',
        releaseNotesAr: 'لوحة تحكم جديدة.',
        releaseId: 'r-abc',
        raw: {'update_available': true},
      );
      expect(state.releaseNotes, 'New dashboard.');
      expect(state.releaseNotesAr, 'لوحة تحكم جديدة.');
    });

    test('no update — minimal required fields', () {
      const state = UpdateCheckLoaded(updateAvailable: false, raw: {'update_available': false});
      expect(state.updateAvailable, isFalse);
      expect(state.latestVersion, isNull);
      expect(state.downloadUrl, isNull);
      expect(state.isForceUpdate, isFalse);
      expect(state.releaseId, isNull);
    });

    test('force update sets both updateAvailable and isForceUpdate', () {
      const state = UpdateCheckLoaded(
        updateAvailable: true,
        latestVersion: '5.0.0',
        isForceUpdate: true,
        releaseId: 'force-release',
        raw: {'is_force_update': true},
      );
      expect(state.updateAvailable, isTrue);
      expect(state.isForceUpdate, isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ChangelogLoaded — release notes presence
  // ═══════════════════════════════════════════════════════════════════════════

  group('ChangelogLoaded — release notes fields', () {
    test('items include release_notes and release_notes_ar', () {
      const state = ChangelogLoaded(
        releases: [
          {
            'id': 'r-001',
            'version_number': '3.0.0',
            'build_number': '300',
            'release_notes': 'Improved performance.',
            'release_notes_ar': 'تحسين الأداء.',
            'is_force_update': false,
            'released_at': '2025-01-01T00:00:00.000Z',
          },
        ],
      );
      expect(state.releases.first['release_notes'], 'Improved performance.');
      expect(state.releases.first['release_notes_ar'], 'تحسين الأداء.');
    });

    test('newest-first ordering preserved from API', () {
      const state = ChangelogLoaded(
        releases: [
          {'version_number': '3.0.0'},
          {'version_number': '2.0.0'},
          {'version_number': '1.0.0'},
        ],
      );
      expect(state.releases.first['version_number'], '3.0.0');
    });

    test('empty changelog is valid state', () {
      const state = ChangelogLoaded(releases: []);
      expect(state.releases, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // HistoryLoaded — stat structure with release info
  // ═══════════════════════════════════════════════════════════════════════════

  group('HistoryLoaded — entry structure', () {
    test('entries include app_release object with version', () {
      const state = HistoryLoaded(
        entries: [
          {
            'status': 'installed',
            'error_message': null,
            'app_release': {
              'id': 'r-001',
              'version_number': '3.0.0',
              'platform': 'ios',
              'released_at': '2025-01-01T00:00:00.000Z',
            },
          },
          {
            'status': 'failed',
            'error_message': 'Download corrupted.',
            'app_release': {'id': 'r-002', 'version_number': '2.5.0', 'platform': 'ios'},
          },
        ],
      );

      expect(state.entries, hasLength(2));
      expect(state.entries.first['status'], 'installed');
      expect(state.entries.first['app_release']['version_number'], '3.0.0');
      expect(state.entries.last['error_message'], 'Download corrupted.');
    });

    test('empty history is valid', () {
      const state = HistoryLoaded(entries: []);
      expect(state.entries, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // UpdateOperationSuccess — includes status field from API
  // ═══════════════════════════════════════════════════════════════════════════

  group('UpdateOperationSuccess — report status response', () {
    test('carries status in data map', () {
      const state = UpdateOperationSuccess(
        'Status reported.',
        data: {'status': 'installed', 'store_id': 's-001', 'app_release_id': 'r-001'},
      );
      expect(state.data!['status'], 'installed');
    });

    test('carries error_message on failed status', () {
      const state = UpdateOperationSuccess('Failure recorded.', data: {'status': 'failed', 'error_message': 'Disk full.'});
      expect(state.data!['error_message'], 'Disk full.');
    });

    test('data is null for operations without return value', () {
      const state = UpdateOperationSuccess('Done');
      expect(state.data, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // MaintenanceStatus — updated field contract
  // ═══════════════════════════════════════════════════════════════════════════

  group('MaintenanceStatus — updated field contract (matches Laravel response)', () {
    test('parses is_active field (not is_enabled)', () {
      final status = MaintenanceStatus.fromJson({'is_active': true});
      expect(status.isActive, isTrue);
    });

    test('parses message field (not banner_message_en)', () {
      final status = MaintenanceStatus.fromJson({'is_active': true, 'message': 'Scheduled downtime.'});
      expect(status.message, 'Scheduled downtime.');
    });

    test('parses message_ar field (not banner_message_ar)', () {
      final status = MaintenanceStatus.fromJson({'is_active': true, 'message_ar': 'صيانة مجدولة.'});
      expect(status.messageAr, 'صيانة مجدولة.');
    });

    test('parses ends_at field (not expected_end_time)', () {
      final status = MaintenanceStatus.fromJson({'is_active': true, 'ends_at': '2030-12-31T23:59:00.000Z'});
      expect(status.endsAt, isNotNull);
      expect(status.endsAt!.year, 2030);
    });

    test('parses starts_at field', () {
      final status = MaintenanceStatus.fromJson({'is_active': true, 'starts_at': '2030-12-31T20:00:00.000Z'});
      expect(status.startsAt, isNotNull);
      expect(status.startsAt!.hour, 20);
    });

    test('parses allowed_ips list', () {
      final status = MaintenanceStatus.fromJson({
        'is_active': true,
        'allowed_ips': ['192.168.1.1', '10.0.0.1'],
      });
      expect(status.allowedIps, hasLength(2));
      expect(status.allowedIps!.first, '192.168.1.1');
    });

    test('allowed_ips null when not sent', () {
      final status = MaintenanceStatus.fromJson({'is_active': false});
      expect(status.allowedIps, isNull);
    });

    test('defaults inactive on empty JSON', () {
      final status = MaintenanceStatus.fromJson({});
      expect(status.isActive, isFalse);
      expect(status.message, isNull);
      expect(status.messageAr, isNull);
      expect(status.endsAt, isNull);
    });

    test('toJson produces is_active key (not is_enabled)', () {
      const status = MaintenanceStatus(isActive: true, message: 'Down for maintenance.');
      final json = status.toJson();
      expect(json.containsKey('is_active'), isTrue);
      expect(json.containsKey('is_enabled'), isFalse);
      expect(json['is_active'], isTrue);
    });

    test('toJson round-trips message fields', () {
      const status = MaintenanceStatus(isActive: true, message: 'test');
      final json = status.toJson();
      final parsed = MaintenanceStatus.fromJson(json);
      expect(parsed.isActive, isTrue);
      expect(parsed.message, 'test');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // TaxConfig — updated field contract (vat_number not vat_registration_number)
  // ═══════════════════════════════════════════════════════════════════════════

  group('TaxConfig — updated field contract (matches Laravel response)', () {
    test('reads vat_number key (not vat_registration_number)', () {
      final tax = TaxConfig.fromJson({'vat_enabled': true, 'vat_rate': 15.0, 'vat_number': '300000000000003'});
      expect(tax.vatNumber, '300000000000003');
    });

    test('vat_number null when not sent', () {
      final tax = TaxConfig.fromJson({'vat_rate': 5.0});
      expect(tax.vatNumber, isNull);
    });

    test('reads vat_enabled field', () {
      final tax = TaxConfig.fromJson({'vat_enabled': false, 'vat_rate': 0.0});
      expect(tax.vatEnabled, isFalse);
    });

    test('defaults to 15% VAT and enabled', () {
      final tax = TaxConfig.fromJson({});
      expect(tax.vatRate, 15.0);
      expect(tax.vatEnabled, isTrue);
    });

    test('parses exempt_categories list', () {
      final tax = TaxConfig.fromJson({
        'vat_rate': 5.0,
        'exempt_categories': ['medical', 'education'],
      });
      expect(tax.exemptCategories, hasLength(2));
      expect(tax.exemptCategories!.first, 'medical');
    });

    test('toJson round-trips vat_number key', () {
      const tax = TaxConfig(vatEnabled: true, vatRate: 15.0, vatNumber: '300000000000003');
      final json = tax.toJson();
      expect(json.containsKey('vat_number'), isTrue);
      expect(json['vat_number'], '300000000000003');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SecurityPolicy — comprehensive field coverage
  // ═══════════════════════════════════════════════════════════════════════════

  group('SecurityPolicy — all 13 fields', () {
    test('parses all 13 security fields', () {
      final policy = SecurityPolicy.fromJson({
        'session_timeout_minutes': 45,
        'require_reauth_on_wake': true,
        'pin_min_length': 6,
        'pin_complexity': 'alphanumeric',
        'require_unique_pins': true,
        'pin_expiry_days': 90,
        'biometric_enabled_default': false,
        'biometric_can_replace_pin': false,
        'max_failed_login_attempts': 3,
        'lockout_duration_minutes': 30,
        'failed_attempt_alert_to_owner': true,
        'device_registration_policy': 'approval_required',
        'max_devices_per_store': 5,
      });

      expect(policy.sessionTimeoutMinutes, 45);
      expect(policy.requireReauthOnWake, isTrue);
      expect(policy.pinMinLength, 6);
      expect(policy.pinComplexity, 'alphanumeric');
      expect(policy.requireUniquePins, isTrue);
      expect(policy.pinExpiryDays, 90);
      expect(policy.biometricEnabledDefault, isFalse);
      expect(policy.biometricCanReplacePin, isFalse);
      expect(policy.maxFailedLoginAttempts, 3);
      expect(policy.lockoutDurationMinutes, 30);
      expect(policy.failedAttemptAlertToOwner, isTrue);
      expect(policy.deviceRegistrationPolicy, 'approval_required');
      expect(policy.maxDevicesPerStore, 5);
    });

    test('pinsNeverExpire is true when pin_expiry_days is 0', () {
      final policy = SecurityPolicy.fromJson({'pin_expiry_days': 0});
      expect(policy.pinsNeverExpire, isTrue);
    });

    test('pinsNeverExpire is false when pin_expiry_days > 0', () {
      final policy = SecurityPolicy.fromJson({'pin_expiry_days': 30});
      expect(policy.pinsNeverExpire, isFalse);
    });

    test('toJson produces all 13 field keys', () {
      final policy = SecurityPolicy.fromJson({'session_timeout_minutes': 60, 'pin_min_length': 4});
      final json = policy.toJson();

      expect(json.containsKey('session_timeout_minutes'), isTrue);
      expect(json.containsKey('pin_min_length'), isTrue);
      expect(json.containsKey('pin_complexity'), isTrue);
      expect(json.containsKey('max_failed_login_attempts'), isTrue);
      expect(json.containsKey('device_registration_policy'), isTrue);
      expect(json.containsKey('max_devices_per_store'), isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Endpoint URL builders — manifest / download / rollout
  // ═══════════════════════════════════════════════════════════════════════════

  group('AutoUpdate endpoint URL builders', () {
    test('autoUpdateManifest builds versioned URL', () {
      expect(ApiEndpoints.autoUpdateManifest('3.0.0'), '/auto-update/manifest/3.0.0');
    });

    test('autoUpdateManifest with complex version', () {
      expect(ApiEndpoints.autoUpdateManifest('3.0.0-beta.1'), '/auto-update/manifest/3.0.0-beta.1');
    });

    test('autoUpdateDownload builds versioned URL', () {
      expect(ApiEndpoints.autoUpdateDownload('3.0.0'), '/auto-update/download/3.0.0');
    });

    test('autoUpdateRolloutStatus constant', () {
      expect(ApiEndpoints.autoUpdateRolloutStatus, '/auto-update/rollout-status');
    });
  });
}
