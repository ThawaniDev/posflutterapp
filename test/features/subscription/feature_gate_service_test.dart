import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Tests for FeatureGateService logic (unit tests for entitlement caching & checks).
void main() {
  group('FeatureGateService cache logic', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('empty cache returns no entitlements', () {
      final cachedData = prefs.getString('subscription_entitlements');
      expect(cachedData, isNull);
    });

    test('cache stores and retrieves entitlement data', () async {
      final entitlements = {
        'features': {'pos': true, 'inventory': true, 'analytics': false},
        'limits': {
          'products': {'max': 100, 'current': 45},
          'staff': {'max': 5, 'current': 3},
        },
        'subscription_status': 'active',
        'expires_at': '2025-12-31T23:59:59.000Z',
      };

      await prefs.setString('subscription_entitlements', jsonEncode(entitlements));
      await prefs.setString('subscription_last_sync', DateTime.now().toIso8601String());

      final cached = prefs.getString('subscription_entitlements');
      expect(cached, isNotNull);

      final parsed = jsonDecode(cached!) as Map<String, dynamic>;
      expect(parsed['subscription_status'], 'active');
      expect(parsed['features']['pos'], true);
      expect(parsed['features']['analytics'], false);
      expect(parsed['limits']['products']['max'], 100);
      expect(parsed['limits']['products']['current'], 45);
    });

    test('isFeatureEnabled checks features map', () {
      final entitlements = {
        'features': {'pos': true, 'inventory': true, 'analytics': false, 'advanced_reports': false},
      };

      final features = entitlements['features'] as Map<String, dynamic>;

      expect(features['pos'], true);
      expect(features['inventory'], true);
      expect(features['analytics'], false);
      expect(features['advanced_reports'], false);
      expect(features['non_existent'], isNull);
    });

    test('getLimit reads limit values', () {
      final entitlements = {
        'limits': {
          'products': {'max': 100, 'current': 45},
          'staff': {'max': 5, 'current': 3},
          'branches': {'max': -1, 'current': 10}, // unlimited
        },
      };

      final limits = entitlements['limits'] as Map<String, dynamic>;
      final productsLimit = limits['products'] as Map<String, dynamic>;
      final staffLimit = limits['staff'] as Map<String, dynamic>;
      final branchesLimit = limits['branches'] as Map<String, dynamic>;

      expect(productsLimit['max'], 100);
      expect(productsLimit['current'], 45);
      expect(staffLimit['max'], 5);
      expect(staffLimit['current'], 3);
      expect(branchesLimit['max'], -1); // unlimited
    });

    test('getRemainingQuota calculates correctly', () {
      int getRemainingQuota(int max, int current) {
        if (max == -1) return -1; // unlimited
        return max - current;
      }

      expect(getRemainingQuota(100, 45), 55);
      expect(getRemainingQuota(5, 5), 0);
      expect(getRemainingQuota(-1, 999), -1); // unlimited
      expect(getRemainingQuota(10, 0), 10);
    });

    test('canPerformAction checks limit remaining', () {
      bool canPerformAction(int max, int current) {
        if (max == -1) return true; // unlimited
        return current < max;
      }

      expect(canPerformAction(100, 45), true);
      expect(canPerformAction(5, 5), false); // at limit
      expect(canPerformAction(5, 6), false); // over limit
      expect(canPerformAction(-1, 999), true); // unlimited
    });

    test('getUsagePercentage calculates correctly', () {
      double getUsagePercentage(int max, int current) {
        if (max == -1) return 0; // unlimited, no percentage
        if (max == 0) return 100; // edge case
        return (current / max) * 100;
      }

      expect(getUsagePercentage(100, 45), closeTo(45.0, 0.01));
      expect(getUsagePercentage(5, 5), closeTo(100.0, 0.01));
      expect(getUsagePercentage(-1, 999), 0); // unlimited
      expect(getUsagePercentage(10, 0), 0);
    });

    test('isAtWarningLevel checks 80% threshold', () {
      bool isAtWarningLevel(int max, int current) {
        if (max == -1) return false;
        return (current / max) >= 0.8;
      }

      expect(isAtWarningLevel(100, 79), false);
      expect(isAtWarningLevel(100, 80), true);
      expect(isAtWarningLevel(100, 90), true);
      expect(isAtWarningLevel(-1, 999), false);
    });

    test('isAtDangerLevel checks 95% threshold', () {
      bool isAtDangerLevel(int max, int current) {
        if (max == -1) return false;
        return (current / max) >= 0.95;
      }

      expect(isAtDangerLevel(100, 94), false);
      expect(isAtDangerLevel(100, 95), true);
      expect(isAtDangerLevel(100, 100), true);
      expect(isAtDangerLevel(-1, 999), false);
    });

    test('cache validity checks 30-day window', () {
      bool isCacheValid(String? lastSyncStr, {int maxDays = 30}) {
        if (lastSyncStr == null) return false;
        final lastSync = DateTime.tryParse(lastSyncStr);
        if (lastSync == null) return false;
        return DateTime.now().difference(lastSync).inDays <= maxDays;
      }

      expect(isCacheValid(null), false);
      expect(isCacheValid('invalid-date'), false);
      expect(isCacheValid(DateTime.now().toIso8601String()), true);
      expect(isCacheValid(DateTime.now().subtract(const Duration(days: 29)).toIso8601String()), true);
      expect(isCacheValid(DateTime.now().subtract(const Duration(days: 31)).toIso8601String()), false);
    });
  });

  group('Subscription sync status logic', () {
    test('isInGracePeriod checks status and date', () {
      bool isInGracePeriod(String status, String? gracePeriodEndsAt) {
        if (status != 'grace' && status != 'past_due') return false;
        if (gracePeriodEndsAt == null) return false;
        final endsAt = DateTime.tryParse(gracePeriodEndsAt);
        return endsAt != null && endsAt.isAfter(DateTime.now());
      }

      expect(isInGracePeriod('active', null), false);
      expect(isInGracePeriod('grace', null), false);
      expect(isInGracePeriod('grace', DateTime.now().add(const Duration(days: 5)).toIso8601String()), true);
      expect(isInGracePeriod('grace', DateTime.now().subtract(const Duration(days: 1)).toIso8601String()), false);
      expect(isInGracePeriod('past_due', DateTime.now().add(const Duration(days: 3)).toIso8601String()), true);
    });

    test('isExpired checks status', () {
      bool isExpired(String status) => status == 'expired';

      expect(isExpired('active'), false);
      expect(isExpired('trial'), false);
      expect(isExpired('expired'), true);
    });

    test('isInTrial checks status and date', () {
      bool isInTrial(String status, String? trialEndsAt) {
        if (status != 'trial') return false;
        if (trialEndsAt == null) return true; // trial with no end date
        final endsAt = DateTime.tryParse(trialEndsAt);
        return endsAt != null && endsAt.isAfter(DateTime.now());
      }

      expect(isInTrial('active', null), false);
      expect(isInTrial('trial', null), true);
      expect(isInTrial('trial', DateTime.now().add(const Duration(days: 10)).toIso8601String()), true);
      expect(isInTrial('trial', DateTime.now().subtract(const Duration(days: 1)).toIso8601String()), false);
    });
  });
}
