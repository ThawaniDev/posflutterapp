import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/pos_customization/models/receipt_layout_template.dart';
import 'package:wameedpos/features/pos_customization/providers/template_browse_providers.dart';

class ReceiptTemplateDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const ReceiptTemplateDetailPage({super.key, required this.slug});

  @override
  ConsumerState<ReceiptTemplateDetailPage> createState() => _ReceiptTemplateDetailPageState();
}

class _ReceiptTemplateDetailPageState extends ConsumerState<ReceiptTemplateDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(receiptLayoutDetailProvider(widget.slug).notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptLayoutDetailProvider(widget.slug));
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: l10n.receiptTemplateDetail,
      showSearch: false,
      actions: [
        if (state is ReceiptLayoutDetailLoaded)
          PosButton(
            label: l10n.templatePreviewButton,
            icon: Icons.visibility_rounded,
            size: PosButtonSize.sm,
            onPressed: () => context.push(
              '${Routes.receiptTemplatePreview}/${(state).template.id}?name=${Uri.encodeComponent((state).template.name)}',
            ),
          ),
      ],
      child: switch (state) {
        ReceiptLayoutDetailInitial() || ReceiptLayoutDetailLoading() => PosLoadingSkeleton.list(),
        ReceiptLayoutDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(receiptLayoutDetailProvider(widget.slug).notifier).load(),
        ),
        ReceiptLayoutDetailLoaded(:final template) => _buildDetail(template, l10n),
      },
    );
  }

  Widget _buildDetail(ReceiptLayoutTemplate template, AppLocalizations l10n) {
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
                      child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 28),
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
                    PosBadge(label: '${template.paperWidth}mm', variant: PosBadgeVariant.info),
                    if (template.showBilingual == true)
                      PosBadge(label: l10n.receiptTemplateBilingual, variant: PosBadgeVariant.primary),
                    if (template.zatcaQrPosition != null)
                      PosBadge(label: 'ZATCA QR: ${template.zatcaQrPosition!.value}', variant: PosBadgeVariant.success),
                    if (template.isActive == true) PosBadge(label: l10n.receiptTemplateActive, variant: PosBadgeVariant.success),
                  ],
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,

          // Header Config
          _configSection(
            title: l10n.receiptTemplateHeaderConfig,
            icon: Icons.vertical_align_top_rounded,
            config: template.headerConfig,
            isDark: isDark,
          ),
          AppSpacing.gapH16,

          // Body Config
          _configSection(
            title: l10n.receiptTemplateBodyConfig,
            icon: Icons.article_rounded,
            config: template.bodyConfig,
            isDark: isDark,
          ),
          AppSpacing.gapH16,

          // Footer Config
          _configSection(
            title: l10n.receiptTemplateFooterConfig,
            icon: Icons.vertical_align_bottom_rounded,
            config: template.footerConfig,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _configSection({
    required String title,
    required IconData icon,
    required Map<String, dynamic> config,
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
          if (config.isEmpty)
            Text(
              'No configuration',
              style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            )
          else
            ...config.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        _formatKey(entry.key),
                        style: AppTypography.labelSmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ),
                    AppSpacing.gapW8,
                    Expanded(flex: 3, child: Text(_formatValue(entry.value), style: AppTypography.bodySmall)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatKey(String key) {
    return key.replaceAll('_', ' ').replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
  }

  String _formatValue(dynamic value) {
    if (value is bool) return value ? 'Yes' : 'No';
    if (value is List) return value.join(', ');
    if (value is Map) return value.entries.map((e) => '${e.key}: ${e.value}').join(', ');
    return value.toString();
  }
}
