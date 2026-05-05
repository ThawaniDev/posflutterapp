/// Integration tests for the Barcode Label Printing feature.
/// These tests exercise multiple steps in sequence, verifying that
/// the state management, repository, and model layers compose correctly.
///
/// These tests use a FakeLabelRepository (no HTTP, no device) and
/// therefore run quickly in CI without network access.

// ignore_for_file: subtype_of_sealed_class
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/providers/label_providers.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';
import 'package:wameedpos/features/labels/services/quick_print_service.dart';

import '_fake_label_repository.dart';

// ─── Fixtures ────────────────────────────────────────────────────

LabelTemplate _template({
  String id = 't1',
  String name = 'Template',
  bool isDefault = false,
  bool isPreset = false,
  double width = 50.0,
  double height = 30.0,
}) =>
    LabelTemplate(
      id: id,
      organizationId: 'org-1',
      name: name,
      labelWidthMm: width,
      labelHeightMm: height,
      layoutJson: const {},
      isPreset: isPreset,
      isDefault: isDefault,
      syncVersion: 1,
    );

LabelPrintHistory _history({String id = 'h1', String? templateId}) => LabelPrintHistory(
      id: id,
      storeId: 's1',
      templateId: templateId,
      productCount: 3,
      totalLabels: 6,
      printedBy: 'u1',
      printedAt: DateTime.now(),
    );

// ─── Tests ──────────────────────────────────────────────────────

