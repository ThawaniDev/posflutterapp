import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

final catalogSyncServiceProvider = Provider<CatalogSyncService>((ref) {
  return CatalogSyncService(
    ref.watch(catalogRepositoryProvider),
    ref.watch(dioClientProvider),
    ref.watch(posOfflineDatabaseProvider),
  );
});

/// Pulls the canonical catalog from the Laravel API and writes it
/// into the local Drift database so the POS terminal can browse the
/// full catalog (categories, suppliers, variants, modifiers) while
/// offline.
///
/// All parsing is defensive: server responses with missing/null
/// fields fall back to safe defaults rather than throwing, so a
/// partial response never corrupts the local store.
class CatalogSyncService {
  CatalogSyncService(this._repo, this._dio, this._db);

  final CatalogRepository _repo;
  final Dio _dio;
  final PosOfflineDatabase _db;

  /// Runs a full catalog sync. Returns a summary of how many rows
  /// were upserted in each table, suitable for logging/UI display.
  Future<CatalogSyncSummary> syncAll() async {
    final cats = await _syncCategories();
    final supps = await _syncSuppliers();
    // Variants + modifiers + product↔supplier links are scoped per
    // product. We fetch the active catalog (already cached locally
    // by ProductSyncService) to enumerate product ids.
    final productIds = await _activeProductIds();
    var variants = 0;
    var modifierGroups = 0;
    var modifierOptions = 0;
    var productSuppliers = 0;
    for (final pid in productIds) {
      variants += await _syncVariantsFor(pid);
      final groupOptCount = await _syncModifiersFor(pid);
      modifierGroups += groupOptCount.groups;
      modifierOptions += groupOptCount.options;
      productSuppliers += await _syncSuppliersFor(pid);
    }
    return CatalogSyncSummary(
      categories: cats,
      suppliers: supps,
      variants: variants,
      modifierGroups: modifierGroups,
      modifierOptions: modifierOptions,
      productSuppliers: productSuppliers,
    );
  }

  // ─── Categories ──────────────────────────────────────────────

  Future<int> _syncCategories() async {
    final categories = await _repo.getCategoryTree();
    if (categories.isEmpty) return 0;
    final companions = categories.map((c) {
      return LocalCategoriesCompanion(
        id: Value(c.id),
        parentId: Value(c.parentId),
        name: Value(c.name),
        nameAr: Value(c.nameAr),
        colorHex: const Value(null),
        iconName: const Value(null),
        sortOrder: Value(c.sortOrder ?? 0),
        isActive: Value(c.isActive ?? true),
        updatedAt: Value(c.updatedAt ?? DateTime.now()),
      );
    }).toList();
    await _db.upsertCategories(companions);
    return companions.length;
  }

  // ─── Suppliers ───────────────────────────────────────────────

  Future<int> _syncSuppliers() async {
    var page = 1;
    var total = 0;
    while (true) {
      final result = await _repo.listSuppliers(page: page, perPage: 100);
      if (result.items.isEmpty) break;
      final companions = result.items.map((s) {
        return LocalSuppliersCompanion(
          id: Value(s.id),
          name: Value(s.name),
          contactPerson: Value(s.contactPerson),
          phone: Value(s.phone),
          email: Value(s.email),
          isActive: Value(s.isActive ?? true),
          updatedAt: Value(s.updatedAt ?? DateTime.now()),
        );
      }).toList();
      await _db.upsertSuppliers(companions);
      total += companions.length;
      if (!result.hasMore) break;
      page += 1;
    }
    return total;
  }

  // ─── Per-product: variants ───────────────────────────────────

  Future<int> _syncVariantsFor(String productId) async {
    final variants = await _repo.getVariants(productId);
    if (variants.isEmpty) return 0;
    final companions = variants.map((v) {
      return LocalProductVariantsCompanion(
        id: Value(v.id),
        productId: Value(productId),
        sku: Value(v.sku),
        barcode: Value(v.barcode),
        name: Value(v.variantValue),
        attributesJson: Value(_attributesJson(v.variantGroupId, v.variantValue)),
        priceDelta: Value(v.priceAdjustment ?? 0),
        costPrice: const Value(null),
        isActive: Value(v.isActive ?? true),
      );
    }).toList();
    await _db.upsertVariants(companions);
    return companions.length;
  }

  String _attributesJson(String groupId, String value) =>
      '{"group_id":"$groupId","value":"${value.replaceAll('"', '\\"')}"}';

