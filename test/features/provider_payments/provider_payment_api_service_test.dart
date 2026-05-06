import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/provider_payments/data/remote/provider_payment_api_service.dart';
import 'package:wameedpos/features/provider_payments/enums/payment_purpose.dart';
import 'package:wameedpos/features/provider_payments/enums/provider_payment_status.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';

// ─── Mock HTTP adapter ────────────────────────────────────────────────────────

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

ProviderPaymentApiService _makeService(Future<ResponseBody> Function(RequestOptions) handler) {
  return ProviderPaymentApiService(_makeDio(handler));
}

// ─── Sample API payloads (matching ProviderPaymentResource exactly) ───────────

Map<String, dynamic> _paymentPayload({
  String id = 'pay-uuid-1',
  String purpose = 'other',
  String status = 'pending',
  String? redirectUrl,
}) => {
  'id': id,
  'organization_id': 'org-uuid-1',
  'invoice_id': null,
  'purpose': purpose,
  'purpose_label': 'Test Payment',
  'purpose_reference_id': null,
  'amount': '100.00',
  'tax_amount': '15.00',
  'total_amount': '115.00',
  'currency': 'SAR',
  'original_currency': null,
  'original_amount': null,
  'exchange_rate_used': null,
  'status': status,
  'gateway': 'paytabs',
  'tran_ref': 'TRAN-001',
  'tran_type': 'sale',
  'cart_id': 'WP-TEST-001',
  'response_status': null,
  'response_code': null,
  'response_message': null,
  'card_type': null,
  'card_scheme': null,
  'payment_description': null,
  'payment_method': null,
  'confirmation_email_sent': false,
  'confirmation_email_sent_at': null,
  'confirmation_email_error': null,
  'invoice_generated': false,
  'invoice_generated_at': null,
  'ipn_received': false,
  'ipn_received_at': null,
  'refund_amount': null,
  'refund_tran_ref': null,
  'refund_reason': null,
  'refunded_at': null,
  'payment_context': null,
  'notes': null,
  'redirect_url': redirectUrl,
  'email_logs': [],
  'created_at': '2025-01-01T00:00:00.000Z',
  'updated_at': '2025-01-01T00:00:00.000Z',
};

// ─── Tests ────────────────────────────────────────────────────────────────────

