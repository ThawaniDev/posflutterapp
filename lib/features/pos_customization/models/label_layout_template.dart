import 'package:thawani_pos/features/catalog/enums/barcode_type.dart';
import 'package:thawani_pos/features/pos_customization/enums/border_style.dart';
import 'package:thawani_pos/features/pos_customization/enums/font_size.dart';
import 'package:thawani_pos/features/labels/enums/label_type.dart';

class LabelLayoutTemplate {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final LabelType labelType;
  final int labelWidthMm;
  final int labelHeightMm;
  final BarcodeType? barcodeType;
  final Map<String, dynamic>? barcodePosition;
  final bool? showBarcodeNumber;
  final Map<String, dynamic> fieldLayout;
  final String? fontFamily;
  final FontSize? defaultFontSize;
  final bool? showBorder;
  final BorderStyle? borderStyle;
  final String? backgroundColor;
  final String? previewImageUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const LabelLayoutTemplate({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.labelType,
    required this.labelWidthMm,
    required this.labelHeightMm,
    this.barcodeType,
    this.barcodePosition,
    this.showBarcodeNumber,
    required this.fieldLayout,
    this.fontFamily,
    this.defaultFontSize,
    this.showBorder,
    this.borderStyle,
    this.backgroundColor,
    this.previewImageUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory LabelLayoutTemplate.fromJson(Map<String, dynamic> json) {
    return LabelLayoutTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      labelType: LabelType.fromValue(json['label_type'] as String),
      labelWidthMm: (json['label_width_mm'] as num).toInt(),
      labelHeightMm: (json['label_height_mm'] as num).toInt(),
      barcodeType: BarcodeType.tryFromValue(json['barcode_type'] as String?),
      barcodePosition: json['barcode_position'] != null ? Map<String, dynamic>.from(json['barcode_position'] as Map) : null,
      showBarcodeNumber: json['show_barcode_number'] as bool?,
      fieldLayout: Map<String, dynamic>.from(json['field_layout'] as Map),
      fontFamily: json['font_family'] as String?,
      defaultFontSize: FontSize.tryFromValue(json['default_font_size'] as String?),
      showBorder: json['show_border'] as bool?,
      borderStyle: BorderStyle.tryFromValue(json['border_style'] as String?),
      backgroundColor: json['background_color'] as String?,
      previewImageUrl: json['preview_image_url'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'label_type': labelType.value,
      'label_width_mm': labelWidthMm,
      'label_height_mm': labelHeightMm,
      'barcode_type': barcodeType?.value,
      'barcode_position': barcodePosition,
      'show_barcode_number': showBarcodeNumber,
      'field_layout': fieldLayout,
      'font_family': fontFamily,
      'default_font_size': defaultFontSize?.value,
      'show_border': showBorder,
      'border_style': borderStyle?.value,
      'background_color': backgroundColor,
      'preview_image_url': previewImageUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  LabelLayoutTemplate copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    LabelType? labelType,
    int? labelWidthMm,
    int? labelHeightMm,
    BarcodeType? barcodeType,
    Map<String, dynamic>? barcodePosition,
    bool? showBarcodeNumber,
    Map<String, dynamic>? fieldLayout,
    String? fontFamily,
    FontSize? defaultFontSize,
    bool? showBorder,
    BorderStyle? borderStyle,
    String? backgroundColor,
    String? previewImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LabelLayoutTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      labelType: labelType ?? this.labelType,
      labelWidthMm: labelWidthMm ?? this.labelWidthMm,
      labelHeightMm: labelHeightMm ?? this.labelHeightMm,
      barcodeType: barcodeType ?? this.barcodeType,
      barcodePosition: barcodePosition ?? this.barcodePosition,
      showBarcodeNumber: showBarcodeNumber ?? this.showBarcodeNumber,
      fieldLayout: fieldLayout ?? this.fieldLayout,
      fontFamily: fontFamily ?? this.fontFamily,
      defaultFontSize: defaultFontSize ?? this.defaultFontSize,
      showBorder: showBorder ?? this.showBorder,
      borderStyle: borderStyle ?? this.borderStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelLayoutTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LabelLayoutTemplate(id: $id, name: $name, nameAr: $nameAr, slug: $slug, labelType: $labelType, labelWidthMm: $labelWidthMm, ...)';
}
