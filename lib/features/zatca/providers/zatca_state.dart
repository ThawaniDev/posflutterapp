import '../models/zatca_certificate.dart';
import '../models/zatca_invoice.dart';

// ─── Enrollment State ──────────────────────────────────────
sealed class ZatcaEnrollmentState {
  const ZatcaEnrollmentState();
}

final class ZatcaEnrollmentInitial extends ZatcaEnrollmentState {
  const ZatcaEnrollmentInitial();
}

final class ZatcaEnrollmentLoading extends ZatcaEnrollmentState {
  const ZatcaEnrollmentLoading();
}

final class ZatcaEnrollmentSuccess extends ZatcaEnrollmentState {
  final Map<String, dynamic> certificate;
  const ZatcaEnrollmentSuccess(this.certificate);
}

final class ZatcaEnrollmentError extends ZatcaEnrollmentState {
  final String message;
  const ZatcaEnrollmentError(this.message);
}

// ─── Invoice List State ────────────────────────────────────
sealed class ZatcaInvoiceListState {
  const ZatcaInvoiceListState();
}

final class ZatcaInvoiceListInitial extends ZatcaInvoiceListState {
  const ZatcaInvoiceListInitial();
}

final class ZatcaInvoiceListLoading extends ZatcaInvoiceListState {
  const ZatcaInvoiceListLoading();
}

final class ZatcaInvoiceListLoaded extends ZatcaInvoiceListState {
  final List<ZatcaInvoice> invoices;
  final int currentPage;
  final int lastPage;
  final int total;
  const ZatcaInvoiceListLoaded({
    required this.invoices,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
}

final class ZatcaInvoiceListError extends ZatcaInvoiceListState {
  final String message;
  const ZatcaInvoiceListError(this.message);
}

// ─── Compliance Summary State ──────────────────────────────
sealed class ZatcaComplianceSummaryState {
  const ZatcaComplianceSummaryState();
}

final class ZatcaComplianceSummaryInitial extends ZatcaComplianceSummaryState {
  const ZatcaComplianceSummaryInitial();
}

final class ZatcaComplianceSummaryLoading extends ZatcaComplianceSummaryState {
  const ZatcaComplianceSummaryLoading();
}

final class ZatcaComplianceSummaryLoaded extends ZatcaComplianceSummaryState {
  final int totalInvoices;
  final int accepted;
  final int rejected;
  final int pending;
  final double successRate;
  final ZatcaCertificate? certificate;

  const ZatcaComplianceSummaryLoaded({
    required this.totalInvoices,
    required this.accepted,
    required this.rejected,
    required this.pending,
    required this.successRate,
    this.certificate,
  });
}

final class ZatcaComplianceSummaryError extends ZatcaComplianceSummaryState {
  final String message;
  const ZatcaComplianceSummaryError(this.message);
}

// ─── VAT Report State ──────────────────────────────────────
sealed class ZatcaVatReportState {
  const ZatcaVatReportState();
}

final class ZatcaVatReportInitial extends ZatcaVatReportState {
  const ZatcaVatReportInitial();
}

final class ZatcaVatReportLoading extends ZatcaVatReportState {
  const ZatcaVatReportLoading();
}

final class ZatcaVatReportLoaded extends ZatcaVatReportState {
  final Map<String, dynamic> standardInvoices;
  final Map<String, dynamic> simplifiedInvoices;
  final double totalVatCollected;
  final double totalAmount;

  const ZatcaVatReportLoaded({
    required this.standardInvoices,
    required this.simplifiedInvoices,
    required this.totalVatCollected,
    required this.totalAmount,
  });
}

final class ZatcaVatReportError extends ZatcaVatReportState {
  final String message;
  const ZatcaVatReportError(this.message);
}
