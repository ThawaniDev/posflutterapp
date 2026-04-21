import 'package:wameedpos/features/branches/enums/register_platform.dart';

class Register {

  const Register({
    required this.id,
    required this.storeId,
    required this.name,
    required this.deviceId,
    this.appVersion,
    this.platform,
    this.lastSyncAt,
    this.isOnline,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Register.fromJson(Map<String, dynamic> json) {
    return Register(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      name: json['name'] as String,
      deviceId: json['device_id'] as String,
      appVersion: json['app_version'] as String?,
      platform: RegisterPlatform.tryFromValue(json['platform'] as String?),
      lastSyncAt: json['last_sync_at'] != null ? DateTime.parse(json['last_sync_at'] as String) : null,
      isOnline: json['is_online'] as bool?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String name;
  final String deviceId;
  final String? appVersion;
  final RegisterPlatform? platform;
  final DateTime? lastSyncAt;
  final bool? isOnline;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'device_id': deviceId,
      'app_version': appVersion,
      'platform': platform?.value,
      'last_sync_at': lastSyncAt?.toIso8601String(),
      'is_online': isOnline,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Register copyWith({
    String? id,
    String? storeId,
    String? name,
    String? deviceId,
    String? appVersion,
    RegisterPlatform? platform,
    DateTime? lastSyncAt,
    bool? isOnline,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Register(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      deviceId: deviceId ?? this.deviceId,
      appVersion: appVersion ?? this.appVersion,
      platform: platform ?? this.platform,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      isOnline: isOnline ?? this.isOnline,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Register && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Register(id: $id, storeId: $storeId, name: $name, deviceId: $deviceId, appVersion: $appVersion, platform: $platform, ...)';
}
