class MarketplaceCategory {

  const MarketplaceCategory({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.iconUrl,
    this.listingCount = 0,
    this.sortOrder = 0,
    this.createdAt,
  });

  factory MarketplaceCategory.fromJson(Map<String, dynamic> json) {
    return MarketplaceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      listingCount: (json['listing_count'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? iconUrl;
  final int listingCount;
  final int sortOrder;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'icon_url': iconUrl,
      'listing_count': listingCount,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is MarketplaceCategory && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
