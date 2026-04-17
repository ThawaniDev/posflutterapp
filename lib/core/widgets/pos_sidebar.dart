import 'package:flutter/material.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
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
  late Map<int, bool> _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = {};
  }

  /// Returns true if the group should be expanded (default: all open).
  bool _isGroupExpanded(int index, PosSidebarGroup group) {
    // Default: expanded if it contains active route, or if never toggled (all open by default)
    return _expanded[index] ?? true;
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

          const Divider(height: 1),

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

  /// Expanded mode: accordion groups with items.
  Widget _buildGroupedList(List<PosSidebarGroup> groups) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      itemCount: groups.length,
      itemBuilder: (context, groupIndex) {
        final group = groups[groupIndex];
        final isExpanded = _isGroupExpanded(groupIndex, group);

        return _SidebarGroupTile(
          group: group,
          isExpanded: isExpanded,
          onToggle: () {
            setState(() {
              _expanded[groupIndex] = !isExpanded;
            });
          },
          currentRoute: widget.currentRoute,
          onItemTap: widget.onItemTap,
        );
      },
    );
  }
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
                        style: AppTypography.caption.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textMutedDark
                              : AppColors.textMutedLight,
                        ),
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
              color: Theme.of(context).brightness == Brightness.dark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Accordion Group Tile ────────────────────────────────────

class _SidebarGroupTile extends StatelessWidget {
  const _SidebarGroupTile({
    required this.group,
    required this.isExpanded,
    required this.onToggle,
    required this.currentRoute,
    required this.onItemTap,
  });

  final PosSidebarGroup group;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String? currentRoute;
  final ValueChanged<String>? onItemTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final mutedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─ Group header (tap to expand/collapse) ─
        InkWell(
          onTap: onToggle,
          borderRadius: AppRadius.borderMd,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Icon(group.icon, size: 16, color: mutedColor),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(
                    group.label,
                    style: AppTypography.caption.copyWith(color: mutedColor, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.0 : -0.25,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.expand_more_rounded, size: 16, color: mutedColor),
                ),
              ],
            ),
          ),
        ),

        // ─ Group items (animated) ─
        AnimatedCrossFade(
          firstChild: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final item in group.items)
                _NavItemTile(
                  item: item,
                  isActive: currentRoute == item.route,
                  isCollapsed: false,
                  onTap: () {
                    if (item.route != null) {
                      onItemTap?.call(item.route!);
                    }
                  },
                ),
            ],
          ),
          secondChild: const SizedBox.shrink(),
          crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
          sizeCurve: Curves.easeInOut,
        ),

        // ─ Subtle divider between groups ─
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          child: Divider(height: 1, color: (isDark ? AppColors.borderDark : AppColors.borderLight).withAlpha(80)),
        ),
      ],
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
