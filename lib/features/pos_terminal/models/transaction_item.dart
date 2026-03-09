import 'package:thawani_pos/features/promotions/enums/discount_type.dart';

class TransactionItem {
  final String id;
  final String transactionId;
  final String productId;
  final String? barcode;
  final String productName;
  final String? productNameAr;
  final double quantity;
  final double unitPrice;
  final double? costPrice;
  final double? discountAmount;
  final DiscountType? discountType;
  final double? discountValue;
  final double? taxRate;
  final double taxAmount;
  final double lineTotal;
  final String? serialNumber;
  final String? batchNumber;
  final DateTime? expiryDate;
  final Map<String, dynamic>? modifierSelections;
  final String? notes;
  final bool? isReturnItem;
  final bool? ageVerified;
  final DateTime? createdAt;

  const TransactionItem({
    required this.id,
    required this.transactionId,
    required this.productId,
    this.barcode,
    required this.productName,
    this.productNameAr,
    required this.quantity,
    required this.unitPrice,
    this.costPrice,
    this.discountAmount,
    this.discountType,
    this.discountValue,
    this.taxRate,
    required this.taxAmount,
    required this.lineTotal,
    this.serialNumber,
    this.batchNumber,
    this.expiryDate,
    this.modifierSelections,
    this.notes,
    this.isReturnItem,
    this.ageVerified,
    this.createdAt,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    return TransactionItem(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      productId: json['product_id'] as String,
      barcode: json['barcode'] as String?,
      productName: json['product_name'] as String,
      productNameAr: json['product_name_ar'] as String?,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      costPrice: (json['cost_price'] as num?)?.toDouble(),
      discountAmount: (json['discount_amount'] as num?)?.toDouble(),
      discountType: DiscountType.tryFromValue(json['discount_type'] as String?),
      discountValue: (json['discount_value'] as num?)?.toDouble(),
      taxRate: (json['tax_rate'] as num?)?.toDouble(),
      taxAmount: (json['tax_amount'] as num).toDouble(),
      lineTotal: (json['line_total'] as num).toDouble(),
      serialNumber: json['serial_number'] as String?,
      batchNumber: json['batch_number'] as String?,
      expiryDate: json['expiry_date'] != null ? DateTime.parse(json['expiry_date'] as String) : null,
      modifierSelections: json['modifier_selections'] != null ? Map<String, dynamic>.from(json['modifier_selections'] as Map) : null,
      notes: json['notes'] as String?,
      isReturnItem: json['is_return_item'] as bool?,
      ageVerified: json['age_verified'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transaction_id': transactionId,
      'product_id': productId,
      'barcode': barcode,
      'product_name': productName,
      'product_name_ar': productNameAr,
      'quantity': quantity,
      'unit_price': unitPrice,
      'cost_price': costPrice,
      'discount_amount': discountAmount,
      'discount_type': discountType?.value,
      'discount_value': discountValue,
      'tax_rate': taxRate,
      'tax_amount': taxAmount,
      'line_total': lineTotal,
      'serial_number': serialNumber,
      'batch_number': batchNumber,
      'expiry_date': expiryDate?.toIso8601String(),
      'modifier_selections': modifierSelections,
      'notes': notes,
      'is_return_item': isReturnItem,
      'age_verified': ageVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  TransactionItem copyWith({
    String? id,
    String? transactionId,
    String? productId,
    String? barcode,
    String? productName,
    String? productNameAr,
    double? quantity,
    double? unitPrice,
    double? costPrice,
    double? discountAmount,
    DiscountType? discountType,
    double? discountValue,
    double? taxRate,
    double? taxAmount,
    double? lineTotal,
    String? serialNumber,
    String? batchNumber,
    DateTime? expiryDate,
    Map<String, dynamic>? modifierSelections,
    String? notes,
    bool? isReturnItem,
    bool? ageVerified,
    DateTime? createdAt,
  }) {
    return TransactionItem(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      barcode: barcode ?? this.barcode,
      productName: productName ?? this.productName,
      productNameAr: productNameAr ?? this.productNameAr,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      costPrice: costPrice ?? this.costPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      lineTotal: lineTotal ?? this.lineTotal,
      serialNumber: serialNumber ?? this.serialNumber,
      batchNumber: batchNumber ?? this.batchNumber,
      expiryDate: expiryDate ?? this.expiryDate,
      modifierSelections: modifierSelections ?? this.modifierSelections,
      notes: notes ?? this.notes,
      isReturnItem: isReturnItem ?? this.isReturnItem,
      ageVerified: ageVerified ?? this.ageVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TransactionItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TransactionItem(id: $id, transactionId: $transactionId, productId: $productId, barcode: $barcode, productName: $productName, productNameAr: $productNameAr, ...)';
}
