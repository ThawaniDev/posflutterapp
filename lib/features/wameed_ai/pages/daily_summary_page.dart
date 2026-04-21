import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_insight_mini_card.dart';

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

    return PosListPage(
  title: l10n.wameedAIDailySummary,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.copy, onPressed: () {
              final s = ref.read(aiFeatureResultProvider);
              if (s is AIFeatureResultLoaded) {
                final text = s.result.data?['narrative_ar']?.toString() ?? s.result.message ?? '';
                Clipboard.setData(ClipboardData(text: text));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.wameedAICopied)));
              }
            }, tooltip: l10n.wameedAICopyResult,
  ),
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('daily_summary'), tooltip: l10n.commonRefresh,
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

    final headlineAr = data['headline_ar']?.toString() ?? '';
    final revenue = (data['revenue'] as num?)?.toDouble() ?? 0;
    final transactionCount = (data['transaction_count'] as num?)?.toInt() ?? 0;
    final avgBasket = (data['avg_basket'] as num?)?.toDouble() ?? 0;
    final narrativeAr = data['narrative_ar']?.toString() ?? '';
    final topProducts = (data['top_products'] as List?) ?? [];
    final alerts = (data['alerts'] as List?) ?? [];
    final comparison = data['comparison_yesterday'] as Map<String, dynamic>? ?? {};
    final recommendationsAr = (data['recommendations_ar'] as List?)?.cast<String>() ?? [];

    // No data case — show empty state with message
    if (transactionCount == 0 && revenue == 0) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.receipt_long_outlined, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.5)),
              AppSpacing.gapH16,
              if (headlineAr.isNotEmpty)
                Text(
                  headlineAr,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              if (narrativeAr.isNotEmpty) ...[
                AppSpacing.gapH12,
                Text(
                  narrativeAr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Revenue change percentage
    String? revenueChange;
    if (comparison['revenue_change'] != null) {
      final change = (comparison['revenue_change'] as num).toDouble();
      revenueChange = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
    } else if (comparison['revenue_change_pct'] != null) {
      final change = (comparison['revenue_change_pct'] as num).toDouble();
      revenueChange = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
    }

    String? txnChange;
    if (comparison['transaction_count_change'] != null) {
      final change = (comparison['transaction_count_change'] as num).toDouble();
      txnChange = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
    } else if (comparison['transaction_count_change_pct'] != null) {
      final change = (comparison['transaction_count_change_pct'] as num).toDouble();
      txnChange = '${change >= 0 ? '+' : ''}${change.toStringAsFixed(1)}%';
    }

    return SingleChildScrollView(
      padding: context.responsivePagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Headline
          if (headlineAr.isNotEmpty) ...[
            Text(headlineAr, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.gapH16,
          ],

          // KPI cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: isMobile ? 2 : 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: isMobile ? 1.0 : 1.8,
            children: [
              AIInsightMiniCard(
                title: l10n.wameedAITotalRevenue,
                value: revenue.toStringAsFixed(2),
                icon: Icons.attach_money,
                color: AppColors.success,
                trend: revenueChange,
              ),
              AIInsightMiniCard(
                title: l10n.wameedAITransactions,
                value: '$transactionCount',
                icon: Icons.receipt_long,
                color: AppColors.info,
                trend: txnChange,
              ),
              AIInsightMiniCard(
                title: l10n.wameedAIAvgBasket,
                value: avgBasket.toStringAsFixed(2),
                icon: Icons.shopping_basket,
                color: AppColors.primary,
              ),
              if (topProducts.isNotEmpty)
                AIInsightMiniCard(
                  title: l10n.wameedAIItemsSold,
                  value: '${topProducts.length}',
                  icon: Icons.inventory,
                  color: AppColors.warning,
                ),
            ],
          ),
          AppSpacing.gapH24,

          // AI Narrative
          if (narrativeAr.isNotEmpty) ...[
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
                      const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                      AppSpacing.gapW8,
                      Text(
                        l10n.wameedAISummary,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  AppSpacing.gapH12,
                  SelectableText(narrativeAr, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
                ],
              ),
            ),
            AppSpacing.gapH20,
          ],

          // Top Products
          if (topProducts.isNotEmpty) ...[
            _sectionTitle(context, Icons.star_outline, l10n.wameedAIHighlights, AppColors.success),
            AppSpacing.gapH8,
            ...topProducts.take(10).map((p) {
              final product = p as Map<String, dynamic>;
              final name = product['name_ar']?.toString() ?? product['name']?.toString() ?? '';
              final qty = (product['qty_sold'] as num?)?.toStringAsFixed(0) ?? '';
              final rev = (product['revenue'] as num?)?.toStringAsFixed(2) ?? '';
              return _bulletItem(context, '$name — $qty ${l10n.wameedAIItemsSold}, $rev', AppColors.success);
            }),
            AppSpacing.gapH20,
          ],

          // Alerts / Concerns
          if (alerts.isNotEmpty) ...[
            _sectionTitle(context, Icons.warning_amber_outlined, l10n.wameedAIConcerns, AppColors.warning),
            AppSpacing.gapH8,
            ...alerts.map((a) => _bulletItem(context, a.toString(), AppColors.warning)),
            AppSpacing.gapH20,
          ],

          // Recommendations
          if (recommendationsAr.isNotEmpty) ...[
            _sectionTitle(context, Icons.lightbulb_outline, l10n.wameedAIRecommendations, AppColors.info),
            AppSpacing.gapH8,
            ...recommendationsAr.map((r) => _bulletItem(context, r, AppColors.info)),
          ],
        ],
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, IconData icon, String title, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        AppSpacing.gapW8,
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
