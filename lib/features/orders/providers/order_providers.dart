import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/orders/providers/order_state.dart';
import 'package:wameedpos/features/orders/repositories/order_repository.dart';

// ─── Orders Provider ────────────────────────────────────────────

final ordersProvider = StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  return OrdersNotifier(ref.watch(orderRepositoryProvider));
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrderRepository _repo;

  OrdersNotifier(this._repo) : super(const OrdersInitial());

  String? _statusFilter;
  String? _searchQuery;

  Future<void> load({int page = 1, String? status, String? search}) async {
    _statusFilter = status ?? _statusFilter;
    _searchQuery = search ?? _searchQuery;
    state = const OrdersLoading();
    try {
      final result = await _repo.listOrders(page: page, status: _statusFilter, search: _searchQuery);
      state = OrdersLoaded(
        orders: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        statusFilter: _statusFilter,
        searchQuery: _searchQuery,
      );
    } on DioException catch (e) {
      state = OrdersError(message: _extractError(e));
    } catch (e) {
      state = OrdersError(message: e.toString());
    }
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    await load(status: status);
  }

  Future<void> search(String? query) async {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    await load(search: _searchQuery);
  }

  Future<void> nextPage() async {
    if (state is! OrdersLoaded) return;
    final loaded = state as OrdersLoaded;
    if (loaded.currentPage < loaded.lastPage) {
      await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is! OrdersLoaded) return;
    final loaded = state as OrdersLoaded;
    if (loaded.currentPage > 1) {
      await load(page: loaded.currentPage - 1);
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
