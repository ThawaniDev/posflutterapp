import 'package:wameedpos/features/security/enums/session_status.dart';

class PosSession {
  const PosSession({
    required this.id,
    required this.storeId,
    required this.registerId,
    required this.cashierId,
    required this.status,
    required this.openingCash,
    this.closingCash,
    this.expectedCash,
    this.cashDifference,
    this.totalCashSales,
    this.totalCardSales,
    this.totalOtherSales,
    this.totalRefunds,
    this.totalVoids,
    this.transactionCount,
    this.openedAt,
    this.closedAt,
    this.zReportPrinted,
    this.createdAt,
    this.updatedAt,
    this.registerName,
  });

  factory PosSession.fromJson(Map<String, dynamic> json) {
    return PosSession(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      registerId: json['register_id'] as String,
      cashierId: json['cashier_id'] as String,
      status: SessionStatus.fromValue(json['status'] as String),
      openingCash: double.tryParse(json['opening_cash'].toString()) ?? 0.0,
      closingCash: (json['closing_cash'] != null ? double.tryParse(json['closing_cash'].toString()) : null),
      expectedCash: (json['expected_cash'] != null ? double.tryParse(json['expected_cash'].toString()) : null),
      cashDifference: (json['cash_difference'] != null ? double.tryParse(json['cash_difference'].toString()) : null),
      totalCashSales: (json['total_cash_sales'] != null ? double.tryParse(json['total_cash_sales'].toString()) : null),
      totalCardSales: (json['total_card_sales'] != null ? double.tryParse(json['total_card_sales'].toString()) : null),
      totalOtherSales: (json['total_other_sales'] != null ? double.tryParse(json['total_other_sales'].toString()) : null),
      totalRefunds: (json['total_refunds'] != null ? double.tryParse(json['total_refunds'].toString()) : null),
      totalVoids: (json['total_voids'] != null ? double.tryParse(json['total_voids'].toString()) : null),
      transactionCount: (json['transaction_count'] as num?)?.toInt(),
      openedAt: json['opened_at'] != null ? DateTime.parse(json['opened_at'] as String) : null,
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      zReportPrinted: json['z_report_printed'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      registerName: json['register_name'] as String?,
    );
  }
  final String id;
  final String storeId;
  final String registerId;
  final String cashierId;
  final SessionStatus status;
  final double openingCash;
  final double? closingCash;
  final double? expectedCash;
  final double? cashDifference;
  final double? totalCashSales;
  final double? totalCardSales;
  final double? totalOtherSales;
  final double? totalRefunds;
  final double? totalVoids;
  final int? transactionCount;
  final DateTime? openedAt;
  final DateTime? closedAt;
  final bool? zReportPrinted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? registerName;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'register_id': registerId,
      'cashier_id': cashierId,
      'status': status.value,
      'opening_cash': openingCash,
      'closing_cash': closingCash,
      'expected_cash': expectedCash,
      'cash_difference': cashDifference,
      'total_cash_sales': totalCashSales,
      'total_card_sales': totalCardSales,
      'total_other_sales': totalOtherSales,
      'total_refunds': totalRefunds,
      'total_voids': totalVoids,
      'transaction_count': transactionCount,
      'opened_at': openedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'z_report_printed': zReportPrinted,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  PosSession copyWith({
    String? id,
    String? storeId,
    String? registerId,
    String? cashierId,
    SessionStatus? status,
    double? openingCash,
    double? closingCash,
    double? expectedCash,
    double? cashDifference,
    double? totalCashSales,
    double? totalCardSales,
    double? totalOtherSales,
    double? totalRefunds,
    double? totalVoids,
    int? transactionCount,
    DateTime? openedAt,
    DateTime? closedAt,
    bool? zReportPrinted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PosSession(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      registerId: registerId ?? this.registerId,
      cashierId: cashierId ?? this.cashierId,
      status: status ?? this.status,
      openingCash: openingCash ?? this.openingCash,
      closingCash: closingCash ?? this.closingCash,
      expectedCash: expectedCash ?? this.expectedCash,
      cashDifference: cashDifference ?? this.cashDifference,
      totalCashSales: totalCashSales ?? this.totalCashSales,
      totalCardSales: totalCardSales ?? this.totalCardSales,
      totalOtherSales: totalOtherSales ?? this.totalOtherSales,
      totalRefunds: totalRefunds ?? this.totalRefunds,
      totalVoids: totalVoids ?? this.totalVoids,
      transactionCount: transactionCount ?? this.transactionCount,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      zReportPrinted: zReportPrinted ?? this.zReportPrinted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PosSession && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'PosSession(id: $id, storeId: $storeId, registerId: $registerId, cashierId: $cashierId, status: $status, openingCash: $openingCash, ...)';
}
