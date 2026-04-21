class DeviceRegistration {

  const DeviceRegistration({
    required this.id,
    required this.storeId,
    required this.deviceName,
    required this.hardwareId,
    this.osInfo,
    this.appVersion,
    this.lastActiveAt,
    this.isActive = true,
    this.remoteWipeRequested = false,
    this.registeredAt,
    this.ipAddress,
    this.screenResolution,
    this.lastKnownLocation,
    this.deviceType,
  });

  factory DeviceRegistration.fromJson(Map<String, dynamic> json) {
    return DeviceRegistration(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      deviceName: json['device_name'] as String,
      hardwareId: json['hardware_id'] as String,
      osInfo: json['os_info'] as String?,
      appVersion: json['app_version'] as String?,
      lastActiveAt: json['last_active_at'] != null ? DateTime.parse(json['last_active_at'] as String) : null,
      isActive: json['is_active'] as bool? ?? true,
      remoteWipeRequested: json['remote_wipe_requested'] as bool? ?? false,
      registeredAt: json['registered_at'] != null ? DateTime.parse(json['registered_at'] as String) : null,
      ipAddress: json['ip_address'] as String?,
      screenResolution: json['screen_resolution'] as String?,
      lastKnownLocation: json['last_known_location'] != null
          ? Map<String, dynamic>.from(json['last_known_location'] as Map)
          : null,
      deviceType: json['device_type'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String deviceName;
  final String hardwareId;
  final String? osInfo;
  final String? appVersion;
  final DateTime? lastActiveAt;
  final bool isActive;
  final bool remoteWipeRequested;
  final DateTime? registeredAt;
  final String? ipAddress;
  final String? screenResolution;
  final Map<String, dynamic>? lastKnownLocation;
  final String? deviceType;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'device_name': deviceName,
      'hardware_id': hardwareId,
      'os_info': osInfo,
      'app_version': appVersion,
      'last_active_at': lastActiveAt?.toIso8601String(),
      'is_active': isActive,
      'remote_wipe_requested': remoteWipeRequested,
      'registered_at': registeredAt?.toIso8601String(),
      'ip_address': ipAddress,
      'screen_resolution': screenResolution,
      'last_known_location': lastKnownLocation,
      'device_type': deviceType,
    };
  }

  DeviceRegistration copyWith({
    String? id,
    String? storeId,
    String? deviceName,
    String? hardwareId,
    String? osInfo,
    String? appVersion,
    DateTime? lastActiveAt,
    bool? isActive,
    bool? remoteWipeRequested,
    DateTime? registeredAt,
    String? ipAddress,
    String? screenResolution,
    Map<String, dynamic>? lastKnownLocation,
    String? deviceType,
  }) {
    return DeviceRegistration(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      deviceName: deviceName ?? this.deviceName,
      hardwareId: hardwareId ?? this.hardwareId,
      osInfo: osInfo ?? this.osInfo,
      appVersion: appVersion ?? this.appVersion,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isActive: isActive ?? this.isActive,
      remoteWipeRequested: remoteWipeRequested ?? this.remoteWipeRequested,
      registeredAt: registeredAt ?? this.registeredAt,
      ipAddress: ipAddress ?? this.ipAddress,
      screenResolution: screenResolution ?? this.screenResolution,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      deviceType: deviceType ?? this.deviceType,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeviceRegistration && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeviceRegistration(id: $id, deviceName: $deviceName, hardwareId: $hardwareId, isActive: $isActive)';
}
