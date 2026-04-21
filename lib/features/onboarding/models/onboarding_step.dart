class OnboardingStep {

  const OnboardingStep({
    required this.id,
    required this.stepNumber,
    required this.title,
    required this.titleAr,
    this.description,
    this.descriptionAr,
    this.isRequired,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory OnboardingStep.fromJson(Map<String, dynamic> json) {
    return OnboardingStep(
      id: json['id'] as String,
      stepNumber: (json['step_number'] as num).toInt(),
      title: json['title'] as String,
      titleAr: json['title_ar'] as String,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      isRequired: json['is_required'] as bool?,
      sortOrder: (json['sort_order'] as num?)?.toInt(),
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final int stepNumber;
  final String title;
  final String titleAr;
  final String? description;
  final String? descriptionAr;
  final bool? isRequired;
  final int? sortOrder;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'step_number': stepNumber,
      'title': title,
      'title_ar': titleAr,
      'description': description,
      'description_ar': descriptionAr,
      'is_required': isRequired,
      'sort_order': sortOrder,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  OnboardingStep copyWith({
    String? id,
    int? stepNumber,
    String? title,
    String? titleAr,
    String? description,
    String? descriptionAr,
    bool? isRequired,
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OnboardingStep(
      id: id ?? this.id,
      stepNumber: stepNumber ?? this.stepNumber,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      isRequired: isRequired ?? this.isRequired,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingStep && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OnboardingStep(id: $id, stepNumber: $stepNumber, title: $title, titleAr: $titleAr, description: $description, descriptionAr: $descriptionAr, ...)';
}
