import 'package:wameedpos/features/wameed_ai/enums/ai_suggestion_priority.dart';
import 'package:wameedpos/features/wameed_ai/enums/ai_suggestion_status.dart';

class AISuggestion {

  const AISuggestion({
    required this.id,
    required this.storeId,
    required this.featureSlug,
    this.suggestionType,
    this.title,
    this.titleAr,
    this.contentJson,
    this.priority = AISuggestionPriority.medium,
    this.status = AISuggestionStatus.pending,
    this.acceptedAt,
    this.dismissedAt,
    this.expiresAt,
    this.createdAt,
  });

  factory AISuggestion.fromJson(Map<String, dynamic> json) {
    return AISuggestion(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      featureSlug: json['feature_slug'] as String,
      suggestionType: json['suggestion_type'] as String?,
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      contentJson: json['content_json'] as Map<String, dynamic>?,
      priority: AISuggestionPriority.tryFromValue(json['priority'] as String?) ?? AISuggestionPriority.medium,
      status: AISuggestionStatus.tryFromValue(json['status'] as String?) ?? AISuggestionStatus.pending,
      acceptedAt: json['accepted_at'] != null ? DateTime.parse(json['accepted_at'] as String) : null,
      dismissedAt: json['dismissed_at'] != null ? DateTime.parse(json['dismissed_at'] as String) : null,
      expiresAt: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final String featureSlug;
  final String? suggestionType;
  final String? title;
  final String? titleAr;
  final Map<String, dynamic>? contentJson;
  final AISuggestionPriority priority;
  final AISuggestionStatus status;
  final DateTime? acceptedAt;
  final DateTime? dismissedAt;
  final DateTime? expiresAt;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'feature_slug': featureSlug,
      'suggestion_type': suggestionType,
      'title': title,
      'title_ar': titleAr,
      'content_json': contentJson,
      'priority': priority.value,
      'status': status.value,
    };
  }

  AISuggestion copyWith({
    String? id,
    String? storeId,
    String? featureSlug,
    String? suggestionType,
    String? title,
    String? titleAr,
    Map<String, dynamic>? contentJson,
    AISuggestionPriority? priority,
    AISuggestionStatus? status,
    DateTime? acceptedAt,
    DateTime? dismissedAt,
    DateTime? expiresAt,
    DateTime? createdAt,
  }) {
    return AISuggestion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      featureSlug: featureSlug ?? this.featureSlug,
      suggestionType: suggestionType ?? this.suggestionType,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      contentJson: contentJson ?? this.contentJson,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      dismissedAt: dismissedAt ?? this.dismissedAt,
      expiresAt: expiresAt ?? this.expiresAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AISuggestion && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class AIFeedback {

  const AIFeedback({
    required this.id,
    required this.aiUsageLogId,
    required this.storeId,
    this.userId,
    required this.rating,
    this.feedbackText,
    this.isHelpful,
    this.createdAt,
  });

  factory AIFeedback.fromJson(Map<String, dynamic> json) {
    return AIFeedback(
      id: json['id'] as String,
      aiUsageLogId: json['ai_usage_log_id'] as String,
      storeId: json['store_id'] as String,
      userId: json['user_id'] as String?,
      rating: (json['rating'] as num).toInt(),
      feedbackText: json['feedback_text'] as String?,
      isHelpful: json['is_helpful'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String aiUsageLogId;
  final String storeId;
  final String? userId;
  final int rating;
  final String? feedbackText;
  final bool? isHelpful;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {'ai_usage_log_id': aiUsageLogId, 'rating': rating, 'feedback_text': feedbackText, 'is_helpful': isHelpful};
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is AIFeedback && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
