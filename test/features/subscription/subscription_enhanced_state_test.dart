import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/subscription/providers/subscription_state.dart';
import 'package:thawani_pos/features/subscription/models/invoice.dart';

void main() {
  // --- InvoiceDetailState Tests ---
  group('InvoiceDetailState', () {
    test('InvoiceDetailInitial is default state', () {
      const state = InvoiceDetailInitial();
      expect(state, isA<InvoiceDetailState>());
    });

    test('InvoiceDetailLoading indicates loading', () {
      const state = InvoiceDetailLoading();
      expect(state, isA<InvoiceDetailState>());
    });

    test('InvoiceDetailLoaded holds invoice', () {
      final invoice = Invoice(id: 'inv-1', invoiceNumber: 'INV-001', amount: 100.0, total: 115.0);

      final state = InvoiceDetailLoaded(invoice: invoice);
      expect(state, isA<InvoiceDetailState>());
      expect(state.invoice.id, 'inv-1');
      expect(state.invoice.invoiceNumber, 'INV-001');
      expect(state.invoice.total, 115.0);
    });

    test('InvoiceDetailError holds error message', () {
      const state = InvoiceDetailError(message: 'Invoice not found');
      expect(state, isA<InvoiceDetailState>());
      expect(state.message, 'Invoice not found');
    });

    test('sealed class exhaustive switch', () {
      InvoiceDetailState state = const InvoiceDetailError(message: 'test');

      final result = switch (state) {
        InvoiceDetailInitial() => 'initial',
        InvoiceDetailLoading() => 'loading',
        InvoiceDetailLoaded(:final invoice) => 'loaded:${invoice.id}',
        InvoiceDetailError(:final message) => 'error:$message',
      };

      expect(result, 'error:test');
    });
  });

  // --- AddOnsState Tests ---
  group('AddOnsState', () {
    test('AddOnsInitial is default state', () {
      const state = AddOnsInitial();
      expect(state, isA<AddOnsState>());
    });

    test('AddOnsLoading indicates loading', () {
      const state = AddOnsLoading();
      expect(state, isA<AddOnsState>());
    });

    test('AddOnsLoaded holds available and store add-ons', () {
      final available = [
        {'id': 'ao-1', 'name': 'Extra Storage', 'price': 5.0},
        {'id': 'ao-2', 'name': 'API Access', 'price': 15.0},
      ];
      final storeAddOns = [
        {'id': 'sao-1', 'plan_add_on_id': 'ao-1', 'is_active': true},
      ];

      final state = AddOnsLoaded(availableAddOns: available, storeAddOns: storeAddOns);
      expect(state, isA<AddOnsState>());
      expect(state.availableAddOns, hasLength(2));
      expect(state.storeAddOns, hasLength(1));
    });

    test('AddOnsLoaded with empty lists', () {
      const state = AddOnsLoaded(availableAddOns: [], storeAddOns: []);
      expect(state.availableAddOns, isEmpty);
      expect(state.storeAddOns, isEmpty);
    });

    test('AddOnsError holds error message', () {
      const state = AddOnsError(message: 'Could not load add-ons');
      expect(state, isA<AddOnsState>());
      expect(state.message, 'Could not load add-ons');
    });

    test('sealed class exhaustive switch', () {
      AddOnsState state = const AddOnsLoading();

      final result = switch (state) {
        AddOnsInitial() => 'initial',
        AddOnsLoading() => 'loading',
        AddOnsLoaded(:final availableAddOns) => 'loaded:${availableAddOns.length}',
        AddOnsError(:final message) => 'error:$message',
      };

      expect(result, 'loading');
    });
  });

  // --- PlanComparisonState Tests ---
  group('PlanComparisonState', () {
    test('PlanComparisonInitial is default state', () {
      const state = PlanComparisonInitial();
      expect(state, isA<PlanComparisonState>());
    });

    test('PlanComparisonLoading indicates loading', () {
      const state = PlanComparisonLoading();
      expect(state, isA<PlanComparisonState>());
    });

    test('PlanComparisonLoaded holds comparison data', () {
      final comparison = {
        'plans': ['Free', 'Pro', 'Enterprise'],
        'features': {
          'pos': [true, true, true],
          'inventory': [false, true, true],
          'analytics': [false, false, true],
        },
      };

      final state = PlanComparisonLoaded(comparison: comparison);
      expect(state, isA<PlanComparisonState>());
      expect(state.comparison['plans'], hasLength(3));
    });

    test('PlanComparisonError holds error message', () {
      const state = PlanComparisonError(message: 'Comparison failed');
      expect(state, isA<PlanComparisonState>());
      expect(state.message, 'Comparison failed');
    });

    test('sealed class exhaustive switch', () {
      PlanComparisonState state = const PlanComparisonInitial();

      final result = switch (state) {
        PlanComparisonInitial() => 'initial',
        PlanComparisonLoading() => 'loading',
        PlanComparisonLoaded(:final comparison) => 'loaded:${comparison.length}',
        PlanComparisonError(:final message) => 'error:$message',
      };

      expect(result, 'initial');
    });
  });

  // --- InvoicesLoaded pagination Tests ---
  group('InvoicesLoaded pagination', () {
    test('holds pagination metadata', () {
      final invoices = [Invoice(id: 'inv-1', amount: 100, total: 115)];

      final state = InvoicesLoaded(invoices: invoices, currentPage: 2, lastPage: 5, total: 50);

      expect(state.invoices, hasLength(1));
      expect(state.currentPage, 2);
      expect(state.lastPage, 5);
      expect(state.total, 50);
    });

    test('defaults pagination to first page', () {
      final state = InvoicesLoaded(invoices: []);
      expect(state.currentPage, 1);
      expect(state.lastPage, 1);
      expect(state.total, 0);
    });
  });
}
