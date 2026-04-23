import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/widgets/label_preview_widget.dart';

LabelTemplate _template({Map<String, dynamic>? layout}) {
  return LabelTemplate(
    id: 'tpl-1',
    organizationId: 'org-1',
    name: 'Test',
    labelWidthMm: 50,
    labelHeightMm: 30,
    layoutJson: layout ??
        {
          'elements': [
            {'type': 'product_name', 'x': 2.0, 'y': 2.0, 'width': 40.0, 'height': 6.0},
            {'type': 'price', 'x': 2.0, 'y': 10.0, 'width': 40.0, 'height': 6.0},
            {
              'type': 'barcode',
              'x': 2.0,
              'y': 18.0,
              'width': 46.0,
              'height': 10.0,
              'config': {'format': 'code128', 'show_text': true},
            },
          ],
        },
  );
}

void main() {
  group('LabelPreviewWidget', () {
    testWidgets('renders demo data when no data provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabelPreviewWidget(template: _template()),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Product Name'), findsOneWidget);
      expect(find.textContaining('9.999'), findsOneWidget);
    });

    testWidgets('renders supplied product data', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabelPreviewWidget(
              template: _template(),
              data: const LabelPreviewData(
                productName: 'Mango',
                productNameAr: 'مانجو',
                barcode: '1234567890128',
                price: 4.5,
                currency: '\u0081',
                sku: 'M-001',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Mango'), findsOneWidget);
      expect(find.textContaining('4.500'), findsOneWidget);
    });

    testWidgets('handles invalid barcode value gracefully', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LabelPreviewWidget(
              template: _template(layout: {
                'elements': [
                  {
                    'type': 'barcode',
                    'x': 0.0,
                    'y': 0.0,
                    'width': 50.0,
                    'height': 20.0,
                    'config': {'format': 'ean13', 'show_text': true},
                  },
                ],
              }),
              data: const LabelPreviewData(
                productName: 'p',
                productNameAr: 'p',
                barcode: 'INVALID-FOR-EAN13',
                price: 1.0,
                currency: '\u0081',
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      // Painter falls back to placeholder; widget tree remains valid.
      expect(tester.takeException(), isNull);
    });
  });
}
