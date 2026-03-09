enum ReturnRefundMethod {
  originalMethod('original_method'),
  cash('cash'),
  storeCredit('store_credit');

  const ReturnRefundMethod(this.value);
  final String value;

  static ReturnRefundMethod fromValue(String value) {
    return ReturnRefundMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ReturnRefundMethod: $value'),
    );
  }

  static ReturnRefundMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
