import 'package:wameedpos/features/orders/models/order.dart';
import 'package:wameedpos/features/orders/models/sale_return.dart';

// ─── Orders State ───────────────────────────────────────────────

sealed class OrdersState {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

class OrdersLoaded extends OrdersState {

  const OrdersLoaded({
    required this.orders,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.statusFilter,
    this.searchQuery,
  });
  final List<Order> orders;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? statusFilter;
  final String? searchQuery;

  bool get hasMore => currentPage < lastPage;

  OrdersLoaded copyWith({
    List<Order>? orders,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? statusFilter,
    String? searchQuery,
  }) => OrdersLoaded(
    orders: orders ?? this.orders,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    statusFilter: statusFilter ?? this.statusFilter,
    searchQuery: searchQuery ?? this.searchQuery,
  );
}

class OrdersError extends OrdersState {
  const OrdersError({required this.message});
  final String message;
}

// ─── Returns State ──────────────────────────────────────────────

sealed class ReturnsState {
  const ReturnsState();
}

class ReturnsInitial extends ReturnsState {
  const ReturnsInitial();
}

class ReturnsLoading extends ReturnsState {
  const ReturnsLoading();
}

class ReturnsLoaded extends ReturnsState {

  const ReturnsLoaded({
    required this.returns,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });
  final List<SaleReturn> returns;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  bool get hasMore => currentPage < lastPage;

  ReturnsLoaded copyWith({List<SaleReturn>? returns, int? total, int? currentPage, int? lastPage, int? perPage}) => ReturnsLoaded(
    returns: returns ?? this.returns,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
  );
}

class ReturnsError extends ReturnsState {
  const ReturnsError({required this.message});
  final String message;
}
