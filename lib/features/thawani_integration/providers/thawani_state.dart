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
}

class ThawaniStatsError extends ThawaniStatsState {
  const ThawaniStatsError(this.message);
  final String message;
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
  const ThawaniConfigLoaded(this.config);
  final Map<String, dynamic>? config;
}

class ThawaniConfigError extends ThawaniConfigState {
  const ThawaniConfigError(this.message);
  final String message;
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
  const ThawaniActionSuccess(this.message);
  final String message;
}

class ThawaniActionError extends ThawaniActionState {
  const ThawaniActionError(this.message);
  final String message;
}

// ─── Thawani Sync State ─────────────────────────────────
sealed class ThawaniSyncState {
  const ThawaniSyncState();
}

class ThawaniSyncInitial extends ThawaniSyncState {
  const ThawaniSyncInitial();
}

class ThawaniSyncLoading extends ThawaniSyncState {
  const ThawaniSyncLoading(this.operation);
  final String operation;
}

class ThawaniSyncSuccess extends ThawaniSyncState {
  const ThawaniSyncSuccess(this.message, {this.data});
  final String message;
  final Map<String, dynamic>? data;
}

class ThawaniSyncError extends ThawaniSyncState {
  const ThawaniSyncError(this.message);
  final String message;
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
  const ThawaniCategoryMappingsLoaded(this.mappings);
  final List<dynamic> mappings;
}

class ThawaniCategoryMappingsError extends ThawaniCategoryMappingsState {
  const ThawaniCategoryMappingsError(this.message);
  final String message;
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
  const ThawaniSyncLogsLoaded(this.logs, {this.pagination});
  final List<dynamic> logs;
  final Map<String, dynamic>? pagination;
}

class ThawaniSyncLogsError extends ThawaniSyncLogsState {
  const ThawaniSyncLogsError(this.message);
  final String message;
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

  const ThawaniQueueStatsLoaded({required this.pending, required this.processing, required this.completed, required this.failed});
  final int pending;
  final int processing;
  final int completed;
  final int failed;
}

class ThawaniQueueStatsError extends ThawaniQueueStatsState {
  const ThawaniQueueStatsError(this.message);
  final String message;
}
