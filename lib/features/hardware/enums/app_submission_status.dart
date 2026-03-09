enum AppSubmissionStatus {
  notApplicable('not_applicable'),
  submitted('submitted'),
  inReview('in_review'),
  approved('approved'),
  rejected('rejected'),
  live('live');

  const AppSubmissionStatus(this.value);
  final String value;

  static AppSubmissionStatus fromValue(String value) {
    return AppSubmissionStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => throw ArgumentError('Invalid AppSubmissionStatus: $value'),
    );
  }

  static AppSubmissionStatus? tryFromValue(String? value) {
    if (value == null) return null;
    try {
      return fromValue(value);
    } catch (_) {
      return null;
    }
  }
}
