import 'package:wameedpos/features/security/enums/session_status.dart';

class CashSession {

  const CashSession({
    required this.id,
    required this.storeId,
    this.terminalId,
    required this.openedBy,
    this.closedBy,
    required this.openingFloat,
    this.expectedCash,
    this.actualCash,
    this.variance,
    this.status,
    this.openedAt,
    this.closedAt,
    this.closeNotes,
  });

  factory CashSession.fromJson(Map<String, dynamic> json) {
    return CashSession(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      terminalId: json['terminal_id'] as String?,
      openedBy: json['opened_by'] as String,
      closedBy: json['closed_by'] as String?,
      openingFloat: double.tryParse(json['opening_float'].toString()) ?? 0.0,
      expectedCash: (json['expected_cash'] != null ? double.tryParse(json['expected_cash'].toString()) : null),
      actualCash: (json['actual_cash'] != null ? double.tryParse(json['actual_cash'].toString()) : null),
      variance: (json['variance'] != null ? double.tryParse(json['variance'].toString()) : null),
      status: SessionStatus.tryFromValue(json['status'] as String?),
      openedAt: json['opened_at'] != null ? DateTime.parse(json['opened_at'] as String) : null,
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      closeNotes: json['close_notes'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String? terminalId;
  final String openedBy;
  final String? closedBy;
  final double openingFloat;
  final double? expectedCash;
  final double? actualCash;
  final double? variance;
  final SessionStatus? status;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final String? closeNotes;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'opened_by': openedBy,
      'closed_by': closedBy,
      'opening_float': openingFloat,
      'expected_cash': expectedCash,
      'actual_cash': actualCash,
      'variance': variance,
      'status': status?.value,
      'opened_at': openedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'close_notes': closeNotes,
    };
  }

  CashSession copyWith({
    String? id,
    String? storeId,
    String? terminalId,
    String? openedBy,
    String? closedBy,
    double? openingFloat,
    double? expectedCash,
    double? actualCash,
    double? variance,
    SessionStatus? status,
    DateTime? openedAt,
    DateTime? closedAt,
    String? closeNotes,
  }) {
    return CashSession(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      terminalId: terminalId ?? this.terminalId,
      openedBy: openedBy ?? this.openedBy,
      closedBy: closedBy ?? this.closedBy,
      openingFloat: openingFloat ?? this.openingFloat,
      expectedCash: expectedCash ?? this.expectedCash,
      actualCash: actualCash ?? this.actualCash,
      variance: variance ?? this.variance,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      closeNotes: closeNotes ?? this.closeNotes,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CashSession && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CashSession(id: $id, storeId: $storeId, terminalId: $terminalId, openedBy: $openedBy, closedBy: $closedBy, openingFloat: $openingFloat, ...)';
}
