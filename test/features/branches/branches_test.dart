import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/branches/enums/business_type.dart';
import 'package:thawani_pos/features/branches/enums/register_platform.dart';
import 'package:thawani_pos/features/branches/enums/provider_registration_status.dart';
import 'package:thawani_pos/features/branches/providers/branch_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('BusinessType', () {
    test('has correct values', () {
      expect(BusinessType.retail.value, 'retail');
      expect(BusinessType.restaurant.value, 'restaurant');
      expect(BusinessType.pharmacy.value, 'pharmacy');
      expect(BusinessType.grocery.value, 'grocery');
      expect(BusinessType.jewelry.value, 'jewelry');
      expect(BusinessType.mobileShop.value, 'mobile_shop');
      expect(BusinessType.flowerShop.value, 'flower_shop');
      expect(BusinessType.bakery.value, 'bakery');
      expect(BusinessType.service.value, 'service');
      expect(BusinessType.custom.value, 'custom');
    });

    test('has 10 values', () {
      expect(BusinessType.values.length, 10);
    });

    test('fromValue works for all values', () {
      for (final b in BusinessType.values) {
        expect(BusinessType.fromValue(b.value), b);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => BusinessType.fromValue('hotel'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(BusinessType.tryFromValue('spa'), isNull);
      expect(BusinessType.tryFromValue(null), isNull);
    });
  });

  group('RegisterPlatform', () {
    test('fromValue works for all values', () {
      for (final r in RegisterPlatform.values) {
        expect(RegisterPlatform.fromValue(r.value), r);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(RegisterPlatform.tryFromValue('unknown'), isNull);
    });
  });

  group('ProviderRegistrationStatus', () {
    test('fromValue works for all values', () {
      for (final s in ProviderRegistrationStatus.values) {
        expect(ProviderRegistrationStatus.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(ProviderRegistrationStatus.tryFromValue('xyz'), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE CLASSES
  // ════════════════════════════════════════════════════════

  group('BranchListState', () {
    test('BranchListInitial is a BranchListState', () {
      expect(const BranchListInitial(), isA<BranchListState>());
    });

    test('BranchListLoading is a BranchListState', () {
      expect(const BranchListLoading(), isA<BranchListState>());
    });

    test('BranchListLoaded holds branches', () {
      const state = BranchListLoaded([
        {'id': '1', 'name': 'Main Branch', 'is_main_branch': true},
        {'id': '2', 'name': 'Branch 2', 'is_main_branch': false},
      ]);
      expect(state.branches.length, 2);
      expect(state.branches.first['name'], 'Main Branch');
      expect(state.branches.first['is_main_branch'], true);
    });

    test('BranchListError holds message', () {
      const state = BranchListError('Failed to load branches');
      expect(state.message, 'Failed to load branches');
    });

    test('all states extend BranchListState', () {
      expect(const BranchListInitial(), isA<BranchListState>());
      expect(const BranchListLoading(), isA<BranchListState>());
      expect(const BranchListLoaded([]), isA<BranchListState>());
      expect(const BranchListError('err'), isA<BranchListState>());
    });
  });
}
