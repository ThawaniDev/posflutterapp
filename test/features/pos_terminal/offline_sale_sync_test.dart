import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_database.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_sync_service.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';
import 'package:wameedpos/features/pos_terminal/models/cart_item.dart';
import 'package:wameedpos/features/pos_terminal/models/pos_session.dart';
import 'package:wameedpos/features/pos_terminal/models/transaction.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:wameedpos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

// ─── Fakes ────────────────────────────────────────────────────────────────

/// Backend batch endpoint that confirms every transaction as `created` and
/// returns the full transaction object (with nested `id`) — exactly the shape
/// the real `POST /pos/transactions/batch` produces.
class _BatchOkApi extends PosTerminalApiService {
  _BatchOkApi() : super(Dio());

  Map<String, dynamic>? lastBatchPayload;

  @override
  Future<Map<String, dynamic>> batchTransactions(Map<String, dynamic> payload) async {
    lastBatchPayload = payload;
    final txns = (payload['transactions'] as List).cast<Map<String, dynamic>>();
    return {
      'results': txns
          .map(
            (t) => {
              'client_uuid': t['client_uuid'],
              'status': 'created',
              'transaction': {'id': 'srv-${t['client_uuid']}'},
            },
          )
          .toList(),
    };
  }
}

/// Repository whose `createTransaction` always fails with the supplied error,
/// used to drive the [SaleNotifier] offline / hard-error branches.
class _FailingRepo extends PosTerminalRepository {
  _FailingRepo(this._error) : super(apiService: PosTerminalApiService(Dio()));
  final Object _error;

  @override
  Future<Transaction> createTransaction(Map<String, dynamic> data) async => throw _error;
}

/// Active-session notifier pre-seeded into a loaded state.
class _SeededActiveSession extends ActiveSessionNotifier {
  _SeededActiveSession(super.repo, PosSession session) {
    state = ActiveSessionLoaded(session: session);
  }
}

/// Sync service whose drain is a no-op so the fire-and-forget kick from
/// `completeSale` cannot race the test assertions.
class _NoopSync extends PosOfflineSyncService {
  _NoopSync(PosOfflineDatabase db) : super.forTesting(db: db, api: PosTerminalApiService(Dio()), connectivity: Connectivity());

  @override
  Future<void> drain() async {}
}

DioException _networkError() => DioException(
  requestOptions: RequestOptions(path: '/pos/transactions'),
  type: DioExceptionType.connectionError,
);

DioException _serverRejection() => DioException(
  requestOptions: RequestOptions(path: '/pos/transactions'),
  type: DioExceptionType.badResponse,
  response: Response(
    requestOptions: RequestOptions(path: '/pos/transactions'),
    statusCode: 422,
    data: {'message': 'Insufficient stock'},
  ),
);

PosSession _session() => PosSession.fromJson({
  'id': 'sess-1',
  'store_id': 'store-1',
  'register_id': 'reg-12345',
  'cashier_id': 'cash-1',
  'status': 'open',
  'opening_cash': 100,
});

CartState _cart() {
  final product = Product.fromJson({
    'id': 'prod-1',
    'organization_id': 'org-1',
    'name': 'Coffee',
    'sell_price': 50,
    'tax_rate': 15,
  });
  return CartState(items: [CartItem(product: product, quantity: 2, unitPrice: 50)]);
}

