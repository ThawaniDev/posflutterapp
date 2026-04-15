import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/companion/repositories/companion_repository.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';

// --- Quick Stats Provider ---
final quickStatsProvider = StateNotifierProvider<QuickStatsNotifier, QuickStatsState>((ref) {
  return QuickStatsNotifier(ref.watch(companionRepositoryProvider));
});

class QuickStatsNotifier extends StateNotifier<QuickStatsState> {
  final CompanionRepository _repo;

  QuickStatsNotifier(this._repo) : super(const QuickStatsInitial());

  Future<void> load() async {
    if (state is! QuickStatsLoaded) state = const QuickStatsLoading();
    try {
      final res = await _repo.quickStats();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = QuickStatsLoaded(
        todayRevenue: (d['today_revenue'] != null ? double.tryParse(d['today_revenue'].toString()) : null) ?? 0,
        todayTransactions: d['today_transactions'] as int? ?? 0,
        todayOrders: d['today_orders'] as int? ?? 0,
        pendingOrders: d['pending_orders'] as int? ?? 0,
        activeStaff: d['active_staff'] as int? ?? 0,
        lowStockItems: d['low_stock_items'] as int? ?? 0,
        lastSync: d['last_sync'] as String?,
        currency: d['currency'] as String? ?? '\u0081',
        raw: d,
      );
    } catch (e) {
      if (state is! QuickStatsLoaded) state = QuickStatsError(e.toString());
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
    if (state is! PreferencesLoaded) state = const PreferencesLoading();
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
      if (state is! PreferencesLoaded) state = PreferencesError(e.toString());
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
    if (state is! QuickActionsLoaded) state = const QuickActionsLoading();
    try {
      final res = await _repo.getQuickActions();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final actions = (d['actions'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = QuickActionsLoaded(actions: actions);
    } catch (e) {
      if (state is! QuickActionsLoaded) state = QuickActionsError(e.toString());
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

// --- Companion Dashboard Provider ---
final companionDashboardProvider = StateNotifierProvider<CompanionDashboardNotifier, CompanionDashboardState>((ref) {
  return CompanionDashboardNotifier(ref.watch(companionRepositoryProvider));
});

class CompanionDashboardNotifier extends StateNotifier<CompanionDashboardState> {
  final CompanionRepository _repo;

  CompanionDashboardNotifier(this._repo) : super(const CompanionDashboardInitial());

  Future<void> load() async {
    if (state is! CompanionDashboardLoaded) state = const CompanionDashboardLoading();
    try {
      final res = await _repo.getDashboard();
      final d = res['data'] as Map<String, dynamic>? ?? res;
      state = CompanionDashboardLoaded(
        todayRevenue: (d['today_revenue'] != null ? double.tryParse(d['today_revenue'].toString()) : null) ?? 0,
        yesterdayRevenue: (d['yesterday_revenue'] != null ? double.tryParse(d['yesterday_revenue'].toString()) : null) ?? 0,
        todayOrders: d['today_orders'] as int? ?? 0,
        yesterdayOrders: d['yesterday_orders'] as int? ?? 0,
        activeStaff: d['active_staff'] as int? ?? 0,
        lowStockItems: d['low_stock_items'] as int? ?? 0,
        pendingOrders: d['pending_orders'] as int? ?? 0,
        storeIsOpen: d['store_is_open'] as bool? ?? true,
        currency: d['currency'] as String? ?? '\u0081',
        raw: d,
      );
    } catch (e) {
      if (state is! CompanionDashboardLoaded) state = CompanionDashboardError(e.toString());
    }
  }

  Future<void> toggleStoreAvailability(bool isOpen) async {
    try {
      await _repo.toggleStoreAvailability(isOpen: isOpen);
      await load();
    } catch (e) {
      if (state is! CompanionDashboardLoaded) state = CompanionDashboardError(e.toString());
    }
  }
}

// --- Sales Summary Provider ---
final salesSummaryProvider = StateNotifierProvider<SalesSummaryNotifier, SalesSummaryState>((ref) {
  return SalesSummaryNotifier(ref.watch(companionRepositoryProvider));
});

class SalesSummaryNotifier extends StateNotifier<SalesSummaryState> {
  final CompanionRepository _repo;

  SalesSummaryNotifier(this._repo) : super(const SalesSummaryInitial());

  Future<void> load({String period = 'today', String? storeId}) async {
    if (state is! SalesSummaryLoaded) state = const SalesSummaryLoading();
    try {
      final res = await _repo.getSalesSummary(period: period, storeId: storeId);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final summary = d['summary'] as Map<String, dynamic>? ?? d;
      final daily = (d['daily_breakdown'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      final periodData = d['period'];
      final periodMap = periodData is Map<String, dynamic>
          ? periodData
          : <String, dynamic>{'label': periodData?.toString() ?? period};
      state = SalesSummaryLoaded(
        period: periodMap,
        totalRevenue: (summary['total_revenue'] != null ? double.tryParse(summary['total_revenue'].toString()) : null) ?? 0,
        totalOrders: summary['total_orders'] as int? ?? 0,
        averageOrderValue: (summary['average_order'] != null ? double.tryParse(summary['average_order'].toString()) : null) ?? 0,
        dailyBreakdown: daily,
        raw: d,
      );
    } catch (e) {
      if (state is! SalesSummaryLoaded) state = SalesSummaryError(e.toString());
    }
  }
}

// --- Active Orders Provider ---
final activeOrdersProvider = StateNotifierProvider<ActiveOrdersNotifier, ActiveOrdersState>((ref) {
  return ActiveOrdersNotifier(ref.watch(companionRepositoryProvider));
});

class ActiveOrdersNotifier extends StateNotifier<ActiveOrdersState> {
  final CompanionRepository _repo;

  ActiveOrdersNotifier(this._repo) : super(const ActiveOrdersInitial());

  Future<void> load({String? storeId}) async {
    if (state is! ActiveOrdersLoaded) state = const ActiveOrdersLoading();
    try {
      final res = await _repo.getActiveOrders(storeId: storeId);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final orders = (d['orders'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = ActiveOrdersLoaded(orders: orders, total: d['total'] as int? ?? orders.length);
    } catch (e) {
      if (state is! ActiveOrdersLoaded) state = ActiveOrdersError(e.toString());
    }
  }
}

// --- Inventory Alerts Provider ---
final inventoryAlertsProvider = StateNotifierProvider<InventoryAlertsNotifier, InventoryAlertsState>((ref) {
  return InventoryAlertsNotifier(ref.watch(companionRepositoryProvider));
});

class InventoryAlertsNotifier extends StateNotifier<InventoryAlertsState> {
  final CompanionRepository _repo;

  InventoryAlertsNotifier(this._repo) : super(const InventoryAlertsInitial());

  Future<void> load({String? storeId}) async {
    if (state is! InventoryAlertsLoaded) state = const InventoryAlertsLoading();
    try {
      final res = await _repo.getInventoryAlerts(storeId: storeId);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final alerts = (d['alerts'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = InventoryAlertsLoaded(
        alerts: alerts,
        lowStockCount: d['low_stock_count'] as int? ?? 0,
        outOfStockCount: d['out_of_stock_count'] as int? ?? 0,
      );
    } catch (e) {
      if (state is! InventoryAlertsLoaded) state = InventoryAlertsError(e.toString());
    }
  }
}

// --- Active Staff Provider ---
final activeStaffProvider = StateNotifierProvider<ActiveStaffNotifier, ActiveStaffState>((ref) {
  return ActiveStaffNotifier(ref.watch(companionRepositoryProvider));
});

class ActiveStaffNotifier extends StateNotifier<ActiveStaffState> {
  final CompanionRepository _repo;

  ActiveStaffNotifier(this._repo) : super(const ActiveStaffInitial());

  Future<void> load({String? storeId}) async {
    if (state is! ActiveStaffLoaded) state = const ActiveStaffLoading();
    try {
      final res = await _repo.getActiveStaff(storeId: storeId);
      final d = res['data'] as Map<String, dynamic>? ?? res;
      final staff = (d['staff'] as List<dynamic>?)?.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
      state = ActiveStaffLoaded(staff: staff, totalActive: d['total_active'] as int? ?? staff.length);
    } catch (e) {
      if (state is! ActiveStaffLoaded) state = ActiveStaffError(e.toString());
    }
  }
}
