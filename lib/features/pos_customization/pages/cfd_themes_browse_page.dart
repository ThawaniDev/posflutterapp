import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_customization/models/cfd_theme.dart';
import 'package:wameedpos/features/pos_customization/providers/template_browse_providers.dart';

class CfdThemesBrowsePage extends ConsumerStatefulWidget {
  const CfdThemesBrowsePage({super.key});

  @override
  ConsumerState<CfdThemesBrowsePage> createState() => _CfdThemesBrowsePageState();
}

class _CfdThemesBrowsePageState extends ConsumerState<CfdThemesBrowsePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cfdThemeListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cfdThemeListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
  title: l10n.cfdThemesTitle,
  showSearch: false,
    child: switch (state) {
        CfdThemeListInitial() || CfdThemeListLoading() => PosLoadingSkeleton.list(),
        CfdThemeListError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(cfdThemeListProvider.notifier).load(),
        ),
        CfdThemeListLoaded(:final themes) when themes.isEmpty => PosEmptyState(
          icon: Icons.tv_outlined,
          title: l10n.cfdThemesEmpty,
          subtitle: l10n.cfdThemesEmptySubtitle,
        ),
        CfdThemeListLoaded(:final themes) => GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 360,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemCount: themes.length,
          itemBuilder: (context, index) => _buildThemeCard(themes[index], l10n, isDark),
        ),
      },
);
  }

  Widget _buildThemeCard(CfdTheme theme, AppLocalizations l10n, bool isDark) {
    final bgColor = _parseColor(theme.backgroundColor);
    final txtColor = _parseColor(theme.textColor);
    final accentColor = _parseColor(theme.accentColor);

    return GestureDetector(
      onTap: () => context.push('${Routes.cfdThemes}/${theme.slug}'),
      child: PosCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color preview
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Container(
                  color: bgColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.tv_rounded, size: 32, color: accentColor),
                      AppSpacing.gapH4,
                      Text(theme.name, style: AppTypography.labelSmall.copyWith(color: txtColor)),
                      AppSpacing.gapH8,
                      // Color swatches
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _colorSwatch(bgColor, 'BG'),
                          AppSpacing.gapW8,
                          _colorSwatch(txtColor, 'Text'),
                          AppSpacing.gapW8,
                          _colorSwatch(accentColor, 'Accent'),
                        ],
                      ),
                    ],
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
                    Text(theme.name, style: AppTypography.titleSmall, maxLines: 2, overflow: TextOverflow.ellipsis),
                    AppSpacing.gapH4,
                    Text(
                      theme.slug,
                      style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                    const Spacer(),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        if (theme.cartLayout != null) PosBadge(label: theme.cartLayout!.value, variant: PosBadgeVariant.info),
                        if (theme.idleLayout != null) PosBadge(label: theme.idleLayout!.value, variant: PosBadgeVariant.primary),
                        if (theme.animationStyle != null)
                          PosBadge(label: theme.animationStyle!.value, variant: PosBadgeVariant.neutral),
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

  Widget _colorSwatch(Color color, String label) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppRadius.borderXs,
            border: Border.all(color: Colors.white54),
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 8, color: Colors.white70)),
      ],
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) return Color(int.parse('FF$cleaned', radix: 16));
    if (cleaned.length == 8) return Color(int.parse(cleaned, radix: 16));
    return Colors.grey;
  }
}
