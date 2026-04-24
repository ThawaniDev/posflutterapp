import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/models/cart_item.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/widgets/tax_exempt_dialog.dart';

// ─── Cart State ──────────────────────────────────────

class CartState {
  const CartState({
    this.items = const [],
    this.customer,
    this.notes,
    this.manualDiscount,
    this.taxExempt = false,
    this.taxExemption,
  });
  final List<CartItem> items;
  final Customer? customer;
  final String? notes;
  final double? manualDiscount;
  final bool taxExempt;
  final TaxExemptionDetails? taxExemption;

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity.toInt());

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.subtotal);

  double get taxAmount => taxExempt ? 0.0 : items.fold(0.0, (sum, i) => sum + i.taxAmount);

  double get discountTotal => (manualDiscount ?? 0) + items.fold(0.0, (sum, i) => sum + (i.discountAmount ?? 0));

  double get totalAmount => subtotal + taxAmount - (manualDiscount ?? 0);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  CartState copyWith({
    List<CartItem>? items,
    Customer? customer,
    String? notes,
    double? manualDiscount,
    bool clearCustomer = false,
    bool? taxExempt,
    TaxExemptionDetails? taxExemption,
    bool clearTaxExemption = false,
  }) {
    return CartState(
      items: items ?? this.items,
      customer: clearCustomer ? null : (customer ?? this.customer),
      notes: notes ?? this.notes,
      manualDiscount: manualDiscount ?? this.manualDiscount,
      taxExempt: taxExempt ?? this.taxExempt,
      taxExemption: clearTaxExemption ? null : (taxExemption ?? this.taxExemption),
    );
  }

  Map<String, dynamic> toHoldCartJson() {
    return {
      'cart_data': items
          .map(
            (i) => {
              'product_id': i.product.id,
              'product_name': i.product.name,
              'product_name_ar': i.product.nameAr,
              'barcode': i.product.barcode,
              'quantity': i.quantity,
              'unit_price': i.unitPrice,
              'discount_amount': i.discountAmount ?? 0,
              'discount_type': i.discountType?.value,
              'discount_value': i.discountValue,
              'notes': i.notes,
            },
          )
          .toList(),
      if (customer != null) 'customer_id': customer!.id,
      if (notes != null) 'notes': notes,
      if (manualDiscount != null) 'manual_discount': manualDiscount,
      if (taxExempt) 'is_tax_exempt': true,
      if (taxExemption != null) 'tax_exemption': taxExemption!.toJson(),
    };
  }
}

// ─── POS Products State ─────────────────────────────────────────

sealed class PosProductsState {
  const PosProductsState();
}

class PosProductsInitial extends PosProductsState {
  const PosProductsInitial();
}

class PosProductsLoading extends PosProductsState {
  const PosProductsLoading();
}

class PosProductsLoaded extends PosProductsState {
  const PosProductsLoaded({
    required this.products,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.search,
    this.categoryId,
  });
  final List<Product> products;
  final int total;
  final int currentPage;
  final int lastPage;
  final String? search;
  final String? categoryId;

  bool get hasMore => currentPage < lastPage;
}

class PosProductsError extends PosProductsState {
  const PosProductsError({required this.message});
  final String message;
}

// ─── POS Customers State ────────────────────────────────────────

sealed class PosCustomersState {
  const PosCustomersState();
}

class PosCustomersInitial extends PosCustomersState {
  const PosCustomersInitial();
}

class PosCustomersLoading extends PosCustomersState {
  const PosCustomersLoading();
}

class PosCustomersLoaded extends PosCustomersState {
  const PosCustomersLoaded({required this.customers});
  final List<Customer> customers;
}

class PosCustomersError extends PosCustomersState {
  const PosCustomersError({required this.message});
  final String message;
}

// ─── Active Session State ───────────────────────────────────────

sealed class ActiveSessionState {
  const ActiveSessionState();
}

class ActiveSessionNone extends ActiveSessionState {
  const ActiveSessionNone();
}

class ActiveSessionLoading extends ActiveSessionState {
  const ActiveSessionLoading();
}

class ActiveSessionLoaded extends ActiveSessionState {
  const ActiveSessionLoaded({required this.session});
  final PosSession session;
}

class ActiveSessionError extends ActiveSessionState {
  const ActiveSessionError({required this.message});
  final String message;
}

// ─── Sale Result ────────────────────────────────────────────────

sealed class SaleState {
  const SaleState();
}

class SaleIdle extends SaleState {
  const SaleIdle();
}

class SaleProcessing extends SaleState {
  const SaleProcessing();
}

class SaleCompleted extends SaleState {
  const SaleCompleted({
    required this.transactionId,
    required this.transactionNumber,
    required this.totalAmount,
    this.changeGiven,
  });
  final String transactionId;
  final String transactionNumber;
  final double totalAmount;
  final double? changeGiven;
}

class SaleError extends SaleState {
  const SaleError({required this.message});
  final String message;
}
