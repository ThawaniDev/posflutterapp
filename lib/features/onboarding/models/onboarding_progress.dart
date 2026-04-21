import 'package:wameedpos/features/onboarding/enums/onboarding_step.dart';

class OnboardingProgress {

  const OnboardingProgress({
    required this.id,
    required this.storeId,
    this.currentStep,
    this.completedSteps = const [],
    this.checklistItems = const {},
    this.isWizardCompleted = false,
    this.isChecklistDismissed = false,
    this.completionPercent = 0,
    this.startedAt,
    this.completedAt,
  });

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) {
    return OnboardingProgress(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      currentStep: OnboardingStep.tryFromValue(json['current_step'] as String?),
      completedSteps: (json['completed_steps'] as List?)?.map((e) => e as String).toList() ?? [],
      checklistItems: json['checklist_items'] != null ? Map<String, dynamic>.from(json['checklist_items'] as Map) : {},
      isWizardCompleted: json['is_wizard_completed'] as bool? ?? false,
      isChecklistDismissed: json['is_checklist_dismissed'] as bool? ?? false,
      completionPercent: (json['completion_percent'] as num?)?.toInt() ?? 0,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }
  final String id;
  final String storeId;
  final OnboardingStep? currentStep;
  final List<String> completedSteps;
  final Map<String, dynamic> checklistItems;
  final bool isWizardCompleted;
  final bool isChecklistDismissed;
  final int completionPercent;
  final DateTime? startedAt;
  final DateTime? completedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'current_step': currentStep?.value,
      'completed_steps': completedSteps,
      'checklist_items': checklistItems,
      'is_wizard_completed': isWizardCompleted,
      'is_checklist_dismissed': isChecklistDismissed,
      'completion_percent': completionPercent,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  bool isStepCompleted(String step) => completedSteps.contains(step);

  OnboardingProgress copyWith({
    String? id,
    String? storeId,
    OnboardingStep? currentStep,
    List<String>? completedSteps,
    Map<String, dynamic>? checklistItems,
    bool? isWizardCompleted,
    bool? isChecklistDismissed,
    int? completionPercent,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return OnboardingProgress(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      checklistItems: checklistItems ?? this.checklistItems,
      isWizardCompleted: isWizardCompleted ?? this.isWizardCompleted,
      isChecklistDismissed: isChecklistDismissed ?? this.isChecklistDismissed,
      completionPercent: completionPercent ?? this.completionPercent,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnboardingProgress && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'OnboardingProgress(id: $id, storeId: $storeId, currentStep: $currentStep, '
      'completed: ${completedSteps.length}/$completionPercent%, '
      'wizardDone: $isWizardCompleted)';
}
