import 'package:wameedpos/features/zatca/models/zatca_certificate.dart';
import 'package:wameedpos/features/zatca/models/zatca_device.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';

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
  const ZatcaEnrollmentSuccess(this.certificate);
  final Map<String, dynamic> certificate;
}

final class ZatcaEnrollmentError extends ZatcaEnrollmentState {
  const ZatcaEnrollmentError(this.message);
  final String message;
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
  const ZatcaInvoiceListLoaded({
    required this.invoices,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });
  final List<ZatcaInvoice> invoices;
  final int currentPage;
  final int lastPage;
  final int total;
}

final class ZatcaInvoiceListError extends ZatcaInvoiceListState {
  const ZatcaInvoiceListError(this.message);
  final String message;
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

  const ZatcaComplianceSummaryLoaded({
    required this.totalInvoices,
    required this.accepted,
    required this.rejected,
    required this.pending,
    required this.successRate,
    this.certificate,
  });
  final int totalInvoices;
  final int accepted;
  final int rejected;
  final int pending;
  final double successRate;
  final ZatcaCertificate? certificate;
}

final class ZatcaComplianceSummaryError extends ZatcaComplianceSummaryState {
  const ZatcaComplianceSummaryError(this.message);
  final String message;
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

  const ZatcaVatReportLoaded({
    required this.standardInvoices,
    required this.simplifiedInvoices,
    required this.totalVatCollected,
    required this.totalAmount,
  });
  final Map<String, dynamic> standardInvoices;
  final Map<String, dynamic> simplifiedInvoices;
  final double totalVatCollected;
  final double totalAmount;
}

final class ZatcaVatReportError extends ZatcaVatReportState {
  const ZatcaVatReportError(this.message);
  final String message;
}

// ─── Device State ──────────────────────────────────────────
sealed class ZatcaDeviceState {
  const ZatcaDeviceState();
}

final class ZatcaDeviceInitial extends ZatcaDeviceState {
  const ZatcaDeviceInitial();
}

final class ZatcaDeviceLoading extends ZatcaDeviceState {
  const ZatcaDeviceLoading();
}

final class ZatcaDeviceListLoaded extends ZatcaDeviceState {
  const ZatcaDeviceListLoaded(this.devices);
  final List<ZatcaDevice> devices;
}

final class ZatcaDeviceProvisioned extends ZatcaDeviceState {
  const ZatcaDeviceProvisioned({
    required this.deviceId,
    required this.deviceUuid,
    required this.activationCode,
  });
  final String deviceId;
  final String deviceUuid;
  final String activationCode;
}

final class ZatcaDeviceActivated extends ZatcaDeviceState {
  const ZatcaDeviceActivated(this.device);
  final ZatcaDevice device;
}

final class ZatcaDeviceError extends ZatcaDeviceState {
  const ZatcaDeviceError(this.message);
  final String message;
}
