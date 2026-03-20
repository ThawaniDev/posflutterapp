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

  const DeliveryStatsLoaded({
    required this.totalPlatforms,
    required this.activePlatforms,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
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
