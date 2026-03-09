enum DeliveryEndpointOperation {
  productCreate('product_create'),
  productUpdate('product_update'),
  productDelete('product_delete'),
  categorySync('category_sync'),
  bulkMenuPush('bulk_menu_push');

  const DeliveryEndpointOperation(this.value);
  final String value;

  static DeliveryEndpointOperation fromValue(String value) {
    return DeliveryEndpointOperation.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid DeliveryEndpointOperation: $value'),
    );
  }

  static DeliveryEndpointOperation? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
