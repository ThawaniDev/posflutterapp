class InternalBarcodeSequence {

  const InternalBarcodeSequence({
    required this.id,
    required this.storeId,
    required this.lastSequence,
    this.updatedAt,
  });

  factory InternalBarcodeSequence.fromJson(Map<String, dynamic> json) {
    return InternalBarcodeSequence(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      lastSequence: (json['last_sequence'] as num).toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final int lastSequence;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'last_sequence': lastSequence,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  InternalBarcodeSequence copyWith({
    String? id,
    String? storeId,
    int? lastSequence,
    DateTime? updatedAt,
  }) {
    return InternalBarcodeSequence(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      lastSequence: lastSequence ?? this.lastSequence,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InternalBarcodeSequence && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'InternalBarcodeSequence(id: $id, storeId: $storeId, lastSequence: $lastSequence, updatedAt: $updatedAt)';
}
