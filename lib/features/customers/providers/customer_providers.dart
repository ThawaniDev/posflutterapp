import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

// ─── Customers Provider ─────────────────────────────────────────

final customersProvider = StateNotifierProvider<CustomersNotifier, CustomersState>((ref) {
  return CustomersNotifier(ref.watch(customerRepositoryProvider));
});

class CustomersNotifier extends StateNotifier<CustomersState> {

  CustomersNotifier(this._repo) : super(const CustomersInitial());
  final CustomerRepository _repo;

  Future<void> load({int page = 1, String? search, String? groupId}) async {
    state = const CustomersLoading();
    try {
      final result = await _repo.listCustomers(page: page, search: search, groupId: groupId);
      state = CustomersLoaded(
        customers: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        searchQuery: search,
        groupId: groupId,
      );
    } on DioException catch (e) {
      state = CustomersError(message: _extractError(e));
    } catch (e) {
      state = CustomersError(message: e.toString());
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _repo.deleteCustomer(id);
      await load();
    } on DioException catch (e) {
      state = CustomersError(message: _extractError(e));
    }
  }
}

// ─── Customer Groups Provider ───────────────────────────────────

final customerGroupsProvider = StateNotifierProvider<CustomerGroupsNotifier, CustomerGroupsState>((ref) {
  return CustomerGroupsNotifier(ref.watch(customerRepositoryProvider));
});

class CustomerGroupsNotifier extends StateNotifier<CustomerGroupsState> {

  CustomerGroupsNotifier(this._repo) : super(const CustomerGroupsInitial());
  final CustomerRepository _repo;

  Future<void> load() async {
    state = const CustomerGroupsLoading();
    try {
      final groups = await _repo.listGroups();
      state = CustomerGroupsLoaded(groups: groups);
    } on DioException catch (e) {
      state = CustomerGroupsError(message: _extractError(e));
    } catch (e) {
      state = CustomerGroupsError(message: e.toString());
    }
  }

  Future<void> createGroup(Map<String, dynamic> data) async {
    try {
      await _repo.createGroup(data);
      await load();
    } on DioException catch (e) {
      state = CustomerGroupsError(message: _extractError(e));
    }
  }

  Future<void> deleteGroup(String id) async {
    try {
      await _repo.deleteGroup(id);
      await load();
    } on DioException catch (e) {
      state = CustomerGroupsError(message: _extractError(e));
    }
  }
}

// ─── Customer Detail Provider ───────────────────────────────────

final customerDetailProvider = StateNotifierProvider.family<CustomerDetailNotifier, CustomerDetailState, String?>((
  ref,
  customerId,
) {
  return CustomerDetailNotifier(ref.watch(customerRepositoryProvider), customerId);
});

class CustomerDetailNotifier extends StateNotifier<CustomerDetailState> {

  CustomerDetailNotifier(this._repo, this._customerId) : super(const CustomerDetailInitial());
  final CustomerRepository _repo;
  final String? _customerId;

  Future<void> load() async {
    if (_customerId == null) return;
    state = const CustomerDetailLoading();
    try {
      final customer = await _repo.getCustomer(_customerId);
      state = CustomerDetailLoaded(customer: customer);
    } on DioException catch (e) {
      state = CustomerDetailError(message: _extractError(e));
    } catch (e) {
      state = CustomerDetailError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const CustomerDetailSaving();
    try {
      final customer = _customerId != null ? await _repo.updateCustomer(_customerId, data) : await _repo.createCustomer(data);
      state = CustomerDetailSaved(customer: customer);
    } on DioException catch (e) {
      state = CustomerDetailError(message: _extractError(e));
    } catch (e) {
      state = CustomerDetailError(message: e.toString());
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
