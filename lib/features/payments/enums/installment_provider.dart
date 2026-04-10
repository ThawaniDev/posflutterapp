/// Installment payment provider identifier.
enum InstallmentProvider {
  tabby('tabby'),
  tamara('tamara'),
  mispay('mispay'),
  madfu('madfu');

  const InstallmentProvider(this.value);
  final String value;

  static InstallmentProvider fromValue(String value) {
    return InstallmentProvider.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid InstallmentProvider: $value'),
    );
  }

  static InstallmentProvider? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }

  String get label {
    switch (this) {
      case InstallmentProvider.tabby:
        return 'Tabby';
      case InstallmentProvider.tamara:
        return 'Tamara';
      case InstallmentProvider.mispay:
        return 'MisPay';
      case InstallmentProvider.madfu:
        return 'Madfu';
    }
  }

  String get labelAr {
    switch (this) {
      case InstallmentProvider.tabby:
        return 'تابي';
      case InstallmentProvider.tamara:
        return 'تمارا';
      case InstallmentProvider.mispay:
        return 'مس باي';
      case InstallmentProvider.madfu:
        return 'مدفوع';
    }
  }

  /// Maps to the POS PaymentMethod enum value for transaction recording.
  String get paymentMethodValue => value;

  bool get usesNativeSdk => this == InstallmentProvider.tabby;
  bool get usesWebView => !usesNativeSdk;
}
