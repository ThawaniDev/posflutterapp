import 'package:thawani_pos/features/settings/enums/tax_exemption_type.dart';

class TaxExemption {
  final String id;
  final String transactionId;
  final String? customerId;
  final TaxExemptionType exemptionType;
  final String? customerTaxId;
  final String? certificateNumber;
  final String? notes;
  final DateTime? createdAt;

  const TaxExemption({
    required this.id,
    required this.transactionId,
    this.customerId,
    required this.exemptionType,
    this.customerTaxId,
    this.certificateNumber,
    this.notes,
    this.createdAt,
  });

  factory TaxExemption.fromJson(Map<String, dynamic> json) {
    return TaxExemption(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      customerId: json['customer_id'] as String?,
      exemptionType: TaxExemptionType.fromValue(json['exemption_type'] as String),
      customerTaxId: json['customer_tax_id'] as String?,
      certificateNumber: json['certificate_number'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'customer_id': customerId,
      'exemption_type': exemptionType.value,
      'customer_tax_id': customerTaxId,
      'certificate_number': certificateNumber,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TaxExemption copyWith({
    String? id,
    String? transactionId,
    String? customerId,
    TaxExemptionType? exemptionType,
    String? customerTaxId,
    String? certificateNumber,
    String? notes,
    DateTime? createdAt,
  }) {
    return TaxExemption(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      customerId: customerId ?? this.customerId,
      exemptionType: exemptionType ?? this.exemptionType,
      customerTaxId: customerTaxId ?? this.customerTaxId,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxExemption && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TaxExemption(id: $id, transactionId: $transactionId, customerId: $customerId, exemptionType: $exemptionType, customerTaxId: $customerTaxId, certificateNumber: $certificateNumber, ...)';
}
