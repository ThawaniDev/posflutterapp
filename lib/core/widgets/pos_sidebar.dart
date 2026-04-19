import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A navigation item definition for [PosSidebar].
class PosSidebarItem {
  PosSidebarItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    this.route,
    this.badge,
    this.children,
    this.permission,
  });

  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String? route;

  /// The permission code required to see this item. Null = always visible.
  final String? permission;

  /// Optional badge count (e.g. pending orders).
  final int? badge;

  /// Nested sub-items (one level deep).
  final List<PosSidebarItem>? children;
}

/// A logical group of sidebar items rendered as an accordion section.
class PosSidebarGroup {
  PosSidebarGroup({required this.label, required this.icon, required this.items});

  final String label;
  final IconData icon;
  final List<PosSidebarItem> items;
}

/// Wameed POS Sidebar — fixed 256px desktop drawer with collapsible mobile.
///
/// All 37 features are grouped into accordion sections, expanded by default.
class PosSidebar extends StatefulWidget {
  const PosSidebar({
    super.key,
    this.groups,
    this.currentRoute,
    this.onItemTap,
    this.isCollapsed = false,
    this.onToggleCollapse,
    this.headerWidget,
    this.footerWidget,
  });

  /// Nav groups. Defaults to [getDefaultGroups] which covers all 37 features.
  final List<PosSidebarGroup>? groups;

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
  State<PosSidebar> createState() => _PosSidebarState();

  // ─── Default grouped navigation for all 37 features ────────

