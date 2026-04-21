import 'package:wameedpos/features/industry_florist/enums/flower_freshness_status.dart';

class FlowerFreshnessLog {

  const FlowerFreshnessLog({
    required this.id,
    required this.productId,
    required this.storeId,
    required this.receivedDate,
    required this.expectedVaseLifeDays,
    this.markdownDate,
    this.disposeDate,
    required this.quantity,
    this.status,
  });

  factory FlowerFreshnessLog.fromJson(Map<String, dynamic> json) {
    return FlowerFreshnessLog(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      storeId: json['store_id'] as String,
      receivedDate: DateTime.parse(json['received_date'] as String),
      expectedVaseLifeDays: (json['expected_vase_life_days'] as num).toInt(),
      markdownDate: json['markdown_date'] != null ? DateTime.parse(json['markdown_date'] as String) : null,
      disposeDate: json['dispose_date'] != null ? DateTime.parse(json['dispose_date'] as String) : null,
      quantity: (json['quantity'] as num).toInt(),
      status: FlowerFreshnessStatus.tryFromValue(json['status'] as String?),
    );
  }
  final String id;
  final String productId;
  final String storeId;
  final DateTime receivedDate;
  final int expectedVaseLifeDays;
  final DateTime? markdownDate;
  final DateTime? disposeDate;
  final int quantity;
  final FlowerFreshnessStatus? status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'store_id': storeId,
      'received_date': receivedDate.toIso8601String(),
      'expected_vase_life_days': expectedVaseLifeDays,
      'markdown_date': markdownDate?.toIso8601String(),
      'dispose_date': disposeDate?.toIso8601String(),
      'quantity': quantity,
      'status': status?.value,
    };
  }

  FlowerFreshnessLog copyWith({
    String? id,
    String? productId,
    String? storeId,
    DateTime? receivedDate,
    int? expectedVaseLifeDays,
    DateTime? markdownDate,
    DateTime? disposeDate,
    int? quantity,
    FlowerFreshnessStatus? status,
  }) {
    return FlowerFreshnessLog(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      receivedDate: receivedDate ?? this.receivedDate,
      expectedVaseLifeDays: expectedVaseLifeDays ?? this.expectedVaseLifeDays,
      markdownDate: markdownDate ?? this.markdownDate,
      disposeDate: disposeDate ?? this.disposeDate,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FlowerFreshnessLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FlowerFreshnessLog(id: $id, productId: $productId, storeId: $storeId, receivedDate: $receivedDate, expectedVaseLifeDays: $expectedVaseLifeDays, markdownDate: $markdownDate, ...)';
}
