import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_table.dart';

// ═══════════════════════════════════════════════════════════════
// PosMobileDataList — card-based list for phone screens
// Replaces PosDataTable on mobile with a swipeable card layout.
// ═══════════════════════════════════════════════════════════════

/// Configuration for a single field shown on a mobile card.
class MobileFieldConfig {
  const MobileFieldConfig({
    required this.label,
    required this.builder,
    this.isTitle = false,
    this.isSubtitle = false,
    this.isBadge = false,
    this.flex = 1,
  });

  final String label;
  final Widget Function(BuildContext context) builder;
  final bool isTitle;
  final bool isSubtitle;
  final bool isBadge;
  final int flex;
}

/// A mobile-friendly card-based list that replaces PosDataTable on phones.
class PosMobileDataList<T> extends StatelessWidget {
  const PosMobileDataList({
    super.key,
    required this.items,
    required this.cardBuilder,
    this.isLoading = false,
    this.error,
    this.onRetry,
    this.emptyConfig,
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.itemsPerPage = 25,
    this.onPreviousPage,
    this.onNextPage,
    this.onRefresh,
    this.padding,
    this.separatorHeight = 1,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) cardBuilder;
  final bool isLoading;
  final String? error;
  final VoidCallback? onRetry;
  final PosTableEmptyConfig? emptyConfig;
  final int? currentPage;
  final int? totalPages;
  final int? totalItems;
  final int itemsPerPage;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final double separatorHeight;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return _MobileErrorState(message: error!, onRetry: onRetry);
    }

    if (items.isEmpty) {
      return _MobileEmptyState(config: emptyConfig);
    }

    Widget list = ListView.separated(
      padding: padding ?? const EdgeInsets.only(bottom: 80),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: separatorHeight),
      itemBuilder: (context, index) => cardBuilder(context, items[index], index),
    );

    if (onRefresh != null) {
      list = RefreshIndicator(onRefresh: onRefresh!, child: list);
    }

    final hasPagination = currentPage != null && totalPages != null;

    if (!hasPagination) return list;

    return Column(
      children: [
        Expanded(child: list),
        _MobilePagination(
          currentPage: currentPage!,
          totalPages: totalPages!,
          totalItems: totalItems,
          onPrevious: onPreviousPage,
          onNext: onNextPage,
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MobileListCard — a standard card template for list items
// ═══════════════════════════════════════════════════════════════

/// A pre-styled card for mobile list items with leading, title,
/// subtitle, trailing info, and swipe/tap actions.
class MobileListCard extends StatelessWidget {
  const MobileListCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.badges,
    this.infoRows,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.isSelected = false,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final List<Widget>? badges;
  final List<MobileInfoRow>? infoRows;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<PosTableRowAction<dynamic>>? actions;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      elevation: 0,
      color: isSelected ? AppColors.primary10 : (isDark ? AppColors.cardDark : AppColors.cardLight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isSelected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: leading + title + trailing/actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (leading != null) ...[leading!, const SizedBox(width: 12)],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title,
                        if (subtitle != null) ...[const SizedBox(height: 2), subtitle!],
                      ],
                    ),
                  ),
                  if (trailing != null) trailing!,
                  if (actions != null && actions!.isNotEmpty) _MobileActions(actions: actions!),
                ],
              ),

              // Badges row
              if (badges != null && badges!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(spacing: 6, runSpacing: 4, children: badges!),
              ],

              // Info rows
              if (infoRows != null && infoRows!.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...infoRows!.map(
                  (row) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        if (row.icon != null) ...[
                          Icon(row.icon, size: 14, color: Theme.of(context).hintColor),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          row.label,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                        ),
                        const Spacer(),
                        row.valueWidget ??
                            Text(
                              row.value ?? '',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A row of label → value data shown on mobile cards.
class MobileInfoRow {
  const MobileInfoRow({required this.label, this.value, this.valueWidget, this.icon});

  final String label;
  final String? value;
  final Widget? valueWidget;
  final IconData? icon;
}

// ═══════════════════════════════════════════════════════════════
// Mobile toolbar — search + filter for phones
// ═══════════════════════════════════════════════════════════════

/// A compact mobile toolbar with search field and filter/action buttons.
class MobileToolbar extends StatelessWidget {
  const MobileToolbar({
    super.key,
    this.searchController,
    this.searchHint,
    this.onSearch,
    this.onSearchChanged,
    this.filterWidgets,
    this.actionButtons,
    this.showSearch = true,
  });

  final TextEditingController? searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearch;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget>? filterWidgets;
  final List<Widget>? actionButtons;
  final bool showSearch;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showSearch)
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: searchHint ?? 'Search...',
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: searchController?.text.isNotEmpty == true
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          searchController?.clear();
                          onSearch?.call('');
                        },
                      )
                    : null,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              onSubmitted: onSearch,
              onChanged: onSearchChanged,
              textInputAction: TextInputAction.search,
            ),
          if (filterWidgets != null && filterWidgets!.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 36,
              child: ListView(scrollDirection: Axis.horizontal, children: filterWidgets!),
            ),
          ],
          if (actionButtons != null && actionButtons!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                for (int i = 0; i < actionButtons!.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(child: actionButtons![i]),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Mobile section header
// ═══════════════════════════════════════════════════════════════

class MobileSectionHeader extends StatelessWidget {
  const MobileSectionHeader({super.key, required this.title, this.trailing, this.padding});

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.5)),
          if (trailing != null) ...[const Spacer(), trailing!],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Mobile stat card — for dashboard KPI-style cards
// ═══════════════════════════════════════════════════════════════

class MobileStatCard extends StatelessWidget {
  const MobileStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.trendPositive,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final bool? trendPositive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child: Icon(icon, size: 16, color: iconColor ?? AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              if (trend != null) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendPositive == true ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: trendPositive == true ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trend!,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: trendPositive == true ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Private widgets
// ═══════════════════════════════════════════════════════════════

class _MobileActions extends StatelessWidget {
  const _MobileActions({required this.actions});
  final List<PosTableRowAction<dynamic>> actions;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert, size: 20),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      itemBuilder: (ctx) => [
        for (int i = 0; i < actions.length; i++)
          PopupMenuItem<int>(
            value: i,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(actions[i].icon, size: 18, color: actions[i].isDestructive ? AppColors.error : null),
                const SizedBox(width: 8),
                Text(actions[i].label, style: TextStyle(color: actions[i].isDestructive ? AppColors.error : null)),
              ],
            ),
          ),
      ],
      onSelected: (idx) {
        // Actions will be triggered by the caller via onTap
      },
    );
  }
}

class _MobilePagination extends StatelessWidget {
  const _MobilePagination({required this.currentPage, required this.totalPages, this.totalItems, this.onPrevious, this.onNext});

  final int currentPage;
  final int totalPages;
  final int? totalItems;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          if (totalItems != null)
            Text('$totalItems items', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor)),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            onPressed: currentPage > 1 ? onPrevious : null,
            visualDensity: VisualDensity.compact,
          ),
          Text('$currentPage / $totalPages', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            onPressed: currentPage < totalPages ? onNext : null,
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}

class _MobileErrorState extends StatelessWidget {
  const _MobileErrorState({required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: Text(AppLocalizations.of(context)!.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MobileEmptyState extends StatelessWidget {
  const _MobileEmptyState({this.config});
  final PosTableEmptyConfig? config;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(config?.icon ?? Icons.inbox_outlined, size: 56, color: Theme.of(context).hintColor),
            const SizedBox(height: 12),
            Text(config?.title ?? 'No items', style: Theme.of(context).textTheme.titleMedium),
            if (config?.subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                config!.subtitle!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
