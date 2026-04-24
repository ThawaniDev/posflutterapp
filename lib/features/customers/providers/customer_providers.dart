import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';
import 'package:wameedpos/features/customers/services/customer_search_service.dart';
import 'package:wameedpos/features/customers/services/customer_sync_service.dart';
import 'package:wameedpos/features/customers/services/loyalty_service.dart';
import 'package:wameedpos/features/customers/services/store_credit_service.dart';

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

// ─── Customer Sync Provider ─────────────────────────────────────

final customerSyncProvider = StateNotifierProvider<CustomerSyncNotifier, CustomerSyncState>((ref) {
  return CustomerSyncNotifier(ref.watch(customerSyncServiceProvider));
});

class CustomerSyncNotifier extends StateNotifier<CustomerSyncState> {
  CustomerSyncNotifier(this._service) : super(const CustomerSyncIdle());
  final CustomerSyncService _service;

  Future<void> sync({bool force = false}) async {
    state = const CustomerSyncRunning();
    try {
      final merged = await _service.syncOnce(force: force);
      final last = await _service.lastSync();
      state = CustomerSyncIdle(lastSyncAt: last, lastMerged: merged);
    } on DioException catch (e) {
      state = CustomerSyncFailure(message: _extractError(e));
    } catch (e) {
      state = CustomerSyncFailure(message: e.toString());
    }
  }

  Future<void> refresh() async {
    final last = await _service.lastSync();
    state = CustomerSyncIdle(lastSyncAt: last);
  }
}

// ─── Customer Search Provider (POS lookup) ──────────────────────

final customerSearchProvider =
    StateNotifierProvider<CustomerSearchNotifier, CustomerSearchState>((ref) {
  return CustomerSearchNotifier(ref.watch(customerSearchServiceProvider), ref);
});

class CustomerSearchNotifier extends StateNotifier<CustomerSearchState> {
  CustomerSearchNotifier(this._service, this._ref) : super(const CustomerSearchIdle());
  final CustomerSearchService _service;
  final Ref _ref;

  Future<void> search(String organizationId, String query) async {
    if (query.trim().isEmpty) {
      state = const CustomerSearchIdle();
      return;
    }
    state = const CustomerSearchSearching();
    try {
      final results = await _service.search(organizationId, query);
      state = CustomerSearchResults(query: query, results: results);
    } catch (e) {
      state = CustomerSearchError(message: e.toString());
    }
    _ref;
  }

  void clear() => state = const CustomerSearchIdle();
}

// ─── Loyalty Config Provider ────────────────────────────────────

final loyaltyConfigProvider =
    StateNotifierProvider<LoyaltyConfigNotifier, LoyaltyConfigState>((ref) {
  return LoyaltyConfigNotifier(ref.watch(loyaltyServiceProvider));
});

class LoyaltyConfigNotifier extends StateNotifier<LoyaltyConfigState> {
  LoyaltyConfigNotifier(this._service) : super(const LoyaltyConfigInitial());
  final LoyaltyService _service;

  Future<void> load() async {
    state = const LoyaltyConfigLoading();
    try {
      final config = await _service.getConfig();
      state = LoyaltyConfigLoaded(config: config);
    } on DioException catch (e) {
      state = LoyaltyConfigError(message: _extractError(e));
    } catch (e) {
      state = LoyaltyConfigError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const LoyaltyConfigSaving();
    try {
      final config = await _service.saveConfig(data);
      state = LoyaltyConfigLoaded(config: config);
    } on DioException catch (e) {
      state = LoyaltyConfigError(message: _extractError(e));
    } catch (e) {
      state = LoyaltyConfigError(message: e.toString());
    }
  }
}

// ─── Loyalty Log Provider (family per customer) ─────────────────

final loyaltyLogProvider =
    StateNotifierProvider.family<LoyaltyLogNotifier, LoyaltyLogState, String>((ref, customerId) {
  return LoyaltyLogNotifier(ref.watch(loyaltyServiceProvider), customerId);
});

class LoyaltyLogNotifier extends StateNotifier<LoyaltyLogState> {
  LoyaltyLogNotifier(this._service, this._customerId) : super(const LoyaltyLogInitial());
  final LoyaltyService _service;
  final String _customerId;

