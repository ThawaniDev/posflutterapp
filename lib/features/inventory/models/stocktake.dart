import 'package:wameedpos/features/inventory/enums/stocktake_status.dart';
import 'package:wameedpos/features/inventory/enums/stocktake_type.dart';
import 'package:wameedpos/features/inventory/models/stocktake_item.dart';

class Stocktake {
  const Stocktake({
    required this.id,
    required this.storeId,
    this.referenceNumber,
    this.type,
    this.status,
    this.categoryId,
    this.categoryName,
    this.notes,
    this.startedBy,
    this.completedBy,
    this.startedAt,
    this.completedAt,
    this.createdAt,
    this.updatedAt,
    this.items,
  });

  factory Stocktake.fromJson(Map<String, dynamic> json) {
    return Stocktake(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      referenceNumber: json['reference_number'] as String?,
      type: json['type'] != null ? StocktakeType.tryFromValue(json['type'] as String) : null,
      status: json['status'] != null ? StocktakeStatus.tryFromValue(json['status'] as String) : null,
      categoryId: json['category_id'] as String?,
      categoryName: (json['category'] as Map<String, dynamic>?)?['name'] as String?,
      notes: json['notes'] as String?,
      startedBy: json['started_by'] as String?,
      completedBy: json['completed_by'] as String?,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      items: json['items'] != null
          ? (json['items'] as List).map((i) => StocktakeItem.fromJson(i as Map<String, dynamic>)).toList()
          : null,
    );
  }

  final String id;
  final String storeId;
  final String? referenceNumber;
  final StocktakeType? type;
  final StocktakeStatus? status;
  final String? categoryId;
  final String? categoryName;
  final String? notes;
  final String? startedBy;
  final String? completedBy;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<StocktakeItem>? items;

  int get itemCount => items?.length ?? 0;
  int get countedItems => items?.where((i) => i.countedQty != null).length ?? 0;
  double get totalVarianceCostImpact => items?.fold(0.0, (sum, i) => sum! + (i.costImpact ?? 0.0)) ?? 0.0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'store_id': storeId,
    'reference_number': referenceNumber,
    'type': type?.value,
    'status': status?.value,
    'category_id': categoryId,
    'notes': notes,
    'started_by': startedBy,
    'completed_by': completedBy,
    'started_at': startedAt?.toIso8601String(),
    'completed_at': completedAt?.toIso8601String(),
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
    if (items != null) 'items': items!.map((i) => i.toJson()).toList(),
  };

  Stocktake copyWith({
    String? id,
    String? storeId,
    String? referenceNumber,
    StocktakeType? type,
    StocktakeStatus? status,
    String? categoryId,
    String? categoryName,
    String? notes,
    String? startedBy,
    String? completedBy,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<StocktakeItem>? items,
  }) {
    return Stocktake(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      notes: notes ?? this.notes,
      startedBy: startedBy ?? this.startedBy,
      completedBy: completedBy ?? this.completedBy,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      items: items ?? this.items,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Stocktake && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Stocktake(id: $id, storeId: $storeId, referenceNumber: $referenceNumber, status: $status)';
}
