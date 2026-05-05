// ignore_for_file: subtype_of_sealed_class
/// Shared fake [LabelRepository] for label feature tests.
///
/// Using `extends Fake` (from mockito) satisfies Dart null-safety without
/// needing code generation. Any method not overridden here throws
/// [UnimplementedError], so test failures are explicit.
library;

import 'package:mockito/mockito.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

class FakeLabelRepository extends Fake implements LabelRepository {
  // ── Configurable responses ──────────────────────────────────────
  List<List<LabelTemplate>> listQueue = []; // sequential results, each pop
  List<LabelTemplate> listResult = const []; // used when queue is empty
  List<LabelTemplate> presetsResult = const [];
  final Map<String, LabelTemplate> getResultById = {};
  LabelTemplate? createResult;
  LabelTemplate? updateResult;
  LabelTemplate? duplicateResult;
  LabelTemplate? setDefaultResult;
  List<LabelPrintHistory> historyResult = const [];

  // ── Errors to throw ────────────────────────────────────────────
  Exception? listError;
  Exception? presetsError;
  Exception? getError;
  Exception? createError;
  Exception? updateError;
  Exception? duplicateError;
  Exception? historyError;
  Exception? statsError;

  // ── Stats-specific response ─────────────────────────────────────
  LabelPrintStats? statsResult;
  List<LabelPrintStats> statsQueue = [];

  // ── Call tracking ──────────────────────────────────────────────
  int listCallCount = 0;
  String? lastListSearch;
  String? lastListType;
  String? lastDeletedId;
  String? lastDuplicatedId;
  String? lastSetDefaultId;
  Map<String, dynamic>? lastCreatePayload;
  String? lastUpdateId;
  Map<String, dynamic>? lastUpdatePayload;
  DateTime? lastHistoryFrom;
  DateTime? lastHistoryTo;
  String? lastHistoryTemplateId;
  int? lastHistoryPerPage;

  // ── Implementations ─────────────────────────────────────────────

  @override
  Future<List<LabelTemplate>> listTemplates({String? search, String? type}) async {
    listCallCount++;
    lastListSearch = search;
    lastListType = type;
    if (listError != null) throw listError!;
    if (listQueue.isNotEmpty) return listQueue.removeAt(0);
    return listResult;
  }

  @override
  Future<List<LabelTemplate>> getPresets() async {
    if (presetsError != null) throw presetsError!;
    return presetsResult;
  }

  @override
  Future<LabelTemplate> getTemplate(String id) async {
    if (getError != null) throw getError!;
    return getResultById[id] ?? (throw StateError('FakeLabelRepository: no stub for getTemplate($id)'));
  }

  @override
  Future<LabelTemplate> createTemplate(Map<String, dynamic> data) async {
    lastCreatePayload = data;
    if (createError != null) throw createError!;
    return createResult ?? (throw StateError('FakeLabelRepository: createResult not set'));
  }

  @override
  Future<LabelTemplate> updateTemplate(String id, Map<String, dynamic> data) async {
    lastUpdateId = id;
    lastUpdatePayload = data;
    if (updateError != null) throw updateError!;
    return updateResult ?? (throw StateError('FakeLabelRepository: updateResult not set'));
  }

  @override
  Future<void> deleteTemplate(String id) async {
    lastDeletedId = id;
  }

  @override
  Future<LabelTemplate> duplicateTemplate(String id) async {
    lastDuplicatedId = id;
    if (duplicateError != null) throw duplicateError!;
    return duplicateResult ?? (throw StateError('FakeLabelRepository: duplicateResult not set'));
  }

  @override
  Future<LabelTemplate> setDefaultTemplate(String id) async {
    lastSetDefaultId = id;
    return setDefaultResult ?? (throw StateError('FakeLabelRepository: setDefaultResult not set'));
  }

  @override
  Future<List<LabelPrintHistory>> getPrintHistory({DateTime? from, DateTime? to, String? templateId, int? perPage}) async {
    lastHistoryFrom = from;
    lastHistoryTo = to;
    lastHistoryTemplateId = templateId;
    lastHistoryPerPage = perPage;
    if (historyError != null) throw historyError!;
    return historyResult;
  }

  @override
  Future<void> recordPrint(Map<String, dynamic> data) async {}

  @override
  Future<LabelPrintStats> getPrintHistoryStats() async {
    if (statsError != null) throw statsError!;
    if (statsQueue.isNotEmpty) return statsQueue.removeAt(0);
    return statsResult ?? LabelPrintStats.empty();
  }
}
