import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/layout_builder/providers/layout_builder_providers.dart';
import 'package:wameedpos/features/layout_builder/providers/layout_builder_state.dart';

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
    final isLoading = state is LayoutTemplatesInitial || state is LayoutTemplatesLoading;
    final hasError = state is LayoutTemplatesError;
    final isEmpty = state is LayoutTemplatesLoaded && state.templates.isEmpty;

    return PosListPage(
      title: l10n.layoutTemplates,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(layoutTemplatesProvider.notifier).load(),
      isEmpty: isEmpty,
      emptyIcon: Icons.dashboard_customize_outlined,
      emptyTitle: l10n.layoutNoTemplates,
      emptySubtitle: l10n.layoutNoTemplatesSubtitle,
      actions: [
        PosButton.icon(icon: Icons.store_rounded, tooltip: l10n.layoutMarketplace, onPressed: () => context.push('/marketplace')),
        PosButton(
          label: l10n.layoutOpenBuilder,
          icon: Icons.dashboard_customize_rounded,
          size: PosButtonSize.sm,
          onPressed: () => context.push('/layout-builder'),
        ),
      ],
      child: state is LayoutTemplatesLoaded
          ? RefreshIndicator(
              onRefresh: () => ref.read(layoutTemplatesProvider.notifier).load(),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 380,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: state.templates.length,
                itemBuilder: (context, index) {
                  final template = state.templates[index];
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
                              child: Text(name, style: AppTypography.titleSmall, maxLines: 1, overflow: TextOverflow.ellipsis),
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
                                color: AppColors.mutedFor(context),
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
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _previewPlaceholder(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.grid_view_rounded, size: 40, color: AppColors.mutedFor(context)),
          AppSpacing.gapH4,
          Text(
            'Layout Preview',
            style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
          ),
        ],
      ),
    );
  }
}
