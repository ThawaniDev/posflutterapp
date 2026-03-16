import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';

final zatcaApiServiceProvider = Provider<ZatcaApiService>((ref) {
  return ZatcaApiService(ref.watch(dioClientProvider));
});

class ZatcaApiService {
  final Dio _dio;

  ZatcaApiService(this._dio);

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
        if (invoiceXml != null) 'invoice_xml': invoiceXml,
        if (digitalSignature != null) 'digital_signature': digitalSignature,
        if (qrCodeData != null) 'qr_code_data': qrCodeData,
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
        if (status != null) 'status': status,
        if (invoiceType != null) 'invoice_type': invoiceType,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (perPage != null) 'per_page': perPage,
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
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }
}
