import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';

class ZatcaInvoiceDetail {
  const ZatcaInvoiceDetail({
    required this.invoice,
    this.qrCodeBase64,
    this.xml,
    this.clearedXml,
  });

  factory ZatcaInvoiceDetail.fromJson(Map<String, dynamic> json) {
    return ZatcaInvoiceDetail(
      invoice: ZatcaInvoice.fromJson(
        Map<String, dynamic>.from(json['invoice'] as Map),
      ),
      qrCodeBase64: json['qr_code_base64'] as String?,
      xml: json['xml'] as String?,
      clearedXml: json['cleared_xml'] as String?,
    );
  }

  final ZatcaInvoice invoice;
  final String? qrCodeBase64;
  final String? xml;
  final String? clearedXml;
}
