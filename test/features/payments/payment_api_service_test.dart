// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/payments/data/remote/payment_api_service.dart';
import 'package:wameedpos/features/payments/enums/cash_event_type.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/enums/refund_status.dart';

// ─── Helpers ──────────────────────────────────────────────────────

/// Creates a fake Dio that resolves every request with the data returned by
/// [handler]. Allows asserting on request parameters without real HTTP.
Dio _fakeDio(Map<String, dynamic> Function(RequestOptions opts) handler) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        try {
          final data = handler(opts);
          requestHandler.resolve(Response(data: data, requestOptions: opts, statusCode: 200));
        } catch (e) {
          requestHandler.reject(DioException(requestOptions: opts, error: e));
        }
      },
    ),
  );
  return dio;
}

/// Dio that always rejects with a 422 server error.
Dio _errorDio({int statusCode = 422}) {
  final dio = Dio();
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (opts, requestHandler) {
        requestHandler.reject(
          DioException(
            requestOptions: opts,
            response: Response(
              data: {'success': false, 'message': 'Validation error'},
              requestOptions: opts,
              statusCode: statusCode,
            ),
            type: DioExceptionType.badResponse,
          ),
        );
      },
    ),
  );
  return dio;
}

/// Standard API envelope.
Map<String, dynamic> _env(dynamic data, {String message = 'ok'}) =>
    {'success': true, 'message': message, 'data': data};

/// Paginated envelope.
Map<String, dynamic> _page(List<dynamic> items, {int total = 0, int page = 1, int lastPage = 1, int perPage = 20}) =>
    _env({
      'data': items,
      'total': total == 0 ? items.length : total,
      'current_page': page,
      'last_page': lastPage,
      'per_page': perPage,
    });

// ─── Fixtures ─────────────────────────────────────────────────────

Map<String, dynamic> _paymentJson({String id = 'pay-001', String method = 'cash', String amount = '50.00'}) => {
      'id': id,
      'transaction_id': 'tx-001',
      'method': method,
      'amount': amount,
      'status': 'completed',
    };

Map<String, dynamic> _refundJson({String id = 'ref-001', String status = 'completed'}) => {
      'id': id,
      'return_id': 'ret-001',
      'payment_id': 'pay-001',
      'method': 'cash',
      'amount': '25.00',
      'status': status,
      'processed_by': 'user-001',
    };

Map<String, dynamic> _cashSessionJson({String id = 'cs-001', String status = 'open'}) => {
      'id': id,
      'store_id': 'store-001',
      'opened_by': 'user-001',
      'opening_float': '300.00',
      'status': status,
      'opened_at': '2026-05-01T08:00:00.000Z',
    };

Map<String, dynamic> _cashEventJson({String id = 'ce-001', String type = 'cash_in'}) => {
      'id': id,
      'cash_session_id': 'cs-001',
      'type': type,
      'amount': '100.00',
      'reason': 'sales',
      'performed_by': 'user-001',
    };

Map<String, dynamic> _expenseJson({String id = 'exp-001', String category = 'supplies'}) => {
      'id': id,
      'store_id': 'store-001',
      'amount': '45.00',
      'category': category,
      'recorded_by': 'user-001',
      'expense_date': '2026-05-01',
    };

Map<String, dynamic> _giftCardJson({String id = 'gc-001', String status = 'active'}) => {
      'id': id,
      'organization_id': 'org-001',
      'code': 'GC-TEST-001',
      'initial_amount': '200.00',
      'balance': '150.00',
      'status': status,
      'issued_by': 'user-001',
      'issued_at_store': 'store-001',
    };

