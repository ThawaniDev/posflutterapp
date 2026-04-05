import 'package:thawani_pos/features/industry_bakery/enums/custom_cake_order_status.dart';

class CustomCakeOrder {
  final String id;
  final String storeId;
  final String? customerId;
  final String? orderId;
  final String description;
  final String? size;
  final String? flavor;
  final String? decorationNotes;
  final DateTime deliveryDate;
  final String? deliveryTime;
  final double price;
  final double? depositPaid;
  final CustomCakeOrderStatus? status;
  final String? referenceImageUrl;
  final DateTime? createdAt;

  const CustomCakeOrder({
    required this.id,
    required this.storeId,
    this.customerId,
    this.orderId,
    required this.description,
    this.size,
    this.flavor,
    this.decorationNotes,
    required this.deliveryDate,
    this.deliveryTime,
    required this.price,
    this.depositPaid,
    this.status,
    this.referenceImageUrl,
    this.createdAt,
  });

  factory CustomCakeOrder.fromJson(Map<String, dynamic> json) {
    return CustomCakeOrder(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      customerId: json['customer_id'] as String?,
      orderId: json['order_id'] as String?,
      description: json['description'] as String,
      size: json['size'] as String?,
      flavor: json['flavor'] as String?,
      decorationNotes: json['decoration_notes'] as String?,
      deliveryDate: DateTime.parse(json['delivery_date'] as String),
      deliveryTime: json['delivery_time'] as String?,
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      depositPaid: (json['deposit_paid'] != null ? double.tryParse(json['deposit_paid'].toString()) : null),
      status: CustomCakeOrderStatus.tryFromValue(json['status'] as String?),
      referenceImageUrl: json['reference_image_url'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'customer_id': customerId,
      'order_id': orderId,
      'description': description,
      'size': size,
      'flavor': flavor,
      'decoration_notes': decorationNotes,
      'delivery_date': deliveryDate.toIso8601String(),
      'delivery_time': deliveryTime,
      'price': price,
      'deposit_paid': depositPaid,
      'status': status?.value,
      'reference_image_url': referenceImageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CustomCakeOrder copyWith({
    String? id,
    String? storeId,
    String? customerId,
    String? orderId,
    String? description,
    String? size,
    String? flavor,
    String? decorationNotes,
    DateTime? deliveryDate,
    String? deliveryTime,
    double? price,
    double? depositPaid,
    CustomCakeOrderStatus? status,
    String? referenceImageUrl,
    DateTime? createdAt,
  }) {
    return CustomCakeOrder(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      customerId: customerId ?? this.customerId,
      orderId: orderId ?? this.orderId,
      description: description ?? this.description,
      size: size ?? this.size,
      flavor: flavor ?? this.flavor,
      decorationNotes: decorationNotes ?? this.decorationNotes,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      price: price ?? this.price,
      depositPaid: depositPaid ?? this.depositPaid,
      status: status ?? this.status,
      referenceImageUrl: referenceImageUrl ?? this.referenceImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCakeOrder && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomCakeOrder(id: $id, storeId: $storeId, customerId: $customerId, orderId: $orderId, description: $description, size: $size, ...)';
}
