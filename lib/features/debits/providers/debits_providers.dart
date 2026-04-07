import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/debits/models/debit.dart';
import 'package:thawani_pos/features/debits/providers/debits_state.dart';
import 'package:thawani_pos/features/debits/repositories/debit_repository.dart';

// ─── Debits Provider ────────────────────────────────────────────

final debitsProvider = StateNotifierProvider<DebitsNotifier, DebitsState>((ref) {
  return DebitsNotifier(ref.watch(debitRepositoryProvider));
});

class DebitsNotifier extends StateNotifier<DebitsState> {
  final DebitRepository _repo;

  DebitsNotifier(this._repo) : super(const DebitsInitial());

  String? _statusFilter;
  String? _debitTypeFilter;
  String? _searchQuery;

  Future<void> load({int page = 1, String? status, String? debitType, String? search}) async {
    _statusFilter = status ?? _statusFilter;
    _debitTypeFilter = debitType ?? _debitTypeFilter;
    _searchQuery = search ?? _searchQuery;
    state = const DebitsLoading();
    try {
      final result = await _repo.listDebits(page: page, status: _statusFilter, debitType: _debitTypeFilter, search: _searchQuery);
      final summary = await _repo.getSummary();
      state = DebitsLoaded(
        debits: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        statusFilter: _statusFilter,
        debitTypeFilter: _debitTypeFilter,
        searchQuery: _searchQuery,
        summary: summary,
      );
    } on DioException catch (e) {
      state = DebitsError(message: _extractError(e));
    } catch (e) {
      state = DebitsError(message: e.toString());
    }
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    await load(status: status);
  }

  Future<void> filterByType(String? debitType) async {
    _debitTypeFilter = debitType;
    await load(debitType: debitType);
  }

  Future<void> search(String? query) async {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    await load(search: _searchQuery);
  }

  Future<void> nextPage() async {
    if (state is! DebitsLoaded) return;
    final loaded = state as DebitsLoaded;
    if (loaded.currentPage < loaded.lastPage) {
      await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is! DebitsLoaded) return;
    final loaded = state as DebitsLoaded;
    if (loaded.currentPage > 1) {
      await load(page: loaded.currentPage - 1);
    }
  }

  Future<Debit> createDebit({
    required String customerId,
    required String debitType,
    required String source,
    required double amount,
    String? description,
    String? descriptionAr,
    String? notes,
    String? referenceNumber,
  }) async {
    final debit = await _repo.createDebit(
      customerId: customerId,
      debitType: debitType,
      source: source,
      amount: amount,
      description: description,
      descriptionAr: descriptionAr,
      notes: notes,
      referenceNumber: referenceNumber,
    );
    await load();
    return debit;
  }

  Future<Debit> updateDebit(String id, Map<String, dynamic> data) async {
    final debit = await _repo.updateDebit(id, data);
    await load();
    return debit;
  }

  Future<void> deleteDebit(String id) async {
    await _repo.deleteDebit(id);
    await load();
  }

  Future<DebitAllocation> allocateDebit({
    required String debitId,
    required String orderId,
    required double amount,
    String? notes,
  }) async {
    final allocation = await _repo.allocateDebit(debitId: debitId, orderId: orderId, amount: amount, notes: notes);
    await load();
    return allocation;
  }

  Future<Debit> reverseDebit(String debitId, {String? reason}) async {
    final debit = await _repo.reverseDebit(debitId, reason: reason);
    await load();
    return debit;
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
