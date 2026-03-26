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
}

class DeliveryStatsError extends DeliveryStatsState {
  final String message;
  const DeliveryStatsError(this.message);
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
  final List<Map<String, dynamic>> configs;
  const DeliveryConfigsLoaded(this.configs);
}

class DeliveryConfigsError extends DeliveryConfigsState {
  final String message;
  const DeliveryConfigsError(this.message);
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
  final List<Map<String, dynamic>> orders;
  const DeliveryOrdersLoaded(this.orders);
}

class DeliveryOrdersError extends DeliveryOrdersState {
  final String message;
  const DeliveryOrdersError(this.message);
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
  final Map<String, dynamic> order;
  const DeliveryOrderDetailLoaded(this.order);
}

class DeliveryOrderDetailError extends DeliveryOrderDetailState {
  final String message;
  const DeliveryOrderDetailError(this.message);
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
  final List<Map<String, dynamic>> platforms;
  const DeliveryPlatformsLoaded(this.platforms);
}

class DeliveryPlatformsError extends DeliveryPlatformsState {
  final String message;
  const DeliveryPlatformsError(this.message);
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
  final String message;
  const DeliveryConnectionTestSuccess(this.message);
}

class DeliveryConnectionTestFailure extends DeliveryConnectionTestState {
  final String message;
  const DeliveryConnectionTestFailure(this.message);
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
  final String message;
  const DeliveryMenuSyncSuccess(this.message);
}

class DeliveryMenuSyncError extends DeliveryMenuSyncState {
  final String message;
  const DeliveryMenuSyncError(this.message);
}
