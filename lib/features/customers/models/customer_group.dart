class CustomerGroup {
  final String id;
  final String organizationId;
  final String name;
  final double? discountPercent;
  final DateTime? createdAt;

  const CustomerGroup({
    required this.id,
    required this.organizationId,
    required this.name,
    this.discountPercent,
    this.createdAt,
  });

  factory CustomerGroup.fromJson(Map<String, dynamic> json) {
    return CustomerGroup(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      name: json['name'] as String,
      discountPercent: (json['discount_percent'] as num?)?.toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'name': name,
      'discount_percent': discountPercent,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CustomerGroup copyWith({
    String? id,
    String? organizationId,
    String? name,
    double? discountPercent,
    DateTime? createdAt,
  }) {
    return CustomerGroup(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerGroup && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomerGroup(id: $id, organizationId: $organizationId, name: $name, discountPercent: $discountPercent, createdAt: $createdAt)';
}
