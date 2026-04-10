import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/enums/ai_feature_category.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_search_bar.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_usage_banner.dart';

class WameedAIHomePage extends ConsumerStatefulWidget {
  const WameedAIHomePage({super.key});

  @override
  ConsumerState<WameedAIHomePage> createState() => _WameedAIHomePageState();
}

class _WameedAIHomePageState extends ConsumerState<WameedAIHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiFeaturesProvider.notifier).load();
      ref.read(aiUsageProvider.notifier).load();
    });
  }

  String _featureRoute(String slug) {
    return switch (slug) {
      'smart_reorder' => Routes.wameedAISmartReorder,
      'expiry_manager' => Routes.wameedAIExpiryManager,
      'daily_summary' => Routes.wameedAIDailySummary,
      'customer_segmentation' => Routes.wameedAICustomerSegments,
      'invoice_ocr' => Routes.wameedAIInvoiceOCR,
      'staff_performance' => Routes.wameedAIStaffPerformance,
      'efficiency_score' => Routes.wameedAIEfficiencyScore,
      _ => '${Routes.wameedAI}/$slug',
    };
  }

  IconData _categoryIcon(AIFeatureCategory category) {
    return switch (category) {
      AIFeatureCategory.inventory => Icons.inventory_2_outlined,
      AIFeatureCategory.sales => Icons.trending_up_rounded,
      AIFeatureCategory.operations => Icons.settings_outlined,
      AIFeatureCategory.catalog => Icons.category_outlined,
      AIFeatureCategory.customer => Icons.people_outline,
      AIFeatureCategory.communication => Icons.campaign_outlined,
      AIFeatureCategory.financial => Icons.account_balance_wallet_outlined,
      AIFeatureCategory.platform => Icons.dashboard_outlined,
    };
  }

  String _categoryLabel(AIFeatureCategory category, AppLocalizations l10n) {
    return switch (category) {
      AIFeatureCategory.inventory => l10n.wameedAICategoryInventory,
      AIFeatureCategory.sales => l10n.wameedAICategorySales,
      AIFeatureCategory.operations => l10n.wameedAICategoryOperations,
      AIFeatureCategory.catalog => l10n.wameedAICategoryCatalog,
      AIFeatureCategory.customer => l10n.wameedAICategoryCustomer,
      AIFeatureCategory.communication => l10n.wameedAICategoryCommunication,
      AIFeatureCategory.financial => l10n.wameedAICategoryFinancial,
      AIFeatureCategory.platform => l10n.wameedAICategoryPlatform,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(aiFeaturesProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAI),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: l10n.wameedAIUsage,
            onPressed: () => context.push(Routes.wameedAIUsage),
          ),
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: l10n.wameedAISuggestions,
            onPressed: () => context.push(Routes.wameedAISuggestions),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.wameedAISettings,
            onPressed: () => context.push(Routes.wameedAISettings),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () {
              ref.read(aiFeaturesProvider.notifier).load();
              ref.read(aiUsageProvider.notifier).load();
            },
          ),
        ],
      ),
      body: switch (state) {
        AIFeaturesInitial() || AIFeaturesLoading() => const Center(child: CircularProgressIndicator()),
        AIFeaturesError(:final message) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 16),
                PosButton(label: l10n.commonRetry, onPressed: () => ref.read(aiFeaturesProvider.notifier).load()),
              ],
            ),
          ),
        AIFeaturesLoaded(:final features) => _buildBody(features, isMobile, l10n),
      },
    );
  }

  Widget _buildBody(List<AIFeatureDefinition> features, bool isMobile, AppLocalizations l10n) {
    final grouped = <AIFeatureCategory, List<AIFeatureDefinition>>{};
    for (final f in features) {
      (grouped[f.category] ??= []).add(f);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AISearchBar(),
          SizedBox(height: isMobile ? 16 : AppSpacing.lg),
          const AIUsageBanner(),
          SizedBox(height: isMobile ? 16 : AppSpacing.lg),
          ...grouped.entries.map((entry) => _buildCategorySection(entry.key, entry.value, isMobile, l10n)),
        ],
      ),
    );
  }

  Widget _buildCategorySection(AIFeatureCategory category, List<AIFeatureDefinition> features, bool isMobile, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(_categoryIcon(category), color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              _categoryLabel(category, l10n),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 2 : 4,
            childAspectRatio: isMobile ? 1.3 : 1.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: features.length,
          itemBuilder: (context, index) => _buildFeatureCard(features[index], l10n),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFeatureCard(AIFeatureDefinition feature, AppLocalizations l10n) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final name = isAr ? (feature.nameAr ?? feature.name) : feature.name;
    final desc = isAr ? (feature.descriptionAr ?? feature.description ?? '') : (feature.description ?? '');

    return InkWell(
      onTap: () => context.push(_featureRoute(feature.slug)),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                if (feature.isPremium) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 14, color: Colors.amber),
                ],
                const Spacer(),
                if (feature.storeConfig != null)
                  Icon(
                    feature.storeConfig!.isEnabled ? Icons.check_circle : Icons.pause_circle_outline,
                    size: 16,
                    color: feature.storeConfig!.isEnabled ? Colors.green : Colors.grey,
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Expanded(
              child: Text(desc, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor), maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}
