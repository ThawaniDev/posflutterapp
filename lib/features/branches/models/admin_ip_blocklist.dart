class AdminIpBlocklist {

  const AdminIpBlocklist({
    required this.id,
    required this.ipAddress,
    this.reason,
    required this.blockedBy,
    this.createdAt,
  });

  factory AdminIpBlocklist.fromJson(Map<String, dynamic> json) {
    return AdminIpBlocklist(
      id: json['id'] as String,
      ipAddress: json['ip_address'] as String,
      reason: json['reason'] as String?,
      blockedBy: json['blocked_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String ipAddress;
  final String? reason;
  final String blockedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ip_address': ipAddress,
      'reason': reason,
      'blocked_by': blockedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AdminIpBlocklist copyWith({
    String? id,
    String? ipAddress,
    String? reason,
    String? blockedBy,
    DateTime? createdAt,
  }) {
    return AdminIpBlocklist(
      id: id ?? this.id,
      ipAddress: ipAddress ?? this.ipAddress,
      reason: reason ?? this.reason,
      blockedBy: blockedBy ?? this.blockedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminIpBlocklist && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminIpBlocklist(id: $id, ipAddress: $ipAddress, reason: $reason, blockedBy: $blockedBy, createdAt: $createdAt)';
}
