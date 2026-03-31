import 'dart:math';

import 'package:thawani_pos/features/payments/enums/payment_method_key.dart';

/// SAR denomination values (notes and coins)
class SarDenomination {
  final double value;
  final String label;
  final String labelAr;
  final bool isCoin;

  const SarDenomination({required this.value, required this.label, required this.labelAr, this.isCoin = false});

  static const List<SarDenomination> all = [
    SarDenomination(value: 500, label: '500 SAR', labelAr: '٥٠٠ ر.س'),
    SarDenomination(value: 200, label: '200 SAR', labelAr: '٢٠٠ ر.س'),
    SarDenomination(value: 100, label: '100 SAR', labelAr: '١٠٠ ر.س'),
    SarDenomination(value: 50, label: '50 SAR', labelAr: '٥٠ ر.س'),
    SarDenomination(value: 20, label: '20 SAR', labelAr: '٢٠ ر.س'),
    SarDenomination(value: 10, label: '10 SAR', labelAr: '١٠ ر.س'),
    SarDenomination(value: 5, label: '5 SAR', labelAr: '٥ ر.س'),
    SarDenomination(value: 2, label: '2 SAR', labelAr: '٢ ر.س', isCoin: true),
    SarDenomination(value: 1, label: '1 SAR', labelAr: '١ ر.س', isCoin: true),
    SarDenomination(value: 0.50, label: '50 Halalas', labelAr: '٥٠ هللة', isCoin: true),
    SarDenomination(value: 0.25, label: '25 Halalas', labelAr: '٢٥ هللة', isCoin: true),
    SarDenomination(value: 0.10, label: '10 Halalas', labelAr: '١٠ هللة', isCoin: true),
    SarDenomination(value: 0.05, label: '5 Halalas', labelAr: '٥ هللة', isCoin: true),
  ];

  /// Quick-pay denominations for the payment screen
  static const List<double> quickPayAmounts = [1, 5, 10, 20, 50, 100, 200, 500];
}

/// Denomination count entry for cash counting
class DenominationCount {
  final SarDenomination denomination;
  int count;

  DenominationCount({required this.denomination, this.count = 0});

  double get total => denomination.value * count;
}

/// Split payment leg
class SplitPaymentLeg {
  final PaymentMethodKey method;
  final double amount;
  final Map<String, dynamic>? metadata; // Card details, gift card code, etc.

  const SplitPaymentLeg({required this.method, required this.amount, this.metadata});

  SplitPaymentLeg copyWith({PaymentMethodKey? method, double? amount, Map<String, dynamic>? metadata}) {
    return SplitPaymentLeg(method: method ?? this.method, amount: amount ?? this.amount, metadata: metadata ?? this.metadata);
  }
}

/// Payment calculation service — handles rounding, change, split payment logic
class PaymentCalculationService {
  /// Round cash amount to nearest 0.25 SAR (Saudi common practice)
  /// Card payments are NOT rounded — exact halalas
  static double roundCash(double amount) {
    return (amount * 4).round() / 4;
  }

  /// Calculate change for a cash payment
  static double calculateChange(double total, double tendered) {
    final change = tendered - total;
    return change > 0 ? roundCash(change) : 0;
  }

  /// Calculate total from denomination counts
  static double calculateDenominationTotal(List<DenominationCount> counts) {
    return counts.fold(0.0, (sum, dc) => sum + dc.total);
  }

  /// Calculate cash variance
  static double calculateVariance(double expected, double actual) {
    return actual - expected;
  }

  /// Validate split payment: sum of legs must equal total
  static bool validateSplitPayment(List<SplitPaymentLeg> legs, double total) {
    final sum = legs.fold(0.0, (s, leg) => s + leg.amount);
    return (sum - total).abs() < 0.01;
  }

  /// Calculate remaining amount for split payment
  static double splitPaymentRemaining(List<SplitPaymentLeg> legs, double total) {
    final allocated = legs.fold(0.0, (s, leg) => s + leg.amount);
    return max(0, total - allocated);
  }

  /// Suggest quick-pay amounts for cash payment
  /// Returns amounts >= total that are common denominations
  static List<double> suggestQuickPayAmounts(double total) {
    final rounded = roundCash(total);
    final suggestions = <double>[rounded]; // Exact amount first

    for (final amount in SarDenomination.quickPayAmounts) {
      if (amount >= total && !suggestions.contains(amount)) {
        suggestions.add(amount);
      }
    }

    // Add next round numbers
    final nextTen = (total / 10).ceil() * 10.0;
    final nextFifty = (total / 50).ceil() * 50.0;
    final nextHundred = (total / 100).ceil() * 100.0;

    for (final amt in [nextTen, nextFifty, nextHundred]) {
      if (!suggestions.contains(amt)) suggestions.add(amt);
    }

    suggestions.sort();
    return suggestions.take(8).toList();
  }

  /// Check if a payment method requires card terminal
  static bool requiresTerminal(PaymentMethodKey method) {
    return method == PaymentMethodKey.cardMada ||
        method == PaymentMethodKey.cardVisa ||
        method == PaymentMethodKey.cardMastercard;
  }

  /// Check if a payment method is a card type
  static bool isCardMethod(PaymentMethodKey method) {
    return requiresTerminal(method);
  }

  /// Get display name for payment method
  static String methodDisplayName(PaymentMethodKey method) {
    switch (method) {
      case PaymentMethodKey.cash:
        return 'Cash';
      case PaymentMethodKey.cardMada:
        return 'mada';
      case PaymentMethodKey.cardVisa:
        return 'Visa';
      case PaymentMethodKey.cardMastercard:
        return 'Mastercard';
      case PaymentMethodKey.storeCredit:
        return 'Store Credit';
      case PaymentMethodKey.giftCard:
        return 'Gift Card';
      case PaymentMethodKey.mobilePayment:
        return 'Mobile Payment';
    }
  }

  /// Get Arabic display name for payment method
  static String methodDisplayNameAr(PaymentMethodKey method) {
    switch (method) {
      case PaymentMethodKey.cash:
        return 'نقدي';
      case PaymentMethodKey.cardMada:
        return 'مدى';
      case PaymentMethodKey.cardVisa:
        return 'فيزا';
      case PaymentMethodKey.cardMastercard:
        return 'ماستركارد';
      case PaymentMethodKey.storeCredit:
        return 'رصيد المتجر';
      case PaymentMethodKey.giftCard:
        return 'بطاقة هدية';
      case PaymentMethodKey.mobilePayment:
        return 'دفع إلكتروني';
    }
  }

  /// Create denomination count list for cash counting
  static List<DenominationCount> createDenominationCounts() {
    return SarDenomination.all.map((d) => DenominationCount(denomination: d)).toList();
  }
}
