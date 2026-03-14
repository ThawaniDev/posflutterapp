import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Invoices
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Billing Invoices', () {
    test('adminBillingInvoices endpoint is correct', () {
      expect(ApiEndpoints.adminBillingInvoices, '/admin/billing/invoices');
    });

    test('adminBillingInvoiceById builds correct path', () {
      expect(ApiEndpoints.adminBillingInvoiceById('42'), '/admin/billing/invoices/42');
    });

    test('adminBillingInvoiceMarkPaid builds correct path', () {
      expect(ApiEndpoints.adminBillingInvoiceMarkPaid('42'), '/admin/billing/invoices/42/mark-paid');
    });

    test('adminBillingInvoiceRefund builds correct path', () {
      expect(ApiEndpoints.adminBillingInvoiceRefund('42'), '/admin/billing/invoices/42/refund');
    });

    test('adminBillingInvoicePdf builds correct path', () {
      expect(ApiEndpoints.adminBillingInvoicePdf('42'), '/admin/billing/invoices/42/pdf');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Failed Payments
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Failed Payments', () {
    test('adminBillingFailedPayments endpoint is correct', () {
      expect(ApiEndpoints.adminBillingFailedPayments, '/admin/billing/failed-payments');
    });

    test('adminBillingRetryPayment builds correct path', () {
      expect(ApiEndpoints.adminBillingRetryPayment('7'), '/admin/billing/failed-payments/7/retry');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Retry Rules
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Retry Rules', () {
    test('adminBillingRetryRules endpoint is correct', () {
      expect(ApiEndpoints.adminBillingRetryRules, '/admin/billing/retry-rules');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Revenue Dashboard
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Revenue Dashboard', () {
    test('adminBillingRevenue endpoint is correct', () {
      expect(ApiEndpoints.adminBillingRevenue, '/admin/billing/revenue');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Gateways
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Gateways', () {
    test('adminBillingGateways endpoint is correct', () {
      expect(ApiEndpoints.adminBillingGateways, '/admin/billing/gateways');
    });

    test('adminBillingGatewayById builds correct path', () {
      expect(ApiEndpoints.adminBillingGatewayById('3'), '/admin/billing/gateways/3');
    });

    test('adminBillingGatewayTest builds correct path', () {
      expect(ApiEndpoints.adminBillingGatewayTest('3'), '/admin/billing/gateways/3/test');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Hardware Sales
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Hardware Sales', () {
    test('adminBillingHardwareSales endpoint is correct', () {
      expect(ApiEndpoints.adminBillingHardwareSales, '/admin/billing/hardware-sales');
    });

    test('adminBillingHardwareSaleById builds correct path', () {
      expect(ApiEndpoints.adminBillingHardwareSaleById('5'), '/admin/billing/hardware-sales/5');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: API Endpoints – Implementation Fees
  // ═══════════════════════════════════════════════════════════════

  group('P5 API Endpoints - Implementation Fees', () {
    test('adminBillingImplementationFees endpoint is correct', () {
      expect(ApiEndpoints.adminBillingImplementationFees, '/admin/billing/implementation-fees');
    });

    test('adminBillingImplementationFeeById builds correct path', () {
      expect(ApiEndpoints.adminBillingImplementationFeeById('8'), '/admin/billing/implementation-fees/8');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: Route Names
  // ═══════════════════════════════════════════════════════════════

  group('P5 Route Names', () {
    test('adminBillingInvoices route exists', () {
      expect(Routes.adminBillingInvoices, '/admin/billing/invoices');
    });

    test('adminBillingInvoiceDetail route exists', () {
      expect(Routes.adminBillingInvoiceDetail, isNotEmpty);
    });

    test('adminBillingCreateInvoice route exists', () {
      expect(Routes.adminBillingCreateInvoice, '/admin/billing/invoices/create');
    });

    test('adminBillingFailedPayments route exists', () {
      expect(Routes.adminBillingFailedPayments, '/admin/billing/failed-payments');
    });

    test('adminBillingRetryRules route exists', () {
      expect(Routes.adminBillingRetryRules, '/admin/billing/retry-rules');
    });

    test('adminBillingRevenue route exists', () {
      expect(Routes.adminBillingRevenue, '/admin/billing/revenue');
    });

    test('adminBillingGateways route exists', () {
      expect(Routes.adminBillingGateways, '/admin/billing/gateways');
    });

    test('adminBillingGatewayDetail route exists', () {
      expect(Routes.adminBillingGatewayDetail, isNotEmpty);
    });

    test('adminBillingGatewayCreate route exists', () {
      expect(Routes.adminBillingGatewayCreate, '/admin/billing/gateways/create');
    });

    test('adminBillingHardwareSales route exists', () {
      expect(Routes.adminBillingHardwareSales, '/admin/billing/hardware-sales');
    });

    test('adminBillingHardwareSaleDetail route exists', () {
      expect(Routes.adminBillingHardwareSaleDetail, isNotEmpty);
    });

    test('adminBillingHardwareSaleCreate route exists', () {
      expect(Routes.adminBillingHardwareSaleCreate, '/admin/billing/hardware-sales/create');
    });

    test('adminBillingImplementationFees route exists', () {
      expect(Routes.adminBillingImplementationFees, '/admin/billing/implementation-fees');
    });

    test('adminBillingImplementationFeeDetail route exists', () {
      expect(Routes.adminBillingImplementationFeeDetail, isNotEmpty);
    });

    test('adminBillingImplementationFeeCreate route exists', () {
      expect(Routes.adminBillingImplementationFeeCreate, '/admin/billing/implementation-fees/create');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: BillingInvoiceListState
  // ═══════════════════════════════════════════════════════════════

  group('BillingInvoiceListState', () {
    test('BillingInvoiceListInitial is default', () {
      const state = BillingInvoiceListInitial();
      expect(state, isA<BillingInvoiceListState>());
    });

    test('BillingInvoiceListLoading represents loading', () {
      const state = BillingInvoiceListLoading();
      expect(state, isA<BillingInvoiceListState>());
    });

    test('BillingInvoiceListLoaded holds invoices with pagination', () {
      const state = BillingInvoiceListLoaded(
        [
          {'id': 1, 'invoice_number': 'INV-001', 'total_amount': 500.00, 'status': 'paid'},
        ],
        {'current_page': 1, 'last_page': 1, 'total': 1},
      );
      expect(state.invoices.length, 1);
      expect(state.invoices.first['invoice_number'], 'INV-001');
      expect(state.pagination['total'], 1);
    });

    test('BillingInvoiceListLoaded can hold multiple invoices', () {
      const state = BillingInvoiceListLoaded(
        [
          {'id': 1, 'status': 'paid', 'total_amount': 100},
          {'id': 2, 'status': 'pending', 'total_amount': 200},
          {'id': 3, 'status': 'failed', 'total_amount': 300},
        ],
        {'current_page': 1, 'last_page': 1, 'total': 3},
      );
      expect(state.invoices.length, 3);
      expect(state.pagination['total'], 3);
    });

    test('BillingInvoiceListError holds error message', () {
      const state = BillingInvoiceListError('Server error');
      expect(state.message, 'Server error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: BillingInvoiceDetailState
  // ═══════════════════════════════════════════════════════════════

  group('BillingInvoiceDetailState', () {
    test('BillingInvoiceDetailInitial is default', () {
      const state = BillingInvoiceDetailInitial();
      expect(state, isA<BillingInvoiceDetailState>());
    });

    test('BillingInvoiceDetailLoading represents loading', () {
      const state = BillingInvoiceDetailLoading();
      expect(state, isA<BillingInvoiceDetailState>());
    });

    test('BillingInvoiceDetailLoaded holds full invoice detail', () {
      const state = BillingInvoiceDetailLoaded({
        'id': 1,
        'invoice_number': 'INV-001',
        'subtotal': 450.00,
        'tax_amount': 67.50,
        'total_amount': 517.50,
        'status': 'paid',
        'due_date': '2025-03-01',
        'line_items': [
          {'id': 1, 'description': 'Basic Plan - Monthly', 'quantity': 1, 'unit_price': 450.00, 'total_price': 450.00},
        ],
      });
      expect(state.invoice['invoice_number'], 'INV-001');
      expect(state.invoice['total_amount'], 517.50);
      expect((state.invoice['line_items'] as List).length, 1);
    });

    test('BillingInvoiceDetailError holds error message', () {
      const state = BillingInvoiceDetailError('Invoice not found');
      expect(state.message, 'Invoice not found');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: RevenueDashboardState
  // ═══════════════════════════════════════════════════════════════

  group('RevenueDashboardState', () {
    test('RevenueDashboardInitial is default', () {
      const state = RevenueDashboardInitial();
      expect(state, isA<RevenueDashboardState>());
    });

    test('RevenueDashboardLoading represents loading', () {
      const state = RevenueDashboardLoading();
      expect(state, isA<RevenueDashboardState>());
    });

    test('RevenueDashboardLoaded holds all revenue metrics', () {
      const state = RevenueDashboardLoaded(
        mrr: 15000.0,
        arr: 180000.0,
        revenueByStatus: [
          {'status': 'paid', 'revenue': 12000, 'count': 24},
          {'status': 'pending', 'revenue': 3000, 'count': 6},
        ],
        upcomingRenewals: 12,
        hardwareRevenue: 5000.0,
        implementationRevenue: 8000.0,
        totalInvoices: 50,
        paidInvoices: 40,
        failedInvoices: 5,
      );
      expect(state.mrr, 15000.0);
      expect(state.arr, 180000.0);
      expect(state.revenueByStatus.length, 2);
      expect(state.upcomingRenewals, 12);
      expect(state.hardwareRevenue, 5000.0);
      expect(state.implementationRevenue, 8000.0);
      expect(state.totalInvoices, 50);
      expect(state.paidInvoices, 40);
      expect(state.failedInvoices, 5);
    });

    test('RevenueDashboardError holds error message', () {
      const state = RevenueDashboardError('Dashboard unavailable');
      expect(state.message, 'Dashboard unavailable');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: GatewayListState
  // ═══════════════════════════════════════════════════════════════

  group('GatewayListState', () {
    test('GatewayListInitial is default', () {
      const state = GatewayListInitial();
      expect(state, isA<GatewayListState>());
    });

    test('GatewayListLoading represents loading', () {
      const state = GatewayListLoading();
      expect(state, isA<GatewayListState>());
    });

    test('GatewayListLoaded holds gateway data', () {
      const state = GatewayListLoaded([
        {
          'id': 1,
          'gateway_name': 'Thawani Pay',
          'environment': 'production',
          'is_active': true,
          'has_credentials': true,
          'webhook_url': 'https://api.example.com/webhook',
        },
        {'id': 2, 'gateway_name': 'Stripe Test', 'environment': 'sandbox', 'is_active': false, 'has_credentials': false},
      ]);
      expect(state.gateways.length, 2);
      expect(state.gateways.first['gateway_name'], 'Thawani Pay');
      expect(state.gateways.first['is_active'], true);
      expect(state.gateways.last['environment'], 'sandbox');
    });

    test('GatewayListError holds error message', () {
      const state = GatewayListError('Cannot fetch gateways');
      expect(state.message, 'Cannot fetch gateways');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: HardwareSaleListState
  // ═══════════════════════════════════════════════════════════════

  group('HardwareSaleListState', () {
    test('HardwareSaleListInitial is default', () {
      const state = HardwareSaleListInitial();
      expect(state, isA<HardwareSaleListState>());
    });

    test('HardwareSaleListLoading represents loading', () {
      const state = HardwareSaleListLoading();
      expect(state, isA<HardwareSaleListState>());
    });

    test('HardwareSaleListLoaded holds sales with pagination', () {
      const state = HardwareSaleListLoaded(
        [
          {
            'id': 1,
            'item_type': 'terminal',
            'item_description': 'Sunmi V2s',
            'serial_number': 'SN-001',
            'amount': 850.00,
            'store_name': 'Store Alpha',
            'sold_at': '2025-01-15 10:00:00',
          },
        ],
        {'current_page': 1, 'last_page': 1, 'total': 1},
      );
      expect(state.sales.length, 1);
      expect(state.sales.first['item_type'], 'terminal');
      expect(state.sales.first['amount'], 850.00);
      expect(state.pagination['total'], 1);
    });

    test('HardwareSaleListError holds error message', () {
      const state = HardwareSaleListError('Cannot load sales');
      expect(state.message, 'Cannot load sales');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: ImplementationFeeListState
  // ═══════════════════════════════════════════════════════════════

  group('ImplementationFeeListState', () {
    test('ImplementationFeeListInitial is default', () {
      const state = ImplementationFeeListInitial();
      expect(state, isA<ImplementationFeeListState>());
    });

    test('ImplementationFeeListLoading represents loading', () {
      const state = ImplementationFeeListLoading();
      expect(state, isA<ImplementationFeeListState>());
    });

    test('ImplementationFeeListLoaded holds fees with pagination', () {
      const state = ImplementationFeeListLoaded(
        [
          {'id': 1, 'fee_type': 'setup', 'amount': 1500.00, 'status': 'invoiced', 'store_name': 'Store Alpha'},
          {'id': 2, 'fee_type': 'training', 'amount': 500.00, 'status': 'paid', 'store_name': 'Store Beta'},
        ],
        {'current_page': 1, 'last_page': 1, 'total': 2},
      );
      expect(state.fees.length, 2);
      expect(state.fees.first['fee_type'], 'setup');
      expect(state.fees.first['status'], 'invoiced');
      expect(state.fees.last['fee_type'], 'training');
      expect(state.pagination['total'], 2);
    });

    test('ImplementationFeeListError holds error message', () {
      const state = ImplementationFeeListError('Cannot load fees');
      expect(state.message, 'Cannot load fees');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: RetryRulesState
  // ═══════════════════════════════════════════════════════════════

  group('RetryRulesState', () {
    test('RetryRulesInitial is default', () {
      const state = RetryRulesInitial();
      expect(state, isA<RetryRulesState>());
    });

    test('RetryRulesLoading represents loading', () {
      const state = RetryRulesLoading();
      expect(state, isA<RetryRulesState>());
    });

    test('RetryRulesLoaded holds config values', () {
      const state = RetryRulesLoaded(maxRetries: 3, retryIntervalHours: 24, gracePeriodDays: 7);
      expect(state.maxRetries, 3);
      expect(state.retryIntervalHours, 24);
      expect(state.gracePeriodDays, 7);
    });

    test('RetryRulesLoaded boundary values - min', () {
      const state = RetryRulesLoaded(maxRetries: 1, retryIntervalHours: 1, gracePeriodDays: 1);
      expect(state.maxRetries, 1);
      expect(state.retryIntervalHours, 1);
      expect(state.gracePeriodDays, 1);
    });

    test('RetryRulesLoaded boundary values - max', () {
      const state = RetryRulesLoaded(maxRetries: 10, retryIntervalHours: 168, gracePeriodDays: 30);
      expect(state.maxRetries, 10);
      expect(state.retryIntervalHours, 168);
      expect(state.gracePeriodDays, 30);
    });

    test('RetryRulesError holds error message', () {
      const state = RetryRulesError('Cannot load rules');
      expect(state.message, 'Cannot load rules');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: Cross-feature – Endpoint Integrity
  // ═══════════════════════════════════════════════════════════════

  group('P5 Endpoint Integrity', () {
    test('all billing endpoints start with /admin/billing/', () {
      final endpoints = [
        ApiEndpoints.adminBillingInvoices,
        ApiEndpoints.adminBillingInvoiceById('1'),
        ApiEndpoints.adminBillingInvoiceMarkPaid('1'),
        ApiEndpoints.adminBillingInvoiceRefund('1'),
        ApiEndpoints.adminBillingInvoicePdf('1'),
        ApiEndpoints.adminBillingFailedPayments,
        ApiEndpoints.adminBillingRetryPayment('1'),
        ApiEndpoints.adminBillingRetryRules,
        ApiEndpoints.adminBillingRevenue,
        ApiEndpoints.adminBillingGateways,
        ApiEndpoints.adminBillingGatewayById('1'),
        ApiEndpoints.adminBillingGatewayTest('1'),
        ApiEndpoints.adminBillingHardwareSales,
        ApiEndpoints.adminBillingHardwareSaleById('1'),
        ApiEndpoints.adminBillingImplementationFees,
        ApiEndpoints.adminBillingImplementationFeeById('1'),
      ];

      for (final ep in endpoints) {
        expect(ep, startsWith('/admin/billing/'), reason: '$ep should start with /admin/billing/');
      }
    });

    test('all billing routes start with /admin/billing/', () {
      final routes = [
        Routes.adminBillingInvoices,
        Routes.adminBillingInvoiceDetail,
        Routes.adminBillingCreateInvoice,
        Routes.adminBillingFailedPayments,
        Routes.adminBillingRetryRules,
        Routes.adminBillingRevenue,
        Routes.adminBillingGateways,
        Routes.adminBillingGatewayDetail,
        Routes.adminBillingGatewayCreate,
        Routes.adminBillingHardwareSales,
        Routes.adminBillingHardwareSaleDetail,
        Routes.adminBillingHardwareSaleCreate,
        Routes.adminBillingImplementationFees,
        Routes.adminBillingImplementationFeeDetail,
        Routes.adminBillingImplementationFeeCreate,
      ];

      for (final r in routes) {
        expect(r, startsWith('/admin/billing/'), reason: '$r should start with /admin/billing/');
      }
    });

    test('parametric invoice endpoints use correct ID', () {
      expect(ApiEndpoints.adminBillingInvoiceById('999'), contains('/999'));
      expect(ApiEndpoints.adminBillingInvoiceMarkPaid('999'), endsWith('/999/mark-paid'));
      expect(ApiEndpoints.adminBillingInvoiceRefund('999'), endsWith('/999/refund'));
      expect(ApiEndpoints.adminBillingInvoicePdf('999'), endsWith('/999/pdf'));
    });

    test('parametric gateway endpoints use correct ID', () {
      expect(ApiEndpoints.adminBillingGatewayById('55'), contains('/55'));
      expect(ApiEndpoints.adminBillingGatewayTest('55'), endsWith('/55/test'));
    });

    test('parametric retry payment endpoint uses correct ID', () {
      expect(ApiEndpoints.adminBillingRetryPayment('12'), '/admin/billing/failed-payments/12/retry');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // P5: Data Shape Validation
  // ═══════════════════════════════════════════════════════════════

  group('P5 Data Shape Validation', () {
    test('RevenueDashboardLoaded exposes all required metrics', () {
      const state = RevenueDashboardLoaded(
        mrr: 10000,
        arr: 120000,
        revenueByStatus: [],
        upcomingRenewals: 5,
        hardwareRevenue: 3000,
        implementationRevenue: 2000,
        totalInvoices: 100,
        paidInvoices: 80,
        failedInvoices: 10,
      );

      expect(state.mrr, isA<double>());
      expect(state.arr, isA<double>());
      expect(state.revenueByStatus, isA<List>());
      expect(state.upcomingRenewals, isA<int>());
      expect(state.hardwareRevenue, isA<double>());
      expect(state.implementationRevenue, isA<double>());
      expect(state.totalInvoices, isA<int>());
      expect(state.paidInvoices, isA<int>());
      expect(state.failedInvoices, isA<int>());
    });

    test('RetryRulesLoaded provides consistent data types', () {
      const state = RetryRulesLoaded(maxRetries: 5, retryIntervalHours: 48, gracePeriodDays: 14);
      expect(state.maxRetries, isA<int>());
      expect(state.retryIntervalHours, isA<int>());
      expect(state.gracePeriodDays, isA<int>());
    });

    test('GatewayListLoaded credentials are never exposed', () {
      const state = GatewayListLoaded([
        {'id': 1, 'gateway_name': 'Test', 'has_credentials': true},
      ]);
      expect(state.gateways.first.containsKey('credentials_encrypted'), false);
      expect(state.gateways.first['has_credentials'], true);
    });

    test('Invoice state supports all statuses', () {
      for (final status in ['paid', 'pending', 'failed', 'refunded', 'draft']) {
        final state = BillingInvoiceListLoaded(
          [
            {'id': 1, 'status': status},
          ],
          const {'current_page': 1, 'last_page': 1, 'total': 1},
        );
        expect(state.invoices.first['status'], status);
      }
    });

    test('HardwareSale supports all item types', () {
      for (final type in ['terminal', 'printer', 'scanner', 'other']) {
        final state = HardwareSaleListLoaded(
          [
            {'id': 1, 'item_type': type, 'amount': 100},
          ],
          const {'current_page': 1, 'last_page': 1, 'total': 1},
        );
        expect(state.sales.first['item_type'], type);
      }
    });

    test('ImplementationFee supports all fee types', () {
      for (final type in ['setup', 'training', 'custom_dev']) {
        final state = ImplementationFeeListLoaded(
          [
            {'id': 1, 'fee_type': type, 'status': 'invoiced'},
          ],
          const {'current_page': 1, 'last_page': 1, 'total': 1},
        );
        expect(state.fees.first['fee_type'], type);
      }
    });

    test('ImplementationFee supports all statuses', () {
      for (final status in ['invoiced', 'paid']) {
        final state = ImplementationFeeListLoaded(
          [
            {'id': 1, 'fee_type': 'setup', 'status': status},
          ],
          const {'current_page': 1, 'last_page': 1, 'total': 1},
        );
        expect(state.fees.first['status'], status);
      }
    });
  });
}
