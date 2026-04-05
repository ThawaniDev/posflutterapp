import 'package:thawani_pos/features/catalog/enums/product_unit.dart';

class Product {
  final String id;
  final String organizationId;
  final String? categoryId;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String? sku;
  final String? barcode;
  final double sellPrice;
  final double? costPrice;
  final ProductUnit? unit;
  final double? taxRate;
  final bool? isWeighable;
  final double? tareWeight;
  final bool? isActive;
  final bool? isCombo;
  final bool? ageRestricted;
  final double? offerPrice;
  final DateTime? offerStart;
  final DateTime? offerEnd;
  final int? minOrderQty;
  final int? maxOrderQty;
  final String? imageUrl;
  final int? syncVersion;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  const Product({
    required this.id,
    required this.organizationId,
    this.categoryId,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.sku,
    this.barcode,
    required this.sellPrice,
    this.costPrice,
    this.unit,
    this.taxRate,
    this.isWeighable,
    this.tareWeight,
    this.isActive,
    this.isCombo,
    this.ageRestricted,
    this.offerPrice,
    this.offerStart,
    this.offerEnd,
    this.minOrderQty,
    this.maxOrderQty,
    this.imageUrl,
    this.syncVersion,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      categoryId: json['category_id'] as String?,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      sellPrice: double.tryParse(json['sell_price'].toString()) ?? 0.0,
      costPrice: (json['cost_price'] != null ? double.tryParse(json['cost_price'].toString()) : null),
      unit: ProductUnit.tryFromValue(json['unit'] as String?),
      taxRate: (json['tax_rate'] != null ? double.tryParse(json['tax_rate'].toString()) : null),
      isWeighable: json['is_weighable'] as bool?,
      tareWeight: (json['tare_weight'] != null ? double.tryParse(json['tare_weight'].toString()) : null),
      isActive: json['is_active'] as bool?,
      isCombo: json['is_combo'] as bool?,
      ageRestricted: json['age_restricted'] as bool?,
      offerPrice: (json['offer_price'] != null ? double.tryParse(json['offer_price'].toString()) : null),
      offerStart: json['offer_start'] != null ? DateTime.parse(json['offer_start'] as String) : null,
      offerEnd: json['offer_end'] != null ? DateTime.parse(json['offer_end'] as String) : null,
      minOrderQty: (json['min_order_qty'] as num?)?.toInt(),
      maxOrderQty: (json['max_order_qty'] as num?)?.toInt(),
      imageUrl: json['image_url'] as String?,
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      deletedAt: json['deleted_at'] != null ? DateTime.parse(json['deleted_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'category_id': categoryId,
      'name': name,
      'name_ar': nameAr,
      'description': description,
      'description_ar': descriptionAr,
      'sku': sku,
      'barcode': barcode,
      'sell_price': sellPrice,
      'cost_price': costPrice,
      'unit': unit?.value,
      'tax_rate': taxRate,
      'is_weighable': isWeighable,
      'tare_weight': tareWeight,
      'is_active': isActive,
      'is_combo': isCombo,
      'age_restricted': ageRestricted,
      'offer_price': offerPrice,
      'offer_start': offerStart?.toIso8601String(),
      'offer_end': offerEnd?.toIso8601String(),
      'min_order_qty': minOrderQty,
      'max_order_qty': maxOrderQty,
      'image_url': imageUrl,
      'sync_version': syncVersion,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? organizationId,
    String? categoryId,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? sku,
    String? barcode,
    double? sellPrice,
    double? costPrice,
    ProductUnit? unit,
    double? taxRate,
    bool? isWeighable,
    double? tareWeight,
    bool? isActive,
    bool? isCombo,
    bool? ageRestricted,
    double? offerPrice,
    DateTime? offerStart,
    DateTime? offerEnd,
    int? minOrderQty,
    int? maxOrderQty,
    String? imageUrl,
    int? syncVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Product(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      sellPrice: sellPrice ?? this.sellPrice,
      costPrice: costPrice ?? this.costPrice,
      unit: unit ?? this.unit,
      taxRate: taxRate ?? this.taxRate,
      isWeighable: isWeighable ?? this.isWeighable,
      tareWeight: tareWeight ?? this.tareWeight,
      isActive: isActive ?? this.isActive,
      isCombo: isCombo ?? this.isCombo,
      ageRestricted: ageRestricted ?? this.ageRestricted,
      offerPrice: offerPrice ?? this.offerPrice,
      offerStart: offerStart ?? this.offerStart,
      offerEnd: offerEnd ?? this.offerEnd,
      minOrderQty: minOrderQty ?? this.minOrderQty,
      maxOrderQty: maxOrderQty ?? this.maxOrderQty,
      imageUrl: imageUrl ?? this.imageUrl,
      syncVersion: syncVersion ?? this.syncVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is Product && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'Product(id: $id, organizationId: $organizationId, categoryId: $categoryId, name: $name, nameAr: $nameAr, description: $description, ...)';
}
