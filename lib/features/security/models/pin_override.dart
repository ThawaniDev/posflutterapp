class PinOverride {

  const PinOverride({
    required this.id,
    required this.storeId,
    required this.requestingUserId,
    required this.authorizingUserId,
    required this.permissionCode,
    this.actionContext,
    this.createdAt,
  });

  factory PinOverride.fromJson(Map<String, dynamic> json) {
    return PinOverride(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      requestingUserId: json['requesting_user_id'] as String,
      authorizingUserId: json['authorizing_user_id'] as String,
      permissionCode: json['permission_code'] as String,
      actionContext: json['action_context'] != null ? Map<String, dynamic>.from(json['action_context'] as Map) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String requestingUserId;
  final String authorizingUserId;
  final String permissionCode;
  final Map<String, dynamic>? actionContext;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'requesting_user_id': requestingUserId,
      'authorizing_user_id': authorizingUserId,
      'permission_code': permissionCode,
      'action_context': actionContext,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  PinOverride copyWith({
    String? id,
    String? storeId,
    String? requestingUserId,
    String? authorizingUserId,
    String? permissionCode,
    Map<String, dynamic>? actionContext,
    DateTime? createdAt,
  }) {
    return PinOverride(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      requestingUserId: requestingUserId ?? this.requestingUserId,
      authorizingUserId: authorizingUserId ?? this.authorizingUserId,
      permissionCode: permissionCode ?? this.permissionCode,
      actionContext: actionContext ?? this.actionContext,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PinOverride && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PinOverride(id: $id, storeId: $storeId, requestingUserId: $requestingUserId, authorizingUserId: $authorizingUserId, permissionCode: $permissionCode, actionContext: $actionContext, ...)';
}
