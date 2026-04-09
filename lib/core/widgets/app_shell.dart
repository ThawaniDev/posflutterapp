import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/providers/app_settings_providers.dart';
import 'package:thawani_pos/core/providers/sidebar_provider.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/branch_selector.dart';
import 'package:thawani_pos/core/widgets/pos_sidebar.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/auth/providers/auth_providers.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';
import 'package:thawani_pos/features/security/repositories/security_repository.dart';
import 'package:thawani_pos/features/staff/providers/roles_providers.dart';
import 'package:thawani_pos/features/staff/providers/roles_state.dart';

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

    // Filter sidebar groups/items based on user permissions
    final permsState = ref.watch(userPermissionsProvider);
    final allGroups = PosSidebar.getDefaultGroups(l10n);
    final filteredGroups = _filterGroups(allGroups, permsState);

    Widget sidebar = PosSidebar(
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
    );

    final actions = _buildActions(context, ref, l10n);

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
                      child: Row(children: [const BranchSelector(), const Spacer(), ...actions]),
                    ),
                  ),
                  Expanded(child: child),
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
        title: SizedBox(height: 50, child: const BranchSelector()),
        actions: actions,
      ),
      drawer: SizedBox(
        width: AppSizes.sidebarWidth,
        child: Drawer(child: sidebar),
      ),
      body: child,
    );
  }

  /// Filters sidebar groups based on user permissions.
  /// Removes items the user lacks permission for, and removes empty groups.
  static List<PosSidebarGroup> _filterGroups(List<PosSidebarGroup> groups, UserPermissionsState permsState) {
    final result = <PosSidebarGroup>[];
    for (final group in groups) {
      final filteredItems = _filterItems(group.items, permsState);
      if (filteredItems.isNotEmpty) {
        result.add(PosSidebarGroup(label: group.label, icon: group.icon, items: filteredItems));
      }
    }
    return result;
  }

  /// Recursively filters sidebar items (and their children) by permission.
  /// Items with null permission are always visible.
  static List<PosSidebarItem> _filterItems(List<PosSidebarItem> items, UserPermissionsState permsState) {
    final result = <PosSidebarItem>[];
    for (final item in items) {
      if (item.permission != null && !permsState.hasPermission(item.permission!)) {
        continue;
      }
      final filteredChildren = item.children != null ? _filterItems(item.children!, permsState) : null;
      result.add(
        PosSidebarItem(
          label: item.label,
          icon: item.icon,
          route: item.route,
          permission: item.permission,
          children: filteredChildren,
        ),
      );
    }
    return result;
  }

  List<Widget> _buildActions(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentLocale = Localizations.localeOf(context);
    final themeMode = ref.watch(themeModeProvider);

    return [
      // Language switch
      IconButton(
        tooltip: l10n.appBarLanguage,
        icon: Text(
          currentLocale.languageCode == 'ar' ? 'EN' : 'ع',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        onPressed: () {
          final newLocale = currentLocale.languageCode == 'ar' ? const Locale('en') : const Locale('ar');
          ref.read(localeProvider.notifier).set(newLocale);
        },
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
      ref.read(authProvider.notifier).logout();
    }
  }
}
