import 'package:wameedpos/core/enums/activity_entity_type.dart';

class StaffActivityLog {
  final String id;
  final String staffUserId;
  final String storeId;
  final String action;
  final ActivityEntityType? entityType;
  final String? entityId;
  final Map<String, dynamic>? details;
  final String? ipAddress;
  final DateTime? createdAt;

  const StaffActivityLog({
    required this.id,
    required this.staffUserId,
    required this.storeId,
    required this.action,
    this.entityType,
    this.entityId,
    this.details,
    this.ipAddress,
    this.createdAt,
  });

  factory StaffActivityLog.fromJson(Map<String, dynamic> json) {
    return StaffActivityLog(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      storeId: json['store_id'] as String,
      action: json['action'] as String,
      entityType: ActivityEntityType.tryFromValue(json['entity_type'] as String?),
      entityId: json['entity_id'] as String?,
      details: json['details'] != null ? Map<String, dynamic>.from(json['details'] as Map) : null,
      ipAddress: json['ip_address'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'store_id': storeId,
      'action': action,
      'entity_type': entityType?.value,
      'entity_id': entityId,
      'details': details,
      'ip_address': ipAddress,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StaffActivityLog copyWith({
    String? id,
    String? staffUserId,
    String? storeId,
    String? action,
    ActivityEntityType? entityType,
    String? entityId,
    Map<String, dynamic>? details,
    String? ipAddress,
    DateTime? createdAt,
  }) {
    return StaffActivityLog(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      storeId: storeId ?? this.storeId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      ipAddress: ipAddress ?? this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StaffActivityLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StaffActivityLog(id: $id, staffUserId: $staffUserId, storeId: $storeId, action: $action, entityType: $entityType, entityId: $entityId, ...)';
}
