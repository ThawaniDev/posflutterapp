/// Parses GS1 weight/price-embedded EAN-13 barcodes commonly produced by
/// supermarket label printers. Only the European convention is supported here:
///
///   * Prefix `21` or `22` — the next 5 digits are the product reference and
///     the following 5 digits are the weight in grams (5-digit packed).
///   * Prefix `23` or `24` — the next 5 digits are the product reference and
///     the following 5 digits are the price in minor units (e.g. halalas).
///
/// The 13th digit is the EAN-13 check digit and is ignored. The check digit
/// of the 5-digit price/weight payload is part of the inner block on some
/// regional encodings; we expose the raw value and let the caller round.
library;

class WeightEmbeddedBarcode {
  const WeightEmbeddedBarcode({required this.productReference, this.weightKg, this.priceMinor});

  final String productReference;
  final double? weightKg;
  final int? priceMinor;

  bool get hasWeight => weightKg != null;
  bool get hasPrice => priceMinor != null;
}

class EanWeightedParser {
  /// Returns the parsed details if [code] is a recognised weight/price-embedded
  /// EAN-13, otherwise `null`.
  static WeightEmbeddedBarcode? tryParse(String code) {
    if (code.length != 13) return null;
    if (!RegExp(r'^[0-9]{13}$').hasMatch(code)) return null;
    final prefix = code.substring(0, 2);
    final ref = code.substring(2, 7);
    final payload = code.substring(7, 12);
    final payloadInt = int.tryParse(payload);
    if (payloadInt == null) return null;

    switch (prefix) {
      case '21':
      case '22':
        return WeightEmbeddedBarcode(productReference: ref, weightKg: payloadInt / 1000.0);
      case '23':
      case '24':
        return WeightEmbeddedBarcode(productReference: ref, priceMinor: payloadInt);
      default:
        return null;
    }
  }
}
