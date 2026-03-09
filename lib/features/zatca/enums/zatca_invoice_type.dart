enum ZatcaInvoiceType {
  standard('standard'),
  simplified('simplified'),
  creditNote('credit_note'),
  debitNote('debit_note');

  const ZatcaInvoiceType(this.value);
  final String value;

  static ZatcaInvoiceType fromValue(String value) {
    return ZatcaInvoiceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ZatcaInvoiceType: $value'),
    );
  }

  static ZatcaInvoiceType? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
