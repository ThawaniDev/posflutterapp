// ─── Thawani Stats State ────────────────────────────────
sealed class ThawaniStatsState {
  const ThawaniStatsState();
}

class ThawaniStatsInitial extends ThawaniStatsState {
  const ThawaniStatsInitial();
}

class ThawaniStatsLoading extends ThawaniStatsState {
  const ThawaniStatsLoading();
}

class ThawaniStatsLoaded extends ThawaniStatsState {
  final bool isConnected;
  final String? thawaniStoreId;
  final int totalOrders;
  final int totalProductsMapped;
  final int totalCategoriesMapped;
  final int totalSettlements;
  final int pendingOrders;
  final int pendingSyncItems;
  final int syncLogsToday;
  final int failedSyncsToday;

  const ThawaniStatsLoaded({
    required this.isConnected,
    this.thawaniStoreId,
    required this.totalOrders,
    required this.totalProductsMapped,
    required this.totalCategoriesMapped,
    required this.totalSettlements,
    required this.pendingOrders,
    required this.pendingSyncItems,
    required this.syncLogsToday,
    required this.failedSyncsToday,
  });
}

class ThawaniStatsError extends ThawaniStatsState {
  final String message;
  const ThawaniStatsError(this.message);
}

// ─── Thawani Config State ───────────────────────────────
sealed class ThawaniConfigState {
  const ThawaniConfigState();
}

class ThawaniConfigInitial extends ThawaniConfigState {
  const ThawaniConfigInitial();
}

class ThawaniConfigLoading extends ThawaniConfigState {
  const ThawaniConfigLoading();
}

class ThawaniConfigLoaded extends ThawaniConfigState {
  final Map<String, dynamic>? config;
  const ThawaniConfigLoaded(this.config);
}

class ThawaniConfigError extends ThawaniConfigState {
  final String message;
  const ThawaniConfigError(this.message);
}

// ─── Thawani Action State ───────────────────────────────
sealed class ThawaniActionState {
  const ThawaniActionState();
}

class ThawaniActionInitial extends ThawaniActionState {
  const ThawaniActionInitial();
}

class ThawaniActionLoading extends ThawaniActionState {
  const ThawaniActionLoading();
}

class ThawaniActionSuccess extends ThawaniActionState {
  final String message;
  const ThawaniActionSuccess(this.message);
}

class ThawaniActionError extends ThawaniActionState {
  final String message;
  const ThawaniActionError(this.message);
}

// ─── Thawani Sync State ─────────────────────────────────
sealed class ThawaniSyncState {
  const ThawaniSyncState();
}

class ThawaniSyncInitial extends ThawaniSyncState {
  const ThawaniSyncInitial();
}

class ThawaniSyncLoading extends ThawaniSyncState {
  final String operation;
  const ThawaniSyncLoading(this.operation);
}

class ThawaniSyncSuccess extends ThawaniSyncState {
  final String message;
  final Map<String, dynamic>? data;
  const ThawaniSyncSuccess(this.message, {this.data});
}

class ThawaniSyncError extends ThawaniSyncState {
  final String message;
  const ThawaniSyncError(this.message);
}

// ─── Thawani Category Mappings State ────────────────────
sealed class ThawaniCategoryMappingsState {
  const ThawaniCategoryMappingsState();
}

class ThawaniCategoryMappingsInitial extends ThawaniCategoryMappingsState {
  const ThawaniCategoryMappingsInitial();
}

class ThawaniCategoryMappingsLoading extends ThawaniCategoryMappingsState {
  const ThawaniCategoryMappingsLoading();
}

class ThawaniCategoryMappingsLoaded extends ThawaniCategoryMappingsState {
  final List<dynamic> mappings;
  const ThawaniCategoryMappingsLoaded(this.mappings);
}

class ThawaniCategoryMappingsError extends ThawaniCategoryMappingsState {
  final String message;
  const ThawaniCategoryMappingsError(this.message);
}

// ─── Thawani Sync Logs State ────────────────────────────
sealed class ThawaniSyncLogsState {
  const ThawaniSyncLogsState();
}

class ThawaniSyncLogsInitial extends ThawaniSyncLogsState {
  const ThawaniSyncLogsInitial();
}

class ThawaniSyncLogsLoading extends ThawaniSyncLogsState {
  const ThawaniSyncLogsLoading();
}

class ThawaniSyncLogsLoaded extends ThawaniSyncLogsState {
  final List<dynamic> logs;
  final Map<String, dynamic>? pagination;
  const ThawaniSyncLogsLoaded(this.logs, {this.pagination});
}

class ThawaniSyncLogsError extends ThawaniSyncLogsState {
  final String message;
  const ThawaniSyncLogsError(this.message);
}

// ─── Thawani Queue Stats State ──────────────────────────
sealed class ThawaniQueueStatsState {
  const ThawaniQueueStatsState();
}

class ThawaniQueueStatsInitial extends ThawaniQueueStatsState {
  const ThawaniQueueStatsInitial();
}

class ThawaniQueueStatsLoading extends ThawaniQueueStatsState {
  const ThawaniQueueStatsLoading();
}

class ThawaniQueueStatsLoaded extends ThawaniQueueStatsState {
  final int pending;
  final int processing;
  final int completed;
  final int failed;

  const ThawaniQueueStatsLoaded({required this.pending, required this.processing, required this.completed, required this.failed});
}

class ThawaniQueueStatsError extends ThawaniQueueStatsState {
  final String message;
  const ThawaniQueueStatsError(this.message);
}
