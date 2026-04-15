import 'package:wameedpos/features/hardware/enums/implementation_fee_status.dart';
import 'package:wameedpos/features/hardware/enums/implementation_fee_type.dart';

class ImplementationFee {
  final String id;
  final String storeId;
  final ImplementationFeeType feeType;
  final double amount;
  final ImplementationFeeStatus status;
  final String? notes;
  final DateTime? createdAt;

  const ImplementationFee({
    required this.id,
    required this.storeId,
    required this.feeType,
    required this.amount,
    required this.status,
    this.notes,
    this.createdAt,
  });

  factory ImplementationFee.fromJson(Map<String, dynamic> json) {
    return ImplementationFee(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      feeType: ImplementationFeeType.fromValue(json['fee_type'] as String),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: ImplementationFeeStatus.fromValue(json['status'] as String),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'fee_type': feeType.value,
      'amount': amount,
      'status': status.value,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ImplementationFee copyWith({
    String? id,
    String? storeId,
    ImplementationFeeType? feeType,
    double? amount,
    ImplementationFeeStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return ImplementationFee(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      feeType: feeType ?? this.feeType,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is ImplementationFee && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'ImplementationFee(id: $id, storeId: $storeId, feeType: $feeType, amount: $amount, status: $status, notes: $notes, ...)';
}
