import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/customers/models/customer.dart';
import 'package:thawani_pos/features/pos_terminal/models/cart_item.dart';
import 'package:thawani_pos/features/pos_terminal/models/pos_session.dart';

// ─── Cart State ─────────────────────────────────────────────────

class CartState {
  final List<CartItem> items;
  final Customer? customer;
  final String? notes;
  final double? manualDiscount;

  const CartState({this.items = const [], this.customer, this.notes, this.manualDiscount});

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity.toInt());

  double get subtotal => items.fold(0.0, (sum, i) => sum + i.subtotal);

  double get taxAmount => items.fold(0.0, (sum, i) => sum + i.taxAmount);

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
  }) {
    return CartState(
      items: items ?? this.items,
      customer: clearCustomer ? null : (customer ?? this.customer),
      notes: notes ?? this.notes,
      manualDiscount: manualDiscount ?? this.manualDiscount,
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
  final List<Product> products;
  final int total;
  final int currentPage;
  final int lastPage;
  final String? search;
  final String? categoryId;

  const PosProductsLoaded({
    required this.products,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.search,
    this.categoryId,
  });

  bool get hasMore => currentPage < lastPage;
}

class PosProductsError extends PosProductsState {
  final String message;
  const PosProductsError({required this.message});
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
  final List<Customer> customers;

  const PosCustomersLoaded({required this.customers});
}

class PosCustomersError extends PosCustomersState {
  final String message;
  const PosCustomersError({required this.message});
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
  final PosSession session;
  const ActiveSessionLoaded({required this.session});
}

class ActiveSessionError extends ActiveSessionState {
  final String message;
  const ActiveSessionError({required this.message});
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
  final String transactionNumber;
  final double totalAmount;
  final double? changeGiven;
  const SaleCompleted({required this.transactionNumber, required this.totalAmount, this.changeGiven});
}

class SaleError extends SaleState {
  final String message;
  const SaleError({required this.message});
}
