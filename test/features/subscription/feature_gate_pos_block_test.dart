import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/core/constants/storage_keys.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';

/// Unit tests for [FeatureGateService.isPosBlocked].
///
/// These verify the POS paywall gate decision logic without any network:
/// the service is seeded purely from local storage via [initialize].
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FeatureGateService buildService() {
    // isPosBlocked only reads cached local state, so a bare Dio (never called)
    // is sufficient for the API dependency.
    return FeatureGateService(SubscriptionApiService(Dio()));
  }

  Future<FeatureGateService> serviceWithStatus(String? status) async {
    final payload = <String, dynamic>{
      'features': <String, dynamic>{'pos': true},
      'limits': <String, dynamic>{},
      'synced_at': DateTime.now().toIso8601String(),
      if (status != null) 'subscription': <String, dynamic>{'status': status, 'expires_at': '2026-01-01T00:00:00.000Z'},
      'plan': <String, dynamic>{'code': 'growth', 'name': 'Growth'},
    };
    SharedPreferences.setMockInitialValues({StorageKeys.subscriptionEntitlements: jsonEncode(payload)});
    final service = buildService();
    await service.initialize();
    return service;
  }

  group('FeatureGateService.isPosBlocked', () {
    test('fails open when no cache exists (fresh install / no sync yet)', () async {
      SharedPreferences.setMockInitialValues({});
      final service = buildService();
      await service.initialize();
      expect(service.isPosBlocked, isFalse);
    });

    test('fails open when subscription is missing from payload', () async {
      final service = await serviceWithStatus(null);
      expect(service.isPosBlocked, isFalse);
    });

    test('does NOT block on active', () async {
      final service = await serviceWithStatus('active');
      expect(service.isPosBlocked, isFalse);
    });

    test('does NOT block on trial', () async {
      final service = await serviceWithStatus('trial');
      expect(service.isPosBlocked, isFalse);
    });

    test('does NOT block on grace (banner is shown instead)', () async {
      final service = await serviceWithStatus('grace');
      expect(service.isPosBlocked, isFalse);
    });

    test('BLOCKS on expired', () async {
      final service = await serviceWithStatus('expired');
      expect(service.isPosBlocked, isTrue);
    });

    test('BLOCKS on cancelled', () async {
      final service = await serviceWithStatus('cancelled');
      expect(service.isPosBlocked, isTrue);
    });

    test('BLOCKS on paused', () async {
      final service = await serviceWithStatus('paused');
      expect(service.isPosBlocked, isTrue);
    });
  });
}
