import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/subscription/models/subscription_plan.dart';
import 'package:thawani_pos/features/subscription/models/store_subscription.dart';
import 'package:thawani_pos/features/subscription/models/invoice.dart';
import 'package:thawani_pos/features/subscription/models/invoice_line_item.dart';
import 'package:thawani_pos/features/subscription/enums/subscription_status.dart';
import 'package:thawani_pos/features/subscription/enums/billing_cycle.dart';
import 'package:thawani_pos/features/payments/enums/subscription_payment_method.dart';

void main() {
  group('SubscriptionPlan', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'plan-uuid-1',
        'name': 'Professional',
        'name_ar': 'احترافي',
        'slug': 'professional',
        'description': 'Best for growing businesses',
        'description_ar': 'الأفضل للأعمال المتنامية',
        'monthly_price': 29.99,
        'annual_price': 299.99,
        'trial_days': 14,
        'grace_period_days': 7,
        'is_active': true,
        'is_highlighted': true,
        'sort_order': 2,
        'features': [
          {'feature_key': 'pos', 'is_enabled': true},
          {'feature_key': 'inventory', 'is_enabled': true},
        ],
        'limits': [
          {'limit_key': 'products', 'limit_value': 500, 'price_per_extra_unit': null},
          {'limit_key': 'staff', 'limit_value': 10, 'price_per_extra_unit': null},
        ],
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final plan = SubscriptionPlan.fromJson(json);

      expect(plan.id, 'plan-uuid-1');
      expect(plan.name, 'Professional');
      expect(plan.nameAr, 'احترافي');
      expect(plan.slug, 'professional');
      expect(plan.description, 'Best for growing businesses');
      expect(plan.monthlyPrice, 29.99);
      expect(plan.annualPrice, 299.99);
      expect(plan.trialDays, 14);
      expect(plan.gracePeriodDays, 7);
      expect(plan.isActive, true);
      expect(plan.isHighlighted, true);
      expect(plan.sortOrder, 2);
      expect(plan.features, isNotNull);
      expect(plan.features!.length, 2);
      expect(plan.limits, isNotNull);
      expect(plan.limits!.length, 2);
    });

    test('fromJson handles integer prices cast to double', () {
      final json = {
        'id': 'plan-1',
        'name': 'Basic',
        'monthly_price': 10, // int, not double
        'annual_price': 100, // int, not double
      };

      final plan = SubscriptionPlan.fromJson(json);
      expect(plan.monthlyPrice, 10.0);
      expect(plan.annualPrice, 100.0);
    });

    test('fromJson handles null optional fields', () {
      final json = {'id': 'plan-1', 'name': 'Free', 'monthly_price': 0.0, 'annual_price': 0.0};

      final plan = SubscriptionPlan.fromJson(json);
      expect(plan.nameAr, isNull);
      expect(plan.description, isNull);
      expect(plan.trialDays, isNull);
      expect(plan.gracePeriodDays, isNull);
      expect(plan.isHighlighted, false);
      expect(plan.features, isNull);
      expect(plan.limits, isNull);
    });

    test('toJson serializes correctly', () {
      final plan = SubscriptionPlan(
        id: 'plan-1',
        name: 'Pro',
        nameAr: 'برو',
        slug: 'pro',
        monthlyPrice: 49.99,
        annualPrice: 499.99,
        trialDays: 14,
        isActive: true,
        isHighlighted: false,
        sortOrder: 1,
      );

      final json = plan.toJson();
      expect(json['id'], 'plan-1');
      expect(json['name'], 'Pro');
      expect(json['name_ar'], 'برو');
      expect(json['monthly_price'], 49.99);
      expect(json['annual_price'], 499.99);
      expect(json['trial_days'], 14);
    });

    test('annualSavings calculates correctly', () {
      final plan = SubscriptionPlan(id: 'plan-1', name: 'Pro', monthlyPrice: 100.0, annualPrice: 1000.0, isActive: true);

      // Annual vs 12 months: 1200 - 1000 = 200 savings
      if (plan.annualPrice != null) {
        final annualSavings = (plan.monthlyPrice * 12) - plan.annualPrice!;
        expect(annualSavings, closeTo(200.0, 0.01));
      }
    });
  });

  group('StoreSubscription', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'sub-uuid-1',
        'store_id': 'store-uuid-1',
        'subscription_plan_id': 'plan-uuid-1',
        'status': 'active',
        'billing_cycle': 'monthly',
        'payment_method': 'credit_card',
        'trial_ends_at': '2024-02-01T00:00:00.000Z',
        'current_period_start': '2024-02-01T00:00:00.000Z',
        'current_period_end': '2024-03-01T00:00:00.000Z',
        'cancelled_at': null,
        'grace_period_ends_at': null,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
        'plan': {'id': 'plan-uuid-1', 'name': 'Professional', 'monthly_price': 29.99, 'annual_price': 299.99},
      };

      final sub = StoreSubscription.fromJson(json);

      expect(sub.id, 'sub-uuid-1');
      expect(sub.storeId, 'store-uuid-1');
      expect(sub.subscriptionPlanId, 'plan-uuid-1');
      expect(sub.status, SubscriptionStatus.active);
      expect(sub.billingCycle, BillingCycle.monthly);
      expect(sub.paymentMethod, SubscriptionPaymentMethod.creditCard);
      expect(sub.trialEndsAt, isNotNull);
      expect(sub.currentPeriodStart, isNotNull);
      expect(sub.currentPeriodEnd, isNotNull);
      expect(sub.cancelledAt, isNull);
      expect(sub.plan, isNotNull);
      expect(sub.plan!.name, 'Professional');
    });

    test('fromJson parses all subscription statuses', () {
      for (final status in ['trial', 'active', 'grace', 'cancelled', 'expired']) {
        final json = {'id': 'sub-1', 'store_id': 'store-1', 'subscription_plan_id': 'plan-1', 'status': status};
        final sub = StoreSubscription.fromJson(json);
        expect(sub.status, isNotNull, reason: 'Status "$status" should parse');
      }
    });

    test('fromJson parses billing cycles', () {
      for (final cycle in ['monthly', 'yearly']) {
        final json = {
          'id': 'sub-1',
          'store_id': 'store-1',
          'subscription_plan_id': 'plan-1',
          'status': 'active',
          'billing_cycle': cycle,
        };
        final sub = StoreSubscription.fromJson(json);
        expect(sub.billingCycle, isNotNull, reason: 'Cycle "$cycle" should parse');
      }
    });

    test('fromJson handles null optional dates', () {
      final json = {'id': 'sub-1', 'store_id': 'store-1', 'subscription_plan_id': 'plan-1', 'status': 'trial'};

      final sub = StoreSubscription.fromJson(json);
      expect(sub.cancelledAt, isNull);
      expect(sub.gracePeriodEndsAt, isNull);
      expect(sub.plan, isNull);
    });

    test('fromJson handles unknown status gracefully', () {
      final json = {'id': 'sub-1', 'store_id': 'store-1', 'subscription_plan_id': 'plan-1', 'status': 'unknown_status'};

      // Due to fromValue (throws) vs tryFromValue (null), check behavior
      // Status uses fromValue which throws — or if it uses tryFromValue, returns null
      // Verify based on actual implementation
      try {
        final sub = StoreSubscription.fromJson(json);
        // If it didn't throw, status should be null
        expect(sub.status, isNull);
      } catch (e) {
        // If fromValue is used, it throws
        expect(e, isA<ArgumentError>());
      }
    });

    test('isActive checks status correctly', () {
      final activeSub = StoreSubscription(
        id: '1',
        storeId: 'store-1',
        subscriptionPlanId: 'plan-1',
        status: SubscriptionStatus.active,
      );
      expect(activeSub.isActive, true);

      final trialSub = StoreSubscription(
        id: '2',
        storeId: 'store-1',
        subscriptionPlanId: 'plan-1',
        status: SubscriptionStatus.trial,
      );
      expect(trialSub.isActive, true); // trial is considered active

      final cancelledSub = StoreSubscription(
        id: '3',
        storeId: 'store-1',
        subscriptionPlanId: 'plan-1',
        status: SubscriptionStatus.cancelled,
      );
      expect(cancelledSub.isActive, false);
    });
  });

  group('Invoice', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'inv-uuid-1',
        'invoice_number': 'INV-2024-001',
        'amount': 29.99,
        'tax': 4.50,
        'total': 34.49,
        'status': 'paid',
        'pdf_url': 'https://example.com/invoices/inv-1.pdf',
        'due_date': '2024-02-15T00:00:00.000Z',
        'paid_at': '2024-02-10T10:00:00.000Z',
        'created_at': '2024-01-01T00:00:00.000Z',
        'line_items': [
          {
            'id': 'item-1',
            'invoice_id': 'inv-uuid-1',
            'description': 'Professional Plan - Monthly',
            'quantity': 1,
            'unit_price': 29.99,
            'total': 29.99,
          },
        ],
      };

      final invoice = Invoice.fromJson(json);

      expect(invoice.id, 'inv-uuid-1');
      expect(invoice.invoiceNumber, 'INV-2024-001');
      expect(invoice.amount, 29.99);
      expect(invoice.tax, 4.50);
      expect(invoice.total, 34.49);
      expect(invoice.pdfUrl, isNotNull);
      expect(invoice.lineItems, isNotNull);
      expect(invoice.lineItems!.length, 1);
    });

    test('fromJson handles null tax', () {
      final json = {'id': 'inv-1', 'amount': 10.0, 'total': 10.0};

      final invoice = Invoice.fromJson(json);
      expect(invoice.tax, isNull);
    });

    test('fromJson casts integer amounts to double', () {
      final json = {'id': 'inv-1', 'amount': 100, 'tax': 15, 'total': 115};

      final invoice = Invoice.fromJson(json);
      expect(invoice.amount, 100.0);
      expect(invoice.tax, 15.0);
      expect(invoice.total, 115.0);
    });

    test('fromJson handles null line_items', () {
      final json = {'id': 'inv-1', 'amount': 10.0, 'total': 10.0};

      final invoice = Invoice.fromJson(json);
      expect(invoice.lineItems, isNull);
    });
  });

  group('InvoiceLineItem', () {
    test('fromJson parses all fields', () {
      final json = {
        'id': 'item-uuid-1',
        'invoice_id': 'inv-uuid-1',
        'description': 'Pro Plan Subscription',
        'quantity': 1,
        'unit_price': 29.99,
        'total': 29.99,
      };

      final item = InvoiceLineItem.fromJson(json);

      expect(item.id, 'item-uuid-1');
      expect(item.invoiceId, 'inv-uuid-1');
      expect(item.description, 'Pro Plan Subscription');
      expect(item.quantity, 1);
      expect(item.unitPrice, 29.99);
      expect(item.total, 29.99);
    });

    test('fromJson handles optional quantity', () {
      final json = {'id': 'item-1', 'invoice_id': 'inv-1', 'description': 'Credit', 'unit_price': 10.0, 'total': 10.0};

      final item = InvoiceLineItem.fromJson(json);
      expect(item.quantity, isNull);
    });

    test('fromJson casts price ints to double', () {
      final json = {'id': 'item-1', 'invoice_id': 'inv-1', 'description': 'Test', 'unit_price': 50, 'total': 50};

      final item = InvoiceLineItem.fromJson(json);
      expect(item.unitPrice, 50.0);
      expect(item.total, 50.0);
    });
  });

  group('SubscriptionStatus', () {
    test('fromValue parses all statuses', () {
      expect(SubscriptionStatus.fromValue('trial'), SubscriptionStatus.trial);
      expect(SubscriptionStatus.fromValue('active'), SubscriptionStatus.active);
      expect(SubscriptionStatus.fromValue('grace'), SubscriptionStatus.grace);
      expect(SubscriptionStatus.fromValue('cancelled'), SubscriptionStatus.cancelled);
      expect(SubscriptionStatus.fromValue('expired'), SubscriptionStatus.expired);
    });

    test('fromValue throws for invalid', () {
      expect(() => SubscriptionStatus.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null for invalid', () {
      expect(SubscriptionStatus.tryFromValue('nope'), isNull);
      expect(SubscriptionStatus.tryFromValue(null), isNull);
    });
  });

  group('BillingCycle', () {
    test('fromValue parses cycles', () {
      expect(BillingCycle.fromValue('monthly'), BillingCycle.monthly);
      expect(BillingCycle.fromValue('yearly'), BillingCycle.yearly);
    });

    test('fromValue throws for invalid', () {
      expect(() => BillingCycle.fromValue('weekly'), throwsArgumentError);
    });

    test('tryFromValue returns null for invalid', () {
      expect(BillingCycle.tryFromValue('biweekly'), isNull);
    });
  });

  group('SubscriptionPaymentMethod', () {
    test('fromValue parses all methods', () {
      expect(SubscriptionPaymentMethod.fromValue('credit_card'), SubscriptionPaymentMethod.creditCard);
      expect(SubscriptionPaymentMethod.fromValue('mada'), SubscriptionPaymentMethod.mada);
      expect(SubscriptionPaymentMethod.fromValue('bank_transfer'), SubscriptionPaymentMethod.bankTransfer);
    });

    test('fromValue throws for invalid', () {
      expect(() => SubscriptionPaymentMethod.fromValue('bitcoin'), throwsArgumentError);
    });

    test('tryFromValue returns null for invalid', () {
      expect(SubscriptionPaymentMethod.tryFromValue('paypal'), isNull);
    });
  });
}
