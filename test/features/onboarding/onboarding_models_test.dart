import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/onboarding/models/store_settings.dart';
import 'package:wameedpos/features/onboarding/models/onboarding_progress.dart';
import 'package:wameedpos/features/onboarding/enums/onboarding_step.dart';

void main() {
  group('StoreSettings', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'settings-uuid-1',
        'store_id': 'store-uuid-1',
        'tax_rate': 15.0,
        'prices_include_tax': true,
        'currency_code': 'SAR',
        'currency_symbol': '﷼',
        'decimal_places': 2,
        'allow_negative_stock': false,
        'low_stock_threshold': 10,
        'auto_print_receipt': true,
        'receipt_header': 'Welcome to our store',
        'receipt_footer': 'Thank you!',
        'receipt_show_logo': true,
        'receipt_show_tax_breakdown': true,
        'session_timeout_minutes': 480,
        'enable_tips': true,
        'enable_kitchen_display': false,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final settings = StoreSettings.fromJson(json);

      expect(settings.id, 'settings-uuid-1');
      expect(settings.storeId, 'store-uuid-1');
      expect(settings.taxRate, 15.0);
      expect(settings.pricesIncludeTax, true);
      expect(settings.currencyCode, 'SAR');
      expect(settings.decimalPlaces, 2);
      expect(settings.allowNegativeStock, false);
      expect(settings.lowStockThreshold, 10);
      expect(settings.autoPrintReceipt, true);
      expect(settings.sessionTimeoutMinutes, 480);
      expect(settings.enableTips, true);
      expect(settings.enableKitchenDisplay, false);
    });

    test('fromJson applies defaults for missing fields', () {
      final json = <String, dynamic>{};

      final settings = StoreSettings.fromJson(json);

      expect(settings.taxRate, 15.0); // default
      expect(settings.currencyCode, 'SAR'); // default
      expect(settings.sessionTimeoutMinutes, 480); // default
      expect(settings.decimalPlaces, 2); // default
    });

    test('fromJson handles zero tax rate', () {
      final json = {'tax_rate': 0.0};

      final settings = StoreSettings.fromJson(json);
      expect(settings.taxRate, 0.0);
    });

    test('fromJson handles integer tax rate cast', () {
      final json = {'tax_rate': 5}; // int, not double

      final settings = StoreSettings.fromJson(json);
      expect(settings.taxRate, 5.0); // should be cast via (num).toDouble()
    });

    test('toJson omits id and storeId', () {
      final settings = StoreSettings(id: 'settings-1', storeId: 'store-1', taxRate: 15.0, currencyCode: 'SAR', decimalPlaces: 2);

      final json = settings.toJson();

      expect(json.containsKey('id'), false);
      expect(json.containsKey('store_id'), false);
      expect(json['tax_rate'], 15.0);
      expect(json['currency_code'], 'SAR');
    });

    test('toJson serializes boolean flags', () {
      final settings = StoreSettings(taxRate: 15.0, pricesIncludeTax: false, allowNegativeStock: true, enableTips: false);

      final json = settings.toJson();
      expect(json['prices_include_tax'], false);
      expect(json['allow_negative_stock'], true);
      expect(json['enable_tips'], false);
    });

    test('handles extra map field', () {
      final json = {
        'extra': {'custom_key': 'custom_value'},
      };

      final settings = StoreSettings.fromJson(json);
      expect(settings.extra, isNotNull);
      expect(settings.extra['custom_key'], 'custom_value');
    });
  });

  group('OnboardingProgress', () {
    test('fromJson parses full payload', () {
      final json = {
        'id': 'onboarding-uuid-1',
        'store_id': 'store-uuid-1',
        'current_step': 'tax',
        'completed_steps': ['welcome', 'business_info', 'business_type'],
        'is_wizard_completed': false,
        'is_checklist_dismissed': false,
        'checklist_items': {'add_first_product': true, 'setup_payment': false, 'invite_staff': false},
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final progress = OnboardingProgress.fromJson(json);

      expect(progress.id, 'onboarding-uuid-1');
      expect(progress.storeId, 'store-uuid-1');
      expect(progress.currentStep, OnboardingStep.tax);
      expect(progress.completedSteps, hasLength(3));
      expect(progress.completedSteps, contains('welcome'));
      expect(progress.completedSteps, contains('business_info'));
      expect(progress.completedSteps, contains('business_type'));
      expect(progress.isWizardCompleted, false);
      expect(progress.isChecklistDismissed, false);
      expect(progress.checklistItems, isNotNull);
      expect(progress.checklistItems['add_first_product'], true);
    });

    test('isStepCompleted returns true for completed steps', () {
      final progress = OnboardingProgress(
        id: '1',
        storeId: 'store-1',
        currentStep: OnboardingStep.tax,
        completedSteps: ['welcome', 'business_info'],
      );

      expect(progress.isStepCompleted('welcome'), true);
      expect(progress.isStepCompleted('business_info'), true);
      expect(progress.isStepCompleted('tax'), false);
      expect(progress.isStepCompleted('review'), false);
    });

    test('fromJson handles null current_step', () {
      final json = {'id': '1', 'store_id': 'store-1', 'completed_steps': []};

      final progress = OnboardingProgress.fromJson(json);
      expect(progress.currentStep, isNull);
    });

    test('fromJson handles invalid step gracefully', () {
      final json = {
        'id': '1',
        'store_id': 'store-1',
        'current_step': 'nonexistent_step',
        'completed_steps': ['welcome', 'invalid_step'],
      };

      final progress = OnboardingProgress.fromJson(json);
      expect(progress.currentStep, isNull); // tryFromValue returns null
      // completedSteps are stored as raw strings from JSON
      expect(progress.completedSteps, hasLength(2));
    });
  });

  group('OnboardingStep', () {
    test('fromValue parses all 8 steps', () {
      expect(OnboardingStep.fromValue('welcome'), OnboardingStep.welcome);
      expect(OnboardingStep.fromValue('business_info'), OnboardingStep.businessInfo);
      expect(OnboardingStep.fromValue('business_type'), OnboardingStep.businessType);
      expect(OnboardingStep.fromValue('tax'), OnboardingStep.tax);
      expect(OnboardingStep.fromValue('hardware'), OnboardingStep.hardware);
      expect(OnboardingStep.fromValue('products'), OnboardingStep.products);
      expect(OnboardingStep.fromValue('staff'), OnboardingStep.staff);
      expect(OnboardingStep.fromValue('review'), OnboardingStep.review);
    });

    test('fromValue throws for invalid step', () {
      expect(() => OnboardingStep.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null for invalid', () {
      expect(OnboardingStep.tryFromValue('nope'), isNull);
      expect(OnboardingStep.tryFromValue(null), isNull);
    });
  });
}
