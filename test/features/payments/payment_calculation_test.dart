import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/services/payment_calculation_service.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // SarDenomination
  // ═══════════════════════════════════════════════════════════

  group('SarDenomination', () {
    test('all has 13 denominations', () {
      expect(SarDenomination.all, hasLength(13));
    });

    test('denominations are sorted descending by value', () {
      for (int i = 0; i < SarDenomination.all.length - 1; i++) {
        expect(SarDenomination.all[i].value, greaterThan(SarDenomination.all[i + 1].value));
      }
    });

    test('highest is 500 SAR note', () {
      final highest = SarDenomination.all.first;
      expect(highest.value, 500);
      expect(highest.isCoin, false);
    });

    test('lowest is 5 Halalas coin', () {
      final lowest = SarDenomination.all.last;
      expect(lowest.value, 0.05);
      expect(lowest.isCoin, true);
    });

    test('coins start from 2 SAR and below', () {
      for (final d in SarDenomination.all) {
        if (d.value <= 2) {
          expect(d.isCoin, true);
        } else {
          expect(d.isCoin, false);
        }
      }
    });

    test('each denomination has both English and Arabic labels', () {
      for (final d in SarDenomination.all) {
        expect(d.label, isNotEmpty);
        expect(d.labelAr, isNotEmpty);
      }
    });

    test('quickPayAmounts has standard bills', () {
      expect(SarDenomination.quickPayAmounts, containsAll([1, 5, 10, 20, 50, 100]));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // DenominationCount
  // ═══════════════════════════════════════════════════════════

  group('DenominationCount', () {
    test('total is value * count', () {
      final dc = DenominationCount(denomination: SarDenomination.all[0], count: 3);
      expect(dc.total, 1500); // 500 * 3
    });

    test('default count is 0', () {
      final dc = DenominationCount(denomination: SarDenomination.all[0]);
      expect(dc.count, 0);
      expect(dc.total, 0);
    });

    test('count is mutable', () {
      final dc = DenominationCount(denomination: SarDenomination.all[0]);
      dc.count = 5;
      expect(dc.total, 2500);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // SplitPaymentLeg
  // ═══════════════════════════════════════════════════════════

  group('SplitPaymentLeg', () {
    test('holds method and amount', () {
      const leg = SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 50);
      expect(leg.method, PaymentMethodKey.cash);
      expect(leg.amount, 50);
      expect(leg.metadata, isNull);
    });

    test('copyWith replaces fields', () {
      const leg = SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 50);
      final updated = leg.copyWith(amount: 100);
      expect(updated.amount, 100);
      expect(updated.method, PaymentMethodKey.cash);
    });

    test('copyWith replaces method', () {
      const leg = SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 50);
      final updated = leg.copyWith(method: PaymentMethodKey.cardMada);
      expect(updated.method, PaymentMethodKey.cardMada);
      expect(updated.amount, 50);
    });

    test('supports metadata', () {
      const leg = SplitPaymentLeg(method: PaymentMethodKey.giftCard, amount: 25, metadata: {'code': 'ABC123'});
      expect(leg.metadata, isNotNull);
      expect(leg.metadata!['code'], 'ABC123');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // PaymentCalculationService
  // ═══════════════════════════════════════════════════════════

  group('PaymentCalculationService', () {
    // ── roundCash ──────────────────────────────────────────

    group('roundCash', () {
      test('rounds to nearest 0.25', () {
        expect(PaymentCalculationService.roundCash(10.0), 10.0);
        expect(PaymentCalculationService.roundCash(10.10), 10.0);
        expect(PaymentCalculationService.roundCash(10.12), 10.0);
        expect(PaymentCalculationService.roundCash(10.13), 10.25);
        expect(PaymentCalculationService.roundCash(10.25), 10.25);
        expect(PaymentCalculationService.roundCash(10.37), 10.25);
        expect(PaymentCalculationService.roundCash(10.38), 10.5);
        expect(PaymentCalculationService.roundCash(10.50), 10.5);
        expect(PaymentCalculationService.roundCash(10.62), 10.5);
        expect(PaymentCalculationService.roundCash(10.63), 10.75);
        expect(PaymentCalculationService.roundCash(10.75), 10.75);
        expect(PaymentCalculationService.roundCash(10.87), 10.75);
        expect(PaymentCalculationService.roundCash(10.88), 11.0);
      });

      test('handles zero', () {
        expect(PaymentCalculationService.roundCash(0), 0);
      });

      test('handles large amounts', () {
        expect(PaymentCalculationService.roundCash(9999.99), 10000.0);
      });
    });

    // ── calculateChange ───────────────────────────────────

    group('calculateChange', () {
      test('returns rounded change when tendered > total', () {
        // Total 73.50, tendered 100 → change 26.50
        expect(PaymentCalculationService.calculateChange(73.50, 100), 26.50);
      });

      test('returns 0 when tendered equals total', () {
        expect(PaymentCalculationService.calculateChange(50, 50), 0);
      });

      test('returns 0 when tendered less than total', () {
        expect(PaymentCalculationService.calculateChange(100, 50), 0);
      });

      test('change is rounded to nearest 0.25', () {
        // Total 10.10, tendered 20 → raw change 9.90, rounded to 10.0
        expect(PaymentCalculationService.calculateChange(10.10, 20), 10.0);
      });
    });

    // ── calculateDenominationTotal ────────────────────────

    group('calculateDenominationTotal', () {
      test('sums all denomination counts', () {
        final counts = [
          DenominationCount(denomination: SarDenomination.all[0], count: 2), // 500 × 2 = 1000
          DenominationCount(denomination: SarDenomination.all[3], count: 3), // 50 × 3 = 150
          DenominationCount(denomination: SarDenomination.all[8], count: 5), // 1 × 5 = 5
        ];
        expect(PaymentCalculationService.calculateDenominationTotal(counts), 1155);
      });

      test('returns 0 for empty list', () {
        expect(PaymentCalculationService.calculateDenominationTotal([]), 0);
      });

      test('returns 0 when all counts are 0', () {
        final counts = PaymentCalculationService.createDenominationCounts();
        expect(PaymentCalculationService.calculateDenominationTotal(counts), 0);
      });
    });

    // ── calculateVariance ─────────────────────────────────

    group('calculateVariance', () {
      test('positive when actual > expected', () {
        expect(PaymentCalculationService.calculateVariance(100, 105), 5);
      });

      test('negative when actual < expected', () {
        expect(PaymentCalculationService.calculateVariance(100, 95), -5);
      });

      test('zero when equal', () {
        expect(PaymentCalculationService.calculateVariance(100, 100), 0);
      });
    });

    // ── validateSplitPayment ──────────────────────────────

    group('validateSplitPayment', () {
      test('valid when sum equals total', () {
        const legs = [
          SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 50),
          SplitPaymentLeg(method: PaymentMethodKey.cardMada, amount: 50),
        ];
        expect(PaymentCalculationService.validateSplitPayment(legs, 100), true);
      });

      test('invalid when sum differs from total', () {
        const legs = [
          SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 50),
          SplitPaymentLeg(method: PaymentMethodKey.cardMada, amount: 30),
        ];
        expect(PaymentCalculationService.validateSplitPayment(legs, 100), false);
      });

      test('valid with very small floating point difference', () {
        const legs = [
          SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 33.33),
          SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 33.33),
          SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 33.34),
        ];
        expect(PaymentCalculationService.validateSplitPayment(legs, 100), true);
      });

      test('empty legs invalid for non-zero total', () {
        expect(PaymentCalculationService.validateSplitPayment([], 100), false);
      });

      test('empty legs valid for zero total', () {
        expect(PaymentCalculationService.validateSplitPayment([], 0), true);
      });
    });

    // ── splitPaymentRemaining ─────────────────────────────

    group('splitPaymentRemaining', () {
      test('returns remaining when partial legs', () {
        const legs = [SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 60)];
        expect(PaymentCalculationService.splitPaymentRemaining(legs, 100), 40);
      });

      test('returns 0 when fully allocated', () {
        const legs = [SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 100)];
        expect(PaymentCalculationService.splitPaymentRemaining(legs, 100), 0);
      });

      test('returns 0 when over-allocated', () {
        const legs = [SplitPaymentLeg(method: PaymentMethodKey.cash, amount: 120)];
        expect(PaymentCalculationService.splitPaymentRemaining(legs, 100), 0);
      });
    });

    // ── suggestQuickPayAmounts ─────────────────────────────

    group('suggestQuickPayAmounts', () {
      test('includes exact amount first', () {
        final suggestions = PaymentCalculationService.suggestQuickPayAmounts(25);
        expect(suggestions.first, 25);
      });

      test('returns sorted list', () {
        final suggestions = PaymentCalculationService.suggestQuickPayAmounts(15);
        for (int i = 0; i < suggestions.length - 1; i++) {
          expect(suggestions[i], lessThanOrEqualTo(suggestions[i + 1]));
        }
      });

      test('returns at most 8 items', () {
        final suggestions = PaymentCalculationService.suggestQuickPayAmounts(3);
        expect(suggestions.length, lessThanOrEqualTo(8));
      });

      test('all suggestions >= total', () {
        final suggestions = PaymentCalculationService.suggestQuickPayAmounts(45);
        for (final s in suggestions) {
          expect(s, greaterThanOrEqualTo(45));
        }
      });
    });

    // ── requiresTerminal ──────────────────────────────────

    group('requiresTerminal', () {
      test('card methods require terminal', () {
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.cardMada), true);
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.cardVisa), true);
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.cardMastercard), true);
      });

      test('non-card methods do not require terminal', () {
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.cash), false);
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.giftCard), false);
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.storeCredit), false);
        expect(PaymentCalculationService.requiresTerminal(PaymentMethodKey.mobilePayment), false);
      });
    });

    // ── isCardMethod ──────────────────────────────────────

    group('isCardMethod', () {
      test('matches requiresTerminal', () {
        for (final method in PaymentMethodKey.values) {
          expect(PaymentCalculationService.isCardMethod(method), PaymentCalculationService.requiresTerminal(method));
        }
      });
    });

    // ── methodDisplayName ─────────────────────────────────

    group('methodDisplayName', () {
      test('returns non-empty string for all methods', () {
        for (final method in PaymentMethodKey.values) {
          expect(PaymentCalculationService.methodDisplayName(method), isNotEmpty);
        }
      });

      test('cash returns Cash', () {
        expect(PaymentCalculationService.methodDisplayName(PaymentMethodKey.cash), 'Cash');
      });

      test('cardMada returns mada', () {
        expect(PaymentCalculationService.methodDisplayName(PaymentMethodKey.cardMada), 'mada');
      });
    });

    // ── methodDisplayNameAr ───────────────────────────────

    group('methodDisplayNameAr', () {
      test('returns non-empty string for all methods', () {
        for (final method in PaymentMethodKey.values) {
          expect(PaymentCalculationService.methodDisplayNameAr(method), isNotEmpty);
        }
      });

      test('cash returns نقدي', () {
        expect(PaymentCalculationService.methodDisplayNameAr(PaymentMethodKey.cash), 'نقدي');
      });
    });

    // ── createDenominationCounts ──────────────────────────

    group('createDenominationCounts', () {
      test('returns 13 denomination counts', () {
        final counts = PaymentCalculationService.createDenominationCounts();
        expect(counts, hasLength(13));
      });

      test('all counts start at 0', () {
        final counts = PaymentCalculationService.createDenominationCounts();
        for (final dc in counts) {
          expect(dc.count, 0);
        }
      });
    });
  });

  // ═══════════════════════════════════════════════════════════
  // PaymentsState Tests
  // ═══════════════════════════════════════════════════════════

  group('PaymentMethodKey', () {
    test('has 18 values', () {
      expect(PaymentMethodKey.values, hasLength(18));
    });

    test('fromValue round-trips', () {
      for (final key in PaymentMethodKey.values) {
        expect(PaymentMethodKey.fromValue(key.value), key);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(PaymentMethodKey.tryFromValue('invalid'), isNull);
    });
  });
}
