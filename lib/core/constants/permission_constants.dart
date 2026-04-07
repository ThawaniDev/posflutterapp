/// All permission codes matching the Laravel backend's `permissions` table.
/// Organised by module; every constant is the exact string stored in the DB.
abstract final class Permissions {
  // ── POS ──────────────────────────────────────────────
  static const posViewSessions = 'pos.view_sessions';
  static const posShiftOpen = 'pos.shift_open';
  static const posShiftClose = 'pos.shift_close';
  static const posSell = 'pos.sell';
  static const posApplyDiscount = 'pos.apply_discount';
  static const posVoidTransaction = 'pos.void_transaction';
  static const posReturn = 'pos.return';
  static const posHoldRecall = 'pos.hold_recall';
  static const posManageTerminals = 'pos.manage_terminals';

  // ── Orders ───────────────────────────────────────────
  static const ordersView = 'orders.view';
  static const ordersManage = 'orders.manage';
  static const ordersUpdateStatus = 'orders.update_status';
  static const ordersVoid = 'orders.void';
  static const ordersReturn = 'orders.return';

  // ── Products ─────────────────────────────────────────
  static const productsView = 'products.view';
  static const productsManage = 'products.manage';
  static const productsManageCategories = 'products.manage_categories';
  static const productsManageSuppliers = 'products.manage_suppliers';
  static const productsManagePricing = 'products.manage_pricing';
  static const productsUsePredefined = 'products.use_predefined';

  // ── Inventory ────────────────────────────────────────
  static const inventoryView = 'inventory.view';
  static const inventoryReceive = 'inventory.receive';
  static const inventoryAdjust = 'inventory.adjust';
  static const inventoryTransfer = 'inventory.transfer';
  static const inventoryPurchaseOrders = 'inventory.purchase_orders';
  static const inventoryRecipes = 'inventory.recipes';
  static const inventoryStocktake = 'inventory.stocktake';
  static const inventoryWriteOff = 'inventory.write_off';
  static const inventorySupplierReturns = 'inventory.supplier_returns';

  // ── Customers ────────────────────────────────────────
  static const customersView = 'customers.view';
  static const customersManage = 'customers.manage';
  static const customersManageLoyalty = 'customers.manage_loyalty';
  static const customersManageCredit = 'customers.manage_credit';
  static const customersManageDebits = 'customers.manage_debits';

  // ── Payments ─────────────────────────────────────────
  static const paymentsProcess = 'payments.process';
  static const paymentsRefund = 'payments.refund';

  // ── Cash ─────────────────────────────────────────────
  static const cashViewSessions = 'cash.view_sessions';
  static const cashManage = 'cash.manage';
  static const cashViewDailySummary = 'cash.view_daily_summary';
  static const cashReconciliation = 'cash.reconciliation';

  // ── Finance ──────────────────────────────────────────
  static const financeExpenses = 'finance.expenses';
  static const financeGiftCards = 'finance.gift_cards';
  static const financeCommissions = 'finance.commissions';

  // ── Reports ──────────────────────────────────────────
  static const reportsView = 'reports.view';
  static const reportsSales = 'reports.sales';
  static const reportsViewMargin = 'reports.view_margin';
  static const reportsStaff = 'reports.staff';
  static const reportsInventory = 'reports.inventory';
  static const reportsViewFinancial = 'reports.view_financial';
  static const reportsCustomers = 'reports.customers';
  static const reportsExport = 'reports.export';
  static const reportsAttendance = 'reports.attendance';

  // ── Staff ────────────────────────────────────────────
  static const staffView = 'staff.view';
  static const staffCreate = 'staff.create';
  static const staffEdit = 'staff.edit';
  static const staffDelete = 'staff.delete';
  static const staffManagePin = 'staff.manage_pin';
  static const staffManage = 'staff.manage';
  static const staffManageShifts = 'staff.manage_shifts';

  // ── Roles ────────────────────────────────────────────
  static const rolesView = 'roles.view';
  static const rolesCreate = 'roles.create';
  static const rolesEdit = 'roles.edit';
  static const rolesDelete = 'roles.delete';
  static const rolesAssign = 'roles.assign';

  // ── Labels ───────────────────────────────────────────
  static const labelsView = 'labels.view';
  static const labelsManage = 'labels.manage';
  static const labelsPrint = 'labels.print';

  // ── Promotions ───────────────────────────────────────
  static const promotionsManage = 'promotions.manage';
  static const promotionsViewAnalytics = 'promotions.view_analytics';
  static const promotionsApplyManual = 'promotions.apply_manual';

