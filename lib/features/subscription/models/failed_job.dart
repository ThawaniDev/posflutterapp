class FailedJob {
  final int id;
  final String uuid;
  final String connection;
  final String queue;
  final String payload;
  final String exception;
  final DateTime? failedAt;

  const FailedJob({
    required this.id,
    required this.uuid,
    required this.connection,
    required this.queue,
    required this.payload,
    required this.exception,
    this.failedAt,
  });

  factory FailedJob.fromJson(Map<String, dynamic> json) {
    return FailedJob(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      connection: json['connection'] as String,
      queue: json['queue'] as String,
      payload: json['payload'] as String,
      exception: json['exception'] as String,
      failedAt: json['failed_at'] != null ? DateTime.parse(json['failed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uuid': uuid,
      'connection': connection,
      'queue': queue,
      'payload': payload,
      'exception': exception,
      'failed_at': failedAt?.toIso8601String(),
    };
  }

  FailedJob copyWith({
    int? id,
    String? uuid,
    String? connection,
    String? queue,
    String? payload,
    String? exception,
    DateTime? failedAt,
  }) {
    return FailedJob(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      connection: connection ?? this.connection,
      queue: queue ?? this.queue,
      payload: payload ?? this.payload,
      exception: exception ?? this.exception,
      failedAt: failedAt ?? this.failedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailedJob && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FailedJob(id: $id, uuid: $uuid, connection: $connection, queue: $queue, payload: $payload, exception: $exception, ...)';
}
