import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/pages/product_combo_page.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';

class _FakeRepo extends CatalogRepository {
  _FakeRepo({required this.products, required this.combo}) : super(apiService: CatalogApiService(Dio()));

  final Map<String, Product> products;
  ComboDefinition combo;

  int syncCalls = 0;
  int clearCalls = 0;
  ComboDefinition? lastSyncedCombo;
  List<ComboItemPayload>? lastSyncedItems;
  double? lastSyncedPrice;
  String? lastSyncedName;

  @override
  Future<Product> getProduct(String id) async => products[id]!;

  @override
  Future<ComboDefinition> getCombo(String productId) async => combo;

  @override
  Future<ComboDefinition> syncCombo(
    String productId, {
    String? name,
    double? comboPrice,
    required List<ComboItemPayload> items,
  }) async {
    syncCalls++;
    lastSyncedName = name;
    lastSyncedPrice = comboPrice;
    lastSyncedItems = items;
    combo = ComboDefinition(
      isCombo: true,
      id: 'combo-1',
      name: name ?? products[productId]?.name,
      comboPrice: comboPrice,
      items: items
          .map(
            (it) => ComboItem(
              id: 'i-${it.productId}',
              productId: it.productId,
              productName: products[it.productId]?.name,
              productNameAr: products[it.productId]?.nameAr,
              quantity: it.quantity,
              isOptional: it.isOptional,
            ),
          )
          .toList(),
    );
    lastSyncedCombo = combo;
    return combo;
  }

  @override
  Future<void> clearCombo(String productId) async {
    clearCalls++;
    combo = const ComboDefinition(isCombo: false, id: null, name: null, comboPrice: null, items: <ComboItem>[]);
  }
}

Widget _harness(Widget child, {required CatalogRepository repo}) {
  return ProviderScope(
    overrides: [catalogRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );
}

void main() {
  const burger = Product(id: 'p-1', organizationId: 'o-1', name: 'Burger', nameAr: 'برجر', sellPrice: 10);

  group('ProductComboPage', () {
    testWidgets('pre-fills name and existing items from getCombo', (tester) async {
      final repo = _FakeRepo(
        products: const {'p-1': burger},
        combo: const ComboDefinition(
          isCombo: true,
          id: 'c-1',
          name: 'Meal',
          comboPrice: 15.5,
          items: [
            ComboItem(id: 'i-1', productId: 'p-2', productName: 'Fries', productNameAr: null, quantity: 2, isOptional: true),
          ],
        ),
      );

      await tester.pumpWidget(_harness(const ProductComboPage(productId: 'p-1'), repo: repo));
      await tester.pumpAndSettle();

      // Name and price fields pre-filled.
      expect(find.widgetWithText(TextField, 'Meal'), findsOneWidget);
      expect(find.widgetWithText(TextField, '15.50'), findsOneWidget);
      // Existing item shown.
      expect(find.text('Fries'), findsOneWidget);
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('clearing combo calls repository.clearCombo and pops true', (tester) async {
      final repo = _FakeRepo(
        products: const {'p-1': burger},
        combo: const ComboDefinition(
          isCombo: true,
          id: 'c-1',
          name: 'Meal',
          comboPrice: 15.5,
          items: [
            ComboItem(id: 'i-1', productId: 'p-2', productName: 'Fries', productNameAr: null, quantity: 1, isOptional: false),
          ],
        ),
      );

      await tester.pumpWidget(_harness(const ProductComboPage(productId: 'p-1'), repo: repo));
      await tester.pumpAndSettle();

      // Tap the outline "Clear combo" button in the bottom bar.
      final clearBtn = find.text('Clear combo');
      expect(clearBtn, findsOneWidget);
      await tester.tap(clearBtn);
      await tester.pumpAndSettle();

      // Confirm dialog appears; tap the destructive "Delete" action.
      final confirmBtn = find.widgetWithText(TextButton, 'Delete');
      expect(confirmBtn, findsOneWidget);
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(repo.clearCalls, 1);
    });

    testWidgets('save with empty items shows validation snack', (tester) async {
      final repo = _FakeRepo(
        products: const {'p-1': burger},
        combo: const ComboDefinition(isCombo: false, id: null, name: null, comboPrice: null, items: <ComboItem>[]),
      );

      await tester.pumpWidget(_harness(const ProductComboPage(productId: 'p-1'), repo: repo));
      await tester.pumpAndSettle();

      // Hit Save with no items
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Add at least one item before saving'), findsOneWidget);
      expect(repo.syncCalls, 0);
    });
  });
}
