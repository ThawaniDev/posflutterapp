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
    this.pricesIncludeTax = true,
  });
  final Product product;
  final double quantity;
  final double unitPrice;
  final double? discountAmount;
  final DiscountType? discountType;
  final double? discountValue;
  final String? notes;
  final bool ageVerified;
  final List<Map<String, dynamic>>? modifierSelections;

  /// Whether the [unitPrice] already includes VAT/tax.
  /// When true, tax is extracted from the price (not added on top).
  final bool pricesIncludeTax;

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

  /// Gross line amount (quantity × price − item discount) — what the customer pays.
  double get grossAmount => quantity * (unitPrice + modifierAdjustment) - (discountAmount ?? 0);

  /// Net (ex-VAT) subtotal used for display and receipt reporting.
  /// • When [pricesIncludeTax] = true  → extracts the net from the inclusive price.
  /// • When [pricesIncludeTax] = false → equal to the gross (tax is added on top).
  double get subtotal => pricesIncludeTax ? grossAmount / (1 + taxRate) : grossAmount;

  /// VAT/tax component of this line.
  /// • When [pricesIncludeTax] = true  → extracted from the inclusive price.
  /// • When [pricesIncludeTax] = false → calculated as net × taxRate.
  double get taxAmount => pricesIncludeTax ? grossAmount - subtotal : subtotal * taxRate;

  /// Total customer-facing line total (= subtotal + taxAmount = grossAmount).
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
    bool? pricesIncludeTax,
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
      pricesIncludeTax: pricesIncludeTax ?? this.pricesIncludeTax,
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
