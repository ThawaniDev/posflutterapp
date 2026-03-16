import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/companion/repositories/companion_repository.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

// --- Quick Stats Provider ---
final quickStatsProvider = StateNotifierProvider<QuickStatsNotifier, QuickStatsState>((ref) {
  return QuickStatsNotifier(ref.watch(companionRepositoryProvider));
});

class QuickStatsNotifier extends StateNotifier<QuickStatsState> {
  final CompanionRepository _repo;

  QuickStatsNotifier(this._repo) : super(const QuickStatsInitial());

  Future<void> load() async {
    state = const QuickStatsLoading();
    try {
      final res = await _repo.quickStats();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = QuickStatsLoaded(
        todayRevenue: (d['today_revenue'] as num?)?.toDouble() ?? 0,
        todayTransactions: d['today_transactions'] as int? ?? 0,
        todayOrders: d['today_orders'] as int? ?? 0,
        pendingOrders: d['pending_orders'] as int? ?? 0,
        activeStaff: d['active_staff'] as int? ?? 0,
        lowStockItems: d['low_stock_items'] as int? ?? 0,
        lastSync: d['last_sync'] as String?,
        currency: d['currency'] as String? ?? 'SAR',
        raw: d,
      );
    } catch (e) {
      state = QuickStatsError(e.toString());
    }
  }
}

// --- Preferences Provider ---
final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  return PreferencesNotifier(ref.watch(companionRepositoryProvider));
});

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  final CompanionRepository _repo;

  PreferencesNotifier(this._repo) : super(const PreferencesInitial());

  Future<void> load() async {
    state = const PreferencesLoading();
    try {
      final res = await _repo.getPreferences();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = PreferencesLoaded(
        theme: d['theme'] as String? ?? 'system',
        language: d['language'] as String? ?? 'en',
        compactMode: d['compact_mode'] as bool? ?? false,
        notificationsEnabled: d['notifications_enabled'] as bool? ?? true,
        biometricLock: d['biometric_lock'] as bool? ?? false,
        defaultPage: d['default_page'] as String? ?? 'dashboard',
        currencyDisplay: d['currency_display'] as String? ?? 'symbol',
        raw: d,
      );
    } catch (e) {
      state = PreferencesError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    state = const PreferencesLoading();
    try {
      await _repo.updatePreferences(data);
      await load();
    } catch (e) {
      state = PreferencesError(e.toString());
    }
  }
}

// --- Quick Actions Provider ---
final quickActionsProvider = StateNotifierProvider<QuickActionsNotifier, QuickActionsState>((ref) {
  return QuickActionsNotifier(ref.watch(companionRepositoryProvider));
});

class QuickActionsNotifier extends StateNotifier<QuickActionsState> {
  final CompanionRepository _repo;

  QuickActionsNotifier(this._repo) : super(const QuickActionsInitial());

  Future<void> load() async {
    state = const QuickActionsLoading();
    try {
      final res = await _repo.getQuickActions();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final actions = (d['actions'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = QuickActionsLoaded(actions: actions);
    } catch (e) {
      state = QuickActionsError(e.toString());
    }
  }

  Future<void> updateActions(List<Map<String, dynamic>> actions) async {
    state = const QuickActionsLoading();
    try {
      await _repo.updateQuickActions(actions);
      await load();
    } catch (e) {
      state = QuickActionsError(e.toString());
    }
  }
}

// --- Companion Operation Provider ---
final companionOperationProvider = StateNotifierProvider<CompanionOperationNotifier, CompanionOperationState>((ref) {
  return CompanionOperationNotifier(ref.watch(companionRepositoryProvider));
});

class CompanionOperationNotifier extends StateNotifier<CompanionOperationState> {
  final CompanionRepository _repo;

  CompanionOperationNotifier(this._repo) : super(const CompanionOperationIdle());

  Future<void> registerSession({required String deviceName, required String deviceOs, required String appVersion}) async {
    state = const CompanionOperationRunning('register_session');
    try {
      final res = await _repo.registerSession(deviceName: deviceName, deviceOs: deviceOs, appVersion: appVersion);
      state = CompanionOperationSuccess('Session registered', data: res);
    } catch (e) {
      state = CompanionOperationError(e.toString());
    }
  }

  Future<void> endSession(String sessionId) async {
    state = const CompanionOperationRunning('end_session');
    try {
      await _repo.endSession(sessionId);
      state = const CompanionOperationSuccess('Session ended');
    } catch (e) {
      state = CompanionOperationError(e.toString());
    }
  }

  Future<void> logEvent({required String eventType, Map<String, dynamic>? eventData}) async {
    state = const CompanionOperationRunning('log_event');
    try {
      await _repo.logEvent(eventType: eventType, eventData: eventData);
      state = const CompanionOperationSuccess('Event logged');
    } catch (e) {
      state = CompanionOperationError(e.toString());
    }
  }

  void reset() {
    state = const CompanionOperationIdle();
  }
}
