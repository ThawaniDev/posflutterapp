import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_score_gauge.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_markdown_text.dart';

class EfficiencyScorePage extends ConsumerStatefulWidget {
  const EfficiencyScorePage({super.key});

  @override
  ConsumerState<EfficiencyScorePage> createState() => _EfficiencyScorePageState();
}

class _EfficiencyScorePageState extends ConsumerState<EfficiencyScorePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('efficiency_score');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.wameedAIEfficiencyScore,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('efficiency_score'), tooltip: l10n.commonRefresh,
  ),
],
  child: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => PosLoading(message: l10n.wameedAIAnalyzing),
        AIFeatureResultError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              AppSpacing.gapH16,
              Text(message, textAlign: TextAlign.center),
              AppSpacing.gapH16,
              PosButton(
                label: l10n.commonRetry,
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('efficiency_score'),
              ),
            ],
          ),
        ),
        AIFeatureResultLoaded(:final result) => _buildContent(result.data, isMobile, l10n),
      },
);
  }

  Widget _buildContent(Map<String, dynamic>? data, bool isMobile, AppLocalizations l10n) {
    if (data == null) {
      return Center(
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.speed),
      );
    }

    final overallScore = (data['overall_score'] as num?)?.toDouble() ?? 0;
    final grade = data['grade']?.toString() ?? '';
    final subscores = data['sub_scores'] as Map<String, dynamic>? ?? data['breakdown'] as Map<String, dynamic>? ?? {};
    // Backend returns 'improvements_ar' as array of objects {area, current_score, target, action_ar}
    final rawImprovements =
        data['improvements_ar'] as List? ?? data['improvements'] as List? ?? data['suggestions'] as List? ?? [];
    final improvements = rawImprovements.map((item) {
      if (item is Map) {
        // Extract action_ar from object, or build a description
        final action = item['action_ar'] ?? item['action'] ?? '';
        final area = item['area'] ?? '';
        if (action.toString().isNotEmpty) return '$area: $action';
        return item.toString();
      }
      return item.toString();
    }).toList();
    // Backend returns 'summary_ar' as a string
    final summaryText = data['summary_ar']?.toString() ?? '';

    return SingleChildScrollView(
      padding: context.responsivePagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main gauge
          Center(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: AppRadius.borderXxl,
                border: Border.all(color: Theme.of(context).dividerColor),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.wameedAIOverallScore,
                    style: Theme.of(
                      context,
                    ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor),
                  ),
                  AppSpacing.gapH16,
                  AIScoreGauge(score: overallScore, size: 160, label: '/100'),
                  AppSpacing.gapH16,
                  Text(
                    grade.isNotEmpty ? '$grade - ${_scoreLabel(l10n, overallScore)}' : _scoreLabel(l10n, overallScore),
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: _scoreColor(overallScore)),
                  ),
                ],
              ),
            ),
          ),

          // Sub-scores
          if (subscores.isNotEmpty) ...[
            AppSpacing.gapH24,
            Text(
              l10n.wameedAIScoreBreakdown,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            AppSpacing.gapH12,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 2 : 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: subscores.length,
              itemBuilder: (context, index) {
                final entry = subscores.entries.elementAt(index);
                final score = (entry.value is num) ? (entry.value as num).toDouble() : 0.0;
                final label = entry.key.replaceAll('_', ' ');
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: AppRadius.borderLg,
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AIScoreGauge(score: score, size: 70),
                      AppSpacing.gapH8,
                      Text(
                        label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],

          // AI Summary
          if (summaryText.isNotEmpty) ...[
            AppSpacing.gapH24,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: AIMarkdownText(summaryText),
            ),
          ],

          // Improvement suggestions
          if (improvements.isNotEmpty) ...[
            AppSpacing.gapH24,
            Row(
              children: [
                const Icon(Icons.trending_up, size: 20, color: AppColors.warning),
                AppSpacing.gapW8,
                Text(
                  l10n.wameedAIImprovements,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            AppSpacing.gapH8,
            ...improvements.asMap().entries.map(
              (entry) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.05),
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(color: AppColors.warning.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderSm,
                      ),
                      child: Text(
                        '${entry.key + 1}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.warning),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(entry.value, style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _scoreLabel(AppLocalizations l10n, double score) {
    if (score >= 90) return l10n.wameedAIScoreExcellent;
    if (score >= 75) return l10n.wameedAIScoreGood;
    if (score >= 60) return l10n.wameedAIScoreAverage;
    if (score >= 40) return l10n.wameedAIScoreBelowAverage;
    return l10n.wameedAIScoreNeedsImprovement;
  }

  Color _scoreColor(double score) {
    if (score >= 80) return AppColors.success;
    if (score >= 60) return AppColors.warning;
    return AppColors.error;
  }
}
