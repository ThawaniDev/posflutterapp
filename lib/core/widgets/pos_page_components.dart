import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

// ═════════════════════════════════════════════════════════════
// POS PAGE HEADER — Filament-style unified page header
// ═════════════════════════════════════════════════════════════

/// Unified page header with title, optional breadcrumb, subtitle,
/// and trailing action buttons. Used at the top of every page.
///
/// Inspired by Filament's clean page headers:
/// - Title on the left, actions on the right
/// - Optional breadcrumb trail above the title
/// - Optional subtitle below the title
/// - Responsive: stacks vertically on narrow screens
class PosPageHeader extends StatelessWidget {
  const PosPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actions,
    this.leading,
    this.onBack,
    this.padding,
  });

  /// Main page title.
  final String title;

  /// Optional subtitle text below the title.
  final String? subtitle;

  /// Breadcrumb trail: list of (label, optional onTap).
  /// The last item is treated as the current page (not tappable).
  final List<PosBreadcrumbItem>? breadcrumbs;

  /// Action widgets (buttons) aligned to the right.
  final List<Widget>? actions;

  /// Optional leading widget (e.g., back button icon).
  final Widget? leading;

  /// Back button callback. If non-null, shows a back arrow.
  final VoidCallback? onBack;

  /// Custom padding override.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < AppSizes.breakpointTablet;

    return Padding(
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl,
            vertical: isMobile ? AppSpacing.md : AppSpacing.lg,
          ),
      child: isMobile ? _buildMobile(context, isDark) : _buildDesktop(context, isDark),
    );
  }

  Widget _buildDesktop(BuildContext context, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (onBack != null || leading != null) ...[
          leading ??
              IconButton(
                onPressed: onBack ?? () => Navigator.maybePop(context),
                icon: Icon(
                  Directionality.of(context) == TextDirection.rtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                ),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.borderMd,
                    side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                ),
              ),
          AppSpacing.gapW12,
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[_buildBreadcrumbs(context, isDark), AppSpacing.gapH4],
              Text(
                title,
                style: AppTypography.headlineMedium.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              if (subtitle != null) ...[
                AppSpacing.gapH2,
                Text(
                  subtitle!,
                  style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
              ],
            ],
          ),
        ),
        if (actions != null && actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < actions!.length; i++) ...[if (i > 0) AppSpacing.gapW8, actions![i]],
            ],
          ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (breadcrumbs != null && breadcrumbs!.isNotEmpty) ...[_buildBreadcrumbs(context, isDark), AppSpacing.gapH4],
        Row(
          children: [
            if (onBack != null || leading != null) ...[
              leading ??
                  IconButton(
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                    icon: Icon(
                      Directionality.of(context) == TextDirection.rtl ? Icons.arrow_forward_rounded : Icons.arrow_back_rounded,
                      size: 20,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              AppSpacing.gapW4,
            ],
            Expanded(
              child: Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
            ),
          ],
        ),
        if (subtitle != null) ...[
          AppSpacing.gapH2,
          Text(
            subtitle!,
            style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[AppSpacing.gapH12, Wrap(spacing: 8, runSpacing: 8, children: actions!)],
      ],
    );
  }

  Widget _buildBreadcrumbs(BuildContext context, bool isDark) {
    if (breadcrumbs == null || breadcrumbs!.isEmpty) return const SizedBox.shrink();

    return Row(
      children: [
        for (int i = 0; i < breadcrumbs!.length; i++) ...[
          if (i > 0) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Directionality.of(context) == TextDirection.rtl ? Icons.chevron_left : Icons.chevron_right,
                size: 14,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
          ],
          if (i < breadcrumbs!.length - 1 && breadcrumbs![i].onTap != null)
            InkWell(
              onTap: breadcrumbs![i].onTap,
              borderRadius: AppRadius.borderXs,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
                child: Text(breadcrumbs![i].label, style: AppTypography.breadcrumb.copyWith(color: AppColors.primary)),
              ),
            )
          else
            Text(
              breadcrumbs![i].label,
              style: (i == breadcrumbs!.length - 1 ? AppTypography.breadcrumbActive : AppTypography.breadcrumb).copyWith(
                color: i == breadcrumbs!.length - 1
                    ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                    : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
            ),
        ],
      ],
    );
  }
}

/// A single breadcrumb item.
class PosBreadcrumbItem {
  const PosBreadcrumbItem({required this.label, this.onTap});
  final String label;
  final VoidCallback? onTap;
}

// ═════════════════════════════════════════════════════════════
// POS FILTER BAR — Horizontal filter area for table pages
// ═════════════════════════════════════════════════════════════

/// Horizontal bar with search field and filter widgets.
/// Filament-inspired: clean, minimal, with clear visual separation.
class PosFilterBar extends StatelessWidget {
  const PosFilterBar({
    super.key,
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.filters,
    this.trailing,
    this.showSearch = true,
    this.searchWidth = 300,
    this.padding,
  });

