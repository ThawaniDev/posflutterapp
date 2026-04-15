import 'package:wameedpos/features/debits/models/debit.dart';

sealed class DebitsState {
  const DebitsState();
}

class DebitsInitial extends DebitsState {
  const DebitsInitial();
}

class DebitsLoading extends DebitsState {
  const DebitsLoading();
}

class DebitsLoaded extends DebitsState {
  final List<Debit> debits;
  final int total;
  final int currentPage;
  final int lastPage;
  final int perPage;
  final String? statusFilter;
  final String? debitTypeFilter;
  final String? searchQuery;
  final DebitSummary? summary;

  const DebitsLoaded({
    required this.debits,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    this.statusFilter,
    this.debitTypeFilter,
    this.searchQuery,
    this.summary,
  });

  bool get hasMore => currentPage < lastPage;

  DebitsLoaded copyWith({
    List<Debit>? debits,
    int? total,
    int? currentPage,
    int? lastPage,
    int? perPage,
    String? statusFilter,
    String? debitTypeFilter,
    String? searchQuery,
    DebitSummary? summary,
  }) {
    return DebitsLoaded(
      debits: debits ?? this.debits,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      perPage: perPage ?? this.perPage,
      statusFilter: statusFilter ?? this.statusFilter,
      debitTypeFilter: debitTypeFilter ?? this.debitTypeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      summary: summary ?? this.summary,
    );
  }
}

class DebitsError extends DebitsState {
  final String message;
  const DebitsError({required this.message});
}
