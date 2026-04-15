import 'package:wameedpos/features/support/enums/ticket_category.dart';

class CannedResponse {
  final String id;
  final String title;
  final String? shortcut;
  final String body;
  final String bodyAr;
  final TicketCategory? category;
  final bool? isActive;
  final String? createdBy;
  final DateTime? createdAt;

  const CannedResponse({
    required this.id,
    required this.title,
    this.shortcut,
    required this.body,
    required this.bodyAr,
    this.category,
    this.isActive,
    this.createdBy,
    this.createdAt,
  });

  factory CannedResponse.fromJson(Map<String, dynamic> json) {
    return CannedResponse(
      id: json['id'] as String,
      title: json['title'] as String,
      shortcut: json['shortcut'] as String?,
      body: json['body'] as String,
      bodyAr: json['body_ar'] as String,
      category: TicketCategory.tryFromValue(json['category'] as String?),
      isActive: json['is_active'] as bool?,
      createdBy: json['created_by'] as String?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'shortcut': shortcut,
      'body': body,
      'body_ar': bodyAr,
      'category': category?.value,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  CannedResponse copyWith({
    String? id,
    String? title,
    String? shortcut,
    String? body,
    String? bodyAr,
    TicketCategory? category,
    bool? isActive,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return CannedResponse(
      id: id ?? this.id,
      title: title ?? this.title,
      shortcut: shortcut ?? this.shortcut,
      body: body ?? this.body,
      bodyAr: bodyAr ?? this.bodyAr,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is CannedResponse && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'CannedResponse(id: $id, title: $title, shortcut: $shortcut, body: $body, bodyAr: $bodyAr, category: $category, ...)';
}
