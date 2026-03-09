class AdminTrustedDevice {
  final String id;
  final String adminUserId;
  final String deviceFingerprint;
  final String? deviceName;
  final String? userAgent;
  final DateTime? trustedAt;
  final DateTime? lastUsedAt;

  const AdminTrustedDevice({
    required this.id,
    required this.adminUserId,
    required this.deviceFingerprint,
    this.deviceName,
    this.userAgent,
    this.trustedAt,
    this.lastUsedAt,
  });

  factory AdminTrustedDevice.fromJson(Map<String, dynamic> json) {
    return AdminTrustedDevice(
      id: json['id'] as String,
      adminUserId: json['admin_user_id'] as String,
      deviceFingerprint: json['device_fingerprint'] as String,
      deviceName: json['device_name'] as String?,
      userAgent: json['user_agent'] as String?,
      trustedAt: json['trusted_at'] != null ? DateTime.parse(json['trusted_at'] as String) : null,
      lastUsedAt: json['last_used_at'] != null ? DateTime.parse(json['last_used_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'admin_user_id': adminUserId,
      'device_fingerprint': deviceFingerprint,
      'device_name': deviceName,
      'user_agent': userAgent,
      'trusted_at': trustedAt?.toIso8601String(),
      'last_used_at': lastUsedAt?.toIso8601String(),
    };
  }

  AdminTrustedDevice copyWith({
    String? id,
    String? adminUserId,
    String? deviceFingerprint,
    String? deviceName,
    String? userAgent,
    DateTime? trustedAt,
    DateTime? lastUsedAt,
  }) {
    return AdminTrustedDevice(
      id: id ?? this.id,
      adminUserId: adminUserId ?? this.adminUserId,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
      deviceName: deviceName ?? this.deviceName,
      userAgent: userAgent ?? this.userAgent,
      trustedAt: trustedAt ?? this.trustedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdminTrustedDevice && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AdminTrustedDevice(id: $id, adminUserId: $adminUserId, deviceFingerprint: $deviceFingerprint, deviceName: $deviceName, userAgent: $userAgent, trustedAt: $trustedAt, ...)';
}
