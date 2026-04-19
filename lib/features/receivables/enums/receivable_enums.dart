enum ReceivableStatus {
  pending('pending'),
  partiallyPaid('partially_paid'),
  fullyPaid('fully_paid'),
  reversed('reversed');

  final String value;
  const ReceivableStatus(this.value);

  static ReceivableStatus fromValue(String value) {
    return ReceivableStatus.values.firstWhere((e) => e.value == value, orElse: () => ReceivableStatus.pending);
  }
}

enum ReceivableType {
  creditSale('credit_sale'),
  loan('loan'),
  inventoryAdjustment('inventory_adjustment'),
  manual('manual');

  final String value;
  const ReceivableType(this.value);

  static ReceivableType fromValue(String value) {
    return ReceivableType.values.firstWhere((e) => e.value == value, orElse: () => ReceivableType.creditSale);
  }
}

enum ReceivableSource {
  posTerminal('pos_terminal'),
  invoice('invoice'),
  returnSource('return'),
  manual('manual'),
  inventorySystem('inventory_system');

  final String value;
  const ReceivableSource(this.value);

  static ReceivableSource fromValue(String value) {
    return ReceivableSource.values.firstWhere((e) => e.value == value, orElse: () => ReceivableSource.manual);
  }
}
