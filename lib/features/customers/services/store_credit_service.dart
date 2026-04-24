import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/models/store_credit_transaction.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

class StoreCreditService {
  StoreCreditService(this._repo);
  final CustomerRepository _repo;

  Future<List<StoreCreditTransaction>> log(String customerId) => _repo.getStoreCreditLog(customerId);

  Future<StoreCreditTransaction> topUp(String customerId, {required double amount, String? notes}) =>
      _repo.topUpCredit(customerId, amount: amount, notes: notes);

  /// Positive or negative ManualAdjustment — server rejects if balance would
  /// go below zero.
  Future<StoreCreditTransaction> adjust(String customerId, {required double amount, String? notes}) =>
      _repo.adjustCredit(customerId, amount: amount, notes: notes);
}

final storeCreditServiceProvider = Provider<StoreCreditService>((ref) {
  return StoreCreditService(ref.watch(customerRepositoryProvider));
});
