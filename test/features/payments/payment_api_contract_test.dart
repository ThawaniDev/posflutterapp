// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/payments/enums/cash_event_type.dart';
import 'package:wameedpos/features/payments/enums/expense_category.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/enums/refund_status.dart';
import 'package:wameedpos/features/payments/models/cash_event.dart';
import 'package:wameedpos/features/payments/models/cash_session.dart';
import 'package:wameedpos/features/payments/models/expense.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';
import 'package:wameedpos/features/security/enums/session_status.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Map<String, dynamic> _paymentJson({
  String id = 'pay-001',
  String transactionId = 'txn-001',
  String method = 'cash',
  String amount = '100.50',
  String? cashTendered,
  String? changeGiven,
  String? tipAmount,
  String? cardBrand,
  String? cardLastFour,
  String? cardAuthCode,
  String? cardReference,
  String? giftCardCode,
  String? status,
  String? createdAt,
}) =>
    {
      'id': id,
      'transaction_id': transactionId,
      'method': method,
      'amount': amount,
      'cash_tendered': cashTendered,
      'change_given': changeGiven,
      'tip_amount': tipAmount,
      'card_brand': cardBrand,
      'card_last_four': cardLastFour,
      'card_auth_code': cardAuthCode,
      'card_reference': cardReference,
      'gift_card_code': giftCardCode,
      'status': status,
      'created_at': createdAt ?? '2024-01-15T10:30:00.000000Z',
    };

Map<String, dynamic> _cashEventJson({
  String id = 'evt-001',
  String cashSessionId = 'cs-001',
  String type = 'cash_in',
  String amount = '50.00',
  String reason = 'opening float supplement',
  String? notes,
  String performedBy = 'user-001',
  String? createdAt,
}) =>
    {
      'id': id,
      'cash_session_id': cashSessionId,
      'type': type,
      'amount': amount,
      'reason': reason,
      'notes': notes,
      'performed_by': performedBy,
      'created_at': createdAt ?? '2024-01-15T08:00:00.000000Z',
    };

Map<String, dynamic> _cashSessionJson({
  String id = 'cs-001',
  String storeId = 'store-001',
  String? terminalId = 'term-001',
  String openedBy = 'user-001',
  String? closedBy,
  String openingFloat = '200.00',
  String? expectedCash,
  String? actualCash,
  String? variance,
  String? status = 'open',
  String? openedAt,
  String? closedAt,
  String? closeNotes,
  List<Map<String, dynamic>>? cashEvents,
  List<Map<String, dynamic>>? expenses,
}) =>
    {
      'id': id,
      'store_id': storeId,
      'terminal_id': terminalId,
      'opened_by': openedBy,
      'closed_by': closedBy,
      'opening_float': openingFloat,
      'expected_cash': expectedCash,
      'actual_cash': actualCash,
      'variance': variance,
      'status': status,
      'opened_at': openedAt ?? '2024-01-15T08:00:00.000000Z',
      'closed_at': closedAt,
      'close_notes': closeNotes,
      'cash_events': cashEvents,
      'expenses': expenses,
    };

Map<String, dynamic> _expenseJson({
  String id = 'exp-001',
  String storeId = 'store-001',
  String? cashSessionId,
  String amount = '75.00',
  String category = 'supplies',
  String? description,
  String recordedBy = 'user-001',
  String expenseDate = '2024-01-15',
  String? createdAt,
}) =>
    {
      'id': id,
      'store_id': storeId,
      'cash_session_id': cashSessionId,
      'amount': amount,
      'category': category,
      'description': description,
      'receipt_image_url': null,
      'recorded_by': recordedBy,
      'expense_date': expenseDate,
      'created_at': createdAt ?? '2024-01-15T09:00:00.000000Z',
      'updated_at': createdAt ?? '2024-01-15T09:00:00.000000Z',
    };

Map<String, dynamic> _giftCardJson({
  String id = 'gc-001',
  String organizationId = 'org-001',
  String code = 'GC-ABCD-1234',
  String? barcode,
  String initialAmount = '100.00',
  String balance = '75.00',
  String? recipientName,
  String status = 'active',
  String issuedBy = 'user-001',
  String issuedAtStore = 'store-001',
  String? expiresAt,
  String? createdAt,
}) =>
    {
      'id': id,
      'organization_id': organizationId,
      'code': code,
      'barcode': barcode,
      'initial_amount': initialAmount,
      'balance': balance,
      'recipient_name': recipientName,
      'status': status,
      'issued_by': issuedBy,
      'issued_at_store': issuedAtStore,
      'expires_at': expiresAt,
      'created_at': createdAt ?? '2024-01-10T12:00:00.000000Z',
    };

