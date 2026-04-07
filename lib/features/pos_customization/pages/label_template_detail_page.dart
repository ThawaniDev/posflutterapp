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
import 'package:thawani_pos/core/widgets/pos_error_state.dart';
import 'package:thawani_pos/core/widgets/pos_loading_skeleton.dart';
import 'package:thawani_pos/features/pos_customization/models/label_layout_template.dart';
import 'package:thawani_pos/features/pos_customization/providers/template_browse_providers.dart';

class LabelTemplateDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const LabelTemplateDetailPage({super.key, required this.slug});

  @override
  ConsumerState<LabelTemplateDetailPage> createState() => _LabelTemplateDetailPageState();
}

class _LabelTemplateDetailPageState extends ConsumerState<LabelTemplateDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(labelLayoutDetailProvider(widget.slug).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(labelLayoutDetailProvider(widget.slug));
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.labelLayoutTemplateDetail)),
      floatingActionButton: switch (state) {
        LabelLayoutDetailLoaded(:final template) => FloatingActionButton.extended(
          onPressed: () =>
              context.push('${Routes.labelLayoutTemplatePreview}/${template.id}?name=${Uri.encodeComponent(template.name)}'),
          icon: const Icon(Icons.visibility_rounded),
          label: Text(l10n.templatePreviewButton),
        ),
        _ => null,
      },
      body: switch (state) {
        LabelLayoutDetailInitial() || LabelLayoutDetailLoading() => PosLoadingSkeleton.list(),
        LabelLayoutDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(labelLayoutDetailProvider(widget.slug).notifier).load(),
        ),
        LabelLayoutDetailLoaded(:final template) => _buildDetail(template, l10n),
      },
    );
  }

  Widget _buildDetail(LabelLayoutTemplate template, AppLocalizations l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

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
                      child: const Icon(Icons.label_rounded, color: AppColors.primary, size: 28),
                    ),
                    AppSpacing.gapW16,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(isAr ? template.nameAr : template.name, style: AppTypography.titleLarge),
                          AppSpacing.gapH4,
                          Text(
                            template.slug,
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
                    PosBadge(label: template.labelType.value, variant: PosBadgeVariant.info),
                    PosBadge(label: '${template.labelWidthMm}×${template.labelHeightMm}mm', variant: PosBadgeVariant.primary),
                    if (template.barcodeType != null)
                      PosBadge(label: template.barcodeType!.value, variant: PosBadgeVariant.neutral),
                    if (template.showBorder == true)
                      PosBadge(
                        label: '${l10n.labelLayoutTemplateBordered} (${template.borderStyle?.value ?? "solid"})',
                        variant: PosBadgeVariant.neutral,
                      ),
                    if (template.isActive == true)
                      PosBadge(label: l10n.labelLayoutTemplateActive, variant: PosBadgeVariant.success),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,

          // Dimensions & Font
          _configSection(
            title: l10n.labelLayoutTemplateDimensions,
            icon: Icons.straighten_rounded,
            entries: {
              l10n.labelLayoutTemplateWidth: '${template.labelWidthMm}mm',
              l10n.labelLayoutTemplateHeight: '${template.labelHeightMm}mm',
              l10n.labelLayoutTemplateFontFamily: template.fontFamily ?? 'system',
              l10n.labelLayoutTemplateFontSize: template.defaultFontSize?.value ?? 'medium',
              l10n.labelLayoutTemplateBackground: template.backgroundColor ?? '#FFFFFF',
            },
            isDark: isDark,
          ),
          AppSpacing.gapH16,

          // Barcode Settings
          if (template.barcodeType != null) ...[
            _configSection(
              title: l10n.labelLayoutTemplateBarcodeSettings,
              icon: Icons.qr_code_rounded,
              entries: {
                l10n.labelLayoutTemplateBarcodeType: template.barcodeType!.value,
                l10n.labelLayoutTemplateShowNumber: template.showBarcodeNumber == true
                    ? l10n.labelLayoutTemplateYes
                    : l10n.labelLayoutTemplateNo,
                if (template.barcodePosition != null)
                  'Position': 'x:${template.barcodePosition!['x'] ?? 0}% y:${template.barcodePosition!['y'] ?? 0}%',
                if (template.barcodePosition != null)
                  'Size': 'w:${template.barcodePosition!['w'] ?? 100}% h:${template.barcodePosition!['h'] ?? 30}%',
              },
              isDark: isDark,
            ),
            AppSpacing.gapH16,
          ],

          // Field Layout
          _fieldLayoutSection(template, l10n, isDark),
        ],
      ),
    );
  }

  Widget _configSection({
    required String title,
    required IconData icon,
    required Map<String, String> entries,
    required bool isDark,
  }) {
    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              AppSpacing.gapW8,
              Text(title, style: AppTypography.titleSmall),
            ],
          ),
          AppSpacing.gapH12,
          ...entries.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      entry.key,
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                  AppSpacing.gapW8,
                  Expanded(flex: 3, child: Text(entry.value, style: AppTypography.bodySmall)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fieldLayoutSection(LabelLayoutTemplate template, AppLocalizations l10n, bool isDark) {
    final fields = template.fieldLayout.whereType<Map>().toList();

    if (fields.isEmpty) {
      return PosCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.view_list_rounded, size: 20, color: AppColors.primary),
            AppSpacing.gapW8,
            Text(l10n.labelLayoutTemplateFieldLayout, style: AppTypography.titleSmall),
            const Spacer(),
            Text(
              l10n.labelLayoutTemplateNoFields,
              style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ],
        ),
      );
    }

    return PosCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.view_list_rounded, size: 20, color: AppColors.primary),
              AppSpacing.gapW8,
              Text(l10n.labelLayoutTemplateFieldLayout, style: AppTypography.titleSmall),
            ],
          ),
          AppSpacing.gapH12,
          ...fields.map((field) {
            final f = Map<String, dynamic>.from(field);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(f['field_key'] ?? '-', style: AppTypography.labelSmall.copyWith(fontFamily: 'monospace')),
                  Text('${f['x'] ?? 0}%, ${f['y'] ?? 0}%', style: AppTypography.micro),
                  Text('${f['w'] ?? 0}%×${f['h'] ?? 0}%', style: AppTypography.micro),
                  PosBadge(label: f['font_size']?.toString() ?? 'medium', variant: PosBadgeVariant.neutral),
                  if (f['is_bold'] == true) const PosBadge(label: 'Bold', variant: PosBadgeVariant.info),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
