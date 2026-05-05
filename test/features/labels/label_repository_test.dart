import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/labels/data/remote/label_api_service.dart';
import 'package:wameedpos/features/labels/models/label_print_history.dart';
import 'package:wameedpos/features/labels/models/label_print_stats.dart';
import 'package:wameedpos/features/labels/models/label_template.dart';
import 'package:wameedpos/features/labels/repositories/label_repository.dart';

// ─── FakeDio ─────────────────────────────────────────────────────
// Replaces MockDio: captures call args, returns a configurable response.
// Uses `extends Fake` (not `extends Mock`) to avoid Mockito null-safety issues.

class FakeDio extends Fake implements Dio {
  Response? nextResponse;

  // Last-call capture
  String? lastMethod;
  String? lastPath;
  Map<String, dynamic>? lastQueryParameters;
  dynamic lastData;

  Response _respond() => nextResponse ?? Response(data: {'success': true, 'data': {}}, statusCode: 200, requestOptions: RequestOptions(path: ''));

  @override
  Future<Response<T>> get<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    lastMethod = 'GET';
    lastPath = path;
    lastQueryParameters = queryParameters;
    return _respond() as Response<T>;
  }

  @override
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    lastMethod = 'POST';
    lastPath = path;
    lastQueryParameters = queryParameters;
    lastData = data;
    return _respond() as Response<T>;
  }

  @override
  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    lastMethod = 'PUT';
    lastPath = path;
    lastQueryParameters = queryParameters;
    lastData = data;
    return _respond() as Response<T>;
  }

  @override
  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    lastMethod = 'DELETE';
    lastPath = path;
    lastQueryParameters = queryParameters;
    lastData = data;
    return _respond() as Response<T>;
  }
}

// ─── Test fixtures ───────────────────────────────────────────────

Map<String, dynamic> _templateJson({
  String id = 't1',
  String name = 'Test Template',
  bool isPreset = false,
  bool isDefault = false,
}) =>
    {
      'id': id,
      'organization_id': 'org-1',
      'name': name,
      'label_width_mm': 50.0,
      'label_height_mm': 30.0,
      'layout_json': <String, dynamic>{},
      'is_preset': isPreset,
      'is_default': isDefault,
      'sync_version': 1,
      'created_at': '2024-01-01T00:00:00.000000Z',
      'updated_at': '2024-01-01T00:00:00.000000Z',
    };

Map<String, dynamic> _historyJson({String id = 'h1'}) => {
      'id': id,
      'store_id': 's1',
      'template_id': 't1',
      'template_name': 'Standard',
      'printed_by': 'u1',
      'printed_by_name': 'Alice',
      'product_count': 3,
      'total_labels': 9,
      'printer_name': 'Zebra',
      'printer_language': 'zpl',
      'job_pages': 1,
      'duration_ms': 800,
      'printed_at': '2024-06-01T10:00:00.000000Z',
    };

Map<String, dynamic> _listResponse(List<Map<String, dynamic>> items) => {
      'success': true,
      'data': items,
    };

Map<String, dynamic> _paginatedResponse(List<Map<String, dynamic>> items) => {
      'success': true,
      'data': {
        'data': items,
        'current_page': 1,
        'last_page': 1,
        'total': items.length,
        'per_page': 20,
      },
    };

Map<String, dynamic> _singleResponse(Map<String, dynamic> item) => {
      'success': true,
      'data': item,
    };

Response _makeResponse(Map<String, dynamic> body) => Response(
      data: body,
      statusCode: 200,
      requestOptions: RequestOptions(path: ''),
    );

// ─── Tests ──────────────────────────────────────────────────────

