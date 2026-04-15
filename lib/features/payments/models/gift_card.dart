import 'package:wameedpos/features/payments/enums/gift_card_status.dart';

class GiftCard {
  final String id;
  final String organizationId;
  final String code;
  final String? barcode;
  final double initialAmount;
  final double balance;
  final String? recipientName;
  final GiftCardStatus? status;
  final String issuedBy;
  final String issuedAtStore;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  const GiftCard({
    required this.id,
    required this.organizationId,
    required this.code,
    this.barcode,
    required this.initialAmount,
    required this.balance,
    this.recipientName,
    this.status,
    required this.issuedBy,
    required this.issuedAtStore,
    this.expiresAt,
    this.createdAt,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      id: json['id'] as String,
      organizationId: json['organization_id'] as String,
      code: json['code'] as String,
      barcode: json['barcode'] as String?,
      initialAmount: double.tryParse(json['initial_amount'].toString()) ?? 0.0,
      balance: double.tryParse(json['balance'].toString()) ?? 0.0,
      recipientName: json['recipient_name'] as String?,
      status: GiftCardStatus.tryFromValue(json['status'] as String?),
      issuedBy: json['issued_by'] as String,
      issuedAtStore: json['issued_at_store'] as String,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'organization_id': organizationId,
      'code': code,
      'barcode': barcode,
      'initial_amount': initialAmount,
      'balance': balance,
      'recipient_name': recipientName,
      'status': status?.value,
      'issued_by': issuedBy,
      'issued_at_store': issuedAtStore,
      'expires_at': expiresAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  GiftCard copyWith({
    String? id,
    String? organizationId,
    String? code,
    String? barcode,
    double? initialAmount,
    double? balance,
    String? recipientName,
    GiftCardStatus? status,
    String? issuedBy,
    String? issuedAtStore,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return GiftCard(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      code: code ?? this.code,
      barcode: barcode ?? this.barcode,
      initialAmount: initialAmount ?? this.initialAmount,
      balance: balance ?? this.balance,
      recipientName: recipientName ?? this.recipientName,
      status: status ?? this.status,
      issuedBy: issuedBy ?? this.issuedBy,
      issuedAtStore: issuedAtStore ?? this.issuedAtStore,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is GiftCard && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'GiftCard(id: $id, organizationId: $organizationId, code: $code, barcode: $barcode, initialAmount: $initialAmount, balance: $balance, ...)';
}
