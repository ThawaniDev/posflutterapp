import 'package:wameedpos/features/staff/enums/staff_document_type.dart';

class StaffDocument {
  const StaffDocument({
    required this.id,
    required this.staffUserId,
    required this.documentType,
    required this.fileUrl,
    this.expiryDate,
    this.uploadedAt,
    this.daysUntilExpiry,
    this.isExpired = false,
    this.expiringSoon = false,
  });

  factory StaffDocument.fromJson(Map<String, dynamic> json) {
    return StaffDocument(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      documentType: StaffDocumentType.fromValue(json['document_type'] as String),
      fileUrl: json['file_url'] as String,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null,
      uploadedAt: json['uploaded_at'] != null ? DateTime.parse(json['uploaded_at'] as String) : null,
      daysUntilExpiry: (json['days_until_expiry'] as num?)?.toInt(),
      isExpired: json['is_expired'] as bool? ?? false,
      expiringSoon: json['expiring_soon'] as bool? ?? false,
    );
  }
  final String id;
  final String staffUserId;
  final StaffDocumentType documentType;
  final String fileUrl;
  final DateTime? expiryDate;
  final DateTime? uploadedAt;
  final int? daysUntilExpiry;
  final bool isExpired;
  final bool expiringSoon;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'document_type': documentType.value,
      'file_url': fileUrl,
      'expiry_date': expiryDate?.toIso8601String(),
      'uploaded_at': uploadedAt?.toIso8601String(),
      'days_until_expiry': daysUntilExpiry,
      'is_expired': isExpired,
      'expiring_soon': expiringSoon,
    };
  }

  StaffDocument copyWith({
    String? id,
    String? staffUserId,
    StaffDocumentType? documentType,
    String? fileUrl,
    DateTime? expiryDate,
    DateTime? uploadedAt,
    int? daysUntilExpiry,
    bool? isExpired,
    bool? expiringSoon,
  }) {
    return StaffDocument(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      documentType: documentType ?? this.documentType,
      fileUrl: fileUrl ?? this.fileUrl,
      expiryDate: expiryDate ?? this.expiryDate,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      daysUntilExpiry: daysUntilExpiry ?? this.daysUntilExpiry,
      isExpired: isExpired ?? this.isExpired,
      expiringSoon: expiringSoon ?? this.expiringSoon,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is StaffDocument && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'StaffDocument(id: $id, staffUserId: $staffUserId, documentType: $documentType, fileUrl: $fileUrl, expiryDate: $expiryDate, uploadedAt: $uploadedAt)';
}
