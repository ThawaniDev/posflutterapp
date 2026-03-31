import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/widgets/app_shell.dart';
import 'package:thawani_pos/features/auth/pages/login_page.dart';
import 'package:thawani_pos/features/auth/pages/pin_login_page.dart';
import 'package:thawani_pos/features/auth/pages/register_page.dart';
import 'package:thawani_pos/features/auth/providers/auth_providers.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';
import 'package:thawani_pos/features/catalog/pages/category_list_page.dart';
import 'package:thawani_pos/features/catalog/pages/product_form_page.dart';
import 'package:thawani_pos/features/catalog/pages/product_list_page.dart';
import 'package:thawani_pos/features/catalog/pages/supplier_list_page.dart';
import 'package:thawani_pos/features/customers/pages/customer_list_page.dart';
import 'package:thawani_pos/features/inventory/pages/goods_receipt_form_page.dart';
import 'package:thawani_pos/features/inventory/pages/goods_receipts_page.dart';
import 'package:thawani_pos/features/inventory/pages/inventory_page.dart';
import 'package:thawani_pos/features/inventory/pages/purchase_orders_page.dart';
import 'package:thawani_pos/features/inventory/pages/recipes_page.dart';
import 'package:thawani_pos/features/inventory/pages/stock_adjustments_page.dart';
import 'package:thawani_pos/features/inventory/pages/stock_levels_page.dart';
import 'package:thawani_pos/features/inventory/pages/stock_movements_page.dart';
import 'package:thawani_pos/features/inventory/pages/stock_transfers_page.dart';
import 'package:thawani_pos/features/labels/pages/label_designer_page.dart';
import 'package:thawani_pos/features/labels/pages/label_history_page.dart';
import 'package:thawani_pos/features/labels/pages/label_list_page.dart';
import 'package:thawani_pos/features/labels/pages/label_print_queue_page.dart';
import 'package:thawani_pos/features/onboarding/pages/onboarding_wizard_page.dart';
import 'package:thawani_pos/features/onboarding/pages/store_settings_page.dart';
import 'package:thawani_pos/features/onboarding/pages/working_hours_page.dart';
import 'package:thawani_pos/features/orders/pages/order_list_page.dart';
import 'package:thawani_pos/features/payments/pages/cash_sessions_page.dart';
import 'package:thawani_pos/features/payments/pages/cash_management_page.dart';
import 'package:thawani_pos/features/payments/pages/expenses_page.dart';
import 'package:thawani_pos/features/payments/pages/gift_cards_page.dart';
import 'package:thawani_pos/features/payments/pages/financial_reconciliation_page.dart';
import 'package:thawani_pos/features/payments/pages/daily_summary_page.dart';
import 'package:thawani_pos/features/pos_terminal/pages/pos_sessions_page.dart';
import 'package:thawani_pos/features/pos_terminal/pages/pos_terminal_form_page.dart';
import 'package:thawani_pos/features/pos_terminal/pages/pos_terminals_page.dart';
import 'package:thawani_pos/features/pos_terminal/pages/pos_cashier_page.dart';
import 'package:thawani_pos/features/staff/pages/attendance_page.dart';
import 'package:thawani_pos/features/staff/pages/commission_summary_page.dart';
import 'package:thawani_pos/features/staff/pages/role_create_page.dart';
import 'package:thawani_pos/features/staff/pages/role_detail_page.dart';
import 'package:thawani_pos/features/staff/pages/roles_list_page.dart';
import 'package:thawani_pos/features/staff/pages/shift_schedule_page.dart';
import 'package:thawani_pos/features/staff/pages/staff_detail_page.dart';
import 'package:thawani_pos/features/staff/pages/staff_form_page.dart';
import 'package:thawani_pos/features/staff/pages/staff_list_page.dart';
import 'package:thawani_pos/features/subscription/pages/billing_history_page.dart';
import 'package:thawani_pos/features/subscription/pages/plan_selection_page.dart';
import 'package:thawani_pos/features/subscription/pages/subscription_status_page.dart';
import 'package:thawani_pos/features/subscription/pages/invoice_detail_page.dart';
import 'package:thawani_pos/features/subscription/pages/plan_comparison_page.dart';
import 'package:thawani_pos/features/subscription/pages/add_ons_page.dart';
import 'package:thawani_pos/features/dashboard/pages/owner_dashboard_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_payment_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_refund_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_cash_session_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_expense_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_gift_card_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_accounting_config_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_thawani_settlement_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_daily_sales_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_failed_jobs_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_backups_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_infra_health_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_provider_permissions_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_provider_role_template_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_provider_role_template_detail_page.dart';
// P1: Provider Management
import 'package:thawani_pos/features/admin_panel/pages/admin_store_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_store_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/registration_queue_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/provider_notes_page.dart';
// P2: Platform Roles
import 'package:thawani_pos/features/admin_panel/pages/admin_role_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_role_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_permissions_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_team_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_team_user_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_activity_log_page.dart';
// P3: Package & Subscription
import 'package:thawani_pos/features/admin_panel/pages/admin_plan_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_plan_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_discount_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_subscription_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_invoice_list_page.dart';
import 'package:thawani_pos/features/admin_panel/pages/admin_revenue_dashboard_page.dart' as p3;
// P4: User Management
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_provider_user_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_provider_user_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_admin_user_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart';
// P5: Billing & Finance
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_billing_invoice_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_billing_invoice_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_failed_payments_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_retry_rules_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_revenue_dashboard_page.dart' as p5;
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_gateway_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_hardware_sale_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_implementation_fee_list_page.dart';
// P6: Analytics & Reporting
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_dashboard_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_features_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_analytics_system_health_page.dart';
// P7: Support Tickets
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_support_ticket_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_canned_response_list_page.dart';
// P8: Feature Flags
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_feature_flag_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_feature_flag_detail_page.dart';
// P9: Notification Templates
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_notification_template_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_notification_log_list_page.dart';
// P10: Log Monitoring / A-B Tests
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_ab_test_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_ab_test_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_platform_event_list_page.dart';
// P11: Content & Onboarding
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_cms_page_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_cms_page_detail_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_article_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_announcement_list_page.dart';
// P13: Marketplace
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_marketplace_store_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_marketplace_settlement_list_page.dart';
// P14: Deployment
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_deployment_release_list_page.dart';
// P15B: Security Center
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_security_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_security_alerts_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_security_alert_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_activity_log_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_user_activity_page.dart';
// Data Management & Health
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_data_management_overview_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_database_backup_list_page.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart';
// POS Feature #20: ZATCA Compliance
import 'package:thawani_pos/features/zatca/pages/zatca_dashboard_page.dart';
import 'package:thawani_pos/features/sync/pages/sync_dashboard_page.dart';
import 'package:thawani_pos/features/hardware/pages/hardware_dashboard_page.dart';
import 'package:thawani_pos/features/settings/pages/localization_page.dart';
import 'package:thawani_pos/features/security/pages/security_dashboard_page.dart';
import 'package:thawani_pos/features/backup/pages/backup_dashboard_page.dart';
import 'package:thawani_pos/features/companion/pages/companion_dashboard_page.dart';
import 'package:thawani_pos/features/pos_customization/pages/customization_dashboard_page.dart';
import 'package:thawani_pos/features/layout_builder/pages/layout_template_list_page.dart';
import 'package:thawani_pos/features/layout_builder/pages/layout_builder_canvas_page.dart';
import 'package:thawani_pos/features/marketplace/pages/marketplace_browse_page.dart';
import 'package:thawani_pos/features/marketplace/pages/marketplace_listing_detail_page.dart';
import 'package:thawani_pos/features/marketplace/pages/my_purchases_page.dart';
import 'package:thawani_pos/features/auto_update/pages/auto_update_dashboard_page.dart';
import 'package:thawani_pos/features/accessibility/pages/accessibility_dashboard_page.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/nice_to_have_dashboard_page.dart';
// Reports
import 'package:thawani_pos/features/reports/pages/dashboard_page.dart' as reports;
import 'package:thawani_pos/features/reports/pages/sales_summary_page.dart';
import 'package:thawani_pos/features/reports/pages/hourly_sales_page.dart';
import 'package:thawani_pos/features/reports/pages/product_performance_page.dart';
import 'package:thawani_pos/features/reports/pages/category_breakdown_page.dart';
import 'package:thawani_pos/features/reports/pages/payment_methods_page.dart';
import 'package:thawani_pos/features/reports/pages/staff_performance_page.dart';
import 'package:thawani_pos/features/reports/pages/inventory_report_page.dart';
import 'package:thawani_pos/features/reports/pages/financial_report_page.dart';
import 'package:thawani_pos/features/reports/pages/customer_report_page.dart';
// Accounting
import 'package:thawani_pos/features/accounting/pages/accounting_settings_page.dart';
import 'package:thawani_pos/features/accounting/pages/account_mapping_page.dart';
import 'package:thawani_pos/features/accounting/pages/export_history_page.dart';
import 'package:thawani_pos/features/accounting/pages/auto_export_settings_page.dart';
// Promotions
import 'package:thawani_pos/features/promotions/pages/promotion_list_page.dart';
import 'package:thawani_pos/features/promotions/pages/promotion_analytics_page.dart';
// Notifications
import 'package:thawani_pos/features/notifications/pages/notifications_list_page.dart';
import 'package:thawani_pos/features/notifications/pages/notification_preferences_page.dart';
// Support
import 'package:thawani_pos/features/support/pages/support_dashboard_page.dart';
import 'package:thawani_pos/features/support/pages/create_ticket_page.dart';
import 'package:thawani_pos/features/support/pages/ticket_detail_page.dart';
import 'package:thawani_pos/features/support/pages/knowledge_base_page.dart';
import 'package:thawani_pos/features/support/pages/article_detail_page.dart';
// Delivery
import 'package:thawani_pos/features/delivery_integration/pages/delivery_dashboard_page.dart';
import 'package:thawani_pos/features/delivery_integration/pages/delivery_config_page.dart';
import 'package:thawani_pos/features/delivery_integration/pages/delivery_order_detail_page.dart';
import 'package:thawani_pos/features/delivery_integration/pages/menu_sync_page.dart';
import 'package:thawani_pos/features/delivery_integration/pages/delivery_webhook_logs_page.dart';
import 'package:thawani_pos/features/delivery_integration/pages/delivery_status_push_logs_page.dart';
// Thawani Pay
import 'package:thawani_pos/features/thawani_integration/pages/thawani_dashboard_page.dart';
// Branches
import 'package:thawani_pos/features/branches/pages/branch_list_page.dart';
import 'package:thawani_pos/features/branches/pages/branch_detail_page.dart';
import 'package:thawani_pos/features/branches/pages/branch_form_page.dart';
import 'package:thawani_pos/features/branches/models/store.dart';
// Settings
import 'package:thawani_pos/features/settings/pages/settings_page.dart';
// Industry Workflows
import 'package:thawani_pos/features/industry_pharmacy/pages/pharmacy_dashboard_page.dart';
import 'package:thawani_pos/features/industry_jewelry/pages/jewelry_dashboard_page.dart';
import 'package:thawani_pos/features/industry_electronics/pages/electronics_dashboard_page.dart';
import 'package:thawani_pos/features/industry_florist/pages/florist_dashboard_page.dart';
import 'package:thawani_pos/features/industry_bakery/pages/bakery_dashboard_page.dart';
import 'package:thawani_pos/features/industry_restaurant/pages/restaurant_dashboard_page.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthInitial || authState is AuthLoading;
      final currentPath = state.matchedLocation;

      // Don't redirect while checking stored session
      if (isLoading) return null;

      // Public routes that don't require auth
      const publicRoutes = [Routes.login, Routes.loginPin, Routes.register];
      final isPublicRoute = publicRoutes.contains(currentPath);

      // Not authenticated → redirect to login (unless already on public route)
      if (!isAuthenticated && !isPublicRoute) {
        return Routes.login;
      }

      // Authenticated → redirect away from auth pages based on role
      if (authState is AuthAuthenticated && isPublicRoute) {
        return Routes.homeForRole(authState.user.role);
      }

      return null;
    },
    routes: [
      // ─── Auth (no shell — standalone pages) ─────
      GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: Routes.loginPin, name: 'loginPin', builder: (context, state) => const PinLoginPage()),
      GoRoute(path: Routes.register, name: 'register', builder: (context, state) => const RegisterPage()),

      // ─── Authenticated Shell (sidebar wrapper) ──
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // ─── Main (protected) ─────────────────────────
          GoRoute(path: Routes.dashboard, name: 'dashboard', builder: (context, state) => const OwnerDashboardPage()),
          GoRoute(path: Routes.pos, name: 'pos', builder: (context, state) => const PosTerminalsPage()),

          // ─── Catalog ──────────────────────────────────
          GoRoute(path: Routes.products, name: 'products', builder: (context, state) => const ProductListPage()),
          GoRoute(path: Routes.productsAdd, name: 'productsAdd', builder: (context, state) => const ProductFormPage()),
          GoRoute(
            path: '${Routes.products}/:id',
            name: 'productsEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductFormPage(productId: id);
            },
          ),
          GoRoute(path: Routes.categories, name: 'categories', builder: (context, state) => const CategoryListPage()),
          GoRoute(path: Routes.suppliers, name: 'suppliers', builder: (context, state) => const SupplierListPage()),

          // ─── Inventory ────────────────────────────────
          GoRoute(path: Routes.inventory, name: 'inventory', builder: (context, state) => const InventoryPage()),
          GoRoute(path: Routes.stockLevels, name: 'stockLevels', builder: (context, state) => const StockLevelsPage()),
          GoRoute(path: Routes.stockMovements, name: 'stockMovements', builder: (context, state) => const StockMovementsPage()),
          GoRoute(path: Routes.goodsReceipts, name: 'goodsReceipts', builder: (context, state) => const GoodsReceiptsPage()),
          GoRoute(
            path: Routes.goodsReceiptsAdd,
            name: 'goodsReceiptsAdd',
            builder: (context, state) => const GoodsReceiptFormPage(),
          ),
          GoRoute(
            path: Routes.stockAdjustments,
            name: 'stockAdjustments',
            builder: (context, state) => const StockAdjustmentsPage(),
          ),
          GoRoute(path: Routes.stockTransfers, name: 'stockTransfers', builder: (context, state) => const StockTransfersPage()),
          GoRoute(path: Routes.purchaseOrders, name: 'purchaseOrders', builder: (context, state) => const PurchaseOrdersPage()),
          GoRoute(path: Routes.recipes, name: 'recipes', builder: (context, state) => const RecipesPage()),

          // ─── POS Terminal ─────────────────────────────
          GoRoute(path: Routes.posSessions, name: 'posSessions', builder: (context, state) => const PosSessionsPage()),
          GoRoute(path: Routes.posTerminals, name: 'posTerminals', builder: (context, state) => const PosTerminalsPage()),
          GoRoute(path: Routes.posTerminalAdd, name: 'posTerminalAdd', builder: (context, state) => const PosTerminalFormPage()),
          GoRoute(
            path: Routes.posTerminalEdit,
            name: 'posTerminalEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PosTerminalFormPage(terminalId: id);
            },
          ),

          // ─── Orders ───────────────────────────────────
          GoRoute(path: Routes.orders, name: 'orders', builder: (context, state) => const OrderListPage()),

          // ─── Payments ─────────────────────────────────
          GoRoute(path: Routes.cashSessions, name: 'cashSessions', builder: (context, state) => const CashSessionsPage()),
          GoRoute(path: Routes.cashManagement, name: 'cashManagement', builder: (context, state) => const CashManagementPage()),
          GoRoute(path: Routes.expenses, name: 'expenses', builder: (context, state) => const ExpensesPage()),
          GoRoute(path: Routes.giftCards, name: 'giftCards', builder: (context, state) => const GiftCardsPage()),
          GoRoute(
            path: Routes.financialReconciliation,
            name: 'financialReconciliation',
            builder: (context, state) => const FinancialReconciliationPage(),
          ),
          GoRoute(path: Routes.dailySummary, name: 'dailySummary', builder: (context, state) => const DailySummaryPage()),

          // ─── Customers ────────────────────────────────
          GoRoute(path: Routes.customers, name: 'customers', builder: (context, state) => const CustomerListPage()),

          // ─── Labels ───────────────────────────────────
          GoRoute(path: Routes.labels, name: 'labels', builder: (context, state) => const LabelListPage()),
          GoRoute(
            path: Routes.labelDesigner,
            name: 'labelDesigner',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              final duplicate = state.uri.queryParameters['duplicate'];
              return LabelDesignerPage(templateId: id, duplicateId: duplicate);
            },
          ),
          GoRoute(path: Routes.labelHistory, name: 'labelHistory', builder: (context, state) => const LabelHistoryPage()),
          GoRoute(
            path: Routes.labelPrintQueue,
            name: 'labelPrintQueue',
            builder: (context, state) {
              final templateId = state.uri.queryParameters['templateId'];
              return LabelPrintQueuePage(templateId: templateId);
            },
          ),

          // ─── Staff / Roles ────────────────────────────
          GoRoute(path: Routes.staffMembers, name: 'staffMembers', builder: (context, state) => const StaffListPage()),
          GoRoute(
            path: Routes.staffMembersCreate,
            name: 'staffMembersCreate',
            builder: (context, state) => const StaffFormPage(),
          ),
          GoRoute(
            path: '${Routes.staffMembers}/:id',
            name: 'staffMemberDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StaffDetailPage(staffId: id);
            },
          ),
          GoRoute(
            path: '${Routes.staffMembers}/:id/edit',
            name: 'staffMemberEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StaffFormPage(staffId: id);
            },
          ),
          GoRoute(path: Routes.staffRoles, name: 'staffRoles', builder: (context, state) => const RolesListPage()),
          GoRoute(path: Routes.staffRoleCreate, name: 'staffRoleCreate', builder: (context, state) => const RoleCreatePage()),
          GoRoute(
            path: '${Routes.staffRoleDetail}/:id',
            name: 'staffRoleDetail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return RoleDetailPage(roleId: id);
            },
          ),
          GoRoute(path: Routes.staffAttendance, name: 'staffAttendance', builder: (context, state) => const AttendancePage()),
          GoRoute(path: Routes.staffShifts, name: 'staffShifts', builder: (context, state) => const ShiftSchedulePage()),
          GoRoute(
            path: '${Routes.staffCommission}/:id',
            name: 'staffCommission',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return CommissionSummaryPage(staffId: id, staffName: name);
            },
          ),

          // ─── Onboarding & Store Setup ────────────────
          GoRoute(path: Routes.onboarding, name: 'onboarding', builder: (context, state) => const OnboardingWizardPage()),
          GoRoute(
            path: '${Routes.storeSettings}/:storeId',
            name: 'storeSettings',
            builder: (context, state) {
              final storeId = state.pathParameters['storeId']!;
              return StoreSettingsPage(storeId: storeId);
            },
          ),
          GoRoute(
            path: '${Routes.workingHours}/:storeId',
            name: 'workingHours',
            builder: (context, state) {
              final storeId = state.pathParameters['storeId']!;
              return WorkingHoursPage(storeId: storeId);
            },
          ),

          // ─── Subscription ─────────────────────────────
          GoRoute(path: Routes.planSelection, name: 'planSelection', builder: (context, state) => const PlanSelectionPage()),
          GoRoute(
            path: Routes.subscriptionStatus,
            name: 'subscriptionStatus',
            builder: (context, state) => const SubscriptionStatusPage(),
          ),
          GoRoute(path: Routes.billingHistory, name: 'billingHistory', builder: (context, state) => const BillingHistoryPage()),
          GoRoute(path: Routes.planComparison, name: 'planComparison', builder: (context, state) => const PlanComparisonPage()),
          GoRoute(path: Routes.subscriptionAddOns, name: 'subscriptionAddOns', builder: (context, state) => const AddOnsPage()),
          GoRoute(
            path: '${Routes.invoiceDetail}/:invoiceId',
            name: 'invoiceDetail',
            builder: (context, state) {
              final invoiceId = state.pathParameters['invoiceId']!;
              return InvoiceDetailPage(invoiceId: invoiceId);
            },
          ),

          // ─── Admin Panel – P15: Financial Operations ──
          GoRoute(path: Routes.adminFinOps, name: 'adminFinOps', builder: (context, state) => const AdminFinOpsOverviewPage()),
          GoRoute(
            path: Routes.adminFinOpsPayments,
            name: 'adminFinOpsPayments',
            builder: (context, state) => const AdminFinOpsPaymentListPage(),
          ),
          GoRoute(
            path: '${Routes.adminFinOpsPaymentDetail}/:id',
            name: 'adminFinOpsPaymentDetail',
            builder: (context, state) => AdminFinOpsPaymentDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.adminFinOpsRefunds,
            name: 'adminFinOpsRefunds',
            builder: (context, state) => const AdminFinOpsRefundListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsCashSessions,
            name: 'adminFinOpsCashSessions',
            builder: (context, state) => const AdminFinOpsCashSessionListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsExpenses,
            name: 'adminFinOpsExpenses',
            builder: (context, state) => const AdminFinOpsExpenseListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsGiftCards,
            name: 'adminFinOpsGiftCards',
            builder: (context, state) => const AdminFinOpsGiftCardListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsAccounting,
            name: 'adminFinOpsAccounting',
            builder: (context, state) => const AdminFinOpsAccountingConfigListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsThawani,
            name: 'adminFinOpsThawani',
            builder: (context, state) => const AdminFinOpsThawaniSettlementListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsSalesReports,
            name: 'adminFinOpsSalesReports',
            builder: (context, state) => const AdminFinOpsDailySalesPage(),
          ),

          // ─── Admin Panel – P16: Infrastructure ────────
          GoRoute(
            path: Routes.adminInfrastructure,
            name: 'adminInfrastructure',
            builder: (context, state) => const AdminInfraOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminInfraFailedJobs,
            name: 'adminInfraFailedJobs',
            builder: (context, state) => const AdminInfraFailedJobsPage(),
          ),
          GoRoute(
            path: Routes.adminInfraHealth,
            name: 'adminInfraHealth',
            builder: (context, state) => const AdminInfraHealthPage(),
          ),
          GoRoute(
            path: Routes.adminInfraStorage,
            name: 'adminInfraStorage',
            builder: (context, state) => const AdminInfraBackupsPage(),
          ),

          // ─── Admin Panel – P17: Provider Roles ────────
          GoRoute(
            path: Routes.adminProviderPermissions,
            name: 'adminProviderPermissions',
            builder: (context, state) => const AdminProviderPermissionsPage(),
          ),
          GoRoute(
            path: Routes.adminProviderRoleTemplates,
            name: 'adminProviderRoleTemplates',
            builder: (context, state) => const AdminProviderRoleTemplateListPage(),
          ),
          GoRoute(
            path: '${Routes.adminProviderRoleTemplateDetail}/:id',
            name: 'adminProviderRoleTemplateDetail',
            builder: (context, state) => AdminProviderRoleTemplateDetailPage(templateId: state.pathParameters['id']!),
          ),

          // ─── Admin Panel – P1: Provider Management ────
          GoRoute(path: Routes.adminStores, name: 'adminStores', builder: (context, state) => const AdminStoreListPage()),
          GoRoute(
            path: '${Routes.adminStoreDetail}/:id',
            name: 'adminStoreDetail',
            builder: (context, state) => AdminStoreDetailPage(storeId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.adminRegistrations,
            name: 'adminRegistrations',
            builder: (context, state) => const RegistrationQueuePage(),
          ),
          GoRoute(
            path: '${Routes.adminNotes}/:organizationId',
            name: 'adminNotes',
            builder: (context, state) => ProviderNotesPage(organizationId: state.pathParameters['organizationId']!),
          ),

          // ─── Admin Panel – P2: Platform Roles ─────────
          GoRoute(path: Routes.adminRoles, name: 'adminRoles', builder: (context, state) => const AdminRoleListPage()),
          GoRoute(
            path: '${Routes.adminRoleDetail}/:roleId',
            name: 'adminRoleDetail',
            builder: (context, state) => AdminRoleDetailPage(roleId: state.pathParameters['roleId']!),
          ),
          GoRoute(
            path: Routes.adminPermissions,
            name: 'adminPermissions',
            builder: (context, state) => const AdminPermissionsPage(),
          ),
          GoRoute(path: Routes.adminTeam, name: 'adminTeam', builder: (context, state) => const AdminTeamListPage()),
          GoRoute(
            path: '${Routes.adminTeamUserDetail}/:userId',
            name: 'adminTeamUserDetail',
            builder: (context, state) => AdminTeamUserDetailPage(userId: state.pathParameters['userId']!),
          ),
          GoRoute(
            path: Routes.adminActivityLog,
            name: 'adminActivityLog',
            builder: (context, state) => const AdminActivityLogPage(),
          ),

          // ─── Admin Panel – P3: Package & Subscription ─
          GoRoute(path: Routes.adminPlans, name: 'adminPlans', builder: (context, state) => const AdminPlanListPage()),
          GoRoute(
            path: '${Routes.adminPlanDetail}/:planId',
            name: 'adminPlanDetail',
            builder: (context, state) => AdminPlanDetailPage(planId: state.pathParameters['planId']!),
          ),
          GoRoute(
            path: Routes.adminDiscounts,
            name: 'adminDiscounts',
            builder: (context, state) => const AdminDiscountListPage(),
          ),
          GoRoute(
            path: Routes.adminSubscriptions,
            name: 'adminSubscriptions',
            builder: (context, state) => const AdminSubscriptionListPage(),
          ),
          GoRoute(path: Routes.adminInvoices, name: 'adminInvoices', builder: (context, state) => const AdminInvoiceListPage()),
          GoRoute(
            path: Routes.adminRevenueDashboard,
            name: 'adminRevenueDashboard',
            builder: (context, state) => const p3.AdminRevenueDashboardPage(),
          ),

          // ─── Admin Panel – P4: User Management ────────
          GoRoute(
            path: Routes.adminProviderUsers,
            name: 'adminProviderUsers',
            builder: (context, state) => const AdminProviderUserListPage(),
          ),
          GoRoute(
            path: '${Routes.adminProviderUserDetail}/:userId',
            name: 'adminProviderUserDetail',
            builder: (context, state) => AdminProviderUserDetailPage(userId: state.pathParameters['userId']!),
          ),
          GoRoute(
            path: Routes.adminAdminUsers,
            name: 'adminAdminUsers',
            builder: (context, state) => const AdminAdminUserListPage(),
          ),
          GoRoute(
            path: '${Routes.adminAdminUserDetail}/:userId',
            name: 'adminAdminUserDetail',
            builder: (context, state) => AdminAdminUserDetailPage(userId: state.pathParameters['userId']!),
          ),

          // ─── Admin Panel – P5: Billing & Finance ──────
          GoRoute(
            path: Routes.adminBillingInvoices,
            name: 'adminBillingInvoices',
            builder: (context, state) => const AdminBillingInvoiceListPage(),
          ),
          GoRoute(
            path: '${Routes.adminBillingInvoiceDetail}/:invoiceId',
            name: 'adminBillingInvoiceDetail',
            builder: (context, state) => AdminBillingInvoiceDetailPage(invoiceId: state.pathParameters['invoiceId']!),
          ),
          GoRoute(
            path: Routes.adminBillingFailedPayments,
            name: 'adminBillingFailedPayments',
            builder: (context, state) => const AdminFailedPaymentsPage(),
          ),
          GoRoute(
            path: Routes.adminBillingRetryRules,
            name: 'adminBillingRetryRules',
            builder: (context, state) => const AdminRetryRulesPage(),
          ),
          GoRoute(
            path: Routes.adminBillingRevenue,
            name: 'adminBillingRevenue',
            builder: (context, state) => const p5.AdminRevenueDashboardPage(),
          ),
          GoRoute(
            path: Routes.adminBillingGateways,
            name: 'adminBillingGateways',
            builder: (context, state) => const AdminGatewayListPage(),
          ),
          GoRoute(
            path: Routes.adminBillingHardwareSales,
            name: 'adminBillingHardwareSales',
            builder: (context, state) => const AdminHardwareSaleListPage(),
          ),
          GoRoute(
            path: Routes.adminBillingImplementationFees,
            name: 'adminBillingImplementationFees',
            builder: (context, state) => const AdminImplementationFeeListPage(),
          ),

          // ─── Admin Panel – P6: Analytics & Reporting ──
          GoRoute(
            path: Routes.adminAnalyticsDashboard,
            name: 'adminAnalyticsDashboard',
            builder: (context, state) => const AdminAnalyticsDashboardPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsRevenue,
            name: 'adminAnalyticsRevenue',
            builder: (context, state) => const AdminAnalyticsRevenuePage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsStores,
            name: 'adminAnalyticsStores',
            builder: (context, state) => const AdminAnalyticsStoresPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsSubscriptions,
            name: 'adminAnalyticsSubscriptions',
            builder: (context, state) => const AdminAnalyticsSubscriptionsPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsFeatures,
            name: 'adminAnalyticsFeatures',
            builder: (context, state) => const AdminAnalyticsFeaturesPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsSystemHealth,
            name: 'adminAnalyticsSystemHealth',
            builder: (context, state) => const AdminAnalyticsSystemHealthPage(),
          ),

          // ─── Admin Panel – P7: Support Tickets ────────
          GoRoute(
            path: Routes.adminSupportTickets,
            name: 'adminSupportTickets',
            builder: (context, state) => const AdminSupportTicketListPage(),
          ),
          GoRoute(
            path: Routes.adminCannedResponses,
            name: 'adminCannedResponses',
            builder: (context, state) => const AdminCannedResponseListPage(),
          ),

          // ─── Admin Panel – P8: Feature Flags ──────────
          GoRoute(
            path: Routes.adminFeatureFlags,
            name: 'adminFeatureFlags',
            builder: (context, state) => const AdminFeatureFlagListPage(),
          ),
          GoRoute(
            path: '${Routes.adminFeatureFlagDetail}/:flagId',
            name: 'adminFeatureFlagDetail',
            builder: (context, state) => AdminFeatureFlagDetailPage(flagId: state.pathParameters['flagId']!),
          ),

          // ─── Admin Panel – P9: Notification Templates ─
          GoRoute(
            path: Routes.adminNotificationTemplates,
            name: 'adminNotificationTemplates',
            builder: (context, state) => const AdminNotificationTemplateListPage(),
          ),
          GoRoute(
            path: Routes.adminNotificationLogs,
            name: 'adminNotificationLogs',
            builder: (context, state) => const AdminNotificationLogListPage(),
          ),

          // ─── Admin Panel – P10: A-B Tests / Events ────
          GoRoute(path: Routes.adminABTests, name: 'adminABTests', builder: (context, state) => const AdminABTestListPage()),
          GoRoute(
            path: '${Routes.adminABTestDetail}/:testId',
            name: 'adminABTestDetail',
            builder: (context, state) => AdminABTestDetailPage(testId: state.pathParameters['testId']!),
          ),
          GoRoute(
            path: '${Routes.adminABTestResults}/:testId',
            name: 'adminABTestResults',
            builder: (context, state) => AdminABTestResultsPage(testId: state.pathParameters['testId']!),
          ),
          GoRoute(
            path: Routes.adminPlatformEvents,
            name: 'adminPlatformEvents',
            builder: (context, state) => const AdminPlatformEventListPage(),
          ),

          // ─── Admin Panel – P11: Content & Onboarding ──
          GoRoute(path: Routes.adminCmsPages, name: 'adminCmsPages', builder: (context, state) => const AdminCmsPageListPage()),
          GoRoute(
            path: '${Routes.adminCmsPageDetail}/:pageId',
            name: 'adminCmsPageDetail',
            builder: (context, state) => AdminCmsPageDetailPage(pageId: state.pathParameters['pageId']!),
          ),
          GoRoute(path: Routes.adminArticles, name: 'adminArticles', builder: (context, state) => const AdminArticleListPage()),
          GoRoute(
            path: Routes.adminAnnouncements,
            name: 'adminAnnouncements',
            builder: (context, state) => const AdminAnnouncementListPage(),
          ),

          // ─── Admin Panel – P13: Marketplace ───────────
          GoRoute(
            path: Routes.adminMarketplaceStores,
            name: 'adminMarketplaceStores',
            builder: (context, state) => const AdminMarketplaceStoreListPage(),
          ),
          GoRoute(
            path: Routes.adminMarketplaceSettlements,
            name: 'adminMarketplaceSettlements',
            builder: (context, state) => const AdminMarketplaceSettlementListPage(),
          ),

          // ─── Admin Panel – P14: Deployment ────────────
          GoRoute(
            path: Routes.adminDeploymentOverview,
            name: 'adminDeploymentOverview',
            builder: (context, state) => const AdminDeploymentOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminDeploymentReleases,
            name: 'adminDeploymentReleases',
            builder: (context, state) => const AdminDeploymentReleaseListPage(),
          ),

          // ─── Admin Panel – Security Center ────────────
          GoRoute(
            path: Routes.adminSecurityOverview,
            name: 'adminSecurityOverview',
            builder: (context, state) => const AdminSecurityOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityAlerts,
            name: 'adminSecurityAlerts',
            builder: (context, state) => const AdminSecurityAlertsPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityAlertList,
            name: 'adminSecurityAlertList',
            builder: (context, state) => const AdminSecurityAlertListPage(),
          ),
          GoRoute(
            path: Routes.adminActivityLogList,
            name: 'adminActivityLogList',
            builder: (context, state) => const AdminActivityLogListPage(),
          ),
          GoRoute(
            path: '${Routes.adminUserActivity}/:userId',
            name: 'adminUserActivity',
            builder: (context, state) => AdminUserActivityPage(userId: state.pathParameters['userId']!),
          ),

          // ─── Admin Panel – Data Management & Health ───
          GoRoute(
            path: Routes.adminDataManagement,
            name: 'adminDataManagement',
            builder: (context, state) => const AdminDataManagementOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminDatabaseBackups,
            name: 'adminDatabaseBackups',
            builder: (context, state) => const AdminDatabaseBackupListPage(),
          ),
          GoRoute(
            path: Routes.adminHealthDashboard,
            name: 'adminHealthDashboard',
            builder: (context, state) => const AdminHealthDashboardPage(),
          ),

          // ─── ZATCA Compliance ───
          GoRoute(path: Routes.zatcaDashboard, name: 'zatcaDashboard', builder: (context, state) => const ZatcaDashboardPage()),

          // ─── Sync ───
          GoRoute(path: Routes.syncDashboard, name: 'syncDashboard', builder: (context, state) => const SyncDashboardPage()),

          // ─── Hardware ───
          GoRoute(
            path: Routes.hardwareDashboard,
            name: 'hardwareDashboard',
            builder: (context, state) => const HardwareDashboardPage(),
          ),

          // ─── Localization ───
          GoRoute(path: Routes.localization, name: 'localization', builder: (context, state) => const LocalizationPage()),

          // ─── Security ───
          GoRoute(
            path: Routes.securityDashboard,
            name: 'securityDashboard',
            builder: (context, state) => const SecurityDashboardPage(),
          ),

          // ─── Backup & Recovery ───
          GoRoute(
            path: Routes.backupDashboard,
            name: 'backupDashboard',
            builder: (context, state) => const BackupDashboardPage(),
          ),

          // ─── Mobile Companion ───
          GoRoute(
            path: Routes.companionDashboard,
            name: 'companionDashboard',
            builder: (context, state) => const CompanionDashboardPage(),
          ),

          // ─── POS Customization ───
          GoRoute(
            path: Routes.customizationDashboard,
            name: 'customizationDashboard',
            builder: (context, state) => const CustomizationDashboardPage(),
          ),

          // ─── Layout Builder ───
          GoRoute(
            path: Routes.layoutTemplates,
            name: 'layoutTemplates',
            builder: (context, state) => const LayoutTemplateListPage(),
          ),
          GoRoute(
            path: Routes.layoutBuilder,
            name: 'layoutBuilder',
            builder: (context, state) => const LayoutBuilderCanvasPage(),
          ),

          // ─── Marketplace ───
          GoRoute(path: Routes.marketplace, name: 'marketplace', builder: (context, state) => const MarketplaceBrowsePage()),
          GoRoute(
            path: '${Routes.marketplace}/:id',
            name: 'marketplaceDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MarketplaceListingDetailPage(listingId: id);
            },
          ),
          GoRoute(path: Routes.myPurchases, name: 'myPurchases', builder: (context, state) => const MyPurchasesPage()),

          // ─── Auto Updates ───
          GoRoute(
            path: Routes.autoUpdateDashboard,
            name: 'autoUpdateDashboard',
            builder: (context, state) => const AutoUpdateDashboardPage(),
          ),

          // ─── Accessibility ───
          GoRoute(
            path: Routes.accessibilityDashboard,
            name: 'accessibilityDashboard',
            builder: (context, state) => const AccessibilityDashboardPage(),
          ),

          // ─── Nice-to-Have ───
          GoRoute(
            path: Routes.niceToHaveDashboard,
            name: 'niceToHaveDashboard',
            builder: (context, state) => const NiceToHaveDashboardPage(),
          ),

          // ─── Settings ───
          GoRoute(path: Routes.settings, name: 'settings', builder: (context, state) => const SettingsPage()),

          // ─── Reports ───
          GoRoute(path: Routes.reports, name: 'reports', builder: (context, state) => const reports.DashboardPage()),
          GoRoute(
            path: Routes.reportsSalesSummary,
            name: 'reportsSalesSummary',
            builder: (context, state) => const SalesSummaryPage(),
          ),
          GoRoute(
            path: Routes.reportsHourlySales,
            name: 'reportsHourlySales',
            builder: (context, state) => const HourlySalesPage(),
          ),
          GoRoute(
            path: Routes.reportsProductPerformance,
            name: 'reportsProductPerformance',
            builder: (context, state) => const ProductPerformancePage(),
          ),
          GoRoute(
            path: Routes.reportsCategoryBreakdown,
            name: 'reportsCategoryBreakdown',
            builder: (context, state) => const CategoryBreakdownPage(),
          ),
          GoRoute(
            path: Routes.reportsPaymentMethods,
            name: 'reportsPaymentMethods',
            builder: (context, state) => const PaymentMethodsPage(),
          ),
          GoRoute(
            path: Routes.reportsStaffPerformance,
            name: 'reportsStaffPerformance',
            builder: (context, state) => const StaffPerformancePage(),
          ),
          GoRoute(
            path: Routes.reportsInventory,
            name: 'reportsInventory',
            builder: (context, state) => const InventoryReportPage(),
          ),
          GoRoute(
            path: Routes.reportsFinancial,
            name: 'reportsFinancial',
            builder: (context, state) => const FinancialReportPage(),
          ),
          GoRoute(
            path: Routes.reportsCustomers,
            name: 'reportsCustomers',
            builder: (context, state) => const CustomerReportPage(),
          ),

          // ─── Branches ───
          GoRoute(path: Routes.branches, name: 'branches', builder: (context, state) => const BranchListPage()),
          GoRoute(path: '${Routes.branches}/create', name: 'branchCreate', builder: (context, state) => const BranchFormPage()),
          GoRoute(
            path: '${Routes.branches}/:branchId',
            name: 'branchDetail',
            builder: (context, state) {
              final branchId = state.pathParameters['branchId']!;
              return BranchDetailPage(branchId: branchId);
            },
          ),
          GoRoute(
            path: '${Routes.branches}/:branchId/edit',
            name: 'branchEdit',
            builder: (context, state) {
              final extra = state.extra as Store?;
              return BranchFormPage(existingBranch: extra);
            },
          ),

          // ─── Accounting ───
          GoRoute(path: Routes.accounting, name: 'accounting', builder: (context, state) => const AccountingSettingsPage()),
          GoRoute(
            path: Routes.accountingMappings,
            name: 'accountingMappings',
            builder: (context, state) => const AccountMappingPage(),
          ),
          GoRoute(
            path: Routes.accountingExportHistory,
            name: 'accountingExportHistory',
            builder: (context, state) => const ExportHistoryPage(),
          ),
          GoRoute(
            path: Routes.accountingAutoExport,
            name: 'accountingAutoExport',
            builder: (context, state) => const AutoExportSettingsPage(),
          ),

          // ─── Promotions ───
          GoRoute(path: Routes.promotions, name: 'promotions', builder: (context, state) => const PromotionListPage()),
          GoRoute(
            path: '${Routes.promotionAnalytics}/:id',
            name: 'promotionAnalytics',
            builder: (context, state) => PromotionAnalyticsPage(promotionId: state.pathParameters['id']!),
          ),

          // ─── Thawani Pay ───
          GoRoute(path: Routes.thawaniPay, name: 'thawaniPay', builder: (context, state) => const ThawaniDashboardPage()),

          // ─── Delivery Integration ───
          GoRoute(path: Routes.delivery, name: 'delivery', builder: (context, state) => const DeliveryDashboardPage()),
          GoRoute(path: Routes.deliveryConfig, name: 'deliveryConfig', builder: (context, state) => const DeliveryConfigPage()),
          GoRoute(
            path: '${Routes.deliveryConfig}/:id',
            name: 'deliveryConfigEdit',
            builder: (context, state) => DeliveryConfigPage(configId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '${Routes.deliveryOrderDetail}/:id',
            name: 'deliveryOrderDetail',
            builder: (context, state) => DeliveryOrderDetailPage(orderId: state.pathParameters['id']!),
          ),
          GoRoute(path: Routes.deliveryMenuSync, name: 'deliveryMenuSync', builder: (context, state) => const MenuSyncPage()),
          GoRoute(
            path: Routes.deliveryWebhookLogs,
            name: 'deliveryWebhookLogs',
            builder: (context, state) => const DeliveryWebhookLogsPage(),
          ),
          GoRoute(
            path: Routes.deliveryStatusPushLogs,
            name: 'deliveryStatusPushLogs',
            builder: (context, state) => const DeliveryStatusPushLogsPage(),
          ),

          // ─── Notifications ───
          GoRoute(path: Routes.notifications, name: 'notifications', builder: (context, state) => const NotificationsListPage()),
          GoRoute(
            path: Routes.notificationPreferences,
            name: 'notificationPreferences',
            builder: (context, state) => const NotificationPreferencesPage(),
          ),

          // ─── Support ───
          GoRoute(path: Routes.support, name: 'support', builder: (context, state) => const SupportDashboardPage()),
          GoRoute(path: Routes.supportCreate, name: 'supportCreate', builder: (context, state) => const CreateTicketPage()),
          GoRoute(
            path: '${Routes.support}/tickets/:id',
            name: 'supportTicketDetail',
            builder: (context, state) => TicketDetailPage(ticketId: state.pathParameters['id']!),
          ),
          GoRoute(path: Routes.supportKb, name: 'supportKb', builder: (context, state) => const KnowledgeBasePage()),
          GoRoute(
            path: '${Routes.supportKb}/:slug',
            name: 'supportKbArticle',
            builder: (context, state) => ArticleDetailPage(slug: state.pathParameters['slug']!),
          ),

          // ─── Industry Workflows ───
          GoRoute(
            path: Routes.industryPharmacy,
            name: 'industryPharmacy',
            builder: (context, state) => const PharmacyDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryJewelry,
            name: 'industryJewelry',
            builder: (context, state) => const JewelryDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryElectronics,
            name: 'industryElectronics',
            builder: (context, state) => const ElectronicsDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryFlorist,
            name: 'industryFlorist',
            builder: (context, state) => const FloristDashboardPage(),
          ),
          GoRoute(path: Routes.industryBakery, name: 'industryBakery', builder: (context, state) => const BakeryDashboardPage()),
          GoRoute(
            path: Routes.industryRestaurant,
            name: 'industryRestaurant',
            builder: (context, state) => const RestaurantDashboardPage(),
          ),
        ], // end ShellRoute routes
      ), // end ShellRoute
      // ─── POS Cashier (full-screen, no sidebar) ──
      GoRoute(path: Routes.posCheckout, name: 'posCheckout', builder: (context, state) => const PosCashierPage()),
    ],
  );
});
