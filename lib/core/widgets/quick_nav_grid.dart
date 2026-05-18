import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/pos_sidebar.dart';

/// Shows a popup dialog with all sidebar items displayed as a grouped grid
/// for quick navigation.
Future<void> showQuickNavGrid(BuildContext context, {required List<PosSidebarGroup> groups}) {
  return showDialog<void>(
    context: context,
    builder: (_) => _QuickNavGridDialog(groups: groups),
  );
}

class _QuickNavGridDialog extends StatelessWidget {
  const _QuickNavGridDialog({required this.groups});

  final List<PosSidebarGroup> groups;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderXl),
      backgroundColor: isDark ? AppColors.cardDark : AppColors.surfaceLight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 780, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─ Header ─
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded, size: 22, color: AppColors.primary),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Text(l10n.quickNavTitle, style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  IconButton(icon: const Icon(Icons.close_rounded, size: 20), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),

            // ─ Scrollable grouped grid ─
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0; i < groups.length; i++) ...[
                      if (i > 0) const SizedBox(height: 16),
                      _GroupSection(
                        group: groups[i],
                        onItemTap: (route) {
                          Navigator.of(context).pop();
                          context.go(route);
                        },
                      ),
                    ],
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

class _GroupSection extends StatelessWidget {
  const _GroupSection({required this.group, required this.onItemTap});

  final PosSidebarGroup group;
  final ValueChanged<String> onItemTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    // Flatten children into the grid too
    final allItems = <PosSidebarItem>[];
    for (final item in group.items) {
      allItems.add(item);
      if (item.children != null) {
        allItems.addAll(item.children!);
      }
    }

    // Only items that can actually navigate. Locked items remain in the main
    // sidebar when a plan wants them visible, but Quick Nav should not bypass
    // the locked-item flow.
    final navigableItems = allItems.where((item) => item.route != null && !item.isLocked).toList();
    if (navigableItems.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        Row(
          children: [
            Icon(group.icon, size: 16, color: mutedColor),
            AppSpacing.gapW8,
            Text(
              group.label,
              style: AppTypography.caption.copyWith(color: mutedColor, fontWeight: FontWeight.w700, letterSpacing: 0.5),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth.isFinite ? constraints.maxWidth.clamp(0.0, double.infinity) : 0.0;
            final crossAxisCount = _crossAxisCountForWidth(availableWidth);
            final tileWidth = _tileWidth(availableWidth, crossAxisCount);

            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: navigableItems
                  .map(
                    (item) => SizedBox(
                      width: tileWidth,
                      child: _QuickNavTile(item: item, onTap: () => onItemTap(item.route!)),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  int _crossAxisCountForWidth(double width) {
    if (width >= 720) return 5;
    if (width >= 560) return 4;
    if (width >= 360) return 3;
    if (width >= 220) return 2;
    return 1;
  }

  double _tileWidth(double availableWidth, int crossAxisCount) {
    const spacing = 8.0;
    final normalizedWidth = availableWidth.isFinite ? availableWidth.clamp(0.0, double.infinity) : 0.0;
    final totalSpacing = (crossAxisCount - 1) * spacing;
    return ((normalizedWidth - totalSpacing) / crossAxisCount).clamp(0.0, normalizedWidth);
  }
}

class _QuickNavTile extends StatelessWidget {
  const _QuickNavTile({required this.item, required this.onTap});

  final PosSidebarItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.cardDark : Colors.white,
      borderRadius: AppRadius.borderLg,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: AppRadius.borderLg,
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 24, color: AppColors.primary),
              const SizedBox(height: 6),
              Text(
                item.label,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
