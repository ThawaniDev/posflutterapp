import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

/// Wameed POS App Bar — sticky top bar with logo area, title,
/// optional search, notification badge, and user avatar.
///
/// Matches the stitch prototype: white bg, bottom border, 56px height.
class PosAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PosAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
    this.showNotification = false,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.avatarUrl,
    this.avatarInitial,
    this.onAvatarTap,
    this.showSearch = false,
    this.onSearchTap,
    this.bottom,
    this.backgroundColor,
    this.elevation,
  });

  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  // Notification bell
  final bool showNotification;
  final int notificationCount;
  final VoidCallback? onNotificationTap;

  // Avatar
  final String? avatarUrl;
  final String? avatarInitial;
  final VoidCallback? onAvatarTap;

  // Search
  final bool showSearch;
  final VoidCallback? onSearchTap;

  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Size get preferredSize => Size.fromHeight(AppSizes.appBarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Build the action buttons list
    final actionsList = <Widget>[
      ...?actions,
      if (showSearch) IconButton(onPressed: onSearchTap, icon: const Icon(Icons.search_rounded), tooltip: AppLocalizations.of(context)!.search),
      if (showNotification) _NotificationBell(count: notificationCount, onTap: onNotificationTap),
      if (avatarUrl != null || avatarInitial != null)
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: _Avatar(url: avatarUrl, initial: avatarInitial ?? '?', onTap: onAvatarTap),
        ),
    ];

    return AppBar(
      leading: showBackButton
          ? IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: onBackPressed ?? () => Navigator.maybePop(context))
          : leading,
      title:
          titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: AppTypography.headlineMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                )
              : null),
      actions: actionsList.isNotEmpty ? actionsList : null,
      backgroundColor: backgroundColor,
      elevation: elevation,
      bottom: bottom,
    );
  }
}

// ─── Notification Bell with badge ────────────────────────────

class _NotificationBell extends StatelessWidget {
  const _NotificationBell({required this.count, this.onTap});

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Badge(
        isLabelVisible: count > 0,
        label: Text(count > 99 ? '99+' : '$count', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        child: const Icon(Icons.notifications_outlined),
      ),
      tooltip: AppLocalizations.of(context)!.notifications,
    );
  }
}

// ─── User Avatar ─────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({this.url, required this.initial, this.onTap});

  final String? url;
  final String initial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primary10,
        backgroundImage: url != null ? NetworkImage(url!) : null,
        child: url == null
            ? Text(initial.substring(0, 1).toUpperCase(), style: AppTypography.labelMedium.copyWith(color: AppColors.primary))
            : null,
      ),
    );
  }
}
