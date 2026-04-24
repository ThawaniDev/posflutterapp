import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wameedpos/features/customers/data/local/daos/customer_dao.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

/// Pulls customer deltas from the cloud and merges them into the Drift cache.
///
/// Usage:
/// - Call [syncOnce] after login or whenever the app comes online.
/// - Pass `force: true` to ignore the persisted cursor and pull everything.
/// - Returns the number of customers merged in this run.
class CustomerSyncService {
  CustomerSyncService({
    required CustomerRepository remote,
    required CustomerDao dao,
    required Future<SharedPreferences> Function() prefsFactory,
  }) : _remote = remote,
       _dao = dao,
       _prefsFactory = prefsFactory;

  final CustomerRepository _remote;
  final CustomerDao _dao;
  final Future<SharedPreferences> Function() _prefsFactory;

  static const _kLastSyncKey = 'customers.last_sync';
  static const int _batchLimit = 500;

  Future<int> syncOnce({bool force = false, int maxBatches = 10}) async {
    final prefs = await _prefsFactory();
    String? cursor = force ? null : prefs.getString(_kLastSyncKey);

    int merged = 0;
    String? newCursor;
    for (var i = 0; i < maxBatches; i++) {
      final res = await _remote.syncDelta(since: cursor, limit: _batchLimit);
      if (res.data.isEmpty) {
        newCursor = res.serverTime.isNotEmpty ? res.serverTime : cursor;
        break;
      }
      // Merge deletions vs upserts.
      final upserts = res.data.where((c) => c.deletedAt == null).toList();
      final deletes = res.data.where((c) => c.deletedAt != null).toList();
      if (upserts.isNotEmpty) await _dao.upsertCustomers(upserts);
      // For deletes, mark them deleted in the local cache so listCustomers
      // (which filters deletedAt.isNull()) hides them.
      for (final d in deletes) {
        await _dao.markDeleted(d.id);
      }

      merged += res.data.length;
      newCursor = res.serverTime.isNotEmpty ? res.serverTime : newCursor;
      cursor = newCursor;
      if (res.data.length < _batchLimit) break; // last batch
    }

    if (newCursor != null && newCursor.isNotEmpty) {
      await prefs.setString(_kLastSyncKey, newCursor);
    }
    return merged;
  }

  Future<DateTime?> lastSync() async {
    final prefs = await _prefsFactory();
    final value = prefs.getString(_kLastSyncKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }

  Future<void> resetCursor() async {
    final prefs = await _prefsFactory();
    await prefs.remove(_kLastSyncKey);
  }

  /// Returns a cached customer first, or pulls from the server if missing.
  Future<Customer?> getOrFetch(String id) async {
    final cached = await _dao.getById(id);
    if (cached != null) return cached;
    try {
      final remote = await _remote.getCustomer(id);
      await _dao.upsertCustomers([remote]);
      return remote;
    } catch (_) {
      return null;
    }
  }
}

final customerSyncServiceProvider = Provider<CustomerSyncService>((ref) {
  return CustomerSyncService(
    remote: ref.watch(customerRepositoryProvider),
    dao: ref.watch(customerDaoProvider),
    prefsFactory: SharedPreferences.getInstance,
  );
});
