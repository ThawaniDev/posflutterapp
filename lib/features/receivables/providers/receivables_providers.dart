import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/receivables/models/receivable.dart';
import 'package:wameedpos/features/receivables/providers/receivables_state.dart';
import 'package:wameedpos/features/receivables/repositories/receivable_repository.dart';

// ─── Receivables Provider ────────────────────────────────────────────

final receivablesProvider = StateNotifierProvider<ReceivablesNotifier, ReceivablesState>((ref) {
  return ReceivablesNotifier(ref.watch(receivableRepositoryProvider));
});

class ReceivablesNotifier extends StateNotifier<ReceivablesState> {
  final ReceivableRepository _repo;

  ReceivablesNotifier(this._repo) : super(const ReceivablesInitial());

  String? _statusFilter;
  String? _receivableTypeFilter;
  String? _searchQuery;

  Future<void> load({int page = 1, String? status, String? receivableType, String? search}) async {
    _statusFilter = status ?? _statusFilter;
    _receivableTypeFilter = receivableType ?? _receivableTypeFilter;
    _searchQuery = search ?? _searchQuery;
    state = const ReceivablesLoading();
    try {
      final result = await _repo.listReceivables(
        page: page,
        status: _statusFilter,
        receivableType: _receivableTypeFilter,
        search: _searchQuery,
      );
      final summary = await _repo.getSummary();
      state = ReceivablesLoaded(
        receivables: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        perPage: result.perPage,
        statusFilter: _statusFilter,
        receivableTypeFilter: _receivableTypeFilter,
        searchQuery: _searchQuery,
        summary: summary,
      );
    } on DioException catch (e) {
      state = ReceivablesError(message: _extractError(e));
    } catch (e) {
      state = ReceivablesError(message: e.toString());
    }
  }

  Future<void> filterByStatus(String? status) async {
    _statusFilter = status;
    await load(status: status);
  }

  Future<void> filterByType(String? receivableType) async {
    _receivableTypeFilter = receivableType;
    await load(receivableType: receivableType);
  }

  Future<void> search(String? query) async {
    _searchQuery = (query != null && query.isEmpty) ? null : query;
    await load(search: _searchQuery);
  }

  Future<void> nextPage() async {
    if (state is! ReceivablesLoaded) return;
    final loaded = state as ReceivablesLoaded;
    if (loaded.currentPage < loaded.lastPage) {
      await load(page: loaded.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state is! ReceivablesLoaded) return;
    final loaded = state as ReceivablesLoaded;
    if (loaded.currentPage > 1) {
      await load(page: loaded.currentPage - 1);
    }
  }

  Future<Receivable> createReceivable({
    required String customerId,
    required String receivableType,
    required String source,
    required double amount,
    String? dueDate,
    String? description,
    String? descriptionAr,
    String? notes,
    String? referenceNumber,
  }) async {
    final receivable = await _repo.createReceivable(
      customerId: customerId,
      receivableType: receivableType,
      source: source,
      amount: amount,
      dueDate: dueDate,
      description: description,
      descriptionAr: descriptionAr,
      notes: notes,
      referenceNumber: referenceNumber,
    );
    await load();
    return receivable;
  }

  Future<Receivable> updateReceivable(String id, Map<String, dynamic> data) async {
    final receivable = await _repo.updateReceivable(id, data);
    await load();
    return receivable;
  }

  Future<void> deleteReceivable(String id) async {
    await _repo.deleteReceivable(id);
    await load();
  }

  Future<ReceivablePayment> recordPayment({
    required String receivableId,
    required double amount,
    String? orderId,
    String? paymentMethod,
    String? notes,
  }) async {
    final payment = await _repo.recordPayment(
      receivableId: receivableId,
      amount: amount,
      orderId: orderId,
      paymentMethod: paymentMethod,
      notes: notes,
    );
    await load();
    return payment;
  }

  Future<Receivable> addNote({required String receivableId, required String note}) async {
    final receivable = await _repo.addNote(receivableId: receivableId, note: note);
    await load();
    return receivable;
  }

  Future<Receivable> reverseReceivable(String receivableId, {String? reason}) async {
    final receivable = await _repo.reverseReceivable(receivableId, reason: reason);
    await load();
    return receivable;
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
