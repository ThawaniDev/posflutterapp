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
  final int totalSettlements;
  final int pendingOrders;

  const ThawaniStatsLoaded({
    required this.isConnected,
    this.thawaniStoreId,
    required this.totalOrders,
    required this.totalProductsMapped,
    required this.totalSettlements,
    required this.pendingOrders,
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
