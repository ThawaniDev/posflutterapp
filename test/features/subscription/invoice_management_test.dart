import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/subscription/data/remote/subscription_api_service.dart';
import 'package:wameedpos/features/subscription/models/invoice.dart';
import 'package:wameedpos/features/zatca/enums/invoice_status.dart';

// ─── Mock HTTP Adapter ────────────────────────────────────────────────────────

class _MockAdapter implements HttpClientAdapter {
  _MockAdapter(this.handler);
  final Future<ResponseBody> Function(RequestOptions options) handler;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream, Future<void>? cancelFuture) {
    return handler(options);
  }
}

Dio _makeDio(Future<ResponseBody> Function(RequestOptions) handler) {
  final dio = Dio(BaseOptions(baseUrl: 'http://test', responseType: ResponseType.json, contentType: 'application/json'));
  dio.httpClientAdapter = _MockAdapter(handler);
  return dio;
}

ResponseBody _json(Object body, [int status = 200]) {
  return ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: ['application/json'],
    },
  );
}

SubscriptionApiService _makeService(Future<ResponseBody> Function(RequestOptions) handler) {
  return SubscriptionApiService(_makeDio(handler));
}

// ─── Fixture payloads ─────────────────────────────────────────────────────────

const _invoiceId = 'inv-uuid-001';
const _invoiceId2 = 'inv-uuid-002';

const _lineItemPayload = {
  'id': 'line-uuid-1',
  'invoice_id': _invoiceId,
  'description': 'Growth Plan - monthly',
  'quantity': 1,
  'unit_price': '29.99',
  'total': '29.99',
};

const _invoicePayload = {
  'id': _invoiceId,
  'invoice_number': 'INV-2025-001',
  'amount': '29.99',
  'tax': '4.50',
  'total': '34.49',
  'status': 'paid',
  'due_date': '2025-01-31T00:00:00.000Z',
  'paid_at': '2025-01-28T10:00:00.000Z',
  'pdf_url': 'https://storage.example.com/invoices/inv-001.pdf',
  'line_items': [_lineItemPayload],
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-28T10:00:00.000Z',
};

const _invoicePayload2 = {
  'id': _invoiceId2,
  'invoice_number': 'INV-2025-002',
  'amount': '29.99',
  'tax': null,
  'total': '29.99',
  'status': 'pending',
  'due_date': '2025-02-28T00:00:00.000Z',
  'paid_at': null,
  'pdf_url': null,
  'line_items': null,
  'created_at': '2025-02-01T00:00:00.000Z',
  'updated_at': '2025-02-01T00:00:00.000Z',
};

Map<String, dynamic> _paginatedListResponse(
  List<Map<String, dynamic>> invoices, {
  int page = 1,
  int lastPage = 1,
  int perPage = 20,
  int? total,
}) {
  return {
    'success': true,
    'data': {
      'data': invoices,
      'meta': {'current_page': page, 'last_page': lastPage, 'per_page': perPage, 'total': total ?? invoices.length},
    },
  };
}

