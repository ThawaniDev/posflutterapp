import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_providers.dart';
import 'package:wameedpos/features/pos_customization/widgets/pos_settings_widget.dart';
import 'package:wameedpos/features/pos_customization/widgets/receipt_template_widget.dart';
import 'package:wameedpos/features/pos_customization/widgets/quick_access_widget.dart';
import 'package:wameedpos/core/router/route_names.dart';

class CustomizationDashboardPage extends ConsumerStatefulWidget {
  const CustomizationDashboardPage({super.key});

  @override
  ConsumerState<CustomizationDashboardPage> createState() => _CustomizationDashboardPageState();
}

class _CustomizationDashboardPageState extends ConsumerState<CustomizationDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(customizationSettingsProvider.notifier).load();
      ref.read(receiptTemplateProvider.notifier).load();
      ref.read(quickAccessProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PosListPage(
      title: l10n.customizationTitle,
      showSearch: false,
      child: Column(
        children: [
          // Feature links bar
          Container(
            padding: EdgeInsets.symmetric(horizontal: context.isPhone ? AppSpacing.sm : AppSpacing.base, vertical: AppSpacing.md),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: SizedBox(
              height: context.isPhone ? 100 : 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _featureLink(
                    icon: Icons.dashboard_customize_rounded,
                    label: l10n.layoutBuilder,
                    subtitle: l10n.layoutBuilderSubtitle,
                    onTap: () => context.push(Routes.layoutTemplates),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.isPhone ? AppSpacing.sm : AppSpacing.base),
                  _featureLink(
                    icon: Icons.storefront_rounded,
                    label: l10n.marketplaceTitle,
                    subtitle: l10n.marketplaceSubtitle,
                    onTap: () => context.push(Routes.marketplace),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.isPhone ? AppSpacing.sm : AppSpacing.base),
                  _featureLink(
                    icon: Icons.label_rounded,
                    label: l10n.labelsTemplates,
                    subtitle: l10n.labelTemplatesSubtitle,
                    onTap: () => context.push(Routes.labels),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.isPhone ? AppSpacing.sm : AppSpacing.base),
                  _featureLink(
                    icon: Icons.receipt_long_rounded,
                    label: l10n.receiptTemplatesTitle,
                    subtitle: l10n.receiptTemplatesEmptySubtitle,
                    onTap: () => context.push(Routes.receiptTemplates),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.isPhone ? AppSpacing.sm : AppSpacing.base),
                  _featureLink(
                    icon: Icons.tv_rounded,
                    label: l10n.cfdThemesTitle,
                    subtitle: l10n.cfdThemesEmptySubtitle,
                    onTap: () => context.push(Routes.cfdThemes),
                    isDark: isDark,
                  ),
                  SizedBox(width: context.isPhone ? AppSpacing.sm : AppSpacing.base),
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
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.customizationTheme, icon: Icons.palette),
              PosTabItem(label: l10n.customizationReceipt, icon: Icons.receipt_long),
              PosTabItem(label: l10n.customizationQuickAccess, icon: Icons.grid_view),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
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
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    return SizedBox(
      width: isMobile ? 100 : null,
      child: GestureDetector(
        onTap: onTap,
        child: PosCard(
          padding: EdgeInsets.all(isMobile ? AppSpacing.sm : AppSpacing.md),
          child: Column(
            children: [
              Container(
                width: isMobile ? 40 : 80,
                height: isMobile ? 40 : 80,
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
                child: Icon(icon, color: AppColors.primary, size: isMobile ? 22 : 40),
              ),
              SizedBox(height: isMobile ? 6 : 12),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      label,
                      style: isMobile ? AppTypography.labelSmall : AppTypography.titleMedium,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (!isMobile)
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (!isMobile)
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