  static List<PosSidebarGroup> getDefaultGroups(AppLocalizations l10n) => [
    // Core
    PosSidebarGroup(
      label: l10n.sidebarGroupCore,
      icon: Icons.dashboard_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarDashboard,
          icon: Icons.dashboard_rounded,
          route: '/dashboard',
          permission: Permissions.dashboardView,
        ),
        PosSidebarItem(
          label: l10n.sidebarPosTerminal,
          icon: Icons.point_of_sale_rounded,
          route: '/pos',
          permission: Permissions.posSell,
          children: [
            PosSidebarItem(
              label: l10n.sidebarTerminals,
              icon: Icons.devices_other_rounded,
              route: '/pos/terminals',
              permission: Permissions.posManageTerminals,
            ),
            PosSidebarItem(
              label: l10n.sidebarSessions,
              icon: Icons.receipt_long_rounded,
              route: '/pos/sessions',
              permission: Permissions.posViewSessions,
            ),
          ],
        ),
        PosSidebarItem(
          label: l10n.sidebarOrders,
          icon: Icons.receipt_long_rounded,
          route: '/orders',
          permission: Permissions.ordersView,
        ),
        PosSidebarItem(
          label: l10n.sidebarTransactions,
          icon: Icons.swap_horiz_rounded,
          route: '/transactions',
          permission: Permissions.transactionsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarPayments,
          icon: Icons.payments_rounded,
          route: '/cash-management',
          permission: Permissions.cashManage,
        ),
      ],
    ),

    // Catalog & Inventory
    PosSidebarGroup(
      label: l10n.sidebarGroupCatalog,
      icon: Icons.inventory_2_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarProducts,
          icon: Icons.inventory_2_rounded,
          route: '/products',
          permission: Permissions.productsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarCategories,
          icon: Icons.category_rounded,
          route: '/categories',
          permission: Permissions.productsManageCategories,
        ),
        PosSidebarItem(
          label: l10n.sidebarSuppliers,
          icon: Icons.people_alt_rounded,
          route: '/suppliers',
          permission: Permissions.productsManageSuppliers,
        ),
        PosSidebarItem(
          label: l10n.sidebarInventory,
          icon: Icons.warehouse_rounded,
          route: '/inventory',
          permission: Permissions.inventoryView,
        ),
        PosSidebarItem(
          label: l10n.sidebarLabels,
          icon: Icons.label_rounded,
          route: '/labels',
          permission: Permissions.labelsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarPredefinedCatalog,
          icon: Icons.auto_awesome_rounded,
          route: '/predefined-catalog',
          permission: Permissions.productsUsePredefined,
        ),
      ],
    ),

    // People
    PosSidebarGroup(
      label: l10n.sidebarGroupPeople,
      icon: Icons.people_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarCustomers,
          icon: Icons.people_rounded,
          route: '/customers',
          permission: Permissions.customersView,
        ),
        PosSidebarItem(
          label: l10n.sidebarStaffMembers,
          icon: Icons.badge_rounded,
          route: '/staff/members',
          permission: Permissions.staffView,
        ),
        PosSidebarItem(
          label: l10n.sidebarRolesPermissions,
          icon: Icons.admin_panel_settings_rounded,
          route: '/staff/roles',
          permission: Permissions.rolesView,
        ),
        PosSidebarItem(
          label: l10n.sidebarAttendance,
          icon: Icons.access_time_rounded,
          route: '/staff/attendance',
          permission: Permissions.reportsAttendance,
        ),
        PosSidebarItem(
          label: l10n.sidebarShiftSchedule,
          icon: Icons.calendar_month_rounded,
          route: '/staff/shifts',
          permission: Permissions.staffManageShifts,
        ),
      ],
    ),

    // Business
    PosSidebarGroup(
      label: l10n.sidebarGroupBusiness,
      icon: Icons.business_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarBranches,
          icon: Icons.store_rounded,
          route: '/branches',
          permission: Permissions.branchesView,
        ),
        PosSidebarItem(
          label: l10n.sidebarAccounting,
          icon: Icons.account_balance_rounded,
          route: '/accounting',
          permission: Permissions.accountingViewHistory,
        ),
        PosSidebarItem(
          label: l10n.sidebarDebits,
          icon: Icons.account_balance_wallet_rounded,
          route: '/debits',
          permission: Permissions.customersManageDebits,
        ),
        PosSidebarItem(
          label: l10n.sidebarReceivables,
          icon: Icons.receipt_long_rounded,
          route: '/receivables',
          permission: Permissions.customersManageReceivables,
        ),
        PosSidebarItem(
          label: l10n.sidebarPromotions,
          icon: Icons.local_offer_rounded,
          route: '/promotions',
          permission: Permissions.promotionsManage,
        ),
        PosSidebarItem(
          label: l10n.sidebarInstallments,
          icon: Icons.calendar_month_rounded,
          route: Routes.settingsInstallments,
          permission: Permissions.installmentsConfigure,
        ),
      ],
    ),

    // Reports
    PosSidebarGroup(
      label: l10n.sidebarGroupReports,
      icon: Icons.bar_chart_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarReports,
          icon: Icons.bar_chart_rounded,
          route: '/reports',
          permission: Permissions.reportsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarSalesSummary,
          icon: Icons.receipt_long_rounded,
          route: '/reports/sales-summary',
          permission: Permissions.reportsSales,
        ),
        PosSidebarItem(
          label: l10n.sidebarHourlySales,
          icon: Icons.schedule_rounded,
          route: '/reports/hourly-sales',
          permission: Permissions.reportsSales,
        ),
        PosSidebarItem(
          label: l10n.sidebarProductPerformance,
          icon: Icons.inventory_2_rounded,
          route: '/reports/product-performance',
          permission: Permissions.reportsSales,
        ),
        PosSidebarItem(
          label: l10n.sidebarCategoryBreakdown,
          icon: Icons.category_rounded,
          route: '/reports/category-breakdown',
          permission: Permissions.reportsSales,
        ),
        PosSidebarItem(
          label: l10n.sidebarPaymentMethods,
          icon: Icons.payment_rounded,
          route: '/reports/payment-methods',
          permission: Permissions.reportsSales,
        ),
        PosSidebarItem(
          label: l10n.sidebarStaffPerformance,
          icon: Icons.people_rounded,
          route: '/reports/staff-performance',
          permission: Permissions.reportsStaff,
        ),
        PosSidebarItem(
          label: l10n.sidebarInventoryReports,
          icon: Icons.warehouse_rounded,
          route: '/reports/inventory',
          permission: Permissions.reportsInventory,
        ),
        PosSidebarItem(
          label: l10n.sidebarFinancialReports,
          icon: Icons.account_balance_wallet_rounded,
          route: '/reports/financial',
          permission: Permissions.reportsViewFinancial,
        ),
        PosSidebarItem(
          label: l10n.sidebarCustomerReports,
          icon: Icons.group_rounded,
          route: '/reports/customers',
          permission: Permissions.reportsCustomers,
        ),
      ],
    ),

    // Integrations
    PosSidebarGroup(
      label: l10n.sidebarGroupIntegrations,
      icon: Icons.extension_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarThawaniIntegration,
          icon: Icons.delivery_dining_sharp,
          route: '/thawani-integration',
          permission: Permissions.thawaniViewDashboard,
        ),
        PosSidebarItem(
          label: l10n.sidebarDelivery,
          icon: Icons.local_shipping_rounded,
          route: '/delivery',
          permission: Permissions.deliveryViewDashboard,
        ),
        PosSidebarItem(
          label: l10n.sidebarZatca,
          icon: Icons.verified_rounded,
          route: '/zatca',
          permission: Permissions.zatcaView,
        ),
      ],
    ),

    // Hardware & Sync
    PosSidebarGroup(
      label: l10n.sidebarGroupHardware,
      icon: Icons.print_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarHardware,
          icon: Icons.print_rounded,
          route: '/hardware',
          permission: Permissions.hardwareView,
        ),
        PosSidebarItem(label: l10n.sidebarSync, icon: Icons.sync_rounded, route: '/sync', permission: Permissions.syncView),
        PosSidebarItem(
          label: l10n.sidebarBackup,
          icon: Icons.backup_rounded,
          route: '/backup',
          permission: Permissions.backupView,
        ),
      ],
    ),

    // Industry Verticals
    PosSidebarGroup(
      label: l10n.sidebarGroupIndustry,
      icon: Icons.storefront_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarRestaurant,
          icon: Icons.restaurant_rounded,
          route: '/industry/restaurant',
          permission: Permissions.restaurantView,
        ),
        PosSidebarItem(
          label: l10n.sidebarBakery,
          icon: Icons.cake_rounded,
          route: '/industry/bakery',
          permission: Permissions.bakeryView,
        ),
        PosSidebarItem(
          label: l10n.sidebarPharmacy,
          icon: Icons.local_pharmacy_rounded,
          route: '/industry/pharmacy',
          permission: Permissions.pharmacyView,
        ),
        PosSidebarItem(
          label: l10n.sidebarElectronics,
          icon: Icons.devices_rounded,
          route: '/industry/electronics',
          permission: Permissions.mobileView,
        ),
        PosSidebarItem(
          label: l10n.sidebarFlorist,
          icon: Icons.local_florist_rounded,
          route: '/industry/florist',
          permission: Permissions.flowersView,
        ),
        PosSidebarItem(
          label: l10n.sidebarJewelry,
          icon: Icons.diamond_rounded,
          route: '/industry/jewelry',
          permission: Permissions.jewelryView,
        ),
      ],
    ),

    // Settings & Tools
    PosSidebarGroup(
      label: l10n.sidebarGroupSettings,
      icon: Icons.settings_rounded,
      items: [
        PosSidebarItem(
          label: l10n.sidebarWameedAI,
          icon: Icons.auto_awesome_rounded,
          route: '/wameed-ai',
          permission: Permissions.wameedAiView,
          children: [
            PosSidebarItem(
              label: l10n.wameedAISuggestions,
              icon: Icons.lightbulb_rounded,
              route: '/wameed-ai/suggestions',
              permission: Permissions.wameedAiView,
            ),
            PosSidebarItem(
              label: l10n.wameedAIUsage,
              icon: Icons.bar_chart_rounded,
              route: '/wameed-ai/usage',
              permission: Permissions.wameedAiView,
            ),
            PosSidebarItem(
              label: l10n.wameedAIBilling,
              icon: Icons.payment_rounded,
              route: '/wameed-ai/billing',
              permission: Permissions.wameedAiView,
            ),
            PosSidebarItem(
              label: l10n.wameedAISettings,
              icon: Icons.settings_rounded,
              route: '/wameed-ai/settings',
              permission: Permissions.wameedAiManage,
            ),
          ],
        ),
        PosSidebarItem(
          label: l10n.sidebarCashierGamification,
          icon: Icons.emoji_events_rounded,
          route: '/cashier-gamification',
          permission: Permissions.cashierPerformanceViewLeaderboard,
          children: [
            PosSidebarItem(
              label: l10n.gamificationBadges,
              icon: Icons.workspace_premium_rounded,
              route: '/cashier-gamification/badges',
              permission: Permissions.cashierPerformanceViewBadges,
            ),
            PosSidebarItem(
              label: l10n.gamificationAnomalies,
              icon: Icons.warning_amber_rounded,
              route: '/cashier-gamification/anomalies',
              permission: Permissions.cashierPerformanceViewAnomalies,
            ),
            PosSidebarItem(
              label: l10n.gamificationShiftReports,
              icon: Icons.assessment_rounded,
              route: '/cashier-gamification/shift-reports',
              permission: Permissions.cashierPerformanceViewReports,
            ),
            PosSidebarItem(
              label: l10n.gamificationSettings,
              icon: Icons.settings_rounded,
              route: '/cashier-gamification/settings',
              permission: Permissions.cashierPerformanceManageSettings,
            ),
          ],
        ),
        PosSidebarItem(
          label: l10n.sidebarPosCustomize,
          icon: Icons.tune_rounded,
          route: '/customization',
          permission: Permissions.posCustomizationView,
          children: [
            PosSidebarItem(
              label: l10n.sidebarLayoutBuilder,
              icon: Icons.dashboard_customize_rounded,
              route: '/layout-templates',
              permission: Permissions.layoutBuilderView,
            ),
            PosSidebarItem(
              label: l10n.sidebarMarketplace,
              icon: Icons.storefront_rounded,
              route: '/marketplace',
              permission: Permissions.marketplaceView,
            ),
            PosSidebarItem(
              label: l10n.sidebarReceiptTemplates,
              icon: Icons.receipt_long_rounded,
              route: '/receipt-templates',
              permission: Permissions.posCustomizationView,
            ),
            PosSidebarItem(
              label: l10n.sidebarCfdThemes,
              icon: Icons.tv_rounded,
              route: '/cfd-themes',
              permission: Permissions.posCustomizationView,
            ),
            PosSidebarItem(
              label: l10n.sidebarLabelLayoutTemplates,
              icon: Icons.label_rounded,
              route: '/label-layout-templates',
              permission: Permissions.posCustomizationView,
            ),
          ],
        ),
        PosSidebarItem(
          label: l10n.sidebarCompanionApp,
          icon: Icons.phone_android_rounded,
          route: '/companion',
          permission: Permissions.companionView,
        ),
        PosSidebarItem(
          label: l10n.sidebarNiceToHave,
          icon: Icons.auto_awesome_rounded,
          route: '/nice-to-have',
          permission: Permissions.niceToHaveView,
        ),
        PosSidebarItem(
          label: l10n.sidebarNotifications,
          icon: Icons.notifications_rounded,
          route: '/notifications',
          permission: Permissions.notificationsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarSecurity,
          icon: Icons.security_rounded,
          route: '/security',
          permission: Permissions.securityViewDashboard,
        ),
        PosSidebarItem(
          label: l10n.sidebarAccessibility,
          icon: Icons.accessibility_new_rounded,
          route: '/accessibility',
          permission: Permissions.accessibilityManage,
        ),
        PosSidebarItem(
          label: l10n.sidebarLocalization,
          icon: Icons.translate_rounded,
          route: '/settings/localization',
          permission: Permissions.settingsLocalization,
        ),
        PosSidebarItem(
          label: l10n.sidebarAutoUpdate,
          icon: Icons.system_update_rounded,
          route: '/auto-update',
          permission: Permissions.autoUpdateView,
        ),
        PosSidebarItem(
          label: l10n.sidebarSettings,
          icon: Icons.settings_rounded,
          route: '/settings',
          permission: Permissions.settingsView,
        ),
        PosSidebarItem(
          label: l10n.sidebarSubscription,
          icon: Icons.card_membership_rounded,
          route: '/subscription/status',
          permission: Permissions.subscriptionView,
        ),
        PosSidebarItem(
          label: l10n.sidebarSupport,
          icon: Icons.support_agent_rounded,
          route: '/support',
          permission: Permissions.supportView,
          children: [
            PosSidebarItem(
              label: l10n.sidebarTickets,
              icon: Icons.confirmation_number_rounded,
              route: '/support',
              permission: Permissions.supportView,
            ),
            PosSidebarItem(
              label: l10n.sidebarKnowledgeBase,
              icon: Icons.menu_book_rounded,
              route: '/support/kb',
              permission: Permissions.supportView,
            ),
          ],
        ),
      ],
    ),
  ];

  /// Legacy flat list accessor for backward compatibility.
  static List<PosSidebarItem> getDefaultItems(AppLocalizations l10n) {
    return getDefaultGroups(l10n).expand((g) => g.items).toList();
  }
}

