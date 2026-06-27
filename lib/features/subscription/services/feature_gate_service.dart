import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/core/constants/storage_keys.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';

/// Provider for FeatureGateService.
final featureGateServiceProvider = ChangeNotifierProvider<FeatureGateService>((ref) {
  return FeatureGateService(ref.watch(subscriptionApiServiceProvider));
});

/// Central feature gate checker.
///
/// - Checks if a feature is enabled based on the current subscription tier.
/// - Checks if a resource is within quota (plan limits).
/// - Caches softPOS threshold info and feature-route mapping.
/// - Falls back to local cache when offline.
class FeatureGateService extends ChangeNotifier {
  FeatureGateService(this._apiService);
  final SubscriptionApiService _apiService;

  /// In-memory feature cache: featureKey → isEnabled
  Map<String, bool> _featureCache = {};

  /// In-memory limits cache: limitKey → {limit, current}
  Map<String, Map<String, dynamic>> _limitsCache = {};

  /// SoftPOS info cache
  Map<String, dynamic>? _softPosInfo;

  /// Feature-to-route mapping cache
  Map<String, List<String>>? _featureRouteMapping;

  /// Plan details
  Map<String, dynamic>? _planDetails;

  /// Subscription status
  Map<String, dynamic>? _subscriptionStatus;

  /// When the cache was last synced
  DateTime? _lastSyncedAt;

  /// How long the cache is considered valid (30 days for offline)
  static const _maxCacheAge = Duration(days: 30);

  /// Initialize : load from local storage
  Future<void> initialize() async {
    await _loadFromLocalStorage();
  }

  /// Check if a feature is enabled for the current subscription.
  ///
  /// First checks local cache, then falls back to API if cache is stale.
  bool isFeatureEnabled(String featureKey) {
    return _featureCache[featureKey] ?? false;
  }

  /// Get the plan limit for a resource type.
  ///
  /// Returns -1 if unlimited, null if not found.
  int? getLimit(String limitKey) {
    final data = _limitsCache[limitKey];
    if (data == null) return null;
    return (data['limit'] as num?)?.toInt();
  }

  /// Get current usage for a resource type.
  int getCurrentUsage(String limitKey) {
    final data = _limitsCache[limitKey];
    if (data == null) return 0;
    return (data['current'] as num?)?.toInt() ?? 0;
  }

  /// Get remaining quota for a resource type.
  ///
  /// Returns null if unlimited.
  int? getRemainingQuota(String limitKey) {
    final limit = getLimit(limitKey);
    if (limit == null) return null;
    if (limit == -1) return null; // unlimited
    final current = getCurrentUsage(limitKey);
    return (limit - current).clamp(0, limit);
  }

  /// Check if the store can perform an action (within quota).
  bool canPerformAction(String limitKey) {
    final remaining = getRemainingQuota(limitKey);
    return remaining == null || remaining > 0;
  }

  /// Get usage percentage (0.0 - 100.0).
  double getUsagePercentage(String limitKey) {
    final limit = getLimit(limitKey);
    if (limit == null || limit <= 0) return 0.0;
    if (limit == -1) return 0.0; // unlimited
    final current = getCurrentUsage(limitKey);
    return (current / limit * 100).clamp(0.0, 100.0);
  }

  /// Whether usage is at warning level (≥80%)
  bool isAtWarningLevel(String limitKey) {
    return getUsagePercentage(limitKey) >= 80.0;
  }

  /// Whether usage is at danger level (≥95%)
  bool isAtDangerLevel(String limitKey) {
    return getUsagePercentage(limitKey) >= 95.0;
  }

  /// Whether the cache is still considered valid for offline use.
  bool get isCacheValid {
    if (_lastSyncedAt == null) return false;
    return DateTime.now().difference(_lastSyncedAt!) < _maxCacheAge;
  }

  /// Sync entitlements from the API and persist locally.
  Future<void> syncEntitlements() async {
    try {
      final data = await _apiService.syncEntitlements();

      final features = data['features'] as Map<String, dynamic>? ?? {};
      final limits = data['limits'] as Map<String, dynamic>? ?? {};

      _featureCache = features.map((k, v) => MapEntry(k, v as bool? ?? false));
      _limitsCache = limits.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));

      // Cache softPOS info
      if (data.containsKey('softpos')) {
        _softPosInfo = Map<String, dynamic>.from(data['softpos'] as Map? ?? {});
      }

      // Cache feature-route mapping
      if (data.containsKey('feature_route_mapping')) {
        final mapping = data['feature_route_mapping'] as Map<String, dynamic>? ?? {};
        _featureRouteMapping = mapping.map((k, v) => MapEntry(k, (v as List).cast<String>()));
      }

      // Cache plan details
      if (data.containsKey('plan')) {
        _planDetails = _extractPlanDetails(data);
      }

      // Cache subscription status
      if (data.containsKey('subscription')) {
        _subscriptionStatus = Map<String, dynamic>.from(data['subscription'] as Map? ?? {});
      }

      _lastSyncedAt = DateTime.now();

      // Include synced_at in data before persisting
      data['synced_at'] = _lastSyncedAt!.toIso8601String();

      await _saveToLocalStorage(data);

