class DeliveryPlatformWebhookTemplate {
  final String id;
  final String deliveryPlatformId;
  final String pathTemplate;

  const DeliveryPlatformWebhookTemplate({
    required this.id,
    required this.deliveryPlatformId,
    required this.pathTemplate,
  });

  factory DeliveryPlatformWebhookTemplate.fromJson(Map<String, dynamic> json) {
    return DeliveryPlatformWebhookTemplate(
      id: json['id'] as String,
      deliveryPlatformId: json['delivery_platform_id'] as String,
      pathTemplate: json['path_template'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'delivery_platform_id': deliveryPlatformId,
      'path_template': pathTemplate,
    };
  }

  DeliveryPlatformWebhookTemplate copyWith({
    String? id,
    String? deliveryPlatformId,
    String? pathTemplate,
  }) {
    return DeliveryPlatformWebhookTemplate(
      id: id ?? this.id,
      deliveryPlatformId: deliveryPlatformId ?? this.deliveryPlatformId,
      pathTemplate: pathTemplate ?? this.pathTemplate,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeliveryPlatformWebhookTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DeliveryPlatformWebhookTemplate(id: $id, deliveryPlatformId: $deliveryPlatformId, pathTemplate: $pathTemplate)';
}
