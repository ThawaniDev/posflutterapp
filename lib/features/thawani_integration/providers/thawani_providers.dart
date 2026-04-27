import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/thawani_integration/repositories/thawani_repository.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

// ─── Thawani Stats Provider ─────────────────────────────
class ThawaniStatsNotifier extends StateNotifier<ThawaniStatsState> {
  ThawaniStatsNotifier(this._repository) : super(const ThawaniStatsInitial());
  final ThawaniRepository _repository;

  Future<void> load() async {
    if (state is! ThawaniStatsLoaded) state = const ThawaniStatsLoading();
    try {
      final result = await _repository.getStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = ThawaniStatsLoaded(
        isConnected: data['is_connected'] as bool? ?? false,
        thawaniStoreId: data['thawani_store_id'] as String?,
        totalOrders: data['total_orders'] as int? ?? 0,
        totalProductsMapped: data['total_products_mapped'] as int? ?? 0,
        totalCategoriesMapped: data['total_categories_mapped'] as int? ?? 0,
        totalSettlements: data['total_settlements'] as int? ?? 0,
        pendingOrders: data['pending_orders'] as int? ?? 0,
        pendingSyncItems: data['pending_sync_items'] as int? ?? 0,
        syncLogsToday: data['sync_logs_today'] as int? ?? 0,
        failedSyncsToday: data['failed_syncs_today'] as int? ?? 0,
      );
    } catch (e) {
      if (state is! ThawaniStatsLoaded) state = ThawaniStatsError(e.toString());
    }
  }
}

