enum DebitStatus {
  pending('pending'),
  partiallyAllocated('partially_allocated'),
  fullyAllocated('fully_allocated'),
  reversed('reversed');

  final String value;
  const DebitStatus(this.value);

  static DebitStatus fromValue(String value) {
    return DebitStatus.values.firstWhere((e) => e.value == value, orElse: () => DebitStatus.pending);
  }
}

enum DebitType {
  customerCredit('customer_credit'),
  supplierReturn('supplier_return'),
  inventoryAdjustment('inventory_adjustment'),
  manualCredit('manual_credit');

  final String value;
  const DebitType(this.value);

  static DebitType fromValue(String value) {
    return DebitType.values.firstWhere((e) => e.value == value, orElse: () => DebitType.customerCredit);
  }
}

enum DebitSource {
  posTerminal('pos_terminal'),
  invoice('invoice'),
  returnSource('return'),
  manual('manual'),
  inventorySystem('inventory_system');

  final String value;
  const DebitSource(this.value);

  static DebitSource fromValue(String value) {
    return DebitSource.values.firstWhere((e) => e.value == value, orElse: () => DebitSource.manual);
  }
}
