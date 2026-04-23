import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/providers/app_settings_providers.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/providers/sidebar_provider.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/branch_selector.dart';
import 'package:wameedpos/core/widgets/quick_nav_grid.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/notifications/widgets/maintenance_banner.dart';
import 'package:wameedpos/features/notifications/widgets/notification_bell.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';
import 'package:wameedpos/features/security/repositories/security_repository.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/providers/roles_state.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/services/upgrade_prompt_service.dart';
import 'package:wameedpos/features/subscription/widgets/global_subscription_banner.dart';

/// Shell widget that wraps authenticated pages with a persistent sidebar.
///
/// On desktop (≥ 1024px): sidebar + body side-by-side.
/// On mobile (< 1024px): body only with a Drawer accessible via menu icon.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  /// Desktop breakpoint — matches Tailwind `lg`.
  static const double _desktopBreakpoint = 1024;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCollapsed = ref.watch(sidebarCollapsedProvider);
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= _desktopBreakpoint;
    final l10n = AppLocalizations.of(context)!;

    // Re-mount the routed page whenever the active branch changes so that
    // initState reruns, autoDispose providers reset, and the user sees data
    // for the newly selected store without a manual refresh.
    final activeBranchId = ref.watch(activeBranchIdProvider);
    final refreshTick = ref.watch(pageRefreshTickProvider);
    final keyedChild = KeyedSubtree(
      key: ValueKey<String>('branch:${activeBranchId ?? '__all__'}|$currentRoute|$refreshTick'),
      child: child,
    );

    // Filter sidebar groups/items based on user permissions
    final permsState = ref.watch(userPermissionsProvider);
    final featureGate = ref.watch(featureGateServiceProvider);
    final allGroups = PosSidebar.getDefaultGroups(l10n);
    final filteredGroups = _filterGroups(allGroups, permsState, featureGate);

    final Widget sidebar = PosSidebar(
      groups: filteredGroups,
      currentRoute: currentRoute,
      isCollapsed: isCollapsed,
      onToggleCollapse: () => ref.read(sidebarCollapsedProvider.notifier).state = !isCollapsed,
      onItemTap: (route) {
        context.go(route);
        // Close drawer on mobile after navigation
        if (!isDesktop && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      },
      onLockedItemTap: (item) {
        ref
            .read(upgradePromptServiceProvider)
            .showFeatureGatePrompt(
              context: context,
              featureKey: item.featureKey!,
              featureName: item.label,
              onUpgrade: () => context.go('/subscription/status'),
            );
      },
    );

    final actions = _buildActions(context, ref, l10n, filteredGroups);
    final mobileActions = _buildMobileActions(context, ref, l10n, filteredGroups);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            sidebar,
            Expanded(
              child: Column(
                children: [
                  Material(
                    elevation: 1,
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        children: [
                          const Expanded(child: BranchSelector()),
                          ...actions,
                        ],
                      ),
                    ),
                  ),
                  const MaintenanceBanner(),
                  const GlobalSubscriptionBanner(),
                  Expanded(child: keyedChild),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Mobile / tablet: use Drawer
    return Scaffold(
      appBar: AppBar(
        // leading: Builder(
        //   builder: (ctx) => IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => Scaffold.of(ctx).openDrawer()),
        // ),
        title: const BranchSelector(),
        actions: mobileActions,
      ),
      drawer: SizedBox(
        width: AppSizes.sidebarWidth,
        child: Drawer(child: sidebar),
      ),
      body: Column(
        children: [
          const MaintenanceBanner(),
          const GlobalSubscriptionBanner(),
          Expanded(child: keyedChild),
        ],
      ),
    );
  }

  /// Filters sidebar groups based on user permissions.
  /// Removes items the user lacks permission for, and removes empty groups.
  /// Items with a featureKey that is disabled are kept but marked as locked.
  static List<PosSidebarGroup> _filterGroups(
    List<PosSidebarGroup> groups,
    UserPermissionsState permsState,
    FeatureGateService featureGate,
  ) {
    final result = <PosSidebarGroup>[];
    for (final group in groups) {
      final filteredItems = _filterItems(group.items, permsState, featureGate);
      if (filteredItems.isNotEmpty) {
        result.add(PosSidebarGroup(label: group.label, icon: group.icon, items: filteredItems));
      }
    }
    return result;
  }

  /// Recursively filters sidebar items (and their children) by permission.
  /// Items with null permission are always visible.
  /// Items with a featureKey that is disabled stay visible but marked locked.
  static List<PosSidebarItem> _filterItems(
    List<PosSidebarItem> items,
    UserPermissionsState permsState,
    FeatureGateService featureGate,
  ) {
    final result = <PosSidebarItem>[];
    for (final item in items) {
      // Permission check — remove entirely if user lacks role permission
      if (item.permission != null && !permsState.hasPermission(item.permission!)) {
        continue;
      }
      // Feature gate check — keep but mark as locked
      final isLocked = item.featureKey != null && !featureGate.isFeatureEnabled(item.featureKey!);
      final filteredChildren = item.children != null
          ? (isLocked ? item.children : _filterItems(item.children!, permsState, featureGate))
          : null;
      result.add(
        PosSidebarItem(
          label: item.label,
          icon: item.icon,
          route: item.route,
          permission: item.permission,
          featureKey: item.featureKey,
          isLocked: isLocked,
          children: isLocked ? null : filteredChildren,
        ),
      );
    }
    return result;
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref, AppLocalizations l10n, List<PosSidebarGroup> filteredGroups) {
    final currentLocale = Localizations.localeOf(context);
    final themeMode = ref.watch(themeModeProvider);

    return [
      // Refresh current page (re-mounts the routed child via key bump)
      IconButton(
        tooltip: l10n.commonRefresh,
        icon: const Icon(Icons.refresh_rounded),
        onPressed: () => ref.read(pageRefreshTickProvider.notifier).state++,
      ),
      // Notification bell
      const NotificationBell(),
      // Quick Nav grid
      IconButton(
        tooltip: l10n.quickNavTitle,
        icon: const Icon(Icons.grid_view_rounded),
        onPressed: () => showQuickNavGrid(context, groups: filteredGroups),
      ),
      // Language switch
      PopupMenuButton<Locale>(
        tooltip: l10n.appBarLanguage,
        initialValue: Locale(currentLocale.languageCode),
        icon: Text(
          _languageButtonLabel(currentLocale.languageCode),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        onSelected: (locale) {
          ref.read(localeProvider.notifier).set(locale);
        },
        itemBuilder: (context) => [
          PopupMenuItem(value: const Locale('en'), child: Text(l10n.languageEnglish)),
          PopupMenuItem(value: const Locale('ar'), child: Text(l10n.languageArabic)),
          PopupMenuItem(value: const Locale('bn'), child: Text(l10n.languageBengali)),
          PopupMenuItem(value: const Locale('ur'), child: Text(l10n.languageUrdu)),
        ],
      ),
      // Theme toggle
      IconButton(
        tooltip: l10n.appBarTheme,
        icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        onPressed: () {
          ref.read(themeModeProvider.notifier).set(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
        },
      ),
      // Logout
      IconButton(
        tooltip: l10n.logout,
        icon: const Icon(Icons.logout_rounded),
        onPressed: () => _confirmLogout(context, ref, l10n),
      ),
    ];
  }

  /// Mobile-only condensed actions: a single overflow button (with the
  /// notification badge) opening a popup menu of all available actions.
  /// Frees up AppBar space so the BranchSelector store dropdown renders well.
  List<Widget> _buildMobileActions(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    List<PosSidebarGroup> filteredGroups,
  ) {
    final unread = ref.watch(unreadCountProvider);
    final unreadCount = unread is UnreadCountLoaded ? unread.count : 0;
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = Localizations.localeOf(context);
    final isDark = themeMode == ThemeMode.dark;

    return [
      PosCountBadge(
        count: unreadCount,
        child: PopupMenuButton<String>(
          tooltip: l10n.appBarMore,
          icon: const Icon(Icons.more_vert_rounded),
          position: PopupMenuPosition.under,
          onSelected: (value) => _handleMobileAction(context, ref, l10n, value, filteredGroups),
          itemBuilder: (ctx) => [
            PopupMenuItem<String>(
              value: 'notifications',
              child: Row(
                children: [
                  const Icon(Icons.notifications_outlined, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.notifications)),
                  if (unreadCount > 0)
                    PosBadge(label: unreadCount > 99 ? '99+' : '$unreadCount', variant: PosBadgeVariant.error, isSmall: true),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'quick_nav',
              child: Row(
                children: [
                  const Icon(Icons.grid_view_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.quickNavTitle),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'language',
              child: Row(
                children: [
                  const Icon(Icons.language_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(l10n.appBarLanguage)),
                  Text(_languageButtonLabel(currentLocale.languageCode), style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'theme',
              child: Row(
                children: [
                  Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.appBarTheme),
                ],
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(l10n.logout),
                ],
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Future<void> _handleMobileAction(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
    String action,
    List<PosSidebarGroup> filteredGroups,
  ) async {
    switch (action) {
      case 'notifications':
        context.go('/notifications');
        break;
      case 'quick_nav':
        showQuickNavGrid(context, groups: filteredGroups);
        break;
      case 'language':
        await _showLanguagePicker(context, ref, l10n);
        break;
      case 'theme':
        final themeMode = ref.read(themeModeProvider);
        ref.read(themeModeProvider.notifier).set(themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
        break;
      case 'logout':
        await _confirmLogout(context, ref, l10n);
        break;
    }
  }

  Future<void> _showLanguagePicker(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final current = Localizations.localeOf(context).languageCode;
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      builder: (ctx) {
        Widget tile(Locale locale, String label) => ListTile(
          leading: Text(_languageButtonLabel(locale.languageCode), style: const TextStyle(fontWeight: FontWeight.bold)),
          title: Text(label),
          trailing: current == locale.languageCode ? const Icon(Icons.check_rounded) : null,
          onTap: () => Navigator.of(ctx).pop(locale),
        );
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(l10n.appBarLanguage, style: Theme.of(ctx).textTheme.titleMedium),
              ),
              tile(const Locale('en'), 'English'),
              tile(const Locale('ar'), 'Arabic'),
              tile(const Locale('bn'), 'Bengali'),
              tile(const Locale('ur'), 'Urdu'),
            ],
          ),
        );
      },
    );
    if (selected != null) {
      ref.read(localeProvider.notifier).set(selected);
    }
  }

  String _languageButtonLabel(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'AR';
      case 'bn':
        return 'BN';
      case 'ur':
        return 'UR';
      default:
        return 'EN';
    }
  }

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.logoutTitle,
      message: l10n.logoutConfirm,
      confirmLabel: l10n.logout,
      isDanger: true,
    );
    if (confirmed == true) {
      final authState = ref.read(authProvider);
      if (authState is AuthAuthenticated && authState.user.storeId != null) {
        ref
            .read(securityRepositoryProvider)
            .endAllSessions(storeId: authState.user.storeId!)
            .catchError((_) => <String, dynamic>{});
      }
      ref.read(authProvider.notifier).logout(l10n);
    }
  }
}
