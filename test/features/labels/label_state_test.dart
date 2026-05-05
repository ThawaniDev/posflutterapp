import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/providers/label_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // LabelTemplatesState Tests
  // ═══════════════════════════════════════════════════════════════

  group('LabelTemplatesState', () {
    test('LabelTemplatesInitial is default state', () {
      const state = LabelTemplatesInitial();
      expect(state, isA<LabelTemplatesState>());
    });

    test('LabelTemplatesLoading indicates loading', () {
      const state = LabelTemplatesLoading();
      expect(state, isA<LabelTemplatesState>());
    });

    test('LabelTemplatesLoaded holds templates', () {
      final templates = [
        const LabelTemplate(
          id: 'lt1',
          organizationId: 'o1',
          name: 'Price Tag',
          labelWidthMm: 50.0,
          labelHeightMm: 30.0,
          layoutJson: {'type': 'price'},
          isPreset: false,
        ),
        const LabelTemplate(
          id: 'lt2',
          organizationId: 'o1',
          name: 'Barcode',
          labelWidthMm: 40.0,
          labelHeightMm: 20.0,
          layoutJson: {'type': 'barcode'},
          isPreset: true,
        ),
      ];

      final state = LabelTemplatesLoaded(templates: templates);
      expect(state, isA<LabelTemplatesState>());
      expect(state.templates, hasLength(2));
      expect(state.presets, isEmpty);
    });

    test('LabelTemplatesLoaded copyWith replaces fields', () {
      final templates = [
        const LabelTemplate(
          id: 'lt1',
          organizationId: 'o1',
          name: 'Price Tag',
          labelWidthMm: 50.0,
          labelHeightMm: 30.0,
          layoutJson: {'type': 'price'},
        ),
      ];

      final presets = [
        const LabelTemplate(
          id: 'lt-preset',
          organizationId: 'system',
          name: 'Default Preset',
          labelWidthMm: 60.0,
          labelHeightMm: 40.0,
          layoutJson: {'type': 'default'},
          isPreset: true,
        ),
      ];

      final state = LabelTemplatesLoaded(templates: templates);
      final updated = state.copyWith(presets: presets);

      expect(updated.templates, hasLength(1));
      expect(updated.presets, hasLength(1));
      expect(updated.presets.first.name, 'Default Preset');
    });

    test('LabelTemplatesError holds message', () {
      const state = LabelTemplatesError(message: 'Network error');
      expect(state, isA<LabelTemplatesState>());
      expect(state.message, 'Network error');
    });

    test('sealed class exhaustive switch', () {
      const LabelTemplatesState state = LabelTemplatesLoading();
      final result = switch (state) {
        LabelTemplatesInitial() => 'initial',
        LabelTemplatesLoading() => 'loading',
        LabelTemplatesLoaded(:final templates) => 'loaded:${templates.length}',
        LabelTemplatesError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // LabelDetailState Tests
  // ═══════════════════════════════════════════════════════════════

  group('LabelDetailState', () {
    test('all subtypes are LabelDetailState', () {
      expect(const LabelDetailInitial(), isA<LabelDetailState>());
      expect(const LabelDetailLoading(), isA<LabelDetailState>());
      expect(const LabelDetailSaving(), isA<LabelDetailState>());
      expect(const LabelDetailError(message: 'e'), isA<LabelDetailState>());
    });

    test('LabelDetailLoaded holds template', () {
      const template = LabelTemplate(
        id: 'lt1',
        organizationId: 'o1',
        name: 'Price Tag 50x30',
        labelWidthMm: 50.0,
        labelHeightMm: 30.0,
        layoutJson: {
          'fields': ['name', 'price', 'barcode'],
        },
      );
      const state = LabelDetailLoaded(template: template);
      expect(state.template.name, 'Price Tag 50x30');
      expect(state.template.labelWidthMm, 50.0);
      expect(state.template.labelHeightMm, 30.0);
    });

    test('LabelDetailSaved holds saved template', () {
      const template = LabelTemplate(
        id: 'lt1',
        organizationId: 'o1',
        name: 'Updated Template',
        labelWidthMm: 60.0,
        labelHeightMm: 40.0,
        layoutJson: {'updated': true},
      );
      const state = LabelDetailSaved(template: template);
      expect(state.template.name, 'Updated Template');
    });

    test('sealed class switch', () {
      const LabelDetailState state = LabelDetailSaving();
      final result = switch (state) {
        LabelDetailInitial() => 'initial',
        LabelDetailLoading() => 'loading',
        LabelDetailLoaded() => 'loaded',
        LabelDetailSaving() => 'saving',
        LabelDetailSaved() => 'saved',
        LabelDetailError(:final message) => 'error:$message',
      };
      expect(result, 'saving');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // LabelPrintStatsState Tests
  // ═══════════════════════════════════════════════════════════════

  group('LabelPrintStatsState', () {
    test('LabelPrintStatsInitial is default state', () {
      const state = LabelPrintStatsInitial();
      expect(state, isA<LabelPrintStatsState>());
    });

    test('LabelPrintStatsLoading indicates loading', () {
      const state = LabelPrintStatsLoading();
      expect(state, isA<LabelPrintStatsState>());
    });

    test('LabelPrintStatsLoaded holds stats', () {
      const stats = LabelPrintStats(jobsLast30Days: 5, productsLast30Days: 15, labelsLast30Days: 45);
      const state = LabelPrintStatsLoaded(stats: stats);
      expect(state, isA<LabelPrintStatsState>());
      expect(state.stats.jobsLast30Days, 5);
      expect(state.stats.productsLast30Days, 15);
      expect(state.stats.labelsLast30Days, 45);
    });

    test('LabelPrintStatsError holds message', () {
      const state = LabelPrintStatsError(message: 'Network error');
      expect(state, isA<LabelPrintStatsState>());
      expect(state.message, 'Network error');
    });

    test('sealed class switch exhaustive', () {
      const LabelPrintStatsState state = LabelPrintStatsLoaded(
        stats: LabelPrintStats(jobsLast30Days: 3, productsLast30Days: 10, labelsLast30Days: 30),
      );
      final result = switch (state) {
        LabelPrintStatsInitial() => 'initial',
        LabelPrintStatsLoading() => 'loading',
        LabelPrintStatsLoaded(:final stats) => 'loaded:${stats.jobsLast30Days}',
        LabelPrintStatsError(:final message) => 'error:$message',
      };
      expect(result, 'loaded:3');
    });
  });
}
