import 'package:thawani_pos/core/constants/permission_constants.dart';

/// Returns the permission code required to view a given route path,
/// or `null` if no permission check is needed (public / admin pages).
///
/// Uses prefix matching so that parameterised paths like `/products/abc123`
/// correctly resolve to the base permission.
///
/// Order matters — more-specific prefixes are checked first.
String? permissionForRoute(String path) {
  // Admin panel routes use a separate platform-admin permission model.
  if (path.startsWith('/admin/')) return null;

  // ── POS ──────────────────────────────────────────────
  if (path == '/pos/checkout') return Permissions.posSell;
  if (path.startsWith('/pos/shift')) return Permissions.posShiftOpen;
  if (path.startsWith('/pos/sessions')) return Permissions.posViewSessions;
  if (path.startsWith('/pos/terminals/add')) return Permissions.posManageTerminals;
  if (path.startsWith('/pos/terminals')) return Permissions.posManageTerminals;
  if (path == '/pos') return Permissions.posSell;

  // ── Catalog ──────────────────────────────────────────
  if (path == '/products/add') return Permissions.productsManage;
  if (path.startsWith('/products')) return Permissions.productsView;
  if (path.startsWith('/categories')) return Permissions.productsManageCategories;
  if (path.startsWith('/suppliers')) return Permissions.productsManageSuppliers;

  // ── Inventory ────────────────────────────────────────
  if (path.startsWith('/inventory/goods-receipts')) return Permissions.inventoryReceive;
  if (path.startsWith('/inventory/stock-adjustments')) return Permissions.inventoryAdjust;
  if (path.startsWith('/inventory/stock-transfers')) return Permissions.inventoryTransfer;
  if (path.startsWith('/inventory/purchase-orders')) return Permissions.inventoryPurchaseOrders;
  if (path.startsWith('/inventory/recipes')) return Permissions.inventoryRecipes;
  if (path.startsWith('/inventory/supplier-returns')) return Permissions.inventorySupplierReturns;
  if (path.startsWith('/inventory/stock-levels')) return Permissions.inventoryView;
  if (path.startsWith('/inventory/stock-movements')) return Permissions.inventoryView;
  if (path == '/inventory') return Permissions.inventoryView;

  // ── Orders ───────────────────────────────────────────
  if (path.startsWith('/orders')) return Permissions.ordersView;

  // ── Transactions ────────────────────────────────────
  if (path.startsWith('/transactions')) return Permissions.transactionsView;

  // ── Payments / Cash / Finance ────────────────────────
  if (path.startsWith('/cash-sessions')) return Permissions.cashViewSessions;
  if (path.startsWith('/cash-management')) return Permissions.cashManage;
  if (path.startsWith('/expenses')) return Permissions.financeExpenses;
  if (path.startsWith('/gift-cards')) return Permissions.financeGiftCards;
  if (path.startsWith('/finance/reconciliation')) return Permissions.cashReconciliation;
  if (path.startsWith('/finance/daily-summary')) return Permissions.cashViewDailySummary;

  // ── Customers ────────────────────────────────────────
  if (path.startsWith('/customers')) return Permissions.customersView;

  // ── Debits ───────────────────────────────────────────
  if (path.startsWith('/debits')) return Permissions.customersManageDebits;

  // ── Labels ───────────────────────────────────────────
  if (path.startsWith('/labels/print-queue')) return Permissions.labelsPrint;
  if (path.startsWith('/labels/designer')) return Permissions.labelsManage;
  if (path.startsWith('/labels')) return Permissions.labelsView;

  // ── Staff / Roles ────────────────────────────────────
  if (path == '/staff/members/create') return Permissions.staffCreate;
  if (path.endsWith('/edit') && path.startsWith('/staff/members/')) return Permissions.staffEdit;
  if (path.startsWith('/staff/members')) return Permissions.staffView;
  if (path == '/staff/roles/create') return Permissions.rolesCreate;
  if (path.startsWith('/staff/roles/detail')) return Permissions.rolesView;
  if (path.startsWith('/staff/roles')) return Permissions.rolesView;
  if (path.startsWith('/staff/attendance')) return Permissions.reportsAttendance;
  if (path.startsWith('/staff/shifts')) return Permissions.staffManageShifts;
  if (path.startsWith('/staff/commission')) return Permissions.financeCommissions;

  // ── Onboarding ───────────────────────────────────────
  if (path.startsWith('/onboarding')) return Permissions.onboardingManage;
  if (path.startsWith('/store/')) return Permissions.settingsManage;

  // ── Subscription ─────────────────────────────────────
  if (path.startsWith('/subscription/add-ons')) return Permissions.subscriptionManage;
  if (path.startsWith('/subscription/')) return Permissions.subscriptionView;

  // ── Reports ──────────────────────────────────────────
  if (path.startsWith('/reports/staff-performance')) return Permissions.reportsStaff;
  if (path.startsWith('/reports/inventory')) return Permissions.reportsInventory;
  if (path.startsWith('/reports/financial')) return Permissions.reportsViewFinancial;
  if (path.startsWith('/reports/customers')) return Permissions.reportsCustomers;
  if (path.startsWith('/reports/')) return Permissions.reportsSales;
  if (path == '/reports') return Permissions.reportsView;

  // ── Settings ─────────────────────────────────────────
  if (path == '/settings/installments') return Permissions.installmentsConfigure;
  if (path == '/settings/localization') return Permissions.settingsLocalization;
  if (path == '/settings' || path == '/settings/about') return Permissions.settingsView;
  if (path.startsWith('/settings/')) return Permissions.settingsManage;

  // ── Branches ─────────────────────────────────────────
  if (path.endsWith('/edit') && path.startsWith('/branches/')) return Permissions.branchesManage;
  if (path == '/branches/create') return Permissions.branchesManage;
  if (path.startsWith('/branches')) return Permissions.branchesView;

  // ── Accounting ───────────────────────────────────────
  if (path.startsWith('/accounting/mappings')) return Permissions.accountingManageMappings;
  if (path.startsWith('/accounting/auto-export')) return Permissions.accountingExport;
  if (path.startsWith('/accounting')) return Permissions.accountingViewHistory;

  // ── Promotions ───────────────────────────────────────
  if (path.startsWith('/promotions/analytics')) return Permissions.promotionsViewAnalytics;
  if (path.startsWith('/promotions')) return Permissions.promotionsManage;

  // ── Thawani ──────────────────────────────────────────
  if (path.startsWith('/thawani-integration')) return Permissions.thawaniViewDashboard;

  // ── Delivery ─────────────────────────────────────────
  if (path.startsWith('/delivery/config')) return Permissions.deliveryManageConfig;
  if (path.startsWith('/delivery/menu-sync')) return Permissions.deliverySyncMenu;
  if (path.startsWith('/delivery/webhook-logs')) return Permissions.deliveryViewLogs;
  if (path.startsWith('/delivery/status-push-logs')) return Permissions.deliveryViewLogs;
  if (path.startsWith('/delivery/orders')) return Permissions.deliveryManage;
  if (path == '/delivery') return Permissions.deliveryViewDashboard;

  // ── Notifications ────────────────────────────────────
  if (path.startsWith('/notifications/preferences')) return Permissions.notificationsManage;
  if (path.startsWith('/notifications')) return Permissions.notificationsView;

  // ── Support ──────────────────────────────────────────
  if (path == '/support/create') return Permissions.supportCreateTicket;
  if (path.startsWith('/support')) return Permissions.supportView;

  // ── Industry ─────────────────────────────────────────
  if (path.startsWith('/industry/pharmacy')) return Permissions.pharmacyView;
  if (path.startsWith('/industry/jewelry')) return Permissions.jewelryView;
  if (path.startsWith('/industry/electronics')) return Permissions.mobileView;
  if (path.startsWith('/industry/florist')) return Permissions.flowersView;
  if (path.startsWith('/industry/bakery')) return Permissions.bakeryView;
  if (path.startsWith('/industry/restaurant')) return Permissions.restaurantView;

  // ── Predefined Catalog ───────────────────────────────
  if (path.startsWith('/predefined-catalog')) return Permissions.productsUsePredefined;

  // ── ZATCA ────────────────────────────────────────────
  if (path.startsWith('/zatca')) return Permissions.zatcaView;

  // ── Sync ─────────────────────────────────────────────
  if (path.startsWith('/sync')) return Permissions.syncView;

  // ── Hardware ─────────────────────────────────────────
  if (path.startsWith('/hardware')) return Permissions.hardwareView;

  // ── Security ─────────────────────────────────────────
  if (path.startsWith('/security')) return Permissions.securityViewDashboard;

  // ── Backup ───────────────────────────────────────────
  if (path.startsWith('/backup')) return Permissions.backupView;

  // ── Companion ────────────────────────────────────────
  if (path.startsWith('/companion')) return Permissions.companionView;

  // ── POS Customization ────────────────────────────────
  if (path.startsWith('/customization')) return Permissions.posCustomizationView;
  if (path.startsWith('/receipt-templates')) return Permissions.posCustomizationView;
  if (path.startsWith('/cfd-themes')) return Permissions.posCustomizationView;
  if (path.startsWith('/label-layout-templates')) return Permissions.posCustomizationView;

  // ── Layout Builder ───────────────────────────────────
  if (path == '/layout-builder') return Permissions.layoutBuilderManage;
  if (path.startsWith('/layout-templates')) return Permissions.layoutBuilderView;

  // ── Marketplace ──────────────────────────────────────
  if (path.startsWith('/marketplace/purchases')) return Permissions.marketplaceView;
  if (path.startsWith('/marketplace')) return Permissions.marketplaceView;

  // ── Auto Update ──────────────────────────────────────
  if (path.startsWith('/auto-update')) return Permissions.autoUpdateView;

  // ── Accessibility ────────────────────────────────────
  if (path.startsWith('/accessibility')) return Permissions.accessibilityManage;

  // ── Nice-to-Have ─────────────────────────────────────
  if (path.startsWith('/nice-to-have')) return Permissions.niceToHaveView;

  // ── Dashboard ────────────────────────────────────────
  if (path == '/dashboard') return Permissions.dashboardView;

  return null;
}
