import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/providers/app_settings_providers.dart';
import 'package:thawani_pos/core/providers/sidebar_provider.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_sidebar.dart';
import 'package:thawani_pos/features/auth/providers/auth_providers.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';
import 'package:thawani_pos/features/security/repositories/security_repository.dart';

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

    Widget sidebar = PosSidebar(
      items: PosSidebar.getDefaultItems(l10n),
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
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(children: [const Spacer(), ...actions]),
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
        leading: Builder(
          builder: (ctx) => IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () => Scaffold.of(ctx).openDrawer()),
        ),
        title: const Text('Wameed POS'),
        actions: actions,
      ),
      drawer: SizedBox(
        width: AppSizes.sidebarWidth,
        child: Drawer(child: sidebar),
      ),
      body: child,
    );
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

  void _confirmLogout(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.logoutTitle),
        content: Text(l10n.logoutConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel)),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final authState = ref.read(authProvider);
              if (authState is AuthAuthenticated && authState.user.storeId != null) {
                ref
                    .read(securityRepositoryProvider)
                    .endAllSessions(storeId: authState.user.storeId!)
                    .catchError((_) => <String, dynamic>{});
              }
              ref.read(authProvider.notifier).logout();
            },
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
  }
}
