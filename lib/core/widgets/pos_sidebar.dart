import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A navigation item definition for [PosSidebar].
class PosSidebarItem {
  PosSidebarItem({required this.label, required this.icon, this.activeIcon, this.route, this.badge, this.children});

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
    final l10n = AppLocalizations.of(context);
    final navItems = items ?? (l10n != null ? getDefaultItems(l10n) : []);

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

  static List<PosSidebarItem> getDefaultItems(AppLocalizations l10n) => [
    // Core
    PosSidebarItem(label: l10n.sidebarDashboard, icon: Icons.dashboard_rounded, route: '/dashboard'),
    PosSidebarItem(
      label: l10n.sidebarPosTerminal,
      icon: Icons.point_of_sale_rounded,
      route: '/pos',
      children: [
        PosSidebarItem(label: l10n.sidebarTerminals, icon: Icons.devices_other_rounded, route: '/pos/terminals'),
        PosSidebarItem(label: l10n.sidebarSessions, icon: Icons.receipt_long_rounded, route: '/pos/sessions'),
      ],
    ),
    PosSidebarItem(label: l10n.sidebarOrders, icon: Icons.receipt_long_rounded, route: '/orders'),
    PosSidebarItem(label: l10n.sidebarPayments, icon: Icons.payments_rounded, route: '/cash-management'),

    // Catalog & Inventory
    PosSidebarItem(label: l10n.sidebarProducts, icon: Icons.inventory_2_rounded, route: '/products'),
    PosSidebarItem(label: l10n.sidebarCategories, icon: Icons.category_rounded, route: '/categories'),
    PosSidebarItem(label: l10n.sidebarSuppliers, icon: Icons.people_alt_rounded, route: '/suppliers'),
    PosSidebarItem(label: l10n.sidebarInventory, icon: Icons.warehouse_rounded, route: '/inventory'),
    PosSidebarItem(label: l10n.sidebarLabels, icon: Icons.label_rounded, route: '/labels'),

    // People
    PosSidebarItem(label: l10n.sidebarCustomers, icon: Icons.people_rounded, route: '/customers'),
    PosSidebarItem(label: l10n.sidebarStaffMembers, icon: Icons.badge_rounded, route: '/staff/members'),
    PosSidebarItem(label: l10n.sidebarRolesPermissions, icon: Icons.admin_panel_settings_rounded, route: '/staff/roles'),
    PosSidebarItem(label: l10n.sidebarAttendance, icon: Icons.access_time_rounded, route: '/staff/attendance'),
    PosSidebarItem(label: l10n.sidebarShiftSchedule, icon: Icons.calendar_month_rounded, route: '/staff/shifts'),

    // Business
    PosSidebarItem(label: l10n.sidebarBranches, icon: Icons.store_rounded, route: '/branches'),
    PosSidebarItem(label: l10n.sidebarAccounting, icon: Icons.account_balance_rounded, route: '/accounting'),
    PosSidebarItem(label: l10n.sidebarReports, icon: Icons.bar_chart_rounded, route: '/reports'),
    PosSidebarItem(label: l10n.sidebarSalesSummary, icon: Icons.receipt_long_rounded, route: '/reports/sales-summary'),
    PosSidebarItem(label: l10n.sidebarHourlySales, icon: Icons.schedule_rounded, route: '/reports/hourly-sales'),
    PosSidebarItem(label: l10n.sidebarProductPerformance, icon: Icons.inventory_2_rounded, route: '/reports/product-performance'),
    PosSidebarItem(label: l10n.sidebarCategoryBreakdown, icon: Icons.category_rounded, route: '/reports/category-breakdown'),
    PosSidebarItem(label: l10n.sidebarPaymentMethods, icon: Icons.payment_rounded, route: '/reports/payment-methods'),
    PosSidebarItem(label: l10n.sidebarStaffPerformance, icon: Icons.people_rounded, route: '/reports/staff-performance'),
    PosSidebarItem(label: l10n.sidebarInventoryReports, icon: Icons.warehouse_rounded, route: '/reports/inventory'),
    PosSidebarItem(label: l10n.sidebarFinancialReports, icon: Icons.account_balance_wallet_rounded, route: '/reports/financial'),
    PosSidebarItem(label: l10n.sidebarCustomerReports, icon: Icons.group_rounded, route: '/reports/customers'),
    PosSidebarItem(label: l10n.sidebarPromotions, icon: Icons.local_offer_rounded, route: '/promotions'),

    // Integrations
    PosSidebarItem(label: l10n.sidebarThawaniPay, icon: Icons.credit_card_rounded, route: '/thawani-pay'),
    PosSidebarItem(label: l10n.sidebarDelivery, icon: Icons.local_shipping_rounded, route: '/delivery'),
    PosSidebarItem(label: l10n.sidebarZatca, icon: Icons.verified_rounded, route: '/zatca'),

    // Hardware & Sync
    PosSidebarItem(label: l10n.sidebarHardware, icon: Icons.print_rounded, route: '/hardware'),
    PosSidebarItem(label: l10n.sidebarSync, icon: Icons.sync_rounded, route: '/sync'),
    PosSidebarItem(label: l10n.sidebarBackup, icon: Icons.backup_rounded, route: '/backup'),

    // Industry Verticals
    PosSidebarItem(label: l10n.sidebarRestaurant, icon: Icons.restaurant_rounded, route: '/industry/restaurant'),
    PosSidebarItem(label: l10n.sidebarBakery, icon: Icons.cake_rounded, route: '/industry/bakery'),
    PosSidebarItem(label: l10n.sidebarPharmacy, icon: Icons.local_pharmacy_rounded, route: '/industry/pharmacy'),
    PosSidebarItem(label: l10n.sidebarElectronics, icon: Icons.devices_rounded, route: '/industry/electronics'),
    PosSidebarItem(label: l10n.sidebarFlorist, icon: Icons.local_florist_rounded, route: '/industry/florist'),
    PosSidebarItem(label: l10n.sidebarJewelry, icon: Icons.diamond_rounded, route: '/industry/jewelry'),

    // Tools
    PosSidebarItem(label: l10n.sidebarCompanionApp, icon: Icons.phone_android_rounded, route: '/companion'),
    PosSidebarItem(label: l10n.sidebarNiceToHave, icon: Icons.auto_awesome_rounded, route: '/nice-to-have'),

    // Settings & Support
    PosSidebarItem(
      label: l10n.sidebarPosCustomize,
      icon: Icons.tune_rounded,
      route: '/customization',
      children: [
        PosSidebarItem(label: l10n.sidebarLayoutBuilder, icon: Icons.dashboard_customize_rounded, route: '/layout-templates'),
        PosSidebarItem(label: l10n.sidebarMarketplace, icon: Icons.storefront_rounded, route: '/marketplace'),
        PosSidebarItem(label: l10n.sidebarReceiptTemplates, icon: Icons.receipt_long_rounded, route: '/receipt-templates'),
        PosSidebarItem(label: l10n.sidebarCfdThemes, icon: Icons.tv_rounded, route: '/cfd-themes'),
        PosSidebarItem(label: l10n.sidebarLabelLayoutTemplates, icon: Icons.label_rounded, route: '/label-layout-templates'),
      ],
    ),
    PosSidebarItem(label: l10n.sidebarNotifications, icon: Icons.notifications_rounded, route: '/notifications'),
    PosSidebarItem(label: l10n.sidebarSecurity, icon: Icons.security_rounded, route: '/security'),
    PosSidebarItem(label: l10n.sidebarAccessibility, icon: Icons.accessibility_new_rounded, route: '/accessibility'),
    PosSidebarItem(label: l10n.sidebarLocalization, icon: Icons.translate_rounded, route: '/settings/localization'),
    PosSidebarItem(label: l10n.sidebarAutoUpdate, icon: Icons.system_update_rounded, route: '/auto-update'),
    PosSidebarItem(label: l10n.sidebarSettings, icon: Icons.settings_rounded, route: '/settings'),
    PosSidebarItem(label: l10n.sidebarSubscription, icon: Icons.card_membership_rounded, route: '/subscription/status'),
    PosSidebarItem(label: l10n.sidebarOnboarding, icon: Icons.rocket_launch_rounded, route: '/onboarding'),

    // Admin Panel
    // PosSidebarItem(label: l10n.sidebarAdminStores, icon: Icons.store_rounded, route: '/admin/stores'),
    PosSidebarItem(
      label: l10n.sidebarSupport,
      icon: Icons.support_agent_rounded,
      route: '/support',
      children: [
        PosSidebarItem(label: l10n.sidebarTickets, icon: Icons.confirmation_number_rounded, route: '/support'),
        PosSidebarItem(label: l10n.sidebarKnowledgeBase, icon: Icons.menu_book_rounded, route: '/support/kb'),
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
                  Builder(
                    builder: (ctx) {
                      final l10n = AppLocalizations.of(ctx);
                      return Text(
                        l10n?.sidebarStoreName ?? 'Store Name',
                        style: AppTypography.caption.copyWith(color: AppColors.textMutedLight),
                      );
                    },
                  ),
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
