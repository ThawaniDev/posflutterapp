class SecurityPolicy {
  final String id;
  final String storeId;
  final int? pinMinLength;
  final int? pinMaxLength;
  final int? autoLockSeconds;
  final int? maxFailedAttempts;
  final int? lockoutDurationMinutes;
  final bool? require2faOwner;
  final int? sessionMaxHours;
  final bool? requirePinOverrideVoid;
  final bool? requirePinOverrideReturn;
  final bool? requirePinOverrideDiscount;
  final double? discountOverrideThreshold;
  final bool? biometricEnabled;
  final int? pinExpiryDays;
  final bool? requireUniquePins;
  final int? maxDevices;
  final int? auditRetentionDays;
  final bool? forceLogoutOnRoleChange;
  final int? passwordExpiryDays;
  final bool? requireStrongPassword;
  final bool? ipRestrictionEnabled;
  final List<String>? allowedIpRanges;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SecurityPolicy({
    required this.id,
    required this.storeId,
    this.pinMinLength,
    this.pinMaxLength,
    this.autoLockSeconds,
    this.maxFailedAttempts,
    this.lockoutDurationMinutes,
    this.require2faOwner,
    this.sessionMaxHours,
    this.requirePinOverrideVoid,
    this.requirePinOverrideReturn,
    this.requirePinOverrideDiscount,
    this.discountOverrideThreshold,
    this.biometricEnabled,
    this.pinExpiryDays,
    this.requireUniquePins,
    this.maxDevices,
    this.auditRetentionDays,
    this.forceLogoutOnRoleChange,
    this.passwordExpiryDays,
    this.requireStrongPassword,
    this.ipRestrictionEnabled,
    this.allowedIpRanges,
    this.createdAt,
    this.updatedAt,
  });

  factory SecurityPolicy.fromJson(Map<String, dynamic> json) {
    return SecurityPolicy(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      pinMinLength: (json['pin_min_length'] as num?)?.toInt(),
      pinMaxLength: (json['pin_max_length'] as num?)?.toInt(),
      autoLockSeconds: (json['auto_lock_seconds'] as num?)?.toInt(),
      maxFailedAttempts: (json['max_failed_attempts'] as num?)?.toInt(),
      lockoutDurationMinutes: (json['lockout_duration_minutes'] as num?)?.toInt(),
      require2faOwner: json['require_2fa_owner'] as bool?,
      sessionMaxHours: (json['session_max_hours'] as num?)?.toInt(),
      requirePinOverrideVoid: json['require_pin_override_void'] as bool?,
      requirePinOverrideReturn: json['require_pin_override_return'] as bool?,
      requirePinOverrideDiscount: json['require_pin_override_discount'] as bool?,
      discountOverrideThreshold: json['discount_override_threshold'] != null
          ? double.tryParse(json['discount_override_threshold'].toString())
          : null,
      biometricEnabled: json['biometric_enabled'] as bool?,
      pinExpiryDays: (json['pin_expiry_days'] as num?)?.toInt(),
      requireUniquePins: json['require_unique_pins'] as bool?,
      maxDevices: (json['max_devices'] as num?)?.toInt(),
      auditRetentionDays: (json['audit_retention_days'] as num?)?.toInt(),
      forceLogoutOnRoleChange: json['force_logout_on_role_change'] as bool?,
      passwordExpiryDays: (json['password_expiry_days'] as num?)?.toInt(),
      requireStrongPassword: json['require_strong_password'] as bool?,
      ipRestrictionEnabled: json['ip_restriction_enabled'] as bool?,
      allowedIpRanges: (json['allowed_ip_ranges'] as List?)?.map((e) => e as String).toList(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'pin_min_length': pinMinLength,
      'pin_max_length': pinMaxLength,
      'auto_lock_seconds': autoLockSeconds,
      'max_failed_attempts': maxFailedAttempts,
      'lockout_duration_minutes': lockoutDurationMinutes,
      'require_2fa_owner': require2faOwner,
      'session_max_hours': sessionMaxHours,
      'require_pin_override_void': requirePinOverrideVoid,
      'require_pin_override_return': requirePinOverrideReturn,
      'require_pin_override_discount': requirePinOverrideDiscount,
      'discount_override_threshold': discountOverrideThreshold,
      'biometric_enabled': biometricEnabled,
      'pin_expiry_days': pinExpiryDays,
      'require_unique_pins': requireUniquePins,
      'max_devices': maxDevices,
      'audit_retention_days': auditRetentionDays,
      'force_logout_on_role_change': forceLogoutOnRoleChange,
      'password_expiry_days': passwordExpiryDays,
      'require_strong_password': requireStrongPassword,
      'ip_restriction_enabled': ipRestrictionEnabled,
      'allowed_ip_ranges': allowedIpRanges,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SecurityPolicy copyWith({
    String? id,
    String? storeId,
    int? pinMinLength,
    int? pinMaxLength,
    int? autoLockSeconds,
    int? maxFailedAttempts,
    int? lockoutDurationMinutes,
    bool? require2faOwner,
    int? sessionMaxHours,
    bool? requirePinOverrideVoid,
    bool? requirePinOverrideReturn,
    bool? requirePinOverrideDiscount,
    double? discountOverrideThreshold,
    bool? biometricEnabled,
    int? pinExpiryDays,
    bool? requireUniquePins,
    int? maxDevices,
    int? auditRetentionDays,
    bool? forceLogoutOnRoleChange,
    int? passwordExpiryDays,
    bool? requireStrongPassword,
    bool? ipRestrictionEnabled,
    List<String>? allowedIpRanges,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SecurityPolicy(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      pinMinLength: pinMinLength ?? this.pinMinLength,
      pinMaxLength: pinMaxLength ?? this.pinMaxLength,
      autoLockSeconds: autoLockSeconds ?? this.autoLockSeconds,
      maxFailedAttempts: maxFailedAttempts ?? this.maxFailedAttempts,
      lockoutDurationMinutes: lockoutDurationMinutes ?? this.lockoutDurationMinutes,
      require2faOwner: require2faOwner ?? this.require2faOwner,
      sessionMaxHours: sessionMaxHours ?? this.sessionMaxHours,
      requirePinOverrideVoid: requirePinOverrideVoid ?? this.requirePinOverrideVoid,
      requirePinOverrideReturn: requirePinOverrideReturn ?? this.requirePinOverrideReturn,
      requirePinOverrideDiscount: requirePinOverrideDiscount ?? this.requirePinOverrideDiscount,
      discountOverrideThreshold: discountOverrideThreshold ?? this.discountOverrideThreshold,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      pinExpiryDays: pinExpiryDays ?? this.pinExpiryDays,
      requireUniquePins: requireUniquePins ?? this.requireUniquePins,
      maxDevices: maxDevices ?? this.maxDevices,
      auditRetentionDays: auditRetentionDays ?? this.auditRetentionDays,
      forceLogoutOnRoleChange: forceLogoutOnRoleChange ?? this.forceLogoutOnRoleChange,
      passwordExpiryDays: passwordExpiryDays ?? this.passwordExpiryDays,
      requireStrongPassword: requireStrongPassword ?? this.requireStrongPassword,
      ipRestrictionEnabled: ipRestrictionEnabled ?? this.ipRestrictionEnabled,
      allowedIpRanges: allowedIpRanges ?? this.allowedIpRanges,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SecurityPolicy && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SecurityPolicy(id: $id, storeId: $storeId, pinMinLength: $pinMinLength, pinMaxLength: $pinMaxLength, autoLockSeconds: $autoLockSeconds, maxFailedAttempts: $maxFailedAttempts, ...)';
}
