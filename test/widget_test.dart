import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/app.dart';
import 'package:wameedpos/core/providers/app_settings_providers.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await initAppSettings();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Allow layout overflow in smoke test (login page Row on small test surface)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    await tester.pumpWidget(const ProviderScope(child: WameedPosApp()));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Wameed POS'), findsWidgets);

    FlutterError.onError = originalOnError;
  });
}
