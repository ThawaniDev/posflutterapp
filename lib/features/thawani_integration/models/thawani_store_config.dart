class ThawaniStoreConfig {

  const ThawaniStoreConfig({
    required this.id,
    required this.storeId,
    required this.thawaniStoreId,
    this.isConnected,
    this.autoSyncProducts,
    this.autoSyncInventory,
    this.autoAcceptOrders,
    this.operatingHoursJson,
    this.commissionRate,
    this.connectedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ThawaniStoreConfig.fromJson(Map<String, dynamic> json) {
    return ThawaniStoreConfig(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      thawaniStoreId: json['thawani_store_id'] as String,
      isConnected: json['is_connected'] as bool?,
      autoSyncProducts: json['auto_sync_products'] as bool?,
      autoSyncInventory: json['auto_sync_inventory'] as bool?,
      autoAcceptOrders: json['auto_accept_orders'] as bool?,
      operatingHoursJson: json['operating_hours_json'] != null ? Map<String, dynamic>.from(json['operating_hours_json'] as Map) : null,
      commissionRate: (json['commission_rate'] != null ? double.tryParse(json['commission_rate'].toString()) : null),
      connectedAt: json['connected_at'] != null ? DateTime.parse(json['connected_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String thawaniStoreId;
  final bool? isConnected;
  final bool? autoSyncProducts;
  final bool? autoSyncInventory;
  final bool? autoAcceptOrders;
  final Map<String, dynamic>? operatingHoursJson;
  final double? commissionRate;
  final DateTime? connectedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'thawani_store_id': thawaniStoreId,
      'is_connected': isConnected,
      'auto_sync_products': autoSyncProducts,
      'auto_sync_inventory': autoSyncInventory,
      'auto_accept_orders': autoAcceptOrders,
      'operating_hours_json': operatingHoursJson,
      'commission_rate': commissionRate,
      'connected_at': connectedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ThawaniStoreConfig copyWith({
    String? id,
    String? storeId,
    String? thawaniStoreId,
    bool? isConnected,
    bool? autoSyncProducts,
    bool? autoSyncInventory,
    bool? autoAcceptOrders,
    Map<String, dynamic>? operatingHoursJson,
    double? commissionRate,
    DateTime? connectedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ThawaniStoreConfig(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      thawaniStoreId: thawaniStoreId ?? this.thawaniStoreId,
      isConnected: isConnected ?? this.isConnected,
      autoSyncProducts: autoSyncProducts ?? this.autoSyncProducts,
      autoSyncInventory: autoSyncInventory ?? this.autoSyncInventory,
      autoAcceptOrders: autoAcceptOrders ?? this.autoAcceptOrders,
      operatingHoursJson: operatingHoursJson ?? this.operatingHoursJson,
      commissionRate: commissionRate ?? this.commissionRate,
      connectedAt: connectedAt ?? this.connectedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThawaniStoreConfig && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ThawaniStoreConfig(id: $id, storeId: $storeId, thawaniStoreId: $thawaniStoreId, isConnected: $isConnected, autoSyncProducts: $autoSyncProducts, autoSyncInventory: $autoSyncInventory, ...)';
}
