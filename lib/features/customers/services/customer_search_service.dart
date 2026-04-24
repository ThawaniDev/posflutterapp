import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/customers/data/local/daos/customer_dao.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

/// Hybrid lookup: local DAO first, then a remote `searchCustomers` call to
/// catch records that weren't synced yet. Results are deduplicated by id.
class CustomerSearchService {
  CustomerSearchService({
    required CustomerRepository remote,
    required CustomerDao dao,
  })  : _remote = remote,
        _dao = dao;

  final CustomerRepository _remote;
  final CustomerDao _dao;

  Future<List<Customer>> search(String organizationId, String query, {int limit = 20}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final local = await _dao.listCustomers(organizationId, search: q, limit: limit);
    final seen = <String>{for (final c in local) c.id};
    try {
      final remote = await _remote.searchCustomers(q, limit: limit);
      // Cache anything new for offline.
      final fresh = remote.where((c) => !seen.contains(c.id)).toList();
      if (fresh.isNotEmpty) {
        await _dao.upsertCustomers(fresh);
      }
      for (final c in fresh) {
        local.add(c);
        seen.add(c.id);
      }
    } catch (_) {
      // Offline → fall back to local results only.
    }
    return local.take(limit).toList();
  }

  Future<Customer?> findByPhone(String organizationId, String phone) async {
    return _dao.getByPhone(organizationId, phone);
  }

  Future<Customer?> findByLoyaltyCode(String organizationId, String code) async {
    return _dao.getByLoyaltyCode(organizationId, code);
  }
}

final customerSearchServiceProvider = Provider<CustomerSearchService>((ref) {
  return CustomerSearchService(
    remote: ref.watch(customerRepositoryProvider),
    dao: ref.watch(customerDaoProvider),
  );
});