class _PosSidebarState extends State<PosSidebar> {
  /// Tracks expanded state of items that have children.
  /// Key = "groupIndex.itemIndex", Value = isExpanded
  final Map<String, bool> _expandedItems = {};

  /// Tracks expanded state of group sections.
  final Map<int, bool> _expandedGroups = {};

  bool _isItemExpanded(int groupIndex, int itemIndex, PosSidebarItem item) {
    final key = '$groupIndex.$itemIndex';
    if (_expandedItems.containsKey(key)) return _expandedItems[key]!;
    // Default: expanded if a child route matches the current route.
    if (item.children != null && widget.currentRoute != null) {
      return item.children!.any((c) => c.route == widget.currentRoute);
    }
    return false;
  }

  bool _isGroupExpanded(int groupIndex, PosSidebarGroup group) {
    if (_expandedGroups.containsKey(groupIndex)) return _expandedGroups[groupIndex]!;
    // Default: only the first group is expanded, OR any group containing the active route.
    if (widget.currentRoute != null) {
      final hasActive = group.items.any(
        (item) => item.route == widget.currentRoute || (item.children?.any((c) => c.route == widget.currentRoute) ?? false),
      );
      if (hasActive) return true;
    }
    return groupIndex == 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    final navGroups = widget.groups ?? (l10n != null ? PosSidebar.getDefaultGroups(l10n) : <PosSidebarGroup>[]);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: widget._width,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.surfaceLight,
        border: Border(right: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        children: [
          context.isPhone ? const SizedBox(height: 50) : const SizedBox.shrink(),
          // ─ Header ─
          if (widget.headerWidget != null) widget.headerWidget!,
          if (widget.headerWidget == null) _DefaultHeader(isCollapsed: widget.isCollapsed),

          // ─ Collapse toggle ─
          if (widget.onToggleCollapse != null && !context.isPhone)
            _CollapseToggle(isCollapsed: widget.isCollapsed, onTap: widget.onToggleCollapse!),

          // ─ Grouped Nav Items ─
          Expanded(child: widget.isCollapsed ? _buildCollapsedList(navGroups) : _buildGroupedList(navGroups)),

          // ─ Footer ─
          if (widget.footerWidget != null) ...[const Divider(height: 1), widget.footerWidget!],
        ],
      ),
    );
  }

  /// Collapsed mode: flat icon-only list without group headers.
  Widget _buildCollapsedList(List<PosSidebarGroup> groups) {
    final allItems = groups.expand((g) => g.items).toList();
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemCount: allItems.length,
      itemBuilder: (_, i) => _NavItemTile(
        item: allItems[i],
        isActive: widget.currentRoute == allItems[i].route,
        isCollapsed: true,
        onTap: () {
          if (allItems[i].route != null) {
            widget.onItemTap?.call(allItems[i].route!);
          }
        },
      ),
    );
  }

  /// Expanded mode: collapsible section groups with items.
  /// Items with children are individually expandable inline.
  Widget _buildGroupedList(List<PosSidebarGroup> groups) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];

        return _SidebarGroupSection(
          group: group,
          groupIndex: groupIndex,
          isGroupExpanded: _isGroupExpanded(groupIndex, group),
          onToggleGroup: () {
            setState(() {
              _expandedGroups[groupIndex] = !_isGroupExpanded(groupIndex, group);
            });
          },
          currentRoute: widget.currentRoute,
          onItemTap: widget.onItemTap,
          isItemExpanded: (itemIndex, item) => _isItemExpanded(groupIndex, itemIndex, item),
          onToggleItem: (itemIndex, item) {
            setState(() {
              final key = '$groupIndex.$itemIndex';
              _expandedItems[key] = !_isItemExpanded(groupIndex, itemIndex, item);
            });
          },
        );
      },
    );
  }
}

