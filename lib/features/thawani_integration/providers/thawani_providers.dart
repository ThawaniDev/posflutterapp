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
        totalSettlements: data['total_settlements'] as int? ?? 0,
        pendingOrders: data['pending_orders'] as int? ?? 0,
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
