import 'package:wameedpos/features/zatca/enums/zatca_qr_position.dart';

class ReceiptLayoutTemplate {

  const ReceiptLayoutTemplate({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.paperWidth,
    required this.headerConfig,
    required this.bodyConfig,
    required this.footerConfig,
    this.zatcaQrPosition,
    this.showBilingual,
    this.isActive,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory ReceiptLayoutTemplate.fromJson(Map<String, dynamic> json) {
    return ReceiptLayoutTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      paperWidth: (json['paper_width'] as num).toInt(),
      headerConfig: Map<String, dynamic>.from(json['header_config'] as Map),
      bodyConfig: Map<String, dynamic>.from(json['body_config'] as Map),
      footerConfig: Map<String, dynamic>.from(json['footer_config'] as Map),
      zatcaQrPosition: ZatcaQrPosition.tryFromValue(json['zatca_qr_position'] as String?),
      showBilingual: json['show_bilingual'] as bool?,
      isActive: json['is_active'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final int paperWidth;
  final Map<String, dynamic> headerConfig;
  final Map<String, dynamic> bodyConfig;
  final Map<String, dynamic> footerConfig;
  final ZatcaQrPosition? zatcaQrPosition;
  final bool? showBilingual;
  final bool? isActive;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'paper_width': paperWidth,
      'header_config': headerConfig,
      'body_config': bodyConfig,
      'footer_config': footerConfig,
      'zatca_qr_position': zatcaQrPosition?.value,
      'show_bilingual': showBilingual,
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ReceiptLayoutTemplate copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    int? paperWidth,
    Map<String, dynamic>? headerConfig,
    Map<String, dynamic>? bodyConfig,
    Map<String, dynamic>? footerConfig,
    ZatcaQrPosition? zatcaQrPosition,
    bool? showBilingual,
    bool? isActive,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ReceiptLayoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      paperWidth: paperWidth ?? this.paperWidth,
      headerConfig: headerConfig ?? this.headerConfig,
      bodyConfig: bodyConfig ?? this.bodyConfig,
      footerConfig: footerConfig ?? this.footerConfig,
      zatcaQrPosition: zatcaQrPosition ?? this.zatcaQrPosition,
      showBilingual: showBilingual ?? this.showBilingual,
      isActive: isActive ?? this.isActive,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReceiptLayoutTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ReceiptLayoutTemplate(id: $id, name: $name, nameAr: $nameAr, slug: $slug, paperWidth: $paperWidth, headerConfig: $headerConfig, ...)';
}
