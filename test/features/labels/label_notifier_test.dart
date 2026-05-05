// ignore_for_file: subtype_of_sealed_class
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/providers/label_providers.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

import '_fake_label_repository.dart';

// ─── Helpers ────────────────────────────────────────────────────

LabelTemplate fakeTemplate({
  String id = 't1',
  String name = 'Test Template',
  bool isDefault = false,
  bool isPreset = false,
}) =>
    LabelTemplate(
      id: id,
      organizationId: 'org-1',
      name: name,
      labelWidthMm: 50,
      labelHeightMm: 30,
      layoutJson: const {},
      isPreset: isPreset,
      isDefault: isDefault,
      syncVersion: 1,
    );

LabelPrintHistory fakeHistory({String id = 'h1'}) => LabelPrintHistory(
      id: id,
      storeId: 's1',
      printedBy: 'u1',
      productCount: 3,
      totalLabels: 6,
      printedAt: DateTime.now(),
    );

// ─── Tests ──────────────────────────────────────────────────────

void main() {
  late FakeLabelRepository repo;

  setUp(() {
    repo = FakeLabelRepository();
  });

  // ══════════════════════════════════════════════════════════════
  // LabelTemplatesNotifier
  // ══════════════════════════════════════════════════════════════

  group('LabelTemplatesNotifier', () {
    ProviderContainer makeContainer() => ProviderContainer(
          overrides: [labelRepositoryProvider.overrideWithValue(repo)],
        );

    test('initial state is LabelTemplatesInitial', () {
      expect(makeContainer().read(labelTemplatesProvider), isA<LabelTemplatesInitial>());
    });

    test('load transitions to Loaded with templates', () async {
      repo.listResult = [fakeTemplate(id: 't1'), fakeTemplate(id: 't2')];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();

      final state = container.read(labelTemplatesProvider);
      expect(state, isA<LabelTemplatesLoaded>());
      expect((state as LabelTemplatesLoaded).templates, hasLength(2));
    });

    test('load passes search param to repository', () async {
      repo.listResult = [];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load(search: 'barcode');

      expect(repo.lastListSearch, 'barcode');
    });

    test('load passes type param to repository', () async {
      repo.listResult = [];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load(type: 'preset');

      expect(repo.lastListType, 'preset');
    });

    test('load transitions to Error on exception', () async {
      repo.listError = Exception('Network error');

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();

      expect(container.read(labelTemplatesProvider), isA<LabelTemplatesError>());
    });

    test('loadPresets updates presets in loaded state', () async {
      repo.listResult = [fakeTemplate(id: 't1')];
      repo.presetsResult = [fakeTemplate(id: 'p1', isPreset: true)];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      await container.read(labelTemplatesProvider.notifier).loadPresets();

      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(state.presets, hasLength(1));
      expect(state.presets.first.id, 'p1');
    });

    test('loadPresets does nothing if state is not Loaded', () async {
      final container = makeContainer();
      // State is still Initial — load() never called
      await container.read(labelTemplatesProvider.notifier).loadPresets();

      expect(container.read(labelTemplatesProvider), isA<LabelTemplatesInitial>());
    });

    test('deleteTemplate calls repo delete and reloads', () async {
      repo.listQueue = [
        [fakeTemplate(id: 't1'), fakeTemplate(id: 't2')], // initial load
        [fakeTemplate(id: 't2')],                          // reload post-delete
      ];

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      await container.read(labelTemplatesProvider.notifier).deleteTemplate('t1');

      expect(repo.lastDeletedId, 't1');
      expect(repo.listCallCount, 2);
      expect(
        (container.read(labelTemplatesProvider) as LabelTemplatesLoaded).templates,
        hasLength(1),
      );
    });

    test('duplicateTemplate appends copy to current list', () async {
      repo.listResult = [fakeTemplate(id: 't1', name: 'Original')];
      repo.duplicateResult = fakeTemplate(id: 't2', name: 'Original (Copy)');

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      final result = await container.read(labelTemplatesProvider.notifier).duplicateTemplate('t1');

      expect(result, isTrue);
      expect(repo.lastDuplicatedId, 't1');
      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(state.templates, hasLength(2));
      expect(state.templates.last.name, 'Original (Copy)');
    });

    test('duplicateTemplate returns false on error', () async {
      repo.listResult = [fakeTemplate()];
      repo.duplicateError = Exception('Duplicate failed');

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      final result = await container.read(labelTemplatesProvider.notifier).duplicateTemplate('t1');

      expect(result, isFalse);
    });

    test('setDefaultTemplate updates isDefault flags in list', () async {
      repo.listResult = [
        fakeTemplate(id: 't1', isDefault: true),
        fakeTemplate(id: 't2', isDefault: false),
      ];
      repo.setDefaultResult = fakeTemplate(id: 't2', isDefault: true);

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      final result = await container.read(labelTemplatesProvider.notifier).setDefaultTemplate('t2');

      expect(result, isTrue);
      expect(repo.lastSetDefaultId, 't2');
      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      final defaults = state.templates.where((t) => t.isDefault == true).toList();
      expect(defaults, hasLength(1));
      expect(defaults.first.id, 't2');
    });

    test('setDefaultTemplate clears previous default', () async {
      repo.listResult = [
        fakeTemplate(id: 't1', isDefault: true),
        fakeTemplate(id: 't2', isDefault: false),
      ];
      repo.setDefaultResult = fakeTemplate(id: 't2', isDefault: true);

      final container = makeContainer();
      await container.read(labelTemplatesProvider.notifier).load();
      await container.read(labelTemplatesProvider.notifier).setDefaultTemplate('t2');

      final state = container.read(labelTemplatesProvider) as LabelTemplatesLoaded;
      expect(state.templates.firstWhere((t) => t.id == 't1').isDefault, isFalse);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // LabelDetailNotifier
  // ══════════════════════════════════════════════════════════════

  group('LabelDetailNotifier', () {
    ProviderContainer makeContainer() => ProviderContainer(
          overrides: [labelRepositoryProvider.overrideWithValue(repo)],
        );

    test('initial state is LabelDetailInitial', () {
      expect(makeContainer().read(labelDetailProvider(null)), isA<LabelDetailInitial>());
    });

    test('load transitions to Loaded with template', () async {
      repo.getResultById['dt1'] = fakeTemplate(id: 'dt1');

      final container = makeContainer();
      await container.read(labelDetailProvider('dt1').notifier).load();

      final state = container.read(labelDetailProvider('dt1'));
      expect(state, isA<LabelDetailLoaded>());
      expect((state as LabelDetailLoaded).template.id, 'dt1');
    });

    test('load does nothing when templateId is null', () async {
      final container = makeContainer();
      await container.read(labelDetailProvider(null).notifier).load();

      // State never advanced past Initial
      expect(container.read(labelDetailProvider(null)), isA<LabelDetailInitial>());
    });

    test('load transitions to Error on failure', () async {
      repo.getError = Exception('Not found');

      final container = makeContainer();
      await container.read(labelDetailProvider('err').notifier).load();

      expect(container.read(labelDetailProvider('err')), isA<LabelDetailError>());
    });

    test('save creates template when no templateId', () async {
      repo.createResult = fakeTemplate(id: 'new1', name: 'New');

      final container = makeContainer();
      await container.read(labelDetailProvider(null).notifier).save({
        'name': 'New',
        'label_width_mm': 50,
        'label_height_mm': 30,
        'layout_json': <String, dynamic>{},
      });

      final state = container.read(labelDetailProvider(null));
      expect(state, isA<LabelDetailSaved>());
      expect((state as LabelDetailSaved).template.id, 'new1');
      expect(repo.lastCreatePayload?['name'], 'New');
    });

    test('save updates template when templateId is present', () async {
      repo.getResultById['existing'] = fakeTemplate(id: 'existing');
      repo.updateResult = fakeTemplate(id: 'existing', name: 'Updated');

      final container = makeContainer();
      await container.read(labelDetailProvider('existing').notifier).load();
      await container.read(labelDetailProvider('existing').notifier).save({'name': 'Updated'});

      final state = container.read(labelDetailProvider('existing'));
      expect(state, isA<LabelDetailSaved>());
      expect((state as LabelDetailSaved).template.name, 'Updated');
      expect(repo.lastUpdateId, 'existing');
      expect(repo.lastUpdatePayload?['name'], 'Updated');
    });

    test('save transitions to Error on failure', () async {
      repo.createError = Exception('Server error');

      final container = makeContainer();
      await container.read(labelDetailProvider(null).notifier).save({'name': 'Fail'});

      expect(container.read(labelDetailProvider(null)), isA<LabelDetailError>());
    });
  });

  // ══════════════════════════════════════════════════════════════
  // LabelHistoryNotifier
  // ══════════════════════════════════════════════════════════════

  group('LabelHistoryNotifier', () {
    ProviderContainer makeContainer() => ProviderContainer(
          overrides: [labelRepositoryProvider.overrideWithValue(repo)],
        );

    test('initial state is LabelHistoryInitial', () {
      expect(makeContainer().read(labelHistoryProvider), isA<LabelHistoryInitial>());
    });

    test('load transitions to Loaded with history', () async {
      repo.historyResult = [fakeHistory(id: 'h1'), fakeHistory(id: 'h2')];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load();

      final state = container.read(labelHistoryProvider);
      expect(state, isA<LabelHistoryLoaded>());
      expect((state as LabelHistoryLoaded).history, hasLength(2));
    });

    test('load passes date range to repository', () async {
      final from = DateTime(2024, 1, 1);
      final to = DateTime(2024, 1, 31);
      repo.historyResult = [];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load(from: from, to: to);

      expect(repo.lastHistoryFrom, from);
      expect(repo.lastHistoryTo, to);
    });

    test('load passes templateId filter to repository', () async {
      repo.historyResult = [];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load(templateId: 'tmpl-id');

      expect(repo.lastHistoryTemplateId, 'tmpl-id');
    });

    test('load transitions to Error on exception', () async {
      repo.historyError = Exception('Timeout');

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load();

      expect(container.read(labelHistoryProvider), isA<LabelHistoryError>());
    });

    test('empty history produces empty Loaded state', () async {
      repo.historyResult = [];

      final container = makeContainer();
      await container.read(labelHistoryProvider.notifier).load();

      expect((container.read(labelHistoryProvider) as LabelHistoryLoaded).history, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // LabelPrintStatsNotifier
  // ══════════════════════════════════════════════════════════════

  group('LabelPrintStatsNotifier', () {
    ProviderContainer makeContainer() => ProviderContainer(
          overrides: [labelRepositoryProvider.overrideWithValue(repo)],
        );

    test('initial state is LabelPrintStatsInitial', () {
      expect(makeContainer().read(labelPrintStatsProvider), isA<LabelPrintStatsInitial>());
    });

    test('load transitions through Loading to Loaded', () async {
      repo.statsResult = const LabelPrintStats(
        jobsLast30Days: 3,
        productsLast30Days: 9,
        labelsLast30Days: 27,
      );

      final container = makeContainer();
      await container.read(labelPrintStatsProvider.notifier).load();

      final state = container.read(labelPrintStatsProvider);
      expect(state, isA<LabelPrintStatsLoaded>());
      final loaded = state as LabelPrintStatsLoaded;
      expect(loaded.stats.jobsLast30Days, 3);
      expect(loaded.stats.productsLast30Days, 9);
      expect(loaded.stats.labelsLast30Days, 27);
    });

    test('load returns zero stats when history is empty', () async {
      repo.statsResult = LabelPrintStats.empty();

      final container = makeContainer();
      await container.read(labelPrintStatsProvider.notifier).load();

      final state = container.read(labelPrintStatsProvider) as LabelPrintStatsLoaded;
      expect(state.stats.jobsLast30Days, 0);
      expect(state.stats.productsLast30Days, 0);
      expect(state.stats.labelsLast30Days, 0);
    });

    test('load transitions to Error on exception', () async {
      repo.statsError = Exception('Network error');

      final container = makeContainer();
      await container.read(labelPrintStatsProvider.notifier).load();

      final state = container.read(labelPrintStatsProvider);
      expect(state, isA<LabelPrintStatsError>());
      expect((state as LabelPrintStatsError).message, contains('Network error'));
    });

    test('load can be called multiple times and updates state', () async {
      repo.statsQueue = [
        const LabelPrintStats(jobsLast30Days: 1, productsLast30Days: 2, labelsLast30Days: 4),
        const LabelPrintStats(jobsLast30Days: 5, productsLast30Days: 10, labelsLast30Days: 20),
      ];

      final container = makeContainer();
      await container.read(labelPrintStatsProvider.notifier).load();
      await container.read(labelPrintStatsProvider.notifier).load();

      final state = container.read(labelPrintStatsProvider) as LabelPrintStatsLoaded;
      // Second call's result wins
      expect(state.stats.jobsLast30Days, 5);
    });
  });
}
