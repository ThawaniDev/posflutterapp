import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_urgency_card.dart';

class SmartReorderPage extends ConsumerStatefulWidget {
  const SmartReorderPage({super.key});

  @override
  ConsumerState<SmartReorderPage> createState() => _SmartReorderPageState();
}

class _SmartReorderPageState extends ConsumerState<SmartReorderPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('smart_reorder');
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
            const Icon(Icons.shopping_cart_checkout, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAISmartReorder),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('smart_reorder'),
          ),
        ],
      ),
      body: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Analyzing inventory levels...')],
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
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('smart_reorder'),
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
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.inventory_2_outlined),
      );
    }

    final suggestions = (data['suggestions'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final summary = data['summary'] as Map<String, dynamic>? ?? {};

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary cards
          if (summary.isNotEmpty) ...[
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _summaryChip(
                  context,
                  Icons.warning_amber,
                  'Low Stock',
                  '${summary['low_stock_count'] ?? suggestions.length}',
                  AppColors.warning,
                ),
                _summaryChip(context, Icons.trending_down, 'Critical', '${summary['critical_count'] ?? 0}', AppColors.error),
                _summaryChip(
                  context,
                  Icons.attach_money,
                  'Est. Value',
                  '\$${summary['estimated_value'] ?? 'N/A'}',
                  AppColors.info,
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // Reorder items
          Text(
            l10n.wameedAIReorderSuggestions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          if (suggestions.isEmpty)
            PosEmptyState(title: l10n.wameedAINoReorderNeeded, icon: Icons.check_circle_outline)
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: suggestions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = suggestions[index];
                final productName = item['product_name'] ?? item['product'] ?? 'Unknown Product';
                final currentStock = item['current_stock'] ?? item['stock_level'] ?? 0;
                final recommendedQty = item['recommended_quantity'] ?? item['reorder_qty'] ?? 0;
                final urgency = item['urgency'] ?? 'medium';
                final reason = item['reason'] ?? '';
                final avgDailySales = item['avg_daily_sales'] ?? item['daily_sales'];
                final daysOfStock = item['days_of_stock'] ?? item['stock_days'];

                return AIUrgencyCard(
                  title: '$productName',
                  subtitle: reason.toString(),
                  urgency: urgency.toString(),
                  icon: Icons.inventory_2_outlined,
                  children: [
                    Row(
                      children: [
                        _infoChip(context, 'Stock: $currentStock'),
                        const SizedBox(width: 8),
                        _infoChip(context, 'Order: $recommendedQty', highlight: true),
                        if (avgDailySales != null) ...[const SizedBox(width: 8), _infoChip(context, 'Avg/day: $avgDailySales')],
                        if (daysOfStock != null) ...[const SizedBox(width: 8), _infoChip(context, '$daysOfStock days left')],
                      ],
                    ),
                  ],
                );
              },
            ),

          // AI recommendations
          if (data['recommendations'] != null) ...[
            const SizedBox(height: 24),
            Text(
              l10n.wameedAIRecommendations,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...(data['recommendations'] as List).map(
              (rec) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lightbulb_outline, size: 18, color: AppColors.warning),
                    const SizedBox(width: 8),
                    Expanded(child: Text('$rec', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _summaryChip(BuildContext context, IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
              Text(
                value,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoChip(BuildContext context, String text, {bool highlight = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlight ? AppColors.primary.withValues(alpha: 0.1) : Theme.of(context).dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: highlight ? FontWeight.w600 : FontWeight.w500,
          color: highlight ? AppColors.primary : null,
        ),
      ),
    );
  }
}
