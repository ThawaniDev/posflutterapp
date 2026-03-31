import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A navigation item definition for [PosSidebar].
class PosSidebarItem {
  const PosSidebarItem({required this.label, required this.icon, this.activeIcon, this.route, this.badge, this.children});

  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? route;

  /// Optional badge count (e.g. pending orders).
  final int? badge;

  /// Nested sub-items (one level deep).
  final List<PosSidebarItem>? children;
}

/// Wameed POS Sidebar — fixed 256px desktop drawer with collapsible mobile.
///
/// All 37 features are pre-configured via [defaultItems].
class PosSidebar extends StatelessWidget {
  const PosSidebar({
    super.key,
    this.items,
    this.currentRoute,
    this.onItemTap,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.headerWidget,
    this.footerWidget,
  });

  /// Nav items. Defaults to [defaultItems] which covers all 37 features.
  final List<PosSidebarItem>? items;

  /// Currently active route for highlight.
  final String? currentRoute;

  /// Callback when a nav item is tapped — passes the route string.
  final ValueChanged<String>? onItemTap;

  /// Collapsed (icon-only) mode for smaller screens.
  final bool isCollapsed;
  final VoidCallback? onToggleCollapse;

  /// Optional header (e.g. logo + store name).
  final Widget? headerWidget;

  /// Optional footer (e.g. support / logout).
  final Widget? footerWidget;

  double get _width => isCollapsed ? AppSizes.sidebarCollapsedWidth : AppSizes.sidebarWidth;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navItems = items ?? defaultItems;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: _width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        border: Border(right: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        children: [
          // ─ Header ─
          if (headerWidget != null) headerWidget!,
          if (headerWidget == null) _DefaultHeader(isCollapsed: isCollapsed),

          // ─ Collapse toggle ─
          if (onToggleCollapse != null) _CollapseToggle(isCollapsed: isCollapsed, onTap: onToggleCollapse!),

          const Divider(height: 1),

          // ─ Nav Items ─
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: navItems.length,
              itemBuilder: (_, i) => _NavItemTile(
                item: navItems[i],
                isActive: currentRoute == navItems[i].route,
                isCollapsed: isCollapsed,
                onTap: () {
                  if (navItems[i].route != null) {
                    onItemTap?.call(navItems[i].route!);
                  }
                },
              ),
            ),
          ),