void main() {
  late FakeLabelRepository repo;

  setUp(() {
    repo = FakeLabelRepository();
  });

  ProviderContainer makeContainer() => ProviderContainer(
        overrides: [labelRepositoryProvider.overrideWithValue(repo)],
      );

  // ══════════════════════════════════════════════════════════════
  // Flow 1: Load → Duplicate → Verify state appended
  // ══════════════════════════════════════════════════════════════

  group('Flow: load → duplicate', () {
    test('loading then duplicating template appends copy to list', () async {
      final original = _template(id: 'orig', name: 'Original');
      final copy = _template(id: 'copy', name: 'Original (Copy)');

      repo.listResult = [original];
      repo.duplicateResult = copy;

      final container = makeContainer();
      final notifier = container.read(labelTemplatesProvider.notifier);

      await notifier.load();
      expect((container.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates, hasLength(1));

      final result = await notifier.duplicateTemplate('orig');
      expect(result, isTrue);
      expect(repo.lastDuplicatedId, 'orig');

      final loaded = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(loaded.templates, hasLength(2));
      expect(loaded.templates.map((t) => t.name), contains('Original (Copy)'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 2: Load → SetDefault → Verify exclusivity
  // ══════════════════════════════════════════════════════════════

  group('Flow: load → setDefault', () {
    test('setting default on one template clears others', () async {
      final t1 = _template(id: 't1', isDefault: true);
      final t2 = _template(id: 't2', isDefault: false);
      final t3 = _template(id: 't3', isDefault: false);
      final updatedT3 = _template(id: 't3', isDefault: true);

      repo.listResult = [t1, t2, t3];
      repo.setDefaultResult = updatedT3;

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      await container.read(labelTemplatesProvider.notifier).setDefaultTemplate('t3');

      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      final defaultTemplates = state.templates.where((t) => t.isDefault == true).toList();
      expect(defaultTemplates, hasLength(1));
      expect(defaultTemplates.first.id, 't3');
    });

    test('setDefault returns true and API is called once', () async {
      repo.listResult = [_template(id: 't1', isDefault: false)];
      repo.setDefaultResult = _template(id: 't1', isDefault: true);

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      final ok = await container.read(labelTemplatesProvider.notifier).setDefaultTemplate('t1');

      expect(ok, isTrue);
      expect(repo.lastSetDefaultId, 't1');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 3: Load → Delete → Verify removed
  // ══════════════════════════════════════════════════════════════

  group('Flow: load → delete', () {
    test('deleting a template triggers reload and state updates', () async {
      final t1 = _template(id: 't1');
      final t2 = _template(id: 't2');

      // queue: first load returns [t1, t2], reload after delete returns [t2]
      repo.listQueue = [[t1, t2], [t2]];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      expect((container.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates, hasLength(2));

      await container.read(labelTemplatesProvider.notifier).deleteTemplate('t1');
      expect(repo.lastDeletedId, 't1');
      expect((container.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates, hasLength(1));
      expect((container.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates.first.id, 't2');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 4: Load presets → loadPresets merged with templates
  // ══════════════════════════════════════════════════════════════

  group('Flow: load templates + presets', () {
    test('loadPresets merges presets into existing loaded state', () async {
      repo.listResult = [_template(id: 'c1', name: 'My Custom')];
      repo.presetsResult = [_template(id: 'p1', name: 'Standard Product', isPreset: true)];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      await container.read(labelTemplatesProvider.notifier).loadPresets();

      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(state.templates, hasLength(1));
      expect(state.templates.first.id, 'c1');
      expect(state.presets, hasLength(1));
      expect(state.presets.first.isPreset, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 5: Create template → load → template visible
  // ══════════════════════════════════════════════════════════════

  group('Flow: create → reload', () {
    test('saving new template and reloading shows it in list', () async {
      final newTemplate = _template(id: 'new1', name: 'Fresh Label');
      repo.createResult = newTemplate;
      repo.listResult = [newTemplate];

      final container = makeContainer();

      // Save new template
      await container.read(labelDetailProvider(null).notifier).save({
        'name': 'Fresh Label',
        'label_width_mm': 50,
        'label_height_mm': 30,
        'layout_json': <String, dynamic>{},
      });

      final detailState = container.read(labelDetailProvider(null));
      expect(detailState, isA<LabelDetailSaved>());
      expect((detailState as LabelDetailSaved).template.name, 'Fresh Label');

      // Reload template list
      await container.read(labelTemplatesProvider.notifier).load();
      final listState = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(listState.templates.first.name, 'Fresh Label');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 6: History load with filters
  // ══════════════════════════════════════════════════════════════

  group('Flow: load history with filters', () {
    test('history notifier filters by date range', () async {
      final from = DateTime(2024, 1, 1);
      final to = DateTime(2024, 1, 31);
      repo.historyResult = [_history(id: 'h-jan')];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load(from: from, to: to);

      final state = container.read(labelHistoryProvider) as LabelHistoryLoaded;
      expect(state.history, hasLength(1));
      expect(state.history.first.id, 'h-jan');
      expect(repo.lastHistoryFrom, from);
      expect(repo.lastHistoryTo, to);
    });

    test('history notifier filters by templateId', () async {
      repo.historyResult = [_history(id: 'h-t2', templateId: 't2')];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load(templateId: 't2');

      final state = container.read(labelHistoryProvider) as LabelHistoryLoaded;
      expect(state.history.first.templateId, 't2');
      expect(repo.lastHistoryTemplateId, 't2');
    });

    test('history can be reloaded with different filters', () async {
      // First load (no filter): returns 2 items
      // Second load (with templateId): returns 1 item
      // Use listQueue-style approach via direct result overwrite
      repo.historyResult = [_history(id: 'all'), _history(id: 'all2')];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load();
      expect((container.read(labelHistoryProvider) as LabelHistoryLoaded).history, hasLength(2));

      repo.historyResult = [_history(id: 'filtered', templateId: 't1')];
      await container.read(labelHistoryProvider.notifier).load(templateId: 't1');
      expect((container.read(labelHistoryProvider) as LabelHistoryLoaded).history, hasLength(1));
      expect((container.read(labelHistoryProvider) as LabelHistoryLoaded).history.first.id, 'filtered');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 7: Quick print template resolution
  // ══════════════════════════════════════════════════════════════

  group('Flow: quick print template resolution', () {
    test('resolveQuickPrintTemplate returns explicit template by id', () {
      final t1 = _template(id: 'explicit', isDefault: false);
      final t2 = _template(id: 'default', isDefault: true);

      final result = resolveQuickPrintTemplate([t1, t2], templateId: 'explicit');
      expect(result?.id, 'explicit');
    });

    test('resolveQuickPrintTemplate falls back to default template', () {
      final t1 = _template(id: 't1', isDefault: false);
      final t2 = _template(id: 'default-tpl', isDefault: true);

      final result = resolveQuickPrintTemplate([t1, t2]);
      expect(result?.id, 'default-tpl');
    });

    test('resolveQuickPrintTemplate falls back to first preset when no default', () {
      final t1 = _template(id: 'custom', isDefault: false, isPreset: false);
      final t2 = _template(id: 'preset', isDefault: false, isPreset: true);

      final result = resolveQuickPrintTemplate([t1, t2]);
      expect(result?.id, 'preset');
    });

    test('resolveQuickPrintTemplate falls back to any first template', () {
      final t = _template(id: 'only-one', isDefault: false, isPreset: false);
      final result = resolveQuickPrintTemplate([t]);
      expect(result?.id, 'only-one');
    });

    test('resolveQuickPrintTemplate returns null for empty list', () {
      expect(resolveQuickPrintTemplate([]), isNull);
    });

    test('resolveQuickPrintTemplate ignores invalid template id and falls back', () {
      final t1 = _template(id: 't1', isDefault: true);
      // Non-existent id → should fall back to default
      final result = resolveQuickPrintTemplate([t1], templateId: 'non-existent-uuid');
      expect(result?.id, 't1');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 8: EAN-13 barcode generation (weighable items)
  // ══════════════════════════════════════════════════════════════

  group('Flow: EAN-13 weighable barcode', () {
    test('generated barcode passes EAN-13 checksum validation', () {
      final code = buildWeighableEan13(prefix: 21, plu: 1234, payload: 10050);
      expect(code.length, 13);

      // Verify EAN-13 Luhn checksum
      final digits = code.split('').map(int.parse).toList();
      final sum = digits.indexed.fold(0, (acc, entry) {
        final (i, d) = entry;
        return acc + (i.isEven ? d : d * 3);
      });
      expect(sum % 10, 0, reason: 'EAN-13 checksum must be divisible by 10');
    });

    test('price 1.500 KWD encodes as 01500 in payload positions', () {
      // payload=1500 → positions 7-11 = "01500"
      final code = buildWeighableEan13(prefix: 21, plu: 1234, payload: 1500);
      expect(code.substring(7, 12), '01500');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 9: Error recovery
  // ══════════════════════════════════════════════════════════════

  group('Flow: error recovery', () {
    test('after error, successful load replaces error state', () async {
      // First call throws, second succeeds
      repo.listError = Exception('Network error');

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      expect(container.read(labelTemplatesProvider), isA<LabelTemplatesError>());

      repo.listError = null;
      repo.listResult = [_template()];
      await container.read(labelTemplatesProvider.notifier).load();
      expect(container.read(labelTemplatesProvider), isA<LabelTemplatesLoaded>());
    });

    test('after error in duplicate, state is LabelTemplatesError', () async {
      repo.listResult = [_template(id: 't1')];
      repo.duplicateError = Exception('Server failure');

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      final ok = await container.read(labelTemplatesProvider.notifier).duplicateTemplate('t1');

      expect(ok, isFalse);
      expect(container.read(labelTemplatesProvider), isA<LabelTemplatesError>());
    });

    test('history load error is recoverable', () async {
      repo.historyError = Exception('Timeout');

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load();
      expect(container.read(labelHistoryProvider), isA<LabelHistoryError>());

      repo.historyError = null;
      repo.historyResult = [_history()];
      await container.read(labelHistoryProvider.notifier).load();
      expect(container.read(labelHistoryProvider), isA<LabelHistoryLoaded>());
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Flow 10: LabelTemplate model immutability + copyWith
  // ══════════════════════════════════════════════════════════════

  group('LabelTemplate copyWith', () {
    test('copyWith produces independent instance', () {
      final original = _template(id: 'orig', isDefault: false);
      final modified = original.copyWith(isDefault: true);

      expect(original.isDefault, isFalse);
      expect(modified.isDefault, isTrue);
      expect(original.id, modified.id); // same id
    });

    test('copyWith preserves unchanged fields', () {
      final original = _template(id: 'x', name: 'My Label', width: 75.0, height: 45.0);
      final modified = original.copyWith(name: 'Renamed');

      expect(modified.labelWidthMm, 75.0);
      expect(modified.labelHeightMm, 45.0);
      expect(modified.organizationId, 'org-1');
    });
  });
}
