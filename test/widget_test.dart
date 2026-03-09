import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ThawaniPosApp()));
    await tester.pumpAndSettle();
    expect(find.text('Thawani POS'), findsOneWidget);
  });
}
