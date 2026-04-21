import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';

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

  const CustomersLoaded({
    required this.customers,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.searchQuery,
    this.groupId,
  });
  final List<Customer> customers;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? searchQuery;
  final String? groupId;

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
  const CustomersError({required this.message});
  final String message;
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
  const CustomerGroupsLoaded({required this.groups});
  final List<CustomerGroup> groups;

  CustomerGroupsLoaded copyWith({List<CustomerGroup>? groups}) => CustomerGroupsLoaded(groups: groups ?? this.groups);
}

class CustomerGroupsError extends CustomerGroupsState {
  const CustomerGroupsError({required this.message});
  final String message;
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
  const CustomerDetailLoaded({required this.customer});
  final Customer customer;
}

class CustomerDetailSaving extends CustomerDetailState {
  const CustomerDetailSaving();
}

class CustomerDetailSaved extends CustomerDetailState {
  const CustomerDetailSaved({required this.customer});
  final Customer customer;
}

class CustomerDetailError extends CustomerDetailState {
  const CustomerDetailError({required this.message});
  final String message;
}
