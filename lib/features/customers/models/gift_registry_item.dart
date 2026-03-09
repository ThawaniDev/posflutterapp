class GiftRegistryItem {
  final String id;
  final String registryId;
  final String productId;
  final int? quantityDesired;
  final int? quantityPurchased;
  final String? purchasedByName;
  final DateTime? createdAt;

  const GiftRegistryItem({
    required this.id,
    required this.registryId,
    required this.productId,
    this.quantityDesired,
    this.quantityPurchased,
    this.purchasedByName,
    this.createdAt,
  });

  factory GiftRegistryItem.fromJson(Map<String, dynamic> json) {
    return GiftRegistryItem(
      id: json['id'] as String,
      registryId: json['registry_id'] as String,
      productId: json['product_id'] as String,
      quantityDesired: (json['quantity_desired'] as num?)?.toInt(),
      quantityPurchased: (json['quantity_purchased'] as num?)?.toInt(),
      purchasedByName: json['purchased_by_name'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registry_id': registryId,
      'product_id': productId,
      'quantity_desired': quantityDesired,
      'quantity_purchased': quantityPurchased,
      'purchased_by_name': purchasedByName,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  GiftRegistryItem copyWith({
    String? id,
    String? registryId,
    String? productId,
    int? quantityDesired,
    int? quantityPurchased,
    String? purchasedByName,
    DateTime? createdAt,
  }) {
    return GiftRegistryItem(
      id: id ?? this.id,
      registryId: registryId ?? this.registryId,
      productId: productId ?? this.productId,
      quantityDesired: quantityDesired ?? this.quantityDesired,
      quantityPurchased: quantityPurchased ?? this.quantityPurchased,
      purchasedByName: purchasedByName ?? this.purchasedByName,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiftRegistryItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'GiftRegistryItem(id: $id, registryId: $registryId, productId: $productId, quantityDesired: $quantityDesired, quantityPurchased: $quantityPurchased, purchasedByName: $purchasedByName, ...)';
}
