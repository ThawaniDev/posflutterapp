/// BNPL checkout response. Mirrors native Bnpl class.
class BnplResponse {
  final String checkoutId;
  final String paymentGatewayTransactionId;
  final String checkoutDeeplink;
  final String transactionId;

  const BnplResponse({
    required this.checkoutId,
    required this.paymentGatewayTransactionId,
    required this.checkoutDeeplink,
    required this.transactionId,
  });

  factory BnplResponse.fromMap(Map<String, dynamic> map) => BnplResponse(
        checkoutId: map['checkoutId'] as String? ?? '',
        paymentGatewayTransactionId: map['paymentGatewayTransactionId'] as String? ?? '',
        checkoutDeeplink: map['checkoutDeeplink'] as String? ?? '',
        transactionId: map['transactionId'] as String? ?? '',
      );

  Map<String, dynamic> toMap() => {
        'checkoutId': checkoutId,
        'paymentGatewayTransactionId': paymentGatewayTransactionId,
        'checkoutDeeplink': checkoutDeeplink,
        'transactionId': transactionId,
      };

  @override
  String toString() => 'BnplResponse(checkoutId: $checkoutId, transactionId: $transactionId, checkoutDeeplink: $checkoutDeeplink)';
}
