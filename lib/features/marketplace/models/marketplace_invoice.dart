class MarketplaceInvoice {
  final String id;
  final String purchaseId;
  final String organizationId;
  final String? listingName;
  final double amount;
  final String currency;
  final String status;
  final String? paymentMethod;
  final DateTime? paidAt;
  final DateTime? createdAt;

  const MarketplaceInvoice({
    required this.id,
    required this.purchaseId,
    required this.organizationId,
    this.listingName,
    required this.amount,
    this.currency = 'SAR',
    required this.status,
    this.paymentMethod,
    this.paidAt,
    this.createdAt,
  });

  factory MarketplaceInvoice.fromJson(Map<String, dynamic> json) {
    return MarketplaceInvoice(
      id: json['id'] as String,
      purchaseId: json['purchase_id'] as String,
      organizationId: json['organization_id'] as String,
      listingName: json['listing_name'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'SAR',
      status: json['status'] as String,
      paymentMethod: json['payment_method'] as String?,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchase_id': purchaseId,
      'organization_id': organizationId,
      'listing_name': listingName,
      'amount': amount,
      'currency': currency,
      'status': status,
      'payment_method': paymentMethod,
      'paid_at': paidAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is MarketplaceInvoice && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
