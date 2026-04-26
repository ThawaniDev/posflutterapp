import 'package:wameedpos/features/zatca/enums/zatca_certificate_status.dart';
import 'package:wameedpos/features/zatca/enums/zatca_certificate_type.dart';

class ZatcaCertificate {
  const ZatcaCertificate({
    required this.id,
    required this.certificateType,
    required this.ccsid,
    required this.issuedAt,
    required this.expiresAt,
    this.storeId,
    this.certificatePem,
    this.pcsid,
    this.daysUntilExpiry,
    this.status,
    this.createdAt,
  });

  factory ZatcaCertificate.fromJson(Map<String, dynamic> json) {
    // Backend exposes two shapes:
    //   1. Full record from /zatca/devices etc. -> certificate_type, store_id, certificate_pem
    //   2. Slim record nested in /zatca/compliance-summary -> type, no store_id/pem, with pcsid/days_until_expiry
    final typeRaw = (json['certificate_type'] ?? json['type']) as String?;
    return ZatcaCertificate(
      id: json['id'] as String,
      storeId: json['store_id'] as String?,
      certificateType: typeRaw != null ? ZatcaCertificateType.fromValue(typeRaw) : ZatcaCertificateType.compliance,
      certificatePem: json['certificate_pem'] as String?,
      ccsid: (json['ccsid'] ?? '') as String,
      pcsid: json['pcsid'] as String?,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      daysUntilExpiry: (json['days_until_expiry'] as num?)?.toDouble(),
      status: ZatcaCertificateStatus.tryFromValue(json['status'] as String?),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String? storeId;
  final ZatcaCertificateType certificateType;
  final String? certificatePem;
  final String ccsid;
  final String? pcsid;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final double? daysUntilExpiry;
  final ZatcaCertificateStatus? status;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'certificate_type': certificateType.value,
      'certificate_pem': certificatePem,
      'ccsid': ccsid,
      'pcsid': pcsid,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'days_until_expiry': daysUntilExpiry,
      'status': status?.value,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ZatcaCertificate copyWith({
    String? id,
    String? storeId,
    ZatcaCertificateType? certificateType,
    String? certificatePem,
    String? ccsid,
    String? pcsid,
    DateTime? issuedAt,
    DateTime? expiresAt,
    double? daysUntilExpiry,
    ZatcaCertificateStatus? status,
    DateTime? createdAt,
  }) {
    return ZatcaCertificate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      certificateType: certificateType ?? this.certificateType,
      certificatePem: certificatePem ?? this.certificatePem,
      ccsid: ccsid ?? this.ccsid,
      pcsid: pcsid ?? this.pcsid,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ZatcaCertificate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ZatcaCertificate(id: $id, storeId: $storeId, certificateType: $certificateType, certificatePem: $certificatePem, ccsid: $ccsid, issuedAt: $issuedAt, ...)';
}
