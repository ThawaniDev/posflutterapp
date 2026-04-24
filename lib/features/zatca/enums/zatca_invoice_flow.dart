enum ZatcaInvoiceFlow {
  clearance('clearance'),
  reporting('reporting');

  const ZatcaInvoiceFlow(this.value);
  final String value;

  static ZatcaInvoiceFlow fromValue(String value) =>
      ZatcaInvoiceFlow.values.firstWhere(
        (e) => e.value == value,
        orElse: () => ZatcaInvoiceFlow.reporting,
      );

  static ZatcaInvoiceFlow? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return ZatcaInvoiceFlow.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