final thawaniStatsProvider = StateNotifierProvider<ThawaniStatsNotifier, ThawaniStatsState>((ref) {
  return ThawaniStatsNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Config Provider ────────────────────────────
class ThawaniConfigNotifier extends StateNotifier<ThawaniConfigState> {
  ThawaniConfigNotifier(this._repository) : super(const ThawaniConfigInitial());
  final ThawaniRepository _repository;

  Future<void> load() async {
    if (state is! ThawaniConfigLoaded) state = const ThawaniConfigLoading();
    try {
      final result = await _repository.getConfig();
      final data = result['data'] as Map<String, dynamic>?;
      state = ThawaniConfigLoaded(data);
    } catch (e) {
      if (state is! ThawaniConfigLoaded) state = ThawaniConfigError(e.toString());
    }
  }
}

final thawaniConfigProvider = StateNotifierProvider<ThawaniConfigNotifier, ThawaniConfigState>((ref) {
  return ThawaniConfigNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Action Provider ────────────────────────────
class ThawaniActionNotifier extends StateNotifier<ThawaniActionState> {
  ThawaniActionNotifier(this._repository) : super(const ThawaniActionInitial());
  final ThawaniRepository _repository;

  Future<void> saveConfig(Map<String, dynamic> data) async {
    state = const ThawaniActionLoading();
    try {
      await _repository.saveConfig(data);
      state = const ThawaniActionSuccess('Configuration saved');
    } catch (e) {
      state = ThawaniActionError(e.toString());
    }
  }

  Future<void> disconnect() async {
    state = const ThawaniActionLoading();
    try {
      await _repository.disconnect();
      state = const ThawaniActionSuccess('Disconnected from Thawani');
    } catch (e) {
      state = ThawaniActionError(e.toString());
    }
  }

  void reset() => state = const ThawaniActionInitial();
}

final thawaniActionProvider = StateNotifierProvider<ThawaniActionNotifier, ThawaniActionState>((ref) {
  return ThawaniActionNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Sync Provider ──────────────────────────────
class ThawaniSyncNotifier extends StateNotifier<ThawaniSyncState> {
  ThawaniSyncNotifier(this._repository) : super(const ThawaniSyncInitial());
  final ThawaniRepository _repository;

  Future<void> testConnection() async {
    state = const ThawaniSyncLoading('test-connection');
    try {
      final result = await _repository.testConnection();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = ThawaniSyncSuccess('Connection successful', data: data);
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  Future<void> pushProducts() async {
    state = const ThawaniSyncLoading('push-products');
    try {
      await _repository.pushProducts();
      state = const ThawaniSyncSuccess('Products pushed to Thawani');
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  Future<void> pullProducts() async {
    state = const ThawaniSyncLoading('pull-products');
    try {
      await _repository.pullProducts();
      state = const ThawaniSyncSuccess('Products pulled from Thawani');
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  Future<void> pushCategories() async {
    state = const ThawaniSyncLoading('push-categories');
    try {
      await _repository.pushCategories();
      state = const ThawaniSyncSuccess('Categories pushed to Thawani');
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  Future<void> pullCategories() async {
    state = const ThawaniSyncLoading('pull-categories');
    try {
      await _repository.pullCategories();
      state = const ThawaniSyncSuccess('Categories pulled from Thawani');
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  Future<void> processQueue() async {
    state = const ThawaniSyncLoading('process-queue');
    try {
      final result = await _repository.processQueue();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = ThawaniSyncSuccess('Queue processed', data: data);
    } catch (e) {
      state = ThawaniSyncError(e.toString());
    }
  }

  void reset() => state = const ThawaniSyncInitial();
}

final thawaniSyncProvider = StateNotifierProvider<ThawaniSyncNotifier, ThawaniSyncState>((ref) {
  return ThawaniSyncNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Category Mappings Provider ─────────────────
class ThawaniCategoryMappingsNotifier extends StateNotifier<ThawaniCategoryMappingsState> {
  ThawaniCategoryMappingsNotifier(this._repository) : super(const ThawaniCategoryMappingsInitial());
  final ThawaniRepository _repository;

  Future<void> load() async {
    if (state is! ThawaniCategoryMappingsLoaded) state = const ThawaniCategoryMappingsLoading();
    try {
      final result = await _repository.getCategoryMappings();
      final data = result['data'];
      final mappings = data is List ? data : [];
      state = ThawaniCategoryMappingsLoaded(mappings);
    } catch (e) {
      if (state is! ThawaniCategoryMappingsLoaded) state = ThawaniCategoryMappingsError(e.toString());
    }
  }
}

final thawaniCategoryMappingsProvider = StateNotifierProvider<ThawaniCategoryMappingsNotifier, ThawaniCategoryMappingsState>((
  ref,
) {
  return ThawaniCategoryMappingsNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Sync Logs Provider ─────────────────────────
class ThawaniSyncLogsNotifier extends StateNotifier<ThawaniSyncLogsState> {
  ThawaniSyncLogsNotifier(this._repository) : super(const ThawaniSyncLogsInitial());
  final ThawaniRepository _repository;

  Future<void> load({String? entityType, String? status, int? perPage}) async {
    if (state is! ThawaniSyncLogsLoaded) state = const ThawaniSyncLogsLoading();
    try {
      final result = await _repository.getSyncLogs(entityType: entityType, status: status, perPage: perPage);
      final data = result['data'];
      List<dynamic> logs;
      Map<String, dynamic>? pagination;
      if (data is Map<String, dynamic>) {
        logs = data['data'] as List? ?? [];
        pagination = {'current_page': data['current_page'], 'last_page': data['last_page'], 'total': data['total']};
      } else if (data is List) {
        logs = data;
      } else {
        logs = [];
      }
      state = ThawaniSyncLogsLoaded(logs, pagination: pagination);
    } catch (e) {
      if (state is! ThawaniSyncLogsLoaded) state = ThawaniSyncLogsError(e.toString());
    }
  }
}

final thawaniSyncLogsProvider = StateNotifierProvider<ThawaniSyncLogsNotifier, ThawaniSyncLogsState>((ref) {
  return ThawaniSyncLogsNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Queue Stats Provider ───────────────────────
class ThawaniQueueStatsNotifier extends StateNotifier<ThawaniQueueStatsState> {
  ThawaniQueueStatsNotifier(this._repository) : super(const ThawaniQueueStatsInitial());
  final ThawaniRepository _repository;

  Future<void> load() async {
    if (state is! ThawaniQueueStatsLoaded) state = const ThawaniQueueStatsLoading();
    try {
      final result = await _repository.getQueueStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = ThawaniQueueStatsLoaded(
        pending: data['pending'] as int? ?? 0,
        processing: data['processing'] as int? ?? 0,
        completed: data['completed'] as int? ?? 0,
        failed: data['failed'] as int? ?? 0,
      );
    } catch (e) {
      if (state is! ThawaniQueueStatsLoaded) state = ThawaniQueueStatsError(e.toString());
    }
  }
}

final thawaniQueueStatsProvider = StateNotifierProvider<ThawaniQueueStatsNotifier, ThawaniQueueStatsState>((ref) {
  return ThawaniQueueStatsNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Orders Provider ─────────────────────────────
class ThawaniOrdersNotifier extends StateNotifier<ThawaniOrdersState> {
  ThawaniOrdersNotifier(this._repository) : super(const ThawaniOrdersInitial());
  final ThawaniRepository _repository;

  Future<void> load({String? status, int perPage = 20}) async {
    if (state is! ThawaniOrdersLoaded) state = const ThawaniOrdersLoading();
    try {
      final result = await _repository.getOrders(status: status, perPage: perPage);
      final data = result['data'];
      List<dynamic> orders;
      Map<String, dynamic>? pagination;
      if (data is Map<String, dynamic>) {
        orders = data['data'] as List? ?? [];
        pagination = {'current_page': data['current_page'], 'last_page': data['last_page'], 'total': data['total']};
      } else if (data is List) {
        orders = data;
      } else {
        orders = [];
      }
      state = ThawaniOrdersLoaded(orders, pagination: pagination, statusFilter: status);
    } catch (e) {
      if (state is! ThawaniOrdersLoaded) state = ThawaniOrdersError(e.toString());
    }
  }

  Future<void> refresh({String? status}) async {
    state = const ThawaniOrdersLoading();
    await load(status: status);
  }
}

final thawaniOrdersProvider = StateNotifierProvider<ThawaniOrdersNotifier, ThawaniOrdersState>((ref) {
  return ThawaniOrdersNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Order Action Provider ───────────────────────
class ThawaniOrderActionNotifier extends StateNotifier<ThawaniOrderActionState> {
  ThawaniOrderActionNotifier(this._repository) : super(const ThawaniOrderActionInitial());
  final ThawaniRepository _repository;

  void reset() => state = const ThawaniOrderActionInitial();

  Future<bool> acceptOrder(String orderId) async {
    state = ThawaniOrderActionLoading(operation: 'accept', orderId: orderId);
    try {
      final result = await _repository.acceptOrder(orderId);
      final msg = result['message'] as String? ?? 'Order accepted';
      final order = result['data'] as Map<String, dynamic>?;
      state = ThawaniOrderActionSuccess(msg, updatedOrder: order);
      return true;
    } catch (e) {
      state = ThawaniOrderActionError(e.toString());
      return false;
    }
  }

  Future<bool> rejectOrder(String orderId, String reason) async {
    state = ThawaniOrderActionLoading(operation: 'reject', orderId: orderId);
    try {
      final result = await _repository.rejectOrder(orderId, reason);
      final msg = result['message'] as String? ?? 'Order rejected';
      final order = result['data'] as Map<String, dynamic>?;
      state = ThawaniOrderActionSuccess(msg, updatedOrder: order);
      return true;
    } catch (e) {
      state = ThawaniOrderActionError(e.toString());
      return false;
    }
  }

  Future<bool> updateStatus(String orderId, String status) async {
    state = ThawaniOrderActionLoading(operation: 'status', orderId: orderId);
    try {
      final result = await _repository.updateOrderStatus(orderId, status);
      final msg = result['message'] as String? ?? 'Status updated';
      final order = result['data'] as Map<String, dynamic>?;
      state = ThawaniOrderActionSuccess(msg, updatedOrder: order);
      return true;
    } catch (e) {
      state = ThawaniOrderActionError(e.toString());
      return false;
    }
  }
}

final thawaniOrderActionProvider = StateNotifierProvider<ThawaniOrderActionNotifier, ThawaniOrderActionState>((ref) {
  return ThawaniOrderActionNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Settlements Provider ────────────────────────
class ThawaniSettlementsNotifier extends StateNotifier<ThawaniSettlementsState> {
  ThawaniSettlementsNotifier(this._repository) : super(const ThawaniSettlementsInitial());
  final ThawaniRepository _repository;

  Future<void> load({int perPage = 20}) async {
    if (state is! ThawaniSettlementsLoaded) state = const ThawaniSettlementsLoading();
    try {
      final result = await _repository.getSettlements(perPage: perPage);
      final data = result['data'];
      List<dynamic> settlements;
      Map<String, dynamic>? pagination;
      if (data is Map<String, dynamic>) {
        settlements = data['data'] as List? ?? [];
        pagination = {'current_page': data['current_page'], 'last_page': data['last_page'], 'total': data['total']};
      } else if (data is List) {
        settlements = data;
      } else {
        settlements = [];
      }
      state = ThawaniSettlementsLoaded(settlements, pagination: pagination);
    } catch (e) {
      if (state is! ThawaniSettlementsLoaded) state = ThawaniSettlementsError(e.toString());
    }
  }
}

final thawaniSettlementsProvider = StateNotifierProvider<ThawaniSettlementsNotifier, ThawaniSettlementsState>((ref) {
  return ThawaniSettlementsNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Menu (Online Products) Provider ─────────────
class ThawaniMenuNotifier extends StateNotifier<ThawaniMenuState> {
  ThawaniMenuNotifier(this._repository) : super(const ThawaniMenuInitial());
  final ThawaniRepository _repository;

  Future<void> load({String? search, bool? isPublished, int perPage = 20}) async {
    if (state is! ThawaniMenuLoaded) state = const ThawaniMenuLoading();
    try {
      final result = await _repository.getProducts(search: search, isPublished: isPublished, perPage: perPage);
      final data = result['data'];
      List<dynamic> products;
      Map<String, dynamic>? pagination;
      if (data is Map<String, dynamic>) {
        products = data['data'] as List? ?? [];
        pagination = {'current_page': data['current_page'], 'last_page': data['last_page'], 'total': data['total']};
      } else if (data is List) {
        products = data;
      } else {
        products = [];
      }
      String? filter;
      if (isPublished == true) filter = 'published';
      if (isPublished == false) filter = 'unpublished';
      state = ThawaniMenuLoaded(products, pagination: pagination, filter: filter);
    } catch (e) {
      if (state is! ThawaniMenuLoaded) state = ThawaniMenuError(e.toString());
    }
  }

  Future<void> refresh({bool? isPublished}) async {
    state = const ThawaniMenuLoading();
    await load(isPublished: isPublished);
  }
}

final thawaniMenuProvider = StateNotifierProvider<ThawaniMenuNotifier, ThawaniMenuState>((ref) {
  return ThawaniMenuNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Menu Action Provider ────────────────────────
class ThawaniMenuActionNotifier extends StateNotifier<ThawaniMenuActionState> {
  ThawaniMenuActionNotifier(this._repository) : super(const ThawaniMenuActionInitial());
  final ThawaniRepository _repository;

  void reset() => state = const ThawaniMenuActionInitial();

  Future<bool> publishProduct(String id, {required bool isPublished, double? onlinePrice, int? displayOrder}) async {
    state = const ThawaniMenuActionLoading();
    try {
      await _repository.publishProduct(id, isPublished: isPublished, onlinePrice: onlinePrice, displayOrder: displayOrder);
      state = ThawaniMenuActionSuccess(isPublished ? 'Product published' : 'Product unpublished');
      return true;
    } catch (e) {
      state = ThawaniMenuActionError(e.toString());
      return false;
    }
  }

  Future<bool> bulkPublish(List<String> productIds, bool isPublished) async {
    state = const ThawaniMenuActionLoading();
    try {
      await _repository.bulkPublishProducts(productIds, isPublished);
      state = ThawaniMenuActionSuccess(isPublished ? 'Products published' : 'Products unpublished');
      return true;
    } catch (e) {
      state = ThawaniMenuActionError(e.toString());
      return false;
    }
  }

  Future<bool> syncInventory() async {
    state = const ThawaniMenuActionLoading();
    try {
      await _repository.syncInventory();
      state = const ThawaniMenuActionSuccess('Inventory synced');
      return true;
    } catch (e) {
      state = ThawaniMenuActionError(e.toString());
      return false;
    }
  }
}

final thawaniMenuActionProvider = StateNotifierProvider<ThawaniMenuActionNotifier, ThawaniMenuActionState>((ref) {
  return ThawaniMenuActionNotifier(ref.watch(thawaniRepositoryProvider));
});

// ─── Thawani Store Availability Provider ─────────────────
class ThawaniStoreAvailabilityNotifier extends StateNotifier<ThawaniStoreAvailabilityState> {
  ThawaniStoreAvailabilityNotifier(this._repository) : super(const ThawaniStoreAvailabilityInitial());
  final ThawaniRepository _repository;

  void initFromConfig(Map<String, dynamic> config) {
    state = ThawaniStoreAvailabilityLoaded(
      isOpen: config['is_store_open'] as bool? ?? true,
      closedReason: config['store_closed_reason'] as String?,
    );
  }

  Future<bool> updateAvailability(bool isOpen, {String? closedReason}) async {
    final prev = state;
    state = const ThawaniStoreAvailabilityLoading();
    try {
      await _repository.updateStoreAvailability(isOpen, closedReason: closedReason);
      state = ThawaniStoreAvailabilityLoaded(isOpen: isOpen, closedReason: isOpen ? null : closedReason);
      return true;
    } catch (e) {
      state = prev;
      return false;
    }
  }
}

final thawaniStoreAvailabilityProvider =
    StateNotifierProvider<ThawaniStoreAvailabilityNotifier, ThawaniStoreAvailabilityState>((ref) {
  return ThawaniStoreAvailabilityNotifier(ref.watch(thawaniRepositoryProvider));
});
