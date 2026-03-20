import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/providers/sidebar_provider.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_sidebar.dart';

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

    Widget sidebar = PosSidebar(
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

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            sidebar,
            Expanded(child: child),
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
        title: const Text('Thawani POS'),
      ),
      drawer: SizedBox(
        width: AppSizes.sidebarWidth,
        child: Drawer(child: sidebar),
      ),
      body: child,
    );
  }
}
