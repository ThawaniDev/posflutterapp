enum ProviderRegistrationStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected');

  const ProviderRegistrationStatus(this.value);
  final String value;

  static ProviderRegistrationStatus fromValue(String value) {
    return ProviderRegistrationStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid ProviderRegistrationStatus: $value'),
    );
  }

  static ProviderRegistrationStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
