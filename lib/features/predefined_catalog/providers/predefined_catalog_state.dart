import 'package:thawani_pos/features/predefined_catalog/models/predefined_category.dart';
import 'package:thawani_pos/features/predefined_catalog/models/predefined_product.dart';

// ─── Predefined Categories State ─────────────────────────────

sealed class PredefinedCategoriesState {
  const PredefinedCategoriesState();
}

class PredefinedCategoriesInitial extends PredefinedCategoriesState {
  const PredefinedCategoriesInitial();
}

class PredefinedCategoriesLoading extends PredefinedCategoriesState {
  const PredefinedCategoriesLoading();
}

class PredefinedCategoriesLoaded extends PredefinedCategoriesState {
  final List<PredefinedCategory> categories;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? selectedBusinessTypeId;

  const PredefinedCategoriesLoaded({
    required this.categories,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.selectedBusinessTypeId,
  });

  bool get hasMore => currentPage < lastPage;

  PredefinedCategoriesLoaded copyWith({
    List<PredefinedCategory>? categories,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? selectedBusinessTypeId,
  }) {
    return PredefinedCategoriesLoaded(
      categories: categories ?? this.categories,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      selectedBusinessTypeId: selectedBusinessTypeId ?? this.selectedBusinessTypeId,
    );
  }
}

class PredefinedCategoriesError extends PredefinedCategoriesState {
  final String message;

  const PredefinedCategoriesError({required this.message});
}

// ─── Category Tree State ─────────────────────────────────────

sealed class PredefinedCategoryTreeState {
  const PredefinedCategoryTreeState();
}

class PredefinedCategoryTreeInitial extends PredefinedCategoryTreeState {
  const PredefinedCategoryTreeInitial();
}

class PredefinedCategoryTreeLoading extends PredefinedCategoryTreeState {
  const PredefinedCategoryTreeLoading();
}

class PredefinedCategoryTreeLoaded extends PredefinedCategoryTreeState {
  final List<PredefinedCategory> tree;

  const PredefinedCategoryTreeLoaded({required this.tree});
}

class PredefinedCategoryTreeError extends PredefinedCategoryTreeState {
  final String message;

  const PredefinedCategoryTreeError({required this.message});
}

// ─── Predefined Products State ───────────────────────────────

sealed class PredefinedProductsState {
  const PredefinedProductsState();
}

class PredefinedProductsInitial extends PredefinedProductsState {
  const PredefinedProductsInitial();
}

class PredefinedProductsLoading extends PredefinedProductsState {
  const PredefinedProductsLoading();
}

class PredefinedProductsLoaded extends PredefinedProductsState {
  final List<PredefinedProduct> products;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? selectedCategoryId;
  final String? searchQuery;

  const PredefinedProductsLoaded({
    required this.products,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.selectedCategoryId,
    this.searchQuery,
  });

  bool get hasMore => currentPage < lastPage;

  PredefinedProductsLoaded copyWith({
    List<PredefinedProduct>? products,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? selectedCategoryId,
    String? searchQuery,
  }) {
    return PredefinedProductsLoaded(
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

class PredefinedProductsError extends PredefinedProductsState {
  final String message;

  const PredefinedProductsError({required this.message});
}

// ─── Clone State ─────────────────────────────────────────────

sealed class CloneState {
  const CloneState();
}

class CloneIdle extends CloneState {
  const CloneIdle();
}

class CloneInProgress extends CloneState {
  const CloneInProgress();
}

class CloneSuccess extends CloneState {
  final String message;
  final Map<String, dynamic> result;

  const CloneSuccess({required this.message, required this.result});
}

class CloneError extends CloneState {
  final String message;

  const CloneError({required this.message});
}
