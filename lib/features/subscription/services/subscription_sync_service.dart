import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';

/// Provider for SubscriptionSyncService.
final subscriptionSyncServiceProvider = Provider<SubscriptionSyncService>((ref) {
  return SubscriptionSyncService(ref.watch(featureGateServiceProvider));
});

/// Service that periodically syncs subscription entitlements from the API.
///
/// Runs on a heartbeat interval and updates the [FeatureGateService] cache.
/// The POS relies on this to stay current with plan changes without manual refresh.
class SubscriptionSyncService {
  final FeatureGateService _featureGateService;

  Timer? _heartbeatTimer;
  bool _isSyncing = false;

  /// Heartbeat sync interval (60 seconds as per the feature doc)
  static const _syncInterval = Duration(seconds: 60);

  /// Cached entitlement data from last sync
  Map<String, dynamic>? _lastEntitlementData;

  SubscriptionSyncService(this._featureGateService);

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
      // FeatureGateService.syncEntitlements() calls the API, parses all data
      // (features, limits, softPOS, plan, subscription, route mapping),
      // and saves to SharedPreferences.
      await _featureGateService.syncEntitlements();

      // Keep local cache for convenience getters
      final sub = _featureGateService.subscriptionStatus ?? {};
      _lastEntitlementData = {
        'status': sub['status'],
        'has_subscription': _featureGateService.hasActiveSubscription,
        'plan_code': _featureGateService.planDetails?['code'],
        'plan_name': _featureGateService.planDetails?['name'],
        'plan_name_ar': _featureGateService.planDetails?['name_ar'],
        'expires_at': sub['expires_at'],
        'trial_ends_at': sub['trial_ends_at'],
        'grace_period_ends_at': sub['grace_period_ends_at'],
        'billing_cycle': sub['billing_cycle'],
      };

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
