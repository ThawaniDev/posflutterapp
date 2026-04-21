import 'package:wameedpos/features/customers/enums/gift_registry_event_type.dart';

class GiftRegistry {

  const GiftRegistry({
    required this.id,
    required this.storeId,
    required this.customerId,
    required this.name,
    required this.eventType,
    this.eventDate,
    required this.shareCode,
    this.isActive,
    this.createdAt,
  });

  factory GiftRegistry.fromJson(Map<String, dynamic> json) {
    return GiftRegistry(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String,
      name: json['name'] as String,
      eventType: GiftRegistryEventType.fromValue(json['event_type'] as String),
      eventDate: json['event_date'] != null ? DateTime.parse(json['event_date'] as String) : null,
      shareCode: json['share_code'] as String,
      isActive: json['is_active'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String customerId;
  final String name;
  final GiftRegistryEventType eventType;
  final DateTime? eventDate;
  final String shareCode;
  final bool? isActive;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'name': name,
      'event_type': eventType.value,
      'event_date': eventDate?.toIso8601String(),
      'share_code': shareCode,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  GiftRegistry copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? name,
    GiftRegistryEventType? eventType,
    DateTime? eventDate,
    String? shareCode,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return GiftRegistry(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      name: name ?? this.name,
      eventType: eventType ?? this.eventType,
      eventDate: eventDate ?? this.eventDate,
      shareCode: shareCode ?? this.shareCode,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GiftRegistry && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GiftRegistry(id: $id, storeId: $storeId, customerId: $customerId, name: $name, eventType: $eventType, eventDate: $eventDate, ...)';
}
