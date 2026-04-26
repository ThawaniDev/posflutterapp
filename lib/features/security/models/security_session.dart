class SecuritySession {
  const SecuritySession({
    required this.id,
    required this.storeId,
    required this.userId,
    this.deviceId,
    this.ipAddress,
    this.userAgent,
    required this.status,
    this.startedAt,
    this.endedAt,
    this.lastActivityAt,
    this.metadata,
  });

  factory SecuritySession.fromJson(Map<String, dynamic> json) {
    return SecuritySession(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String,
      deviceId: json['device_id'] as String?,
      ipAddress: json['ip_address'] as String?,
      userAgent: json['user_agent'] as String?,
      status: json['status'] as String? ?? 'active',
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      endedAt: json['ended_at'] != null ? DateTime.parse(json['ended_at'] as String) : null,
      lastActivityAt: json['last_activity_at'] != null ? DateTime.parse(json['last_activity_at'] as String) : null,
      metadata: json['metadata'] != null && json['metadata'] is Map ? Map<String, dynamic>.from(json['metadata'] as Map) : null,
    );
  }
  final String id;
  final String storeId;
  final String userId;
  final String? deviceId;
  final String? ipAddress;
  final String? userAgent;
  final String status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime? lastActivityAt;
  final Map<String, dynamic>? metadata;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'user_id': userId,
      'device_id': deviceId,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'status': status,
      'started_at': startedAt?.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'metadata': metadata,
    };
  }

  bool get isActive => status == 'active' || status == 'open';

  SecuritySession copyWith({
    String? id,
    String? storeId,
    String? userId,
    String? deviceId,
    String? ipAddress,
    String? userAgent,
    String? status,
    DateTime? startedAt,
    DateTime? endedAt,
    DateTime? lastActivityAt,
    Map<String, dynamic>? metadata,
  }) {
    return SecuritySession(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SecuritySession && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SecuritySession(id: $id, userId: $userId, status: $status, startedAt: $startedAt)';
}
