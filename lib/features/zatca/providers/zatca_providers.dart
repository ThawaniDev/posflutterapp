import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/zatca/models/zatca_certificate.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';
import 'package:wameedpos/features/zatca/repositories/zatca_repository.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

// ─── Enrollment Provider ───────────────────────────────────────

final zatcaEnrollmentProvider =
    StateNotifierProvider<ZatcaEnrollmentNotifier, ZatcaEnrollmentState>((ref) {
  return ZatcaEnrollmentNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaEnrollmentNotifier extends StateNotifier<ZatcaEnrollmentState> {

  ZatcaEnrollmentNotifier(this._repo) : super(const ZatcaEnrollmentInitial());
  final ZatcaRepository _repo;

  Future<void> enroll({
    required String otp,
    required String environment,
  }) async {
    state = const ZatcaEnrollmentLoading();
    try {
      final result = await _repo.enroll(otp: otp, environment: environment);
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaEnrollmentSuccess(data);
    } catch (e) {
      state = ZatcaEnrollmentError(e.toString());
    }
  }

  Future<void> renew() async {
    state = const ZatcaEnrollmentLoading();
    try {
      final result = await _repo.renewCertificate();
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaEnrollmentSuccess(data);
    } catch (e) {
      state = ZatcaEnrollmentError(e.toString());
    }
  }
}

// ─── Invoice List Provider ─────────────────────────────────────

final zatcaInvoiceListProvider =
    StateNotifierProvider<ZatcaInvoiceListNotifier, ZatcaInvoiceListState>(
        (ref) {
  return ZatcaInvoiceListNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaInvoiceListNotifier extends StateNotifier<ZatcaInvoiceListState> {

  ZatcaInvoiceListNotifier(this._repo)
      : super(const ZatcaInvoiceListInitial());
  final ZatcaRepository _repo;

  Future<void> load({
    String? status,
    String? invoiceType,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  }) async {
    state = const ZatcaInvoiceListLoading();
    try {
      final result = await _repo.listInvoices(
        status: status,
        invoiceType: invoiceType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        perPage: perPage,
      );
      final data = result['data'] as Map<String, dynamic>;
      final items = (data['data'] as List)
          .map((e) => ZatcaInvoice.fromJson(e as Map<String, dynamic>))
          .toList();
      final meta = data['meta'] as Map<String, dynamic>;
      state = ZatcaInvoiceListLoaded(
        invoices: items,
        currentPage: meta['current_page'] as int,
        lastPage: meta['last_page'] as int,
        total: meta['total'] as int,
      );
    } catch (e) {
      state = ZatcaInvoiceListError(e.toString());
    }
  }
}

// ─── Compliance Summary Provider ───────────────────────────────

final zatcaComplianceSummaryProvider = StateNotifierProvider<
    ZatcaComplianceSummaryNotifier, ZatcaComplianceSummaryState>((ref) {
  return ZatcaComplianceSummaryNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaComplianceSummaryNotifier
    extends StateNotifier<ZatcaComplianceSummaryState> {

  ZatcaComplianceSummaryNotifier(this._repo)
      : super(const ZatcaComplianceSummaryInitial());
  final ZatcaRepository _repo;

  Future<void> load() async {
    state = const ZatcaComplianceSummaryLoading();
    try {
      final result = await _repo.complianceSummary();
      final data = result['data'] as Map<String, dynamic>;
      final certData = data['certificate'] as Map<String, dynamic>?;
      state = ZatcaComplianceSummaryLoaded(
        totalInvoices: data['total_invoices'] as int,
        accepted: data['accepted'] as int,
        rejected: data['rejected'] as int,
        pending: data['pending'] as int,
        successRate: double.tryParse(data['success_rate'].toString()) ?? 0.0,
        certificate: certData != null
            ? ZatcaCertificate.fromJson(certData)
            : null,
      );
    } catch (e) {
      state = ZatcaComplianceSummaryError(e.toString());
    }
  }
}

// ─── VAT Report Provider ───────────────────────────────────────

final zatcaVatReportProvider =
    StateNotifierProvider<ZatcaVatReportNotifier, ZatcaVatReportState>((ref) {
  return ZatcaVatReportNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaVatReportNotifier extends StateNotifier<ZatcaVatReportState> {

  ZatcaVatReportNotifier(this._repo) : super(const ZatcaVatReportInitial());
  final ZatcaRepository _repo;

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const ZatcaVatReportLoading();
    try {
      final result = await _repo.vatReport(
        dateFrom: dateFrom,
        dateTo: dateTo,
      );
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaVatReportLoaded(
        standardInvoices:
            Map<String, dynamic>.from(data['standard_invoices'] as Map),
        simplifiedInvoices:
            Map<String, dynamic>.from(data['simplified_invoices'] as Map),
        totalVatCollected: double.tryParse(data['total_vat_collected'].toString()) ?? 0.0,
        totalAmount: double.tryParse(data['total_amount'].toString()) ?? 0.0,
      );
    } catch (e) {
      state = ZatcaVatReportError(e.toString());
    }
  }
}
