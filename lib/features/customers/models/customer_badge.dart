class CustomerBadge {

  const CustomerBadge({
    required this.id,
    required this.customerId,
    required this.badgeId,
    this.earnedAt,
  });

  factory CustomerBadge.fromJson(Map<String, dynamic> json) {
    return CustomerBadge(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      badgeId: json['badge_id'] as String,
      earnedAt: json['earned_at'] != null ? DateTime.parse(json['earned_at'] as String) : null,
    );
  }
  final String id;
  final String customerId;
  final String badgeId;
  final DateTime? earnedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'badge_id': badgeId,
      'earned_at': earnedAt?.toIso8601String(),
    };
  }

  CustomerBadge copyWith({
    String? id,
    String? customerId,
    String? badgeId,
    DateTime? earnedAt,
  }) {
    return CustomerBadge(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      badgeId: badgeId ?? this.badgeId,
      earnedAt: earnedAt ?? this.earnedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerBadge && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomerBadge(id: $id, customerId: $customerId, badgeId: $badgeId, earnedAt: $earnedAt)';
}
