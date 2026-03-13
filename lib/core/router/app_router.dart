import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
import 'package:thawani_pos/features/labels/pages/label_list_page.dart';
import 'package:thawani_pos/features/onboarding/pages/onboarding_wizard_page.dart';
import 'package:thawani_pos/features/onboarding/pages/store_settings_page.dart';
import 'package:thawani_pos/features/onboarding/pages/working_hours_page.dart';
import 'package:thawani_pos/features/orders/pages/order_list_page.dart';
import 'package:thawani_pos/features/payments/pages/cash_sessions_page.dart';
import 'package:thawani_pos/features/pos_terminal/pages/pos_sessions_page.dart';
import 'package:thawani_pos/features/staff/pages/role_create_page.dart';
import 'package:thawani_pos/features/staff/pages/role_detail_page.dart';
import 'package:thawani_pos/features/staff/pages/roles_list_page.dart';
import 'package:thawani_pos/features/subscription/pages/billing_history_page.dart';
import 'package:thawani_pos/features/subscription/pages/plan_selection_page.dart';
import 'package:thawani_pos/features/subscription/pages/subscription_status_page.dart';
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

      // Authenticated → redirect away from auth pages to dashboard
      if (isAuthenticated && isPublicRoute) {
        return Routes.dashboard;
      }

      return null;
    },
    routes: [
      // ─── Auth ─────────────────────────────────────
      GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: Routes.loginPin, name: 'loginPin', builder: (context, state) => const PinLoginPage()),
      GoRoute(path: Routes.register, name: 'register', builder: (context, state) => const RegisterPage()),

      // ─── Main (protected) ─────────────────────────
      GoRoute(
        path: Routes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const Scaffold(body: Center(child: Text('Dashboard — Phase 2'))),
      ),
      GoRoute(
        path: Routes.pos,
        name: 'pos',
        builder: (context, state) => const Scaffold(body: Center(child: Text('POS Terminal — Phase 2'))),
      ),

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
      GoRoute(path: Routes.goodsReceiptsAdd, name: 'goodsReceiptsAdd', builder: (context, state) => const GoodsReceiptFormPage()),
      GoRoute(path: Routes.stockAdjustments, name: 'stockAdjustments', builder: (context, state) => const StockAdjustmentsPage()),
      GoRoute(path: Routes.stockTransfers, name: 'stockTransfers', builder: (context, state) => const StockTransfersPage()),
      GoRoute(path: Routes.purchaseOrders, name: 'purchaseOrders', builder: (context, state) => const PurchaseOrdersPage()),
      GoRoute(path: Routes.recipes, name: 'recipes', builder: (context, state) => const RecipesPage()),

      // ─── POS Terminal ─────────────────────────────
      GoRoute(path: Routes.posSessions, name: 'posSessions', builder: (context, state) => const PosSessionsPage()),

      // ─── Orders ───────────────────────────────────
      GoRoute(path: Routes.orders, name: 'orders', builder: (context, state) => const OrderListPage()),

      // ─── Payments ─────────────────────────────────
      GoRoute(path: Routes.cashSessions, name: 'cashSessions', builder: (context, state) => const CashSessionsPage()),

      // ─── Customers ────────────────────────────────
      GoRoute(path: Routes.customers, name: 'customers', builder: (context, state) => const CustomerListPage()),

      // ─── Labels ───────────────────────────────────
      GoRoute(path: Routes.labels, name: 'labels', builder: (context, state) => const LabelListPage()),

      // ─── Staff / Roles ────────────────────────────
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
    ],
  );
});