  // ── Settings ─────────────────────────────────────────
  static const settingsView = 'settings.view';
  static const settingsManage = 'settings.manage';
  static const settingsLocalization = 'settings.localization';

  // ── Accounting ───────────────────────────────────────
  static const accountingViewHistory = 'accounting.view_history';
  static const accountingConnect = 'accounting.connect';
  static const accountingManageMappings = 'accounting.manage_mappings';
  static const accountingExport = 'accounting.export';

  // ── Thawani ──────────────────────────────────────────
  static const thawaniViewDashboard = 'thawani.view_dashboard';
  static const thawaniManageConfig = 'thawani.manage_config';
  static const thawaniMenu = 'thawani.menu';

  // ── Delivery ─────────────────────────────────────────
  static const deliveryViewDashboard = 'delivery.view_dashboard';
  static const deliveryManageConfig = 'delivery.manage_config';
  static const deliveryManage = 'delivery.manage';
  static const deliverySyncMenu = 'delivery.sync_menu';
  static const deliveryViewLogs = 'delivery.view_logs';

  // ── Notifications ────────────────────────────────────
  static const notificationsView = 'notifications.view';
  static const notificationsManage = 'notifications.manage';
  static const notificationsSchedules = 'notifications.schedules';

  // ── Branches ─────────────────────────────────────────
  static const branchesView = 'branches.view';
  static const branchesManage = 'branches.manage';

  // ── Subscription ─────────────────────────────────────
  static const subscriptionView = 'subscription.view';
  static const subscriptionManage = 'subscription.manage';

  // ── Support ──────────────────────────────────────────
  static const supportView = 'support.view';
  static const supportCreateTicket = 'support.create_ticket';

  // ── Security ─────────────────────────────────────────
  static const securityViewDashboard = 'security.view_dashboard';
  static const securityManagePolicies = 'security.manage_policies';
  static const securityViewAudit = 'security.view_audit';

  // ── ZATCA ────────────────────────────────────────────
  static const zatcaView = 'zatca.view';
  static const zatcaManage = 'zatca.manage';

  // ── Sync ─────────────────────────────────────────────
  static const syncView = 'sync.view';
  static const syncManage = 'sync.manage';

  // ── Hardware ─────────────────────────────────────────
  static const hardwareView = 'hardware.view';
  static const hardwareManage = 'hardware.manage';

  // ── Backup ───────────────────────────────────────────
  static const backupView = 'backup.view';
  static const backupManage = 'backup.manage';

  // ── Dashboard ────────────────────────────────────────
  static const dashboardView = 'dashboard.view';

  // ── Companion ────────────────────────────────────────
  static const companionView = 'companion.view';

  // ── POS Customization ────────────────────────────────
  static const posCustomizationView = 'pos_customization.view';
  static const posCustomizationManage = 'pos_customization.manage';

  // ── Layout Builder ───────────────────────────────────
  static const layoutBuilderView = 'layout_builder.view';
  static const layoutBuilderManage = 'layout_builder.manage';

  // ── Marketplace ──────────────────────────────────────
  static const marketplaceView = 'marketplace.view';
  static const marketplacePurchase = 'marketplace.purchase';

  // ── Accessibility ────────────────────────────────────
  static const accessibilityManage = 'accessibility.manage';

  // ── Nice to Have ─────────────────────────────────────
  static const niceToHaveManage = 'nice_to_have.manage';
  static const niceToHaveView = 'nice_to_have.view';

  // ── Onboarding ───────────────────────────────────────
  static const onboardingManage = 'onboarding.manage';

  // ── Auto-Update ──────────────────────────────────────
  static const autoUpdateView = 'auto_update.view';
  static const autoUpdateManage = 'auto_update.manage';

  // ── Bakery ───────────────────────────────────────────
  static const bakeryView = 'bakery.view';
  static const bakeryRecipes = 'bakery.recipes';
  static const bakeryProduction = 'bakery.production';
  static const bakeryCustomOrders = 'bakery.custom_orders';

  // ── Mobile / Electronics ─────────────────────────────
  static const mobileView = 'mobile.view';
  static const mobileImei = 'mobile.imei';
  static const mobileRepairs = 'mobile.repairs';
  static const mobileTradeIn = 'mobile.trade_in';

  // ── Flowers / Florist ────────────────────────────────
  static const flowersView = 'flowers.view';
  static const flowersArrangements = 'flowers.arrangements';
  static const flowersFreshness = 'flowers.freshness';
  static const flowersSubscriptions = 'flowers.subscriptions';

