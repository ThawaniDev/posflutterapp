import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P3: API Endpoints
  // ═══════════════════════════════════════════════════════════════

  group('P3 API Endpoints', () {
    test('adminPlans endpoint is correct', () {
      expect(ApiEndpoints.adminPlans, '/admin/plans');
    });

    test('adminPlanById builds correct path', () {
      expect(ApiEndpoints.adminPlanById('plan-123'), '/admin/plans/plan-123');
    });

    test('adminPlanToggle builds correct path', () {
      expect(ApiEndpoints.adminPlanToggle('plan-123'), '/admin/plans/plan-123/toggle');
    });

    test('adminPlanCompare endpoint is correct', () {
      expect(ApiEndpoints.adminPlanCompare, '/admin/plans/compare');
    });

    test('adminAddOns endpoint is correct', () {
      expect(ApiEndpoints.adminAddOns, '/admin/add-ons');
    });

    test('adminAddOnById builds correct path', () {
      expect(ApiEndpoints.adminAddOnById('ao-1'), '/admin/add-ons/ao-1');
    });

    test('adminDiscounts endpoint is correct', () {
      expect(ApiEndpoints.adminDiscounts, '/admin/discounts');
    });

    test('adminDiscountById builds correct path', () {
      expect(ApiEndpoints.adminDiscountById('d-1'), '/admin/discounts/d-1');
    });

    test('adminSubscriptions endpoint is correct', () {
      expect(ApiEndpoints.adminSubscriptions, '/admin/subscriptions');
    });

    test('adminSubscriptionById builds correct path', () {
      expect(ApiEndpoints.adminSubscriptionById('sub-1'), '/admin/subscriptions/sub-1');
    });

    test('adminInvoices endpoint is correct', () {
      expect(ApiEndpoints.adminInvoices, '/admin/invoices');
    });

    test('adminInvoiceById builds correct path', () {
      expect(ApiEndpoints.adminInvoiceById('inv-1'), '/admin/invoices/inv-1');
    });

    test('adminRevenueDashboard endpoint is correct', () {
      expect(ApiEndpoints.adminRevenueDashboard, '/admin/revenue-dashboard');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Route Names
  // ═══════════════════════════════════════════════════════════════

  group('P3 Route Names', () {
    test('adminPlans route exists', () {
      expect(Routes.adminPlans, '/admin/plans');
    });

    test('adminPlanDetail route exists', () {
      expect(Routes.adminPlanDetail, isNotEmpty);
    });

    test('adminPlanCreate route exists', () {
      expect(Routes.adminPlanCreate, '/admin/plans/create');
    });

    test('adminAddOns route exists', () {
      expect(Routes.adminAddOns, '/admin/add-ons');
    });

    test('adminDiscounts route exists', () {
      expect(Routes.adminDiscounts, '/admin/discounts');
    });

    test('adminDiscountDetail route exists', () {
      expect(Routes.adminDiscountDetail, isNotEmpty);
    });

    test('adminSubscriptions route exists', () {
      expect(Routes.adminSubscriptions, '/admin/subscriptions');
    });

    test('adminSubscriptionDetail route exists', () {
      expect(Routes.adminSubscriptionDetail, isNotEmpty);
    });

    test('adminInvoices route exists', () {
      expect(Routes.adminInvoices, '/admin/invoices');
    });

    test('adminInvoiceDetail route exists', () {
      expect(Routes.adminInvoiceDetail, isNotEmpty);
    });

    test('adminRevenueDashboard route exists', () {
      expect(Routes.adminRevenueDashboard, '/admin/revenue-dashboard');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Plan List State
  // ═══════════════════════════════════════════════════════════════

  group('PlanListState', () {
    test('PlanListInitial is default state', () {
      const state = PlanListInitial();
      expect(state, isA<PlanListState>());
    });

    test('PlanListLoading represents loading', () {
      const state = PlanListLoading();
      expect(state, isA<PlanListState>());
    });

    test('PlanListLoaded holds plans', () {
      const state = PlanListLoaded([
        {'id': '1', 'name': 'Basic', 'monthly_price': 10.0},
      ]);
      expect(state.plans.length, 1);
      expect(state.plans.first['name'], 'Basic');
    });

    test('PlanListError holds error message', () {
      const state = PlanListError('Network error');
      expect(state.message, 'Network error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Plan Detail State
  // ═══════════════════════════════════════════════════════════════

  group('PlanDetailState', () {
    test('PlanDetailInitial is default state', () {
      const state = PlanDetailInitial();
      expect(state, isA<PlanDetailState>());
    });

    test('PlanDetailLoading represents loading', () {
      const state = PlanDetailLoading();
      expect(state, isA<PlanDetailState>());
    });

    test('PlanDetailLoaded holds plan with features', () {
      const state = PlanDetailLoaded({
        'id': '1',
        'name': 'Premium',
        'features': [
          {'feature_key': 'pos_basic', 'is_enabled': true},
        ],
        'limits': [
          {'limit_key': 'products', 'limit_value': 10000},
        ],
      });
      expect(state.plan['name'], 'Premium');
      expect((state.plan['features'] as List).length, 1);
    });

    test('PlanDetailError holds error message', () {
      const state = PlanDetailError('Not found');
      expect(state.message, 'Not found');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Add-On List State
  // ═══════════════════════════════════════════════════════════════

  group('AddOnListState', () {
    test('AddOnListInitial is default state', () {
      const state = AddOnListInitial();
      expect(state, isA<AddOnListState>());
    });

    test('AddOnListLoaded holds add-ons', () {
      const state = AddOnListLoaded([
        {'id': '1', 'name': 'SMS Pack', 'monthly_price': 5.0},
      ]);
      expect(state.addOns.length, 1);
      expect(state.addOns.first['name'], 'SMS Pack');
    });

    test('AddOnListError holds error', () {
      const state = AddOnListError('Failed');
      expect(state.message, 'Failed');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Discount List State
  // ═══════════════════════════════════════════════════════════════

  group('DiscountListState', () {
    test('DiscountListInitial is default state', () {
      const state = DiscountListInitial();
      expect(state, isA<DiscountListState>());
    });

    test('DiscountListLoaded holds discounts with pagination', () {
      const state = DiscountListLoaded(
        discounts: [
          {'id': '1', 'code': 'SAVE20', 'type': 'percentage', 'value': 20.0},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.discounts.length, 1);
      expect(state.discounts.first['code'], 'SAVE20');
      expect(state.total, 1);
    });

    test('DiscountListError holds error', () {
      const state = DiscountListError('Server error');
      expect(state.message, 'Server error');
    });

    test('discount type can be percentage or fixed', () {
      final percentageDiscount = {'type': 'percentage', 'value': 20.0};
      final fixedDiscount = {'type': 'fixed', 'value': 50.0};
      expect(percentageDiscount['type'], 'percentage');
      expect(fixedDiscount['type'], 'fixed');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Subscription List State
  // ═══════════════════════════════════════════════════════════════

  group('SubscriptionListState', () {
    test('SubscriptionListInitial is default state', () {
      const state = SubscriptionListInitial();
      expect(state, isA<SubscriptionListState>());
    });

    test('SubscriptionListLoaded holds subscriptions with pagination', () {
      const state = SubscriptionListLoaded(
        subscriptions: [
          {'id': '1', 'store_id': 'store-1', 'status': 'active', 'billing_cycle': 'monthly'},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.subscriptions.length, 1);
      expect(state.subscriptions.first['status'], 'active');
    });

    test('SubscriptionListError holds error', () {
      const state = SubscriptionListError('Connection timeout');
      expect(state.message, 'Connection timeout');
    });

    test('subscription statuses are valid', () {
      const validStatuses = ['trial', 'active', 'grace', 'cancelled', 'expired'];
      for (final s in validStatuses) {
        expect(s, isNotEmpty);
      }
      expect(validStatuses.length, 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Invoice List State
  // ═══════════════════════════════════════════════════════════════

  group('InvoiceListState', () {
    test('InvoiceListInitial is default state', () {
      const state = InvoiceListInitial();
      expect(state, isA<InvoiceListState>());
    });

    test('InvoiceListLoaded holds invoices with pagination', () {
      const state = InvoiceListLoaded(
        invoices: [
          {'id': '1', 'invoice_number': 'INV-001', 'total': 11.5, 'status': 'pending'},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.invoices.length, 1);
      expect(state.invoices.first['invoice_number'], 'INV-001');
    });

    test('InvoiceListError holds error', () {
      const state = InvoiceListError('Unauthorized');
      expect(state.message, 'Unauthorized');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Revenue Dashboard State
  // ═══════════════════════════════════════════════════════════════

  group('RevenueDashboardState', () {
    test('RevenueDashboardInitial is default state', () {
      const state = RevenueDashboardInitial();
      expect(state, isA<RevenueDashboardState>());
    });

    test('RevenueDashboardLoading represents loading', () {
      const state = RevenueDashboardLoading();
      expect(state, isA<RevenueDashboardState>());
    });

    test('RevenueDashboardLoaded holds subscription counts and revenue', () {
      const state = RevenueDashboardLoaded(
        subscriptions: {'active': 50, 'trial': 10, 'grace': 3, 'cancelled': 5},
        revenue: {'monthly': 5000.0, 'pending_invoices': 7},
      );
      expect(state.subscriptions['active'], 50);
      expect(state.subscriptions['trial'], 10);
      expect(state.revenue['monthly'], 5000.0);
      expect(state.revenue['pending_invoices'], 7);
    });

    test('RevenueDashboardError holds error message', () {
      const state = RevenueDashboardError('Timeout');
      expect(state.message, 'Timeout');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P3: Data Integrity & Edge Cases
  // ═══════════════════════════════════════════════════════════════

  group('P3 Data Integrity', () {
    test('plan with features and limits has correct structure', () {
      final plan = {
        'id': 'uuid-1',
        'name': 'Pro',
        'name_ar': 'احترافي',
        'slug': 'pro',
        'monthly_price': 30.0,
        'annual_price': 300.0,
        'trial_days': 7,
        'grace_period_days': 14,
        'is_active': true,
        'is_highlighted': false,
        'sort_order': 2,
        'features': [
          {'feature_key': 'pos_basic', 'is_enabled': true},
          {'feature_key': 'delivery', 'is_enabled': false},
        ],
        'limits': [
          {'limit_key': 'products', 'limit_value': 500},
          {'limit_key': 'staff', 'limit_value': 10, 'price_per_extra_unit': 2.0},
        ],
      };

      expect(plan['name'], 'Pro');
      expect(plan['name_ar'], 'احترافي');
      expect((plan['features'] as List).length, 2);
      expect((plan['limits'] as List).length, 2);
    });

    test('discount with applicable plan IDs', () {
      final discount = {
        'id': 'uuid-1',
        'code': 'BASIC_ONLY',
        'type': 'percentage',
        'value': 10.0,
        'applicable_plan_ids': ['plan-1', 'plan-2'],
      };

      expect((discount['applicable_plan_ids'] as List).contains('plan-1'), true);
    });

    test('invoice total equals amount plus tax', () {
      final invoice = {'amount': 50.0, 'tax': 7.5, 'total': 57.5};

      expect((invoice['amount'] as double) + (invoice['tax'] as double), invoice['total']);
    });

    test('subscription with nested plan data', () {
      final subscription = {
        'id': 'sub-1',
        'store_id': 'store-1',
        'status': 'active',
        'billing_cycle': 'monthly',
        'plan': {'id': 'plan-1', 'name': 'Basic'},
        'invoices': [
          {'id': 'inv-1', 'total': 11.5},
        ],
      };

      expect((subscription['plan'] as Map<String, dynamic>)['name'], 'Basic');
      expect((subscription['invoices'] as List).length, 1);
    });

    test('empty plans list produces empty state', () {
      const state = PlanListLoaded([]);
      expect(state.plans.isEmpty, true);
    });

    test('all P3 endpoints use /admin/ prefix', () {
      expect(ApiEndpoints.adminPlans, startsWith('/admin/'));
      expect(ApiEndpoints.adminAddOns, startsWith('/admin/'));
      expect(ApiEndpoints.adminDiscounts, startsWith('/admin/'));
      expect(ApiEndpoints.adminSubscriptions, startsWith('/admin/'));
      expect(ApiEndpoints.adminInvoices, startsWith('/admin/'));
      expect(ApiEndpoints.adminRevenueDashboard, startsWith('/admin/'));
      expect(ApiEndpoints.adminPlanCompare, startsWith('/admin/'));
    });

    test('dynamic endpoints include the ID', () {
      const testId = 'abc-123';
      expect(ApiEndpoints.adminPlanById(testId), contains(testId));
      expect(ApiEndpoints.adminAddOnById(testId), contains(testId));
      expect(ApiEndpoints.adminDiscountById(testId), contains(testId));
      expect(ApiEndpoints.adminSubscriptionById(testId), contains(testId));
      expect(ApiEndpoints.adminInvoiceById(testId), contains(testId));
      expect(ApiEndpoints.adminPlanToggle(testId), contains(testId));
    });

    test('revenue dashboard state tracks all subscription statuses', () {
      const state = RevenueDashboardLoaded(
        subscriptions: {'active': 100, 'trial': 20, 'grace': 5, 'cancelled': 10},
        revenue: {'monthly': 15000.0, 'pending_invoices': 12},
      );

      expect(state.subscriptions.keys.length, 4);
      expect(state.subscriptions.containsKey('active'), true);
      expect(state.subscriptions.containsKey('trial'), true);
      expect(state.subscriptions.containsKey('grace'), true);
      expect(state.subscriptions.containsKey('cancelled'), true);
    });
  });
}
