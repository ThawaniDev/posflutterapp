import 'package:wameedpos/features/pos_customization/enums/knowledge_base_category.dart';

class KnowledgeBaseArticle {
  final String id;
  final String title;
  final String titleAr;
  final String slug;
  final String body;
  final String bodyAr;
  final KnowledgeBaseCategory category;
  final String? deliveryPlatformId;
  final bool? isPublished;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const KnowledgeBaseArticle({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.slug,
    required this.body,
    required this.bodyAr,
    required this.category,
    this.deliveryPlatformId,
    this.isPublished,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory KnowledgeBaseArticle.fromJson(Map<String, dynamic> json) {
    return KnowledgeBaseArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      titleAr: json['title_ar'] as String,
      slug: json['slug'] as String,
      body: json['body'] as String,
      bodyAr: json['body_ar'] as String,
      category: KnowledgeBaseCategory.fromValue(json['category'] as String),
      deliveryPlatformId: json['delivery_platform_id'] as String?,
      isPublished: json['is_published'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'title_ar': titleAr,
      'slug': slug,
      'body': body,
      'body_ar': bodyAr,
      'category': category.value,
      'delivery_platform_id': deliveryPlatformId,
      'is_published': isPublished,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  KnowledgeBaseArticle copyWith({
    String? id,
    String? title,
    String? titleAr,
    String? slug,
    String? body,
    String? bodyAr,
    KnowledgeBaseCategory? category,
    String? deliveryPlatformId,
    bool? isPublished,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return KnowledgeBaseArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      slug: slug ?? this.slug,
      body: body ?? this.body,
      bodyAr: bodyAr ?? this.bodyAr,
      category: category ?? this.category,
      deliveryPlatformId: deliveryPlatformId ?? this.deliveryPlatformId,
      isPublished: isPublished ?? this.isPublished,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is KnowledgeBaseArticle && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'KnowledgeBaseArticle(id: $id, title: $title, titleAr: $titleAr, slug: $slug, body: $body, bodyAr: $bodyAr, ...)';
}