  // ── Jewelry ──────────────────────────────────────────
  static const jewelryView = 'jewelry.view';
  static const jewelryManageRates = 'jewelry.manage_rates';
  static const jewelryManageDetails = 'jewelry.manage_details';
  static const jewelryBuyback = 'jewelry.buyback';

  // ── Pharmacy ─────────────────────────────────────────
  static const pharmacyView = 'pharmacy.view';
  static const pharmacyPrescriptions = 'pharmacy.prescriptions';
  static const pharmacyDrugSchedules = 'pharmacy.drug_schedules';

  // ── Restaurant ───────────────────────────────────────
  static const restaurantView = 'restaurant.view';
  static const restaurantTables = 'restaurant.tables';
  static const restaurantKds = 'restaurant.kds';
  static const restaurantReservations = 'restaurant.reservations';
  static const restaurantTabs = 'restaurant.tabs';

  /// All permission codes as a flat list (useful for validation / debugging).
  static const List<String> all = [
    // pos
    posViewSessions, posShiftOpen, posShiftClose, posSell, posApplyDiscount,
    posVoidTransaction, posReturn, posHoldRecall, posManageTerminals,
    // orders
    ordersView, ordersManage, ordersUpdateStatus, ordersVoid, ordersReturn,
    // products
    productsView, productsManage, productsManageCategories,
    productsManageSuppliers, productsManagePricing, productsUsePredefined,
    // inventory
    inventoryView, inventoryReceive, inventoryAdjust, inventoryTransfer,
    inventoryPurchaseOrders, inventoryRecipes, inventoryStocktake,
    inventoryWriteOff, inventorySupplierReturns,
    // customers
    customersView, customersManage, customersManageLoyalty,
    customersManageCredit, customersManageDebits,
    // payments
    paymentsProcess, paymentsRefund,
    // cash
    cashViewSessions, cashManage, cashViewDailySummary, cashReconciliation,
    // finance
    financeExpenses, financeGiftCards, financeCommissions,
    // reports
    reportsView, reportsSales, reportsViewMargin, reportsStaff,
    reportsInventory, reportsViewFinancial, reportsCustomers, reportsExport,
    reportsAttendance,
    // staff
    staffView, staffCreate, staffEdit, staffDelete, staffManagePin,
    staffManage, staffManageShifts,
    // roles
    rolesView, rolesCreate, rolesEdit, rolesDelete, rolesAssign,
    // labels
    labelsView, labelsManage, labelsPrint,
    // promotions
    promotionsManage, promotionsViewAnalytics, promotionsApplyManual,
    // settings
    settingsView, settingsManage, settingsLocalization,
    // accounting
    accountingViewHistory, accountingConnect, accountingManageMappings,
    accountingExport,
    // thawani
    thawaniViewDashboard, thawaniManageConfig, thawaniMenu,
    // delivery
    deliveryViewDashboard, deliveryManageConfig, deliveryManage,
    deliverySyncMenu, deliveryViewLogs,
    // notifications
    notificationsView, notificationsManage, notificationsSchedules,
    // branches
    branchesView, branchesManage,
    // subscription
    subscriptionView, subscriptionManage,
    // support
    supportView, supportCreateTicket,
    // security
    securityViewDashboard, securityManagePolicies, securityViewAudit,
    // zatca
    zatcaView, zatcaManage,
    // sync
    syncView, syncManage,
    // hardware
    hardwareView, hardwareManage,
    // backup
    backupView, backupManage,
    // dashboard
    dashboardView,
    // companion
    companionView,
    // pos_customization
    posCustomizationView, posCustomizationManage,
    // layout_builder
    layoutBuilderView, layoutBuilderManage,
    // marketplace
    marketplaceView, marketplacePurchase,
    // accessibility
    accessibilityManage,
    // nice_to_have
    niceToHaveManage, niceToHaveView,
    // onboarding
    onboardingManage,
    // auto_update
    autoUpdateView, autoUpdateManage,
    // bakery
    bakeryView, bakeryRecipes, bakeryProduction, bakeryCustomOrders,
    // mobile
    mobileView, mobileImei, mobileRepairs, mobileTradeIn,
    // flowers
    flowersView, flowersArrangements, flowersFreshness, flowersSubscriptions,
    // jewelry
    jewelryView, jewelryManageRates, jewelryManageDetails, jewelryBuyback,
    // pharmacy
    pharmacyView, pharmacyPrescriptions, pharmacyDrugSchedules,
    // restaurant
    restaurantView, restaurantTables, restaurantKds, restaurantReservations,
    restaurantTabs,
  ];
}
