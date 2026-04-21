class AdminIpAllowlist {

  const AdminIpAllowlist({
    required this.id,
    required this.ipAddress,
    this.label,
    required this.addedBy,
    this.createdAt,
  });

  factory AdminIpAllowlist.fromJson(Map<String, dynamic> json) {
    return AdminIpAllowlist(
      id: json['id'] as String,
      ipAddress: json['ip_address'] as String,
      label: json['label'] as String?,
      addedBy: json['added_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String ipAddress;
  final String? label;
  final String addedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip_address': ipAddress,
      'label': label,
      'added_by': addedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AdminIpAllowlist copyWith({
    String? id,
    String? ipAddress,
    String? label,
    String? addedBy,
    DateTime? createdAt,
  }) {
    return AdminIpAllowlist(
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      label: label ?? this.label,
      addedBy: addedBy ?? this.addedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminIpAllowlist && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminIpAllowlist(id: $id, ipAddress: $ipAddress, label: $label, addedBy: $addedBy, createdAt: $createdAt)';
}
