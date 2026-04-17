import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_urgency_card.dart';

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

    return PosListPage(
  title: l10n.wameedAISmartReorder,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh, onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('smart_reorder'), tooltip: l10n.commonRefresh,
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

    // Backend returns 'recommendations' as main list, or 'suggestions' for no-data fallback
    final suggestions =
        (data['suggestions'] as List?)?.cast<Map<String, dynamic>>() ??
        (data['recommendations'] as List?)?.cast<Map<String, dynamic>>() ??
        [];
    // Backend returns 'summary' as a string (Arabic), not a map
    final summaryText = data['summary']?.toString() ?? data['summary_ar']?.toString() ?? '';

    return SingleChildScrollView(
      padding: context.responsivePagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary chips
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _summaryChip(context, Icons.warning_amber, l10n.wameedAILowStock, '${suggestions.length}', AppColors.warning),
            ],
          ),
          AppSpacing.gapH20,

          // AI summary text
          if (summaryText.isNotEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
              ),
              child: SelectableText(summaryText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6)),
            ),
            AppSpacing.gapH20,
          ],

          // Reorder items
          Text(
            l10n.wameedAIReorderSuggestions,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapH12,
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
                final productName = item['product_name'] ?? item['name'] ?? item['product'] ?? l10n.wameedAIUnknownProduct;
                final currentStock = item['current_stock'] ?? item['stock_level'] ?? 0;
                final recommendedQty =
                    item['suggested_order_quantity'] ?? item['recommended_quantity'] ?? item['reorder_qty'] ?? 0;
                final urgency = item['urgency'] ?? 'medium';
                final reason = item['reason'] ?? '';
                final avgDailySales = item['avg_daily_sales'] ?? item['daily_sales'];
                final daysOfStock = item['days_of_stock'] ?? item['stock_days'];
                final supplier = item['preferred_supplier'] ?? item['supplier'];

                return AIUrgencyCard(
                  title: '$productName',
                  subtitle: reason.toString(),
                  urgency: urgency.toString(),
                  icon: Icons.inventory_2_outlined,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: [
                        _infoChip(context, '${l10n.wameedAIStock}: $currentStock'),
                        _infoChip(context, '${l10n.wameedAIOrder}: $recommendedQty', highlight: true),
                        if (avgDailySales != null) _infoChip(context, '${l10n.wameedAIAvgPerDay}: $avgDailySales'),
                        if (daysOfStock != null) _infoChip(context, '$daysOfStock ${l10n.wameedAIDaysLeft}'),
                        if (supplier != null) _infoChip(context, '$supplier'),
                      ],
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _summaryChip(BuildContext context, IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          AppSpacing.gapW8,
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
        borderRadius: AppRadius.borderSm,
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
