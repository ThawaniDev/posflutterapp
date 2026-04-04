import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_badge.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/core/widgets/pos_empty_state.dart';
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/features/pos_customization/models/label_layout_template.dart';
import 'package:thawani_pos/features/pos_customization/providers/template_browse_providers.dart';

class LabelTemplatesBrowsePage extends ConsumerStatefulWidget {
  const LabelTemplatesBrowsePage({super.key});

  @override
  ConsumerState<LabelTemplatesBrowsePage> createState() => _LabelTemplatesBrowsePageState();
}

class _LabelTemplatesBrowsePageState extends ConsumerState<LabelTemplatesBrowsePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(labelLayoutListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(labelLayoutListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labelLayoutTemplatesTitle)),
      body: switch (state) {
        LabelLayoutListInitial() || LabelLayoutListLoading() => PosLoadingSkeleton.list(),
        LabelLayoutListError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(labelLayoutListProvider.notifier).load(),
        ),
        LabelLayoutListLoaded(:final templates) when templates.isEmpty => PosEmptyState(
          icon: Icons.label_outlined,
          title: l10n.labelLayoutTemplatesEmpty,
          subtitle: l10n.labelLayoutTemplatesEmptySubtitle,
        ),
        LabelLayoutListLoaded(:final templates) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) => _buildTemplateCard(templates[index], l10n, isDark),
        ),
      },
    );
  }

  Widget _buildTemplateCard(LabelLayoutTemplate template, AppLocalizations l10n, bool isDark) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isAr ? template.nameAr : template.name;

    return GestureDetector(
      onTap: () => context.push('${Routes.labelLayoutTemplates}/${template.slug}'),
      child: PosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview area
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.label_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
                        AppSpacing.gapH8,
                        Text(
                          '${template.labelWidthMm}×${template.labelHeightMm}mm',
                          style: AppTypography.labelSmall.copyWith(
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: AppTypography.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    AppSpacing.gapH4,
                    Text(
                      template.slug,
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        PosBadge(label: template.labelType.value, variant: PosBadgeVariant.info),
                        PosBadge(label: '${template.labelWidthMm}×${template.labelHeightMm}mm', variant: PosBadgeVariant.neutral),
                        if (template.isActive == true)
                          PosBadge(label: l10n.labelLayoutTemplateActive, variant: PosBadgeVariant.success),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
