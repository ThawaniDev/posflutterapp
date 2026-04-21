class AdminSession {

  const AdminSession({
    required this.id,
    required this.adminUserId,
    required this.sessionTokenHash,
    required this.ipAddress,
    this.userAgent,
    this.twoFaVerified,
    this.createdAt,
    this.lastActivityAt,
    required this.expiresAt,
    this.revokedAt,
  });

  factory AdminSession.fromJson(Map<String, dynamic> json) {
    return AdminSession(
      id: json['id'] as String,
      adminUserId: json['admin_user_id'] as String,
      sessionTokenHash: json['session_token_hash'] as String,
      ipAddress: json['ip_address'] as String,
      userAgent: json['user_agent'] as String?,
      twoFaVerified: json['two_fa_verified'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      lastActivityAt: json['last_activity_at'] != null ? DateTime.parse(json['last_activity_at'] as String) : null,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      revokedAt: json['revoked_at'] != null ? DateTime.parse(json['revoked_at'] as String) : null,
    );
  }
  final String id;
  final String adminUserId;
  final String sessionTokenHash;
  final String ipAddress;
  final String? userAgent;
  final bool? twoFaVerified;
  final DateTime? createdAt;
  final DateTime? lastActivityAt;
  final DateTime expiresAt;
  final DateTime? revokedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_user_id': adminUserId,
      'session_token_hash': sessionTokenHash,
      'ip_address': ipAddress,
      'user_agent': userAgent,
      'two_fa_verified': twoFaVerified,
      'created_at': createdAt?.toIso8601String(),
      'last_activity_at': lastActivityAt?.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'revoked_at': revokedAt?.toIso8601String(),
    };
  }

  AdminSession copyWith({
    String? id,
    String? adminUserId,
    String? sessionTokenHash,
    String? ipAddress,
    String? userAgent,
    bool? twoFaVerified,
    DateTime? createdAt,
    DateTime? lastActivityAt,
    DateTime? expiresAt,
    DateTime? revokedAt,
  }) {
    return AdminSession(
      id: id ?? this.id,
      adminUserId: adminUserId ?? this.adminUserId,
      sessionTokenHash: sessionTokenHash ?? this.sessionTokenHash,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      twoFaVerified: twoFaVerified ?? this.twoFaVerified,
      createdAt: createdAt ?? this.createdAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      expiresAt: expiresAt ?? this.expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminSession && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminSession(id: $id, adminUserId: $adminUserId, sessionTokenHash: $sessionTokenHash, ipAddress: $ipAddress, userAgent: $userAgent, twoFaVerified: $twoFaVerified, ...)';
}
