import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/zatca/models/zatca_connection_status.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice_detail.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

void main() {
  group('ZatcaConnectionStatus', () {
    test('fromJson parses healthy production payload', () {
      final json = {
        'environment': 'production',
        'is_production': true,
        'is_healthy': true,
        'connected': true,
        'certificate': {
          'id': 'cert-1',
          'type': 'production',
          'ccsid': 'CCSID',
          'pcsid': 'PCSID',
          'issued_at': '2024-01-01T00:00:00Z',
          'expires_at': '2025-01-01T00:00:00Z',
          'days_until_expiry': 200,
          'expiring_soon': false,
          'expired': false,
        },
        'devices': {'total': 2, 'active': 2, 'tampered': 0},
        'queue_depth': 0,
        'last_success': {'id': 'inv-1', 'invoice_number': 'INV-1', 'submitted_at': '2024-06-01T12:00:00Z', 'flow': 'reporting'},
        'last_error': null,
      };

      final status = ZatcaConnectionStatus.fromJson(json);
      expect(status.connected, true);
      expect(status.isHealthy, true);
      expect(status.isProduction, true);
      expect(status.certificate, isNotNull);
      expect(status.certificate!.daysUntilExpiry, 200);
      expect(status.devices.tampered, 0);
      expect(status.queueDepth, 0);
      expect(status.lastSuccess?.invoiceNumber, 'INV-1');
      expect(status.lastError, isNull);
    });

    test('fromJson handles disconnected payload', () {
      final json = {
        'environment': 'sandbox',
        'is_production': false,
        'is_healthy': false,
        'connected': false,
        'certificate': null,
        'devices': {'total': 0, 'active': 0, 'tampered': 0},
        'queue_depth': 0,
        'last_success': null,
        'last_error': null,
      };

      final status = ZatcaConnectionStatus.fromJson(json);
      expect(status.connected, false);
      expect(status.isHealthy, false);
      expect(status.certificate, isNull);
    });

    test('fromJson surfaces tampered devices and last error', () {
      final json = {
        'environment': 'sandbox',
        'is_production': false,
        'is_healthy': false,
        'connected': true,
        'certificate': {
          'id': 'cert-1',
          'type': 'compliance',
          'issued_at': '2024-01-01T00:00:00Z',
          'expires_at': '2025-01-05T00:00:00Z',
          'days_until_expiry': 5,
          'expiring_soon': true,
          'expired': false,
        },
        'devices': {'total': 3, 'active': 2, 'tampered': 1},
        'queue_depth': 4,
        'last_success': null,
        'last_error': {
          'id': 'inv-9',
          'invoice_number': 'INV-9',
          'last_attempt_at': '2024-06-02T00:00:00Z',
          'response_code': 'E-001',
          'message': 'invalid hash',
          'errors': ['hash mismatch'],
        },
      };

      final status = ZatcaConnectionStatus.fromJson(json);
      expect(status.devices.tampered, 1);
      expect(status.queueDepth, 4);
      expect(status.lastError?.responseCode, 'E-001');
      expect(status.certificate?.expiringSoon, true);
    });
  });

  group('ZatcaInvoiceDetail', () {
    test('fromJson wraps invoice + xml + qr', () {
      final json = {
        'invoice': {
          'id': 'inv-1',
          'store_id': 'store-1',
          'order_id': 'order-1',
          'invoice_number': 'INV-1',
          'invoice_type': 'standard',
          'invoice_xml': '<x/>',
          'invoice_hash': 'hash',
          'previous_invoice_hash': '0',
          'digital_signature': 'sig',
          'qr_code_data': 'qr',
          'total_amount': 115.0,
          'vat_amount': 15.0,
          'submission_status': 'accepted',
          'uuid': 'uuid-1',
          'icv': 1,
          'is_b2b': false,
          'flow': 'reporting',
        },
        'qr_code_base64': 'AAAA',
        'xml': '<x/>',
        'cleared_xml': '<cleared/>',
      };

      final detail = ZatcaInvoiceDetail.fromJson(json);
      expect(detail.invoice.invoiceNumber, 'INV-1');
      expect(detail.qrCodeBase64, 'AAAA');
      expect(detail.xml, '<x/>');
      expect(detail.clearedXml, '<cleared/>');
    });
  });

  group('ZatcaConnectionState pattern matching', () {
    test('exhaustive switch returns expected branches', () {
      String describe(ZatcaConnectionState s) => switch (s) {
        ZatcaConnectionInitial() => 'initial',
        ZatcaConnectionLoading() => 'loading',
        ZatcaConnectionLoaded() => 'loaded',
        ZatcaConnectionError() => 'error',
      };
      expect(describe(const ZatcaConnectionInitial()), 'initial');
      expect(describe(const ZatcaConnectionLoading()), 'loading');
      expect(describe(const ZatcaConnectionError('x')), 'error');
    });
  });
}
