import 'package:wameedpos/features/orders/enums/cancellation_reason_category.dart';

class CancellationReason {

  const CancellationReason({
    required this.id,
    required this.storeSubscriptionId,
    required this.reasonCategory,
    this.reasonText,
    this.cancelledAt,
  });

  factory CancellationReason.fromJson(Map<String, dynamic> json) {
    return CancellationReason(
      id: json['id'] as String,
      storeSubscriptionId: json['store_subscription_id'] as String,
      reasonCategory: CancellationReasonCategory.fromValue(json['reason_category'] as String),
      reasonText: json['reason_text'] as String?,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
    );
  }
  final String id;
  final String storeSubscriptionId;
  final CancellationReasonCategory reasonCategory;
  final String? reasonText;
  final DateTime? cancelledAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_subscription_id': storeSubscriptionId,
      'reason_category': reasonCategory.value,
      'reason_text': reasonText,
      'cancelled_at': cancelledAt?.toIso8601String(),
    };
  }

  CancellationReason copyWith({
    String? id,
    String? storeSubscriptionId,
    CancellationReasonCategory? reasonCategory,
    String? reasonText,
    DateTime? cancelledAt,
  }) {
    return CancellationReason(
      id: id ?? this.id,
      storeSubscriptionId: storeSubscriptionId ?? this.storeSubscriptionId,
      reasonCategory: reasonCategory ?? this.reasonCategory,
      reasonText: reasonText ?? this.reasonText,
      cancelledAt: cancelledAt ?? this.cancelledAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CancellationReason && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CancellationReason(id: $id, storeSubscriptionId: $storeSubscriptionId, reasonCategory: $reasonCategory, reasonText: $reasonText, cancelledAt: $cancelledAt)';
}
