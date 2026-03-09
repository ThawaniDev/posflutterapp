import 'package:thawani_pos/features/pos_customization/enums/font_size.dart';
import 'package:thawani_pos/features/zatca/enums/zatca_qr_position.dart';

class BusinessTypeReceiptTemplate {
  final String id;
  final String businessTypeId;
  final int? paperWidth;
  final Map<String, dynamic> headerSections;
  final Map<String, dynamic> bodySections;
  final Map<String, dynamic> footerSections;
  final ZatcaQrPosition? zatcaQrPosition;
  final bool? showBilingual;
  final FontSize? fontSize;
  final String? customFooterText;
  final String? customFooterTextAr;

  const BusinessTypeReceiptTemplate({
    required this.id,
    required this.businessTypeId,
    this.paperWidth,
    required this.headerSections,
    required this.bodySections,
    required this.footerSections,
    this.zatcaQrPosition,
    this.showBilingual,
    this.fontSize,
    this.customFooterText,
    this.customFooterTextAr,
  });

  factory BusinessTypeReceiptTemplate.fromJson(Map<String, dynamic> json) {
    return BusinessTypeReceiptTemplate(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      paperWidth: (json['paper_width'] as num?)?.toInt(),
      headerSections: Map<String, dynamic>.from(json['header_sections'] as Map),
      bodySections: Map<String, dynamic>.from(json['body_sections'] as Map),
      footerSections: Map<String, dynamic>.from(json['footer_sections'] as Map),
      zatcaQrPosition: ZatcaQrPosition.tryFromValue(json['zatca_qr_position'] as String?),
      showBilingual: json['show_bilingual'] as bool?,
      fontSize: FontSize.tryFromValue(json['font_size'] as String?),
      customFooterText: json['custom_footer_text'] as String?,
      customFooterTextAr: json['custom_footer_text_ar'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'paper_width': paperWidth,
      'header_sections': headerSections,
      'body_sections': bodySections,
      'footer_sections': footerSections,
      'zatca_qr_position': zatcaQrPosition?.value,
      'show_bilingual': showBilingual,
      'font_size': fontSize?.value,
      'custom_footer_text': customFooterText,
      'custom_footer_text_ar': customFooterTextAr,
    };
  }

  BusinessTypeReceiptTemplate copyWith({
    String? id,
    String? businessTypeId,
    int? paperWidth,
    Map<String, dynamic>? headerSections,
    Map<String, dynamic>? bodySections,
    Map<String, dynamic>? footerSections,
    ZatcaQrPosition? zatcaQrPosition,
    bool? showBilingual,
    FontSize? fontSize,
    String? customFooterText,
    String? customFooterTextAr,
  }) {
    return BusinessTypeReceiptTemplate(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      paperWidth: paperWidth ?? this.paperWidth,
      headerSections: headerSections ?? this.headerSections,
      bodySections: bodySections ?? this.bodySections,
      footerSections: footerSections ?? this.footerSections,
      zatcaQrPosition: zatcaQrPosition ?? this.zatcaQrPosition,
      showBilingual: showBilingual ?? this.showBilingual,
      fontSize: fontSize ?? this.fontSize,
      customFooterText: customFooterText ?? this.customFooterText,
      customFooterTextAr: customFooterTextAr ?? this.customFooterTextAr,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessTypeReceiptTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BusinessTypeReceiptTemplate(id: $id, businessTypeId: $businessTypeId, paperWidth: $paperWidth, headerSections: $headerSections, bodySections: $bodySections, footerSections: $footerSections, ...)';
}
