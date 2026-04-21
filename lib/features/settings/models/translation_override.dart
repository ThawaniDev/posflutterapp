class TranslationOverride {

  const TranslationOverride({
    required this.id,
    required this.storeId,
    required this.stringKey,
    required this.locale,
    required this.customValue,
    this.updatedAt,
  });

  factory TranslationOverride.fromJson(Map<String, dynamic> json) {
    return TranslationOverride(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      stringKey: json['string_key'] as String,
      locale: json['locale'] as String,
      customValue: json['custom_value'] as String,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String stringKey;
  final String locale;
  final String customValue;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'string_key': stringKey,
      'locale': locale,
      'custom_value': customValue,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  TranslationOverride copyWith({
    String? id,
    String? storeId,
    String? stringKey,
    String? locale,
    String? customValue,
    DateTime? updatedAt,
  }) {
    return TranslationOverride(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      stringKey: stringKey ?? this.stringKey,
      locale: locale ?? this.locale,
      customValue: customValue ?? this.customValue,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslationOverride && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TranslationOverride(id: $id, storeId: $storeId, stringKey: $stringKey, locale: $locale, customValue: $customValue, updatedAt: $updatedAt)';
}
