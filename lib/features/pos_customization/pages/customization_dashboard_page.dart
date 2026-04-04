import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/features/pos_customization/providers/customization_providers.dart';
import 'package:thawani_pos/features/pos_customization/widgets/pos_settings_widget.dart';
import 'package:thawani_pos/features/pos_customization/widgets/receipt_template_widget.dart';
import 'package:thawani_pos/features/pos_customization/widgets/quick_access_widget.dart';
import 'package:thawani_pos/core/router/route_names.dart';

class CustomizationDashboardPage extends ConsumerStatefulWidget {
  const CustomizationDashboardPage({super.key});

  @override
  ConsumerState<CustomizationDashboardPage> createState() => _CustomizationDashboardPageState();
}

class _CustomizationDashboardPageState extends ConsumerState<CustomizationDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(customizationSettingsProvider.notifier).load();
      ref.read(receiptTemplateProvider.notifier).load();
      ref.read(quickAccessProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customizationTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.palette), text: l10n.customizationTheme),
            Tab(icon: const Icon(Icons.receipt_long), text: l10n.customizationReceipt),
            Tab(icon: const Icon(Icons.grid_view), text: l10n.customizationQuickAccess),
          ],
        ),
      ),
      body: Column(
        children: [
          // Feature links bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: SizedBox(
              height: 200,
              child: Row(
                children: [
                  _featureLink(
                    icon: Icons.dashboard_customize_rounded,
                    label: l10n.layoutBuilder,
                    subtitle: l10n.layoutBuilderSubtitle,
                    onTap: () => context.push(Routes.layoutTemplates),
                    isDark: isDark,
                  ),
                  AppSpacing.gapW16,
                  _featureLink(
                    icon: Icons.storefront_rounded,
                    label: l10n.marketplaceTitle,
                    subtitle: l10n.marketplaceSubtitle,
                    onTap: () => context.push(Routes.marketplace),
                    isDark: isDark,
                  ),
                  AppSpacing.gapW16,
                  _featureLink(
                    icon: Icons.label_rounded,
                    label: l10n.labelsTemplates,
                    subtitle: l10n.labelTemplatesSubtitle,
                    onTap: () => context.push(Routes.labels),
                    isDark: isDark,
                  ),
                  AppSpacing.gapW16,
                  _featureLink(
                    icon: Icons.receipt_long_rounded,
                    label: l10n.receiptTemplatesTitle,
                    subtitle: l10n.receiptTemplatesEmptySubtitle,
                    onTap: () => context.push(Routes.receiptTemplates),
                    isDark: isDark,
                  ),
                  AppSpacing.gapW16,
                  _featureLink(
                    icon: Icons.tv_rounded,
                    label: l10n.cfdThemesTitle,
                    subtitle: l10n.cfdThemesEmptySubtitle,
                    onTap: () => context.push(Routes.cfdThemes),
                    isDark: isDark,
                  ),
                  AppSpacing.gapW16,
                  _featureLink(
                    icon: Icons.label_rounded,
                    label: l10n.labelLayoutTemplatesTitle,
                    subtitle: l10n.labelLayoutTemplatesEmptySubtitle,
                    onTap: () => context.push(Routes.labelLayoutTemplates),
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
          // Existing tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [PosSettingsWidget(), ReceiptTemplateWidget(), QuickAccessWidget()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _featureLink({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: PosCard(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                child: Icon(icon, color: AppColors.primary, size: 40),
              ),
              AppSpacing.gapH12,
              Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: AppTypography.titleMedium),
                    Text(
                      subtitle,
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 18,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
