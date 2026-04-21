import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/zatca/enums/zatca_certificate_status.dart';
import 'package:wameedpos/features/zatca/enums/zatca_certificate_type.dart';
import 'package:wameedpos/features/zatca/enums/zatca_invoice_type.dart';
import 'package:wameedpos/features/zatca/enums/zatca_submission_status.dart';
import 'package:wameedpos/features/zatca/models/zatca_certificate.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // ZATCA Invoice Model
  // ═══════════════════════════════════════════════════════════

  group('ZatcaInvoice model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'inv-001',
        'store_id': 'store-001',
        'order_id': 'order-001',
        'invoice_number': 'INV-2024-001',
        'invoice_type': 'standard',
        'invoice_xml': '<xml>test</xml>',
        'invoice_hash': 'abc123hash',
        'previous_invoice_hash': 'prev-hash',
        'digital_signature': 'sig-data',
        'qr_code_data': 'qr-base64',
        'total_amount': 1150.0,
        'vat_amount': 150.0,
        'submission_status': 'accepted',
        'zatca_response_code': '200',
        'zatca_response_message': 'Accepted',
        'submitted_at': '2024-06-01T10:00:00.000Z',
        'created_at': '2024-06-01T09:30:00.000Z',
      };

      final invoice = ZatcaInvoice.fromJson(json);
      expect(invoice.id, 'inv-001');
      expect(invoice.storeId, 'store-001');
      expect(invoice.invoiceNumber, 'INV-2024-001');
      expect(invoice.invoiceType, ZatcaInvoiceType.standard);
      expect(invoice.totalAmount, 1150.0);
      expect(invoice.vatAmount, 150.0);
      expect(invoice.submissionStatus, ZatcaSubmissionStatus.accepted);
      expect(invoice.zatcaResponseCode, '200');
      expect(invoice.submittedAt, isNotNull);
    });

    test('toJson round-trip preserves data', () {
      final invoice = ZatcaInvoice(
        id: 'inv-002',
        storeId: 'store-002',
        orderId: 'order-002',
        invoiceNumber: 'INV-2024-002',
        invoiceType: ZatcaInvoiceType.simplified,
        invoiceXml: '<xml>simplified</xml>',
        invoiceHash: 'hash-002',
        previousInvoiceHash: 'hash-001',
        digitalSignature: 'sig-002',
        qrCodeData: 'qr-002',
        totalAmount: 575.0,
        vatAmount: 75.0,
        submissionStatus: ZatcaSubmissionStatus.pending,
        createdAt: DateTime(2024, 6, 1),
      );

      final json = invoice.toJson();
      expect(json['invoice_type'], 'simplified');
      expect(json['total_amount'], 575.0);
      expect(json['submission_status'], 'pending');

      final restored = ZatcaInvoice.fromJson(json);
      expect(restored.invoiceNumber, invoice.invoiceNumber);
      expect(restored.totalAmount, invoice.totalAmount);
      expect(restored.invoiceType, invoice.invoiceType);
    });

    test('nullable fields handle null', () {
      final json = {
        'id': 'inv-003',
        'store_id': 'store-003',
        'order_id': 'order-003',
        'invoice_number': 'INV-2024-003',
        'invoice_type': 'credit_note',
        'invoice_xml': '<xml/>',
        'invoice_hash': 'h3',
        'previous_invoice_hash': 'h2',
        'digital_signature': 's3',
        'qr_code_data': 'q3',
        'total_amount': 100,
        'vat_amount': 15,
        'submission_status': null,
        'zatca_response_code': null,
        'zatca_response_message': null,
        'submitted_at': null,
        'created_at': null,
      };

      final invoice = ZatcaInvoice.fromJson(json);
      expect(invoice.submissionStatus, isNull);
      expect(invoice.zatcaResponseCode, isNull);
      expect(invoice.submittedAt, isNull);
      expect(invoice.createdAt, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ZATCA Certificate Model
  // ═══════════════════════════════════════════════════════════

  group('ZatcaCertificate model', () {
    test('fromJson creates valid instance', () {
      final json = {
        'id': 'cert-001',
        'store_id': 'store-001',
        'certificate_type': 'compliance',
        'certificate_pem': 'MIIBx...',
        'ccsid': 'CCSID-12345',
        'issued_at': '2024-01-15T00:00:00.000Z',
        'expires_at': '2025-01-15T00:00:00.000Z',
        'status': 'active',
        'created_at': '2024-01-15T00:00:00.000Z',
      };

      final cert = ZatcaCertificate.fromJson(json);
      expect(cert.id, 'cert-001');
      expect(cert.certificateType, ZatcaCertificateType.compliance);
      expect(cert.ccsid, 'CCSID-12345');
      expect(cert.status, ZatcaCertificateStatus.active);
      expect(cert.issuedAt.year, 2024);
      expect(cert.expiresAt.year, 2025);
    });

    test('toJson round-trip', () {
      final cert = ZatcaCertificate(
        id: 'cert-002',
        storeId: 'store-002',
        certificateType: ZatcaCertificateType.production,
        certificatePem: 'PEM-DATA',
        ccsid: 'CCSID-99999',
        issuedAt: DateTime(2024, 3, 1),
        expiresAt: DateTime(2025, 3, 1),
        status: ZatcaCertificateStatus.active,
      );

      final json = cert.toJson();
      expect(json['certificate_type'], 'production');
      expect(json['ccsid'], 'CCSID-99999');

      final restored = ZatcaCertificate.fromJson(json);
      expect(restored.certificateType, cert.certificateType);
      expect(restored.ccsid, cert.ccsid);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // ZATCA Enums
  // ═══════════════════════════════════════════════════════════

  group('ZATCA enums', () {
    test('ZatcaInvoiceType fromValue', () {
      expect(ZatcaInvoiceType.fromValue('standard'), ZatcaInvoiceType.standard);
      expect(ZatcaInvoiceType.fromValue('simplified'), ZatcaInvoiceType.simplified);
      expect(ZatcaInvoiceType.fromValue('credit_note'), ZatcaInvoiceType.creditNote);
      expect(ZatcaInvoiceType.fromValue('debit_note'), ZatcaInvoiceType.debitNote);
    });

    test('ZatcaSubmissionStatus fromValue', () {
      expect(ZatcaSubmissionStatus.fromValue('pending'), ZatcaSubmissionStatus.pending);
      expect(ZatcaSubmissionStatus.fromValue('accepted'), ZatcaSubmissionStatus.accepted);
      expect(ZatcaSubmissionStatus.fromValue('rejected'), ZatcaSubmissionStatus.rejected);
    });

    test('ZatcaCertificateType fromValue', () {
      expect(ZatcaCertificateType.fromValue('compliance'), ZatcaCertificateType.compliance);
      expect(ZatcaCertificateType.fromValue('production'), ZatcaCertificateType.production);
    });

    test('ZatcaCertificateStatus fromValue', () {
      expect(ZatcaCertificateStatus.fromValue('active'), ZatcaCertificateStatus.active);
      expect(ZatcaCertificateStatus.fromValue('expired'), ZatcaCertificateStatus.expired);
      expect(ZatcaCertificateStatus.fromValue('revoked'), ZatcaCertificateStatus.revoked);
    });

    test('tryFromValue returns null for unknown', () {
      expect(ZatcaSubmissionStatus.tryFromValue(null), isNull);
      expect(ZatcaCertificateStatus.tryFromValue(null), isNull);
      expect(ZatcaSubmissionStatus.tryFromValue('nonexistent'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Enrollment State
  // ═══════════════════════════════════════════════════════════

  group('ZatcaEnrollmentState', () {
    test('initial state', () {
      expect(const ZatcaEnrollmentInitial(), isA<ZatcaEnrollmentState>());
    });

    test('loading state', () {
      expect(const ZatcaEnrollmentLoading(), isA<ZatcaEnrollmentState>());
    });

    test('success state with certificate data', () {
      const state = ZatcaEnrollmentSuccess({'certificate_type': 'compliance', 'ccsid': 'CCSID-12345', 'status': 'active'});
      expect(state.certificate['ccsid'], 'CCSID-12345');
      expect(state.certificate['status'], 'active');
    });

    test('error state', () {
      const state = ZatcaEnrollmentError('Invalid OTP');
      expect(state.message, 'Invalid OTP');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Invoice List State
  // ═══════════════════════════════════════════════════════════

  group('ZatcaInvoiceListState', () {
    test('initial state', () {
      expect(const ZatcaInvoiceListInitial(), isA<ZatcaInvoiceListState>());
    });

    test('loading state', () {
      expect(const ZatcaInvoiceListLoading(), isA<ZatcaInvoiceListState>());
    });

    test('loaded with invoices and pagination', () {
      final invoices = [
        const ZatcaInvoice(
          id: 'inv-1',
          storeId: 's1',
          orderId: 'o1',
          invoiceNumber: 'INV-001',
          invoiceType: ZatcaInvoiceType.standard,
          invoiceXml: '<xml/>',
          invoiceHash: 'h1',
          previousInvoiceHash: 'h0',
          digitalSignature: 'sig',
          qrCodeData: 'qr',
          totalAmount: 1000.0,
          vatAmount: 150.0,
        ),
      ];
      final state = ZatcaInvoiceListLoaded(invoices: invoices, currentPage: 1, lastPage: 3, total: 25);
      expect(state.invoices.length, 1);
      expect(state.invoices[0].invoiceNumber, 'INV-001');
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.total, 25);
    });

    test('loaded with empty list', () {
      const state = ZatcaInvoiceListLoaded(invoices: [], currentPage: 1, lastPage: 1, total: 0);
      expect(state.invoices, isEmpty);
      expect(state.total, 0);
    });

    test('error state', () {
      const state = ZatcaInvoiceListError('Failed to load invoices');
      expect(state.message, 'Failed to load invoices');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Compliance Summary State
  // ═══════════════════════════════════════════════════════════

  group('ZatcaComplianceSummaryState', () {
    test('initial state', () {
      expect(const ZatcaComplianceSummaryInitial(), isA<ZatcaComplianceSummaryState>());
    });

    test('loading state', () {
      expect(const ZatcaComplianceSummaryLoading(), isA<ZatcaComplianceSummaryState>());
    });

    test('loaded with stats and certificate', () {
      final cert = ZatcaCertificate(
        id: 'cert-1',
        storeId: 'store-1',
        certificateType: ZatcaCertificateType.production,
        certificatePem: 'PEM',
        ccsid: 'CCSID-1',
        issuedAt: DateTime(2024, 1, 1),
        expiresAt: DateTime(2025, 1, 1),
        status: ZatcaCertificateStatus.active,
      );

      final state = ZatcaComplianceSummaryLoaded(
        totalInvoices: 150,
        accepted: 145,
        rejected: 3,
        pending: 2,
        successRate: 96.67,
        certificate: cert,
      );

      expect(state.totalInvoices, 150);
      expect(state.accepted, 145);
      expect(state.rejected, 3);
      expect(state.pending, 2);
      expect(state.successRate, 96.67);
      expect(state.certificate, isNotNull);
      expect(state.certificate!.ccsid, 'CCSID-1');
      expect(state.certificate!.status, ZatcaCertificateStatus.active);
    });

    test('loaded without certificate', () {
      const state = ZatcaComplianceSummaryLoaded(totalInvoices: 0, accepted: 0, rejected: 0, pending: 0, successRate: 0.0);
      expect(state.certificate, isNull);
      expect(state.totalInvoices, 0);
    });

    test('error state', () {
      const state = ZatcaComplianceSummaryError('Not enrolled');
      expect(state.message, 'Not enrolled');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // VAT Report State
  // ═══════════════════════════════════════════════════════════

  group('ZatcaVatReportState', () {
    test('initial state', () {
      expect(const ZatcaVatReportInitial(), isA<ZatcaVatReportState>());
    });

    test('loading state', () {
      expect(const ZatcaVatReportLoading(), isA<ZatcaVatReportState>());
    });

    test('loaded with VAT breakdown', () {
      const state = ZatcaVatReportLoaded(
        standardInvoices: {'total_amount': 50000.0, 'vat_amount': 7500.0, 'count': 80},
        simplifiedInvoices: {'total_amount': 20000.0, 'vat_amount': 3000.0, 'count': 120},
        totalVatCollected: 10500.0,
        totalAmount: 70000.0,
      );
      expect(state.standardInvoices['total_amount'], 50000.0);
      expect(state.simplifiedInvoices['count'], 120);
      expect(state.totalVatCollected, 10500.0);
      expect(state.totalAmount, 70000.0);
    });

    test('loaded with zero data', () {
      const state = ZatcaVatReportLoaded(
        standardInvoices: {'total_amount': 0.0, 'vat_amount': 0.0, 'count': 0},
        simplifiedInvoices: {'total_amount': 0.0, 'vat_amount': 0.0, 'count': 0},
        totalVatCollected: 0.0,
        totalAmount: 0.0,
      );
      expect(state.totalVatCollected, 0.0);
      expect(state.totalAmount, 0.0);
    });

    test('error state', () {
      const state = ZatcaVatReportError('No data available');
      expect(state.message, 'No data available');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // State Pattern Matching (sealed class exhaustiveness)
  // ═══════════════════════════════════════════════════════════

  group('ZATCA state pattern matching', () {
    test('enrollment state switch exhaustiveness', () {
      const ZatcaEnrollmentState state = ZatcaEnrollmentInitial();
      final result = switch (state) {
        ZatcaEnrollmentInitial() => 'initial',
        ZatcaEnrollmentLoading() => 'loading',
        ZatcaEnrollmentSuccess() => 'success',
        ZatcaEnrollmentError() => 'error',
      };
      expect(result, 'initial');
    });

    test('invoice list state switch with destructuring', () {
      const ZatcaInvoiceListState state = ZatcaInvoiceListLoaded(invoices: [], currentPage: 1, lastPage: 1, total: 0);
      final result = switch (state) {
        ZatcaInvoiceListInitial() => 'initial',
        ZatcaInvoiceListLoading() => 'loading',
        ZatcaInvoiceListLoaded(:final total) => 'loaded:$total',
        ZatcaInvoiceListError(:final message) => 'error:$message',
      };
      expect(result, 'loaded:0');
    });

    test('compliance summary state switch', () {
      const ZatcaComplianceSummaryState state = ZatcaComplianceSummaryError('test-error');
      final result = switch (state) {
        ZatcaComplianceSummaryInitial() => 'initial',
        ZatcaComplianceSummaryLoading() => 'loading',
        ZatcaComplianceSummaryLoaded(:final successRate) => 'loaded:$successRate',
        ZatcaComplianceSummaryError(:final message) => 'error:$message',
      };
      expect(result, 'error:test-error');
    });

    test('vat report state switch', () {
      const ZatcaVatReportState state = ZatcaVatReportLoading();
      final result = switch (state) {
        ZatcaVatReportInitial() => 'initial',
        ZatcaVatReportLoading() => 'loading',
        ZatcaVatReportLoaded(:final totalVatCollected) => 'loaded:$totalVatCollected',
        ZatcaVatReportError(:final message) => 'error:$message',
      };
      expect(result, 'loading');
    });
  });
}
