import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/models/cart_item.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';
import 'package:wameedpos/features/pos_terminal/widgets/tax_exempt_dialog.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/customers/services/customer_search_service.dart';

// ─── Cart Provider ──────────────────────────────────────────────

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addProduct(Product product, {double qty = 1}) {
    final existing = state.items.indexWhere((i) => i.product.id == product.id);
    if (existing >= 0) {
      final updated = List<CartItem>.from(state.items);
      updated[existing] = updated[existing].copyWith(quantity: updated[existing].quantity + qty);
      state = state.copyWith(items: updated);
    } else {
      final price =
          product.offerPrice != null &&
              product.offerStart != null &&
              product.offerEnd != null &&
              DateTime.now().isAfter(product.offerStart!) &&
              DateTime.now().isBefore(product.offerEnd!)
          ? product.offerPrice!
          : product.sellPrice;
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(product: product, quantity: qty, unitPrice: price),
        ],
      );
    }
  }

  void updateQuantity(int index, double qty) {
    if (index < 0 || index >= state.items.length) return;
    if (qty <= 0) {
      removeItem(index);
      return;
    }
    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(quantity: qty);
    state = state.copyWith(items: updated);
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<CartItem>.from(state.items);
    updated.removeAt(index);
    state = state.copyWith(items: updated);
  }

  void setItemDiscount(int index, double amount) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(discountAmount: amount);
    state = state.copyWith(items: updated);
  }

  void setItemNotes(int index, String notes) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(notes: notes);
    state = state.copyWith(items: updated);
  }

  void setCustomer(Customer? customer) {
    state = state.copyWith(customer: customer, clearCustomer: customer == null);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setManualDiscount(double? discount) {
    state = state.copyWith(manualDiscount: discount);
  }

  void toggleTaxExempt() {
    state = state.copyWith(taxExempt: !state.taxExempt);
  }

  /// Apply tax-exemption details captured from the dialog. Forces taxExempt=true.
  void setTaxExemption(TaxExemptionDetails? details) {
    if (details == null) {
      state = state.copyWith(taxExempt: false, clearTaxExemption: true);
    } else {
      state = state.copyWith(taxExempt: true, taxExemption: details);
    }
  }

  /// Mark a cart line as age-verified (used after the age-verification dialog).
  void markAgeVerified(int index) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(ageVerified: true);
    state = state.copyWith(items: updated);
  }

  void clear() {
    state = const CartState();
  }

  void restoreFromHeldCart(Map<String, dynamic> cartData, List<Product> products) {
    final rawItems = cartData['items'] as List? ?? [];
    final items = <CartItem>[];
    for (final raw in rawItems) {
      final map = raw as Map<String, dynamic>;
      final productId = map['product_id'] as String;
      final product = products.where((p) => p.id == productId).firstOrNull;
      if (product != null) {
        items.add(
          CartItem(
            product: product,
            quantity: double.tryParse(map['quantity'].toString()) ?? 0.0,
            unitPrice: double.tryParse(map['unit_price'].toString()) ?? 0.0,
            discountAmount: (map['discount_amount'] != null ? double.tryParse(map['discount_amount'].toString()) : null),
            notes: map['notes'] as String?,
          ),
        );
      }
    }
    state = CartState(
      items: items,
      notes: cartData['notes'] as String?,
      manualDiscount: (cartData['manual_discount'] != null ? double.tryParse(cartData['manual_discount'].toString()) : null),
    );
  }
}

// ─── Active Session Provider ────────────────────────────────────

final activeSessionProvider = StateNotifierProvider<ActiveSessionNotifier, ActiveSessionState>((ref) {
  return ActiveSessionNotifier(ref.watch(posTerminalRepositoryProvider));
});

class ActiveSessionNotifier extends StateNotifier<ActiveSessionState> {
  ActiveSessionNotifier(this._repo) : super(const ActiveSessionNone());
  final PosTerminalRepository _repo;

  Future<void> openSession({required double openingCash, required String registerId}) async {
    state = const ActiveSessionLoading();
    try {
      final session = await _repo.openSession({'opening_cash': openingCash, 'register_id': registerId});
      state = ActiveSessionLoaded(session: session);
    } on DioException catch (e) {
      state = ActiveSessionError(message: _extractError(e));
    } catch (e) {
      state = ActiveSessionError(message: e.toString());
    }
  }

  Future<bool> closeSession({required double closingCash}) async {
    final current = state;
    if (current is! ActiveSessionLoaded) return false;
    state = const ActiveSessionLoading();
    try {
      await _repo.closeSession(current.session.id, {'closing_cash': closingCash});
      state = const ActiveSessionNone();
      return true;
    } on DioException catch (e) {
      state = ActiveSessionError(message: _extractError(e));
      return false;
    } catch (e) {
      state = ActiveSessionError(message: e.toString());
      return false;
    }
  }

  Future<void> refreshSession() async {
    final current = state;
    if (current is! ActiveSessionLoaded) return;
    try {
      final session = await _repo.getSession(current.session.id);
      state = ActiveSessionLoaded(session: session);
    } catch (_) {}
  }

  void setSession(PosSession session) {
    state = ActiveSessionLoaded(session: session);
  }

  void clearSession() {
    state = const ActiveSessionNone();
  }
}

// ─── POS Products Provider ──────────────────────────────────────

final posProductsProvider = StateNotifierProvider<PosProductsNotifier, PosProductsState>((ref) {
  return PosProductsNotifier(ref.watch(posTerminalRepositoryProvider));
});