// ─── Tests ────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════
  // listPayments
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listPayments', () {
    test('sends GET to payments endpoint and parses paginated result', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.payments);
        expect(opts.method, 'GET');
        expect(opts.queryParameters['page'], 1);
        return _page([_paymentJson(id: 'pay-001'), _paymentJson(id: 'pay-002')], total: 2);
      }));

      final result = await svc.listPayments();
      expect(result.items.length, 2);
      expect(result.total, 2);
      expect(result.currentPage, 1);
      expect(result.lastPage, 1);
      expect(result.items.first.id, 'pay-001');
      expect(result.items.first.method, PaymentMethodKey.cash);
    });

    test('passes filter params in query string', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters['method'], 'card');
        expect(opts.queryParameters['status'], 'completed');
        expect(opts.queryParameters['start_date'], '2026-05-01');
        expect(opts.queryParameters['end_date'], '2026-05-31');
        expect(opts.queryParameters['search'], 'Ali');
        return _page([]);
      }));

      await svc.listPayments(method: 'card', status: 'completed', startDate: '2026-05-01', endDate: '2026-05-31', search: 'Ali');
    });

    test('hasMore is true when more pages remain', () async {
      final svc = PaymentApiService(_fakeDio((_) {
        return _page([_paymentJson()], total: 50, page: 1, lastPage: 3, perPage: 20);
      }));

      final result = await svc.listPayments();
      expect(result.hasMore, true);
    });

    test('hasMore is false on last page', () async {
      final svc = PaymentApiService(_fakeDio((_) {
        return _page([_paymentJson()], total: 1, page: 1, lastPage: 1, perPage: 20);
      }));

      final result = await svc.listPayments();
      expect(result.hasMore, false);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // createPayment
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.createPayment', () {
    test('sends POST and returns parsed Payment', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.payments);
        return _env(_paymentJson(id: 'pay-new', method: 'card'));
      }));

      final payment = await svc.createPayment({'transaction_id': 'tx-001', 'method': 'card', 'amount': 50.0});
      expect(payment.id, 'pay-new');
      expect(payment.method, PaymentMethodKey.card);
    });

    test('throws DioException on server error', () async {
      final svc = PaymentApiService(_errorDio(statusCode: 422));
      expect(
        () => svc.createPayment({'transaction_id': 'bad', 'method': 'cash', 'amount': 0}),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // listRefunds
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listRefunds', () {
    test('sends GET to refunds endpoint', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.paymentRefunds);
        return _page([_refundJson(id: 'ref-001'), _refundJson(id: 'ref-002')], total: 2);
      }));

      final result = await svc.listRefunds();
      expect(result.items.length, 2);
      expect(result.items.first.status, RefundStatus.completed);
    });

    test('passes status and method filters', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters['status'], 'pending');
        expect(opts.queryParameters['method'], 'card');
        return _page([]);
      }));
      await svc.listRefunds(status: 'pending', method: 'card');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // listPaymentRefunds
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listPaymentRefunds', () {
    test('sends GET to payment-specific refunds endpoint', () async {
      const paymentId = 'pay-123';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.paymentRefundsById(paymentId));
        return _page([_refundJson()]);
      }));

      final result = await svc.listPaymentRefunds(paymentId);
      expect(result.items, hasLength(1));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // createRefund
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.createRefund', () {
    test('sends POST to correct refund endpoint and returns Refund', () async {
      const paymentId = 'pay-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.paymentRefund(paymentId));
        return _env(_refundJson(id: 'ref-new', status: 'completed'));
      }));

      final refund = await svc.createRefund(paymentId, {'amount': 25.0});
      expect(refund.id, 'ref-new');
      expect(refund.method, PaymentMethodKey.cash);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Cash Sessions
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listCashSessions', () {
    test('parses paginated cash sessions', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.cashSessions);
        return _page([_cashSessionJson(id: 'cs-001'), _cashSessionJson(id: 'cs-002')], total: 2);
      }));

      final result = await svc.listCashSessions();
      expect(result.items.length, 2);
      expect(result.items.first.id, 'cs-001');
      expect(result.items.first.openingFloat, 300.0);
    });
  });

  group('PaymentApiService.openCashSession', () {
    test('sends POST and returns new CashSession', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.cashSessions);
        return _env(_cashSessionJson(id: 'cs-new'));
      }));

      final session = await svc.openCashSession({'opening_float': 300.0});
      expect(session.id, 'cs-new');
      expect(session.openingFloat, 300.0);
    });
  });

  group('PaymentApiService.getCashSession', () {
    test('sends GET to session-by-id endpoint', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, '${ApiEndpoints.cashSessions}/cs-001');
        return _env(_cashSessionJson(id: 'cs-001', status: 'closed'));
      }));

      final session = await svc.getCashSession('cs-001');
      expect(session.id, 'cs-001');
    });
  });

  group('PaymentApiService.closeCashSession', () {
    test('sends PUT to close endpoint and returns updated session', () async {
      const id = 'cs-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'PUT');
        expect(opts.path, ApiEndpoints.cashSessionClose(id));
        final closedJson = Map<String, dynamic>.from(_cashSessionJson(id: id))
          ..['status'] = 'closed'
          ..['actual_cash'] = '295.00'
          ..['variance'] = '-5.00';
        return _env(closedJson);
      }));

      final session = await svc.closeCashSession(id, {'actual_cash': 295.0});
      expect(session.actualCash, 295.0);
      expect(session.variance, -5.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Cash Events
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.createCashEvent', () {
    test('sends POST to cash-events endpoint', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.cashEvents);
        return _env(_cashEventJson(id: 'ce-new', type: 'cash_out'));
      }));

      final event = await svc.createCashEvent({'cash_session_id': 'cs-001', 'type': 'cash_out', 'amount': 50.0});
      expect(event.id, 'ce-new');
      expect(event.type, CashEventType.cashOut);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Expenses
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listExpenses', () {
    test('parses paginated expenses', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.expenses);
        return _page([_expenseJson(id: 'exp-001', category: 'maintenance')], total: 1);
      }));

      final result = await svc.listExpenses();
      expect(result.items.length, 1);
      expect(result.items.first.category, ExpenseCategory.maintenance);
    });

    test('passes category filter', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters['category'], 'supplies');
        return _page([]);
      }));
      await svc.listExpenses(category: 'supplies');
    });
  });

  group('PaymentApiService.createExpense', () {
    test('sends POST and returns Expense', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.expenses);
        return _env(_expenseJson(id: 'exp-new', category: 'food'));
      }));

      final expense = await svc.createExpense({'amount': 45.0, 'category': 'food', 'expense_date': '2026-05-01'});
      expect(expense.id, 'exp-new');
      expect(expense.category, ExpenseCategory.food);
    });
  });

  group('PaymentApiService.updateExpense', () {
    test('sends PUT to expense-by-id endpoint', () async {
      const id = 'exp-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'PUT');
        expect(opts.path, ApiEndpoints.expenseById(id));
        return _env(Map<String, dynamic>.from(_expenseJson(id: id))..['amount'] = '60.00');
      }));

      final expense = await svc.updateExpense(id, {'amount': 60.0});
      expect(expense.amount, 60.0);
    });
  });

  group('PaymentApiService.deleteExpense', () {
    test('sends DELETE to expense-by-id endpoint', () async {
      const id = 'exp-001';
      bool called = false;
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'DELETE');
        expect(opts.path, ApiEndpoints.expenseById(id));
        called = true;
        return {'success': true, 'message': 'Deleted', 'data': null};
      }));

      await svc.deleteExpense(id);
      expect(called, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Gift Cards
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.listGiftCards', () {
    test('parses paginated gift cards', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.giftCards);
        return _page([_giftCardJson(id: 'gc-001'), _giftCardJson(id: 'gc-002')], total: 2);
      }));

      final result = await svc.listGiftCards();
      expect(result.items.length, 2);
      expect(result.items.first.status, GiftCardStatus.active);
    });

    test('passes status filter', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters['status'], 'deactivated');
        return _page([]);
      }));
      await svc.listGiftCards(status: 'deactivated');
    });
  });

  group('PaymentApiService.issueGiftCard', () {
    test('sends POST and returns new GiftCard', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.giftCards);
        return _env(_giftCardJson(id: 'gc-new'));
      }));

      final card = await svc.issueGiftCard({'amount': 200.0});
      expect(card.id, 'gc-new');
      expect(card.initialAmount, 200.0);
    });
  });

  group('PaymentApiService.checkGiftCardBalance', () {
    test('returns raw balance map from server', () async {
      const code = 'GC-TEST-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.giftCardBalance(code));
        return _env({'code': code, 'balance': '150.00', 'status': 'active'});
      }));

      final result = await svc.checkGiftCardBalance(code);
      expect(result['balance'], '150.00');
      expect(result['status'], 'active');
    });
  });

  group('PaymentApiService.redeemGiftCard', () {
    test('sends POST with amount and returns updated GiftCard', () async {
      const code = 'GC-TEST-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'POST');
        expect(opts.path, ApiEndpoints.giftCardRedeem(code));
        final data = opts.data as Map<String, dynamic>;
        expect(data['amount'], 50.0);
        final updated = Map<String, dynamic>.from(_giftCardJson())..['balance'] = '100.00';
        return _env(updated);
      }));

      final card = await svc.redeemGiftCard(code, 50.0);
      expect(card.balance, 100.0);
    });
  });

  group('PaymentApiService.deactivateGiftCard', () {
    test('sends PUT to deactivate endpoint', () async {
      const code = 'GC-TEST-001';
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.method, 'PUT');
        expect(opts.path, ApiEndpoints.giftCardDeactivate(code));
        final deactivated = Map<String, dynamic>.from(_giftCardJson())..['status'] = 'deactivated';
        return _env(deactivated);
      }));

      final card = await svc.deactivateGiftCard(code);
      expect(card.status, GiftCardStatus.deactivated);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Financial Reports
  // ═══════════════════════════════════════════════════════════════

  group('PaymentApiService.dailySummary', () {
    test('sends GET to daily-summary endpoint with date', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financeDailySummary);
        expect(opts.queryParameters['date'], '2026-05-01');
        return _env({
          'revenue': {'gross': 500.0, 'refunds': 50.0, 'expenses': 30.0, 'net': 420.0},
          'transactions': {'count': 10},
          'hourly_activity': List.generate(24, (i) => {'hour': i, 'total': 0.0}),
        });
      }));

      final result = await svc.dailySummary(date: '2026-05-01');
      expect(result['revenue']['gross'], 500.0);
      expect((result['hourly_activity'] as List).length, 24);
    });

    test('sends GET without date param when null', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters.containsKey('date'), false);
        return _env({'revenue': {'gross': 0.0, 'refunds': 0.0, 'expenses': 0.0, 'net': 0.0}, 'transactions': {'count': 0}, 'hourly_activity': []});
      }));

      await svc.dailySummary();
    });
  });

  group('PaymentApiService.reconciliation', () {
    test('sends GET with start and end dates', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.path, ApiEndpoints.financeReconciliation);
        expect(opts.queryParameters['start_date'], '2026-05-01');
        expect(opts.queryParameters['end_date'], '2026-05-31');
        return _env({
          'summary': {'session_count': 5, 'total_variance': -10.0},
          'sessions': [],
        });
      }));

      final result = await svc.reconciliation(startDate: '2026-05-01', endDate: '2026-05-31');
      expect(result['summary']['session_count'], 5);
    });

    test('sends GET without date params when null', () async {
      final svc = PaymentApiService(_fakeDio((opts) {
        expect(opts.queryParameters.containsKey('start_date'), false);
        expect(opts.queryParameters.containsKey('end_date'), false);
        return _env({'summary': {}, 'sessions': []});
      }));

      await svc.reconciliation();
    });

    test('throws DioException on 401 unauthorized', () async {
      final svc = PaymentApiService(_errorDio(statusCode: 401));
      expect(() => svc.reconciliation(), throwsA(isA<DioException>()));
    });
  });
}
