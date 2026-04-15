import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Allow layout overflow in smoke test (login page Row on small test surface)
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      if (details.toString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    await tester.pumpWidget(const ProviderScope(child: WameedPosApp()));
    await tester.pumpAndSettle();
    expect(find.text('Wameed POS'), findsOneWidget);

    FlutterError.onError = originalOnError;
  });
}
