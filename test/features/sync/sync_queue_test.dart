import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/sync/services/sync_queue_manager.dart';

void main() {
  late Directory tempDir;
  late SyncQueueManager manager;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('sync_queue_test_');
    manager = SyncQueueManager(storagePath: tempDir.path);
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  // ═══════════════════════════════════════════════════════════
  // QueuedOperation Model
  // ═══════════════════════════════════════════════════════════

  group('QueuedOperation', () {
    test('fromJson / toJson round-trips correctly', () {
      final now = DateTime.utc(2025, 1, 15, 10, 30);
      final op = QueuedOperation(
        id: 'op-1',
        table: 'products',
        type: QueueOperationType.create,
        data: {'name': 'Test Product', 'price': 25.50},
        createdAt: now,
      );
      final json = op.toJson();
      final restored = QueuedOperation.fromJson(json);

      expect(restored.id, 'op-1');
      expect(restored.table, 'products');
      expect(restored.type, QueueOperationType.create);
      expect(restored.data['name'], 'Test Product');
      expect(restored.data['price'], 25.50);
      expect(restored.createdAt, now);
      expect(restored.retryCount, 0);
      expect(restored.lastError, isNull);
    });

    test('fromJson handles retry count and error', () {
      final json = {
        'id': 'op-2',
        'table': 'orders',
        'type': 'update',
        'data': {'status': 'completed'},
        'created_at': '2025-01-15T10:30:00.000Z',
        'retry_count': 3,
        'last_error': 'Network timeout',
      };
      final op = QueuedOperation.fromJson(json);

      expect(op.retryCount, 3);
      expect(op.lastError, 'Network timeout');
    });

    test('copyWith replaces fields', () {
      final op = QueuedOperation(
        id: 'op-1',
        table: 'products',
        type: QueueOperationType.create,
        data: {'name': 'Test'},
        createdAt: DateTime.utc(2025, 1, 15),
      );
      final updated = op.copyWith(retryCount: 2, lastError: 'Fail');

      expect(updated.id, 'op-1');
      expect(updated.retryCount, 2);
      expect(updated.lastError, 'Fail');
    });

    test('type serializes as enum name', () {
      final op = QueuedOperation(
        id: 'op-1',
        table: 'products',
        type: QueueOperationType.delete,
        data: {},
        createdAt: DateTime.utc(2025, 1, 15),
      );
      expect(op.toJson()['type'], 'delete');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // QueueOperationType
  // ═══════════════════════════════════════════════════════════

  group('QueueOperationType', () {
    test('has 3 values', () {
      expect(QueueOperationType.values, hasLength(3));
    });

    test('has create, update, delete', () {
      expect(
        QueueOperationType.values,
        containsAll([QueueOperationType.create, QueueOperationType.update, QueueOperationType.delete]),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SyncQueueManager
  // ═══════════════════════════════════════════════════════════

  group('SyncQueueManager', () {
    QueuedOperation makeOp(String id) => QueuedOperation(
      id: id,
      table: 'products',
      type: QueueOperationType.create,
      data: {'name': 'Product $id'},
      createdAt: DateTime.utc(2025, 1, 15),
    );

    test('starts empty before load', () async {
      await manager.load();
      expect(manager.pendingCount, 0);
      expect(manager.isEmpty, true);
      expect(manager.pending, isEmpty);
    });

    test('enqueue adds operations', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));

      expect(manager.pendingCount, 2);
      expect(manager.isEmpty, false);
      expect(manager.pending[0].id, '1');
      expect(manager.pending[1].id, '2');
    });

    test('dequeue removes specific operation', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));
      await manager.enqueue(makeOp('3'));

      await manager.dequeue('2');

      expect(manager.pendingCount, 2);
      expect(manager.pending.map((o) => o.id), ['1', '3']);
    });

    test('dequeueProcessed removes first N operations', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));
      await manager.enqueue(makeOp('3'));

      await manager.dequeueProcessed(2);

      expect(manager.pendingCount, 1);
      expect(manager.pending[0].id, '3');
    });

    test('dequeueProcessed clears all when count >= length', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));

      await manager.dequeueProcessed(10);

      expect(manager.isEmpty, true);
    });

    test('markFailed increments retry count and sets error', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));

      await manager.markFailed('1', 'Server error');
      expect(manager.pending[0].retryCount, 1);
      expect(manager.pending[0].lastError, 'Server error');

      await manager.markFailed('1', 'Timeout');
      expect(manager.pending[0].retryCount, 2);
      expect(manager.pending[0].lastError, 'Timeout');
    });

    test('markFailed is no-op for unknown ID', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));

      await manager.markFailed('unknown', 'Error');
      expect(manager.pending[0].retryCount, 0);
    });

    test('clear removes all operations', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));

      await manager.clear();
      expect(manager.isEmpty, true);
    });

    test('persists across instances', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.enqueue(makeOp('2'));

      // Create a new manager with the same path
      final manager2 = SyncQueueManager(storagePath: tempDir.path);
      await manager2.load();

      expect(manager2.pendingCount, 2);
      expect(manager2.pending[0].id, '1');
      expect(manager2.pending[1].id, '2');
    });

    test('handles empty file on disk', () async {
      // Create an empty file
      final file = File('${tempDir.path}/sync_queue.jsonl');
      await file.create(recursive: true);
      await file.writeAsString('');

      await manager.load();
      expect(manager.isEmpty, true);
    });

    test('skips malformed JSON lines gracefully', () async {
      final file = File('${tempDir.path}/sync_queue.jsonl');
      await file.create(recursive: true);
      final validOp = QueuedOperation(
        id: 'valid',
        table: 'products',
        type: QueueOperationType.create,
        data: {'name': 'x'},
        createdAt: DateTime.utc(2025, 1, 15),
      );
      // Write one valid + one invalid line
      await file.writeAsString('${_toJsonString(validOp)}\n{invalid json}\n');

      await manager.load();
      expect(manager.pendingCount, 1);
      expect(manager.pending[0].id, 'valid');
    });

    test('pending returns unmodifiable list', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));

      expect(() => manager.pending.add(makeOp('2')), throwsUnsupportedError);
    });

    test('load is idempotent', () async {
      await manager.load();
      await manager.enqueue(makeOp('1'));
      await manager.load(); // Should not re-read

      expect(manager.pendingCount, 1);
    });
  });
}

String _toJsonString(QueuedOperation op) {
  // Import not needed — use manual construction to avoid dart:convert import issues
  final data = op.toJson();
  // Simple workaround: use the same approach the manager uses
  return '{"id":"${data['id']}","table":"${data['table']}","type":"${data['type']}","data":{"name":"${(data['data'] as Map)['name']}"},"created_at":"${data['created_at']}","retry_count":${data['retry_count']},"last_error":null}';
}
