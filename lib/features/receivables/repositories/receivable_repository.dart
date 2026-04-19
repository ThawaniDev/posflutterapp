import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/receivables/data/remote/receivables_api_service.dart';
import 'package:wameedpos/features/receivables/models/receivable.dart';

final receivableRepositoryProvider = Provider<ReceivableRepository>((ref) {
  return ReceivableRepository(apiService: ref.watch(receivablesApiServiceProvider));
});

class ReceivableRepository {
  final ReceivablesApiService _apiService;

  ReceivableRepository({required ReceivablesApiService apiService}) : _apiService = apiService;

  Future<PaginatedResult<Receivable>> listReceivables({
    int page = 1,
    int perPage = 25,
    String? customerId,
    String? status,
    String? receivableType,
    String? source,
    String? search,
    bool? overdue,
    String? sortBy,
    String? sortDir,
  }) => _apiService.listReceivables(
    page: page,
    perPage: perPage,
    customerId: customerId,
    status: status,
    receivableType: receivableType,
    source: source,
    search: search,
    overdue: overdue,
    sortBy: sortBy,
    sortDir: sortDir,
  );

  Future<Receivable> getReceivable(String id) => _apiService.getReceivable(id);

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
  }) => _apiService.createReceivable(
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

  Future<Receivable> updateReceivable(String id, Map<String, dynamic> data) => _apiService.updateReceivable(id, data);

  Future<void> deleteReceivable(String id) => _apiService.deleteReceivable(id);

  Future<ReceivablePayment> recordPayment({
    required String receivableId,
    required double amount,
    String? orderId,
    String? paymentMethod,
    String? notes,
  }) => _apiService.recordPayment(
    receivableId: receivableId,
    amount: amount,
    orderId: orderId,
    paymentMethod: paymentMethod,
    notes: notes,
  );

  Future<List<ReceivablePayment>> listPayments(String receivableId) => _apiService.listPayments(receivableId);

  Future<Receivable> addNote({required String receivableId, required String note}) =>
      _apiService.addNote(receivableId: receivableId, note: note);

  Future<List<ReceivableLog>> getLogs(String receivableId) => _apiService.getLogs(receivableId);

  Future<Receivable> reverseReceivable(String receivableId, {String? reason}) =>
      _apiService.reverseReceivable(receivableId, reason: reason);

  Future<double> getCustomerReceivableBalance(String customerId) => _apiService.getCustomerReceivableBalance(customerId);

  Future<List<Receivable>> getCustomerReceivables(String customerId) => _apiService.getCustomerReceivables(customerId);

  Future<ReceivableSummary> getSummary() => _apiService.getSummary();
}
