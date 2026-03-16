import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/catalog/models/supplier.dart';

// ─── Products List State ───────────────────────────────────────

sealed class ProductsState {
  const ProductsState();
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? selectedCategoryId;
  final String? searchQuery;

  const ProductsLoaded({
    required this.products,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.selectedCategoryId,
    this.searchQuery,
  });

  bool get hasMore => currentPage < lastPage;

  ProductsLoaded copyWith({
    List<Product>? products,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});
}

// ─── Product Detail / Form State ───────────────────────────────

sealed class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial();
}

class ProductDetailLoading extends ProductDetailState {
  const ProductDetailLoading();
}

class ProductDetailLoaded extends ProductDetailState {
  final Product product;

  const ProductDetailLoaded({required this.product});
}

class ProductDetailSaving extends ProductDetailState {
  const ProductDetailSaving();
}

class ProductDetailSaved extends ProductDetailState {
  final Product product;

  const ProductDetailSaved({required this.product});
}

class ProductDetailError extends ProductDetailState {
  final String message;

  const ProductDetailError({required this.message});
}

// ─── Categories State ──────────────────────────────────────────

sealed class CategoriesState {
  const CategoriesState();
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  final List<Category> categories;

  const CategoriesLoaded({required this.categories});

  CategoriesLoaded copyWith({List<Category>? categories}) => CategoriesLoaded(categories: categories ?? this.categories);
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError({required this.message});
}

// ─── Suppliers State ───────────────────────────────────────────

sealed class SuppliersState {
  const SuppliersState();
}

class SuppliersInitial extends SuppliersState {
  const SuppliersInitial();
}

class SuppliersLoading extends SuppliersState {
  const SuppliersLoading();
}

class SuppliersLoaded extends SuppliersState {
  final List<Supplier> suppliers;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;

  const SuppliersLoaded({
    required this.suppliers,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
  });

  bool get hasMore => currentPage < lastPage;

  SuppliersLoaded copyWith({List<Supplier>? suppliers, int? total, int? currentPage, int? lastPage, int? perPage}) {
    return SuppliersLoaded(
      suppliers: suppliers ?? this.suppliers,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
    );
  }
}

class SuppliersError extends SuppliersState {
  final String message;

  const SuppliersError({required this.message});
}
