import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/zatca_api_service.dart';

final zatcaRepositoryProvider = Provider<ZatcaRepository>((ref) {
  return ZatcaRepository(ref.watch(zatcaApiServiceProvider));
});

class ZatcaRepository {
  final ZatcaApiService _apiService;

  ZatcaRepository(this._apiService);

  Future<Map<String, dynamic>> enroll({
    required String otp,
    required String environment,
  }) =>
      _apiService.enroll(otp: otp, environment: environment);

  Future<Map<String, dynamic>> renewCertificate() =>
      _apiService.renewCertificate();

  Future<Map<String, dynamic>> submitInvoice({
    required String orderId,
    required String invoiceNumber,
    required String invoiceType,
    required double totalAmount,
    required double vatAmount,
    String? invoiceXml,
    String? digitalSignature,
    String? qrCodeData,
  }) =>
      _apiService.submitInvoice(
        orderId: orderId,
        invoiceNumber: invoiceNumber,
        invoiceType: invoiceType,
        totalAmount: totalAmount,
        vatAmount: vatAmount,
        invoiceXml: invoiceXml,
        digitalSignature: digitalSignature,
        qrCodeData: qrCodeData,
      );

  Future<Map<String, dynamic>> submitBatch({
    required List<Map<String, dynamic>> invoices,
  }) =>
      _apiService.submitBatch(invoices: invoices);

  Future<Map<String, dynamic>> listInvoices({
    String? status,
    String? invoiceType,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  }) =>
      _apiService.listInvoices(
        status: status,
        invoiceType: invoiceType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        perPage: perPage,
      );

  Future<String> getInvoiceXml(String invoiceId) =>
      _apiService.getInvoiceXml(invoiceId);

  Future<Map<String, dynamic>> complianceSummary() =>
      _apiService.complianceSummary();

  Future<Map<String, dynamic>> vatReport({
    String? dateFrom,
    String? dateTo,
  }) =>
      _apiService.vatReport(dateFrom: dateFrom, dateTo: dateTo);
}
