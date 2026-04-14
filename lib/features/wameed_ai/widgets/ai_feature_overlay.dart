import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_state.dart';

class AIFeatureOverlay extends ConsumerWidget {
  final void Function(String slug, String displayName) onFeatureSelected;

  const AIFeatureOverlay({super.key, required this.onFeatureSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(aiFeatureCardsProvider);
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.hintColor.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
                    const SizedBox(width: 8),
                    Text(AppLocalizations.of(context)!.wameedAIFeatures, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Divider(color: theme.dividerColor),
              // Content
              Expanded(
                child: switch (cardsState) {
                  AIFeatureCardsInitial() || AIFeatureCardsLoading() => const PosLoading(),
                  AIFeatureCardsError(:final message) => Center(child: Text(message)),
                  AIFeatureCardsLoaded(:final categories) => _buildCategoriesList(categories, scrollController, theme),
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoriesList(List<Map<String, dynamic>> categories, ScrollController scrollController, ThemeData theme) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        final categoryName = category['category'] as String? ?? '';
        final features = (category['features'] as List<dynamic>?) ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Icon(_categoryIcon(categoryName), color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _formatCategoryName(categoryName),
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: features.map((f) {
                final feature = AIFeatureCard.fromJson(f as Map<String, dynamic>);
                return ActionChip(
                  avatar: const Icon(Icons.auto_awesome, size: 16),
                  label: Text(feature.displayName),
                  labelStyle: theme.textTheme.bodySmall,
                  backgroundColor: theme.cardColor,
                  side: BorderSide(color: theme.dividerColor),
                  onPressed: () => onFeatureSelected(feature.slug, feature.displayName),
                );
              }).toList(),
            ),
            if (index < categories.length - 1) const SizedBox(height: 4),
          ],
        );
      },
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'inventory' => Icons.inventory_2_outlined,
      'sales' => Icons.trending_up_rounded,
      'operations' => Icons.settings_outlined,
      'catalog' => Icons.category_outlined,
      'customer' => Icons.people_outline,
      'communication' => Icons.campaign_outlined,
      'financial' => Icons.account_balance_wallet_outlined,
      'platform' => Icons.dashboard_outlined,
      _ => Icons.auto_awesome,
    };
  }

  String _formatCategoryName(String name) {
    if (name.isEmpty) return name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
}
