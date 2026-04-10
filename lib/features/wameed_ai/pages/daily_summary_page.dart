import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_insight_mini_card.dart';

class DailySummaryPage extends ConsumerStatefulWidget {
  const DailySummaryPage({super.key});

  @override
  ConsumerState<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends ConsumerState<DailySummaryPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('daily_summary');
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
            const Icon(Icons.summarize_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAIDailySummary),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: l10n.wameedAICopyResult,
            onPressed: () {
              final s = ref.read(aiFeatureResultProvider);
              if (s is AIFeatureResultLoaded) {
                final text = s.result.data?['summary']?.toString() ?? s.result.message ?? '';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.wameedAICopied)));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('daily_summary'),
          ),
        ],
      ),
      body: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Generating daily summary...')],
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
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('daily_summary'),
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
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.summarize_outlined),
      );
    }

    final summary = data['summary']?.toString() ?? '';
    final kpis = data['kpis'] as Map<String, dynamic>? ?? {};
    final highlights = (data['highlights'] as List?)?.cast<String>() ?? [];
    final concerns = (data['concerns'] as List?)?.cast<String>() ?? [];
    final recommendations = (data['recommendations'] as List?)?.cast<String>() ?? [];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI cards
          if (kpis.isNotEmpty) ...[
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMobile ? 1.5 : 1.8,
              children: [
                if (kpis['total_revenue'] != null)
                  AIInsightMiniCard(
                    title: l10n.wameedAITotalRevenue,
                    value: '\$${kpis['total_revenue']}',
                    icon: Icons.attach_money,
                    color: AppColors.success,
                    trend: kpis['revenue_change']?.toString(),
                  ),
                if (kpis['total_transactions'] != null)
                  AIInsightMiniCard(
                    title: l10n.wameedAITransactions,
                    value: '${kpis['total_transactions']}',
                    icon: Icons.receipt_long,
                    color: AppColors.info,
                    trend: kpis['transactions_change']?.toString(),
                  ),
                if (kpis['avg_basket'] != null)
                  AIInsightMiniCard(
                    title: l10n.wameedAIAvgBasket,
                    value: '\$${kpis['avg_basket']}',
                    icon: Icons.shopping_basket,
                    color: AppColors.primary,
                  ),
                if (kpis['items_sold'] != null)
                  AIInsightMiniCard(
                    title: l10n.wameedAIItemsSold,
                    value: '${kpis['items_sold']}',
                    icon: Icons.inventory,
                    color: AppColors.warning,
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],

          // Summary text
          if (summary.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        l10n.wameedAISummary,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SelectableText(summary, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Highlights
          if (highlights.isNotEmpty) ...[
            _sectionTitle(context, Icons.star_outline, l10n.wameedAIHighlights, AppColors.success),
            const SizedBox(height: 8),
            ...highlights.map((h) => _bulletItem(context, h, AppColors.success)),
            const SizedBox(height: 20),
          ],

          // Concerns
          if (concerns.isNotEmpty) ...[
            _sectionTitle(context, Icons.warning_amber_outlined, l10n.wameedAIConcerns, AppColors.warning),
            const SizedBox(height: 8),
            ...concerns.map((c) => _bulletItem(context, c, AppColors.warning)),
            const SizedBox(height: 20),
          ],

          // Recommendations
          if (recommendations.isNotEmpty) ...[
            _sectionTitle(context, Icons.lightbulb_outline, l10n.wameedAIRecommendations, AppColors.info),
            const SizedBox(height: 8),
            ...recommendations.map((r) => _bulletItem(context, r, AppColors.info)),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _bulletItem(BuildContext context, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 6, right: 10),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
