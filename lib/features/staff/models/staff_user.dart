import 'package:thawani_pos/features/staff/enums/employment_type.dart';
import 'package:thawani_pos/features/staff/enums/salary_type.dart';
import 'package:thawani_pos/features/staff/enums/staff_status.dart';

class StaffUser {
  final String id;
  final String storeId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final String? nationalId;
  final String? pinHash;
  final String? nfcBadgeUid;
  final bool? biometricEnabled;
  final EmploymentType employmentType;
  final SalaryType salaryType;
  final double? hourlyRate;
  final DateTime hireDate;
  final DateTime? terminationDate;
  final StaffStatus? status;
  final String? languagePreference;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const StaffUser({
    required this.id,
    required this.storeId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.photoUrl,
    this.nationalId,
    this.pinHash,
    this.nfcBadgeUid,
    this.biometricEnabled,
    required this.employmentType,
    required this.salaryType,
    this.hourlyRate,
    required this.hireDate,
    this.terminationDate,
    this.status,
    this.languagePreference,
    this.createdAt,
    this.updatedAt,
  });

  factory StaffUser.fromJson(Map<String, dynamic> json) {
    return StaffUser(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      photoUrl: json['photo_url'] as String?,
      nationalId: json['national_id'] as String?,
      pinHash: json['pin_hash'] as String?,
      nfcBadgeUid: json['nfc_badge_uid'] as String?,
      biometricEnabled: json['biometric_enabled'] as bool?,
      employmentType: EmploymentType.fromValue(json['employment_type'] as String),
      salaryType: SalaryType.fromValue(json['salary_type'] as String),
      hourlyRate: (json['hourly_rate'] as num?)?.toDouble(),
      hireDate: DateTime.parse(json['hire_date'] as String),
      terminationDate: json['termination_date'] != null ? DateTime.parse(json['termination_date'] as String) : null,
      status: StaffStatus.tryFromValue(json['status'] as String?),
      languagePreference: json['language_preference'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'photo_url': photoUrl,
      'national_id': nationalId,
      'pin_hash': pinHash,
      'nfc_badge_uid': nfcBadgeUid,
      'biometric_enabled': biometricEnabled,
      'employment_type': employmentType.value,
      'salary_type': salaryType.value,
      'hourly_rate': hourlyRate,
      'hire_date': hireDate.toIso8601String(),
      'termination_date': terminationDate?.toIso8601String(),
      'status': status?.value,
      'language_preference': languagePreference,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  StaffUser copyWith({
    String? id,
    String? storeId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? photoUrl,
    String? nationalId,
    String? pinHash,
    String? nfcBadgeUid,
    bool? biometricEnabled,
    EmploymentType? employmentType,
    SalaryType? salaryType,
    double? hourlyRate,
    DateTime? hireDate,
    DateTime? terminationDate,
    StaffStatus? status,
    String? languagePreference,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StaffUser(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      nationalId: nationalId ?? this.nationalId,
      pinHash: pinHash ?? this.pinHash,
      nfcBadgeUid: nfcBadgeUid ?? this.nfcBadgeUid,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      employmentType: employmentType ?? this.employmentType,
      salaryType: salaryType ?? this.salaryType,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      hireDate: hireDate ?? this.hireDate,
      terminationDate: terminationDate ?? this.terminationDate,
      status: status ?? this.status,
      languagePreference: languagePreference ?? this.languagePreference,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StaffUser && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StaffUser(id: $id, storeId: $storeId, firstName: $firstName, lastName: $lastName, email: $email, phone: $phone, ...)';
}
