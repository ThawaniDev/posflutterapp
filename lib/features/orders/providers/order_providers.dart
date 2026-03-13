import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/orders/providers/order_state.dart';
import 'package:thawani_pos/features/orders/repositories/order_repository.dart';

// ─── Orders Provider ────────────────────────────────────────────

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(ref.watch(orderRepositoryProvider));
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository _repo;

  OrdersNotifier(this._repo) : super(const OrdersInitial());

  Future<void> load({int page = 1, String? status, String? search}) async {
    state = const OrdersLoading();
    try {
      final result = await _repo.listOrders(page: page, status: status, search: search);
      state = OrdersLoaded(
        orders: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        statusFilter: status,
        searchQuery: search,
      );
    } on DioException catch (e) {
      state = OrdersError(message: _extractError(e));
    } catch (e) {
      state = OrdersError(message: e.toString());
    }
  }

  Future<void> updateStatus(String orderId, String status) async {
    try {
      await _repo.updateOrderStatus(orderId, status);
      await load();
    } on DioException catch (e) {
      state = OrdersError(message: _extractError(e));
    }
  }

  Future<void> voidOrder(String orderId) async {
    try {
      await _repo.voidOrder(orderId);
      await load();
    } on DioException catch (e) {
      state = OrdersError(message: _extractError(e));
    }
  }
}

// ─── Returns Provider ───────────────────────────────────────────

final returnsProvider = StateNotifierProvider<ReturnsNotifier, ReturnsState>((ref) {
  return ReturnsNotifier(ref.watch(orderRepositoryProvider));
});

class ReturnsNotifier extends StateNotifier<ReturnsState> {
  final OrderRepository _repo;

  ReturnsNotifier(this._repo) : super(const ReturnsInitial());

  Future<void> load({int page = 1}) async {
    state = const ReturnsLoading();
    try {
      final result = await _repo.listReturns(page: page);
      state = ReturnsLoaded(
        returns: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
      );
    } on DioException catch (e) {
      state = ReturnsError(message: _extractError(e));
    } catch (e) {
      state = ReturnsError(message: e.toString());
    }
  }

  Future<void> createReturn(Map<String, dynamic> data) async {
    try {
      await _repo.createReturn(data);
      await load();
    } on DioException catch (e) {
      state = ReturnsError(message: _extractError(e));
    }
  }
}

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
