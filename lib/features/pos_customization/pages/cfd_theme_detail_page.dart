import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/core/widgets/pos_error_state.dart';
import 'package:wameedpos/core/widgets/pos_loading_skeleton.dart';
import 'package:wameedpos/features/pos_customization/models/cfd_theme.dart';
import 'package:wameedpos/features/pos_customization/providers/template_browse_providers.dart';

class CfdThemeDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const CfdThemeDetailPage({super.key, required this.slug});

  @override
  ConsumerState<CfdThemeDetailPage> createState() => _CfdThemeDetailPageState();
}

class _CfdThemeDetailPageState extends ConsumerState<CfdThemeDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cfdThemeDetailProvider(widget.slug).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cfdThemeDetailProvider(widget.slug));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cfdThemeDetail)),
      floatingActionButton: switch (state) {
        CfdThemeDetailLoaded(:final theme) => FloatingActionButton.extended(
          onPressed: () => context.push('${Routes.cfdThemePreview}/${theme.id}?name=${Uri.encodeComponent(theme.name)}'),
          icon: const Icon(Icons.visibility_rounded),
          label: Text(l10n.templatePreviewButton),
        ),
        _ => null,
      },
      body: switch (state) {
        CfdThemeDetailInitial() || CfdThemeDetailLoading() => PosLoadingSkeleton.list(),
        CfdThemeDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(cfdThemeDetailProvider(widget.slug).notifier).load(),
        ),
        CfdThemeDetailLoaded(:final theme) => _buildDetail(theme, l10n),
      },
    );
  }

  Widget _buildDetail(CfdTheme theme, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = _parseColor(theme.backgroundColor);
    final txtColor = _parseColor(theme.textColor);
    final accentColor = _parseColor(theme.accentColor);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          PosCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: const Icon(Icons.tv_rounded, color: AppColors.primary, size: 28),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(theme.name, style: AppTypography.titleLarge),
                          AppSpacing.gapH4,
                          Text(
                            theme.slug,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppSpacing.gapH16,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (theme.isActive == true) PosBadge(label: l10n.cfdThemeActive, variant: PosBadgeVariant.success),
                    if (theme.cartLayout != null)
                      PosBadge(label: '${l10n.cfdThemeCartLayout}: ${theme.cartLayout!.value}', variant: PosBadgeVariant.info),
                    if (theme.idleLayout != null)
                      PosBadge(label: '${l10n.cfdThemeIdleLayout}: ${theme.idleLayout!.value}', variant: PosBadgeVariant.primary),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,

          // Color palette preview
          PosCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.palette_rounded, size: 20, color: AppColors.primary),
                    AppSpacing.gapW8,
                    Text(l10n.cfdThemeColorPalette, style: AppTypography.titleSmall),
                  ],
                ),
                AppSpacing.gapH16,
                // Live preview
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: AppRadius.borderMd,
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.cfdThemePreviewTitle,
                          style: TextStyle(color: txtColor, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        AppSpacing.gapH4,
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(color: accentColor, borderRadius: BorderRadius.circular(4)),
                          child: Text(l10n.cfdThemePreviewButton, style: const TextStyle(color: Colors.white, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
                AppSpacing.gapH16,
                // Color details
                Row(
                  children: [
                    _colorDetail(l10n.cfdThemeBackground, theme.backgroundColor, bgColor),
                    AppSpacing.gapW16,
                    _colorDetail(l10n.cfdThemeText, theme.textColor, txtColor),
                    AppSpacing.gapW16,
                    _colorDetail(l10n.cfdThemeAccent, theme.accentColor, accentColor),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,

          // Display settings
          PosCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 20, color: AppColors.primary),
                    AppSpacing.gapW8,
                    Text(l10n.cfdThemeDisplaySettings, style: AppTypography.titleSmall),
                  ],
                ),
                AppSpacing.gapH12,
                _settingRow(l10n.cfdThemeFontFamily, theme.fontFamily ?? 'system', isDark),
                _settingRow(l10n.cfdThemeCartLayout, theme.cartLayout?.value ?? '-', isDark),
                _settingRow(l10n.cfdThemeIdleLayout, theme.idleLayout?.value ?? '-', isDark),
                _settingRow(l10n.cfdThemeAnimation, theme.animationStyle?.value ?? '-', isDark),
                _settingRow(l10n.cfdThemeTransition, '${theme.transitionSeconds ?? 5}s', isDark),
                _settingRow(l10n.cfdThemeThankYou, theme.thankYouAnimation?.value ?? '-', isDark),
                _settingRow(l10n.cfdThemeShowLogo, theme.showStoreLogo == true ? l10n.cfdThemeYes : l10n.cfdThemeNo, isDark),
                _settingRow(l10n.cfdThemeShowTotal, theme.showRunningTotal == true ? l10n.cfdThemeYes : l10n.cfdThemeNo, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _colorDetail(String label, String hex, Color color) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
          ),
          AppSpacing.gapH4,
          Text(label, style: AppTypography.micro),
          Text(hex, style: AppTypography.micro.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _settingRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
          AppSpacing.gapW8,
          Expanded(flex: 3, child: Text(value, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) return Color(int.parse('FF$cleaned', radix: 16));
    if (cleaned.length == 8) return Color(int.parse(cleaned, radix: 16));
    return Colors.grey;
  }
}
