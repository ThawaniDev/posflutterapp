import 'package:wameedpos/features/catalog/enums/product_unit.dart';
import 'package:wameedpos/features/predefined_catalog/models/predefined_category.dart';
import 'package:wameedpos/features/predefined_catalog/models/predefined_product_image.dart';

class PredefinedProduct {

  const PredefinedProduct({
    required this.id,
    required this.businessTypeId,
    this.predefinedCategoryId,
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
    this.isWeighable = false,
    this.tareWeight,
    this.isActive = true,
    this.ageRestricted = false,
    this.imageUrl,
    this.category,
    this.images = const [],
    this.businessType,
    this.createdAt,
    this.updatedAt,
  });

  factory PredefinedProduct.fromJson(Map<String, dynamic> json) {
    return PredefinedProduct(
      id: json['id'] as String,
      businessTypeId: json['business_type_id'] as String,
      predefinedCategoryId: json['predefined_category_id'] as String?,
      name: json['name'] as String,
      nameAr: json['name_ar'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      sellPrice: double.tryParse(json['sell_price'].toString()) ?? 0.0,
      costPrice: json['cost_price'] != null ? double.tryParse(json['cost_price'].toString()) : null,
      unit: ProductUnit.tryFromValue(json['unit'] as String?),
      taxRate: json['tax_rate'] != null ? double.tryParse(json['tax_rate'].toString()) : null,
      isWeighable: json['is_weighable'] as bool? ?? false,
      tareWeight: json['tare_weight'] != null ? double.tryParse(json['tare_weight'].toString()) : null,
      isActive: json['is_active'] as bool? ?? true,
      ageRestricted: json['age_restricted'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      category: json['category'] != null ? PredefinedCategory.fromJson(json['category'] as Map<String, dynamic>) : null,
      images: json['images'] != null
          ? (json['images'] as List).map((i) => PredefinedProductImage.fromJson(i as Map<String, dynamic>)).toList()
          : const [],
      businessType: json['business_type'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String businessTypeId;
  final String? predefinedCategoryId;
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
  final bool isWeighable;
  final double? tareWeight;
  final bool isActive;
  final bool ageRestricted;
  final String? imageUrl;
  final PredefinedCategory? category;
  final List<PredefinedProductImage> images;
  final Map<String, dynamic>? businessType;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_type_id': businessTypeId,
      'predefined_category_id': predefinedCategoryId,
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
      'age_restricted': ageRestricted,
      'image_url': imageUrl,
    };
  }

  PredefinedProduct copyWith({
    String? id,
    String? businessTypeId,
    String? predefinedCategoryId,
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
    bool? ageRestricted,
    String? imageUrl,
    PredefinedCategory? category,
    List<PredefinedProductImage>? images,
    Map<String, dynamic>? businessType,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PredefinedProduct(
      id: id ?? this.id,
      businessTypeId: businessTypeId ?? this.businessTypeId,
      predefinedCategoryId: predefinedCategoryId ?? this.predefinedCategoryId,
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
      ageRestricted: ageRestricted ?? this.ageRestricted,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      images: images ?? this.images,
      businessType: businessType ?? this.businessType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PredefinedProduct && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PredefinedProduct(id: $id, name: $name, nameAr: $nameAr, sellPrice: $sellPrice, sku: $sku)';
}
