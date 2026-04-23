import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:wameedpos/features/labels/data/local/label_template_dao.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

/// Coordinates label-template persistence between the server and the local
/// Drift cache, and tracks the last-used printer preference.
///
/// Responsibilities (from feature spec):
///  * Rule #9 — Templates are read offline from Drift; refreshed from server
///    when online and re-cached.
///  * Rule #10 — Last-used printer ID is persisted across sessions.
///  * Rule #8 — Local print history is pruned to 90 days.
class OfflineLabelService {
  OfflineLabelService({
    required LabelRepository remote,
    required LabelTemplateDao dao,
    required Future<SharedPreferences> Function() prefsFactory,
  })  : _remote = remote,
        _dao = dao,
        _prefsFactory = prefsFactory;

  final LabelRepository _remote;
  final LabelTemplateDao _dao;
  final Future<SharedPreferences> Function() _prefsFactory;

  static const _kLastPrinterKey = 'labels.last_printer_id';
  static const _kLastTemplateKey = 'labels.last_template_id';

  // ─── Templates ──────────────────────────────────────────────

  /// Returns the currently cached templates immediately. Caller may listen to
  /// [refreshTemplates] for an updated list once network responds.
  Future<List<LabelTemplate>> cachedTemplates(String organizationId) =>
      _dao.listTemplates(organizationId);

  /// Pulls templates from the API, replaces the cache for the org and
  /// returns the fresh list. Falls back to the cache on network failure.
  Future<List<LabelTemplate>> refreshTemplates(String organizationId) async {
    try {
      final remote = await _remote.listTemplates();
      final scoped = remote.where((t) => t.organizationId == organizationId).toList();
      await _dao.upsertTemplates(scoped);
      return scoped;
    } catch (_) {
      return _dao.listTemplates(organizationId);
    }
  }

  Future<LabelTemplate?> defaultTemplate(String organizationId) =>
      _dao.getDefaultTemplate(organizationId);

  // ─── Printer preference ────────────────────────────────────

  Future<String?> lastPrinterId() async {
    final p = await _prefsFactory();
    return p.getString(_kLastPrinterKey);
  }

  Future<void> setLastPrinterId(String id) async {
    final p = await _prefsFactory();
    await p.setString(_kLastPrinterKey, id);
  }

  Future<String?> lastTemplateId() async {
    final p = await _prefsFactory();
    return p.getString(_kLastTemplateKey);
  }

  Future<void> setLastTemplateId(String id) async {
    final p = await _prefsFactory();
    await p.setString(_kLastTemplateKey, id);
  }

  // ─── Print history ─────────────────────────────────────────

  /// Record a print job locally (always succeeds, even offline) and try to
  /// flush to the server. The local row is marked synced on success.
  Future<void> recordPrint({
    String? templateId,
    String? printerName,
    required int productCount,
    required int totalLabels,
  }) async {
    final id = const Uuid().v4();
    await _dao.recordLocalPrint(
      id: id,
      templateId: templateId,
      printerName: printerName,
      productCount: productCount,
      totalLabels: totalLabels,
    );
    try {
      await _remote.recordPrint({
        'template_id': templateId,
        'printer_name': printerName,
        'product_count': productCount,
        'total_labels': totalLabels,
      });
      await _dao.markSynced(id);
    } catch (_) {
      // Will be retried on next online sync — leave unsynced.
    }
    // Opportunistic prune.
    unawaited(_dao.pruneOldHistory());
  }
}

final offlineLabelServiceProvider = Provider<OfflineLabelService>((ref) {
  return OfflineLabelService(
    remote: ref.watch(labelRepositoryProvider),
    dao: ref.watch(labelTemplateDaoProvider),
    prefsFactory: SharedPreferences.getInstance,
  );
});
