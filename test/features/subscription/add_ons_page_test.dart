import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/subscription/pages/add_ons_page.dart';
import 'package:wameedpos/features/subscription/providers/subscription_providers.dart';
import 'package:wameedpos/features/subscription/providers/subscription_state.dart';

class MockAddOnsNotifier extends StateNotifier<AddOnsState> implements AddOnsNotifier {
  MockAddOnsNotifier(super.state);

  @override
  Future<void> loadAddOns() async {}
}

Widget _wrap(Widget child, {required AddOnsState state, Locale? locale}) {
  return ProviderScope(
    overrides: [addOnsProvider.overrideWith((_) => MockAddOnsNotifier(state))],
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: child,
    ),
  );
}

void main() {
  group('AddOnsPage', () {
    testWidgets('shows Arabic add-on name on available tab', (tester) async {
      const state = AddOnsLoaded(
        availableAddOns: [
          {'id': 'addon-1', 'name': 'SoftPOS', 'name_ar': 'سوفت بوس', 'monthly_price': 49.99, 'description': 'NFC payments'},
        ],
        storeAddOns: [],
      );

      await tester.pumpWidget(_wrap(const AddOnsPage(), state: state, locale: const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('سوفت بوس'), findsOneWidget);
    });

    testWidgets('reads active add-ons from add_on payload shape', (tester) async {
      const state = AddOnsLoaded(
        availableAddOns: [],
        storeAddOns: [
          {
            'plan_add_on_id': 'addon-1',
            'is_active': true,
            'add_on': {
              'id': 'addon-1',
              'name': 'SoftPOS',
              'name_ar': 'سوفت بوس',
              'monthly_price': 49.99,
              'description': 'NFC payments',
            },
          },
        ],
      );

      await tester.pumpWidget(_wrap(const AddOnsPage(), state: state));
      await tester.pumpAndSettle();

      await tester.tap(find.textContaining('My'));
      await tester.pumpAndSettle();

      expect(find.text('SoftPOS'), findsOneWidget);
    });
  });
}
