import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.leaderboard, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAIStaffPerformance),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('staff_performance'),
          ),
        ],
      ),
      body: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Analyzing staff performance...')],
          ),
        ),
        AIFeatureResultError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
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

    final staff = (data['staff'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final teamInsights = (data['team_insights'] as List?)?.cast<String>() ?? data['insights'] as List? ?? [];
    final coachingTips = (data['coaching_tips'] as List?)?.cast<String>() ?? [];

    // Sort by performance score descending
    staff.sort(
      (a, b) =>
          ((b['score'] ?? b['performance_score'] ?? 0) as num).compareTo((a['score'] ?? a['performance_score'] ?? 0) as num),
    );

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leaderboard
          Text(l10n.wameedAILeaderboard, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),

          if (staff.isEmpty)
            PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.people_outline)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: staff.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final member = staff[index];
                return _buildStaffCard(member, index, l10n);
              },
            ),

          // Team insights
          if (teamInsights.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.insights, size: 20, color: AppColors.info),
                const SizedBox(width: 8),
                Text(
                  l10n.wameedAITeamInsights,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...teamInsights.map(
              (insight) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6, right: 10),
                      decoration: const BoxDecoration(color: AppColors.info, shape: BoxShape.circle),
                    ),
                    Expanded(child: Text('$insight', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],

          // Coaching tips
          if (coachingTips.isNotEmpty) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                const Icon(Icons.school_outlined, size: 20, color: AppColors.success),
                const SizedBox(width: 8),
                Text(
                  l10n.wameedAICoachingTips,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...coachingTips.map(
              (tip) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.success.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 16, color: AppColors.success),
                    const SizedBox(width: 8),
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
    final totalSales = member['total_sales'] ?? member['sales_count'] ?? 0;
    final revenue = member['revenue'] ?? member['total_revenue'] ?? 0;
    final avgTransaction = member['avg_transaction'] ?? member['avg_basket'] ?? 0;
    final feedback = member['feedback'] ?? member['coaching'] ?? '';

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
        borderRadius: BorderRadius.circular(12),
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
          const SizedBox(width: 12),

          // Staff info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name.toString(), style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _metricChip(context, Icons.receipt, '$totalSales sales'),
                    const SizedBox(width: 8),
                    _metricChip(context, Icons.attach_money, '\$$revenue'),
                    if (avgTransaction != 0) ...[
                      const SizedBox(width: 8),
                      _metricChip(context, Icons.shopping_basket, 'Avg: \$$avgTransaction'),
                    ],
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
