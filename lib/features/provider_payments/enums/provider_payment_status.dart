enum ProviderPaymentStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  refunded('refunded'),
  voided('voided');

  const ProviderPaymentStatus(this.value);
  final String value;

  static ProviderPaymentStatus fromValue(String value) {
    return ProviderPaymentStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ProviderPaymentStatus: $value'),
    );
  }

  static ProviderPaymentStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }

  String get label => switch (this) {
    pending => 'Pending',
    processing => 'Processing',
    completed => 'Completed',
    failed => 'Failed',
    refunded => 'Refunded',
    voided => 'Voided',
  };

  bool get isTerminal => this == completed || this == failed || this == refunded || this == voided;
}