void main() {
  // ─── listPayments ───────────────────────────────────────────────

  group('listPayments', () {
    test('returns list of provider payments', () async {
      final service = _makeService(
        (_) async => _json({
          'success': true,
          'data': {
            'data': [_paymentPayload(), _paymentPayload(id: 'pay-uuid-2')],
            'total': 2,
            'current_page': 1,
            'per_page': 20,
            'last_page': 1,
          },
        }),
      );

      final payments = await service.listPayments();

      expect(payments, hasLength(2));
      expect(payments.first.id, 'pay-uuid-1');
      expect(payments.first.status, ProviderPaymentStatus.pending);
    });

    test('passes status and purpose query params', () async {
      String? capturedStatus;
      String? capturedPurpose;

      final service = _makeService((req) async {
        capturedStatus = req.queryParameters['status'];
        capturedPurpose = req.queryParameters['purpose'];
        return _json({
          'success': true,
          'data': {'data': [], 'total': 0, 'current_page': 1, 'per_page': 20, 'last_page': 1},
        });
      });

      await service.listPayments(status: 'completed', purpose: 'subscription');

      expect(capturedStatus, 'completed');
      expect(capturedPurpose, 'subscription');
    });

    test('parses email_logs list', () async {
      final service = _makeService(
        (_) async => _json({
          'success': true,
          'data': {
            'data': [
              {
                ..._paymentPayload(),
                'email_logs': [
                  {
                    'id': 'log-1',
                    'provider_payment_id': 'pay-uuid-1',
                    'email_type': 'confirmation',
                    'recipient_email': 'owner@test.com',
                    'subject': 'Payment Confirmed',
                    'status': 'sent',
                    'created_at': '2025-01-01T00:00:00.000Z',
                  },
                ],
              },
            ],
            'total': 1,
            'current_page': 1,
            'per_page': 20,
            'last_page': 1,
          },
        }),
      );

      final payments = await service.listPayments();

      expect(payments.first.emailLogs, isNotNull);
      expect(payments.first.emailLogs!, hasLength(1));
      expect(payments.first.emailLogs!.first.emailType, 'confirmation');
    });
  });

  // ─── getPayment ─────────────────────────────────────────────────

  group('getPayment', () {
    test('returns a single provider payment by id', () async {
      final service = _makeService(
        (_) async => _json({'success': true, 'data': _paymentPayload(id: 'pay-uuid-99', status: 'completed')}),
      );

      final payment = await service.getPayment('pay-uuid-99');

      expect(payment.id, 'pay-uuid-99');
      expect(payment.status, ProviderPaymentStatus.completed);
      expect(payment.totalAmount, 115.00);
    });

    test('sends request to correct endpoint', () async {
      String? capturedPath;

      final service = _makeService((req) async {
        capturedPath = req.path;
        return _json({'success': true, 'data': _paymentPayload()});
      });

      await service.getPayment('pay-uuid-test');

      expect(capturedPath, '/provider-payments/pay-uuid-test');
    });
  });

  // ─── initiatePayment ────────────────────────────────────────────

  group('initiatePayment', () {
    test('sends all required body fields', () async {
      Map<String, dynamic>? sentBody;

      final service = _makeService((req) async {
        sentBody = req.data is String
            ? jsonDecode(req.data as String) as Map<String, dynamic>
            : req.data as Map<String, dynamic>?;
        return _json({
          'success': true,
          'data': _paymentPayload(purpose: 'subscription', redirectUrl: 'https://pay.example.com/checkout'),
        });
      });

      final payment = await service.initiatePayment(
        purpose: 'subscription',
        purposeLabel: 'Growth (monthly)',
        amount: 49.99,
        subscriptionPlanId: 'plan-uuid-1',
        billingCycle: 'monthly',
        discountCode: 'SAVE10',
      );

      expect(sentBody, isNotNull);
      expect(sentBody!['purpose'], 'subscription');
      expect(sentBody!['purpose_label'], 'Growth (monthly)');
      expect(sentBody!['amount'], 49.99);
      expect(sentBody!['purpose_reference_id'], 'plan-uuid-1');
      expect(sentBody!['billing_cycle'], 'monthly');
      expect(sentBody!['discount_code'], 'SAVE10');
      expect(payment.purpose, PaymentPurpose.subscription);
    });

    test('maps subscriptionPlanId to purpose_reference_id', () async {
      Map<String, dynamic>? sentBody;

      final service = _makeService((req) async {
        sentBody = req.data as Map<String, dynamic>?;
        return _json({'success': true, 'data': _paymentPayload(purpose: 'subscription')});
      });

      await service.initiatePayment(
        purpose: 'subscription',
        purposeLabel: 'Pro (monthly)',
        amount: 99.99,
        subscriptionPlanId: 'plan-uuid-pro',
      );

      expect(sentBody!['purpose_reference_id'], 'plan-uuid-pro');
    });

    test('maps addOnId to purpose_reference_id when no subscriptionPlanId', () async {
      Map<String, dynamic>? sentBody;

      final service = _makeService((req) async {
        sentBody = req.data as Map<String, dynamic>?;
        return _json({'success': true, 'data': _paymentPayload(purpose: 'plan_addon')});
      });

      await service.initiatePayment(
        purpose: 'plan_addon',
        purposeLabel: 'KDS Addon',
        amount: 10.00,
        addOnId: 'addon-uuid-kds',
        billingCycle: 'monthly',
      );

      expect(sentBody!['purpose_reference_id'], 'addon-uuid-kds');
      expect(sentBody!['billing_cycle'], 'monthly');
    });

    test('prefers explicit purposeReferenceId over subscriptionPlanId and addOnId', () async {
      Map<String, dynamic>? sentBody;

      final service = _makeService((req) async {
        sentBody = req.data as Map<String, dynamic>?;
        return _json({'success': true, 'data': _paymentPayload(purpose: 'ai_billing')});
      });

      await service.initiatePayment(
        purpose: 'ai_billing',
        purposeLabel: 'AI Invoice',
        amount: 5.00,
        currency: 'USD',
        purposeReferenceId: 'ai-invoice-uuid-1',
        subscriptionPlanId: 'should-be-ignored',
      );

      expect(sentBody!['purpose_reference_id'], 'ai-invoice-uuid-1');
      expect(sentBody!['currency'], 'USD');
    });

    test('omits null optional fields from body', () async {
      Map<String, dynamic>? sentBody;

      final service = _makeService((req) async {
        sentBody = req.data as Map<String, dynamic>?;
        return _json({'success': true, 'data': _paymentPayload()});
      });

      await service.initiatePayment(purpose: 'other', purposeLabel: 'Other', amount: 50.0);

      // Null fields should not be present (Dart null-aware `?value` syntax omits them)
      expect(sentBody!.containsKey('currency'), isFalse);
      expect(sentBody!.containsKey('billing_cycle'), isFalse);
      expect(sentBody!.containsKey('discount_code'), isFalse);
      expect(sentBody!.containsKey('notes'), isFalse);
    });

    test('returns redirect_url from response', () async {
      final service = _makeService(
        (_) async => _json({'success': true, 'data': _paymentPayload(redirectUrl: 'https://pay.paytabs.com/checkout/abc123')}),
      );

      final payment = await service.initiatePayment(purpose: 'other', purposeLabel: 'Test', amount: 50.0);

      expect(payment.redirectUrl, 'https://pay.paytabs.com/checkout/abc123');
    });

    test('sends to correct initiate endpoint', () async {
      String? capturedPath;

      final service = _makeService((req) async {
        capturedPath = req.path;
        return _json({'success': true, 'data': _paymentPayload()});
      });

      await service.initiatePayment(purpose: 'other', purposeLabel: 'Test', amount: 10.0);

      expect(capturedPath, '/provider-payments/initiate');
    });
  });

  // ─── getStatistics ──────────────────────────────────────────────

  group('getStatistics', () {
    test('returns stats map from API', () async {
      final service = _makeService(
        (_) async => _json({
          'success': true,
          'data': {'total_payments': 42, 'total_paid': '1234.56', 'total_pending': 3, 'total_failed': 2, 'emails_sent': 38},
        }),
      );

      final stats = await service.getStatistics();

      expect(stats['total_payments'], 42);
      expect(stats['total_paid'], '1234.56');
      expect(stats['emails_sent'], 38);
    });

    test('sends to correct statistics endpoint', () async {
      String? capturedPath;

      final service = _makeService((req) async {
        capturedPath = req.path;
        return _json({'success': true, 'data': {}});
      });

      await service.getStatistics();

      expect(capturedPath, '/provider-payments/statistics');
    });
  });

  // ─── resendEmail ────────────────────────────────────────────────

  group('resendEmail', () {
    test('posts to correct resend-email endpoint', () async {
      String? capturedPath;
      String? capturedMethod;

      final service = _makeService((req) async {
        capturedPath = req.path;
        capturedMethod = req.method;
        return _json({'success': true, 'data': null});
      });

      await service.resendEmail('pay-uuid-999');

      expect(capturedPath, '/provider-payments/pay-uuid-999/resend-email');
      expect(capturedMethod, 'POST');
    });
  });

  // ─── ProviderPayment model parsing ──────────────────────────────

  group('ProviderPayment.fromJson', () {
    test('parses all core fields', () {
      final payment = ProviderPayment.fromJson(_paymentPayload(id: 'pay-parse-1', purpose: 'subscription', status: 'completed'));

      expect(payment.id, 'pay-parse-1');
      expect(payment.purpose, PaymentPurpose.subscription);
      expect(payment.status, ProviderPaymentStatus.completed);
      expect(payment.amount, 100.00);
      expect(payment.taxAmount, 15.00);
      expect(payment.totalAmount, 115.00);
      expect(payment.currency, 'SAR');
      expect(payment.gateway, 'paytabs');
      expect(payment.cartId, 'WP-TEST-001');
    });

    test('parses unknown purpose as null', () {
      final payment = ProviderPayment.fromJson({..._paymentPayload(), 'purpose': 'unknown_future_value'});

      expect(payment.purpose, isNull);
    });

    test('parses unknown status as pending', () {
      final payment = ProviderPayment.fromJson({..._paymentPayload(), 'status': 'unknown_status'});

      expect(payment.status, ProviderPaymentStatus.pending);
    });

    test('parses USD conversion fields', () {
      final payment = ProviderPayment.fromJson({
        ..._paymentPayload(),
        'original_currency': 'USD',
        'original_amount': '10.00',
        'exchange_rate_used': '3.75',
        'amount': '37.50',
      });

      expect(payment.originalCurrency, 'USD');
      expect(payment.originalAmount, 10.00);
      expect(payment.exchangeRateUsed, 3.75);
      expect(payment.amount, 37.50);
    });

    test('parses refund fields', () {
      final payment = ProviderPayment.fromJson({
        ..._paymentPayload(status: 'refunded'),
        'refund_amount': '50.00',
        'refund_tran_ref': 'REFUND-TRAN-001',
        'refund_reason': 'Customer request',
        'refunded_at': '2025-06-01T12:00:00.000Z',
      });

      expect(payment.status, ProviderPaymentStatus.refunded);
      expect(payment.refundAmount, 50.00);
      expect(payment.refundTranRef, 'REFUND-TRAN-001');
      expect(payment.refundReason, 'Customer request');
      expect(payment.refundedAt, isNotNull);
    });

    test('parses email confirmation flags', () {
      final payment = ProviderPayment.fromJson({
        ..._paymentPayload(status: 'completed'),
        'confirmation_email_sent': true,
        'confirmation_email_sent_at': '2025-01-01T10:00:00.000Z',
        'invoice_generated': true,
      });

      expect(payment.confirmationEmailSent, isTrue);
      expect(payment.confirmationEmailSentAt, isNotNull);
      expect(payment.invoiceGenerated, isTrue);
    });
  });
}
