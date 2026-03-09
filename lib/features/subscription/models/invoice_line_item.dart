class InvoiceLineItem {
  final String id;
  final String invoiceId;
  final String description;
  final int? quantity;
  final double unitPrice;
  final double total;

  const InvoiceLineItem({
    required this.id,
    required this.invoiceId,
    required this.description,
    this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) {
    return InvoiceLineItem(
      id: json['id'] as String,
      invoiceId: json['invoice_id'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num?)?.toInt(),
      unitPrice: (json['unit_price'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'invoice_id': invoiceId,
      'description': description,
      'quantity': quantity,
      'unit_price': unitPrice,
      'total': total,
    };
  }

  InvoiceLineItem copyWith({
    String? id,
    String? invoiceId,
    String? description,
    int? quantity,
    double? unitPrice,
    double? total,
  }) {
    return InvoiceLineItem(
      id: id ?? this.id,
      invoiceId: invoiceId ?? this.invoiceId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      total: total ?? this.total,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceLineItem && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'InvoiceLineItem(id: $id, invoiceId: $invoiceId, description: $description, quantity: $quantity, unitPrice: $unitPrice, total: $total)';
}
