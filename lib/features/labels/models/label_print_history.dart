class LabelPrintHistory {

  const LabelPrintHistory({
    required this.id,
    required this.storeId,
    this.templateId,
    this.templateName,
    required this.printedBy,
    this.printedByName,
    required this.productCount,
    required this.totalLabels,
    this.printerName,
    this.printedAt,
  });

  factory LabelPrintHistory.fromJson(Map<String, dynamic> json) {
    return LabelPrintHistory(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      templateId: json['template_id'] as String?,
      templateName: json['template_name'] as String?,
      printedBy: json['printed_by'] as String,
      printedByName: json['printed_by_name'] as String?,
      productCount: (json['product_count'] as num).toInt(),
      totalLabels: (json['total_labels'] as num).toInt(),
      printerName: json['printer_name'] as String?,
      printedAt: json['printed_at'] != null ? DateTime.parse(json['printed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? templateId;
  final String? templateName;
  final String printedBy;
  final String? printedByName;
  final int productCount;
  final int totalLabels;
  final String? printerName;
  final DateTime? printedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'template_id': templateId,
      'template_name': templateName,
      'printed_by': printedBy,
      'printed_by_name': printedByName,
      'product_count': productCount,
      'total_labels': totalLabels,
      'printer_name': printerName,
      'printed_at': printedAt?.toIso8601String(),
    };
  }

  LabelPrintHistory copyWith({
    String? id,
    String? storeId,
    String? templateId,
    String? templateName,
    String? printedBy,
    String? printedByName,
    int? productCount,
    int? totalLabels,
    String? printerName,
    DateTime? printedAt,
  }) {
    return LabelPrintHistory(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      templateId: templateId ?? this.templateId,
      templateName: templateName ?? this.templateName,
      printedBy: printedBy ?? this.printedBy,
      printedByName: printedByName ?? this.printedByName,
      productCount: productCount ?? this.productCount,
      totalLabels: totalLabels ?? this.totalLabels,
      printerName: printerName ?? this.printerName,
      printedAt: printedAt ?? this.printedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LabelPrintHistory && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LabelPrintHistory(id: $id, storeId: $storeId, templateId: $templateId, printedBy: $printedBy, productCount: $productCount, totalLabels: $totalLabels, ...)';
}
