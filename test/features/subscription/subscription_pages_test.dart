import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/subscription/enums/subscription_status.dart';
import 'package:wameedpos/features/subscription/enums/billing_cycle.dart';
import 'package:wameedpos/features/subscription/pages/plan_selection_page.dart';
import 'package:wameedpos/features/subscription/pages/subscription_status_page.dart';
import 'package:wameedpos/features/subscription/pages/billing_history_page.dart';

/// Helper to wrap widget in MaterialApp + ProviderScope with overrides
Widget _wrapWithProviders(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

/// Mock PlansNotifier that holds a fixed state
class MockPlansNotifier extends StateNotifier<PlansState> implements PlansNotifier {
  MockPlansNotifier(super.initial);

  @override
  Future<void> loadPlans({bool activeOnly = true}) async {}
}

/// Mock SubscriptionNotifier that holds a fixed state
class MockSubscriptionNotifier extends StateNotifier<SubscriptionState> implements SubscriptionNotifier {
  MockSubscriptionNotifier(super.initial);

  @override
  Future<void> loadCurrent() async {}

  @override
  Future<void> subscribe({required String planId, String billingCycle = 'monthly', String? paymentMethod}) async {}

  @override
  Future<void> changePlan({required String planId, String billingCycle = 'monthly'}) async {}

  @override
  Future<void> cancel({String? reason}) async {}

  @override
  Future<void> resume() async {}
}

/// Mock InvoicesNotifier that holds a fixed state
class MockInvoicesNotifier extends StateNotifier<InvoicesState> implements InvoicesNotifier {
  MockInvoicesNotifier(super.initial);

  @override
  Future<void> loadInvoices({int page = 1}) async {}
}

/// Mock UsageNotifier that holds a fixed state
class MockUsageNotifier extends StateNotifier<UsageState> implements UsageNotifier {
  MockUsageNotifier(super.initial);

  @override
  Future<void> loadUsage() async {}
}

// --- Test Data ---

final _testPlans = [
  SubscriptionPlan(
    id: 'plan-free',
    name: 'Free',
    nameAr: 'مجاني',
    slug: 'free',
    description: 'For small businesses',
    monthlyPrice: 0.0,
    annualPrice: 0.0,
    isActive: true,
    isHighlighted: false,
    sortOrder: 1,
  ),
  SubscriptionPlan(
    id: 'plan-pro',
    name: 'Professional',
    nameAr: 'احترافي',
    slug: 'professional',
    description: 'For growing businesses',
    monthlyPrice: 29.99,
    annualPrice: 299.99,
    trialDays: 14,
    isActive: true,
    isHighlighted: true,
    sortOrder: 2,
  ),
];

final _testSubscription = StoreSubscription(
  id: 'sub-1',
  organizationId: 'org-1',
  subscriptionPlanId: 'plan-pro',
  status: SubscriptionStatus.active,
  billingCycle: BillingCycle.monthly,
  currentPeriodStart: DateTime(2024, 1, 1),
  currentPeriodEnd: DateTime(2024, 2, 1),
);

final _testInvoices = [
  Invoice(id: 'inv-1', invoiceNumber: 'INV-001', amount: 29.99, tax: 4.50, total: 34.49),
  Invoice(id: 'inv-2', invoiceNumber: 'INV-002', amount: 29.99, tax: 4.50, total: 34.49),
];

void main() {
  group('PlanSelectionPage', () {
    testWidgets('shows loading indicator when PlansLoading', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const PlanSelectionPage(),
          overrides: [
            plansProvider.overrideWith((_) => MockPlansNotifier(const PlansLoading())),
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionInitial())),
          ],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on PlansError', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const PlanSelectionPage(),
          overrides: [
            plansProvider.overrideWith((_) => MockPlansNotifier(const PlansError(message: 'Failed to load plans'))),
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Failed to load plans'), findsOneWidget);
    });

    testWidgets('displays plan cards when PlansLoaded', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const PlanSelectionPage(),
          overrides: [
            plansProvider.overrideWith((_) => MockPlansNotifier(PlansLoaded(plans: _testPlans))),
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Free'), findsOneWidget);
      expect(find.text('Professional'), findsOneWidget);
    });

    testWidgets('shows Monthly/Annual toggle', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const PlanSelectionPage(),
          overrides: [
            plansProvider.overrideWith((_) => MockPlansNotifier(PlansLoaded(plans: _testPlans))),
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      // Should have a switch for billing cycle toggle
      expect(find.byType(Switch), findsOneWidget);
    });
  });

  group('SubscriptionStatusPage', () {
    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const SubscriptionStatusPage(),
          overrides: [
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionLoading())),
            usageProvider.overrideWith((_) => MockUsageNotifier(const UsageInitial())),
          ],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows no subscription CTA', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const SubscriptionStatusPage(),
          overrides: [
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionLoaded())),
            usageProvider.overrideWith((_) => MockUsageNotifier(const UsageInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Browse Plans'), findsOneWidget);
    });

    testWidgets('shows subscription details when loaded', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const SubscriptionStatusPage(),
          overrides: [
            subscriptionProvider.overrideWith(
              (_) => MockSubscriptionNotifier(SubscriptionLoaded(subscription: _testSubscription)),
            ),
            usageProvider.overrideWith((_) => MockUsageNotifier(const UsageLoaded(usageItems: []))),
          ],
        ),
      );

      await tester.pumpAndSettle();
      // Should display the subscription status
      expect(find.textContaining('Active'), findsWidgets);
    });

    testWidgets('shows error state with message', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const SubscriptionStatusPage(),
          overrides: [
            subscriptionProvider.overrideWith((_) => MockSubscriptionNotifier(const SubscriptionError(message: 'Network error'))),
            usageProvider.overrideWith((_) => MockUsageNotifier(const UsageInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Network error'), findsOneWidget);
    });
  });

  group('BillingHistoryPage', () {
    testWidgets('shows loading indicator', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const BillingHistoryPage(),
          overrides: [invoicesProvider.overrideWith((_) => MockInvoicesNotifier(const InvoicesLoading()))],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows empty state when no invoices', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const BillingHistoryPage(),
          overrides: [invoicesProvider.overrideWith((_) => MockInvoicesNotifier(const InvoicesLoaded(invoices: [])))],
        ),
      );

      await tester.pumpAndSettle();
      // Empty state text
      expect(find.textContaining('No'), findsWidgets);
    });

    testWidgets('shows invoice list when loaded', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const BillingHistoryPage(),
          overrides: [invoicesProvider.overrideWith((_) => MockInvoicesNotifier(InvoicesLoaded(invoices: _testInvoices)))],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('INV-001'), findsOneWidget);
      expect(find.text('INV-002'), findsOneWidget);
    });

    testWidgets('shows error with retry button', (tester) async {
      await tester.pumpWidget(
        _wrapWithProviders(
          const BillingHistoryPage(),
          overrides: [
            invoicesProvider.overrideWith((_) => MockInvoicesNotifier(const InvoicesError(message: 'Connection failed'))),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Connection failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
