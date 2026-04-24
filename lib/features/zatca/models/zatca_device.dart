import 'package:wameedpos/features/zatca/enums/zatca_device_status.dart';

/// Mirror of the backend `zatca_devices` row.
///
/// Phase 2 EGS device with provisioning code, hardware serial,
/// running ICV, current PIH, and tamper flag. The terminal stores
/// only one of these locally to gate submissions.
class ZatcaDevice {
  const ZatcaDevice({
    required this.id,
    required this.storeId,
    required this.deviceUuid,
    required this.status,
    required this.environment,
    required this.isTampered,
    required this.currentIcv,
    this.hardwareSerial,
    this.activationCode,
    this.activatedAt,
    this.tamperReason,
    this.currentPih,
    this.certificateId,
  });

  factory ZatcaDevice.fromJson(Map<String, dynamic> json) {
    return ZatcaDevice(
      id: json['id'] as String,
      storeId: json['store_id'] as String? ?? '',
      deviceUuid: json['device_uuid'] as String,
      status: ZatcaDeviceStatus.fromValue((json['status'] as String?) ?? 'pending'),
      environment: (json['environment'] as String?) ?? 'sandbox',
      isTampered: (json['is_tampered'] as bool?) ?? false,
      currentIcv: int.tryParse((json['current_icv'] ?? 0).toString()) ?? 0,
      hardwareSerial: json['hardware_serial'] as String?,
      activationCode: json['activation_code'] as String?,
      activatedAt: json['activated_at'] != null ? DateTime.tryParse(json['activated_at'] as String) : null,
      tamperReason: json['tamper_reason'] as String?,
      currentPih: json['current_pih'] as String?,
      certificateId: json['certificate_id'] as String?,
    );
  }

  final String id;
  final String storeId;
  final String deviceUuid;
  final ZatcaDeviceStatus status;
  final String environment;
  final bool isTampered;
  final int currentIcv;
  final String? hardwareSerial;
  final String? activationCode;
  final DateTime? activatedAt;
  final String? tamperReason;
  final String? currentPih;
  final String? certificateId;

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'device_uuid': deviceUuid,
    'status': status.value,
    'environment': environment,
    'is_tampered': isTampered,
    'current_icv': currentIcv,
    'hardware_serial': hardwareSerial,
    'activation_code': activationCode,
    'activated_at': activatedAt?.toIso8601String(),
    'tamper_reason': tamperReason,
    'current_pih': currentPih,
    'certificate_id': certificateId,
  };

  ZatcaDevice copyWith({
    ZatcaDeviceStatus? status,
    bool? isTampered,
    int? currentIcv,
    String? hardwareSerial,
    DateTime? activatedAt,
    String? tamperReason,
    String? currentPih,
  }) {
    return ZatcaDevice(
      id: id,
      storeId: storeId,
      deviceUuid: deviceUuid,
      status: status ?? this.status,
      environment: environment,
      isTampered: isTampered ?? this.isTampered,
      currentIcv: currentIcv ?? this.currentIcv,
      hardwareSerial: hardwareSerial ?? this.hardwareSerial,
      activationCode: activationCode,
      activatedAt: activatedAt ?? this.activatedAt,
      tamperReason: tamperReason ?? this.tamperReason,
      currentPih: currentPih ?? this.currentPih,
      certificateId: certificateId,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (other is ZatcaDevice && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
