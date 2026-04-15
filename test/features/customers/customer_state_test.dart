import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // CustomersState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CustomersState', () {
    test('CustomersInitial is default state', () {
      const state = CustomersInitial();
      expect(state, isA<CustomersState>());
    });

    test('CustomersLoading indicates loading', () {
      const state = CustomersLoading();
      expect(state, isA<CustomersState>());
    });

    test('CustomersLoaded holds customers and pagination', () {
      final customers = [
        Customer(id: 'c1', organizationId: 'o1', name: 'Alice', phone: '+96812345678', loyaltyPoints: 150),
        Customer(id: 'c2', organizationId: 'o1', name: 'Bob', phone: '+96887654321', email: 'bob@example.com'),
      ];

      final state = CustomersLoaded(customers: customers, total: 100, currentPage: 1, lastPage: 5, perPage: 20);

      expect(state, isA<CustomersState>());
      expect(state.customers, hasLength(2));
      expect(state.total, 100);
      expect(state.hasMore, true);
    });

    test('CustomersLoaded hasMore is false on last page', () {
      final state = CustomersLoaded(customers: [], total: 5, currentPage: 1, lastPage: 1, perPage: 20);
      expect(state.hasMore, false);
    });

    test('CustomersLoaded copyWith replaces fields', () {
      final state = CustomersLoaded(
        customers: [Customer(id: 'c1', organizationId: 'o1', name: 'Alice', phone: '+96812345678')],
        total: 10,
        currentPage: 1,
        lastPage: 2,
        perPage: 20,
      );

      final updated = state.copyWith(currentPage: 2, total: 50);
      expect(updated.currentPage, 2);
      expect(updated.total, 50);
      expect(updated.customers.first.name, 'Alice');
    });

    test('CustomersError holds message', () {
      const state = CustomersError(message: 'Fetch failed');
      expect(state, isA<CustomersState>());
      expect(state.message, 'Fetch failed');
    });

    test('sealed class exhaustive switch', () {
      CustomersState state = const CustomersLoading();
      final result = switch (state) {
        CustomersInitial() => 'initial',
        CustomersLoading() => 'loading',
        CustomersLoaded(:final customers) => 'loaded:${customers.length}',
        CustomersError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CustomerGroupsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CustomerGroupsState', () {
    test('all subtypes are CustomerGroupsState', () {
      expect(const CustomerGroupsInitial(), isA<CustomerGroupsState>());
      expect(const CustomerGroupsLoading(), isA<CustomerGroupsState>());
      expect(const CustomerGroupsError(message: 'e'), isA<CustomerGroupsState>());
    });

    test('CustomerGroupsLoaded holds groups', () {
      final groups = [
        CustomerGroup(id: 'g1', organizationId: 'o1', name: 'VIP', discountPercent: 10.0),
        CustomerGroup(id: 'g2', organizationId: 'o1', name: 'Regular'),
      ];

      final state = CustomerGroupsLoaded(groups: groups);
      expect(state.groups, hasLength(2));
      expect(state.groups.first.name, 'VIP');
      expect(state.groups.first.discountPercent, 10.0);
    });

    test('sealed class switch for CustomerGroupsState', () {
      CustomerGroupsState state = const CustomerGroupsError(message: 'timeout');
      final result = switch (state) {
        CustomerGroupsInitial() => 'initial',
        CustomerGroupsLoading() => 'loading',
        CustomerGroupsLoaded(:final groups) => 'loaded:${groups.length}',
        CustomerGroupsError(:final message) => 'error:$message',
      };
      expect(result, 'error:timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CustomerDetailState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CustomerDetailState', () {
    test('all subtypes are CustomerDetailState', () {
      expect(const CustomerDetailInitial(), isA<CustomerDetailState>());
      expect(const CustomerDetailLoading(), isA<CustomerDetailState>());
      expect(const CustomerDetailSaving(), isA<CustomerDetailState>());
      expect(const CustomerDetailError(message: 'e'), isA<CustomerDetailState>());
    });

    test('CustomerDetailLoaded holds customer', () {
      final customer = Customer(
        id: 'c1',
        organizationId: 'o1',
        name: 'Alice',
        phone: '+96812345678',
        loyaltyPoints: 500,
        storeCreditBalance: 25.0,
      );
      final state = CustomerDetailLoaded(customer: customer);
      expect(state.customer.name, 'Alice');
      expect(state.customer.loyaltyPoints, 500);
      expect(state.customer.storeCreditBalance, 25.0);
    });

    test('CustomerDetailSaved holds saved customer', () {
      final customer = Customer(id: 'c1', organizationId: 'o1', name: 'Alice Updated', phone: '+96812345678');
      final state = CustomerDetailSaved(customer: customer);
      expect(state.customer.name, 'Alice Updated');
    });
  });
}
