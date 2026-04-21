class TemplateReview {

  const TemplateReview({
    required this.id,
    required this.listingId,
    required this.organizationId,
    this.reviewerName,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  factory TemplateReview.fromJson(Map<String, dynamic> json) {
    return TemplateReview(
      id: json['id'] as String,
      listingId: json['listing_id'] as String,
      organizationId: json['organization_id'] as String,
      reviewerName: json['reviewer_name'] as String?,
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String listingId;
  final String organizationId;
  final String? reviewerName;
  final int rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'organization_id': organizationId,
      'reviewer_name': reviewerName,
      'rating': rating,
      'comment': comment,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is TemplateReview && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
