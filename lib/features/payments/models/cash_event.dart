import 'package:wameedpos/features/payments/enums/cash_event_type.dart';

class CashEvent {

  const CashEvent({
    required this.id,
    required this.cashSessionId,
    required this.type,
    required this.amount,
    required this.reason,
    this.notes,
    required this.performedBy,
    this.createdAt,
  });

  factory CashEvent.fromJson(Map<String, dynamic> json) {
    return CashEvent(
      id: json['id'] as String,
      cashSessionId: json['cash_session_id'] as String,
      type: CashEventType.fromValue(json['type'] as String),
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      reason: json['reason'] as String,
      notes: json['notes'] as String?,
      performedBy: json['performed_by'] as String,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String cashSessionId;
  final CashEventType type;
  final double amount;
  final String reason;
  final String? notes;
  final String performedBy;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cash_session_id': cashSessionId,
      'type': type.value,
      'amount': amount,
      'reason': reason,
      'notes': notes,
      'performed_by': performedBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CashEvent copyWith({
    String? id,
    String? cashSessionId,
    CashEventType? type,
    double? amount,
    String? reason,
    String? notes,
    String? performedBy,
    DateTime? createdAt,
  }) {
    return CashEvent(
      id: id ?? this.id,
      cashSessionId: cashSessionId ?? this.cashSessionId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
      performedBy: performedBy ?? this.performedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashEvent && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CashEvent(id: $id, cashSessionId: $cashSessionId, type: $type, amount: $amount, reason: $reason, notes: $notes, ...)';
}
