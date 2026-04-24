import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/zatca/data/remote/zatca_api_service.dart';

final zatcaRepositoryProvider = Provider<ZatcaRepository>((ref) {
  return ZatcaRepository(ref.watch(zatcaApiServiceProvider));
});

class ZatcaRepository {
  ZatcaRepository(this._apiService);
  final ZatcaApiService _apiService;

  Future<Map<String, dynamic>> enroll({required String otp, required String environment}) =>
      _apiService.enroll(otp: otp, environment: environment);

  Future<Map<String, dynamic>> renewCertificate() => _apiService.renewCertificate();

  Future<Map<String, dynamic>> submitInvoice({
    required String orderId,
    required String invoiceNumber,
    required String invoiceType,
    required double totalAmount,
    required double vatAmount,
    String? invoiceXml,
    String? digitalSignature,
    String? qrCodeData,
  }) => _apiService.submitInvoice(
    orderId: orderId,
    invoiceNumber: invoiceNumber,
    invoiceType: invoiceType,
    totalAmount: totalAmount,
    vatAmount: vatAmount,
    invoiceXml: invoiceXml,
    digitalSignature: digitalSignature,
    qrCodeData: qrCodeData,
  );

  Future<Map<String, dynamic>> submitBatch({required List<Map<String, dynamic>> invoices}) =>
      _apiService.submitBatch(invoices: invoices);

  Future<Map<String, dynamic>> listInvoices({
    String? status,
    String? invoiceType,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  }) => _apiService.listInvoices(status: status, invoiceType: invoiceType, dateFrom: dateFrom, dateTo: dateTo, perPage: perPage);

  Future<String> getInvoiceXml(String invoiceId) => _apiService.getInvoiceXml(invoiceId);

  Future<Map<String, dynamic>> complianceSummary() => _apiService.complianceSummary();

  Future<Map<String, dynamic>> vatReport({String? dateFrom, String? dateTo}) =>
      _apiService.vatReport(dateFrom: dateFrom, dateTo: dateTo);

  // ─── Phase 2 device + chain ───────────────────────────────

  Future<Map<String, dynamic>> listDevices() => _apiService.listDevices();

  Future<Map<String, dynamic>> provisionDevice({String environment = 'sandbox'}) =>
      _apiService.provisionDevice(environment: environment);

  Future<Map<String, dynamic>> activateDevice({required String activationCode, String? hardwareSerial}) =>
      _apiService.activateDevice(activationCode: activationCode, hardwareSerial: hardwareSerial);

  Future<Map<String, dynamic>> resetDeviceTamper(String deviceId) => _apiService.resetDeviceTamper(deviceId);

  Future<Map<String, dynamic>> verifyChain(String deviceId) => _apiService.verifyChain(deviceId);

  Future<Map<String, dynamic>> dashboard() => _apiService.dashboard();

  // ─── Phase 2 production-visibility ────────────────────────

  Future<Map<String, dynamic>> getInvoiceDetail(String invoiceId) => _apiService.getInvoiceDetail(invoiceId);

  Future<Map<String, dynamic>> retrySubmission(String invoiceId) => _apiService.retrySubmission(invoiceId);

  Future<Map<String, dynamic>> connectionStatus() => _apiService.connectionStatus();

  Future<Map<String, dynamic>> adminOverview() => _apiService.adminOverview();
}
