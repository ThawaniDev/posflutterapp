import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/debits/data/remote/debits_api_service.dart';
import 'package:wameedpos/features/debits/models/debit.dart';

final debitRepositoryProvider = Provider<DebitRepository>((ref) {
  return DebitRepository(apiService: ref.watch(debitsApiServiceProvider));
});

class DebitRepository {

  DebitRepository({required DebitsApiService apiService}) : _apiService = apiService;
  final DebitsApiService _apiService;

  // List
  Future<PaginatedResult<Debit>> listDebits({
    int page = 1,
    int perPage = 25,
    String? customerId,
    String? status,
    String? debitType,
    String? source,
    String? search,
    String? sortBy,
    String? sortDir,
  }) => _apiService.listDebits(
    page: page,
    perPage: perPage,
    customerId: customerId,
    status: status,
    debitType: debitType,
    source: source,
    search: search,
    sortBy: sortBy,
    sortDir: sortDir,
  );

  // Get
  Future<Debit> getDebit(String id) => _apiService.getDebit(id);

  // Create
  Future<Debit> createDebit({
    required String customerId,
    required String debitType,
    required String source,
    required double amount,
    String? description,
    String? descriptionAr,
    String? notes,
    String? referenceNumber,
  }) => _apiService.createDebit(
    customerId: customerId,
    debitType: debitType,
    source: source,
    amount: amount,
    description: description,
    descriptionAr: descriptionAr,
    notes: notes,
    referenceNumber: referenceNumber,
  );

  // Update
  Future<Debit> updateDebit(String id, Map<String, dynamic> data) => _apiService.updateDebit(id, data);

  // Delete
  Future<void> deleteDebit(String id) => _apiService.deleteDebit(id);

  // Allocate
  Future<DebitAllocation> allocateDebit({
    required String debitId,
    required String orderId,
    required double amount,
    String? notes,
  }) => _apiService.allocateDebit(debitId: debitId, orderId: orderId, amount: amount, notes: notes);

  // Allocations
  Future<List<DebitAllocation>> listAllocations(String debitId) => _apiService.listAllocations(debitId);

  // Reverse
  Future<Debit> reverseDebit(String debitId, {String? reason}) => _apiService.reverseDebit(debitId, reason: reason);

  // Customer balance
  Future<double> getCustomerDebitBalance(String customerId) => _apiService.getCustomerDebitBalance(customerId);

  // Customer debits
  Future<List<Debit>> getCustomerDebits(String customerId) => _apiService.getCustomerDebits(customerId);

  // Summary
  Future<DebitSummary> getSummary() => _apiService.getSummary();
}
