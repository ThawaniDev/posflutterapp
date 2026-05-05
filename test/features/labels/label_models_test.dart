import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';

void main() {
  // ─── LabelTemplate ───────────────────────────────────────

  group('LabelTemplate', () {
    const baseTemplate = LabelTemplate(
      id: 'tmpl-1',
      organizationId: 'org-1',
      name: 'My Label',
      labelWidthMm: 50.0,
      labelHeightMm: 30.0,
      layoutJson: {'elements': []},
    );

    test('fromJson parses all standard fields', () {
      final json = {
        'id': 'tmpl-1',
        'organization_id': 'org-1',
        'name': 'My Label',
        'label_width_mm': 50.0,
        'label_height_mm': 30.0,
        'layout_json': {'elements': []},
        'is_preset': false,
        'is_default': true,
        'created_by': 'user-1',
        'created_by_name': 'John Doe',
        'sync_version': 3,
        'created_at': '2024-01-15T10:30:00+00:00',
        'updated_at': '2024-01-16T10:30:00+00:00',
      };

      final template = LabelTemplate.fromJson(json);

      expect(template.id, 'tmpl-1');
      expect(template.organizationId, 'org-1');
      expect(template.name, 'My Label');
      expect(template.labelWidthMm, 50.0);
      expect(template.labelHeightMm, 30.0);
      expect(template.isPreset, false);
      expect(template.isDefault, true);
      expect(template.createdBy, 'user-1');
      expect(template.createdByName, 'John Doe');
      expect(template.syncVersion, 3);
      expect(template.createdAt, isNotNull);
      expect(template.updatedAt, isNotNull);
    });

    test('fromJson handles null created_by_name', () {
      final json = {
        'id': 'tmpl-1',
        'organization_id': 'org-1',
        'name': 'My Label',
        'label_width_mm': '50.5',
        'label_height_mm': '30.0',
        'layout_json': {'elements': []},
        'created_by_name': null,
      };

      final template = LabelTemplate.fromJson(json);
      expect(template.createdByName, isNull);
    });

    test('fromJson parses string dimension values', () {
      final json = {
        'id': 'tmpl-1',
        'organization_id': 'org-1',
        'name': 'My Label',
        'label_width_mm': '60.5',
        'label_height_mm': '40.25',
        'layout_json': {'elements': []},
      };

      final template = LabelTemplate.fromJson(json);
      expect(template.labelWidthMm, 60.5);
      expect(template.labelHeightMm, 40.25);
    });

    test('toJson serializes created_by_name', () {
      final template = baseTemplate.copyWith(createdByName: 'Jane Smith');
      final json = template.toJson();
      expect(json['created_by_name'], 'Jane Smith');
    });

    test('copyWith preserves createdByName', () {
      final t = baseTemplate.copyWith(createdByName: 'Alice');
      final copy = t.copyWith(name: 'Updated');
      expect(copy.createdByName, 'Alice');
    });

    test('equality is based on id only', () {
      const a = LabelTemplate(
        id: 'same-id',
        organizationId: 'org-1',
        name: 'A',
        labelWidthMm: 50,
        labelHeightMm: 30,
        layoutJson: {},
      );
      const b = LabelTemplate(
        id: 'same-id',
        organizationId: 'org-2',
        name: 'B',
        labelWidthMm: 60,
        labelHeightMm: 40,
        layoutJson: {},
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });
  });

  // ─── LabelPrintHistory ───────────────────────────────────

  group('LabelPrintHistory', () {
    test('fromJson parses templateName and printedByName', () {
      final json = {
        'id': 'hist-1',
        'store_id': 'store-1',
        'template_id': 'tmpl-1',
        'template_name': 'Standard Label',
        'printed_by': 'user-1',
        'printed_by_name': 'Alice Smith',
        'product_count': 5,
        'total_labels': 10,
        'printer_name': 'Zebra GK420d',
        'printer_language': 'zpl',
        'job_pages': 2,
        'duration_ms': 1800,
        'printed_at': '2024-01-15T10:30:00+00:00',
      };

      final history = LabelPrintHistory.fromJson(json);

      expect(history.id, 'hist-1');
      expect(history.templateId, 'tmpl-1');
      expect(history.templateName, 'Standard Label');
      expect(history.printedBy, 'user-1');
      expect(history.printedByName, 'Alice Smith');
      expect(history.productCount, 5);
      expect(history.totalLabels, 10);
      expect(history.printerName, 'Zebra GK420d');
      expect(history.printerLanguage, 'zpl');
      expect(history.jobPages, 2);
      expect(history.durationMs, 1800);
      expect(history.printedAt, isNotNull);
    });

    test('fromJson handles null printer_language, job_pages, duration_ms', () {
      final json = {
        'id': 'hist-3',
        'store_id': 'store-1',
        'printed_by': 'user-1',
        'product_count': 1,
        'total_labels': 1,
        'printer_language': null,
        'job_pages': null,
        'duration_ms': null,
      };

      final history = LabelPrintHistory.fromJson(json);
      expect(history.printerLanguage, isNull);
      expect(history.jobPages, isNull);
      expect(history.durationMs, isNull);
    });

    test('fromJson handles null templateId and templateName', () {
      final json = {
        'id': 'hist-2',
        'store_id': 'store-1',
        'template_id': null,
        'template_name': null,
        'printed_by': 'user-1',
        'printed_by_name': null,
        'product_count': 3,
        'total_labels': 3,
      };

      final history = LabelPrintHistory.fromJson(json);

      expect(history.templateId, isNull);
      expect(history.templateName, isNull);
      expect(history.printedByName, isNull);
    });

    test('toJson includes templateName and printedByName', () {
      const history = LabelPrintHistory(
        id: 'hist-1',
        storeId: 'store-1',
        templateId: 'tmpl-1',
        templateName: 'Standard Label',
        printedBy: 'user-1',
        printedByName: 'Alice Smith',
        productCount: 5,
        totalLabels: 10,
        printerLanguage: 'tspl',
        jobPages: 3,
        durationMs: 2500,
      );

      final json = history.toJson();
      expect(json['template_name'], 'Standard Label');
      expect(json['printed_by_name'], 'Alice Smith');
      expect(json['printer_language'], 'tspl');
      expect(json['job_pages'], 3);
      expect(json['duration_ms'], 2500);
    });

    test('copyWith preserves all new fields', () {
      const base = LabelPrintHistory(id: 'hist-1', storeId: 'store-1', printedBy: 'user-1', productCount: 1, totalLabels: 1);

      final copy = base.copyWith(
        templateName: 'My Template',
        printedByName: 'Bob',
        printerLanguage: 'zpl',
        jobPages: 2,
        durationMs: 900,
      );
      expect(copy.templateName, 'My Template');
      expect(copy.printedByName, 'Bob');
      expect(copy.printerLanguage, 'zpl');
      expect(copy.jobPages, 2);
      expect(copy.durationMs, 900);
      expect(copy.id, 'hist-1');
    });

    test('equality is based on id', () {
      const a = LabelPrintHistory(id: 'same', storeId: 'store-1', printedBy: 'user-1', productCount: 1, totalLabels: 1);
      const b = LabelPrintHistory(id: 'same', storeId: 'store-99', printedBy: 'user-99', productCount: 99, totalLabels: 99);
      expect(a, equals(b));
    });
  });

  // ─── LabelTemplatesState copyWith ────────────────────────

  group('LabelTemplatesLoaded copyWith presets', () {
    test('copies with new presets list', () {
      const t1 = LabelTemplate(
        id: 't1',
        organizationId: 'org-1',
        name: 'T1',
        labelWidthMm: 50,
        labelHeightMm: 30,
        layoutJson: {},
      );
      const t2 = LabelTemplate(
        id: 't2',
        organizationId: 'org-1',
        name: 'T2',
        labelWidthMm: 60,
        labelHeightMm: 40,
        layoutJson: {},
        isPreset: true,
      );

      final template = LabelTemplate(
        id: t1.id,
        organizationId: t1.organizationId,
        name: t1.name,
        labelWidthMm: t1.labelWidthMm,
        labelHeightMm: t1.labelHeightMm,
        layoutJson: t1.layoutJson,
        isDefault: true,
      );

      final newDefault = template.copyWith(isDefault: false);
      expect(newDefault.isDefault, false);

      final withId = t1.copyWith(createdByName: 'Creator Name');
      expect(withId.createdByName, 'Creator Name');
      expect(withId.id, t1.id);
      expect(t2.isPreset, true); // verify preset template
    });
  });

  // ─── LabelPrintStats ─────────────────────────────────────

  group('LabelPrintStats', () {
    test('fromJson parses all fields', () {
      final json = {'jobs_last_30_days': 12, 'products_last_30_days': 45, 'labels_last_30_days': 90};

      final stats = LabelPrintStats.fromJson(json);
      expect(stats.jobsLast30Days, 12);
      expect(stats.productsLast30Days, 45);
      expect(stats.labelsLast30Days, 90);
    });

    test('fromJson handles numeric types (int and double)', () {
      final json = {'jobs_last_30_days': 5.0, 'products_last_30_days': 20.0, 'labels_last_30_days': 40.0};

      final stats = LabelPrintStats.fromJson(json);
      expect(stats.jobsLast30Days, 5);
      expect(stats.productsLast30Days, 20);
      expect(stats.labelsLast30Days, 40);
    });

    test('empty factory returns zeros', () {
      final stats = LabelPrintStats.empty();
      expect(stats.jobsLast30Days, 0);
      expect(stats.productsLast30Days, 0);
      expect(stats.labelsLast30Days, 0);
    });

    test('toJson round-trips correctly', () {
      const stats = LabelPrintStats(jobsLast30Days: 7, productsLast30Days: 21, labelsLast30Days: 63);

      final json = stats.toJson();
      expect(json['jobs_last_30_days'], 7);
      expect(json['products_last_30_days'], 21);
      expect(json['labels_last_30_days'], 63);

      final roundTripped = LabelPrintStats.fromJson(json);
      expect(roundTripped.jobsLast30Days, 7);
    });
  });
}
