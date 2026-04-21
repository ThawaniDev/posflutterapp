class LoyaltyBadge {

  const LoyaltyBadge({
    required this.id,
    required this.storeId,
    required this.nameAr,
    required this.nameEn,
    this.iconUrl,
    this.descriptionAr,
    this.descriptionEn,
    this.createdAt,
  });

  factory LoyaltyBadge.fromJson(Map<String, dynamic> json) {
    return LoyaltyBadge(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      iconUrl: json['icon_url'] as String?,
      descriptionAr: json['description_ar'] as String?,
      descriptionEn: json['description_en'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String nameAr;
  final String nameEn;
  final String? iconUrl;
  final String? descriptionAr;
  final String? descriptionEn;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'icon_url': iconUrl,
      'description_ar': descriptionAr,
      'description_en': descriptionEn,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  LoyaltyBadge copyWith({
    String? id,
    String? storeId,
    String? nameAr,
    String? nameEn,
    String? iconUrl,
    String? descriptionAr,
    String? descriptionEn,
    DateTime? createdAt,
  }) {
    return LoyaltyBadge(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      iconUrl: iconUrl ?? this.iconUrl,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoyaltyBadge && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LoyaltyBadge(id: $id, storeId: $storeId, nameAr: $nameAr, nameEn: $nameEn, iconUrl: $iconUrl, descriptionAr: $descriptionAr, ...)';
}
