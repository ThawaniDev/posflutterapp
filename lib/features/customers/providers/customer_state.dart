import 'package:thawani_pos/features/customers/models/customer.dart';
import 'package:thawani_pos/features/customers/models/customer_group.dart';

// ─── Customers State ────────────────────────────────────────────

sealed class CustomersState {
  const CustomersState();
}

class CustomersInitial extends CustomersState {
  const CustomersInitial();
}

class CustomersLoading extends CustomersState {
  const CustomersLoading();
}

class CustomersLoaded extends CustomersState {
  final List<Customer> customers;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? searchQuery;
  final String? groupId;

  const CustomersLoaded({
    required this.customers,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.searchQuery,
    this.groupId,
  });

  bool get hasMore => currentPage < lastPage;

  CustomersLoaded copyWith({
    List<Customer>? customers,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? searchQuery,
    String? groupId,
  }) => CustomersLoaded(
    customers: customers ?? this.customers,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    searchQuery: searchQuery ?? this.searchQuery,
    groupId: groupId ?? this.groupId,
  );
}

class CustomersError extends CustomersState {
  final String message;
  const CustomersError({required this.message});
}

// ─── Customer Groups State ──────────────────────────────────────

sealed class CustomerGroupsState {
  const CustomerGroupsState();
}

class CustomerGroupsInitial extends CustomerGroupsState {
  const CustomerGroupsInitial();
}

class CustomerGroupsLoading extends CustomerGroupsState {
  const CustomerGroupsLoading();
}

class CustomerGroupsLoaded extends CustomerGroupsState {
  final List<CustomerGroup> groups;
  const CustomerGroupsLoaded({required this.groups});

  CustomerGroupsLoaded copyWith({List<CustomerGroup>? groups}) => CustomerGroupsLoaded(groups: groups ?? this.groups);
}

class CustomerGroupsError extends CustomerGroupsState {
  final String message;
  const CustomerGroupsError({required this.message});
}

// ─── Customer Detail State ──────────────────────────────────────

sealed class CustomerDetailState {
  const CustomerDetailState();
}

class CustomerDetailInitial extends CustomerDetailState {
  const CustomerDetailInitial();
}

class CustomerDetailLoading extends CustomerDetailState {
  const CustomerDetailLoading();
}

class CustomerDetailLoaded extends CustomerDetailState {
  final Customer customer;
  const CustomerDetailLoaded({required this.customer});
}

class CustomerDetailSaving extends CustomerDetailState {
  const CustomerDetailSaving();
}

class CustomerDetailSaved extends CustomerDetailState {
  final Customer customer;
  const CustomerDetailSaved({required this.customer});
}

class CustomerDetailError extends CustomerDetailState {
  final String message;
  const CustomerDetailError({required this.message});
}
