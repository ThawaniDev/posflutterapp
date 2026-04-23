import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_markdown_text.dart';

class CustomerSegmentsPage extends ConsumerStatefulWidget {
  const CustomerSegmentsPage({super.key});

  @override
  ConsumerState<CustomerSegmentsPage> createState() => _CustomerSegmentsPageState();
}

class _CustomerSegmentsPageState extends ConsumerState<CustomerSegmentsPage> {
  String? _selectedSegment;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeatureResultProvider.notifier).invoke('customer_segmentation');
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;

    return PosListPage(
      title: l10n.wameedAICustomerSegments,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.refresh,
          onPressed: () {
            setState(() => _selectedSegment = null);
            ref.read(aiFeatureResultProvider.notifier).invoke('customer_segmentation');
          },
          tooltip: l10n.commonRefresh,
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
                onPressed: () => ref.read(aiFeatureResultProvider.notifier).invoke('customer_segmentation'),
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
        child: PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.people_outline),
      );
    }

    final segments = (data['segments'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    // Backend doesn't return total_customers — compute from segments
    final totalCustomers =
        data['total_customers'] ?? segments.fold<num>(0, (sum, s) => sum + ((s['customer_count'] ?? s['count'] ?? 0) as num));
    // Backend returns 'summary_ar' as a string
    final summaryText = data['summary_ar']?.toString() ?? '';

    return SingleChildScrollView(
      padding: context.responsivePagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total customers header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.03)],
              ),
              borderRadius: AppRadius.borderLg,
            ),
            child: Row(
              children: [
                const Icon(Icons.groups, size: 36, color: AppColors.primary),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.wameedAITotalCustomers,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                    ),
                    Text(
                      '$totalCustomers',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${segments.length} ${l10n.wameedAISegments}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,

          // AI summary
          if (summaryText.isNotEmpty) ...[
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
            AppSpacing.gapH16,
          ],

          // Segment cards
          Text(
            l10n.wameedAICustomerSegments,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          AppSpacing.gapH12,

          if (segments.isEmpty)
            PosEmptyState(title: l10n.wameedAINoResults, icon: Icons.people_outline)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: isMobile ? 2.2 : 2.5,
              ),
              itemCount: segments.length,
              itemBuilder: (context, index) {
                final segment = segments[index];
                return _buildSegmentCard(segment, index, l10n);
              },
            ),

          // Detail view for selected segment
          if (_selectedSegment != null) ...[AppSpacing.gapH24, _buildSegmentDetail(segments, l10n)],
        ],
      ),
    );
  }

  Widget _buildSegmentCard(Map<String, dynamic> segment, int index, AppLocalizations l10n) {
    final name = segment['name'] ?? segment['segment_name'] ?? 'Segment ${index + 1}';
    final count = segment['customer_count'] ?? segment['count'] ?? 0;
    final avgSpend = segment['avg_spend'] ?? segment['average_spend'] ?? 0;
    final description = segment['description'] ?? segment['marketing_strategy_ar'] ?? '';
    final isSelected = _selectedSegment == name;
    final colors = [AppColors.primary, AppColors.success, AppColors.info, AppColors.warning, AppColors.error];
    final color = colors[index % colors.length];

    return InkWell(
      onTap: () => setState(() => _selectedSegment = isSelected ? null : name.toString()),
      borderRadius: AppRadius.borderLg,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Theme.of(context).cardColor,
          borderRadius: AppRadius.borderLg,
          border: Border.all(color: isSelected ? color : Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
                  child: Icon(Icons.group, size: 18, color: color),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    name.toString(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  '$count',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: color),
                ),
              ],
            ),
            AppSpacing.gapH8,
            if (description.toString().isNotEmpty)
              Text(
                description.toString(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '${l10n.wameedAIAvgSpend}: \$$avgSpend',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Icon(isSelected ? Icons.expand_less : Icons.expand_more, size: 18, color: Theme.of(context).hintColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentDetail(List<Map<String, dynamic>> segments, AppLocalizations l10n) {
    final segment = segments.firstWhere((s) => (s['name'] ?? s['segment_name']) == _selectedSegment, orElse: () => {});

    if (segment.isEmpty) return const SizedBox.shrink();

    final characteristics = (segment['characteristics'] as List?)?.cast<String>() ?? [];
    final marketingStrategy = segment['marketing_strategy_ar']?.toString() ?? '';
    final promotionIdeas = (segment['promotion_ideas'] as List?)?.cast<String>() ?? segment['suggestions'] as List? ?? [];
    final topProducts = (segment['top_products'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final avgVisits = segment['avg_visits'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_selectedSegment!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          if (avgVisits != null) ...[
            AppSpacing.gapH4,
            Text(
              '${l10n.wameedAIAvgVisits}: $avgVisits',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
          AppSpacing.gapH16,

          // Marketing strategy from AI
          if (marketingStrategy.isNotEmpty) ...[
            Text(
              l10n.wameedAIPromotionIdeas,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.05),
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.campaign_outlined, size: 16, color: AppColors.warning),
                  AppSpacing.gapW8,
                  Expanded(child: AIMarkdownText(marketingStrategy)),
                ],
              ),
            ),
            AppSpacing.gapH16,
          ],

          if (characteristics.isNotEmpty) ...[
            Text(
              l10n.wameedAICharacteristics,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: characteristics
                  .map(
                    (c) => Chip(
                      label: Text(c, style: const TextStyle(fontSize: 12)),
                      visualDensity: VisualDensity.compact,
                    ),
                  )
                  .toList(),
            ),
            AppSpacing.gapH16,
          ],

          if (topProducts.isNotEmpty) ...[
            Text(l10n.wameedAITopProducts, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            AppSpacing.gapH8,
            ...topProducts
                .take(5)
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: AppColors.primary),
                        AppSpacing.gapW8,
                        Expanded(child: Text(p['name']?.toString() ?? '', style: Theme.of(context).textTheme.bodyMedium)),
                        if (p['count'] != null)
                          Text(
                            '${p['count']}x',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                      ],
                    ),
                  ),
                ),
            AppSpacing.gapH16,
          ],

          if (promotionIdeas.isNotEmpty) ...[
            Text(
              l10n.wameedAIPromotionIdeas,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            AppSpacing.gapH8,
            ...promotionIdeas.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.campaign_outlined, size: 16, color: AppColors.warning),
                    AppSpacing.gapW8,
                    Expanded(child: Text('$p', style: Theme.of(context).textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
