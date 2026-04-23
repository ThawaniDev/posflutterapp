import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';

/// Drains [PosOfflineDatabase.localSyncQueue] when the device has internet.
/// Talks to the backend `POST /api/v2/pos/transactions/batch` and
/// `POST /api/v2/pos/inventory/adjustments` for idempotent replay.
class PosOfflineSyncService {
  PosOfflineSyncService({required this.db, required this.api, required this.connectivity}) {
    _connectivitySubscription = connectivity.onConnectivityChanged.listen(_handleConnectivity);
  }

  final PosOfflineDatabase db;
  final PosTerminalApiService api;
  final Connectivity connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isDraining = false;
  Timer? _retryTimer;

  static const int _maxAttempts = 8;

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    _retryTimer?.cancel();
  }

  void _handleConnectivity(List<ConnectivityResult> results) {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (online) {
      // Fire-and-forget; errors are logged inside the drain loop.
      unawaited(drain());
    }
  }

  /// Schedule a periodic drain in addition to the connectivity listener so
  /// transient backend errors get retried.
  void startPeriodicDrain({Duration interval = const Duration(minutes: 1)}) {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(interval, (_) => drain());
  }

  Future<void> drain() async {
    if (_isDraining) return;
    _isDraining = true;
    try {
      while (true) {
        final entries = await db.dueQueueEntries(limit: 50);
        if (entries.isEmpty) break;

        final transactionEntries = entries.where((e) => e.kind == 'transaction').toList();
        final adjustmentEntries = entries.where((e) => e.kind == 'inventory_adjustment').toList();
        final customerEntries = entries.where((e) => e.kind == 'customer').toList();

        if (transactionEntries.isNotEmpty) {
          await _flushBatch(
            entries: transactionEntries,
            send: (payloads) => api.batchTransactions({'register_id': payloads.first['register_id'], 'transactions': payloads}),
            extractResults: (response) => (response['results'] as List).cast<Map<String, dynamic>>(),
          );
        }
        if (adjustmentEntries.isNotEmpty) {
          await _flushBatch(
            entries: adjustmentEntries,
            send: (payloads) => api.applyInventoryAdjustments({'adjustments': payloads}),
            extractResults: (response) => (response['results'] as List).cast<Map<String, dynamic>>(),
          );
        }
        for (final entry in customerEntries) {
          await _flushSingle(entry, () async {
            final payload = jsonDecode(entry.payloadJson) as Map<String, dynamic>;
            await api.quickAddCustomer(payload);
          });
        }
      }
    } finally {
      _isDraining = false;
    }
  }

  Future<void> _flushBatch({
    required List<LocalSyncQueueData> entries,
    required Future<Map<String, dynamic>> Function(List<Map<String, dynamic>> payloads) send,
    required List<Map<String, dynamic>> Function(Map<String, dynamic> response) extractResults,
  }) async {
    // Mark in-progress so concurrent drains don't double-send.
    await db.batch((b) {
      for (final entry in entries) {
        b.update(
          db.localSyncQueue,
          LocalSyncQueueCompanion(status: const Value('in_progress')),
          where: (t) => t.id.equals(entry.id),
        );
      }
    });

    final payloads = entries.map((e) => jsonDecode(e.payloadJson) as Map<String, dynamic>).toList();
    try {
      final response = await send(payloads);
      final results = extractResults(response);
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final result = i < results.length ? results[i] : null;
        final status = result?['status'] as String? ?? 'failed';
        if (status == 'created' || status == 'duplicate') {
          await db.markEntryStatus(entry.id, 'done');
          final serverId = result?['transaction_id'] as String?;
          if (serverId != null) {
            await db.markTransactionSynced(entry.clientUuid, serverId);
          }
        } else {
          await _scheduleRetry(entry, result?['error']?.toString() ?? 'unknown');
        }
      }
    } on DioException catch (e) {
      for (final entry in entries) {
        await _scheduleRetry(entry, e.message ?? e.toString());
      }
    } catch (e) {
      for (final entry in entries) {
        await _scheduleRetry(entry, e.toString());
      }
    }
  }

  Future<void> _flushSingle(LocalSyncQueueData entry, Future<void> Function() task) async {
    await db.markEntryStatus(entry.id, 'in_progress');
    try {
      await task();
      await db.markEntryStatus(entry.id, 'done');
    } catch (e) {
      await _scheduleRetry(entry, e.toString());
    }
  }

  Future<void> _scheduleRetry(LocalSyncQueueData entry, String error) async {
    final attempts = entry.attempts + 1;
    if (attempts >= _maxAttempts) {
      await db.markEntryStatus(entry.id, 'failed', error: error);
      return;
    }
    await db.incrementAttempts(entry.id);
    final backoffSeconds = math.min(60 * 60, math.pow(2, attempts).toInt() * 5);
    await db.markEntryStatus(
      entry.id,
      'pending',
      error: error,
      nextAttemptAt: DateTime.now().add(Duration(seconds: backoffSeconds)),
    );
  }
}

final posOfflineSyncServiceProvider = Provider<PosOfflineSyncService>((ref) {
  final svc = PosOfflineSyncService(
    db: ref.watch(posOfflineDatabaseProvider),
    api: ref.watch(posTerminalApiServiceProvider),
    connectivity: Connectivity(),
  );
  ref.onDispose(svc.dispose);
  return svc;
});
