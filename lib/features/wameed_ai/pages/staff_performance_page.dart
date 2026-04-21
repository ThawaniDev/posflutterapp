import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';

class StaffPerformancePage extends ConsumerStatefulWidget {
  const StaffPerformancePage({super.key});

  @override
  ConsumerState<StaffPerformancePage> createState() => _StaffPerformancePageState();
}

class _StaffPerformancePageState extends ConsumerState<StaffPerformancePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('staff_performance');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;

    return PosListPage(
  title: l10n.wameedAIStaffPerformance,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('staff_performance'), tooltip: l10n.commonRefresh,
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
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('staff_performance'),
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
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.leaderboard),
      );
    }

    // Backend returns 'rankings' array from AI, fallback to 'staff'
    final staff =
        (data['rankings'] as List?)?.cast<Map<String, dynamic>>() ?? (data['staff'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // Backend returns 'team_summary_ar' as a string, not a list
    final teamSummary = data['team_summary_ar']?.toString() ?? '';
    // Backend returns 'improvement_areas_ar' as a list
    final improvementAreas =
        (data['improvement_areas_ar'] as List?)?.cast<String>() ?? (data['coaching_tips'] as List?)?.cast<String>() ?? [];

    // Sort by performance score descending
    staff.sort(
      (a, b) =>
          ((b['score'] ?? b['performance_score'] ?? 0) as num).compareTo((a['score'] ?? a['performance_score'] ?? 0) as num),
    );

    return SingleChildScrollView(
      padding: context.responsivePagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Team summary
          if (teamSummary.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.insights, size: 20, color: AppColors.info),
                      AppSpacing.gapW8,
                      Text(
                        l10n.wameedAITeamInsights,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  AppSpacing.gapH8,
                  SelectableText(teamSummary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                ],
              ),
            ),
            AppSpacing.gapH20,
          ],

          // Leaderboard
          Text(l10n.wameedAILeaderboard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          AppSpacing.gapH12,

          if (staff.isEmpty)
            PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.people_outline)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staff.length,
              separatorBuilder: (_, __) => AppSpacing.gapH8,
              itemBuilder: (context, index) {
                final member = staff[index];
                return _buildStaffCard(member, index, l10n);
              },
            ),

          // Improvement areas
          if (improvementAreas.isNotEmpty) ...[
            AppSpacing.gapH24,
            Row(
              children: [
                const Icon(Icons.school_outlined, size: 20, color: AppColors.success),
                AppSpacing.gapW8,
                Text(
                  l10n.wameedAICoachingTips,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            AppSpacing.gapH12,
            ...improvementAreas.map(
              (tip) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.05),
                  borderRadius: AppRadius.borderLg,
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.success),
                    AppSpacing.gapW8,
                    Expanded(child: Text(tip, style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStaffCard(Map<String, dynamic> member, int rank, AppLocalizations l10n) {
    final name = member['name'] ?? member['staff_name'] ?? 'Staff ${rank + 1}';
    final score = (member['score'] ?? member['performance_score'] ?? 0) as num;
    // Backend returns 'sales_total' and 'txn_count', fallback to old keys
    final totalSales = member['sales_total'] ?? member['total_sales'] ?? member['sales_count'] ?? 0;
    final txnCount = member['txn_count'] ?? member['revenue'] ?? member['total_revenue'] ?? 0;
    final avgBasket = member['avg_basket'] ?? member['avg_transaction'] ?? 0;
    final voidRate = member['void_rate'];
    final attendancePct = member['attendance_pct'];
    final feedback = member['feedback_ar'] ?? member['feedback'] ?? member['coaching'] ?? '';

    final medalColors = [Colors.amber, Colors.grey.shade400, const Color(0xFFCD7F32)];
    final medalIcons = [Icons.emoji_events, Icons.emoji_events, Icons.emoji_events];

    Color scoreColor;
    if (score >= 80) {
      scoreColor = AppColors.success;
    } else if (score >= 60) {
      scoreColor = AppColors.warning;
    } else {
      scoreColor = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: rank < 3 ? medalColors[rank].withValues(alpha: 0.3) : Theme.of(context).dividerColor),
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 40,
            child: rank < 3
                ? Icon(medalIcons[rank], color: medalColors[rank], size: 28)
                : Text(
                    '#${rank + 1}',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: Theme.of(context).hintColor),
                    textAlign: TextAlign.center,
                  ),
          ),
          AppSpacing.gapW12,

          // Staff info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                AppSpacing.gapH4,
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _metricChip(context, Icons.attach_money, '$totalSales ${l10n.wameedAISales}'),
                    _metricChip(context, Icons.receipt, '$txnCount ${l10n.wameedAITxns}'),
                    if (avgBasket != 0) _metricChip(context, Icons.shopping_basket, '${l10n.wameedAIAvg}: $avgBasket'),
                    if (voidRate != null) _metricChip(context, Icons.cancel_outlined, '${l10n.wameedAIVoid}: $voidRate%'),
                    if (attendancePct != null) _metricChip(context, Icons.access_time, '$attendancePct%'),
                  ],
                ),
                if (feedback.toString().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    feedback.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor, fontStyle: FontStyle.italic),
                    maxLines: 2,
                  ),
                ],
              ],
            ),
          ),

          // Score
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: scoreColor, width: 3),
            ),
            alignment: Alignment.center,
            child: Text(
              '${score.toInt()}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: scoreColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricChip(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: Theme.of(context).hintColor),
        const SizedBox(width: 3),
        Text(text, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11)),
      ],
    );
  }
}
