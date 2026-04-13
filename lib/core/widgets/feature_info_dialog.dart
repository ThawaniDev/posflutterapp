import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'pos_dialog.dart';

/// A single step in a feature guide.
class FeatureGuideStep {
  const FeatureGuideStep({required this.title, required this.description});
  final String title;
  final String description;
}

/// A section in the feature info (e.g. "Creating a Product", "Editing a Product").
class FeatureInfoSection {
  const FeatureInfoSection({required this.title, required this.icon, required this.steps});
  final String title;
  final IconData icon;
  final List<FeatureGuideStep> steps;
}

/// Shows a bottom-sheet style feature info dialog with a description and
/// step-by-step guides for each CRUD operation.
///
/// Uses the existing [showPosBottomSheet] helper for UI consistency.
Future<void> showFeatureInfoDialog(
  BuildContext context, {
  required String title,
  required String description,
  required List<FeatureInfoSection> sections,
  List<String> tips = const [],
}) {
  return showPosBottomSheet(
    context,
    maxHeightFraction: 0.85,
    builder: (ctx) => _FeatureInfoContent(title: title, description: description, sections: sections, tips: tips),
  );
}

class _FeatureInfoContent extends StatelessWidget {
  const _FeatureInfoContent({required this.title, required this.description, required this.sections, required this.tips});

  final String title;
  final String description;
  final List<FeatureInfoSection> sections;
  final List<String> tips;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosBottomSheetHeader(title: title, subtitle: null),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            children: [
              // Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.08),
                  borderRadius: AppRadius.borderMd,
                  border: Border.all(color: AppColors.info.withValues(alpha: 0.20)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppColors.info, size: 20),
                    AppSpacing.gapW12,
                    Expanded(
                      child: Text(
                        description,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.gapH20,

              // Sections (CRUD guides)
              for (final section in sections) ...[_SectionWidget(section: section), AppSpacing.gapH16],

              // Tips
              if (tips.isNotEmpty) ...[
                AppSpacing.gapH4,
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.08),
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: AppColors.warning.withValues(alpha: 0.20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline_rounded, color: AppColors.warning, size: 18),
                          AppSpacing.gapW8,
                          Text(
                            'Tips',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.warning, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      AppSpacing.gapH8,
                      for (final tip in tips)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('• ', style: AppTypography.bodySmall),
                              Expanded(child: Text(tip, style: AppTypography.bodySmall)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionWidget extends StatelessWidget {
  const _SectionWidget({required this.section});
  final FeatureInfoSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(section.icon, size: 20, color: AppColors.primary),
            AppSpacing.gapW8,
            Expanded(
              child: Text(section.title, style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.w700)),
            ),
          ],
        ),
        AppSpacing.gapH8,
        for (int i = 0; i < section.steps.length; i++) _StepRow(index: i + 1, step: section.steps[i]),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.index, required this.step});
  final int index;
  final FeatureGuideStep step;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Center(
              child: Text(
                '$index',
                style: AppTypography.labelSmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
              ),
            ),
          ),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  step.description,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
