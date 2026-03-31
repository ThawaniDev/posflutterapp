import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_empty_state.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/features/layout_builder/providers/layout_builder_providers.dart';
import 'package:thawani_pos/features/layout_builder/providers/layout_builder_state.dart';

class LayoutTemplateListPage extends ConsumerStatefulWidget {
  const LayoutTemplateListPage({super.key});

  @override
  ConsumerState<LayoutTemplateListPage> createState() => _LayoutTemplateListPageState();
}

class _LayoutTemplateListPageState extends ConsumerState<LayoutTemplateListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(layoutTemplatesProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(layoutTemplatesProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.layoutTemplates),
        actions: [
          PosButton.icon(
            icon: Icons.store_rounded,
            tooltip: l10n.layoutMarketplace,
            onPressed: () => context.push('/marketplace'),
          ),
          AppSpacing.gapW8,
          PosButton(
            label: l10n.layoutOpenBuilder,
            icon: Icons.dashboard_customize_rounded,
            size: PosButtonSize.sm,
            onPressed: () => context.push('/layout-builder'),
          ),
          AppSpacing.gapW16,
        ],
      ),
      body: switch (state) {
        LayoutTemplatesInitial() || LayoutTemplatesLoading() => PosLoadingSkeleton.list(),
        LayoutTemplatesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(layoutTemplatesProvider.notifier).load(),
        ),
        LayoutTemplatesLoaded(:final templates) =>
          templates.isEmpty
              ? PosEmptyState(
                  icon: Icons.dashboard_customize_outlined,
                  title: l10n.layoutNoTemplates,
                  subtitle: l10n.layoutNoTemplatesSubtitle,
                  actionLabel: l10n.layoutOpenBuilder,
                  onAction: () => context.push('/layout-builder'),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(layoutTemplatesProvider.notifier).load(),
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 380,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      final name = (isAr && template.nameAr.isNotEmpty) ? template.nameAr : template.name;

                      return PosCard(
                        onTap: () => context.push('/layout-builder'),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Preview area
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : AppColors.inputBgLight,
                                  borderRadius: AppRadius.borderMd,
                                ),
                                child: template.previewImageUrl != null
                                    ? ClipRRect(
                                        borderRadius: AppRadius.borderMd,
                                        child: Image.network(
                                          template.previewImageUrl!,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => _previewPlaceholder(isDark),
                                        ),
                                      )
                                    : _previewPlaceholder(isDark),
                              ),
                            ),
                            AppSpacing.gapH8,
                            // Name + badges
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: AppTypography.titleSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (template.isDefault)
                                  PosBadge(label: l10n.layoutDefault, variant: PosBadgeVariant.primary, isSmall: true),
                              ],
                            ),
                            AppSpacing.gapH4,
                            // Layout key + status
                            Row(
                              children: [
                                Text(
                                  template.layoutKey.replaceAll('_', ' '),
                                  style: AppTypography.micro.copyWith(
                                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                  ),
                                ),
                                const Spacer(),
                                PosBadge(
                                  label: template.isActive ? l10n.layoutActive : l10n.layoutInactive,
                                  variant: template.isActive ? PosBadgeVariant.success : PosBadgeVariant.neutral,
                                  isSmall: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
      },
    );
  }

  Widget _previewPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, size: 40, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          AppSpacing.gapH4,
          Text(
            'Layout Preview',
            style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
      ),
    );
  }
}
