import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/subscription/enums/billing_cycle.dart';
import 'package:wameedpos/features/subscription/enums/subscription_status.dart';
import 'package:wameedpos/features/subscription/models/store_subscription.dart';
import 'package:wameedpos/features/subscription/models/subscription_plan.dart';
import 'package:wameedpos/features/subscription/pages/add_ons_page.dart';
import 'package:wameedpos/features/subscription/pages/subscription_status_page.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';

class _SubscriptionNotifier extends StateNotifier<SubscriptionState> implements SubscriptionNotifier {
  _SubscriptionNotifier(super.state);

  @override
  Future<void> loadCurrent() async {}

  @override
  Future<void> subscribe(
    AppLocalizations l10n, {
    required String planId,
    String billingCycle = 'monthly',
    String? paymentMethod,
  }) async {}

  @override
  Future<void> changePlan(AppLocalizations l10n, {required String planId, String billingCycle = 'monthly'}) async {}

  @override
  Future<void> cancel(AppLocalizations l10n, {String? reason}) async {}

  @override
  Future<void> resume(AppLocalizations l10n) async {}
}

class _UsageNotifier extends StateNotifier<UsageState> implements UsageNotifier {
  _UsageNotifier(super.state);

  @override
  Future<void> loadUsage() async {}
}

class _AddOnsNotifier extends StateNotifier<AddOnsState> implements AddOnsNotifier {
  _AddOnsNotifier(super.state);

  @override
  Future<void> loadAddOns() async {}
}

Widget _app(Widget child, {required List<Override> overrides, Locale? locale}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: child,
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('subscription pages core flow renders localized data and supports UI actions', (tester) async {
    final subscription = StoreSubscription(
      id: 'sub-1',
      organizationId: 'org-1',
      subscriptionPlanId: 'plan-pro',
      status: SubscriptionStatus.active,
      billingCycle: BillingCycle.monthly,
      currentPeriodStart: DateTime(2026, 1, 1),
      currentPeriodEnd: DateTime(2026, 2, 1),
      plan: const SubscriptionPlan(
        id: 'plan-pro',
        name: 'Professional',
        nameAr: 'احترافي',
        monthlyPrice: 29.99,
        isActive: true,
        features: [
          {'feature_key': 'inventory', 'name': 'Inventory', 'name_ar': 'المخزون', 'is_enabled': true},
        ],
        limits: [
          {'limit_key': 'products', 'limit_value': 100},
        ],
      ),
    );

    await tester.pumpWidget(
      _app(
        const SubscriptionStatusPage(),
        locale: const Locale('ar'),
        overrides: [
          subscriptionProvider.overrideWith((_) => _SubscriptionNotifier(SubscriptionLoaded(subscription: subscription))),
          usageProvider.overrideWith(
            (_) => _UsageNotifier(
              const UsageLoaded(
                usageItems: [
                  {'limit_key': 'products', 'current': 55, 'limit': 100, 'percentage': 55.0},
                ],
              ),
            ),
          ),
        ],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('احترافي'), findsWidgets);
    expect(find.text('المخزون'), findsOneWidget);
    expect(find.text('55 / 100'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        const AddOnsPage(),
        locale: const Locale('ar'),
        overrides: [
          addOnsProvider.overrideWith(
            (_) => _AddOnsNotifier(
              const AddOnsLoaded(
                availableAddOns: [
                  {'id': 'addon-1', 'name': 'SoftPOS', 'name_ar': 'سوفت بوس', 'monthly_price': 49.99},
                ],
                storeAddOns: [
                  {
                    'plan_add_on_id': 'addon-1',
                    'is_active': true,
                    'add_on': {'id': 'addon-1', 'name': 'SoftPOS', 'name_ar': 'سوفت بوس', 'monthly_price': 49.99},
                  },
                ],
              ),
            ),
          ),
        ],
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('سوفت بوس'), findsWidgets);
  });
}
