import 'dart:convert';
import 'dart:io';

/// Manages a persistent queue of operations made while offline.
/// Operations are stored as JSON lines in a local file and replayed when online.
class SyncQueueManager {
  SyncQueueManager({required this.storagePath});

  final String storagePath;
  final List<QueuedOperation> _queue = [];
  bool _loaded = false;

  String get _filePath => '$storagePath/sync_queue.jsonl';

  /// Load queued operations from disk.
  Future<void> load() async {
    if (_loaded) return;
    _queue.clear();
    final file = File(_filePath);
    if (await file.exists()) {
      final lines = await file.readAsLines();
      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          _queue.add(QueuedOperation.fromJson(json.decode(line) as Map<String, dynamic>));
        } catch (_) {
          // Skip malformed entries
        }
      }
    }
    _loaded = true;
  }

  /// Enqueue an operation for later replay.
  Future<void> enqueue(QueuedOperation operation) async {
    _queue.add(operation);
    await _persist();
  }

  /// Get all pending operations in order.
  List<QueuedOperation> get pending => List.unmodifiable(_queue);

  /// Number of pending operations.
  int get pendingCount => _queue.length;

  /// Whether the queue is empty.
  bool get isEmpty => _queue.isEmpty;

  /// Remove a single operation after successful replay.
  Future<void> dequeue(String operationId) async {
    _queue.removeWhere((op) => op.id == operationId);
    await _persist();
  }

  /// Remove all successfully replayed operations up to index.
  Future<void> dequeueProcessed(int count) async {
    if (count >= _queue.length) {
      _queue.clear();
    } else {
      _queue.removeRange(0, count);
    }
    await _persist();
  }

  /// Mark an operation as failed (increment retry count, update error).
  Future<void> markFailed(String operationId, String error) async {
    final idx = _queue.indexWhere((op) => op.id == operationId);
    if (idx >= 0) {
      _queue[idx] = _queue[idx].copyWith(retryCount: _queue[idx].retryCount + 1, lastError: error);
      await _persist();
    }
  }

  /// Clear the entire queue.
  Future<void> clear() async {
    _queue.clear();
    await _persist();
  }

  /// Write current queue to disk.
  Future<void> _persist() async {
    final file = File(_filePath);
    await file.parent.create(recursive: true);
    final buffer = StringBuffer();
    for (final op in _queue) {
      buffer.writeln(json.encode(op.toJson()));
    }
    await file.writeAsString(buffer.toString());
  }
}

class QueuedOperation {
  final String id;
  final String table;
  final QueueOperationType type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  const QueuedOperation({
    required this.id,
    required this.table,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
  });

  factory QueuedOperation.fromJson(Map<String, dynamic> json) {
    return QueuedOperation(
      id: json['id'] as String,
      table: json['table'] as String,
      type: QueueOperationType.values.firstWhere((e) => e.name == json['type']),
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['created_at'] as String),
      retryCount: json['retry_count'] as int? ?? 0,
      lastError: json['last_error'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'table': table,
    'type': type.name,
    'data': data,
    'created_at': createdAt.toIso8601String(),
    'retry_count': retryCount,
    'last_error': lastError,
  };

  QueuedOperation copyWith({
    String? id,
    String? table,
    QueueOperationType? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    String? lastError,
  }) {
    return QueuedOperation(
      id: id ?? this.id,
      table: table ?? this.table,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }
}

enum QueueOperationType { create, update, delete }