      notifyListeners();
      debugPrint('[FeatureGateService] Entitlements synced: ${_featureCache.length} features, ${_limitsCache.length} limits');
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        // Propagate 403 so callers (e.g. SubscriptionSyncService) can back off.
        debugPrint('[FeatureGateService] Sync failed with 403: using cached data');
        rethrow;
      }
      debugPrint('[FeatureGateService] Sync failed, using cached data: $e');
    } catch (e) {
      debugPrint('[FeatureGateService] Sync failed, using cached data: $e');
    }
  }

  /// Update the local cache with fresh entitlement data (from sync service).
  void updateCache({required Map<String, bool> features, required Map<String, Map<String, dynamic>> limits}) {
    _featureCache = features;
    _limitsCache = limits;
    _lastSyncedAt = DateTime.now();
    notifyListeners();
  }

  /// Load cached entitlements from SharedPreferences.
  Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(StorageKeys.subscriptionEntitlements);
      if (raw == null) return;

      final data = json.decode(raw) as Map<String, dynamic>;

      final features = data['features'] as Map<String, dynamic>? ?? {};
      final limits = data['limits'] as Map<String, dynamic>? ?? {};
      final syncedAt = data['synced_at'] as String?;

      _featureCache = features.map((k, v) => MapEntry(k, v as bool? ?? false));
      _limitsCache = limits.map((k, v) => MapEntry(k, Map<String, dynamic>.from(v as Map)));

      if (data.containsKey('softpos')) {
        _softPosInfo = Map<String, dynamic>.from(data['softpos'] as Map? ?? {});
      }
      if (data.containsKey('feature_route_mapping')) {
        final mapping = data['feature_route_mapping'] as Map<String, dynamic>? ?? {};
        _featureRouteMapping = mapping.map((k, v) => MapEntry(k, (v as List).cast<String>()));
      }
      if (data.containsKey('plan')) {
        _planDetails = _extractPlanDetails(data);
      }
      if (data.containsKey('subscription')) {
        _subscriptionStatus = Map<String, dynamic>.from(data['subscription'] as Map? ?? {});
      }

      if (syncedAt != null) {
        _lastSyncedAt = DateTime.tryParse(syncedAt);
      }

      debugPrint('[FeatureGateService] Loaded cached entitlements: ${_featureCache.length} features');
      notifyListeners();
    } catch (e) {
      debugPrint('[FeatureGateService] Failed to load cached entitlements: $e');
    }
  }

  Map<String, dynamic> _extractPlanDetails(Map<String, dynamic> data) {
    final plan = Map<String, dynamic>.from(data['plan'] as Map? ?? {});
    plan['hide_from_public'] = plan['hide_from_public'] ?? data['hide_from_public'] ?? false;
    plan['hide_unselected_features'] = plan['hide_unselected_features'] ?? data['hide_unselected_features'] ?? false;
    return plan;
  }

  /// Save entitlements to SharedPreferences.
  Future<void> _saveToLocalStorage(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(StorageKeys.subscriptionEntitlements, json.encode(data));
    } catch (e) {
      debugPrint('[FeatureGateService] Failed to save entitlements: $e');
    }
  }

  /// Clear the local cache (e.g. on logout).
  Future<void> clearCache() async {
    _featureCache = {};
    _limitsCache = {};
    _lastSyncedAt = null;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(StorageKeys.subscriptionEntitlements);
    } catch (_) {}
    notifyListeners();
  }

  /// All cached features.
  Map<String, bool> get features => Map.unmodifiable(_featureCache);

  /// All cached limits.
  Map<String, Map<String, dynamic>> get limits => Map.unmodifiable(_limitsCache);

  /// SoftPOS threshold info (null if not loaded).
  Map<String, dynamic>? get softPosInfo => _softPosInfo;

  /// Feature-to-route mapping (null if not loaded).
  Map<String, List<String>>? get featureRouteMapping => _featureRouteMapping;

  /// Cached plan details.
  Map<String, dynamic>? get planDetails => _planDetails;

  /// When true, sidebar items whose feature_key is disabled for the current
  /// plan should be hidden entirely rather than shown as locked/greyed out.
  bool get hideUnselectedFeatures {
    final value = _planDetails?['hide_unselected_features'];
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }

    // Compatibility for cached entitlement payloads from before the visibility
    // flag was added to the nested plan object.
    final slug = _planDetails?['slug']?.toString() ?? _planDetails?['code']?.toString();
    return slug == 'small-supermarket';
  }

  /// Cached subscription status.
  Map<String, dynamic>? get subscriptionStatus => _subscriptionStatus;

  /// Whether the subscription has an active status.
  bool get hasActiveSubscription {
    final status = _subscriptionStatus?['status'] as String?;
    return status == 'active' || status == 'trial' || status == 'grace';
  }

  /// Whether the POS should be hard-blocked due to subscription state.
  ///
  /// Returns `true` ONLY when there is a confirmed lapsed status
  /// (`expired` or `cancelled`). Fails **open** for every other case —
  /// including `null`/unknown status — so the POS is never wrongly locked
  /// out before the first sync, on a fresh install, or when a sync fails
  /// with no cache. Grace period is allowed through (a banner is shown).
  /// Server-side `plan.active` middleware remains the authoritative gate.
  bool get isPosBlocked {
    final status = _subscriptionStatus?['status'] as String?;
    if (status == null) return false; // fail-open: never lock out on missing data
    const blockedStates = {'expired', 'cancelled', 'paused'};
    return blockedStates.contains(status);
  }

  /// Whether the SoftPOS free tier is active.
  bool get isSoftPosFree => _softPosInfo?['is_free'] as bool? ?? false;

  /// SoftPOS threshold progress percentage (0.0 - 100.0).
  double get softPosProgress => (_softPosInfo?['percentage'] as num?)?.toDouble() ?? 0.0;

  /// Last sync timestamp.
  DateTime? get lastSyncedAt => _lastSyncedAt;
}
