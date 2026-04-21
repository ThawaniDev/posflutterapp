import 'package:wameedpos/features/settings/enums/translation_category.dart';

class MasterTranslationString {

  const MasterTranslationString({
    required this.id,
    required this.stringKey,
    required this.category,
    required this.valueEn,
    required this.valueAr,
    this.description,
    this.isOverridable,
    this.updatedAt,
  });

  factory MasterTranslationString.fromJson(Map<String, dynamic> json) {
    return MasterTranslationString(
      id: json['id'] as String,
      stringKey: json['string_key'] as String,
      category: TranslationCategory.fromValue(json['category'] as String),
      valueEn: json['value_en'] as String,
      valueAr: json['value_ar'] as String,
      description: json['description'] as String?,
      isOverridable: json['is_overridable'] as bool?,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String stringKey;
  final TranslationCategory category;
  final String valueEn;
  final String valueAr;
  final String? description;
  final bool? isOverridable;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'string_key': stringKey,
      'category': category.value,
      'value_en': valueEn,
      'value_ar': valueAr,
      'description': description,
      'is_overridable': isOverridable,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  MasterTranslationString copyWith({
    String? id,
    String? stringKey,
    TranslationCategory? category,
    String? valueEn,
    String? valueAr,
    String? description,
    bool? isOverridable,
    DateTime? updatedAt,
  }) {
    return MasterTranslationString(
      id: id ?? this.id,
      stringKey: stringKey ?? this.stringKey,
      category: category ?? this.category,
      valueEn: valueEn ?? this.valueEn,
      valueAr: valueAr ?? this.valueAr,
      description: description ?? this.description,
      isOverridable: isOverridable ?? this.isOverridable,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is MasterTranslationString && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'MasterTranslationString(id: $id, stringKey: $stringKey, category: $category, valueEn: $valueEn, valueAr: $valueAr, description: $description, ...)';
}