          // ─ Footer ─
          if (footerWidget != null) ...[const Divider(height: 1), footerWidget!],
        ],
      ),
    );
  }

  // ─── Default navigation items for all 37 features ─────────

  static const List<PosSidebarItem> defaultItems = [
    // Core
    PosSidebarItem(label: 'Dashboard', icon: Icons.dashboard_rounded, route: '/dashboard'),
    PosSidebarItem(
      label: 'POS Terminal',
      icon: Icons.point_of_sale_rounded,
      route: '/pos',
      children: [
        PosSidebarItem(label: 'Terminals', icon: Icons.devices_other_rounded, route: '/pos/terminals'),
        PosSidebarItem(label: 'Sessions', icon: Icons.receipt_long_rounded, route: '/pos/sessions'),
      ],
    ),
    PosSidebarItem(label: 'Orders', icon: Icons.receipt_long_rounded, route: '/orders'),
    PosSidebarItem(label: 'Payments', icon: Icons.payments_rounded, route: '/cash-sessions'),

    // Catalog & Inventory
    PosSidebarItem(label: 'Products', icon: Icons.inventory_2_rounded, route: '/products'),
    PosSidebarItem(label: 'Categories', icon: Icons.category_rounded, route: '/categories'),
    PosSidebarItem(label: 'Suppliers', icon: Icons.people_alt_rounded, route: '/suppliers'),
    PosSidebarItem(label: 'Inventory', icon: Icons.warehouse_rounded, route: '/inventory'),
    PosSidebarItem(label: 'Labels', icon: Icons.label_rounded, route: '/labels'),

    // People
    PosSidebarItem(label: 'Customers', icon: Icons.people_rounded, route: '/customers'),
    PosSidebarItem(label: 'Staff Members', icon: Icons.badge_rounded, route: '/staff/members'),
    PosSidebarItem(label: 'Roles & Permissions', icon: Icons.admin_panel_settings_rounded, route: '/staff/roles'),
    PosSidebarItem(label: 'Attendance', icon: Icons.access_time_rounded, route: '/staff/attendance'),
    PosSidebarItem(label: 'Shift Schedule', icon: Icons.calendar_month_rounded, route: '/staff/shifts'),

    // Business
    PosSidebarItem(label: 'Branches', icon: Icons.store_rounded, route: '/branches'),
    PosSidebarItem(label: 'Accounting', icon: Icons.account_balance_rounded, route: '/accounting'),
    PosSidebarItem(label: 'Reports', icon: Icons.bar_chart_rounded, route: '/reports'),
    PosSidebarItem(label: 'Sales Summary', icon: Icons.receipt_long_rounded, route: '/reports/sales-summary'),
    PosSidebarItem(label: 'Hourly Sales', icon: Icons.schedule_rounded, route: '/reports/hourly-sales'),
    PosSidebarItem(label: 'Product Performance', icon: Icons.inventory_2_rounded, route: '/reports/product-performance'),
    PosSidebarItem(label: 'Category Breakdown', icon: Icons.category_rounded, route: '/reports/category-breakdown'),
    PosSidebarItem(label: 'Payment Methods', icon: Icons.payment_rounded, route: '/reports/payment-methods'),
    PosSidebarItem(label: 'Staff Performance', icon: Icons.people_rounded, route: '/reports/staff-performance'),
    PosSidebarItem(label: 'Inventory Reports', icon: Icons.warehouse_rounded, route: '/reports/inventory'),
    PosSidebarItem(label: 'Financial Reports', icon: Icons.account_balance_wallet_rounded, route: '/reports/financial'),
    PosSidebarItem(label: 'Customer Reports', icon: Icons.group_rounded, route: '/reports/customers'),
    PosSidebarItem(label: 'Promotions', icon: Icons.local_offer_rounded, route: '/promotions'),

    // Integrations
    PosSidebarItem(label: 'Thawani Pay', icon: Icons.credit_card_rounded, route: '/thawani-pay'),
    PosSidebarItem(label: 'Delivery', icon: Icons.local_shipping_rounded, route: '/delivery'),
    PosSidebarItem(label: 'ZATCA', icon: Icons.verified_rounded, route: '/zatca'),

    // Hardware & Sync
    PosSidebarItem(label: 'Hardware', icon: Icons.print_rounded, route: '/hardware'),
    PosSidebarItem(label: 'Sync', icon: Icons.sync_rounded, route: '/sync'),
    PosSidebarItem(label: 'Backup', icon: Icons.backup_rounded, route: '/backup'),

    // Industry Verticals
    PosSidebarItem(label: 'Restaurant', icon: Icons.restaurant_rounded, route: '/industry/restaurant'),
    PosSidebarItem(label: 'Bakery', icon: Icons.cake_rounded, route: '/industry/bakery'),
    PosSidebarItem(label: 'Pharmacy', icon: Icons.local_pharmacy_rounded, route: '/industry/pharmacy'),
    PosSidebarItem(label: 'Electronics', icon: Icons.devices_rounded, route: '/industry/electronics'),
    PosSidebarItem(label: 'Florist', icon: Icons.local_florist_rounded, route: '/industry/florist'),
    PosSidebarItem(label: 'Jewelry', icon: Icons.diamond_rounded, route: '/industry/jewelry'),

    // Tools
    PosSidebarItem(label: 'Companion App', icon: Icons.phone_android_rounded, route: '/companion'),
    PosSidebarItem(label: 'Nice-to-Have', icon: Icons.auto_awesome_rounded, route: '/nice-to-have'),

    // Settings & Support
    PosSidebarItem(
      label: 'POS Customize',
      icon: Icons.tune_rounded,
      route: '/customization',
      children: [
        PosSidebarItem(label: 'Layout Builder', icon: Icons.dashboard_customize_rounded, route: '/layout-templates'),
        PosSidebarItem(label: 'Marketplace', icon: Icons.storefront_rounded, route: '/marketplace'),
      ],
    ),
    PosSidebarItem(label: 'Notifications', icon: Icons.notifications_rounded, route: '/notifications'),
    PosSidebarItem(label: 'Security', icon: Icons.security_rounded, route: '/security'),
    PosSidebarItem(label: 'Accessibility', icon: Icons.accessibility_new_rounded, route: '/accessibility'),
    PosSidebarItem(label: 'Localization', icon: Icons.translate_rounded, route: '/settings/localization'),
    PosSidebarItem(label: 'Auto Update', icon: Icons.system_update_rounded, route: '/auto-update'),
    PosSidebarItem(label: 'Settings', icon: Icons.settings_rounded, route: '/settings'),
    PosSidebarItem(label: 'Subscription', icon: Icons.card_membership_rounded, route: '/subscription/status'),
    PosSidebarItem(label: 'Onboarding', icon: Icons.rocket_launch_rounded, route: '/onboarding'),

    // Admin Panel
    PosSidebarItem(label: 'Admin Stores', icon: Icons.store_rounded, route: '/admin/stores'),
    PosSidebarItem(label: 'Admin Registrations', icon: Icons.app_registration_rounded, route: '/admin/registrations'),
    PosSidebarItem(
      label: 'Support',
      icon: Icons.support_agent_rounded,
      route: '/support',
      children: [
        PosSidebarItem(label: 'Tickets', icon: Icons.confirmation_number_rounded, route: '/support'),
        PosSidebarItem(label: 'Knowledge Base', icon: Icons.menu_book_rounded, route: '/support/kb'),
      ],
    ),
  ];
}

