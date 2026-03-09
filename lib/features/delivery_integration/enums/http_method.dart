enum HttpMethod {
  post('POST'),
  put('PUT'),
  delete('DELETE'),
  patch('PATCH');

  const HttpMethod(this.value);
  final String value;

  static HttpMethod fromValue(String value) {
    return HttpMethod.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid HttpMethod: $value'),
    );
  }

  static HttpMethod? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
