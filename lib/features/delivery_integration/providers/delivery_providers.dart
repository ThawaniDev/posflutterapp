import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/delivery_integration/repositories/delivery_repository.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

// ─── Delivery Stats Provider ────────────────────────────
class DeliveryStatsNotifier extends StateNotifier<DeliveryStatsState> {
  final DeliveryRepository _repository;
  DeliveryStatsNotifier(this._repository) : super(const DeliveryStatsInitial());

  Future<void> load() async {
    if (state is! DeliveryStatsLoaded) state = const DeliveryStatsLoading();
    try {
      final result = await _repository.getStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = DeliveryStatsLoaded(
        totalPlatforms: data['total_platforms'] as int? ?? 0,
        activePlatforms: data['active_platforms'] as int? ?? 0,
        totalOrders: data['total_orders'] as int? ?? 0,
        pendingOrders: data['pending_orders'] as int? ?? 0,
        completedOrders: data['completed_orders'] as int? ?? 0,
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
}

final deliveryConfigsProvider = StateNotifierProvider<DeliveryConfigsNotifier, DeliveryConfigsState>((ref) {
  return DeliveryConfigsNotifier(ref.watch(deliveryRepositoryProvider));
});

// ─── Delivery Orders Provider ───────────────────────────
class DeliveryOrdersNotifier extends StateNotifier<DeliveryOrdersState> {
  final DeliveryRepository _repository;
  DeliveryOrdersNotifier(this._repository) : super(const DeliveryOrdersInitial());

  Future<void> load({String? platform, String? status}) async {
    if (state is! DeliveryOrdersLoaded) state = const DeliveryOrdersLoading();
    try {
      final result = await _repository.getOrders(platform: platform, status: status);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = data['data'] as List<dynamic>? ?? [];
      state = DeliveryOrdersLoaded(items.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! DeliveryOrdersLoaded) state = DeliveryOrdersError(e.toString());
    }
  }
}

final deliveryOrdersProvider = StateNotifierProvider<DeliveryOrdersNotifier, DeliveryOrdersState>((ref) {
  return DeliveryOrdersNotifier(ref.watch(deliveryRepositoryProvider));
});
