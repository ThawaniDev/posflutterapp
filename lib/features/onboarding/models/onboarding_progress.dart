import 'package:thawani_pos/features/onboarding/enums/onboarding_step.dart';

class OnboardingProgress {
  final String id;
  final String storeId;
  final OnboardingStep? currentStep;
  final Map<String, dynamic>? completedSteps;
  final bool? isWizardCompleted;
  final bool? isChecklistDismissed;
  final DateTime? startedAt;
  final DateTime? completedAt;

  const OnboardingProgress({
    required this.id,
    required this.storeId,
    this.currentStep,
    this.completedSteps,
    this.isWizardCompleted,
    this.isChecklistDismissed,
    this.startedAt,
    this.completedAt,
  });

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) {
    return OnboardingProgress(
      id: json['id'] as String,
      storeId: json['store_id'] as String,
      currentStep: OnboardingStep.tryFromValue(json['current_step'] as String?),
      completedSteps: json['completed_steps'] != null ? Map<String, dynamic>.from(json['completed_steps'] as Map) : null,
      isWizardCompleted: json['is_wizard_completed'] as bool?,
      isChecklistDismissed: json['is_checklist_dismissed'] as bool?,
      startedAt: json['started_at'] != null ? DateTime.parse(json['started_at'] as String) : null,
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'current_step': currentStep?.value,
      'completed_steps': completedSteps,
      'is_wizard_completed': isWizardCompleted,
      'is_checklist_dismissed': isChecklistDismissed,
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  OnboardingProgress copyWith({
    String? id,
    String? storeId,
    OnboardingStep? currentStep,
    Map<String, dynamic>? completedSteps,
    bool? isWizardCompleted,
    bool? isChecklistDismissed,
    DateTime? startedAt,
    DateTime? completedAt,
  }) {
    return OnboardingProgress(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      currentStep: currentStep ?? this.currentStep,
      completedSteps: completedSteps ?? this.completedSteps,
      isWizardCompleted: isWizardCompleted ?? this.isWizardCompleted,
      isChecklistDismissed: isChecklistDismissed ?? this.isChecklistDismissed,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OnboardingProgress && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'OnboardingProgress(id: $id, storeId: $storeId, currentStep: $currentStep, completedSteps: $completedSteps, isWizardCompleted: $isWizardCompleted, isChecklistDismissed: $isChecklistDismissed, ...)';
}
