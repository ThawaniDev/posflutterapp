import 'package:wameedpos/features/branches/enums/provider_registration_status.dart';

class ProviderRegistration {
  final String id;
  final String organizationName;
  final String? organizationNameAr;
  final String ownerName;
  final String ownerEmail;
  final String ownerPhone;
  final String? crNumber;
  final String? vatNumber;
  final String? businessTypeId;
  final ProviderRegistrationStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? rejectionReason;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProviderRegistration({
    required this.id,
    required this.organizationName,
    this.organizationNameAr,
    required this.ownerName,
    required this.ownerEmail,
    required this.ownerPhone,
    this.crNumber,
    this.vatNumber,
    this.businessTypeId,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.rejectionReason,
    this.createdAt,
    this.updatedAt,
  });

  factory ProviderRegistration.fromJson(Map<String, dynamic> json) {
    return ProviderRegistration(
      id: json['id'] as String,
      organizationName: json['organization_name'] as String,
      organizationNameAr: json['organization_name_ar'] as String?,
      ownerName: json['owner_name'] as String,
      ownerEmail: json['owner_email'] as String,
      ownerPhone: json['owner_phone'] as String,
      crNumber: json['cr_number'] as String?,
      vatNumber: json['vat_number'] as String?,
      businessTypeId: json['business_type_id'] as String?,
      status: ProviderRegistrationStatus.fromValue(json['status'] as String),
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: json['reviewed_at'] != null ? DateTime.parse(json['reviewed_at'] as String) : null,
      rejectionReason: json['rejection_reason'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_name': organizationName,
      'organization_name_ar': organizationNameAr,
      'owner_name': ownerName,
      'owner_email': ownerEmail,
      'owner_phone': ownerPhone,
      'cr_number': crNumber,
      'vat_number': vatNumber,
      'business_type_id': businessTypeId,
      'status': status.value,
      'reviewed_by': reviewedBy,
      'reviewed_at': reviewedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProviderRegistration copyWith({
    String? id,
    String? organizationName,
    String? organizationNameAr,
    String? ownerName,
    String? ownerEmail,
    String? ownerPhone,
    String? crNumber,
    String? vatNumber,
    String? businessTypeId,
    ProviderRegistrationStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? rejectionReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProviderRegistration(
      id: id ?? this.id,
      organizationName: organizationName ?? this.organizationName,
      organizationNameAr: organizationNameAr ?? this.organizationNameAr,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      crNumber: crNumber ?? this.crNumber,
      vatNumber: vatNumber ?? this.vatNumber,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProviderRegistration && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ProviderRegistration(id: $id, organizationName: $organizationName, organizationNameAr: $organizationNameAr, ownerName: $ownerName, ownerEmail: $ownerEmail, ownerPhone: $ownerPhone, ...)';
}
