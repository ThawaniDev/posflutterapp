class PendingOrder {
  final String id;
  final String storeId;
  final String? customerId;
  final Map<String, dynamic> itemsJson;
  final double total;
  final String? notes;
  final String createdBy;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const PendingOrder({
    required this.id,
    required this.storeId,
    this.customerId,
    required this.itemsJson,
    required this.total,
    this.notes,
    required this.createdBy,
    this.expiresAt,
    this.createdAt,
  });

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    return PendingOrder(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      itemsJson: Map<String, dynamic>.from(json['items_json'] as Map),
      total: (json['total'] as num).toDouble(),
      notes: json['notes'] as String?,
      createdBy: json['created_by'] as String,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'items_json': itemsJson,
      'total': total,
      'notes': notes,
      'created_by': createdBy,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PendingOrder copyWith({
    String? id,
    String? storeId,
    String? customerId,
    Map<String, dynamic>? itemsJson,
    double? total,
    String? notes,
    String? createdBy,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return PendingOrder(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      itemsJson: itemsJson ?? this.itemsJson,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PendingOrder && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PendingOrder(id: $id, storeId: $storeId, customerId: $customerId, itemsJson: $itemsJson, total: $total, notes: $notes, ...)';
}
