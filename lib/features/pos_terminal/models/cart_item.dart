import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/promotions/enums/discount_type.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.quantity,
    required this.unitPrice,
    this.discountAmount,
    this.discountType,
    this.discountValue,
    this.notes,
    this.ageVerified = false,
  });
  final Product product;
  final double quantity;
  final double unitPrice;
  final double? discountAmount;
  final DiscountType? discountType;
  final double? discountValue;
  final String? notes;

  /// Set to true once the cashier has verified the customer's age for an
  /// age-restricted product. Persisted on the backend as `age_verified`.
  final bool ageVerified;

  /// Raw tax rate as stored in DB (e.g. 15 for 15%).
  double get rawTaxRate => product.taxRate ?? 15.0;

  /// Normalized tax rate as decimal fraction for calculations (e.g. 0.15).
  double get taxRate {
    final rate = rawTaxRate;
    return rate > 1 ? rate / 100 : rate;
  }

  double get subtotal => quantity * unitPrice - (discountAmount ?? 0);

  double get taxAmount => subtotal * taxRate;

  double get lineTotal => subtotal + taxAmount;

  CartItem copyWith({
    Product? product,
    double? quantity,
    double? unitPrice,
    double? discountAmount,
    DiscountType? discountType,
    double? discountValue,
    String? notes,
    bool? ageVerified,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountAmount: discountAmount ?? this.discountAmount,
      discountType: discountType ?? this.discountType,
      discountValue: discountValue ?? this.discountValue,
      notes: notes ?? this.notes,
      ageVerified: ageVerified ?? this.ageVerified,
    );
  }

  Map<String, dynamic> toTransactionItemJson() {
    return {
      'product_id': product.id,
      'barcode': product.barcode,
      'product_name': product.name,
      'product_name_ar': product.nameAr,
      'quantity': quantity,
      'unit_price': unitPrice,
      'cost_price': product.costPrice,
      'discount_amount': discountAmount ?? 0,
      if (discountType != null) 'discount_type': discountType!.value,
      if (discountValue != null) 'discount_value': discountValue,
      'tax_rate': rawTaxRate,
      'tax_amount': taxAmount,
      'line_total': lineTotal,
      if (ageVerified) 'age_verified': true,
    };
  }
}