// ─── Default Header (logo + store) ───────────────────────────

class _DefaultHeader extends ConsumerWidget {
  const _DefaultHeader({required this.isCollapsed});

  final bool isCollapsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final user = ref.watch(currentUserProvider);
    final isArabic = Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';
    final orgName = isArabic
        ? (user?.organization?.nameAr ?? user?.organization?.name)
        : (user?.organization?.name ?? user?.organization?.nameAr);
    final storeName = isArabic ? (user?.store?.nameAr ?? user?.store?.name) : (user?.store?.name ?? user?.store?.nameAr);
    final displayName = orgName ?? storeName ?? AppLocalizations.of(context)?.appTitle ?? 'Wameed POS';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        children: [
          // Diamond logo mark
          // Transform.rotate(
          //   angle: 0.785398, // 45deg
          //   child: Container(
          //     width: 22,
          //     height: 22,
          //     decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(4)),
          //   ),
          // ),
          // assets/images/wameedlogo.png
          // assets/images/wameedlogowhite.png
          Image.asset(isDark ? 'assets/images/wameedlogowhite.png' : 'assets/images/wameedlogo.png', width: 28, height: 28),

          // Organization name (only in expanded mode)
          if (!isCollapsed) ...[
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //app title
                  Text(
                    AppLocalizations.of(context)?.appTitle ?? 'Wameed POS',
                    style: AppTypography.titleLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                    ),
                  ),
                  Text(
                    displayName,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Group Section (collapsible label + items) ───────────────

class _SidebarGroupSection extends StatelessWidget {
  const _SidebarGroupSection({
    required this.group,
    required this.groupIndex,
    required this.isGroupExpanded,
    required this.onToggleGroup,
    required this.currentRoute,
    required this.onItemTap,
    required this.isItemExpanded,
    required this.onToggleItem,
  });

  final PosSidebarGroup group;
  final int groupIndex;
  final bool isGroupExpanded;
  final VoidCallback onToggleGroup;
  final String? currentRoute;
  final ValueChanged<String>? onItemTap;
  final bool Function(int itemIndex, PosSidebarItem item) isItemExpanded;
  final void Function(int itemIndex, PosSidebarItem item) onToggleItem;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─ Collapsible section header (sentence case + chevron) ─
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onTap: onToggleGroup,
            borderRadius: AppRadius.borderMd,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      group.label,
                      style: AppTypography.bodyMedium.copyWith(color: mutedColor, fontWeight: FontWeight.w600),
                    ),
                  ),
                  AnimatedRotation(
                    turns: isGroupExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more_rounded, size: 18, color: mutedColor),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ─ Group items (animated expand/collapse) ─
        AnimatedCrossFade(
          firstChild: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < group.items.length; i++) ...[
                _NavItemTile(
                  item: group.items[i],
                  isActive: currentRoute == group.items[i].route,
                  isCollapsed: false,
                  isExpanded: isItemExpanded(i, group.items[i]),
                  onTap: () {
                    if (group.items[i].children != null && group.items[i].children!.isNotEmpty) {
                      onToggleItem(i, group.items[i]);
                    } else if (group.items[i].route != null) {
                      onItemTap?.call(group.items[i].route!);
                    }
                  },
                ),
                if (group.items[i].children != null && isItemExpanded(i, group.items[i]))
                  for (final child in group.items[i].children!)
                    _SubNavItemTile(
                      item: child,
                      isActive: currentRoute == child.route,
                      onTap: () {
                        if (child.route != null) onItemTap?.call(child.route!);
                      },
                    ),
              ],
            ],
          ),
          secondChild: const SizedBox(width: double.infinity),
          crossFadeState: isGroupExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}

