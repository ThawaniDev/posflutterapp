import 'package:wameedpos/features/support/enums/knowledge_base_category.dart';

class KnowledgeBaseArticle {
  final String id;
  final String title;
  final String? titleAr;
  final String slug;
  final String body;
  final String? bodyAr;
  final KnowledgeBaseCategory category;
  final bool isPublished;
  final int sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const KnowledgeBaseArticle({
    required this.id,
    required this.title,
    this.titleAr,
    required this.slug,
    required this.body,
    this.bodyAr,
    required this.category,
    required this.isPublished,
    required this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory KnowledgeBaseArticle.fromJson(Map<String, dynamic> json) {
    return KnowledgeBaseArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      titleAr: json['title_ar'] as String?,
      slug: json['slug'] as String,
      body: json['body'] as String,
      bodyAr: json['body_ar'] as String?,
      category: KnowledgeBaseCategory.fromValue(json['category'] as String),
      isPublished: json['is_published'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
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
      'is_published': isPublished,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is KnowledgeBaseArticle && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
