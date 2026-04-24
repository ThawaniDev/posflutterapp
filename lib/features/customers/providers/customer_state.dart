import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/models/loyalty_config.dart';
import 'package:wameedpos/features/customers/models/loyalty_transaction.dart';
import 'package:wameedpos/features/customers/models/store_credit_transaction.dart';

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
    this.hasLoyalty,
    this.lastVisitFrom,
    this.lastVisitTo,
  });
  final List<Customer> customers;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? searchQuery;
  final String? groupId;
  final bool? hasLoyalty;
  final DateTime? lastVisitFrom;
  final DateTime? lastVisitTo;

  bool get hasMore => currentPage < lastPage;

  CustomersLoaded copyWith({
    List<Customer>? customers,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? searchQuery,
    String? groupId,
    bool? hasLoyalty,
    DateTime? lastVisitFrom,
    DateTime? lastVisitTo,
  }) => CustomersLoaded(
    customers: customers ?? this.customers,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    perPage: perPage ?? this.perPage,
    searchQuery: searchQuery ?? this.searchQuery,
    groupId: groupId ?? this.groupId,
    hasLoyalty: hasLoyalty ?? this.hasLoyalty,
    lastVisitFrom: lastVisitFrom ?? this.lastVisitFrom,
    lastVisitTo: lastVisitTo ?? this.lastVisitTo,
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

// ─── Customer Search State ──────────────────────────────────────

sealed class CustomerSearchState {
  const CustomerSearchState();
}

class CustomerSearchIdle extends CustomerSearchState {
  const CustomerSearchIdle();
}

class CustomerSearchSearching extends CustomerSearchState {
  const CustomerSearchSearching();
}

class CustomerSearchResults extends CustomerSearchState {
  const CustomerSearchResults({required this.query, required this.results});
  final String query;
  final List<Customer> results;
}

class CustomerSearchError extends CustomerSearchState {
  const CustomerSearchError({required this.message});
  final String message;
}

// ─── Customer Sync State ────────────────────────────────────────

sealed class CustomerSyncState {
  const CustomerSyncState();
}

class CustomerSyncIdle extends CustomerSyncState {
  const CustomerSyncIdle({this.lastSyncAt, this.lastMerged});
  final DateTime? lastSyncAt;
  final int? lastMerged;
}

class CustomerSyncRunning extends CustomerSyncState {
  const CustomerSyncRunning();
}

class CustomerSyncFailure extends CustomerSyncState {
  const CustomerSyncFailure({required this.message});
  final String message;
}

// ─── Loyalty Config State ───────────────────────────────────────

sealed class LoyaltyConfigState {
  const LoyaltyConfigState();
}

class LoyaltyConfigInitial extends LoyaltyConfigState {
  const LoyaltyConfigInitial();
}

class LoyaltyConfigLoading extends LoyaltyConfigState {
  const LoyaltyConfigLoading();
}

class LoyaltyConfigLoaded extends LoyaltyConfigState {
  const LoyaltyConfigLoaded({required this.config});
  final LoyaltyConfig? config;
}

class LoyaltyConfigSaving extends LoyaltyConfigState {
  const LoyaltyConfigSaving();
}

class LoyaltyConfigError extends LoyaltyConfigState {
  const LoyaltyConfigError({required this.message});
  final String message;
}

// ─── Loyalty Log State (per customer) ───────────────────────────

sealed class LoyaltyLogState {
  const LoyaltyLogState();
}

class LoyaltyLogInitial extends LoyaltyLogState {
  const LoyaltyLogInitial();
}

class LoyaltyLogLoading extends LoyaltyLogState {
  const LoyaltyLogLoading();
}

class LoyaltyLogLoaded extends LoyaltyLogState {
  const LoyaltyLogLoaded({required this.transactions, required this.balance});
  final List<LoyaltyTransaction> transactions;
  final int balance;
}

class LoyaltyLogError extends LoyaltyLogState {
  const LoyaltyLogError({required this.message});
  final String message;
}

// ─── Store Credit Log State (per customer) ──────────────────────

sealed class StoreCreditLogState {
  const StoreCreditLogState();
}

class StoreCreditLogInitial extends StoreCreditLogState {
  const StoreCreditLogInitial();
}

class StoreCreditLogLoading extends StoreCreditLogState {
  const StoreCreditLogLoading();
}

class StoreCreditLogLoaded extends StoreCreditLogState {
  const StoreCreditLogLoaded({required this.transactions, required this.balance});
  final List<StoreCreditTransaction> transactions;
  final double balance;
}

class StoreCreditLogError extends StoreCreditLogState {
  const StoreCreditLogError({required this.message});
  final String message;
}

// ─── Customer Orders State (per customer) ───────────────────────

sealed class CustomerOrdersState {
  const CustomerOrdersState();
}

class CustomerOrdersInitial extends CustomerOrdersState {
  const CustomerOrdersInitial();
}

class CustomerOrdersLoading extends CustomerOrdersState {
  const CustomerOrdersLoading();
}

class CustomerOrdersLoaded extends CustomerOrdersState {
  const CustomerOrdersLoaded({
    required this.orders,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
  final List<Map<String, dynamic>> orders;
  final int total;
  final int currentPage;
  final int lastPage;
}

class CustomerOrdersError extends CustomerOrdersState {
  const CustomerOrdersError({required this.message});
  final String message;
}
