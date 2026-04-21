import 'package:wameedpos/features/industry_restaurant/enums/restaurant_table_status.dart';

class RestaurantTable {

  const RestaurantTable({
    required this.id,
    required this.storeId,
    required this.tableNumber,
    this.displayName,
    required this.seats,
    this.zone,
    this.positionX,
    this.positionY,
    this.status,
    this.currentOrderId,
    this.isActive,
    this.createdAt,
  });

  factory RestaurantTable.fromJson(Map<String, dynamic> json) {
    return RestaurantTable(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      tableNumber: json['table_number'] as String,
      displayName: json['display_name'] as String?,
      seats: (json['seats'] as num).toInt(),
      zone: json['zone'] as String?,
      positionX: (json['position_x'] as num?)?.toInt(),
      positionY: (json['position_y'] as num?)?.toInt(),
      status: RestaurantTableStatus.tryFromValue(json['status'] as String?),
      currentOrderId: json['current_order_id'] as String?,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String tableNumber;
  final String? displayName;
  final int seats;
  final String? zone;
  final int? positionX;
  final int? positionY;
  final RestaurantTableStatus? status;
  final String? currentOrderId;
  final bool? isActive;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'table_number': tableNumber,
      'display_name': displayName,
      'seats': seats,
      'zone': zone,
      'position_x': positionX,
      'position_y': positionY,
      'status': status?.value,
      'current_order_id': currentOrderId,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  RestaurantTable copyWith({
    String? id,
    String? storeId,
    String? tableNumber,
    String? displayName,
    int? seats,
    String? zone,
    int? positionX,
    int? positionY,
    RestaurantTableStatus? status,
    String? currentOrderId,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RestaurantTable(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      tableNumber: tableNumber ?? this.tableNumber,
      displayName: displayName ?? this.displayName,
      seats: seats ?? this.seats,
      zone: zone ?? this.zone,
      positionX: positionX ?? this.positionX,
      positionY: positionY ?? this.positionY,
      status: status ?? this.status,
      currentOrderId: currentOrderId ?? this.currentOrderId,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is RestaurantTable && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'RestaurantTable(id: $id, storeId: $storeId, tableNumber: $tableNumber, displayName: $displayName, seats: $seats, zone: $zone, ...)';
}
