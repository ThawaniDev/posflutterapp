enum MarketplaceListingStatus {
  draft('draft'),
  pendingReview('pending_review'),
  approved('approved'),
  rejected('rejected'),
  suspended('suspended');

  const MarketplaceListingStatus(this.value);
  final String value;

  static MarketplaceListingStatus fromValue(String value) {
    return MarketplaceListingStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid MarketplaceListingStatus: $value'),
    );
  }

  static MarketplaceListingStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
