import 'package:wameedpos/features/onboarding/enums/signage_template_type.dart';

class SignageTemplate {
  final String id;
  final String name;
  final String nameAr;
  final String slug;
  final SignageTemplateType templateType;
  final Map<String, dynamic> layoutConfig;
  final Map<String, dynamic>? placeholderContent;
  final String? backgroundColor;
  final String? textColor;
  final String? fontFamily;
  final String? transitionStyle;
  final String? previewImageUrl;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SignageTemplate({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.slug,
    required this.templateType,
    required this.layoutConfig,
    this.placeholderContent,
    this.backgroundColor,
    this.textColor,
    this.fontFamily,
    this.transitionStyle,
    this.previewImageUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory SignageTemplate.fromJson(Map<String, dynamic> json) {
    return SignageTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String,
      slug: json['slug'] as String,
      templateType: SignageTemplateType.fromValue(json['template_type'] as String),
      layoutConfig: Map<String, dynamic>.from(json['layout_config'] as Map),
      placeholderContent: json['placeholder_content'] != null
          ? Map<String, dynamic>.from(json['placeholder_content'] as Map)
          : null,
      backgroundColor: json['background_color'] as String?,
      textColor: json['text_color'] as String?,
      fontFamily: json['font_family'] as String?,
      transitionStyle: json['transition_style'] as String?,
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
      'template_type': templateType.value,
      'layout_config': layoutConfig,
      'placeholder_content': placeholderContent,
      'background_color': backgroundColor,
      'text_color': textColor,
      'font_family': fontFamily,
      'transition_style': transitionStyle,
      'preview_image_url': previewImageUrl,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SignageTemplate copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? slug,
    SignageTemplateType? templateType,
    Map<String, dynamic>? layoutConfig,
    Map<String, dynamic>? placeholderContent,
    String? backgroundColor,
    String? textColor,
    String? fontFamily,
    String? transitionStyle,
    String? previewImageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SignageTemplate(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      slug: slug ?? this.slug,
      templateType: templateType ?? this.templateType,
      layoutConfig: layoutConfig ?? this.layoutConfig,
      placeholderContent: placeholderContent ?? this.placeholderContent,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textColor: textColor ?? this.textColor,
      fontFamily: fontFamily ?? this.fontFamily,
      transitionStyle: transitionStyle ?? this.transitionStyle,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SignageTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SignageTemplate(id: $id, name: $name, nameAr: $nameAr, slug: $slug, templateType: $templateType, layoutConfig: $layoutConfig, ...)';
}
