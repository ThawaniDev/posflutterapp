import 'package:wameedpos/features/receivables/models/receivable.dart';

sealed class ReceivablesState {
  const ReceivablesState();
}

class ReceivablesInitial extends ReceivablesState {
  const ReceivablesInitial();
}

class ReceivablesLoading extends ReceivablesState {
  const ReceivablesLoading();
}

class ReceivablesLoaded extends ReceivablesState {

  const ReceivablesLoaded({
    required this.receivables,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.statusFilter,
    this.receivableTypeFilter,
    this.searchQuery,
    this.summary,
  });
  final List<Receivable> receivables;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? statusFilter;
  final String? receivableTypeFilter;
  final String? searchQuery;
  final ReceivableSummary? summary;

  bool get hasMore => currentPage < lastPage;

  ReceivablesLoaded copyWith({
    List<Receivable>? receivables,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? statusFilter,
    String? receivableTypeFilter,
    String? searchQuery,
    ReceivableSummary? summary,
  }) {
    return ReceivablesLoaded(
      receivables: receivables ?? this.receivables,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      statusFilter: statusFilter ?? this.statusFilter,
      receivableTypeFilter: receivableTypeFilter ?? this.receivableTypeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      summary: summary ?? this.summary,
    );
  }
}

class ReceivablesError extends ReceivablesState {
  const ReceivablesError({required this.message});
  final String message;
}
