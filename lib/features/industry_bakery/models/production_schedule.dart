import 'package:thawani_pos/features/industry_bakery/enums/production_schedule_status.dart';

class ProductionSchedule {
  final String id;
  final String storeId;
  final String recipeId;
  final DateTime scheduleDate;
  final int plannedBatches;
  final int? actualBatches;
  final int plannedYield;
  final int? actualYield;
  final ProductionScheduleStatus? status;
  final String? notes;
  final DateTime? createdAt;

  const ProductionSchedule({
    required this.id,
    required this.storeId,
    required this.recipeId,
    required this.scheduleDate,
    required this.plannedBatches,
    this.actualBatches,
    required this.plannedYield,
    this.actualYield,
    this.status,
    this.notes,
    this.createdAt,
  });

  factory ProductionSchedule.fromJson(Map<String, dynamic> json) {
    return ProductionSchedule(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      recipeId: json['recipe_id'] as String,
      scheduleDate: DateTime.parse(json['schedule_date'] as String),
      plannedBatches: (json['planned_batches'] as num).toInt(),
      actualBatches: (json['actual_batches'] as num?)?.toInt(),
      plannedYield: (json['planned_yield'] as num).toInt(),
      actualYield: (json['actual_yield'] as num?)?.toInt(),
      status: ProductionScheduleStatus.tryFromValue(json['status'] as String?),
      notes: json['notes'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'recipe_id': recipeId,
      'schedule_date': scheduleDate.toIso8601String(),
      'planned_batches': plannedBatches,
      'actual_batches': actualBatches,
      'planned_yield': plannedYield,
      'actual_yield': actualYield,
      'status': status?.value,
      'notes': notes,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProductionSchedule copyWith({
    String? id,
    String? storeId,
    String? recipeId,
    DateTime? scheduleDate,
    int? plannedBatches,
    int? actualBatches,
    int? plannedYield,
    int? actualYield,
    ProductionScheduleStatus? status,
    String? notes,
    DateTime? createdAt,
  }) {
    return ProductionSchedule(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      recipeId: recipeId ?? this.recipeId,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      plannedBatches: plannedBatches ?? this.plannedBatches,
      actualBatches: actualBatches ?? this.actualBatches,
      plannedYield: plannedYield ?? this.plannedYield,
      actualYield: actualYield ?? this.actualYield,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductionSchedule && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductionSchedule(id: $id, storeId: $storeId, recipeId: $recipeId, scheduleDate: $scheduleDate, plannedBatches: $plannedBatches, actualBatches: $actualBatches, ...)';
}