void main() {
  late FakeDio fakeDio;
  late LabelApiService apiService;
  late LabelRepository repository;

  setUp(() {
    fakeDio = FakeDio();
    apiService = LabelApiService(fakeDio);
    repository = LabelRepository(apiService: apiService);
  });

  // ══════════════════════════════════════════════════════════════
  // listTemplates
  // ══════════════════════════════════════════════════════════════

  group('listTemplates', () {
    test('calls GET labelTemplates endpoint', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([_templateJson()]));

      final result = await repository.listTemplates();

      expect(fakeDio.lastMethod, 'GET');
      expect(fakeDio.lastPath, ApiEndpoints.labelTemplates);
      expect(fakeDio.lastQueryParameters, isNull);
      expect(result, hasLength(1));
    });

    test('passes search query param', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([]));

      await repository.listTemplates(search: 'barcode');

      expect(fakeDio.lastQueryParameters, {'search': 'barcode'});
    });

    test('passes type query param', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([]));

      await repository.listTemplates(type: 'preset');

      expect(fakeDio.lastQueryParameters, {'type': 'preset'});
    });

    test('passes combined search and type params', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([]));

      await repository.listTemplates(search: 'shelf', type: 'preset');

      expect(fakeDio.lastQueryParameters, {'search': 'shelf', 'type': 'preset'});
    });

    test('parses returned templates correctly', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([
        _templateJson(id: 'id-1', name: 'Wide Label', isDefault: true),
      ]));

      final result = await repository.listTemplates();

      expect(result.first, isA<LabelTemplate>());
      expect(result.first.id, 'id-1');
      expect(result.first.name, 'Wide Label');
      expect(result.first.isDefault, isTrue);
    });

    test('returns empty list when response data is empty', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([]));

      final result = await repository.listTemplates();
      expect(result, isEmpty);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // getPresets
  // ══════════════════════════════════════════════════════════════

  group('getPresets', () {
    test('calls GET labelPresets endpoint', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([_templateJson(isPreset: true)]));

      final result = await repository.getPresets();

      expect(fakeDio.lastMethod, 'GET');
      expect(fakeDio.lastPath, ApiEndpoints.labelPresets);
      expect(result, hasLength(1));
      expect(result.first.isPreset, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // getTemplate
  // ══════════════════════════════════════════════════════════════

  group('getTemplate', () {
    test('calls GET with template id in URL', () async {
      fakeDio.nextResponse = _makeResponse(_singleResponse(_templateJson(id: 't42')));

      final result = await repository.getTemplate('t42');

      expect(fakeDio.lastMethod, 'GET');
      expect(fakeDio.lastPath, '${ApiEndpoints.labelTemplates}/t42');
      expect(result.id, 't42');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // createTemplate
  // ══════════════════════════════════════════════════════════════

  group('createTemplate', () {
    test('calls POST labelTemplates with data', () async {
      final payload = {'name': 'New', 'label_width_mm': 60, 'label_height_mm': 40, 'layout_json': {}};
      fakeDio.nextResponse = _makeResponse(_singleResponse(_templateJson(name: 'New')));

      final result = await repository.createTemplate(payload);

      expect(fakeDio.lastMethod, 'POST');
      expect(fakeDio.lastPath, ApiEndpoints.labelTemplates);
      expect(fakeDio.lastData, payload);
      expect(result.name, 'New');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // updateTemplate
  // ══════════════════════════════════════════════════════════════

  group('updateTemplate', () {
    test('calls PUT with template id and payload', () async {
      final payload = {'name': 'Updated'};
      fakeDio.nextResponse = _makeResponse(_singleResponse(_templateJson(id: 't5', name: 'Updated')));

      final result = await repository.updateTemplate('t5', payload);

      expect(fakeDio.lastMethod, 'PUT');
      expect(fakeDio.lastPath, '${ApiEndpoints.labelTemplates}/t5');
      expect(fakeDio.lastData, payload);
      expect(result.name, 'Updated');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // deleteTemplate
  // ══════════════════════════════════════════════════════════════

  group('deleteTemplate', () {
    test('calls DELETE with template id', () async {
      fakeDio.nextResponse = _makeResponse({'success': true});

      await repository.deleteTemplate('tdel');

      expect(fakeDio.lastMethod, 'DELETE');
      expect(fakeDio.lastPath, '${ApiEndpoints.labelTemplates}/tdel');
    });
  });

  // ══════════════════════════════════════════════════════════════
  // duplicateTemplate
  // ══════════════════════════════════════════════════════════════

  group('duplicateTemplate', () {
    test('calls POST duplicate endpoint', () async {
      fakeDio.nextResponse = _makeResponse(_singleResponse(_templateJson(id: 'copy', name: 'Template (Copy)')));

      final result = await repository.duplicateTemplate('orig');

      expect(fakeDio.lastMethod, 'POST');
      expect(fakeDio.lastPath, '${ApiEndpoints.labelTemplates}/orig/duplicate');
      expect(result.name, contains('Copy'));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // setDefaultTemplate
  // ══════════════════════════════════════════════════════════════

  group('setDefaultTemplate', () {
    test('calls POST set-default endpoint', () async {
      fakeDio.nextResponse = _makeResponse(_singleResponse(_templateJson(id: 'tdef', isDefault: true)));

      final result = await repository.setDefaultTemplate('tdef');

      expect(fakeDio.lastMethod, 'POST');
      expect(fakeDio.lastPath, '${ApiEndpoints.labelTemplates}/tdef/set-default');
      expect(result.isDefault, isTrue);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // getPrintHistory
  // ══════════════════════════════════════════════════════════════

  group('getPrintHistory', () {
    test('calls GET labelPrintHistory endpoint with no params', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([_historyJson()]));

      final result = await repository.getPrintHistory();

      expect(fakeDio.lastMethod, 'GET');
      expect(fakeDio.lastPath, ApiEndpoints.labelPrintHistory);
      expect(fakeDio.lastQueryParameters, isNull);
      expect(result, hasLength(1));
    });

    test('passes from date as string param', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([]));

      await repository.getPrintHistory(from: DateTime(2024, 3, 15));

      expect(fakeDio.lastQueryParameters, {'from': '2024-03-15'});
    });

    test('passes to date as string param', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([]));

      await repository.getPrintHistory(to: DateTime(2024, 3, 31));

      expect(fakeDio.lastQueryParameters, {'to': '2024-03-31'});
    });

    test('passes template_id filter', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([]));

      await repository.getPrintHistory(templateId: 'tpl-uuid');

      expect(fakeDio.lastQueryParameters, {'template_id': 'tpl-uuid'});
    });

    test('passes per_page param', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([]));

      await repository.getPrintHistory(perPage: 50);

      expect(fakeDio.lastQueryParameters, {'per_page': 50});
    });

    test('parses history from paginated response', () async {
      fakeDio.nextResponse = _makeResponse(_paginatedResponse([_historyJson(id: 'h99')]));

      final result = await repository.getPrintHistory();

      expect(result.first, isA<LabelPrintHistory>());
      expect(result.first.id, 'h99');
      expect(result.first.productCount, 3);
      expect(result.first.totalLabels, 9);
      expect(result.first.printerName, 'Zebra');
    });

    test('handles plain list response (non-paginated fallback)', () async {
      fakeDio.nextResponse = _makeResponse(_listResponse([_historyJson()]));

      final result = await repository.getPrintHistory();
      expect(result, hasLength(1));
    });
  });

  // ══════════════════════════════════════════════════════════════
  // recordPrint
  // ══════════════════════════════════════════════════════════════

  group('recordPrint', () {
    test('calls POST labelPrintHistory with data', () async {
      final payload = {
        'template_id': 't1',
        'product_count': 5,
        'total_labels': 10,
        'printer_name': 'Zebra ZD420',
        'printer_language': 'zpl',
        'job_pages': 2,
        'duration_ms': 1500,
      };
      fakeDio.nextResponse = _makeResponse({'success': true, 'data': {}});

      await repository.recordPrint(payload);

      expect(fakeDio.lastMethod, 'POST');
      expect(fakeDio.lastPath, ApiEndpoints.labelPrintHistory);
      expect(fakeDio.lastData, payload);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // getPrintHistoryStats
  // ══════════════════════════════════════════════════════════════

  group('getPrintHistoryStats', () {
    test('calls GET labelPrintHistoryStats endpoint', () async {
      fakeDio.nextResponse = _makeResponse({
        'success': true,
        'data': {
          'jobs_last_30_days': 5,
          'products_last_30_days': 15,
          'labels_last_30_days': 45,
        },
      });

      final stats = await repository.getPrintHistoryStats();

      expect(fakeDio.lastMethod, 'GET');
      expect(fakeDio.lastPath, ApiEndpoints.labelPrintHistoryStats);
      expect(stats, isA<LabelPrintStats>());
      expect(stats.jobsLast30Days, 5);
      expect(stats.productsLast30Days, 15);
      expect(stats.labelsLast30Days, 45);
    });

    test('returns zeros when all counts are 0', () async {
      fakeDio.nextResponse = _makeResponse({
        'success': true,
        'data': {
          'jobs_last_30_days': 0,
          'products_last_30_days': 0,
          'labels_last_30_days': 0,
        },
      });

      final stats = await repository.getPrintHistoryStats();

      expect(stats.jobsLast30Days, 0);
      expect(stats.productsLast30Days, 0);
      expect(stats.labelsLast30Days, 0);
    });
  });

  // ══════════════════════════════════════════════════════════════
  // Model parsing round-trips
  // ══════════════════════════════════════════════════════════════

  group('LabelTemplate model parsing', () {
    test('parses dimensions as doubles from numeric JSON', () {
      final json = _templateJson();
      final template = LabelTemplate.fromJson(json);
      expect(template.labelWidthMm, isA<double>());
      expect(template.labelHeightMm, isA<double>());
    });

    test('parses dimensions from string representation', () {
      final json = _templateJson();
      json['label_width_mm'] = '75.5';
      json['label_height_mm'] = '45.0';
      final template = LabelTemplate.fromJson(json);
      expect(template.labelWidthMm, 75.5);
      expect(template.labelHeightMm, 45.0);
    });

    test('parses nullable createdByName field', () {
      final json = _templateJson();
      json['created_by_name'] = 'Alice';
      final template = LabelTemplate.fromJson(json);
      expect(template.createdByName, 'Alice');
    });

    test('handles missing optional fields gracefully', () {
      final minimal = {
        'id': 'min',
        'organization_id': 'org',
        'name': 'Minimal',
        'label_width_mm': 50,
        'label_height_mm': 30,
        'layout_json': <String, dynamic>{},
        'is_preset': false,
        'is_default': false,
        'sync_version': 1,
        'created_at': '2024-01-01T00:00:00.000000Z',
        'updated_at': '2024-01-01T00:00:00.000000Z',
      };
      final template = LabelTemplate.fromJson(minimal);
      expect(template.createdByName, isNull);
      expect(template.createdBy, isNull);
    });
  });

  group('LabelPrintHistory model parsing', () {
    test('parses printedAt as DateTime', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.printedAt, isA<DateTime>());
    });

    test('parses templateName correctly', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.templateName, 'Standard');
    });

    test('parses printedByName correctly', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.printedByName, 'Alice');
    });

    test('parses printer_language correctly', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.printerLanguage, 'zpl');
    });

    test('parses job_pages as int', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.jobPages, 1);
    });

    test('parses duration_ms as int', () {
      final history = LabelPrintHistory.fromJson(_historyJson());
      expect(history.durationMs, 800);
    });

    test('handles null template_id in history', () {
      final json = _historyJson();
      json['template_id'] = null;
      json['template_name'] = null;
      final history = LabelPrintHistory.fromJson(json);
      expect(history.templateId, isNull);
      expect(history.templateName, isNull);
    });

    test('handles null printer_language, job_pages, duration_ms', () {
      final json = _historyJson();
      json['printer_language'] = null;
      json['job_pages'] = null;
      json['duration_ms'] = null;
      final history = LabelPrintHistory.fromJson(json);
      expect(history.printerLanguage, isNull);
      expect(history.jobPages, isNull);
      expect(history.durationMs, isNull);
    });
  });
}
