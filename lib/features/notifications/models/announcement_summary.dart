/// Lightweight summary of a platform announcement as returned by the
/// provider-facing GET /announcements endpoint. The server omits internal
/// fields such as target_filter / created_by.
class AnnouncementSummary {
  const AnnouncementSummary({
    required this.id,
    required this.type,
    required this.title,
    required this.titleAr,
    required this.body,
    required this.bodyAr,
    required this.isBanner,
    this.displayStartAt,
    this.displayEndAt,
    this.createdAt,
  });

  factory AnnouncementSummary.fromJson(Map<String, dynamic> json) {
    return AnnouncementSummary(
      id: json['id'] as String,
      type: json['type'] as String? ?? 'info',
      title: json['title'] as String? ?? '',
      titleAr: json['title_ar'] as String? ?? '',
      body: json['body'] as String? ?? '',
      bodyAr: json['body_ar'] as String? ?? '',
      isBanner: (json['is_banner'] as bool?) ?? false,
      displayStartAt: json['display_start_at'] != null ? DateTime.tryParse(json['display_start_at'] as String) : null,
      displayEndAt: json['display_end_at'] != null ? DateTime.tryParse(json['display_end_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
    );
  }

  final String id;
  final String type;
  final String title;
  final String titleAr;
  final String body;
  final String bodyAr;
  final bool isBanner;
  final DateTime? displayStartAt;
  final DateTime? displayEndAt;
  final DateTime? createdAt;

  String localizedTitle(String locale) => locale.startsWith('ar') && titleAr.isNotEmpty ? titleAr : title;

  String localizedBody(String locale) => locale.startsWith('ar') && bodyAr.isNotEmpty ? bodyAr : body;
}
