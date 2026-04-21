import 'package:wameedpos/features/zatca/enums/zatca_certificate_status.dart';
import 'package:wameedpos/features/zatca/enums/zatca_certificate_type.dart';

class ZatcaCertificate {

  const ZatcaCertificate({
    required this.id,
    required this.storeId,
    required this.certificateType,
    required this.certificatePem,
    required this.ccsid,
    required this.issuedAt,
    required this.expiresAt,
    this.status,
    this.createdAt,
  });

  factory ZatcaCertificate.fromJson(Map<String, dynamic> json) {
    return ZatcaCertificate(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      certificateType: ZatcaCertificateType.fromValue(json['certificate_type'] as String),
      certificatePem: json['certificate_pem'] as String,
      ccsid: json['ccsid'] as String,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      status: ZatcaCertificateStatus.tryFromValue(json['status'] as String?),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final ZatcaCertificateType certificateType;
  final String certificatePem;
  final String ccsid;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final ZatcaCertificateStatus? status;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'certificate_type': certificateType.value,
      'certificate_pem': certificatePem,
      'ccsid': ccsid,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
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
    DateTime? issuedAt,
    DateTime? expiresAt,
    ZatcaCertificateStatus? status,
    DateTime? createdAt,
  }) {
    return ZatcaCertificate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      certificateType: certificateType ?? this.certificateType,
      certificatePem: certificatePem ?? this.certificatePem,
      ccsid: ccsid ?? this.ccsid,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
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
