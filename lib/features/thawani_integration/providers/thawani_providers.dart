import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/thawani_integration/repositories/thawani_repository.dart';
import 'package:thawani_pos/features/thawani_integration/providers/thawani_state.dart';

// ─── Thawani Stats Provider ─────────────────────────────
class ThawaniStatsNotifier extends StateNotifier<ThawaniStatsState> {
  final ThawaniRepository _repository;
  ThawaniStatsNotifier(this._repository) : super(const ThawaniStatsInitial());

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
  final ThawaniRepository _repository;
  ThawaniConfigNotifier(this._repository) : super(const ThawaniConfigInitial());

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
  final ThawaniRepository _repository;
  ThawaniActionNotifier(this._repository) : super(const ThawaniActionInitial());

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
  final ThawaniRepository _repository;
  ThawaniSyncNotifier(this._repository) : super(const ThawaniSyncInitial());

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
  final ThawaniRepository _repository;
  ThawaniCategoryMappingsNotifier(this._repository) : super(const ThawaniCategoryMappingsInitial());

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
  final ThawaniRepository _repository;
  ThawaniSyncLogsNotifier(this._repository) : super(const ThawaniSyncLogsInitial());

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
  final ThawaniRepository _repository;
  ThawaniQueueStatsNotifier(this._repository) : super(const ThawaniQueueStatsInitial());

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
