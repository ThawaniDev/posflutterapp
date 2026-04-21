class ReceiptTemplate {

  const ReceiptTemplate({
    required this.id,
    required this.storeId,
    this.logoUrl,
    this.headerLine1,
    this.headerLine2,
    this.footerText,
    this.showVatNumber,
    this.showLoyaltyPoints,
    this.showBarcode,
    this.paperWidthMm,
    this.syncVersion,
    this.updatedAt,
  });

  factory ReceiptTemplate.fromJson(Map<String, dynamic> json) {
    return ReceiptTemplate(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      logoUrl: json['logo_url'] as String?,
      headerLine1: json['header_line_1'] as String?,
      headerLine2: json['header_line_2'] as String?,
      footerText: json['footer_text'] as String?,
      showVatNumber: json['show_vat_number'] as bool?,
      showLoyaltyPoints: json['show_loyalty_points'] as bool?,
      showBarcode: json['show_barcode'] as bool?,
      paperWidthMm: (json['paper_width_mm'] as num?)?.toInt(),
      syncVersion: (json['sync_version'] as num?)?.toInt(),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String? logoUrl;
  final String? headerLine1;
  final String? headerLine2;
  final String? footerText;
  final bool? showVatNumber;
  final bool? showLoyaltyPoints;
  final bool? showBarcode;
  final int? paperWidthMm;
  final int? syncVersion;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'logo_url': logoUrl,
      'header_line_1': headerLine1,
      'header_line_2': headerLine2,
      'footer_text': footerText,
      'show_vat_number': showVatNumber,
      'show_loyalty_points': showLoyaltyPoints,
      'show_barcode': showBarcode,
      'paper_width_mm': paperWidthMm,
      'sync_version': syncVersion,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ReceiptTemplate copyWith({
    String? id,
    String? storeId,
    String? logoUrl,
    String? headerLine1,
    String? headerLine2,
    String? footerText,
    bool? showVatNumber,
    bool? showLoyaltyPoints,
    bool? showBarcode,
    int? paperWidthMm,
    int? syncVersion,
    DateTime? updatedAt,
  }) {
    return ReceiptTemplate(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      logoUrl: logoUrl ?? this.logoUrl,
      headerLine1: headerLine1 ?? this.headerLine1,
      headerLine2: headerLine2 ?? this.headerLine2,
      footerText: footerText ?? this.footerText,
      showVatNumber: showVatNumber ?? this.showVatNumber,
      showLoyaltyPoints: showLoyaltyPoints ?? this.showLoyaltyPoints,
      showBarcode: showBarcode ?? this.showBarcode,
      paperWidthMm: paperWidthMm ?? this.paperWidthMm,
      syncVersion: syncVersion ?? this.syncVersion,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptTemplate && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ReceiptTemplate(id: $id, storeId: $storeId, logoUrl: $logoUrl, headerLine1: $headerLine1, headerLine2: $headerLine2, footerText: $footerText, ...)';
}
