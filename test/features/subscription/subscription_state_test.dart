import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/enums/subscription_status.dart';
import 'package:wameedpos/features/subscription/enums/billing_cycle.dart';

void main() {
  // --- PlansState Tests ---
  group('PlansState', () {
    test('PlansInitial is default state', () {
      const state = PlansInitial();
      expect(state, isA<PlansState>());
    });

    test('PlansLoading indicates loading', () {
      const state = PlansLoading();
      expect(state, isA<PlansState>());
    });

    test('PlansLoaded holds plans list', () {
      final plans = [
        SubscriptionPlan(id: 'p1', name: 'Free', monthlyPrice: 0.0, isActive: true),
        SubscriptionPlan(id: 'p2', name: 'Pro', monthlyPrice: 29.99, isActive: true),
      ];

      final state = PlansLoaded(plans: plans);
      expect(state, isA<PlansState>());
      expect(state.plans, hasLength(2));
      expect(state.plans.first.name, 'Free');
      expect(state.plans.last.name, 'Pro');
    });

    test('PlansError holds error message', () {
      const state = PlansError(message: 'Network timeout');
      expect(state, isA<PlansState>());
      expect(state.message, 'Network timeout');
    });

    test('sealed class exhaustive switch', () {
      PlansState state = PlansLoaded(plans: []);

      final result = switch (state) {
        PlansInitial() => 'initial',
        PlansLoading() => 'loading',
        PlansLoaded(:final plans) => 'loaded:${plans.length}',
        PlansError(:final message) => 'error:$message',
      };

      expect(result, 'loaded:0');
    });
  });

  // --- SubscriptionState Tests ---
  group('SubscriptionState', () {
    test('SubscriptionInitial is default', () {
      const state = SubscriptionInitial();
      expect(state, isA<SubscriptionState>());
    });

    test('SubscriptionLoading indicates loading', () {
      const state = SubscriptionLoading();
      expect(state, isA<SubscriptionState>());
    });

    test('SubscriptionLoaded with subscription', () {
      final sub = StoreSubscription(
        id: 'sub-1',
        organizationId: 'org-1',
        subscriptionPlanId: 'plan-1',
        status: SubscriptionStatus.active,
        billingCycle: BillingCycle.monthly,
      );

      final state = SubscriptionLoaded(subscription: sub);
      expect(state.subscription, isNotNull);
      expect(state.subscription!.status, SubscriptionStatus.active);
    });

    test('SubscriptionLoaded with null (no subscription)', () {
      const state = SubscriptionLoaded();
      expect(state.subscription, isNull);
    });

    test('SubscriptionActionSuccess carries message', () {
      final sub = StoreSubscription(
        id: 'sub-1',
        organizationId: 'org-1',
        subscriptionPlanId: 'plan-1',
        status: SubscriptionStatus.active,
      );

      final state = SubscriptionActionSuccess(subscription: sub, message: 'Subscribed successfully');
      expect(state.subscription, isNotNull);
      expect(state.message, 'Subscribed successfully');
    });

    test('SubscriptionError holds message', () {
      const state = SubscriptionError(message: 'Payment failed');
      expect(state.message, 'Payment failed');
    });

    test('sealed class exhaustive switch', () {
      SubscriptionState state = SubscriptionError(message: 'test');

      final result = switch (state) {
        SubscriptionInitial() => 'initial',
        SubscriptionLoading() => 'loading',
        SubscriptionLoaded() => 'loaded',
        SubscriptionActionSuccess(:final message) => 'success:$message',
        SubscriptionError(:final message) => 'error:$message',
      };

      expect(result, 'error:test');
    });
  });

  // --- InvoicesState Tests ---
  group('InvoicesState', () {
    test('InvoicesInitial is default', () {
      const state = InvoicesInitial();
      expect(state, isA<InvoicesState>());
    });

    test('InvoicesLoaded with invoices', () {
      final invoices = [Invoice(id: 'inv-1', invoiceNumber: 'INV-001', amount: 29.99, total: 34.49)];

      final state = InvoicesLoaded(invoices: invoices);
      expect(state.invoices, hasLength(1));
      expect(state.invoices.first.invoiceNumber, 'INV-001');
    });

    test('InvoicesError holds message', () {
      const state = InvoicesError(message: 'Could not load invoices');
      expect(state.message, 'Could not load invoices');
    });
  });

  // --- UsageState Tests ---
  group('UsageState', () {
    test('UsageInitial is default', () {
      const state = UsageInitial();
      expect(state, isA<UsageState>());
    });

    test('UsageLoaded with usage items', () {
      final items = [
        {'key': 'products', 'current': 45, 'limit': 100, 'percentage': 45.0},
        {'key': 'staff', 'current': 3, 'limit': 5, 'percentage': 60.0},
      ];

      final state = UsageLoaded(usageItems: items);
      expect(state.usageItems, hasLength(2));
    });

    test('UsageLoaded with empty items', () {
      const state = UsageLoaded(usageItems: []);
      expect(state.usageItems, isEmpty);
    });

    test('UsageError holds message', () {
      const state = UsageError(message: 'Usage data unavailable');
      expect(state.message, 'Usage data unavailable');
    });
  });
}
