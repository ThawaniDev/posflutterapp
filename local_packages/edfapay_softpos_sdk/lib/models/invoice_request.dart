import '../enums/bnpl_provider.dart';

/// BNPL/Invoice checkout request. Mirrors native InvoiceRequest class.
class InvoiceRequest {
  final PaymentMethod paymentMethod;
  final String merchantId;
  final double amount;
  final String currency;
  final String phoneNumber;
  final String email;
  final String orderReferenceId;
  final String orderNumber;
  final String locale;
  final String paymentType;
  final Invoice invoice;
  final AdditionalData additionalData;

  const InvoiceRequest({
    required this.paymentMethod,
    required this.merchantId,
    required this.amount,
    required this.currency,
    required this.phoneNumber,
    required this.email,
    required this.orderReferenceId,
    required this.orderNumber,
    this.locale = 'en_US',
    this.paymentType = 'PAY_BY_INSTALMENTS',
    required this.invoice,
    required this.additionalData,
  });

  Map<String, dynamic> toMap() => {
        'paymentMethod': paymentMethod.name,
        'merchantId': merchantId,
        'amount': amount,
        'currency': currency,
        'phoneNumber': phoneNumber,
        'email': email,
        'orderReferenceId': orderReferenceId,
        'orderNumber': orderNumber,
        'locale': locale,
        'paymentType': paymentType,
        'invoice': invoice.toMap(),
        'additionalData': additionalData.toMap(),
      };
}

/// Invoice details for BNPL checkout.
class Invoice {
  final double shippingCharges;
  final double extraDiscount;
  final double total;
  final List<InvoiceLineItem> lineItems;

  const Invoice({
    this.shippingCharges = 0,
    this.extraDiscount = 0,
    required this.total,
    required this.lineItems,
  });

  Map<String, dynamic> toMap() => {
        'shippingCharges': shippingCharges,
        'extraDiscount': extraDiscount,
        'total': total,
        'lineItems': lineItems.map((i) => i.toMap()).toList(),
      };
}

/// Line item in BNPL invoice.
class InvoiceLineItem {
  final String sku;
  final String description;
  final double unitCost;
  final double quantity;
  final double netTotal;
  final double discountAmount;
  final double taxTotal;
  final double total;

  const InvoiceLineItem({
    required this.sku,
    required this.description,
    required this.unitCost,
    required this.quantity,
    required this.netTotal,
    this.discountAmount = 0,
    this.taxTotal = 0,
    required this.total,
  });

  Map<String, dynamic> toMap() => {
        'sku': sku,
        'description': description,
        'unitCost': unitCost,
        'quantity': quantity,
        'netTotal': netTotal,
        'discountAmount': discountAmount,
        'taxTotal': taxTotal,
        'total': total,
      };
}

/// Additional data for BNPL checkout.
class AdditionalData {
  final String storeId;

  const AdditionalData({required this.storeId});

  Map<String, dynamic> toMap() => {
        'storeId': storeId,
      };
}