Map<String, dynamic> _singleResponse(Map<String, dynamic> invoice) {
  return {'success': true, 'data': invoice};
}

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  group('Invoice — model parsing', () {
    test('parses all fields correctly from full payload', () {
      final invoice = Invoice.fromJson(Map<String, dynamic>.from(_invoicePayload));

      expect(invoice.id, equals(_invoiceId));
      expect(invoice.invoiceNumber, equals('INV-2025-001'));
      expect(invoice.amount, closeTo(29.99, 0.001));
      expect(invoice.tax, closeTo(4.50, 0.001));
      expect(invoice.total, closeTo(34.49, 0.001));
      expect(invoice.status, equals(InvoiceStatus.paid));
      expect(invoice.dueDate, equals(DateTime.parse('2025-01-31T00:00:00.000Z')));
      expect(invoice.paidAt, equals(DateTime.parse('2025-01-28T10:00:00.000Z')));
      expect(invoice.pdfUrl, equals('https://storage.example.com/invoices/inv-001.pdf'));
      expect(invoice.createdAt, isNotNull);
      expect(invoice.updatedAt, isNotNull);
    });

    test('parses nullable fields as null when absent', () {
      final invoice = Invoice.fromJson(Map<String, dynamic>.from(_invoicePayload2));

      expect(invoice.tax, isNull);
      expect(invoice.paidAt, isNull);
      expect(invoice.pdfUrl, isNull);
      expect(invoice.lineItems, isNull);
      expect(invoice.status, equals(InvoiceStatus.pending));
    });

    test('parses line_items into InvoiceLineItem list', () {
      final invoice = Invoice.fromJson(Map<String, dynamic>.from(_invoicePayload));

      expect(invoice.lineItems, isNotNull);
      expect(invoice.lineItems!.length, equals(1));

      final item = invoice.lineItems!.first;
      expect(item.id, equals('line-uuid-1'));
      expect(item.invoiceId, equals(_invoiceId));
      expect(item.description, equals('Growth Plan - monthly'));
      expect(item.quantity, equals(1));
      expect(item.unitPrice, closeTo(29.99, 0.001));
      expect(item.total, closeTo(29.99, 0.001));
    });

    test('empty line_items list is parsed as empty list', () {
      final payload = Map<String, dynamic>.from(_invoicePayload)..['line_items'] = <dynamic>[];
      final invoice = Invoice.fromJson(payload);

      expect(invoice.lineItems, isNotNull);
      expect(invoice.lineItems, isEmpty);
    });

    test('amount and total parse numeric strings correctly', () {
      final payload = {'id': 'inv-num', 'amount': '100.00', 'total': '115.00'};
      final invoice = Invoice.fromJson(payload);

      expect(invoice.amount, closeTo(100.0, 0.001));
      expect(invoice.total, closeTo(115.0, 0.001));
    });

    test('amount and total parse numeric int values correctly', () {
      final payload = {'id': 'inv-int', 'amount': 50, 'total': 57};
      final invoice = Invoice.fromJson(payload);

      expect(invoice.amount, closeTo(50.0, 0.001));
      expect(invoice.total, closeTo(57.0, 0.001));
    });

    test('status null when json status field is missing', () {
      final payload = {'id': 'inv-ns', 'amount': '10', 'total': '10'};
      final invoice = Invoice.fromJson(payload);

      expect(invoice.status, isNull);
    });
  });

  group('InvoiceStatus enum', () {
    test('fromValue maps all known string values', () {
      expect(InvoiceStatus.fromValue('draft'), equals(InvoiceStatus.draft));
      expect(InvoiceStatus.fromValue('pending'), equals(InvoiceStatus.pending));
      expect(InvoiceStatus.fromValue('paid'), equals(InvoiceStatus.paid));
      expect(InvoiceStatus.fromValue('failed'), equals(InvoiceStatus.failed));
      expect(InvoiceStatus.fromValue('refunded'), equals(InvoiceStatus.refunded));
    });

    test('fromValue throws for unknown string', () {
      expect(() => InvoiceStatus.fromValue('unknown'), throwsArgumentError);
    });

    test('tryFromValue returns null for null input', () {
      expect(InvoiceStatus.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown string', () {
      expect(InvoiceStatus.tryFromValue('nope'), isNull);
    });

    test('tryFromValue returns correct enum for valid string', () {
      expect(InvoiceStatus.tryFromValue('paid'), equals(InvoiceStatus.paid));
    });

    test('.value returns the string representation', () {
      expect(InvoiceStatus.draft.value, equals('draft'));
      expect(InvoiceStatus.paid.value, equals('paid'));
      expect(InvoiceStatus.failed.value, equals('failed'));
    });
  });

  group('SubscriptionApiService.getInvoices()', () {
    test('returns list of invoices from paginated response', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_paginatedListResponse([_invoicePayload, _invoicePayload2]));
      });

      final invoices = await service.getInvoices();

      expect(invoices.length, equals(2));
      expect(invoices[0].id, equals(_invoiceId));
      expect(invoices[1].id, equals(_invoiceId2));
    });

    test('sends GET to /subscription/invoices with default page/per_page', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_paginatedListResponse([]));
      });

      await service.getInvoices();

      expect(captured!.path, contains('/subscription/invoices'));
      expect(captured!.queryParameters['page'], equals(1));
      expect(captured!.queryParameters['per_page'], equals(20));
    });

    test('forwards custom page and per_page params', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_paginatedListResponse([]));
      });

      await service.getInvoices(page: 3, perPage: 10);

      expect(captured!.queryParameters['page'], equals(3));
      expect(captured!.queryParameters['per_page'], equals(10));
    });

    test('returns empty list when data envelope contains no invoices', () async {
      final service = _makeService((opts) async {
        return _json(_paginatedListResponse([]));
      });

      final invoices = await service.getInvoices();

      expect(invoices, isEmpty);
    });

    test('first invoice in list parses line_items correctly', () async {
      final service = _makeService((opts) async {
        return _json(_paginatedListResponse([_invoicePayload]));
      });

      final invoices = await service.getInvoices();
      final first = invoices.first;

      expect(first.lineItems, isNotNull);
      expect(first.lineItems!.length, equals(1));
      expect(first.lineItems!.first.description, equals('Growth Plan - monthly'));
    });

    test('invoices with null line_items parse without error', () async {
      final service = _makeService((opts) async {
        return _json(_paginatedListResponse([_invoicePayload2]));
      });

      final invoices = await service.getInvoices();
      expect(invoices.first.lineItems, isNull);
    });

    test('all InvoiceStatus values appearing in a list are parsed', () async {
      final statuses = ['draft', 'pending', 'paid', 'failed', 'refunded'];
      final payloads = statuses.map((s) => {'id': 'inv-$s', 'amount': '10', 'total': '10', 'status': s}).toList();

      final service = _makeService((opts) async {
        return _json(_paginatedListResponse(payloads));
      });

      final invoices = await service.getInvoices();

      expect(invoices.length, equals(5));
      expect(invoices.map((i) => i.status?.value).toList(), equals(statuses));
    });
  });

  group('SubscriptionApiService.getInvoice(id)', () {
    test('sends GET to /subscription/invoices/{id}', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_singleResponse(_invoicePayload));
      });

      await service.getInvoice(_invoiceId);

      expect(captured!.path, contains('/subscription/invoices/$_invoiceId'));
      expect(captured!.method, equals('GET'));
    });

    test('parses returned Invoice correctly', () async {
      final service = _makeService((opts) async {
        return _json(_singleResponse(_invoicePayload));
      });

      final invoice = await service.getInvoice(_invoiceId);

      expect(invoice.id, equals(_invoiceId));
      expect(invoice.invoiceNumber, equals('INV-2025-001'));
      expect(invoice.total, closeTo(34.49, 0.001));
      expect(invoice.status, equals(InvoiceStatus.paid));
    });

    test('parses line_items when present in single invoice response', () async {
      final service = _makeService((opts) async {
        return _json(_singleResponse(_invoicePayload));
      });

      final invoice = await service.getInvoice(_invoiceId);

      expect(invoice.lineItems, isNotNull);
      expect(invoice.lineItems!.isNotEmpty, isTrue);
      final item = invoice.lineItems!.first;
      expect(item.unitPrice, closeTo(29.99, 0.001));
    });

    test('invoice with null optional fields parses correctly', () async {
      final service = _makeService((opts) async {
        return _json(_singleResponse(_invoicePayload2));
      });

      final invoice = await service.getInvoice(_invoiceId2);

      expect(invoice.paidAt, isNull);
      expect(invoice.tax, isNull);
      expect(invoice.pdfUrl, isNull);
    });
  });

  group('SubscriptionApiService.getInvoicePdfUrl(id)', () {
    test('sends GET to /subscription/invoices/{id}/pdf', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json({
          'success': true,
          'data': {'pdf_url': 'https://example.com/inv.pdf'},
        });
      });

      await service.getInvoicePdfUrl(_invoiceId);

      expect(captured!.path, contains('/subscription/invoices/$_invoiceId/pdf'));
      expect(captured!.method, equals('GET'));
    });

    test('returns pdf_url string when present', () async {
      const expectedUrl = 'https://storage.example.com/invoices/inv-001.pdf';
      final service = _makeService((opts) async {
        return _json({
          'success': true,
          'data': {'pdf_url': expectedUrl},
        });
      });

      final url = await service.getInvoicePdfUrl(_invoiceId);

      expect(url, equals(expectedUrl));
    });

    test('returns null when data payload is null', () async {
      final service = _makeService((opts) async {
        return _json({'success': true, 'data': null});
      });

      final url = await service.getInvoicePdfUrl(_invoiceId);

      expect(url, isNull);
    });

    test('returns null when pdf_url field is null', () async {
      final service = _makeService((opts) async {
        return _json({
          'success': true,
          'data': {'pdf_url': null},
        });
      });

      final url = await service.getInvoicePdfUrl(_invoiceId);

      expect(url, isNull);
    });
  });

  group('Invoice pagination params contract', () {
    test('default page=1 per_page=20 when no arguments provided', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_paginatedListResponse([]));
      });

      await service.getInvoices();

      expect(captured!.queryParameters['page'], equals(1));
      expect(captured!.queryParameters['per_page'], equals(20));
    });

    test('page=2 per_page=5 are forwarded when explicitly set', () async {
      RequestOptions? captured;
      final service = _makeService((opts) async {
        captured = opts;
        return _json(_paginatedListResponse([]));
      });

      await service.getInvoices(page: 2, perPage: 5);

      expect(captured!.queryParameters['page'], equals(2));
      expect(captured!.queryParameters['per_page'], equals(5));
    });
  });
}
