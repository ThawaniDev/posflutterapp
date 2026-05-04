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
    this.modifierSelections,
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

  /// Selected modifier options for this line item. Each entry is a map
  /// shaped like the backend `modifier_selections` payload:
  ///   { modifier_group_id, modifier_option_id, name, price_adjustment, quantity }
  /// `price_adjustment` is summed into the per-unit price below.
  final List<Map<String, dynamic>>? modifierSelections;

  /// Total per-unit add-on cost from selected modifiers (e.g. extra cheese
  /// + large size). Multiplied by `quantity` when computing the line total.
  double get modifierAdjustment {
    final list = modifierSelections;
    if (list == null || list.isEmpty) return 0;
    return list.fold<double>(
      0,
      (s, m) => s + ((m['price_adjustment'] as num?)?.toDouble() ?? 0) * ((m['quantity'] as num?)?.toDouble() ?? 1),
    );
  }

  /// Raw tax rate as stored in DB (e.g. 15 for 15%).
  double get rawTaxRate => product.taxRate ?? 15.0;

  /// Normalized tax rate as decimal fraction for calculations (e.g. 0.15).
  double get taxRate {
    final rate = rawTaxRate;
    return rate > 1 ? rate / 100 : rate;
  }

  double get subtotal => quantity * (unitPrice + modifierAdjustment) - (discountAmount ?? 0);

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
    List<Map<String, dynamic>>? modifierSelections,
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
      modifierSelections: modifierSelections ?? this.modifierSelections,
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
      if (modifierSelections != null && modifierSelections!.isNotEmpty) 'modifier_selections': modifierSelections,
      if (notes != null && notes!.isNotEmpty) 'item_notes': notes,
    };
  }
}
