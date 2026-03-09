import 'package:thawani_pos/features/payments/enums/expense_category.dart';

class Expense {
  final String id;
  final String storeId;
  final String? cashSessionId;
  final double amount;
  final ExpenseCategory category;
  final String? description;
  final String? receiptImageUrl;
  final String recordedBy;
  final DateTime expenseDate;
  final DateTime? createdAt;

  const Expense({
    required this.id,
    required this.storeId,
    this.cashSessionId,
    required this.amount,
    required this.category,
    this.description,
    this.receiptImageUrl,
    required this.recordedBy,
    required this.expenseDate,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      cashSessionId: json['cash_session_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      category: ExpenseCategory.fromValue(json['category'] as String),
      description: json['description'] as String?,
      receiptImageUrl: json['receipt_image_url'] as String?,
      recordedBy: json['recorded_by'] as String,
      expenseDate: DateTime.parse(json['expense_date'] as String),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'cash_session_id': cashSessionId,
      'amount': amount,
      'category': category.value,
      'description': description,
      'receipt_image_url': receiptImageUrl,
      'recorded_by': recordedBy,
      'expense_date': expenseDate.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  Expense copyWith({
    String? id,
    String? storeId,
    String? cashSessionId,
    double? amount,
    ExpenseCategory? category,
    String? description,
    String? receiptImageUrl,
    String? recordedBy,
    DateTime? expenseDate,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      cashSessionId: cashSessionId ?? this.cashSessionId,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      description: description ?? this.description,
      receiptImageUrl: receiptImageUrl ?? this.receiptImageUrl,
      recordedBy: recordedBy ?? this.recordedBy,
      expenseDate: expenseDate ?? this.expenseDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Expense && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Expense(id: $id, storeId: $storeId, cashSessionId: $cashSessionId, amount: $amount, category: $category, description: $description, ...)';
}
