class CommissionEarning {
  final String id;
  final String staffUserId;
  final String orderId;
  final String commissionRuleId;
  final double orderTotal;
  final double commissionAmount;
  final DateTime? createdAt;

  const CommissionEarning({
    required this.id,
    required this.staffUserId,
    required this.orderId,
    required this.commissionRuleId,
    required this.orderTotal,
    required this.commissionAmount,
    this.createdAt,
  });

  factory CommissionEarning.fromJson(Map<String, dynamic> json) {
    return CommissionEarning(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      orderId: json['order_id'] as String,
      commissionRuleId: json['commission_rule_id'] as String,
      orderTotal: (json['order_total'] as num).toDouble(),
      commissionAmount: (json['commission_amount'] as num).toDouble(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'order_id': orderId,
      'commission_rule_id': commissionRuleId,
      'order_total': orderTotal,
      'commission_amount': commissionAmount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CommissionEarning copyWith({
    String? id,
    String? staffUserId,
    String? orderId,
    String? commissionRuleId,
    double? orderTotal,
    double? commissionAmount,
    DateTime? createdAt,
  }) {
    return CommissionEarning(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      orderId: orderId ?? this.orderId,
      commissionRuleId: commissionRuleId ?? this.commissionRuleId,
      orderTotal: orderTotal ?? this.orderTotal,
      commissionAmount: commissionAmount ?? this.commissionAmount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CommissionEarning && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CommissionEarning(id: $id, staffUserId: $staffUserId, orderId: $orderId, commissionRuleId: $commissionRuleId, orderTotal: $orderTotal, commissionAmount: $commissionAmount, ...)';
}
