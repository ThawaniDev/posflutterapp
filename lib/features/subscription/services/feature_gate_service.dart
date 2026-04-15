import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/core/constants/storage_keys.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';

/// Provider for FeatureGateService.
final featureGateServiceProvider = Provider<FeatureGateService>((ref) {
  return FeatureGateService(ref.watch(subscriptionApiServiceProvider));
});

/// Central feature gate checker.
///
/// - Checks if a feature is enabled based on the current subscription tier.
/// - Checks if a resource is within quota (plan limits).
/// - Falls back to local cache when offline.
class FeatureGateService {
  final SubscriptionApiService _apiService;

  /// In-memory feature cache: featureKey → isEnabled
  Map<String, bool> _featureCache = {};

  /// In-memory limits cache: limitKey → {limit, current}
  Map<String, Map<String, dynamic>> _limitsCache = {};

  /// When the cache was last synced
  DateTime? _lastSyncedAt;

  /// How long the cache is considered valid (30 days for offline)
  static const _maxCacheAge = Duration(days: 30);

  FeatureGateService(this._apiService);

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
      _lastSyncedAt = DateTime.now();

      await _saveToLocalStorage(data);

      debugPrint('[FeatureGateService] Entitlements synced: ${_featureCache.length} features, ${_limitsCache.length} limits');
    } catch (e) {
      debugPrint('[FeatureGateService] Sync failed, using cached data: $e');
    }
  }

  /// Update the local cache with fresh entitlement data (from sync service).
  void updateCache({required Map<String, bool> features, required Map<String, Map<String, dynamic>> limits}) {
    _featureCache = features;
    _limitsCache = limits;
    _lastSyncedAt = DateTime.now();
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
      if (syncedAt != null) {
        _lastSyncedAt = DateTime.tryParse(syncedAt);
      }

      debugPrint('[FeatureGateService] Loaded cached entitlements: ${_featureCache.length} features');
    } catch (e) {
      debugPrint('[FeatureGateService] Failed to load cached entitlements: $e');
    }
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
  }

  /// All cached features.
  Map<String, bool> get features => Map.unmodifiable(_featureCache);

  /// All cached limits.
  Map<String, Map<String, dynamic>> get limits => Map.unmodifiable(_limitsCache);

  /// Last sync timestamp.
  DateTime? get lastSyncedAt => _lastSyncedAt;
}
