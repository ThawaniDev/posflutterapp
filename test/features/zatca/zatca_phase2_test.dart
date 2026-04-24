import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/zatca/enums/zatca_device_status.dart';
import 'package:wameedpos/features/zatca/enums/zatca_invoice_flow.dart';
import 'package:wameedpos/features/zatca/models/zatca_device.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';

void main() {
  group('ZatcaDeviceStatus enum', () {
    test('fromValue parses all variants', () {
      expect(ZatcaDeviceStatus.fromValue('pending'), ZatcaDeviceStatus.pending);
      expect(ZatcaDeviceStatus.fromValue('active'), ZatcaDeviceStatus.active);
      expect(ZatcaDeviceStatus.fromValue('suspended'),
          ZatcaDeviceStatus.suspended);
      expect(ZatcaDeviceStatus.fromValue('tampered'),
          ZatcaDeviceStatus.tampered);
      expect(ZatcaDeviceStatus.fromValue('revoked'), ZatcaDeviceStatus.revoked);
    });

    test('value round-trips', () {
      for (final s in ZatcaDeviceStatus.values) {
        expect(ZatcaDeviceStatus.fromValue(s.value), s);
      }
    });
  });

  group('ZatcaInvoiceFlow enum', () {
    test('parses clearance and reporting', () {
      expect(ZatcaInvoiceFlow.tryFromValue('clearance'),
          ZatcaInvoiceFlow.clearance);
      expect(ZatcaInvoiceFlow.tryFromValue('reporting'),
          ZatcaInvoiceFlow.reporting);
    });

    test('null and unknown return null', () {
      expect(ZatcaInvoiceFlow.tryFromValue(null), isNull);
      expect(ZatcaInvoiceFlow.tryFromValue('bogus'), isNull);
    });
  });

  group('ZatcaDevice model', () {
    test('fromJson parses tampered active device', () {
      final d = ZatcaDevice.fromJson({
        'id': 'dev-1',
        'store_id': 'store-1',
        'device_uuid': 'uuid-xyz',
        'status': 'tampered',
        'environment': 'production',
        'is_tampered': true,
        'current_icv': 42,
        'hardware_serial': 'SN-001',
        'tamper_reason': 'icv mismatch',
        'current_pih': 'hash==',
      });

      expect(d.id, 'dev-1');
      expect(d.status, ZatcaDeviceStatus.tampered);
      expect(d.isTampered, true);
      expect(d.currentIcv, 42);
      expect(d.hardwareSerial, 'SN-001');
      expect(d.tamperReason, 'icv mismatch');
    });

    test('toJson preserves required fields', () {
      const d = ZatcaDevice(
        id: 'd',
        storeId: 's',
        deviceUuid: 'u',
        status: ZatcaDeviceStatus.active,
        environment: 'sandbox',
        isTampered: false,
        currentIcv: 1,
      );
      final json = d.toJson();
      expect(json['status'], 'active');
      expect(json['environment'], 'sandbox');
      expect(json['current_icv'], 1);
      expect(json['is_tampered'], false);
    });

    test('fromJson defaults missing fields safely', () {
      final d = ZatcaDevice.fromJson({
        'id': 'd',
        'device_uuid': 'u',
      });
      expect(d.status, ZatcaDeviceStatus.pending);
      expect(d.environment, 'sandbox');
      expect(d.isTampered, false);
      expect(d.currentIcv, 0);
    });
  });

  group('ZatcaInvoice phase 2 fields', () {
    test('fromJson parses extended phase 2 fields', () {
      final invoice = ZatcaInvoice.fromJson({
        'id': 'inv-1',
        'store_id': 'store-1',
        'order_id': 'order-1',
        'invoice_number': 'INV-001',
        'invoice_type': 'standard',
        'invoice_xml': '<x/>',
        'invoice_hash': 'h',
        'previous_invoice_hash': '',
        'digital_signature': 's',
        'qr_code_data': 'q',
        'total_amount': 115.0,
        'vat_amount': 15.0,
        'uuid': 'uuid-xyz',
        'icv': 7,
        'device_id': 'dev-1',
        'is_b2b': true,
        'flow': 'clearance',
        'submission_attempts': 2,
        'cleared_xml': '<x/>',
        'tlv_qr_base64': 'AQID',
      });

      expect(invoice.uuid, 'uuid-xyz');
      expect(invoice.icv, 7);
      expect(invoice.deviceId, 'dev-1');
      expect(invoice.isB2b, true);
      expect(invoice.flow, ZatcaInvoiceFlow.clearance);
      expect(invoice.submissionAttempts, 2);
      expect(invoice.clearedXml, '<x/>');
      expect(invoice.tlvQrBase64, 'AQID');
    });

    test('isB2b defaults to false when missing', () {
      final invoice = ZatcaInvoice.fromJson({
        'id': 'inv-2',
        'store_id': 's',
        'order_id': 'o',
        'invoice_number': 'N',
        'invoice_type': 'simplified',
        'invoice_xml': '',
        'invoice_hash': '',
        'previous_invoice_hash': '',
        'digital_signature': '',
        'qr_code_data': '',
        'total_amount': 10.0,
        'vat_amount': 1.0,
      });
      expect(invoice.isB2b, false);
      expect(invoice.flow, isNull);
      expect(invoice.icv, isNull);
    });

    test('toJson roundtrip preserves phase 2 fields', () {
      final invoice = ZatcaInvoice.fromJson({
        'id': 'inv',
        'store_id': 's',
        'order_id': 'o',
        'invoice_number': 'N',
        'invoice_type': 'standard',
        'invoice_xml': '',
        'invoice_hash': '',
        'previous_invoice_hash': '',
        'digital_signature': '',
        'qr_code_data': '',
        'total_amount': 100.0,
        'vat_amount': 15.0,
        'uuid': 'uuid',
        'icv': 9,
        'flow': 'reporting',
        'is_b2b': false,
      });
      final json = invoice.toJson();
      expect(json['uuid'], 'uuid');
      expect(json['icv'], 9);
      expect(json['flow'], 'reporting');
      expect(json['is_b2b'], false);
    });
  });
}
