import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.people_outline, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAICustomerSegments),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () {
              setState(() => _selectedSegment = null);
              ref.read(aiFeatureResultProvider.notifier).invoke('customer_segmentation');
            },
          ),
        ],
      ),
      body: switch (state) {
        AIFeatureResultInitial() || AIFeatureResultLoading() => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Analyzing customer data...')],
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
    final totalCustomers = data['total_customers'] ?? 0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
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
              borderRadius: BorderRadius.circular(12),
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
          const SizedBox(height: 20),

          // Segment cards
          Text(
            l10n.wameedAICustomerSegments,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

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
          if (_selectedSegment != null) ...[const SizedBox(height: 24), _buildSegmentDetail(segments, l10n)],
        ],
      ),
    );
  }

  Widget _buildSegmentCard(Map<String, dynamic> segment, int index, AppLocalizations l10n) {
    final name = segment['name'] ?? segment['segment_name'] ?? 'Segment ${index + 1}';
    final count = segment['customer_count'] ?? segment['count'] ?? 0;
    final avgSpend = segment['avg_spend'] ?? segment['average_spend'] ?? 0;
    final description = segment['description'] ?? '';
    final isSelected = _selectedSegment == name;
    final colors = [AppColors.primary, AppColors.success, AppColors.info, AppColors.warning, AppColors.error];
    final color = colors[index % colors.length];

    return InkWell(
      onTap: () => setState(() => _selectedSegment = isSelected ? null : name.toString()),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
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
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
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
            const SizedBox(height: 8),
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
    final promotionIdeas = (segment['promotion_ideas'] as List?)?.cast<String>() ?? segment['suggestions'] as List? ?? [];
    final topProducts = (segment['top_products'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_selectedSegment!, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),

          if (characteristics.isNotEmpty) ...[
            Text(
              l10n.wameedAICharacteristics,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 16),
          ],

          if (topProducts.isNotEmpty) ...[
            Text(l10n.wameedAITopProducts, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...topProducts
                .take(5)
                .map(
                  (p) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: AppColors.primary),
                        const SizedBox(width: 8),
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
            const SizedBox(height: 16),
          ],

          if (promotionIdeas.isNotEmpty) ...[
            Text(
              l10n.wameedAIPromotionIdeas,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...promotionIdeas.map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.campaign_outlined, size: 16, color: AppColors.warning),
                    const SizedBox(width: 8),
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