Map<String, dynamic> _refundJson({
  String id = 'ref-001',
  String returnId = 'ret-001',
  String? paymentId = 'pay-001',
  String method = 'cash',
  String amount = '40.00',
  String? referenceNumber,
  String status = 'completed',
  String processedBy = 'user-001',
  String? createdAt,
}) =>
    {
      'id': id,
      'return_id': returnId,
      'payment_id': paymentId,
      'method': method,
      'amount': amount,
      'reference_number': referenceNumber,
      'status': status,
      'processed_by': processedBy,
      'created_at': createdAt ?? '2024-01-15T11:00:00.000000Z',
    };

Map<String, dynamic> _paginatedResponse(List<Map<String, dynamic>> items) => {
      'success': true,
      'message': 'OK',
      'data': {
        'data': items,
        'total': items.length,
        'current_page': 1,
        'last_page': 1,
        'per_page': 20,
      },
    };

Map<String, dynamic> _singleResponse(Map<String, dynamic> item) => {
      'success': true,
      'message': 'OK',
      'data': item,
    };

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  // API ENDPOINT CONSTANTS
  // ═══════════════════════════════════════════════════════════════════════════

  group('ApiEndpoints — payment routes', () {
    test('payments constant is correct', () {
      expect(ApiEndpoints.payments, '/payments');
    });

    test('paymentRefunds constant is correct', () {
      expect(ApiEndpoints.paymentRefunds, '/payments/refunds');
    });

    test('paymentRefundsById generates correct path', () {
      expect(ApiEndpoints.paymentRefundsById('abc-123'), '/payments/abc-123/refunds');
    });

    test('paymentRefund (singular) generates correct path', () {
      expect(ApiEndpoints.paymentRefund('abc-123'), '/payments/abc-123/refund');
    });

    test('cashSessions constant is correct', () {
      expect(ApiEndpoints.cashSessions, '/cash-sessions');
    });

    test('cashEvents constant is correct', () {
      expect(ApiEndpoints.cashEvents, '/cash-events');
    });

    test('cashSessionClose generates correct path', () {
      expect(ApiEndpoints.cashSessionClose('sess-42'), '/cash-sessions/sess-42/close');
    });

    test('expenses constant is correct', () {
      expect(ApiEndpoints.expenses, '/expenses');
    });

    test('expenseById generates correct path', () {
      expect(ApiEndpoints.expenseById('exp-99'), '/expenses/exp-99');
    });

    test('giftCards constant is correct', () {
      expect(ApiEndpoints.giftCards, '/gift-cards');
    });

    test('giftCardBalance generates correct path', () {
      expect(ApiEndpoints.giftCardBalance('GC-ABCD-1234'), '/gift-cards/GC-ABCD-1234/balance');
    });

    test('giftCardRedeem generates correct path', () {
      expect(ApiEndpoints.giftCardRedeem('GC-ABCD-1234'), '/gift-cards/GC-ABCD-1234/redeem');
    });

    test('giftCardDeactivate uses PUT path', () {
      expect(ApiEndpoints.giftCardDeactivate('GC-ABCD-1234'), '/gift-cards/GC-ABCD-1234/deactivate');
    });

    test('financeDailySummary constant is correct', () {
      expect(ApiEndpoints.financeDailySummary, '/finance/daily-summary');
    });

    test('financeReconciliation constant is correct', () {
      expect(ApiEndpoints.financeReconciliation, '/finance/reconciliation');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Payment.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('Payment.fromJson', () {
    test('parses required fields', () {
      final p = Payment.fromJson(_paymentJson());
      expect(p.id, 'pay-001');
      expect(p.transactionId, 'txn-001');
      expect(p.method, PaymentMethodKey.cash);
      expect(p.amount, 100.50);
      expect(p.createdAt, isNotNull);
    });

    test('parses card payment fields', () {
      final p = Payment.fromJson(_paymentJson(
        method: 'card_mada',
        cardBrand: 'mada',
        cardLastFour: '1234',
        cardAuthCode: 'AUTH9999',
        cardReference: 'REF-ABC',
      ));
      expect(p.method, PaymentMethodKey.cardMada);
      expect(p.cardBrand, 'mada');
      expect(p.cardLastFour, '1234');
      expect(p.cardAuthCode, 'AUTH9999');
      expect(p.cardReference, 'REF-ABC');
    });

    test('parses cash payment with change', () {
      final p = Payment.fromJson(_paymentJson(
        cashTendered: '150.00',
        changeGiven: '49.50',
      ));
      expect(p.cashTendered, 150.00);
      expect(p.changeGiven, 49.50);
    });

    test('parses gift card payment', () {
      final p = Payment.fromJson(_paymentJson(
        method: 'gift_card',
        giftCardCode: 'GC-XYZW-9999',
      ));
      expect(p.method, PaymentMethodKey.giftCard);
      expect(p.giftCardCode, 'GC-XYZW-9999');
    });

    test('nullable fields default to null when absent', () {
      final p = Payment.fromJson(_paymentJson());
      expect(p.cashTendered, isNull);
      expect(p.changeGiven, isNull);
      expect(p.tipAmount, isNull);
      expect(p.cardBrand, isNull);
      expect(p.giftCardCode, isNull);
      expect(p.loyaltyPointsUsed, isNull);
      expect(p.nearpayTransactionId, isNull);
      expect(p.syncVersion, isNull);
    });

    test('parses numeric amount from string', () {
      final p = Payment.fromJson(_paymentJson(amount: '250.75'));
      expect(p.amount, 250.75);
    });

    test('parses numeric amount from int', () {
      final json = _paymentJson();
      json['amount'] = 99;
      final p = Payment.fromJson(json);
      expect(p.amount, 99.0);
    });

    test('parses createdAt as DateTime', () {
      final p = Payment.fromJson(_paymentJson(createdAt: '2024-06-01T14:30:00.000000Z'));
      expect(p.createdAt, DateTime.parse('2024-06-01T14:30:00.000000Z'));
    });

    test('unknown method falls back to other', () {
      final p = Payment.fromJson(_paymentJson(method: 'crypto_unknown'));
      expect(p.method, PaymentMethodKey.other);
    });

    test('toJson round-trips', () {
      final p = Payment.fromJson(_paymentJson(
        cashTendered: '200.00',
        changeGiven: '99.50',
        cardBrand: 'visa',
      ));
      final json = p.toJson();
      expect(json['id'], p.id);
      expect(json['transaction_id'], p.transactionId);
      expect(json['method'], 'cash');
      expect(json['amount'], 100.50);
      expect(json['cash_tendered'], 200.00);
      expect(json['change_given'], 99.50);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CashEvent.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('CashEvent.fromJson', () {
    test('parses cash_in event', () {
      final e = CashEvent.fromJson(_cashEventJson(type: 'cash_in', amount: '100.00'));
      expect(e.type, CashEventType.cashIn);
      expect(e.amount, 100.00);
      expect(e.cashSessionId, 'cs-001');
      expect(e.performedBy, 'user-001');
    });

    test('parses cash_out event', () {
      final e = CashEvent.fromJson(_cashEventJson(type: 'cash_out', amount: '25.00'));
      expect(e.type, CashEventType.cashOut);
      expect(e.amount, 25.00);
    });

    test('notes is nullable', () {
      final e = CashEvent.fromJson(_cashEventJson());
      expect(e.notes, isNull);
    });

    test('notes is parsed when present', () {
      final e = CashEvent.fromJson(_cashEventJson(notes: 'Till change'));
      expect(e.notes, 'Till change');
    });

    test('parses createdAt', () {
      final e = CashEvent.fromJson(_cashEventJson(createdAt: '2024-01-15T08:00:00.000000Z'));
      expect(e.createdAt, DateTime.parse('2024-01-15T08:00:00.000000Z'));
    });

    test('toJson round-trips type value', () {
      final e = CashEvent.fromJson(_cashEventJson(type: 'cash_out'));
      expect(e.toJson()['type'], 'cash_out');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CashSession.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('CashSession.fromJson', () {
    test('parses open session', () {
      final s = CashSession.fromJson(_cashSessionJson());
      expect(s.id, 'cs-001');
      expect(s.storeId, 'store-001');
      expect(s.terminalId, 'term-001');
      expect(s.openedBy, 'user-001');
      expect(s.openingFloat, 200.00);
      expect(s.status, SessionStatus.open);
      expect(s.closedBy, isNull);
      expect(s.closedAt, isNull);
    });

    test('parses closed session with variance', () {
      final s = CashSession.fromJson(_cashSessionJson(
        status: 'closed',
        closedBy: 'user-002',
        expectedCash: '350.00',
        actualCash: '345.00',
        variance: '-5.00',
        closedAt: '2024-01-15T18:00:00.000000Z',
        closeNotes: 'Slight variance on drawer 3',
      ));
      expect(s.status, SessionStatus.closed);
      expect(s.closedBy, 'user-002');
      expect(s.expectedCash, 350.00);
      expect(s.actualCash, 345.00);
      expect(s.variance, -5.00);
      expect(s.closeNotes, 'Slight variance on drawer 3');
      expect(s.closedAt, isNotNull);
    });

    test('parses embedded cash_events list', () {
      final s = CashSession.fromJson(_cashSessionJson(
        cashEvents: [_cashEventJson(type: 'cash_in'), _cashEventJson(id: 'evt-002', type: 'cash_out')],
      ));
      expect(s.cashEvents, hasLength(2));
      expect(s.cashEvents![0].type, CashEventType.cashIn);
      expect(s.cashEvents![1].type, CashEventType.cashOut);
    });

    test('parses embedded expenses list', () {
      final s = CashSession.fromJson(_cashSessionJson(
        expenses: [_expenseJson(cashSessionId: 'cs-001')],
      ));
      expect(s.expenses, hasLength(1));
      expect(s.expenses![0].category, ExpenseCategory.supplies);
    });

    test('null cash_events is allowed', () {
      final s = CashSession.fromJson(_cashSessionJson(cashEvents: null));
      expect(s.cashEvents, isNull);
    });

    test('null expenses is allowed', () {
      final s = CashSession.fromJson(_cashSessionJson(expenses: null));
      expect(s.expenses, isNull);
    });

    test('terminal_id is nullable', () {
      final json = _cashSessionJson(terminalId: null);
      json['terminal_id'] = null;
      final s = CashSession.fromJson(json);
      expect(s.terminalId, isNull);
    });

    test('toJson includes all scalar fields', () {
      final s = CashSession.fromJson(_cashSessionJson());
      final json = s.toJson();
      expect(json['id'], 'cs-001');
      expect(json['store_id'], 'store-001');
      expect(json['opening_float'], 200.00);
      expect(json['status'], 'open');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Expense.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('Expense.fromJson', () {
    test('parses required fields', () {
      final e = Expense.fromJson(_expenseJson());
      expect(e.id, 'exp-001');
      expect(e.storeId, 'store-001');
      expect(e.amount, 75.00);
      expect(e.category, ExpenseCategory.supplies);
      expect(e.recordedBy, 'user-001');
      expect(e.expenseDate.year, 2024);
      expect(e.expenseDate.month, 1);
      expect(e.expenseDate.day, 15);
    });

    test('parses each expense category', () {
      final categories = [
        'supplies', 'food', 'transport', 'maintenance', 'utility',
        'cleaning', 'rent', 'salary', 'marketing', 'other',
      ];
      for (final cat in categories) {
        final e = Expense.fromJson(_expenseJson(category: cat));
        expect(e.category.value, cat, reason: 'category $cat must parse correctly');
      }
    });

    test('cashSessionId is nullable', () {
      final e = Expense.fromJson(_expenseJson());
      expect(e.cashSessionId, isNull);
    });

    test('cashSessionId parsed when present', () {
      final e = Expense.fromJson(_expenseJson(cashSessionId: 'cs-001'));
      expect(e.cashSessionId, 'cs-001');
    });

    test('description is nullable', () {
      final e = Expense.fromJson(_expenseJson());
      expect(e.description, isNull);
    });

    test('description parsed when present', () {
      final e = Expense.fromJson(_expenseJson(description: 'Office supplies for front desk'));
      expect(e.description, 'Office supplies for front desk');
    });

    test('toJson expense_date is date-only string', () {
      final e = Expense.fromJson(_expenseJson(expenseDate: '2024-03-20'));
      expect(e.toJson()['expense_date'], '2024-03-20');
    });

    test('equality based on id', () {
      final e1 = Expense.fromJson(_expenseJson(id: 'exp-1'));
      final e2 = Expense.fromJson(_expenseJson(id: 'exp-1', amount: '999.00'));
      final e3 = Expense.fromJson(_expenseJson(id: 'exp-2'));
      expect(e1, e2);
      expect(e1, isNot(e3));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GiftCard.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('GiftCard.fromJson', () {
    test('parses active gift card', () {
      final g = GiftCard.fromJson(_giftCardJson());
      expect(g.id, 'gc-001');
      expect(g.code, 'GC-ABCD-1234');
      expect(g.initialAmount, 100.00);
      expect(g.balance, 75.00);
      expect(g.status, GiftCardStatus.active);
      expect(g.issuedBy, 'user-001');
      expect(g.issuedAtStore, 'store-001');
    });

    test('parses each gift card status', () {
      for (final status in ['active', 'redeemed', 'expired', 'deactivated']) {
        final g = GiftCard.fromJson(_giftCardJson(status: status));
        expect(g.status?.value, status, reason: 'status $status must parse correctly');
      }
    });

    test('expiresAt is nullable', () {
      final g = GiftCard.fromJson(_giftCardJson());
      expect(g.expiresAt, isNull);
    });

    test('expiresAt parsed when present', () {
      final g = GiftCard.fromJson(_giftCardJson(expiresAt: '2025-12-31T23:59:59.000000Z'));
      expect(g.expiresAt, isNotNull);
      expect(g.expiresAt!.year, 2025);
    });

    test('barcode is nullable', () {
      final g = GiftCard.fromJson(_giftCardJson());
      expect(g.barcode, isNull);
    });

    test('recipientName is nullable', () {
      final g = GiftCard.fromJson(_giftCardJson());
      expect(g.recipientName, isNull);
    });

    test('recipientName parsed when present', () {
      final g = GiftCard.fromJson(_giftCardJson(recipientName: 'Alice Smith'));
      expect(g.recipientName, 'Alice Smith');
    });

    test('equality based on id', () {
      final g1 = GiftCard.fromJson(_giftCardJson(id: 'gc-1'));
      final g2 = GiftCard.fromJson(_giftCardJson(id: 'gc-1', balance: '0.00'));
      expect(g1, g2);
    });

    test('toJson includes status value', () {
      final g = GiftCard.fromJson(_giftCardJson(status: 'deactivated'));
      expect(g.toJson()['status'], 'deactivated');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Refund.fromJson
  // ═══════════════════════════════════════════════════════════════════════════

  group('Refund.fromJson', () {
    test('parses completed refund', () {
      final r = Refund.fromJson(_refundJson());
      expect(r.id, 'ref-001');
      expect(r.returnId, 'ret-001');
      expect(r.paymentId, 'pay-001');
      expect(r.method, PaymentMethodKey.cash);
      expect(r.amount, 40.00);
      expect(r.status, RefundStatus.completed);
      expect(r.processedBy, 'user-001');
    });

    test('parses each refund status', () {
      for (final status in ['completed', 'pending', 'failed']) {
        final r = Refund.fromJson(_refundJson(status: status));
        expect(r.status?.value, status);
      }
    });

    test('paymentId is nullable', () {
      final json = _refundJson();
      json['payment_id'] = null;
      final r = Refund.fromJson(json);
      expect(r.paymentId, isNull);
    });

    test('referenceNumber is nullable', () {
      final r = Refund.fromJson(_refundJson());
      expect(r.referenceNumber, isNull);
    });

    test('referenceNumber parsed when present', () {
      final r = Refund.fromJson(_refundJson(referenceNumber: 'REF-2024-001'));
      expect(r.referenceNumber, 'REF-2024-001');
    });

    test('parses card method', () {
      final r = Refund.fromJson(_refundJson(method: 'card_mada'));
      expect(r.method, PaymentMethodKey.cardMada);
    });

    test('toJson includes method value', () {
      final r = Refund.fromJson(_refundJson(method: 'card_visa'));
      expect(r.toJson()['method'], 'card_visa');
    });

    test('equality based on id', () {
      final r1 = Refund.fromJson(_refundJson(id: 'ref-1'));
      final r2 = Refund.fromJson(_refundJson(id: 'ref-1', amount: '999.00'));
      expect(r1, r2);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ApiResponse wrapper
  // ═══════════════════════════════════════════════════════════════════════════

  group('ApiResponse.fromJson', () {
    test('parses success response', () {
      final response = ApiResponse.fromJson(_singleResponse(_paymentJson()), (d) => d);
      expect(response.success, true);
      expect(response.message, 'OK');
      expect(response.data, isNotNull);
    });

    test('parses error response with message', () {
      final response = ApiResponse.fromJson({
        'success': false,
        'message': 'Validation failed',
        'errors': {'amount': ['The amount field is required.']},
      }, (d) => d);
      expect(response.success, false);
      expect(response.message, 'Validation failed');
      expect(response.errors, isNotNull);
      expect(response.errors!['amount'], contains('The amount field is required.'));
    });

    test('dataList extracts paginated data array', () {
      final response = ApiResponse.fromJson(_paginatedResponse([_paymentJson(), _paymentJson(id: 'pay-002')]), (d) => d);
      expect(response.dataList, hasLength(2));
    });

    test('dataList on plain list response', () {
      final response = ApiResponse.fromJson({
        'success': true,
        'message': 'OK',
        'data': [_paymentJson()],
      }, (d) => d);
      expect(response.dataList, hasLength(1));
    });

    test('handles null data gracefully', () {
      final response = ApiResponse.fromJson({'success': true, 'message': 'OK'}, (d) => d);
      expect(response.data, isNull);
      expect(response.dataList, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PaginatedResult
  // ═══════════════════════════════════════════════════════════════════════════

  group('PaginatedResult', () {
    test('holds items and pagination meta', () {
      final payments = [Payment.fromJson(_paymentJson()), Payment.fromJson(_paymentJson(id: 'pay-002'))];
      final result = PaginatedResult(items: payments, total: 50, currentPage: 1, lastPage: 3, perPage: 20);
      expect(result.items, hasLength(2));
      expect(result.total, 50);
      expect(result.currentPage, 1);
      expect(result.lastPage, 3);
      expect(result.perPage, 20);
    });

    test('can hold GiftCard items', () {
      final cards = [GiftCard.fromJson(_giftCardJson()), GiftCard.fromJson(_giftCardJson(id: 'gc-002'))];
      final result = PaginatedResult(items: cards, total: 2, currentPage: 1, lastPage: 1, perPage: 20);
      expect(result.items, hasLength(2));
    });

    test('can hold CashSession items', () {
      final sessions = [CashSession.fromJson(_cashSessionJson())];
      final result = PaginatedResult(items: sessions, total: 1, currentPage: 1, lastPage: 1, perPage: 20);
      expect(result.items, hasLength(1));
    });

    test('can hold Expense items', () {
      final expenses = [Expense.fromJson(_expenseJson())];
      final result = PaginatedResult(items: expenses, total: 1, currentPage: 1, lastPage: 1, perPage: 20);
      expect(result.items, hasLength(1));
    });

    test('can hold Refund items', () {
      final refunds = [Refund.fromJson(_refundJson())];
      final result = PaginatedResult(items: refunds, total: 1, currentPage: 1, lastPage: 1, perPage: 20);
      expect(result.items, hasLength(1));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // PaymentMethodKey enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('PaymentMethodKey', () {
    test('all values have correct string values', () {
      expect(PaymentMethodKey.cash.value, 'cash');
      expect(PaymentMethodKey.card.value, 'card');
      expect(PaymentMethodKey.cardMada.value, 'card_mada');
      expect(PaymentMethodKey.cardVisa.value, 'card_visa');
      expect(PaymentMethodKey.cardMastercard.value, 'card_mastercard');
      expect(PaymentMethodKey.mada.value, 'mada');
      expect(PaymentMethodKey.applePay.value, 'apple_pay');
      expect(PaymentMethodKey.stcPay.value, 'stc_pay');
      expect(PaymentMethodKey.giftCard.value, 'gift_card');
      expect(PaymentMethodKey.storeCredit.value, 'store_credit');
      expect(PaymentMethodKey.loyaltyPoints.value, 'loyalty_points');
      expect(PaymentMethodKey.bankTransfer.value, 'bank_transfer');
      expect(PaymentMethodKey.tabby.value, 'tabby');
      expect(PaymentMethodKey.tamara.value, 'tamara');
      expect(PaymentMethodKey.other.value, 'other');
    });

    test('fromValue parses known values', () {
      expect(PaymentMethodKey.fromValue('cash'), PaymentMethodKey.cash);
      expect(PaymentMethodKey.fromValue('card_mada'), PaymentMethodKey.cardMada);
      expect(PaymentMethodKey.fromValue('gift_card'), PaymentMethodKey.giftCard);
      expect(PaymentMethodKey.fromValue('apple_pay'), PaymentMethodKey.applePay);
    });

    test('fromValue falls back to other for unknown', () {
      expect(PaymentMethodKey.fromValue('unknown_method'), PaymentMethodKey.other);
      expect(PaymentMethodKey.fromValue(''), PaymentMethodKey.other);
    });

    test('tryFromValue returns null for null input', () {
      expect(PaymentMethodKey.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown value', () {
      expect(PaymentMethodKey.tryFromValue('mystery_pay'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // ExpenseCategory enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('ExpenseCategory', () {
    test('fromValue parses all values', () {
      final values = ['supplies', 'food', 'transport', 'maintenance', 'utility', 'cleaning', 'rent', 'salary', 'marketing', 'other'];
      for (final v in values) {
        expect(ExpenseCategory.fromValue(v).value, v);
      }
    });

    test('fromValue throws on unknown value', () {
      expect(() => ExpenseCategory.fromValue('luxury'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(ExpenseCategory.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown', () {
      expect(ExpenseCategory.tryFromValue('invalid'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // GiftCardStatus enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('GiftCardStatus', () {
    test('fromValue parses all statuses', () {
      expect(GiftCardStatus.fromValue('active'), GiftCardStatus.active);
      expect(GiftCardStatus.fromValue('redeemed'), GiftCardStatus.redeemed);
      expect(GiftCardStatus.fromValue('expired'), GiftCardStatus.expired);
      expect(GiftCardStatus.fromValue('deactivated'), GiftCardStatus.deactivated);
    });

    test('fromValue throws on unknown', () {
      expect(() => GiftCardStatus.fromValue('unknown'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(GiftCardStatus.tryFromValue(null), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // RefundStatus enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('RefundStatus', () {
    test('fromValue parses all statuses', () {
      expect(RefundStatus.fromValue('completed'), RefundStatus.completed);
      expect(RefundStatus.fromValue('pending'), RefundStatus.pending);
      expect(RefundStatus.fromValue('failed'), RefundStatus.failed);
    });

    test('fromValue throws on unknown', () {
      expect(() => RefundStatus.fromValue('unknown'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(RefundStatus.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown', () {
      expect(RefundStatus.tryFromValue('invalid'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // CashEventType enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('CashEventType', () {
    test('fromValue parses cash_in', () {
      expect(CashEventType.fromValue('cash_in'), CashEventType.cashIn);
    });

    test('fromValue parses cash_out', () {
      expect(CashEventType.fromValue('cash_out'), CashEventType.cashOut);
    });

    test('fromValue throws on unknown', () {
      expect(() => CashEventType.fromValue('unknown'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(CashEventType.tryFromValue(null), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // SessionStatus enum
  // ═══════════════════════════════════════════════════════════════════════════

  group('SessionStatus', () {
    test('fromValue parses all statuses', () {
      expect(SessionStatus.fromValue('active'), SessionStatus.active);
      expect(SessionStatus.fromValue('closed'), SessionStatus.closed);
      expect(SessionStatus.fromValue('open'), SessionStatus.open);
      expect(SessionStatus.fromValue('expired'), SessionStatus.expired);
      expect(SessionStatus.fromValue('revoked'), SessionStatus.revoked);
    });

    test('isActive is true for active and open', () {
      expect(SessionStatus.active.isActive, isTrue);
      expect(SessionStatus.open.isActive, isTrue);
      expect(SessionStatus.closed.isActive, isFalse);
      expect(SessionStatus.expired.isActive, isFalse);
      expect(SessionStatus.revoked.isActive, isFalse);
    });

    test('tryFromValue returns null for null', () {
      expect(SessionStatus.tryFromValue(null), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // Full API response simulation (end-to-end deserialization)
  // ═══════════════════════════════════════════════════════════════════════════

  group('Full response deserialization', () {
    test('paginated payments response parses correctly', () {
      final rawResponse = _paginatedResponse([
        _paymentJson(id: 'p1', method: 'cash', amount: '100.00'),
        _paymentJson(id: 'p2', method: 'card_mada', amount: '200.00', cardLastFour: '5678'),
        _paymentJson(id: 'p3', method: 'gift_card', giftCardCode: 'GC-1234'),
      ]);
      final apiResponse = ApiResponse.fromJson(rawResponse, (data) => data);
      final map = apiResponse.data as Map<String, dynamic>;
      final payments = (map['data'] as List).map((j) => Payment.fromJson(j as Map<String, dynamic>)).toList();

      expect(payments, hasLength(3));
      expect(payments[0].method, PaymentMethodKey.cash);
      expect(payments[1].method, PaymentMethodKey.cardMada);
      expect(payments[1].cardLastFour, '5678');
      expect(payments[2].giftCardCode, 'GC-1234');
    });

    test('single payment response parses correctly', () {
      final rawResponse = _singleResponse(_paymentJson(id: 'pay-new', amount: '350.00'));
      final apiResponse = ApiResponse.fromJson(rawResponse, (data) => data);
      final payment = Payment.fromJson(apiResponse.data as Map<String, dynamic>);

      expect(payment.id, 'pay-new');
      expect(payment.amount, 350.00);
    });

    test('cash session with nested events and expenses', () {
      final rawResponse = _singleResponse(_cashSessionJson(
        id: 'cs-full',
        status: 'closed',
        expectedCash: '500.00',
        actualCash: '498.00',
        variance: '-2.00',
        cashEvents: [
          _cashEventJson(type: 'cash_in', amount: '100.00'),
          _cashEventJson(id: 'evt-2', type: 'cash_out', amount: '30.00'),
        ],
        expenses: [
          _expenseJson(amount: '45.00', category: 'food'),
          _expenseJson(id: 'exp-002', amount: '20.00', category: 'transport'),
        ],
      ));
      final session = CashSession.fromJson(rawResponse['data'] as Map<String, dynamic>);

      expect(session.status, SessionStatus.closed);
      expect(session.variance, -2.00);
      expect(session.cashEvents, hasLength(2));
      expect(session.expenses, hasLength(2));
      expect(session.expenses![0].category, ExpenseCategory.food);
      expect(session.expenses![1].category, ExpenseCategory.transport);
    });

    test('paginated gift cards response parses correctly', () {
      final rawResponse = _paginatedResponse([
        _giftCardJson(id: 'gc-1', status: 'active', balance: '100.00'),
        _giftCardJson(id: 'gc-2', status: 'redeemed', balance: '0.00'),
        _giftCardJson(id: 'gc-3', status: 'deactivated', balance: '50.00'),
      ]);
      final apiResponse = ApiResponse.fromJson(rawResponse, (data) => data);
      final map = apiResponse.data as Map<String, dynamic>;
      final cards = (map['data'] as List).map((j) => GiftCard.fromJson(j as Map<String, dynamic>)).toList();

      expect(cards, hasLength(3));
      expect(cards[0].status, GiftCardStatus.active);
      expect(cards[1].status, GiftCardStatus.redeemed);
      expect(cards[2].status, GiftCardStatus.deactivated);
    });

    test('paginated refunds response parses correctly', () {
      final rawResponse = _paginatedResponse([
        _refundJson(id: 'r1', amount: '40.00', method: 'cash'),
        _refundJson(id: 'r2', amount: '80.00', method: 'card_visa', status: 'completed'),
      ]);
      final apiResponse = ApiResponse.fromJson(rawResponse, (data) => data);
      final map = apiResponse.data as Map<String, dynamic>;
      final refunds = (map['data'] as List).map((j) => Refund.fromJson(j as Map<String, dynamic>)).toList();

      expect(refunds, hasLength(2));
      expect(refunds[0].method, PaymentMethodKey.cash);
      expect(refunds[1].method, PaymentMethodKey.cardVisa);
    });

    test('validation error response has correct shape', () {
      final errorResponse = {
        'success': false,
        'message': 'The given data was invalid.',
        'errors': {
          'amount': ['The amount must be at least 0.01.'],
          'method': ['The selected method is invalid.'],
        },
      };
      final apiResponse = ApiResponse.fromJson(errorResponse, (d) => d);
      expect(apiResponse.success, false);
      expect(apiResponse.errors!['amount'], isNotEmpty);
      expect(apiResponse.errors!['method'], isNotEmpty);
    });
  });
}
