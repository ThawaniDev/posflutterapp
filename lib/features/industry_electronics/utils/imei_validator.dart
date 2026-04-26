/// IMEI validation utilities.
///
/// Implements the Luhn algorithm for check-digit verification per the
/// IMEI specification (ITU-T E.212).
class ImeiValidator {
  ImeiValidator._();

  /// Returns `true` if [imei] is a 15-digit string that passes the Luhn check.
  static bool isValid(String imei) {
    if (imei.length != 15 || !RegExp(r'^\d{15}$').hasMatch(imei)) {
      return false;
    }

    int sum = 0;
    for (int i = 0; i < 15; i++) {
      int digit = int.parse(imei[i]);
      if (i % 2 == 1) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }

  /// Validator suitable for use with [TextFormField.validator].
  /// Returns an error string or `null` when valid.
  static String? validate(String? value, {required String errorMessage}) {
    if (value == null || value.trim().isEmpty) return null; // optional field
    return isValid(value.trim()) ? null : errorMessage;
  }
}
