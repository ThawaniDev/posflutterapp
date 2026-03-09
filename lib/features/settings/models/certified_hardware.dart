import 'package:thawani_pos/features/hardware/enums/driver_protocol.dart';
import 'package:thawani_pos/features/hardware/enums/hardware_device_type.dart';

class CertifiedHardware {
  final String id;
  final HardwareDeviceType deviceType;
  final String brand;
  final String model;
  final DriverProtocol driverProtocol;
  final Map<String, dynamic>? connectionTypes;
  final String? firmwareVersionMin;
  final Map<String, dynamic>? paperWidths;
  final String? setupInstructions;
  final String? setupInstructionsAr;
  final bool? isCertified;
  final bool? isActive;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const CertifiedHardware({
    required this.id,
    required this.deviceType,
    required this.brand,
    required this.model,
    required this.driverProtocol,
    this.connectionTypes,
    this.firmwareVersionMin,
    this.paperWidths,
    this.setupInstructions,
    this.setupInstructionsAr,
    this.isCertified,
    this.isActive,
    this.notes,
    this.createdAt,
    this.updatedAt,
  });

  factory CertifiedHardware.fromJson(Map<String, dynamic> json) {
    return CertifiedHardware(
      id: json['id'] as String,
      deviceType: HardwareDeviceType.fromValue(json['device_type'] as String),
      brand: json['brand'] as String,
      model: json['model'] as String,
      driverProtocol: DriverProtocol.fromValue(json['driver_protocol'] as String),
      connectionTypes: json['connection_types'] != null ? Map<String, dynamic>.from(json['connection_types'] as Map) : null,
      firmwareVersionMin: json['firmware_version_min'] as String?,
      paperWidths: json['paper_widths'] != null ? Map<String, dynamic>.from(json['paper_widths'] as Map) : null,
      setupInstructions: json['setup_instructions'] as String?,
      setupInstructionsAr: json['setup_instructions_ar'] as String?,
      isCertified: json['is_certified'] as bool?,
      isActive: json['is_active'] as bool?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'device_type': deviceType.value,
      'brand': brand,
      'model': model,
      'driver_protocol': driverProtocol.value,
      'connection_types': connectionTypes,
      'firmware_version_min': firmwareVersionMin,
      'paper_widths': paperWidths,
      'setup_instructions': setupInstructions,
      'setup_instructions_ar': setupInstructionsAr,
      'is_certified': isCertified,
      'is_active': isActive,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  CertifiedHardware copyWith({
    String? id,
    HardwareDeviceType? deviceType,
    String? brand,
    String? model,
    DriverProtocol? driverProtocol,
    Map<String, dynamic>? connectionTypes,
    String? firmwareVersionMin,
    Map<String, dynamic>? paperWidths,
    String? setupInstructions,
    String? setupInstructionsAr,
    bool? isCertified,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CertifiedHardware(
      id: id ?? this.id,
      deviceType: deviceType ?? this.deviceType,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      driverProtocol: driverProtocol ?? this.driverProtocol,
      connectionTypes: connectionTypes ?? this.connectionTypes,
      firmwareVersionMin: firmwareVersionMin ?? this.firmwareVersionMin,
      paperWidths: paperWidths ?? this.paperWidths,
      setupInstructions: setupInstructions ?? this.setupInstructions,
      setupInstructionsAr: setupInstructionsAr ?? this.setupInstructionsAr,
      isCertified: isCertified ?? this.isCertified,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CertifiedHardware && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CertifiedHardware(id: $id, deviceType: $deviceType, brand: $brand, model: $model, driverProtocol: $driverProtocol, connectionTypes: $connectionTypes, ...)';
}
