import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // ProductsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('ProductsState', () {
    test('ProductsInitial is default state', () {
      const state = ProductsInitial();
      expect(state, isA<ProductsState>());
    });

    test('ProductsLoading indicates loading', () {
      const state = ProductsLoading();
      expect(state, isA<ProductsState>());
    });

    test('ProductsLoaded holds products and pagination info', () {
      final products = [
        const Product(id: 'p1', organizationId: 'o1', name: 'Product 1', sellPrice: 1.0),
        const Product(id: 'p2', organizationId: 'o1', name: 'Product 2', sellPrice: 2.0),
      ];

      final state = ProductsLoaded(products: products, total: 50, currentPage: 1, lastPage: 3, perPage: 25);

      expect(state, isA<ProductsState>());
      expect(state.products, hasLength(2));
      expect(state.total, 50);
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.perPage, 25);
      expect(state.hasMore, true);
    });

    test('ProductsLoaded hasMore is false on last page', () {
      const state = ProductsLoaded(products: [], total: 10, currentPage: 1, lastPage: 1, perPage: 25);
      expect(state.hasMore, false);
    });

    test('ProductsLoaded copyWith replaces fields', () {
      const state = ProductsLoaded(
        products: [Product(id: 'p1', organizationId: 'o1', name: 'A', sellPrice: 1.0)],
        total: 10,
        currentPage: 1,
        lastPage: 1,
        perPage: 25,
      );

      final updated = state.copyWith(currentPage: 2, total: 50);
      expect(updated.currentPage, 2);
      expect(updated.total, 50);
      expect(updated.products.first.name, 'A'); // Unchanged
    });

    test('ProductsError holds error message', () {
      const state = ProductsError(message: 'Network error');
      expect(state, isA<ProductsState>());
      expect(state.message, 'Network error');
    });

    test('sealed class exhaustive switch', () {
      const ProductsState state = ProductsLoading();

      final result = switch (state) {
        ProductsInitial() => 'initial',
        ProductsLoading() => 'loading',
        ProductsLoaded(:final products) => 'loaded:${products.length}',
        ProductsError(:final message) => 'error:$message',
      };

      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ProductDetailState Tests
  // ═══════════════════════════════════════════════════════════════

  group('ProductDetailState', () {
    test('all states are subtypes of ProductDetailState', () {
      expect(const ProductDetailInitial(), isA<ProductDetailState>());
      expect(const ProductDetailLoading(), isA<ProductDetailState>());
      expect(const ProductDetailSaving(), isA<ProductDetailState>());
      expect(
        const ProductDetailLoaded(
          product: Product(id: 'p1', organizationId: 'o1', name: 'T', sellPrice: 1.0),
        ),
        isA<ProductDetailState>(),
      );
      expect(
        const ProductDetailSaved(
          product: Product(id: 'p1', organizationId: 'o1', name: 'T', sellPrice: 1.0),
        ),
        isA<ProductDetailState>(),
      );
      expect(const ProductDetailError(message: 'e'), isA<ProductDetailState>());
    });

    test('ProductDetailLoaded holds product', () {
      const product = Product(id: 'p1', organizationId: 'o1', name: 'Coca Cola', sellPrice: 0.250);
      const state = ProductDetailLoaded(product: product);
      expect(state.product.name, 'Coca Cola');
    });

    test('ProductDetailSaved holds saved product', () {
      const product = Product(id: 'p1', organizationId: 'o1', name: 'Updated', sellPrice: 0.300);
      const state = ProductDetailSaved(product: product);
      expect(state.product.name, 'Updated');
      expect(state.product.sellPrice, 0.300);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CategoriesState Tests
  // ═══════════════════════════════════════════════════════════════

  group('CategoriesState', () {
    test('CategoriesInitial is default', () {
      const state = CategoriesInitial();
      expect(state, isA<CategoriesState>());
    });

    test('CategoriesLoaded holds categories list', () {
      final categories = [
        const Category(id: 'c1', organizationId: 'o1', name: 'Beverages'),
        const Category(id: 'c2', organizationId: 'o1', name: 'Snacks'),
      ];

      final state = CategoriesLoaded(categories: categories);
      expect(state.categories, hasLength(2));
      expect(state.categories.first.name, 'Beverages');
    });

    test('CategoriesLoaded copyWith replaces categories', () {
      const state = CategoriesLoaded(
        categories: [Category(id: 'c1', organizationId: 'o1', name: 'A')],
      );

      final updated = state.copyWith(
        categories: [
          const Category(id: 'c1', organizationId: 'o1', name: 'A'),
          const Category(id: 'c2', organizationId: 'o1', name: 'B'),
        ],
      );

      expect(updated.categories, hasLength(2));
    });

    test('CategoriesError holds message', () {
      const state = CategoriesError(message: 'Failed');
      expect(state.message, 'Failed');
    });

    test('sealed class exhaustive switch', () {
      const CategoriesState state = CategoriesLoading();

      final result = switch (state) {
        CategoriesInitial() => 'initial',
        CategoriesLoading() => 'loading',
        CategoriesLoaded(:final categories) => 'loaded:${categories.length}',
        CategoriesError(:final message) => 'error:$message',
      };

      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // SuppliersState Tests
  // ═══════════════════════════════════════════════════════════════

  group('SuppliersState', () {
    test('SuppliersInitial is default', () {
      const state = SuppliersInitial();
      expect(state, isA<SuppliersState>());
    });

    test('SuppliersLoaded holds suppliers and pagination', () {
      final suppliers = [const Supplier(id: 's1', organizationId: 'o1', name: 'Supplier A')];

      final state = SuppliersLoaded(suppliers: suppliers, total: 25, currentPage: 1, lastPage: 2, perPage: 25);

      expect(state.suppliers, hasLength(1));
      expect(state.total, 25);
      expect(state.hasMore, true);
    });

    test('SuppliersLoaded hasMore is false on last page', () {
      const state = SuppliersLoaded(suppliers: [], total: 5, currentPage: 1, lastPage: 1, perPage: 25);
      expect(state.hasMore, false);
    });

    test('SuppliersLoaded copyWith', () {
      const state = SuppliersLoaded(
        suppliers: [Supplier(id: 's1', organizationId: 'o1', name: 'A')],
        total: 10,
        currentPage: 1,
        lastPage: 1,
        perPage: 25,
      );

      final updated = state.copyWith(total: 20, currentPage: 2);
      expect(updated.total, 20);
      expect(updated.currentPage, 2);
      expect(updated.suppliers.first.name, 'A');
    });

    test('SuppliersError holds message', () {
      const state = SuppliersError(message: 'Server error');
      expect(state.message, 'Server error');
    });

    test('sealed class exhaustive switch', () {
      const SuppliersState state = SuppliersError(message: 'fail');

      final result = switch (state) {
        SuppliersInitial() => 'initial',
        SuppliersLoading() => 'loading',
        SuppliersLoaded(:final suppliers) => 'loaded:${suppliers.length}',
        SuppliersError(:final message) => 'error:$message',
      };

      expect(result, 'error:fail');
    });
  });
}
