class ThawaniProductMapping {

  const ThawaniProductMapping({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.thawaniProductId,
    this.isPublished,
    this.onlinePrice,
    this.displayOrder,
    this.lastSyncedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ThawaniProductMapping.fromJson(Map<String, dynamic> json) {
    return ThawaniProductMapping(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      productId: json['product_id'] as String,
      thawaniProductId: json['thawani_product_id'] as String,
      isPublished: json['is_published'] as bool?,
      onlinePrice: (json['online_price'] != null ? double.tryParse(json['online_price'].toString()) : null),
      displayOrder: (json['display_order'] as num?)?.toInt(),
      lastSyncedAt: json['last_synced_at'] != null ? DateTime.parse(json['last_synced_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String productId;
  final String thawaniProductId;
  final bool? isPublished;
  final double? onlinePrice;
  final int? displayOrder;
  final DateTime? lastSyncedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'product_id': productId,
      'thawani_product_id': thawaniProductId,
      'is_published': isPublished,
      'online_price': onlinePrice,
      'display_order': displayOrder,
      'last_synced_at': lastSyncedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ThawaniProductMapping copyWith({
    String? id,
    String? storeId,
    String? productId,
    String? thawaniProductId,
    bool? isPublished,
    double? onlinePrice,
    int? displayOrder,
    DateTime? lastSyncedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThawaniProductMapping(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      thawaniProductId: thawaniProductId ?? this.thawaniProductId,
      isPublished: isPublished ?? this.isPublished,
      onlinePrice: onlinePrice ?? this.onlinePrice,
      displayOrder: displayOrder ?? this.displayOrder,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThawaniProductMapping && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ThawaniProductMapping(id: $id, storeId: $storeId, productId: $productId, thawaniProductId: $thawaniProductId, isPublished: $isPublished, onlinePrice: $onlinePrice, ...)';
}
