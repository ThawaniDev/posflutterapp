import 'package:wameedpos/features/delivery_integration/enums/delivery_field_type.dart';

class DeliveryPlatformField {

  const DeliveryPlatformField({
    required this.id,
    required this.deliveryPlatformId,
    required this.fieldLabel,
    required this.fieldKey,
    required this.fieldType,
    this.isRequired,
    this.sortOrder,
  });

  factory DeliveryPlatformField.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatformField(
      id: json['id'] as String,
      deliveryPlatformId: json['delivery_platform_id'] as String,
      fieldLabel: json['field_label'] as String,
      fieldKey: json['field_key'] as String,
      fieldType: DeliveryFieldType.fromValue(json['field_type'] as String),
      isRequired: json['is_required'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
    );
  }
  final String id;
  final String deliveryPlatformId;
  final String fieldLabel;
  final String fieldKey;
  final DeliveryFieldType fieldType;
  final bool? isRequired;
  final int? sortOrder;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_platform_id': deliveryPlatformId,
      'field_label': fieldLabel,
      'field_key': fieldKey,
      'field_type': fieldType.value,
      'is_required': isRequired,
      'sort_order': sortOrder,
    };
  }

  DeliveryPlatformField copyWith({
    String? id,
    String? deliveryPlatformId,
    String? fieldLabel,
    String? fieldKey,
    DeliveryFieldType? fieldType,
    bool? isRequired,
    int? sortOrder,
  }) {
    return DeliveryPlatformField(
      id: id ?? this.id,
      deliveryPlatformId: deliveryPlatformId ?? this.deliveryPlatformId,
      fieldLabel: fieldLabel ?? this.fieldLabel,
      fieldKey: fieldKey ?? this.fieldKey,
      fieldType: fieldType ?? this.fieldType,
      isRequired: isRequired ?? this.isRequired,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DeliveryPlatformField && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'DeliveryPlatformField(id: $id, deliveryPlatformId: $deliveryPlatformId, fieldLabel: $fieldLabel, fieldKey: $fieldKey, fieldType: $fieldType, isRequired: $isRequired, ...)';
}