  final TextEditingController? searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchClear;

  /// Filter widgets (dropdowns, chips, etc.) shown after the search field.
  final List<Widget>? filters;

  /// Trailing widgets (e.g., view toggle, export button).
  final List<Widget>? trailing;

  final bool showSearch;
  final double searchWidth;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet;

    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl, vertical: AppSpacing.sm),
      child: isMobile ? _buildMobile(context) : _buildDesktop(context),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      children: [
        if (showSearch) SizedBox(width: searchWidth, child: _buildSearchField(context)),
        if (filters != null && filters!.isNotEmpty) ...[
          AppSpacing.gapW12,
          ...filters!.map((f) => Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: f)),
        ],
        const Spacer(),
        if (trailing != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < trailing!.length; i++) ...[if (i > 0) AppSpacing.gapW8, trailing![i]],
            ],
          ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showSearch) _buildSearchField(context),
        if (filters != null && filters!.isNotEmpty) ...[
          AppSpacing.gapH8,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: filters!.map((f) => Padding(padding: const EdgeInsetsDirectional.only(end: 8), child: f)).toList(),
            ),
          ),
        ],
        if (trailing != null && trailing!.isNotEmpty) ...[
          AppSpacing.gapH8,
          Row(mainAxisAlignment: MainAxisAlignment.end, children: trailing!),
        ],
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: searchController,
      onChanged: onSearchChanged,
      onSubmitted: onSearchSubmitted,
      style: AppTypography.bodyMedium.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      decoration: InputDecoration(
        hintText: searchHint ?? 'Search...',
        prefixIcon: Icon(Icons.search_rounded, size: 20, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
        suffixIcon: searchController != null && searchController!.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                onPressed: () {
                  searchController?.clear();
                  onSearchChanged?.call('');
                  onSearchClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        isDense: true,
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS FORM CARD — Form section card with title
// ═════════════════════════════════════════════════════════════

/// A card wrapper for form sections. Filament-style:
/// - Title and description in the card header
/// - Form fields as children
/// - Consistent padding and border radius
class PosFormCard extends StatelessWidget {
  const PosFormCard({super.key, this.title, this.description, this.action, this.padding, required this.child});

  final String? title;
  final String? description;
  final Widget? action;
  final EdgeInsetsGeometry? padding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final borderColor = isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight;

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Container(
              padding: padding ?? const EdgeInsets.fromLTRB(20, 16, 20, 12),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: AppTypography.titleLarge.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        if (description != null) ...[
                          AppSpacing.gapH2,
                          Text(
                            description!,
                            style: AppTypography.bodySmall.copyWith(
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (action != null) action!,
                ],
              ),
            ),
          Padding(padding: padding ?? const EdgeInsets.all(20), child: child),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS TABS — Filament-style tab bar
// ═════════════════════════════════════════════════════════════

/// Clean underline-style tabs matching Filament's design.
class PosTabs extends StatelessWidget {
  const PosTabs({super.key, required this.tabs, required this.selectedIndex, required this.onChanged, this.isScrollable = false});

  final List<PosTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: isScrollable
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: _buildTabs(context, isDark)),
            )
          : Row(children: _buildTabs(context, isDark)),
    );
  }

  List<Widget> _buildTabs(BuildContext context, bool isDark) {
    return [
      for (int i = 0; i < tabs.length; i++)
        _PosTabButton(tab: tabs[i], isSelected: i == selectedIndex, onTap: () => onChanged(i), isDark: isDark),
    ];
  }
}

class PosTabItem {
  const PosTabItem({required this.label, this.icon, this.badge});
  final String label;
  final IconData? icon;
  final int? badge;
}

class _PosTabButton extends StatelessWidget {
  const _PosTabButton({required this.tab, required this.isSelected, required this.onTap, required this.isDark});

  final PosTabItem tab;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.primary;
    final unselectedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final color = isSelected ? selectedColor : unselectedColor;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: isSelected ? selectedColor : Colors.transparent, width: 2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[Icon(tab.icon, size: 18, color: color), AppSpacing.gapW4],
            Text(tab.label, style: (isSelected ? AppTypography.titleMedium : AppTypography.bodyMedium).copyWith(color: color)),
            if (tab.badge != null && tab.badge! > 0) ...[
              AppSpacing.gapW4,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: isSelected ? selectedColor.withValues(alpha: 0.1) : unselectedColor.withValues(alpha: 0.1),
                  borderRadius: AppRadius.borderFull,
                ),
                child: Text(
                  '${tab.badge}',
                  style: AppTypography.micro.copyWith(color: color, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS STATS GRID — Responsive KPI grid
// ═════════════════════════════════════════════════════════════

/// Responsive grid for stat/KPI cards. Automatically adjusts columns.
class PosStatsGrid extends StatelessWidget {
  const PosStatsGrid({
    super.key,
    required this.children,
    this.mobileCols = 2,
    this.tabletCols = 3,
    this.desktopCols = 4,
    this.spacing = 12,
  });

  final List<Widget> children;
  final int mobileCols;
  final int tabletCols;
  final int desktopCols;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final cols = w < 600
            ? mobileCols
            : w < 1000
            ? tabletCols
            : desktopCols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children.map((child) {
            final itemWidth = (w - (cols - 1) * spacing) / cols;
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS INFO BANNER — Dismissible notification banner
// ═════════════════════════════════════════════════════════════

/// Filament-style info/warning/success banner at the top of pages.
enum PosInfoBannerVariant { info, warning, success, error }

class PosInfoBanner extends StatelessWidget {
  const PosInfoBanner({
    super.key,
    required this.message,
    this.variant = PosInfoBannerVariant.info,
    this.icon,
    this.action,
    this.actionLabel,
    this.onDismiss,
  });

  final String message;
  final PosInfoBannerVariant variant;
  final IconData? icon;
  final VoidCallback? action;
  final String? actionLabel;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final (bgColor, fgColor, defaultIcon) = _variantColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: bgColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon ?? defaultIcon, size: 20, color: fgColor),
          AppSpacing.gapW12,
          Expanded(
            child: Text(message, style: AppTypography.bodySmall.copyWith(color: fgColor)),
          ),
          if (actionLabel != null && action != null) ...[
            AppSpacing.gapW8,
            InkWell(
              onTap: action,
              borderRadius: AppRadius.borderXs,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelSmall.copyWith(color: fgColor, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: Icon(Icons.close, size: 16, color: fgColor.withValues(alpha: 0.7)),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
        ],
      ),
    );
  }

  (Color bg, Color fg, IconData icon) get _variantColors => switch (variant) {
    PosInfoBannerVariant.info => (AppColors.info, AppColors.infoDark, Icons.info_outline_rounded),
    PosInfoBannerVariant.warning => (AppColors.warning, AppColors.warningDark, Icons.warning_amber_rounded),
    PosInfoBannerVariant.success => (AppColors.success, AppColors.successDark, Icons.check_circle_outline_rounded),
    PosInfoBannerVariant.error => (AppColors.error, AppColors.errorDark, Icons.error_outline_rounded),
  };
}

// ═════════════════════════════════════════════════════════════
// POS TIMELINE TILE — Activity/audit log item
// ═════════════════════════════════════════════════════════════

class PosTimelineTile extends StatelessWidget {
  const PosTimelineTile({
    super.key,
    required this.title,
    this.subtitle,
    this.timestamp,
    this.icon,
    this.iconColor,
    this.isFirst = false,
    this.isLast = false,
  });

  final String title;
  final String? subtitle;
  final String? timestamp;
  final IconData? icon;
  final Color? iconColor;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    final effectiveIconColor = iconColor ?? AppColors.primary;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 32,
            child: Column(
              children: [
                if (!isFirst) Expanded(child: Container(width: 1.5, color: lineColor)),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: effectiveIconColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Center(child: Icon(icon ?? Icons.circle, size: 12, color: effectiveIconColor)),
                ),
                if (!isLast) Expanded(child: Container(width: 1.5, color: lineColor)),
              ],
            ),
          ),
          AppSpacing.gapW12,
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  if (timestamp != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        timestamp!,
                        style: AppTypography.micro.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS CHIP GROUP — Selectable chip group
// ═════════════════════════════════════════════════════════════

class PosChipGroup<T> extends StatelessWidget {
  const PosChipGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.labelBuilder,
    this.multiSelect = false,
    this.selectedValues = const {},
    this.onMultiChanged,
  });

  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T> onChanged;
  final String Function(T)? labelBuilder;
  final bool multiSelect;
  final Set<T> selectedValues;
  final ValueChanged<Set<T>>? onMultiChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final label = labelBuilder?.call(item) ?? item.toString();
        final isSelected = multiSelect ? selectedValues.contains(item) : selectedValue == item;

        return FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (selected) {
            if (multiSelect && onMultiChanged != null) {
              final newSet = Set<T>.from(selectedValues);
              if (selected) {
                newSet.add(item);
              } else {
                newSet.remove(item);
              }
              onMultiChanged!(newSet);
            } else {
              onChanged(item);
            }
          },
          selectedColor: AppColors.primary10,
          checkmarkColor: AppColors.primary,
          labelStyle: AppTypography.labelMedium.copyWith(color: isSelected ? AppColors.primary : null),
        );
      }).toList(),
    );
  }
}