// ─── Default Header (logo + store) ───────────────────────────

class _DefaultHeader extends StatelessWidget {
  const _DefaultHeader({required this.isCollapsed});

  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: AppRadius.borderMd),
            child: const Center(
              child: Text(
                'T',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
              ),
            ),
          ),
          if (!isCollapsed) ...[
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Wameed POS', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
                  Text('Store Name', style: AppTypography.caption.copyWith(color: AppColors.textMutedLight)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Collapse Toggle Button ──────────────────────────────────

class _CollapseToggle extends StatelessWidget {
  const _CollapseToggle({required this.isCollapsed, required this.onTap});

  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.end,
          children: [
            Icon(
              isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded,
              size: 20,
              color: AppColors.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Single Nav Item Tile ────────────────────────────────────

class _NavItemTile extends StatelessWidget {
  const _NavItemTile({required this.item, required this.isActive, required this.isCollapsed, required this.onTap});

  final PosSidebarItem item;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final activeBg = AppColors.primary10;
    final activeFg = AppColors.primary;
    final inactiveFg = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final fg = isActive ? activeFg : inactiveFg;

    return Tooltip(
      message: isCollapsed ? item.label : '',
      waitDuration: const Duration(milliseconds: 500),
      child: Material(
        color: isActive ? activeBg : Colors.transparent,
        borderRadius: AppRadius.borderMd,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderMd,
          child: Container(
            height: 40,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
            decoration: isActive
                ? BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.primary, width: 3)),
                  )
                : null,
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(isActive ? (item.activeIcon ?? item.icon) : item.icon, size: 20, color: fg),
                if (!isCollapsed) ...[
                  AppSpacing.gapW12,
                  Expanded(
                    child: Text(
                      item.label,
                      style: AppTypography.bodyMedium.copyWith(
                        color: fg,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.badge != null && item.badge! > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.badge, borderRadius: AppRadius.borderFull),
                      child: Text(
                        item.badge! > 99 ? '99+' : '${item.badge}',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