  Future<void> load() async {
    state = const LoyaltyLogLoading();
    try {
      final txns = await _service.log(_customerId);
      // Compute current balance: sum of points (signed).
      final balance = txns.fold<int>(0, (sum, t) => sum + t.points);
      state = LoyaltyLogLoaded(transactions: txns, balance: balance);
    } on DioException catch (e) {
      state = LoyaltyLogError(message: _extractError(e));
    } catch (e) {
      state = LoyaltyLogError(message: e.toString());
    }
  }

  Future<void> adjust({required int points, required String type, String? notes, String? orderId}) async {
    try {
      await _service.adjust(_customerId, points: points, type: type, notes: notes, orderId: orderId);
      await load();
    } on DioException catch (e) {
      state = LoyaltyLogError(message: _extractError(e));
    }
  }

  Future<void> redeem({required int points, String? orderId}) async {
    try {
      await _service.redeem(_customerId, points: points, orderId: orderId);
      await load();
    } on DioException catch (e) {
      state = LoyaltyLogError(message: _extractError(e));
    }
  }
}

// ─── Store Credit Log Provider (family per customer) ────────────

final storeCreditLogProvider = StateNotifierProvider.family<StoreCreditLogNotifier,
    StoreCreditLogState, String>((ref, customerId) {
  return StoreCreditLogNotifier(ref.watch(storeCreditServiceProvider), customerId);
});

class StoreCreditLogNotifier extends StateNotifier<StoreCreditLogState> {
  StoreCreditLogNotifier(this._service, this._customerId) : super(const StoreCreditLogInitial());
  final StoreCreditService _service;
  final String _customerId;

  Future<void> load() async {
    state = const StoreCreditLogLoading();
    try {
      final txns = await _service.log(_customerId);
      final balance = txns.fold<double>(0, (sum, t) => sum + t.amount);
      state = StoreCreditLogLoaded(transactions: txns, balance: balance);
    } on DioException catch (e) {
      state = StoreCreditLogError(message: _extractError(e));
    } catch (e) {
      state = StoreCreditLogError(message: e.toString());
    }
  }

  Future<void> topUp({required double amount, String? notes}) async {
    try {
      await _service.topUp(_customerId, amount: amount, notes: notes);
      await load();
    } on DioException catch (e) {
      state = StoreCreditLogError(message: _extractError(e));
    }
  }

  Future<void> adjust({required double amount, String? notes}) async {
    try {
      await _service.adjust(_customerId, amount: amount, notes: notes);
      await load();
    } on DioException catch (e) {
      state = StoreCreditLogError(message: _extractError(e));
    }
  }
}

// ─── Customer Orders Provider (family per customer) ─────────────

final customerOrdersProvider = StateNotifierProvider.family<CustomerOrdersNotifier,
    CustomerOrdersState, String>((ref, customerId) {
  return CustomerOrdersNotifier(ref.watch(customerRepositoryProvider), customerId);
});

class CustomerOrdersNotifier extends StateNotifier<CustomerOrdersState> {
  CustomerOrdersNotifier(this._repo, this._customerId) : super(const CustomerOrdersInitial());
  final CustomerRepository _repo;
  final String _customerId;

  Future<void> load({int perPage = 20}) async {
    state = const CustomerOrdersLoading();
    try {
      final raw = await _repo.getCustomerOrders(_customerId, perPage: perPage);
      final list = (raw['data'] as List?)?.cast<Map<String, dynamic>>() ?? const [];
      state = CustomerOrdersLoaded(
        orders: list,
        total: (raw['total'] as num?)?.toInt() ?? list.length,
        currentPage: (raw['current_page'] as num?)?.toInt() ?? 1,
        lastPage: (raw['last_page'] as num?)?.toInt() ?? 1,
      );
    } on DioException catch (e) {
      state = CustomerOrdersError(message: _extractError(e));
    } catch (e) {
      state = CustomerOrdersError(message: e.toString());
    }
  }
}
