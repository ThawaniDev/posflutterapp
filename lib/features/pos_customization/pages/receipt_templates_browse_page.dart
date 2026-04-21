import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_customization/models/receipt_layout_template.dart';
import 'package:wameedpos/features/pos_customization/providers/template_browse_providers.dart';

class ReceiptTemplatesBrowsePage extends ConsumerStatefulWidget {
  const ReceiptTemplatesBrowsePage({super.key});

  @override
  ConsumerState<ReceiptTemplatesBrowsePage> createState() => _ReceiptTemplatesBrowsePageState();
}

class _ReceiptTemplatesBrowsePageState extends ConsumerState<ReceiptTemplatesBrowsePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(receiptLayoutListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(receiptLayoutListProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
  title: l10n.receiptTemplatesTitle,
  showSearch: false,
    child: switch (state) {
        ReceiptLayoutListInitial() || ReceiptLayoutListLoading() => PosLoadingSkeleton.list(),
        ReceiptLayoutListError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(receiptLayoutListProvider.notifier).load(),
        ),
        ReceiptLayoutListLoaded(:final templates) when templates.isEmpty => PosEmptyState(
          icon: Icons.receipt_long_outlined,
          title: l10n.receiptTemplatesEmpty,
          subtitle: l10n.receiptTemplatesEmptySubtitle,
        ),
        ReceiptLayoutListLoaded(:final templates) => GridView.builder(
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

  Widget _buildTemplateCard(ReceiptLayoutTemplate template, AppLocalizations l10n, bool isDark) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final displayName = isAr ? template.nameAr : template.name;

    return GestureDetector(
      onTap: () => context.push('${Routes.receiptTemplates}/${template.slug}'),
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
                        Icon(Icons.receipt_long_rounded, size: 48, color: AppColors.primary.withValues(alpha: 0.5)),
                        AppSpacing.gapH8,
                        Text(
                          '${template.paperWidth}mm',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.mutedFor(context),
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
                      style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
                    ),
                    const Spacer(),
                    // Badges
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        PosBadge(label: '${template.paperWidth}mm', variant: PosBadgeVariant.info),
                        if (template.showBilingual == true)
                          PosBadge(label: l10n.receiptTemplateBilingual, variant: PosBadgeVariant.primary),
                        if (template.zatcaQrPosition != null) PosBadge(label: l10n.pcZatcaQr, variant: PosBadgeVariant.success),
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
