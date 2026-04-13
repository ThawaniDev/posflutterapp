class ThawaniCategoryMapping {
  final String id;
  final String storeId;
  final String? categoryId;
  final String? thawaniCategoryId;
  final String? syncStatus;
  final String? syncDirection;
  final String? syncError;
  final DateTime? lastSyncedAt;
  final Map<String, dynamic>? category;

  const ThawaniCategoryMapping({
    required this.id,
    required this.storeId,
    this.categoryId,
    this.thawaniCategoryId,
    this.syncStatus,
    this.syncDirection,
    this.syncError,
    this.lastSyncedAt,
    this.category,
  });

  factory ThawaniCategoryMapping.fromJson(Map<String, dynamic> json) {
    return ThawaniCategoryMapping(
      id: json['id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      categoryId: json['category_id']?.toString(),
      thawaniCategoryId: json['thawani_category_id']?.toString(),
      syncStatus: json['sync_status'] as String?,
      syncDirection: json['sync_direction'] as String?,
      syncError: json['sync_error'] as String?,
      lastSyncedAt: json['last_synced_at'] != null ? DateTime.tryParse(json['last_synced_at'].toString()) : null,
      category: json['category'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'category_id': categoryId,
    'thawani_category_id': thawaniCategoryId,
    'sync_status': syncStatus,
    'sync_direction': syncDirection,
    'sync_error': syncError,
    'last_synced_at': lastSyncedAt?.toIso8601String(),
  };
}
