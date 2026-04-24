import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';

/// Data-access layer for offline label-template cache and local print history.
/// Backed by the existing [PosOfflineDatabase] (Drift / SQLite).
///
/// Spec rule #9: label printing must work fully offline. Templates are
/// upserted from the cloud whenever online; reads always hit the cache.
///
/// Spec rule #8: print history is pruned to the last 90 days locally.
class LabelTemplateDao {
  LabelTemplateDao(this._db);
  final PosOfflineDatabase _db;

  static const Duration historyRetention = Duration(days: 90);

  // ─── Templates ─────────────────────────────────────────────

  Future<void> upsertTemplates(List<LabelTemplate> templates) async {
    if (templates.isEmpty) return;
    await _db.batch((b) {
      for (final t in templates) {
        b.insert(
          _db.localLabelTemplates,
          LocalLabelTemplatesCompanion.insert(
            id: t.id,
            organizationId: t.organizationId,
            name: t.name,
            labelWidthMm: t.labelWidthMm,
            labelHeightMm: t.labelHeightMm,
            layoutJson: jsonEncode(t.layoutJson),
            isPreset: Value(t.isPreset ?? false),
            isDefault: Value(t.isDefault ?? false),
            syncVersion: Value(t.syncVersion ?? 1),
            updatedAt: Value(t.updatedAt ?? DateTime.now()),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<List<LabelTemplate>> listTemplates(String organizationId) async {
    final rows =
        await (_db.select(_db.localLabelTemplates)
              ..where((t) => t.organizationId.equals(organizationId))
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return rows.map(_rowToTemplate).toList();
  }

  Future<LabelTemplate?> getTemplate(String id) async {
    final row = await (_db.select(_db.localLabelTemplates)..where((t) => t.id.equals(id))).getSingleOrNull();
    return row == null ? null : _rowToTemplate(row);
  }

  Future<LabelTemplate?> getDefaultTemplate(String organizationId) async {
    final row =
        await (_db.select(_db.localLabelTemplates)
              ..where((t) => t.organizationId.equals(organizationId) & t.isDefault.equals(true))
              ..limit(1))
            .getSingleOrNull();
    return row == null ? null : _rowToTemplate(row);
  }

  Future<int> deleteTemplate(String id) => (_db.delete(_db.localLabelTemplates)..where((t) => t.id.equals(id))).go();

  // ─── Print history ─────────────────────────────────────────

  Future<void> recordLocalPrint({
    required String id,
    String? templateId,
    String? printerName,
    required int productCount,
    required int totalLabels,
  }) async {
    await _db
        .into(_db.localLabelPrintHistory)
        .insert(
          LocalLabelPrintHistoryCompanion.insert(
            id: id,
            templateId: Value(templateId),
            printerName: Value(printerName),
            productCount: productCount,
            totalLabels: totalLabels,
          ),
        );
  }

  Future<void> markSynced(String id) async {
    await (_db.update(
      _db.localLabelPrintHistory,
    )..where((t) => t.id.equals(id))).write(const LocalLabelPrintHistoryCompanion(syncedToServer: Value(true)));
  }

  /// Hard-delete records older than 90 days. Spec rule #8.
  Future<int> pruneOldHistory({DateTime? now}) {
    final cutoff = (now ?? DateTime.now()).subtract(historyRetention);
    return (_db.delete(_db.localLabelPrintHistory)..where((t) => t.printedAt.isSmallerThanValue(cutoff))).go();
  }

  // ─── Mapping ───────────────────────────────────────────────

  LabelTemplate _rowToTemplate(LocalLabelTemplate r) => LabelTemplate(
    id: r.id,
    organizationId: r.organizationId,
    name: r.name,
    labelWidthMm: r.labelWidthMm,
    labelHeightMm: r.labelHeightMm,
    layoutJson: jsonDecode(r.layoutJson) as Map<String, dynamic>,
    isPreset: r.isPreset,
    isDefault: r.isDefault,
    syncVersion: r.syncVersion,
    updatedAt: r.updatedAt,
  );
}

final labelTemplateDaoProvider = Provider<LabelTemplateDao>((ref) {
  return LabelTemplateDao(ref.watch(posOfflineDatabaseProvider));
});
