class TemplatePurchase {
  final String id;
  final String organizationId;
  final String listingId;
  final String? listingName;
  final String purchaseType;
  final double amountPaid;
  final String? subscriptionInterval;
  final DateTime? expiresAt;
  final bool isActive;
  final DateTime? cancelledAt;
  final DateTime? createdAt;

  const TemplatePurchase({
    required this.id,
    required this.organizationId,
    required this.listingId,
    this.listingName,
    required this.purchaseType,
    required this.amountPaid,
    this.subscriptionInterval,
    this.expiresAt,
    this.isActive = true,
    this.cancelledAt,
    this.createdAt,
  });

  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  factory TemplatePurchase.fromJson(Map<String, dynamic> json) {
    return TemplatePurchase(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      listingId: json['listing_id'] as String,
      listingName: json['listing_name'] as String?,
      purchaseType: json['purchase_type'] as String,
      amountPaid: (json['amount_paid'] as num).toDouble(),
      subscriptionInterval: json['subscription_interval'] as String?,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      isActive: json['is_active'] as bool? ?? true,
      cancelledAt: json['cancelled_at'] != null ? DateTime.parse(json['cancelled_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'listing_id': listingId,
      'listing_name': listingName,
      'purchase_type': purchaseType,
      'amount_paid': amountPaid,
      'subscription_interval': subscriptionInterval,
      'expires_at': expiresAt?.toIso8601String(),
      'is_active': isActive,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is TemplatePurchase && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