class PosProductsNotifier extends StateNotifier<PosProductsState> {
  PosProductsNotifier(this._repo) : super(const PosProductsInitial());
  final PosTerminalRepository _repo;

  Future<void> load({String? search, String? categoryId, String? barcode}) async {
    state = const PosProductsLoading();
    try {
      final result = await _repo.listPosProducts(search: search, categoryId: categoryId, barcode: barcode, perPage: 100);
      state = PosProductsLoaded(
        products: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        search: search,
        categoryId: categoryId,
      );
    } on DioException catch (e) {
      state = PosProductsError(message: _extractError(e));
    } catch (e) {
      state = PosProductsError(message: e.toString());
    }
  }

  Future<Product?> findByBarcode(String barcode) async {
    try {
      final result = await _repo.listPosProducts(barcode: barcode, perPage: 1);
      return result.items.isNotEmpty ? result.items.first : null;
    } catch (_) {
      return null;
    }
  }
}

// ─── POS Customers Provider ─────────────────────────────────────

final posCustomersProvider = StateNotifierProvider<PosCustomersNotifier, PosCustomersState>((ref) {
  return PosCustomersNotifier(ref.watch(customerSearchServiceProvider), ref);
});

class PosCustomersNotifier extends StateNotifier<PosCustomersState> {
  PosCustomersNotifier(this._search, this._ref) : super(const PosCustomersInitial());
  final CustomerSearchService _search;
  final Ref _ref;

  Future<void> search(String query) async {
    if (query.isEmpty) {
      state = const PosCustomersInitial();
      return;
    }
    state = const PosCustomersLoading();
    try {
      final auth = _ref.read(authProvider);
      final orgId = auth is AuthAuthenticated ? (auth.user.organizationId ?? '') : '';
      final results = await _search.search(orgId, query, limit: 20);
      state = PosCustomersLoaded(customers: results);
    } on DioException catch (e) {
      state = PosCustomersError(message: _extractError(e));
    } catch (e) {
      state = PosCustomersError(message: e.toString());
    }
  }
}

// ─── Sale Provider (checkout flow) ──────────────────────────────

final saleProvider = StateNotifierProvider<SaleNotifier, SaleState>((ref) {
  return SaleNotifier(ref.watch(posTerminalRepositoryProvider));
});

class SaleNotifier extends StateNotifier<SaleState> {
  SaleNotifier(this._repo) : super(const SaleIdle());
  final PosTerminalRepository _repo;

  Future<bool> completeSale({
    required String sessionId,
    required CartState cart,
    required List<Map<String, dynamic>> payments,
    double tipAmount = 0,
    String? approvalToken,
    String? saleType,
  }) async {
    state = const SaleProcessing();
    try {
      final data = {
        'type': 'sale',
        'pos_session_id': sessionId,
        if (saleType != null) 'sale_type': saleType,
        'subtotal': cart.subtotal,
        'discount_amount': cart.discountTotal > 0 ? cart.discountTotal : null,
        'tax_amount': cart.taxAmount,
        'tip_amount': tipAmount > 0 ? tipAmount : null,
        'total_amount': cart.totalAmount + tipAmount,
        'items': cart.items.map((i) => i.toTransactionItemJson()).toList(),
        'payments': payments,
        if (cart.customer != null) 'customer_id': cart.customer!.id,
        if (cart.notes != null) 'notes': cart.notes,
        if (cart.taxExempt) 'is_tax_exempt': true,
        if (cart.taxExemption != null) 'tax_exemption': cart.taxExemption!.toJson(),
        if (approvalToken != null) 'approval_token': approvalToken,
      };
      final transaction = await _repo.createTransaction(data);
      final change = payments
          .where((p) => p['method'] == 'cash' && p['change_given'] != null)
          .fold<double>(0, (sum, p) => sum + (double.tryParse(p['change_given'].toString()) ?? 0.0));
      state = SaleCompleted(
        transactionId: transaction.id,
        transactionNumber: transaction.transactionNumber,
        totalAmount: transaction.totalAmount,
        changeGiven: change > 0 ? change : null,
      );
      return true;
    } on DioException catch (e) {
      state = SaleError(message: _extractError(e));
      return false;
    } catch (e) {
      state = SaleError(message: e.toString());
      return false;
    }
  }

  Future<bool> processReturn({
    required String returnTransactionId,
    required List<Map<String, dynamic>> items,
    required List<Map<String, dynamic>> payments,
    required double subtotal,
    required double totalAmount,
    double discountAmount = 0,
    double taxAmount = 0,
    String? notes,
    String? posSessionId,
  }) async {
    state = const SaleProcessing();
    try {
      final data = <String, dynamic>{
        'return_transaction_id': returnTransactionId,
        'subtotal': subtotal,
        'discount_amount': discountAmount,
        'tax_amount': taxAmount,
        'total_amount': totalAmount,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
        if (posSessionId != null) 'pos_session_id': posSessionId,
        'items': items,
        'payments': payments,
      };
      final transaction = await _repo.returnTransaction(data);
      state = SaleCompleted(transactionId: transaction.id, transactionNumber: transaction.transactionNumber, totalAmount: transaction.totalAmount);
      return true;
    } on DioException catch (e) {
      state = SaleError(message: _extractError(e));
      return false;
    } catch (e) {
      state = SaleError(message: e.toString());
      return false;
    }
  }

  void reset() {
    state = const SaleIdle();
  }
}

// ─── Helper ─────────────────────────────────────────────────────

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}
