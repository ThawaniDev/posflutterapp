import 'package:wameedpos/features/hardware/enums/hardware_device_type.dart';

class HardwareEventLog {
  final String id;
  final String storeId;
  final String terminalId;
  final HardwareDeviceType deviceType;
  final String event;
  final String? details;
  final DateTime? createdAt;

  const HardwareEventLog({
    required this.id,
    required this.storeId,
    required this.terminalId,
    required this.deviceType,
    required this.event,
    this.details,
    this.createdAt,
  });

  factory HardwareEventLog.fromJson(Map<String, dynamic> json) {
    return HardwareEventLog(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String,
      deviceType: HardwareDeviceType.fromValue(json['device_type'] as String),
      event: json['event'] as String,
      details: json['details'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'device_type': deviceType.value,
      'event': event,
      'details': details,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  HardwareEventLog copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    HardwareDeviceType? deviceType,
    String? event,
    String? details,
    DateTime? createdAt,
  }) {
    return HardwareEventLog(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      deviceType: deviceType ?? this.deviceType,
      event: event ?? this.event,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is HardwareEventLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'HardwareEventLog(id: $id, storeId: $storeId, terminalId: $terminalId, deviceType: $deviceType, event: $event, details: $details, ...)';
}