  // ─── Per-product: modifiers (groups + options) ───────────────

  Future<({int groups, int options})> _syncModifiersFor(String productId) async {
    // Use raw dio so we get the nested options that the typed
    // ModifierGroup model does not expose.
    final response = await _dio.get('${ApiEndpoints.products}/$productId/modifiers');
    final api = ApiResponse.fromJson(response.data, (d) => d);
    final raw = api.dataList;
    final companions = parseModifierResponse(productId, raw);

    if (companions.groups.isNotEmpty) {
      await _db.upsertModifierGroups(companions.groups);
    }
    if (companions.options.isNotEmpty) {
      await _db.upsertModifierOptions(companions.options);
    }
    return (groups: companions.groups.length, options: companions.options.length);
  }

  // ─── Per-product: supplier links ─────────────────────────────

  Future<int> _syncSuppliersFor(String productId) async {
    final links = await _repo.getProductSuppliers(productId);
    if (links.isEmpty) return 0;
    final companions = links.map((l) {
      return LocalProductSuppliersCompanion(
        productId: Value(productId),
        supplierId: Value(l.supplierId),
        costPrice: Value(l.costPrice),
        supplierSku: Value(l.supplierSku),
        leadTimeDays: Value(l.leadTimeDays),
        isPreferred: const Value(false),
      );
    }).toList();
    await _db.upsertProductSuppliers(companions);
    return companions.length;
  }

  // ─── Helpers ─────────────────────────────────────────────────

  Future<List<String>> _activeProductIds() async {
    final products = await _repo.getCatalog();
    return products.map((p) => p.id).toList();
  }
}

double? _asDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString());
}

class CatalogSyncSummary {
  const CatalogSyncSummary({
    required this.categories,
    required this.suppliers,
    required this.variants,
    required this.modifierGroups,
    required this.modifierOptions,
    required this.productSuppliers,
  });

  final int categories;
  final int suppliers;
  final int variants;
  final int modifierGroups;
  final int modifierOptions;
  final int productSuppliers;

  @override
  String toString() => 'CatalogSyncSummary('
      'categories: $categories, suppliers: $suppliers, '
      'variants: $variants, modifierGroups: $modifierGroups, '
      'modifierOptions: $modifierOptions, productSuppliers: $productSuppliers)';
}

/// Pure-data result returned by [parseModifierResponse]; exposed so
/// it can be unit-tested without touching the database.
class ParsedModifiers {
  const ParsedModifiers({required this.groups, required this.options});

  final List<LocalModifierGroupsCompanion> groups;
  final List<LocalModifierOptionsCompanion> options;
}

/// Builds Drift companions from the raw `data` list returned by
/// `GET /catalog/products/:id/modifiers`. Tolerates malformed
/// entries (missing id, non-map nodes, missing options array)
/// without throwing.
ParsedModifiers parseModifierResponse(String productId, List<dynamic> raw) {
  final groupCompanions = <LocalModifierGroupsCompanion>[];
  final optionCompanions = <LocalModifierOptionsCompanion>[];

  for (final entry in raw) {
    if (entry is! Map<String, dynamic>) continue;
    final id = entry['id']?.toString();
    if (id == null) continue;

    groupCompanions.add(LocalModifierGroupsCompanion(
      id: Value(id),
      productId: Value(productId),
      name: Value(entry['name']?.toString() ?? ''),
      nameAr: Value(entry['name_ar']?.toString()),
      minSelect: Value((entry['min_select'] as num?)?.toInt() ?? 0),
      maxSelect: Value((entry['max_select'] as num?)?.toInt()),
      isRequired: Value(entry['is_required'] == true),
      sortOrder: Value((entry['sort_order'] as num?)?.toInt() ?? 0),
    ));

    final options = entry['options'];
    if (options is! List) continue;
    for (final opt in options) {
      if (opt is! Map<String, dynamic>) continue;
      final optId = opt['id']?.toString();
      if (optId == null) continue;
      optionCompanions.add(LocalModifierOptionsCompanion(
        id: Value(optId),
        groupId: Value(id),
        name: Value(opt['name']?.toString() ?? ''),
        nameAr: Value(opt['name_ar']?.toString()),
        priceDelta: Value(_asDouble(opt['price_adjustment']) ?? 0),
        sortOrder: Value((opt['sort_order'] as num?)?.toInt() ?? 0),
        isActive: Value(opt['is_active'] != false),
      ));
    }
  }

  return ParsedModifiers(groups: groupCompanions, options: optionCompanions);
}
