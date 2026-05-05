// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
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

void main() {
  // ═══════════════════════════════════════════════════════════════
  // PaymentMethodKey enum
  // ═══════════════════════════════════════════════════════════════

  group('PaymentMethodKey', () {
    test('fromValue maps known values', () {
      expect(PaymentMethodKey.fromValue('cash'), PaymentMethodKey.cash);
      expect(PaymentMethodKey.fromValue('card'), PaymentMethodKey.card);
      expect(PaymentMethodKey.fromValue('apple_pay'), PaymentMethodKey.applePay);
      expect(PaymentMethodKey.fromValue('gift_card'), PaymentMethodKey.giftCard);
      expect(PaymentMethodKey.fromValue('stc_pay'), PaymentMethodKey.stcPay);
      expect(PaymentMethodKey.fromValue('bank_transfer'), PaymentMethodKey.bankTransfer);
    });

    test('fromValue falls back to other for unknown', () {
      expect(PaymentMethodKey.fromValue('unknown_method'), PaymentMethodKey.other);
      expect(PaymentMethodKey.fromValue(''), PaymentMethodKey.other);
    });

    test('tryFromValue returns null for null input', () {
      expect(PaymentMethodKey.tryFromValue(null), isNull);
    });

    test('tryFromValue returns null for unknown value', () {
      expect(PaymentMethodKey.tryFromValue('not_a_method'), isNull);
    });

    test('value property returns the string', () {
      expect(PaymentMethodKey.cash.value, 'cash');
      expect(PaymentMethodKey.cardMada.value, 'card_mada');
      expect(PaymentMethodKey.loyaltyPoints.value, 'loyalty_points');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // RefundStatus enum
  // ═══════════════════════════════════════════════════════════════

  group('RefundStatus', () {
    test('fromValue maps all values', () {
      expect(RefundStatus.fromValue('completed'), RefundStatus.completed);
      expect(RefundStatus.fromValue('pending'), RefundStatus.pending);
      expect(RefundStatus.fromValue('failed'), RefundStatus.failed);
    });

    test('fromValue throws on unknown', () {
      expect(() => RefundStatus.fromValue('unknown'), throwsArgumentError);
    });

    test('tryFromValue returns null for null/unknown', () {
      expect(RefundStatus.tryFromValue(null), isNull);
      expect(RefundStatus.tryFromValue('bad'), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GiftCardStatus enum
  // ═══════════════════════════════════════════════════════════════

  group('GiftCardStatus', () {
    test('fromValue maps all values', () {
      expect(GiftCardStatus.fromValue('active'), GiftCardStatus.active);
      expect(GiftCardStatus.fromValue('redeemed'), GiftCardStatus.redeemed);
      expect(GiftCardStatus.fromValue('expired'), GiftCardStatus.expired);
      expect(GiftCardStatus.fromValue('deactivated'), GiftCardStatus.deactivated);
    });

    test('tryFromValue returns null for null', () {
      expect(GiftCardStatus.tryFromValue(null), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CashEventType enum
  // ═══════════════════════════════════════════════════════════════

  group('CashEventType', () {
    test('fromValue maps both values', () {
      expect(CashEventType.fromValue('cash_in'), CashEventType.cashIn);
      expect(CashEventType.fromValue('cash_out'), CashEventType.cashOut);
    });

    test('fromValue throws on unknown', () {
      expect(() => CashEventType.fromValue('transfer'), throwsArgumentError);
    });

    test('tryFromValue returns null for null', () {
      expect(CashEventType.tryFromValue(null), isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // ExpenseCategory enum
  // ═══════════════════════════════════════════════════════════════

  group('ExpenseCategory', () {
    test('fromValue maps known values', () {
      expect(ExpenseCategory.fromValue('supplies'), ExpenseCategory.supplies);
      expect(ExpenseCategory.fromValue('rent'), ExpenseCategory.rent);
      expect(ExpenseCategory.fromValue('salary'), ExpenseCategory.salary);
      expect(ExpenseCategory.fromValue('other'), ExpenseCategory.other);
    });

    test('fromValue throws on unknown', () {
      expect(() => ExpenseCategory.fromValue('luxury'), throwsArgumentError);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Payment model
  // ═══════════════════════════════════════════════════════════════

  group('Payment.fromJson', () {
    test('parses all required and optional fields', () {
      final json = {
        'id': 'pay-001',
        'transaction_id': 'tx-001',
        'method': 'cash',
        'amount': '120.50',
        'cash_tendered': '150.00',
        'change_given': '29.50',
        'tip_amount': '5.00',
        'card_brand': 'visa',
        'card_last_four': '1234',
        'card_auth_code': 'AUTH99',
        'card_reference': 'REF001',
        'gift_card_code': 'GC-ABC',
        'coupon_code': 'SAVE10',
        'loyalty_points_used': 100,
        'status': 'completed',
        'nearpay_transaction_id': 'np-tx-001',
        'sync_version': 3,
        'created_at': '2026-05-01T10:00:00.000Z',
      };

      final payment = Payment.fromJson(json);

      expect(payment.id, 'pay-001');
      expect(payment.transactionId, 'tx-001');
      expect(payment.method, PaymentMethodKey.cash);
      expect(payment.amount, 120.50);
      expect(payment.cashTendered, 150.00);
      expect(payment.changeGiven, 29.50);
      expect(payment.tipAmount, 5.00);
      expect(payment.cardBrand, 'visa');
      expect(payment.cardLastFour, '1234');
      expect(payment.cardAuthCode, 'AUTH99');
      expect(payment.cardReference, 'REF001');
      expect(payment.giftCardCode, 'GC-ABC');
      expect(payment.couponCode, 'SAVE10');
      expect(payment.loyaltyPointsUsed, 100);
      expect(payment.status, 'completed');
      expect(payment.nearpayTransactionId, 'np-tx-001');
      expect(payment.syncVersion, 3);
      expect(payment.createdAt, isNotNull);
      expect(payment.createdAt!.year, 2026);
    });

    test('amount parses numeric integer from server', () {
      final json = {
        'id': 'pay-002',
        'transaction_id': 'tx-002',
        'method': 'card',
        'amount': 50,
      };
      final payment = Payment.fromJson(json);
      expect(payment.amount, 50.0);
    });

    test('nullable fields are null when absent', () {
      final json = {
        'id': 'pay-003',
        'transaction_id': 'tx-003',
        'method': 'gift_card',
        'amount': '25.00',
      };
      final payment = Payment.fromJson(json);
      expect(payment.cashTendered, isNull);
      expect(payment.changeGiven, isNull);
      expect(payment.tipAmount, isNull);
      expect(payment.cardBrand, isNull);
      expect(payment.cardLastFour, isNull);
      expect(payment.giftCardCode, isNull);
      expect(payment.status, isNull);
      expect(payment.createdAt, isNull);
    });

    test('unknown method falls back to other', () {
      final json = {
        'id': 'pay-004',
        'transaction_id': 'tx-004',
        'method': 'future_crypto',
        'amount': '10.00',
      };
      final payment = Payment.fromJson(json);
      expect(payment.method, PaymentMethodKey.other);
    });

    test('toJson round-trips the data', () {
      final json = {
        'id': 'pay-005',
        'transaction_id': 'tx-005',
        'method': 'stc_pay',
        'amount': '99.99',
        'status': 'completed',
      };
      final payment = Payment.fromJson(json);
      final out = payment.toJson();
      expect(out['id'], 'pay-005');
      expect(out['method'], 'stc_pay');
      expect(out['amount'], 99.99);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CashEvent model
  // ═══════════════════════════════════════════════════════════════

  group('CashEvent.fromJson', () {
    test('parses cash_in event', () {
      final json = {
        'id': 'ce-001',
        'cash_session_id': 'cs-001',
        'type': 'cash_in',
        'amount': '100.00',
        'reason': 'sales proceeds',
        'notes': 'end of shift',
        'performed_by': 'user-001',
        'created_at': '2026-05-01T09:00:00.000Z',
      };
      final event = CashEvent.fromJson(json);
      expect(event.id, 'ce-001');
      expect(event.cashSessionId, 'cs-001');
      expect(event.type, CashEventType.cashIn);
      expect(event.amount, 100.0);
      expect(event.reason, 'sales proceeds');
      expect(event.notes, 'end of shift');
      expect(event.performedBy, 'user-001');
      expect(event.createdAt, isNotNull);
    });

    test('parses cash_out event', () {
      final json = {
        'id': 'ce-002',
        'cash_session_id': 'cs-001',
        'type': 'cash_out',
        'amount': '50.00',
        'reason': 'petty cash',
        'performed_by': 'user-001',
      };
      final event = CashEvent.fromJson(json);
      expect(event.type, CashEventType.cashOut);
      expect(event.notes, isNull);
      expect(event.createdAt, isNull);
    });

    test('toJson serialises type as string', () {
      final json = {
        'id': 'ce-003',
        'cash_session_id': 'cs-001',
        'type': 'cash_in',
        'amount': '75.00',
        'reason': 'test',
        'performed_by': 'user-001',
      };
      final out = CashEvent.fromJson(json).toJson();
      expect(out['type'], 'cash_in');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // CashSession model
  // ═══════════════════════════════════════════════════════════════

  group('CashSession.fromJson', () {
    test('parses open session with no nested relations', () {
      final json = {
        'id': 'cs-001',
        'store_id': 'store-001',
        'opened_by': 'user-001',
        'opening_float': '300.00',
        'status': 'open',
        'opened_at': '2026-05-01T08:00:00.000Z',
      };
      final session = CashSession.fromJson(json);
      expect(session.id, 'cs-001');
      expect(session.storeId, 'store-001');
      expect(session.openedBy, 'user-001');
      expect(session.openingFloat, 300.0);
      expect(session.cashEvents, isNull);
      expect(session.expenses, isNull);
      expect(session.closedAt, isNull);
    });

    test('parses closed session with all fields', () {
      final json = {
        'id': 'cs-002',
        'store_id': 'store-001',
        'terminal_id': 'pos-01',
        'opened_by': 'user-001',
        'closed_by': 'user-002',
        'opening_float': '200.00',
        'expected_cash': '350.00',
        'actual_cash': '345.00',
        'variance': '-5.00',
        'status': 'closed',
        'opened_at': '2026-05-01T08:00:00.000Z',
        'closed_at': '2026-05-01T18:00:00.000Z',
        'close_notes': 'Counted twice',
        'cash_events': [],
        'expenses': [],
      };
      final session = CashSession.fromJson(json);
      expect(session.terminalId, 'pos-01');
      expect(session.closedBy, 'user-002');
      expect(session.expectedCash, 350.0);
      expect(session.actualCash, 345.0);
      expect(session.variance, -5.0);
      expect(session.closeNotes, 'Counted twice');
      expect(session.cashEvents, isEmpty);
      expect(session.expenses, isEmpty);
      expect(session.closedAt, isNotNull);
    });

    test('parses nested cash_events and expenses', () {
      final cashEventJson = {
        'id': 'ce-001',
        'cash_session_id': 'cs-003',
        'type': 'cash_in',
        'amount': '100.00',
        'reason': 'sales',
        'performed_by': 'user-001',
      };
      final expenseJson = {
        'id': 'exp-001',
        'store_id': 'store-001',
        'amount': '15.00',
        'category': 'supplies',
        'recorded_by': 'user-001',
        'expense_date': '2026-05-01',
      };
      final json = {
        'id': 'cs-003',
        'store_id': 'store-001',
        'opened_by': 'user-001',
        'opening_float': '100.00',
        'cash_events': [cashEventJson],
        'expenses': [expenseJson],
      };
      final session = CashSession.fromJson(json);
      expect(session.cashEvents, hasLength(1));
      expect(session.cashEvents!.first.type, CashEventType.cashIn);
      expect(session.expenses, hasLength(1));
      expect(session.expenses!.first.category, ExpenseCategory.supplies);
    });

    test('copyWith replaces selected fields only', () {
      final session = CashSession.fromJson({
        'id': 'cs-004',
        'store_id': 'store-001',
        'opened_by': 'user-001',
        'opening_float': '100.00',
      });
      final updated = session.copyWith(terminalId: 'pos-02', openingFloat: 200.0);
      expect(updated.id, 'cs-004');
      expect(updated.terminalId, 'pos-02');
      expect(updated.openingFloat, 200.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Expense model
  // ═══════════════════════════════════════════════════════════════

  group('Expense.fromJson', () {
    test('parses all fields including optional', () {
      final json = {
        'id': 'exp-001',
        'store_id': 'store-001',
        'cash_session_id': 'cs-001',
        'amount': '45.00',
        'category': 'maintenance',
        'description': 'AC repair',
        'receipt_image_url': 'https://cdn.example.com/receipts/001.jpg',
        'recorded_by': 'user-001',
        'expense_date': '2026-05-01',
        'created_at': '2026-05-01T10:30:00.000Z',
        'updated_at': '2026-05-01T11:00:00.000Z',
      };
      final expense = Expense.fromJson(json);
      expect(expense.id, 'exp-001');
      expect(expense.storeId, 'store-001');
      expect(expense.cashSessionId, 'cs-001');
      expect(expense.amount, 45.0);
      expect(expense.category, ExpenseCategory.maintenance);
      expect(expense.description, 'AC repair');
      expect(expense.receiptImageUrl, 'https://cdn.example.com/receipts/001.jpg');
      expect(expense.recordedBy, 'user-001');
      expect(expense.expenseDate.year, 2026);
      expect(expense.expenseDate.month, 5);
      expect(expense.expenseDate.day, 1);
      expect(expense.createdAt, isNotNull);
      expect(expense.updatedAt, isNotNull);
    });

    test('optional fields null when absent', () {
      final json = {
        'id': 'exp-002',
        'store_id': 'store-001',
        'amount': '10.00',
        'category': 'food',
        'recorded_by': 'user-001',
        'expense_date': '2026-05-02',
      };
      final expense = Expense.fromJson(json);
      expect(expense.cashSessionId, isNull);
      expect(expense.description, isNull);
      expect(expense.receiptImageUrl, isNull);
      expect(expense.updatedAt, isNull);
    });

    test('toJson encodes expense_date as Y-m-d', () {
      final json = {
        'id': 'exp-003',
        'store_id': 'store-001',
        'amount': '20.00',
        'category': 'transport',
        'recorded_by': 'user-001',
        'expense_date': '2026-05-03',
      };
      final out = Expense.fromJson(json).toJson();
      expect(out['expense_date'], '2026-05-03');
      expect(out['category'], 'transport');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // GiftCard model
  // ═══════════════════════════════════════════════════════════════

  group('GiftCard.fromJson', () {
    test('parses active gift card with expiry', () {
      final json = {
        'id': 'gc-001',
        'organization_id': 'org-001',
        'code': 'GC-ABCD1234',
        'barcode': '123456789',
        'initial_amount': '200.00',
        'balance': '150.00',
        'recipient_name': 'Ali',
        'status': 'active',
        'issued_by': 'user-001',
        'issued_at_store': 'store-001',
        'expires_at': '2027-01-01T00:00:00.000Z',
        'created_at': '2026-05-01T09:00:00.000Z',
      };
      final card = GiftCard.fromJson(json);
      expect(card.id, 'gc-001');
      expect(card.code, 'GC-ABCD1234');
      expect(card.initialAmount, 200.0);
      expect(card.balance, 150.0);
      expect(card.status, GiftCardStatus.active);
      expect(card.recipientName, 'Ali');
      expect(card.expiresAt, isNotNull);
      expect(card.expiresAt!.year, 2027);
    });

    test('parses deactivated card with null expiry', () {
      final json = {
        'id': 'gc-002',
        'organization_id': 'org-001',
        'code': 'GC-XYZ',
        'initial_amount': '100.00',
        'balance': '0.00',
        'status': 'deactivated',
        'issued_by': 'user-001',
        'issued_at_store': 'store-001',
      };
      final card = GiftCard.fromJson(json);
      expect(card.status, GiftCardStatus.deactivated);
      expect(card.balance, 0.0);
      expect(card.expiresAt, isNull);
      expect(card.recipientName, isNull);
    });

    test('null status string returns null', () {
      final json = {
        'id': 'gc-003',
        'organization_id': 'org-001',
        'code': 'GC-NO-STATUS',
        'initial_amount': '50.00',
        'balance': '50.00',
        'status': null,
        'issued_by': 'user-001',
        'issued_at_store': 'store-001',
      };
      final card = GiftCard.fromJson(json);
      expect(card.status, isNull);
    });

    test('toJson serialises status as string', () {
      final json = {
        'id': 'gc-004',
        'organization_id': 'org-001',
        'code': 'GC-RNDM',
        'initial_amount': '75.00',
        'balance': '75.00',
        'status': 'active',
        'issued_by': 'user-001',
        'issued_at_store': 'store-001',
      };
      final out = GiftCard.fromJson(json).toJson();
      expect(out['status'], 'active');
      expect(out['balance'], 75.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  // Refund model
  // ═══════════════════════════════════════════════════════════════

  group('Refund.fromJson', () {
    test('parses completed refund', () {
      final json = {
        'id': 'ref-001',
        'return_id': 'ret-001',
        'payment_id': 'pay-001',
        'method': 'cash',
        'amount': '25.00',
        'reference_number': 'REF-2026-001',
        'status': 'completed',
        'processed_by': 'user-001',
        'created_at': '2026-05-01T12:00:00.000Z',
      };
      final refund = Refund.fromJson(json);
      expect(refund.id, 'ref-001');
      expect(refund.returnId, 'ret-001');
      expect(refund.paymentId, 'pay-001');
      expect(refund.method, PaymentMethodKey.cash);
      expect(refund.amount, 25.0);
      expect(refund.referenceNumber, 'REF-2026-001');
      expect(refund.status, RefundStatus.completed);
      expect(refund.processedBy, 'user-001');
      expect(refund.createdAt, isNotNull);
    });

    test('nullable fields null when absent', () {
      final json = {
        'id': 'ref-002',
        'return_id': 'ret-002',
        'method': 'card',
        'amount': '10.00',
        'processed_by': 'user-001',
      };
      final refund = Refund.fromJson(json);
      expect(refund.paymentId, isNull);
      expect(refund.referenceNumber, isNull);
      expect(refund.status, isNull);
      expect(refund.createdAt, isNull);
    });

    test('pending status parsed correctly', () {
      final json = {
        'id': 'ref-003',
        'return_id': 'ret-003',
        'method': 'card',
        'amount': '50.00',
        'status': 'pending',
        'processed_by': 'user-001',
      };
      final refund = Refund.fromJson(json);
      expect(refund.status, RefundStatus.pending);
    });

    test('toJson serialises method and status as strings', () {
      final json = {
        'id': 'ref-004',
        'return_id': 'ret-004',
        'method': 'bank_transfer',
        'amount': '80.00',
        'status': 'completed',
        'processed_by': 'user-001',
      };
      final out = Refund.fromJson(json).toJson();
      expect(out['method'], 'bank_transfer');
      expect(out['status'], 'completed');
      expect(out['amount'], 80.0);
    });

    test('amount parses numeric value', () {
      final json = {
        'id': 'ref-005',
        'return_id': 'ret-005',
        'method': 'cash',
        'amount': 33,
        'processed_by': 'user-001',
      };
      final refund = Refund.fromJson(json);
      expect(refund.amount, 33.0);
    });

    test('copyWith preserves unset fields', () {
      final json = {
        'id': 'ref-006',
        'return_id': 'ret-006',
        'method': 'cash',
        'amount': '15.00',
        'status': 'pending',
        'processed_by': 'user-001',
      };
      final refund = Refund.fromJson(json);
      final updated = refund.copyWith(amount: 20.0, status: RefundStatus.completed);
      expect(updated.id, 'ref-006');
      expect(updated.amount, 20.0);
      expect(updated.status, RefundStatus.completed);
      expect(updated.processedBy, 'user-001');
    });
  });
}
