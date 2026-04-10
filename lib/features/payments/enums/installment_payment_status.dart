/// Status of an installment payment through its lifecycle.
enum InstallmentPaymentStatus {
  pending('pending'),
  checkoutCreated('checkout_created'),
  authorized('authorized'),
  completed('completed'),
  failed('failed'),
  cancelled('cancelled'),
  expired('expired'),
  rejected('rejected');

  const InstallmentPaymentStatus(this.value);
  final String value;

  static InstallmentPaymentStatus fromValue(String value) {
    return InstallmentPaymentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid InstallmentPaymentStatus: $value'),
    );
  }

  static InstallmentPaymentStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }

  String get label {
    switch (this) {
      case InstallmentPaymentStatus.pending:
        return 'Pending';
      case InstallmentPaymentStatus.checkoutCreated:
        return 'Checkout Created';
      case InstallmentPaymentStatus.authorized:
        return 'Authorized';
      case InstallmentPaymentStatus.completed:
        return 'Completed';
      case InstallmentPaymentStatus.failed:
        return 'Failed';
      case InstallmentPaymentStatus.cancelled:
        return 'Cancelled';
      case InstallmentPaymentStatus.expired:
        return 'Expired';
      case InstallmentPaymentStatus.rejected:
        return 'Rejected';
    }
  }

  bool get isFinal => this == completed || this == failed || this == cancelled || this == expired || this == rejected;
  bool get isSuccess => this == completed;
}
