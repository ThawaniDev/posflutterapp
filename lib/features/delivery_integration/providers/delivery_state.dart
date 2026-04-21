// ─── Delivery Stats State ───────────────────────────────
sealed class DeliveryStatsState {
  const DeliveryStatsState();
}

class DeliveryStatsInitial extends DeliveryStatsState {
  const DeliveryStatsInitial();
}

class DeliveryStatsLoading extends DeliveryStatsState {
  const DeliveryStatsLoading();
}

class DeliveryStatsLoaded extends DeliveryStatsState {

  const DeliveryStatsLoaded({
    required this.totalPlatforms,
    required this.activePlatforms,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    this.todayOrders = 0,
    this.todayRevenue = 0.0,
    this.activeOrders = 0,
    this.rejectedOrders = 0,
    this.platformBreakdown = const [],
  });
  final int totalPlatforms;
  final int activePlatforms;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int todayOrders;
  final double todayRevenue;
  final int activeOrders;
  final int rejectedOrders;
  final List<Map<String, dynamic>> platformBreakdown;
}

class DeliveryStatsError extends DeliveryStatsState {
  const DeliveryStatsError(this.message);
  final String message;
}

// ─── Delivery Configs State ─────────────────────────────
sealed class DeliveryConfigsState {
  const DeliveryConfigsState();
}

class DeliveryConfigsInitial extends DeliveryConfigsState {
  const DeliveryConfigsInitial();
}

class DeliveryConfigsLoading extends DeliveryConfigsState {
  const DeliveryConfigsLoading();
}

class DeliveryConfigsLoaded extends DeliveryConfigsState {
  const DeliveryConfigsLoaded(this.configs);
  final List<Map<String, dynamic>> configs;
}

class DeliveryConfigsError extends DeliveryConfigsState {
  const DeliveryConfigsError(this.message);
  final String message;
}

// ─── Delivery Orders State ──────────────────────────────
sealed class DeliveryOrdersState {
  const DeliveryOrdersState();
}

class DeliveryOrdersInitial extends DeliveryOrdersState {
  const DeliveryOrdersInitial();
}

class DeliveryOrdersLoading extends DeliveryOrdersState {
  const DeliveryOrdersLoading();
}

class DeliveryOrdersLoaded extends DeliveryOrdersState {
  const DeliveryOrdersLoaded(this.orders, {this.currentPage = 1, this.lastPage = 1, this.total = 0});
  final List<Map<String, dynamic>> orders;
  final int currentPage;
  final int lastPage;
  final int total;
}

class DeliveryOrdersError extends DeliveryOrdersState {
  const DeliveryOrdersError(this.message);
  final String message;
}

// ─── Delivery Order Detail State ────────────────────────
sealed class DeliveryOrderDetailState {
  const DeliveryOrderDetailState();
}

class DeliveryOrderDetailInitial extends DeliveryOrderDetailState {
  const DeliveryOrderDetailInitial();
}

class DeliveryOrderDetailLoading extends DeliveryOrderDetailState {
  const DeliveryOrderDetailLoading();
}

class DeliveryOrderDetailLoaded extends DeliveryOrderDetailState {
  const DeliveryOrderDetailLoaded(this.order);
  final Map<String, dynamic> order;
}

class DeliveryOrderDetailError extends DeliveryOrderDetailState {
  const DeliveryOrderDetailError(this.message);
  final String message;
}

// ─── Delivery Platforms State ───────────────────────────
sealed class DeliveryPlatformsState {
  const DeliveryPlatformsState();
}

class DeliveryPlatformsInitial extends DeliveryPlatformsState {
  const DeliveryPlatformsInitial();
}

class DeliveryPlatformsLoading extends DeliveryPlatformsState {
  const DeliveryPlatformsLoading();
}

class DeliveryPlatformsLoaded extends DeliveryPlatformsState {
  const DeliveryPlatformsLoaded(this.platforms);
  final List<Map<String, dynamic>> platforms;
}

class DeliveryPlatformsError extends DeliveryPlatformsState {
  const DeliveryPlatformsError(this.message);
  final String message;
}

// ─── Connection Test State ──────────────────────────────
sealed class DeliveryConnectionTestState {
  const DeliveryConnectionTestState();
}

class DeliveryConnectionTestIdle extends DeliveryConnectionTestState {
  const DeliveryConnectionTestIdle();
}

class DeliveryConnectionTestLoading extends DeliveryConnectionTestState {
  const DeliveryConnectionTestLoading();
}

class DeliveryConnectionTestSuccess extends DeliveryConnectionTestState {
  const DeliveryConnectionTestSuccess(this.message);
  final String message;
}

class DeliveryConnectionTestFailure extends DeliveryConnectionTestState {
  const DeliveryConnectionTestFailure(this.message);
  final String message;
}

// ─── Menu Sync State ────────────────────────────────────
sealed class DeliveryMenuSyncState {
  const DeliveryMenuSyncState();
}

class DeliveryMenuSyncIdle extends DeliveryMenuSyncState {
  const DeliveryMenuSyncIdle();
}

class DeliveryMenuSyncLoading extends DeliveryMenuSyncState {
  const DeliveryMenuSyncLoading();
}

class DeliveryMenuSyncSuccess extends DeliveryMenuSyncState {
  const DeliveryMenuSyncSuccess(this.message);
  final String message;
}

class DeliveryMenuSyncError extends DeliveryMenuSyncState {
  const DeliveryMenuSyncError(this.message);
  final String message;
}

// ─── Webhook Logs State ─────────────────────────────────
sealed class DeliveryWebhookLogsState {
  const DeliveryWebhookLogsState();
}

class DeliveryWebhookLogsInitial extends DeliveryWebhookLogsState {
  const DeliveryWebhookLogsInitial();
}

class DeliveryWebhookLogsLoading extends DeliveryWebhookLogsState {
  const DeliveryWebhookLogsLoading();
}

class DeliveryWebhookLogsLoaded extends DeliveryWebhookLogsState {
  const DeliveryWebhookLogsLoaded(this.logs, {this.currentPage = 1, this.lastPage = 1, this.total = 0});
  final List<Map<String, dynamic>> logs;
  final int currentPage;
  final int lastPage;
  final int total;
}

class DeliveryWebhookLogsError extends DeliveryWebhookLogsState {
  const DeliveryWebhookLogsError(this.message);
  final String message;
}

// ─── Status Push Logs State ─────────────────────────────
sealed class DeliveryStatusPushLogsState {
  const DeliveryStatusPushLogsState();
}

class DeliveryStatusPushLogsInitial extends DeliveryStatusPushLogsState {
  const DeliveryStatusPushLogsInitial();
}

class DeliveryStatusPushLogsLoading extends DeliveryStatusPushLogsState {
  const DeliveryStatusPushLogsLoading();
}

class DeliveryStatusPushLogsLoaded extends DeliveryStatusPushLogsState {
  const DeliveryStatusPushLogsLoaded(this.logs, {this.currentPage = 1, this.lastPage = 1, this.total = 0});
  final List<Map<String, dynamic>> logs;
  final int currentPage;
  final int lastPage;
  final int total;
}

class DeliveryStatusPushLogsError extends DeliveryStatusPushLogsState {
  const DeliveryStatusPushLogsError(this.message);
  final String message;
}
