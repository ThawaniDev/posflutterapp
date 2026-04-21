class AdminActivityLog {

  const AdminActivityLog({
    required this.id,
    this.adminUserId,
    required this.action,
    this.entityType,
    this.entityId,
    this.details,
    required this.ipAddress,
    this.userAgent,
    this.createdAt,
  });

  factory AdminActivityLog.fromJson(Map<String, dynamic> json) {
    return AdminActivityLog(
      id: json['id'] as String,
      adminUserId: json['admin_user_id'] as String?,
      action: json['action'] as String,
      entityType: json['entity_type'] as String?,
      entityId: json['entity_id'] as String?,
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String? adminUserId;
  final String action;
  final String? entityType;
  final String? entityId;
  final Map<String, dynamic>? details;
  final String ipAddress;
  final String? userAgent;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_user_id': adminUserId,
      'action': action,
      'entity_type': entityType,
      'entity_id': entityId,
      'details': details,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  AdminActivityLog copyWith({
    String? id,
    String? adminUserId,
    String? action,
    String? entityType,
    String? entityId,
    Map<String, dynamic>? details,
    String? ipAddress,
    String? userAgent,
    DateTime? createdAt,
  }) {
    return AdminActivityLog(
      id: id ?? this.id,
      adminUserId: adminUserId ?? this.adminUserId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminActivityLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminActivityLog(id: $id, adminUserId: $adminUserId, action: $action, entityType: $entityType, entityId: $entityId, details: $details, ...)';
}
