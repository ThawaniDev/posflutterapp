import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';

final zatcaApiServiceProvider = Provider<ZatcaApiService>((ref) {
  return ZatcaApiService(ref.watch(dioClientProvider));
});

class ZatcaApiService {

  ZatcaApiService(this._dio);
  final Dio _dio;

  Future<Map<String, dynamic>> enroll({
    required String otp,
    required String environment,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.zatcaEnroll,
      data: {'otp': otp, 'environment': environment},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> renewCertificate() async {
    final response = await _dio.post(ApiEndpoints.zatcaRenew);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> submitInvoice({
    required String orderId,
    required String invoiceNumber,
    required String invoiceType,
    required double totalAmount,
    required double vatAmount,
    String? invoiceXml,
    String? digitalSignature,
    String? qrCodeData,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.zatcaSubmitInvoice,
      data: {
        'order_id': orderId,
        'invoice_number': invoiceNumber,
        'invoice_type': invoiceType,
        'total_amount': totalAmount,
        'vat_amount': vatAmount,
        'invoice_xml': ?invoiceXml,
        'digital_signature': ?digitalSignature,
        'qr_code_data': ?qrCodeData,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> submitBatch({
    required List<Map<String, dynamic>> invoices,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.zatcaSubmitBatch,
      data: {'invoices': invoices},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> listInvoices({
    String? status,
    String? invoiceType,
    String? dateFrom,
    String? dateTo,
    int? perPage,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.zatcaInvoices,
      queryParameters: {
        'status': ?status,
        'invoice_type': ?invoiceType,
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
        'per_page': ?perPage,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<String> getInvoiceXml(String invoiceId) async {
    final response = await _dio.get(
      ApiEndpoints.zatcaInvoiceXml(invoiceId),
      options: Options(responseType: ResponseType.plain),
    );
    return response.data as String;
  }

  Future<Map<String, dynamic>> complianceSummary() async {
    final response = await _dio.get(ApiEndpoints.zatcaComplianceSummary);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> vatReport({
    String? dateFrom,
    String? dateTo,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.zatcaVatReport,
      queryParameters: {
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  // ─── Phase 2 device + chain endpoints ─────────────────────

  Future<Map<String, dynamic>> listDevices() async {
    final response = await _dio.get(ApiEndpoints.zatcaDevices);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> provisionDevice({String environment = 'sandbox'}) async {
    final response = await _dio.post(
      ApiEndpoints.zatcaDevices,
      data: {'environment': environment},
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> activateDevice({
    required String activationCode,
    String? hardwareSerial,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.zatcaDeviceActivate,
      data: {
        'activation_code': activationCode,
        'hardware_serial': ?hardwareSerial,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> resetDeviceTamper(String deviceId) async {
    final response = await _dio.post(ApiEndpoints.zatcaDeviceResetTamper(deviceId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> verifyChain(String deviceId) async {
    final response = await _dio.get(ApiEndpoints.zatcaDeviceVerifyChain(deviceId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> dashboard() async {
    final response = await _dio.get(ApiEndpoints.zatcaDashboard);
    return Map<String, dynamic>.from(response.data as Map);
  }

  // ─── Phase 2 production-visibility endpoints ──────────────

  Future<Map<String, dynamic>> getInvoiceDetail(String invoiceId) async {
    final response = await _dio.get(ApiEndpoints.zatcaInvoiceDetail(invoiceId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> retrySubmission(String invoiceId) async {
    final response = await _dio.post(ApiEndpoints.zatcaInvoiceRetry(invoiceId));
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> connectionStatus() async {
    final response = await _dio.get(ApiEndpoints.zatcaConnection);
    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> adminOverview() async {
    final response = await _dio.get(ApiEndpoints.zatcaAdminOverview);
    return Map<String, dynamic>.from(response.data as Map);
  }
}
