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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userCollapsed = ref.watch(sidebarCollapsedProvider);
    final currentRoute = GoRouterState.of(context).matchedLocation;
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

    // Wrap the routed body with device-aware gutters and a soft max-content-width.
    final wrappedChild = _ResponsiveContentArea(route: currentRoute, child: keyedChild);

    // Filter sidebar groups/items based on user permissions
    final permsState = ref.watch(userPermissionsProvider);
    final featureGate = ref.watch(featureGateServiceProvider);
    final allGroups = PosSidebar.getDefaultGroups(l10n);
    final filteredGroups = _filterGroups(allGroups, permsState, featureGate);

    final actions = _buildActions(context, ref, l10n, filteredGroups);

    // Sidebar is ALWAYS persistent — no drawer. Use LayoutBuilder so we get
    // the real rendered width rather than the raw MediaQuery size, which can
    // differ inside a ShellRoute on some platforms.
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // < 600 dp: auto-collapse to icon rail, hide toggle.
          // ≥ 600 dp: user-controlled expand/collapse.
          final isNarrow = constraints.maxWidth < 600;
          final isCollapsed = isNarrow ? true : userCollapsed;

          final Widget sidebar = PosSidebar(
            groups: filteredGroups,
            currentRoute: currentRoute,
            isCollapsed: isCollapsed,
            onToggleCollapse: isNarrow ? null : () => ref.read(sidebarCollapsedProvider.notifier).state = !userCollapsed,
            onItemTap: (route) => context.go(route),
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

          // Calculate the actual content width so that every child widget
          // that reads MediaQuery.sizeOf(context).width (PosTable, PosCard,
          // PosPageComponents, etc.) gets the real available width rather than
          // the full screen width. Without this, a 1024px tablet with a 256px
          // sidebar would report 1024px to children — making them think they
          // have desktop space — when they only have 768px.
          final sidebarPx = isCollapsed ? AppSizes.sidebarCollapsedWidth : AppSizes.sidebarWidth;
          final contentWidth = (constraints.maxWidth - sidebarPx).clamp(0.0, double.infinity);
          final mqData = MediaQuery.of(context).copyWith(size: Size(contentWidth, MediaQuery.of(context).size.height));

          return Row(
            children: [
              sidebar,
              Expanded(
                child: MediaQuery(
                  data: mqData,
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
                      Expanded(child: wrappedChild),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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

// ─────────────────────────────────────────────────────────────────────────────
// _ResponsiveContentArea
// ─────────────────────────────────────────────────────────────────────────────
//
// Centralised wrapper that gives every routed page consistent device-aware
// gutters and a soft maximum content width on tablet+/desktop+. Without this,
// each page renders mobile-style (single column, edge-to-edge cards) at every
// screen size because individual pages don't opt into ResponsiveBuilder.
//
// Routes that need the entire viewport (POS register, customer-facing
// display, drag-and-drop layout canvas, etc.) bypass the wrapper.

class _ResponsiveContentArea extends StatelessWidget {
  const _ResponsiveContentArea({required this.route, required this.child});

  final String route;
  final Widget child;

  /// Route prefixes that must render full-bleed (no gutters, no max-width cap).
  static const List<String> _fullBleedPrefixes = <String>[
    '/pos/cashier',
    '/pos/cfd',
    '/pos/customer-display',
    '/layout-builder',
    '/labels/designer',
    '/onboarding',
    '/login',
    '/auth',
    '/splash',
  ];

  bool get _isFullBleed => _fullBleedPrefixes.any(route.startsWith);

  @override
  Widget build(BuildContext context) {
    if (_isFullBleed) return child;

    final width = MediaQuery.sizeOf(context).width;

    // Phones / compact (< 600 dp): render as-is. Mobile-friendly padding
    // already comes from the page itself.
    if (width < 600) return child;

    // Tablet: modest horizontal gutters, no width cap.
    if (width < AppSizes.breakpointDesktop) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: child,
      );
    }

    // Desktop / wide: centered content with max-width and generous gutters.
    final maxContentWidth = width >= AppSizes.breakpointWide ? 1440.0 : 1200.0;
    final horizontalGutter = width >= AppSizes.breakpointWide ? AppSpacing.xxxl : AppSpacing.xxl;

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalGutter),
          child: child,
        ),
      ),
    );
  }
}
