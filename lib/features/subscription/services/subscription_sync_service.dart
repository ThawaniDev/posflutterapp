import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:thawani_pos/features/subscription/services/feature_gate_service.dart';

/// Provider for SubscriptionSyncService.
final subscriptionSyncServiceProvider = Provider<SubscriptionSyncService>((ref) {
  return SubscriptionSyncService(ref.watch(subscriptionApiServiceProvider), ref.watch(featureGateServiceProvider));
});

/// Service that periodically syncs subscription entitlements from the API.
///
/// Runs on a heartbeat interval and updates the [FeatureGateService] cache.
/// The POS relies on this to stay current with plan changes without manual refresh.
class SubscriptionSyncService {
  final SubscriptionApiService _apiService;
  final FeatureGateService _featureGateService;

  Timer? _heartbeatTimer;
  bool _isSyncing = false;

  /// Heartbeat sync interval (60 seconds as per the feature doc)
  static const _syncInterval = Duration(seconds: 60);

  /// Cached entitlement data from last sync
  Map<String, dynamic>? _lastEntitlementData;

  SubscriptionSyncService(this._apiService, this._featureGateService);

  /// Start periodic sync.
  void startSync() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(_syncInterval, (_) => sync());

    // Perform initial sync immediately
    sync();
  }

  /// Stop periodic sync.
  void stopSync() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  /// Perform a single sync.
  Future<void> sync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final data = await _apiService.syncEntitlements();
      _lastEntitlementData = data;

      final features = data['features'] as Map<String, dynamic>? ?? {};
      final limits = data['limits'] as Map<String, dynamic>? ?? {};

      _featureGateService.updateCache(
        features: features.map((k, v) => MapEntry(k, v as bool? ?? false)),
        limits: limits.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map))),
      );

      debugPrint('[SubscriptionSyncService] Sync completed successfully');
    } catch (e) {
      debugPrint('[SubscriptionSyncService] Sync failed: $e');
    } finally {
      _isSyncing = false;
    }
  }

  /// Get the current subscription status from last sync.
  String? get currentStatus => _lastEntitlementData?['status'] as String?;

  /// Whether subscription exists.
  bool get hasSubscription => _lastEntitlementData?['has_subscription'] as bool? ?? false;

  /// Plan code from last sync.
  String? get planCode => _lastEntitlementData?['plan_code'] as String?;

  /// Plan name from last sync.
  String? get planName => _lastEntitlementData?['plan_name'] as String?;

  /// Plan name (Arabic) from last sync.
  String? get planNameAr => _lastEntitlementData?['plan_name_ar'] as String?;

  /// Subscription expiry.
  DateTime? get expiresAt {
    final v = _lastEntitlementData?['expires_at'] as String?;
    return v != null ? DateTime.tryParse(v) : null;
  }

  /// Trial end date.
  DateTime? get trialEndsAt {
    final v = _lastEntitlementData?['trial_ends_at'] as String?;
    return v != null ? DateTime.tryParse(v) : null;
  }

  /// Grace period end date.
  DateTime? get gracePeriodEndsAt {
    final v = _lastEntitlementData?['grace_period_ends_at'] as String?;
    return v != null ? DateTime.tryParse(v) : null;
  }

  /// Whether the subscription is in grace period.
  bool get isInGracePeriod => currentStatus == 'grace';

  /// Whether the subscription is expired.
  bool get isExpired => currentStatus == 'expired';

  /// Whether the subscription is in trial.
  bool get isInTrial => currentStatus == 'trial';

  /// Billing cycle.
  String? get billingCycle => _lastEntitlementData?['billing_cycle'] as String?;

  /// Whether sync is currently running.
  bool get isSyncing => _isSyncing;

  /// Latest raw entitlement data.
  Map<String, dynamic>? get lastEntitlementData => _lastEntitlementData;

  /// Dispose resources.
  void dispose() {
    stopSync();
  }
}