// ─── Single Nav Item Tile ────────────────────────────────────

class _NavItemTile extends StatelessWidget {
  const _NavItemTile({
    required this.item,
    required this.isActive,
    required this.isCollapsed,
    required this.onTap,
    this.isExpanded = false,
  });

  final PosSidebarItem item;
  final bool isActive;
  final bool isCollapsed;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasChildren = item.children != null && item.children!.isNotEmpty;

    final activeBg = AppColors.primary10;
    final activeFg = AppColors.primary;
    final inactiveFg = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    final fg = isActive ? activeFg : inactiveFg;

    Widget content = Material(
      color: isActive ? activeBg : Colors.transparent,
      borderRadius: AppRadius.borderMd,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderMd,
        child: Container(
          height: 40,
          padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 12),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(isActive ? (item.activeIcon ?? item.icon) : item.icon, size: 20, color: fg),
              if (!isCollapsed) ...[
                AppSpacing.gapW12,
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTypography.bodyMedium.copyWith(color: fg, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500),
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
                if (hasChildren)
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.expand_more_rounded, size: 18, color: fg),
                  ),
              ],
            ],
          ),
        ),
      ),
    );

    if (isCollapsed) {
      content = Tooltip(message: item.label, waitDuration: const Duration(milliseconds: 500), child: content);
    }

    return Padding(padding: const EdgeInsets.symmetric(vertical: 1), child: content);
  }
}

// ─── Sub Nav Item Tile (indented child with dash prefix) ─────

class _SubNavItemTile extends StatelessWidget {
  const _SubNavItemTile({required this.item, required this.isActive, required this.onTap});

  final PosSidebarItem item;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeFg = AppColors.primary;
    final inactiveFg = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;
    final fg = isActive ? activeFg : inactiveFg;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppRadius.borderMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderMd,
          child: Container(
            height: 34,
            padding: const EdgeInsets.only(left: 36, right: 12),
            child: Row(
              children: [
                Text(
                  '-',
                  style: AppTypography.bodyMedium.copyWith(color: fg, fontWeight: FontWeight.w400),
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTypography.bodySmall.copyWith(color: fg, fontWeight: isActive ? FontWeight.w600 : FontWeight.w400),
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
            ),
          ),
        ),
      ),
    );
  }
}
