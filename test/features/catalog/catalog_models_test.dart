import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';
import 'package:wameedpos/features/catalog/enums/product_unit.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // Product Model Tests
  // ═══════════════════════════════════════════════════════════════

  group('Product', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'prod-uuid-1',
        'organization_id': 'org-uuid-1',
        'category_id': 'cat-uuid-1',
        'name': 'Coca Cola 330ml',
        'name_ar': 'كوكا كولا',
        'description': 'Carbonated soft drink',
        'description_ar': 'مشروب غازي',
        'sku': 'SKU001',
        'barcode': '5449000000996',
        'sell_price': 0.250,
        'cost_price': 0.150,
        'unit': 'piece',
        'tax_rate': 5.0,
        'is_weighable': false,
        'tare_weight': null,
        'is_active': true,
        'is_combo': false,
        'age_restricted': false,
        'image_url': 'https://example.com/coca-cola.jpg',
        'sync_version': 42,
        'created_at': '2024-01-15T10:30:00.000Z',
        'updated_at': '2024-06-20T14:00:00.000Z',
        'deleted_at': null,
      };

      final product = Product.fromJson(json);

      expect(product.id, 'prod-uuid-1');
      expect(product.organizationId, 'org-uuid-1');
      expect(product.categoryId, 'cat-uuid-1');
      expect(product.name, 'Coca Cola 330ml');
      expect(product.nameAr, 'كوكا كولا');
      expect(product.description, 'Carbonated soft drink');
      expect(product.descriptionAr, 'مشروب غازي');
      expect(product.sku, 'SKU001');
      expect(product.barcode, '5449000000996');
      expect(product.sellPrice, 0.250);
      expect(product.costPrice, 0.150);
      expect(product.unit, ProductUnit.piece);
      expect(product.taxRate, 5.0);
      expect(product.isWeighable, false);
      expect(product.tareWeight, isNull);
      expect(product.isActive, true);
      expect(product.isCombo, false);
      expect(product.ageRestricted, false);
      expect(product.imageUrl, 'https://example.com/coca-cola.jpg');
      expect(product.syncVersion, 42);
      expect(product.createdAt, isNotNull);
      expect(product.deletedAt, isNull);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'prod-uuid-2', 'organization_id': 'org-uuid-1', 'name': 'Simple Product', 'sell_price': 1.500};

      final product = Product.fromJson(json);
      expect(product.id, 'prod-uuid-2');
      expect(product.name, 'Simple Product');
      expect(product.sellPrice, 1.500);
      expect(product.categoryId, isNull);
      expect(product.sku, isNull);
      expect(product.barcode, isNull);
      expect(product.costPrice, isNull);
      expect(product.unit, isNull);
      expect(product.isActive, isNull);
    });

    test('fromJson handles numeric sell_price as int', () {
      final json = {'id': 'p1', 'organization_id': 'o1', 'name': 'Test', 'sell_price': 5};

      final product = Product.fromJson(json);
      expect(product.sellPrice, 5.0);
    });

    test('toJson produces correct map', () {
      const product = Product(
        id: 'prod-uuid-1',
        organizationId: 'org-uuid-1',
        name: 'Test',
        sellPrice: 1.250,
        sku: 'SKU123',
        isActive: true,
      );

      final json = product.toJson();
      expect(json['id'], 'prod-uuid-1');
      expect(json['organization_id'], 'org-uuid-1');
      expect(json['name'], 'Test');
      expect(json['sell_price'], 1.250);
      expect(json['sku'], 'SKU123');
      expect(json['is_active'], true);
    });

    test('copyWith replaces specified fields', () {
      const original = Product(id: 'p1', organizationId: 'o1', name: 'Original', sellPrice: 1.0, isActive: true);

      final updated = original.copyWith(name: 'Updated', sellPrice: 2.5);
      expect(updated.id, 'p1');
      expect(updated.name, 'Updated');
      expect(updated.sellPrice, 2.5);
      expect(updated.isActive, true); // Unchanged
    });

    test('equality is based on id', () {
      const p1 = Product(id: 'same-id', organizationId: 'o1', name: 'A', sellPrice: 1.0);
      const p2 = Product(id: 'same-id', organizationId: 'o1', name: 'B', sellPrice: 2.0);
      const p3 = Product(id: 'diff-id', organizationId: 'o1', name: 'A', sellPrice: 1.0);

      expect(p1, equals(p2));
      expect(p1, isNot(equals(p3)));
      expect(p1.hashCode, p2.hashCode);
    });

    test('fromJson parses deleted_at for soft-deleted products', () {
      final json = {
        'id': 'p1',
        'organization_id': 'o1',
        'name': 'Deleted',
        'sell_price': 1.0,
        'deleted_at': '2024-12-01T00:00:00.000Z',
      };

      final product = Product.fromJson(json);
      expect(product.deletedAt, isNotNull);
      expect(product.deletedAt!.year, 2024);
      expect(product.deletedAt!.month, 12);
    });

    test('fromJson parses ProductUnit enum correctly', () {
      for (final unitValue in ['piece', 'kg', 'litre', 'custom']) {
        final json = {
          'id': 'p-$unitValue',
          'organization_id': 'o1',
          'name': 'Test $unitValue',
          'sell_price': 1.0,
          'unit': unitValue,
        };
        final product = Product.fromJson(json);
        expect(product.unit, isNotNull, reason: 'Failed to parse unit: $unitValue');
        expect(product.unit!.value, unitValue);
      }
    });

    test('fromJson handles unknown unit gracefully', () {
      final json = {'id': 'p1', 'organization_id': 'o1', 'name': 'Test', 'sell_price': 1.0, 'unit': 'unknown_unit'};
      final product = Product.fromJson(json);
      expect(product.unit, isNull); // tryFromValue returns null
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Category Model Tests
  // ═══════════════════════════════════════════════════════════════

  group('Category', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'cat-uuid-1',
        'organization_id': 'org-uuid-1',
        'parent_id': null,
        'name': 'Beverages',
        'name_ar': 'مشروبات',
        'image_url': 'https://example.com/beverages.jpg',
        'sort_order': 1,
        'is_active': true,
        'sync_version': 10,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-01T00:00:00.000Z',
      };

      final category = Category.fromJson(json);

      expect(category.id, 'cat-uuid-1');
      expect(category.organizationId, 'org-uuid-1');
      expect(category.parentId, isNull);
      expect(category.name, 'Beverages');
      expect(category.nameAr, 'مشروبات');
      expect(category.imageUrl, 'https://example.com/beverages.jpg');
      expect(category.sortOrder, 1);
      expect(category.isActive, true);
      expect(category.syncVersion, 10);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'cat-uuid-2', 'organization_id': 'org-uuid-1', 'name': 'Simple'};

      final category = Category.fromJson(json);
      expect(category.name, 'Simple');
      expect(category.parentId, isNull);
      expect(category.nameAr, isNull);
      expect(category.sortOrder, isNull);
    });

    test('fromJson parses subcategory with parent_id', () {
      final json = {'id': 'sub-cat-1', 'organization_id': 'org-1', 'parent_id': 'cat-parent-1', 'name': 'Juices'};

      final category = Category.fromJson(json);
      expect(category.parentId, 'cat-parent-1');
    });

    test('toJson produces correct map', () {
      const category = Category(id: 'cat-1', organizationId: 'org-1', name: 'Food', isActive: true, sortOrder: 2);

      final json = category.toJson();
      expect(json['id'], 'cat-1');
      expect(json['name'], 'Food');
      expect(json['is_active'], true);
      expect(json['sort_order'], 2);
    });

    test('copyWith replaces specified fields', () {
      const original = Category(id: 'c1', organizationId: 'o1', name: 'Original', isActive: true);

      final updated = original.copyWith(name: 'Updated', isActive: false);
      expect(updated.id, 'c1');
      expect(updated.name, 'Updated');
      expect(updated.isActive, false);
    });

    test('equality is based on id', () {
      const c1 = Category(id: 'same', organizationId: 'o1', name: 'A');
      const c2 = Category(id: 'same', organizationId: 'o1', name: 'B');
      expect(c1, equals(c2));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Supplier Model Tests
  // ═══════════════════════════════════════════════════════════════

  group('Supplier', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'id': 'sup-uuid-1',
        'organization_id': 'org-uuid-1',
        'name': 'Oman Beverages',
        'phone': '+96824567890',
        'email': 'contact@omanbev.com',
        'address': 'Muscat Industrial Area',
        'notes': 'Main juice supplier',
        'is_active': true,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-03-15T12:00:00.000Z',
      };

      final supplier = Supplier.fromJson(json);

      expect(supplier.id, 'sup-uuid-1');
      expect(supplier.organizationId, 'org-uuid-1');
      expect(supplier.name, 'Oman Beverages');
      expect(supplier.phone, '+96824567890');
      expect(supplier.email, 'contact@omanbev.com');
      expect(supplier.address, 'Muscat Industrial Area');
      expect(supplier.notes, 'Main juice supplier');
      expect(supplier.isActive, true);
    });

    test('fromJson handles minimal fields', () {
      final json = {'id': 'sup-2', 'organization_id': 'org-1', 'name': 'Basic Supplier'};

      final supplier = Supplier.fromJson(json);
      expect(supplier.name, 'Basic Supplier');
      expect(supplier.phone, isNull);
      expect(supplier.email, isNull);
      expect(supplier.address, isNull);
      expect(supplier.notes, isNull);
      expect(supplier.isActive, isNull);
    });

    test('toJson produces correct map', () {
      const supplier = Supplier(
        id: 'sup-1',
        organizationId: 'org-1',
        name: 'Test Supplier',
        phone: '12345',
        email: 'test@test.com',
      );

      final json = supplier.toJson();
      expect(json['id'], 'sup-1');
      expect(json['name'], 'Test Supplier');
      expect(json['phone'], '12345');
      expect(json['email'], 'test@test.com');
    });

    test('copyWith replaces specified fields', () {
      const original = Supplier(id: 's1', organizationId: 'o1', name: 'Original');
      final updated = original.copyWith(name: 'Updated', phone: '999');

      expect(updated.id, 's1');
      expect(updated.name, 'Updated');
      expect(updated.phone, '999');
    });

    test('equality is based on id', () {
      const s1 = Supplier(id: 'same', organizationId: 'o1', name: 'A');
      const s2 = Supplier(id: 'same', organizationId: 'o1', name: 'B');
      const s3 = Supplier(id: 'diff', organizationId: 'o1', name: 'A');

      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));
    });
  });
}
