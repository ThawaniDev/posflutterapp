import 'package:thawani_pos/features/hardware/enums/connection_type.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';

class HardwareConfiguration {
  final String id;
  final String storeId;
  final String terminalId;
  final HardwareDeviceType deviceType;
  final ConnectionType connectionType;
  final String? deviceName;
  final Map<String, dynamic> configJson;
  final bool? isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const HardwareConfiguration({
    required this.id,
    required this.storeId,
    required this.terminalId,
    required this.deviceType,
    required this.connectionType,
    this.deviceName,
    required this.configJson,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory HardwareConfiguration.fromJson(Map<String, dynamic> json) {
    return HardwareConfiguration(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      deviceType: HardwareDeviceType.fromValue(json['device_type'] as String),
      connectionType: ConnectionType.fromValue(json['connection_type'] as String),
      deviceName: json['device_name'] as String?,
      configJson: Map<String, dynamic>.from(json['config_json'] as Map),
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'device_type': deviceType.value,
      'connection_type': connectionType.value,
      'device_name': deviceName,
      'config_json': configJson,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  HardwareConfiguration copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    HardwareDeviceType? deviceType,
    ConnectionType? connectionType,
    String? deviceName,
    Map<String, dynamic>? configJson,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HardwareConfiguration(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      deviceType: deviceType ?? this.deviceType,
      connectionType: connectionType ?? this.connectionType,
      deviceName: deviceName ?? this.deviceName,
      configJson: configJson ?? this.configJson,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HardwareConfiguration && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'HardwareConfiguration(id: $id, storeId: $storeId, terminalId: $terminalId, deviceType: $deviceType, connectionType: $connectionType, deviceName: $deviceName, ...)';
}
