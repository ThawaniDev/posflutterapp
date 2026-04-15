import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/delivery_integration/repositories/delivery_repository.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

// ─── Delivery Stats Provider ────────────────────────────
class DeliveryStatsNotifier extends StateNotifier<DeliveryStatsState> {
  final DeliveryRepository _repository;
  DeliveryStatsNotifier(this._repository) : super(const DeliveryStatsInitial());

  Future<void> load() async {
    if (state is! DeliveryStatsLoaded) state = const DeliveryStatsLoading();
    try {
      final result = await _repository.getStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final platforms = (data['platforms'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
      state = DeliveryStatsLoaded(
        totalPlatforms: data['total_platforms'] as int? ?? 0,
        activePlatforms: data['active_platforms'] as int? ?? 0,
        totalOrders: data['total_orders'] as int? ?? 0,
        pendingOrders: data['pending_orders'] as int? ?? 0,
        completedOrders: data['completed_orders'] as int? ?? 0,
        todayOrders: data['today_orders'] as int? ?? 0,
        todayRevenue: (data['today_revenue'] != null ? double.tryParse(data['today_revenue'].toString()) : null) ?? 0.0,
        activeOrders: data['active_orders'] as int? ?? 0,
        rejectedOrders: data['rejected_orders'] as int? ?? 0,
        platformBreakdown: platforms,
      );
    } catch (e) {
      if (state is! DeliveryStatsLoaded) state = DeliveryStatsError(e.toString());
    }
  }
}

final deliveryStatsProvider = StateNotifierProvider<DeliveryStatsNotifier, DeliveryStatsState>((ref) {
  return DeliveryStatsNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Delivery Configs Provider ──────────────────────────
class DeliveryConfigsNotifier extends StateNotifier<DeliveryConfigsState> {
  final DeliveryRepository _repository;
  DeliveryConfigsNotifier(this._repository) : super(const DeliveryConfigsInitial());

  Future<void> load() async {
    if (state is! DeliveryConfigsLoaded) state = const DeliveryConfigsLoading();
    try {
      final result = await _repository.getConfigs();
      final data = result['data'] as List<dynamic>? ?? [];
      state = DeliveryConfigsLoaded(data.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! DeliveryConfigsLoaded) state = DeliveryConfigsError(e.toString());
    }
  }

  Future<void> toggle(String id) async {
    try {
      await _repository.toggleConfig(id);
      await load();
    } catch (e) {
      state = DeliveryConfigsError(e.toString());
    }
  }

  Future<void> saveConfig(Map<String, dynamic> data) async {
    try {
      await _repository.saveConfig(data);
      await load();
    } catch (e) {
      state = DeliveryConfigsError(e.toString());
    }
  }

  Future<bool> deleteConfig(String id) async {
    try {
      await _repository.deleteConfig(id);
      await load();
      return true;
    } catch (e) {
      state = DeliveryConfigsError(e.toString());
      return false;
    }
  }
}

final deliveryConfigsProvider = StateNotifierProvider<DeliveryConfigsNotifier, DeliveryConfigsState>((ref) {
  return DeliveryConfigsNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Delivery Orders Provider ───────────────────────────
class DeliveryOrdersNotifier extends StateNotifier<DeliveryOrdersState> {
  final DeliveryRepository _repository;
  DeliveryOrdersNotifier(this._repository) : super(const DeliveryOrdersInitial());

  String? _platformFilter;
  String? _statusFilter;

  String? get platformFilter => _platformFilter;
  String? get statusFilter => _statusFilter;

  Future<void> load({String? platform, String? status, int? page, String? dateFrom, String? dateTo}) async {
    _platformFilter = platform;
    _statusFilter = status;
    if (state is! DeliveryOrdersLoaded) state = const DeliveryOrdersLoading();
    try {
      final result = await _repository.getOrders(
        platform: platform,
        status: status,
        page: page,
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = data['data'] as List<dynamic>? ?? [];
      final meta = data['meta'] as Map<String, dynamic>? ?? data;
      state = DeliveryOrdersLoaded(
        items.cast<Map<String, dynamic>>(),
        currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
        total: (meta['total'] as num?)?.toInt() ?? items.length,
      );
    } catch (e) {
      if (state is! DeliveryOrdersLoaded) state = DeliveryOrdersError(e.toString());
    }
  }

  Future<void> loadActive() async {
    if (state is! DeliveryOrdersLoaded) state = const DeliveryOrdersLoading();
    try {
      final result = await _repository.getActiveOrders();
      final data = result['data'] as List<dynamic>? ?? [];
      state = DeliveryOrdersLoaded(data.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! DeliveryOrdersLoaded) state = DeliveryOrdersError(e.toString());
    }
  }

  Future<bool> updateOrderStatus(String id, {required String status, String? rejectionReason}) async {
    try {
      await _repository.updateOrderStatus(id, status: status, rejectionReason: rejectionReason);
      await load(platform: _platformFilter, status: _statusFilter);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final deliveryOrdersProvider = StateNotifierProvider<DeliveryOrdersNotifier, DeliveryOrdersState>((ref) {
  return DeliveryOrdersNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Delivery Order Detail Provider ─────────────────────
class DeliveryOrderDetailNotifier extends StateNotifier<DeliveryOrderDetailState> {
  final DeliveryRepository _repository;
  DeliveryOrderDetailNotifier(this._repository) : super(const DeliveryOrderDetailInitial());

  Future<void> load(String id) async {
    state = const DeliveryOrderDetailLoading();
    try {
      final result = await _repository.getOrderDetail(id);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = DeliveryOrderDetailLoaded(data);
    } catch (e) {
      state = DeliveryOrderDetailError(e.toString());
    }
  }

  Future<bool> updateStatus({required String id, required String status, String? rejectionReason}) async {
    try {
      await _repository.updateOrderStatus(id, status: status, rejectionReason: rejectionReason);
      await load(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}

final deliveryOrderDetailProvider = StateNotifierProvider<DeliveryOrderDetailNotifier, DeliveryOrderDetailState>((ref) {
  return DeliveryOrderDetailNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Delivery Platforms Provider ────────────────────────
class DeliveryPlatformsNotifier extends StateNotifier<DeliveryPlatformsState> {
  final DeliveryRepository _repository;
  DeliveryPlatformsNotifier(this._repository) : super(const DeliveryPlatformsInitial());

  Future<void> load() async {
    if (state is! DeliveryPlatformsLoaded) state = const DeliveryPlatformsLoading();
    try {
      final result = await _repository.getPlatforms();
      final data = result['data'] as List<dynamic>? ?? [];
      state = DeliveryPlatformsLoaded(data.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! DeliveryPlatformsLoaded) state = DeliveryPlatformsError(e.toString());
    }
  }
}

final deliveryPlatformsProvider = StateNotifierProvider<DeliveryPlatformsNotifier, DeliveryPlatformsState>((ref) {
  return DeliveryPlatformsNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Connection Test Provider ───────────────────────────
class DeliveryConnectionTestNotifier extends StateNotifier<DeliveryConnectionTestState> {
  final DeliveryRepository _repository;
  DeliveryConnectionTestNotifier(this._repository) : super(const DeliveryConnectionTestIdle());

  Future<void> test(String configId) async {
    state = const DeliveryConnectionTestLoading();
    try {
      final result = await _repository.testConnection(configId);
      final success = result['success'] as bool? ?? false;
      if (success) {
        state = DeliveryConnectionTestSuccess(result['message'] as String? ?? 'Connected');
      } else {
        state = DeliveryConnectionTestFailure(result['message'] as String? ?? 'Connection failed');
      }
    } catch (e) {
      state = DeliveryConnectionTestFailure(e.toString());
    }
  }

  void reset() => state = const DeliveryConnectionTestIdle();
}

final deliveryConnectionTestProvider = StateNotifierProvider<DeliveryConnectionTestNotifier, DeliveryConnectionTestState>((ref) {
  return DeliveryConnectionTestNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Menu Sync Provider ─────────────────────────────────
class DeliveryMenuSyncNotifier extends StateNotifier<DeliveryMenuSyncState> {
  final DeliveryRepository _repository;
  DeliveryMenuSyncNotifier(this._repository) : super(const DeliveryMenuSyncIdle());

  Future<void> sync({String? platform, required List<Map<String, dynamic>> products}) async {
    state = const DeliveryMenuSyncLoading();
    try {
      final result = await _repository.triggerMenuSync(platform: platform, products: products);
      state = DeliveryMenuSyncSuccess(result['message'] as String? ?? 'Sync completed');
    } catch (e) {
      state = DeliveryMenuSyncError(e.toString());
    }
  }

  void reset() => state = const DeliveryMenuSyncIdle();
}

final deliveryMenuSyncProvider = StateNotifierProvider<DeliveryMenuSyncNotifier, DeliveryMenuSyncState>((ref) {
  return DeliveryMenuSyncNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Webhook Logs Provider ──────────────────────────────
class DeliveryWebhookLogsNotifier extends StateNotifier<DeliveryWebhookLogsState> {
  final DeliveryRepository _repository;
  DeliveryWebhookLogsNotifier(this._repository) : super(const DeliveryWebhookLogsInitial());

  String? _platformFilter;
  String? get platformFilter => _platformFilter;

  Future<void> load({String? platform, int? page}) async {
    _platformFilter = platform;
    if (state is! DeliveryWebhookLogsLoaded) state = const DeliveryWebhookLogsLoading();
    try {
      final result = await _repository.getWebhookLogs(platform: platform, page: page, perPage: 20);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = data['data'] as List<dynamic>? ?? [];
      final meta = data['meta'] as Map<String, dynamic>? ?? data;
      state = DeliveryWebhookLogsLoaded(
        items.cast<Map<String, dynamic>>(),
        currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
        total: (meta['total'] as num?)?.toInt() ?? items.length,
      );
    } catch (e) {
      if (state is! DeliveryWebhookLogsLoaded) state = DeliveryWebhookLogsError(e.toString());
    }
  }
}

final deliveryWebhookLogsProvider = StateNotifierProvider<DeliveryWebhookLogsNotifier, DeliveryWebhookLogsState>((ref) {
  return DeliveryWebhookLogsNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Status Push Logs Provider ──────────────────────────
class DeliveryStatusPushLogsNotifier extends StateNotifier<DeliveryStatusPushLogsState> {
  final DeliveryRepository _repository;
  DeliveryStatusPushLogsNotifier(this._repository) : super(const DeliveryStatusPushLogsInitial());

  String? _platformFilter;
  String? get platformFilter => _platformFilter;

  Future<void> load({String? platform, int? page}) async {
    _platformFilter = platform;
    if (state is! DeliveryStatusPushLogsLoaded) state = const DeliveryStatusPushLogsLoading();
    try {
      final result = await _repository.getStatusPushLogs(platform: platform, page: page, perPage: 20);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = data['data'] as List<dynamic>? ?? [];
      final meta = data['meta'] as Map<String, dynamic>? ?? data;
      state = DeliveryStatusPushLogsLoaded(
        items.cast<Map<String, dynamic>>(),
        currentPage: (meta['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (meta['last_page'] as num?)?.toInt() ?? 1,
        total: (meta['total'] as num?)?.toInt() ?? items.length,
      );
    } catch (e) {
      if (state is! DeliveryStatusPushLogsLoaded) state = DeliveryStatusPushLogsError(e.toString());
    }
  }
}

final deliveryStatusPushLogsProvider = StateNotifierProvider<DeliveryStatusPushLogsNotifier, DeliveryStatusPushLogsState>((ref) {
  return DeliveryStatusPushLogsNotifier(ref.watch(deliveryRepositoryProvider));
});