const _payments = [
  {'method': 'cash', 'amount': 115.0, 'cash_tendered': 120.0, 'change_given': 5.0},
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Offline drain round-trip', () {
    late PosOfflineDatabase db;

    setUp(() => db = PosOfflineDatabase.forTesting(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('drains a queued transaction and records the server id', () async {
      // Seed a local mirror + queue entry as completeSale would when offline.
      await db.saveTransaction(
        LocalTransactionsCompanion.insert(
          clientUuid: 'cu-1',
          transactionNumber: 'OFF-REG1-1',
          type: 'sale',
          status: 'completed',
          storeId: 'store-1',
          cashierId: 'cash-1',
          subtotal: 100,
          totalAmount: 115,
          itemsJson: '[]',
          paymentsJson: '[]',
          createdAt: DateTime.now(),
        ),
      );
      await db.enqueue(
        LocalSyncQueueCompanion.insert(
          clientUuid: 'cu-1',
          kind: 'transaction',
          payloadJson: jsonEncode({
            'register_id': 'reg-12345',
            'client_uuid': 'cu-1',
            'transaction_number': 'OFF-REG1-1',
            'type': 'sale',
            'items': [
              {'product_name': 'Coffee', 'quantity': 2, 'unit_price': 50},
            ],
          }),
          createdAt: DateTime.now(),
          nextAttemptAt: DateTime.now(),
        ),
      );

      final api = _BatchOkApi();
      final svc = PosOfflineSyncService.forTesting(db: db, api: api, connectivity: Connectivity());

      await svc.drain();

      // Queue fully drained …
      expect(await db.dueQueueEntries(), isEmpty);
      // … the batch carried the register id …
      expect(api.lastBatchPayload?['register_id'], 'reg-12345');
      // … and the server id was written back (regression guard for the
      // `result['transaction']['id']` extraction bug).
      expect(await db.transactionsAwaitingSync(), isEmpty);
    });
  });

  group('SaleNotifier offline fallback', () {
    late PosOfflineDatabase db;

    ProviderContainer makeContainer(Object error, {PosSession? session}) {
      final repo = _FailingRepo(error);
      return ProviderContainer(
        overrides: [
          posOfflineDatabaseProvider.overrideWithValue(db),
          posTerminalRepositoryProvider.overrideWithValue(repo),
          posOfflineSyncServiceProvider.overrideWithValue(_NoopSync(db)),
          if (session != null) activeSessionProvider.overrideWith((ref) => _SeededActiveSession(repo, session)),
        ],
      );
    }

    setUp(() => db = PosOfflineDatabase.forTesting(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('network failure queues the sale and reports it as offline', () async {
      final container = makeContainer(_networkError(), session: _session());
      addTearDown(container.dispose);

      final ok = await container
          .read(saleProvider.notifier)
          .completeSale(sessionId: 'sess-1', cart: _cart(), payments: List<Map<String, dynamic>>.from(_payments));

      expect(ok, isTrue);
      final state = container.read(saleProvider);
      expect(state, isA<SaleCompleted>());
      expect((state as SaleCompleted).isOffline, isTrue);
      expect(state.changeGiven, 5.0);

      // Queued for replay …
      final due = await db.dueQueueEntries();
      expect(due, hasLength(1));
      expect(due.first.kind, 'transaction');
      // … and mirrored to the local transactions table for offline history.
      expect(await db.transactionsAwaitingSync(), hasLength(1));
    });

    test('queued payload carries idempotency + batch fields', () async {
      final container = makeContainer(_networkError(), session: _session());
      addTearDown(container.dispose);

      await container
          .read(saleProvider.notifier)
          .completeSale(sessionId: 'sess-1', cart: _cart(), payments: List<Map<String, dynamic>>.from(_payments));

      final entry = (await db.dueQueueEntries()).single;
      final payload = jsonDecode(entry.payloadJson) as Map<String, dynamic>;
      expect(payload['client_uuid'], isNotEmpty);
      expect(payload['register_id'], 'reg-12345');
      expect(payload['transaction_number'], startsWith('OFF-'));
      expect(payload['type'], 'sale');
      expect((payload['items'] as List), isNotEmpty);
      // client_uuid must match the queue row so the drainer can reconcile it.
      expect(payload['client_uuid'], entry.clientUuid);
    });

    test('server rejection surfaces an error and does NOT queue', () async {
      final container = makeContainer(_serverRejection(), session: _session());
      addTearDown(container.dispose);

      final ok = await container
          .read(saleProvider.notifier)
          .completeSale(sessionId: 'sess-1', cart: _cart(), payments: List<Map<String, dynamic>>.from(_payments));

      expect(ok, isFalse);
      expect(container.read(saleProvider), isA<SaleError>());
      expect(await db.dueQueueEntries(), isEmpty);
      expect(await db.transactionsAwaitingSync(), isEmpty);
    });
  });
}
