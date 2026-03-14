import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  //  P7 API Endpoints
  // ═══════════════════════════════════════════════════════════════

  group('P7 API Endpoints - Feature Flags', () {
    test('adminFeatureFlags endpoint is correct', () {
      expect(ApiEndpoints.adminFeatureFlags, '/admin/feature-flags');
    });

    test('adminFeatureFlagById returns correct path', () {
      expect(ApiEndpoints.adminFeatureFlagById('abc-123'), '/admin/feature-flags/abc-123');
    });

    test('adminFeatureFlagToggle returns correct path', () {
      expect(ApiEndpoints.adminFeatureFlagToggle('abc-123'), '/admin/feature-flags/abc-123/toggle');
    });
  });

  group('P7 API Endpoints - A/B Tests', () {
    test('adminABTests endpoint is correct', () {
      expect(ApiEndpoints.adminABTests, '/admin/ab-tests');
    });

    test('adminABTestById returns correct path', () {
      expect(ApiEndpoints.adminABTestById('test-1'), '/admin/ab-tests/test-1');
    });

    test('adminABTestStart returns correct path', () {
      expect(ApiEndpoints.adminABTestStart('test-1'), '/admin/ab-tests/test-1/start');
    });

    test('adminABTestStop returns correct path', () {
      expect(ApiEndpoints.adminABTestStop('test-1'), '/admin/ab-tests/test-1/stop');
    });

    test('adminABTestResults returns correct path', () {
      expect(ApiEndpoints.adminABTestResults('test-1'), '/admin/ab-tests/test-1/results');
    });

    test('adminABTestVariants returns correct path', () {
      expect(ApiEndpoints.adminABTestVariants('test-1'), '/admin/ab-tests/test-1/variants');
    });

    test('adminABTestVariantById returns correct path', () {
      expect(ApiEndpoints.adminABTestVariantById('test-1', 'var-a'), '/admin/ab-tests/test-1/variants/var-a');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - FeatureFlagListState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - FeatureFlagListState', () {
    test('FeatureFlagListInitial is correct type', () {
      const state = FeatureFlagListInitial();
      expect(state, isA<FeatureFlagListState>());
    });

    test('FeatureFlagListLoading is correct type', () {
      const state = FeatureFlagListLoading();
      expect(state, isA<FeatureFlagListState>());
    });

    test('FeatureFlagListLoaded holds all fields', () {
      const state = FeatureFlagListLoaded(
        flags: [
          {'flag_key': 'new_checkout', 'is_enabled': true},
          {'flag_key': 'dark_mode', 'is_enabled': false},
        ],
        total: 2,
      );
      expect(state.flags.length, 2);
      expect(state.total, 2);
      expect(state.flags[0]['flag_key'], 'new_checkout');
    });

    test('FeatureFlagListError holds message', () {
      const state = FeatureFlagListError('Network error');
      expect(state.message, 'Network error');
    });

    test('FeatureFlagListState sealed class pattern matching', () {
      const FeatureFlagListState state = FeatureFlagListLoaded(
        flags: [
          {'flag_key': 'test'},
        ],
        total: 1,
      );
      final result = switch (state) {
        FeatureFlagListInitial() => 'initial',
        FeatureFlagListLoading() => 'loading',
        FeatureFlagListLoaded() => 'loaded',
        FeatureFlagListError() => 'error',
      };
      expect(result, 'loaded');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - FeatureFlagDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - FeatureFlagDetailState', () {
    test('FeatureFlagDetailInitial is correct type', () {
      expect(const FeatureFlagDetailInitial(), isA<FeatureFlagDetailState>());
    });

    test('FeatureFlagDetailLoading is correct type', () {
      expect(const FeatureFlagDetailLoading(), isA<FeatureFlagDetailState>());
    });

    test('FeatureFlagDetailLoaded holds flag and abTests', () {
      const state = FeatureFlagDetailLoaded(
        flag: {'flag_key': 'shown', 'is_enabled': true},
        abTests: [
          {'name': 'Test A', 'status': 'running'},
        ],
      );
      expect(state.flag['flag_key'], 'shown');
      expect(state.abTests.length, 1);
      expect(state.abTests[0]['name'], 'Test A');
    });

    test('FeatureFlagDetailError holds message', () {
      const state = FeatureFlagDetailError('Not found');
      expect(state.message, 'Not found');
    });

    test('FeatureFlagDetailState sealed class pattern matching', () {
      const FeatureFlagDetailState state = FeatureFlagDetailError('err');
      final result = switch (state) {
        FeatureFlagDetailInitial() => 'initial',
        FeatureFlagDetailLoading() => 'loading',
        FeatureFlagDetailLoaded() => 'loaded',
        FeatureFlagDetailError() => 'error',
      };
      expect(result, 'error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - FeatureFlagActionState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - FeatureFlagActionState', () {
    test('FeatureFlagActionInitial is correct type', () {
      expect(const FeatureFlagActionInitial(), isA<FeatureFlagActionState>());
    });

    test('FeatureFlagActionLoading is correct type', () {
      expect(const FeatureFlagActionLoading(), isA<FeatureFlagActionState>());
    });

    test('FeatureFlagActionSuccess holds message', () {
      const state = FeatureFlagActionSuccess('Created!');
      expect(state.message, 'Created!');
    });

    test('FeatureFlagActionError holds message', () {
      const state = FeatureFlagActionError('Failed');
      expect(state.message, 'Failed');
    });

    test('FeatureFlagActionState pattern matching covers all cases', () {
      const FeatureFlagActionState state = FeatureFlagActionSuccess('ok');
      final result = switch (state) {
        FeatureFlagActionInitial() => 'initial',
        FeatureFlagActionLoading() => 'loading',
        FeatureFlagActionSuccess() => 'success',
        FeatureFlagActionError() => 'error',
      };
      expect(result, 'success');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - ABTestListState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - ABTestListState', () {
    test('ABTestListInitial is correct type', () {
      expect(const ABTestListInitial(), isA<ABTestListState>());
    });

    test('ABTestListLoading is correct type', () {
      expect(const ABTestListLoading(), isA<ABTestListState>());
    });

    test('ABTestListLoaded holds all fields', () {
      const state = ABTestListLoaded(
        tests: [
          {'name': 'Color Test', 'status': 'running'},
          {'name': 'Layout Test', 'status': 'draft'},
        ],
        total: 10,
        currentPage: 1,
        lastPage: 2,
      );
      expect(state.tests.length, 2);
      expect(state.total, 10);
      expect(state.currentPage, 1);
      expect(state.lastPage, 2);
    });

    test('ABTestListError holds message', () {
      const state = ABTestListError('Server error');
      expect(state.message, 'Server error');
    });

    test('ABTestListState sealed class pattern matching', () {
      const ABTestListState state = ABTestListLoading();
      final result = switch (state) {
        ABTestListInitial() => 'initial',
        ABTestListLoading() => 'loading',
        ABTestListLoaded() => 'loaded',
        ABTestListError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - ABTestDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - ABTestDetailState', () {
    test('ABTestDetailInitial is correct type', () {
      expect(const ABTestDetailInitial(), isA<ABTestDetailState>());
    });

    test('ABTestDetailLoading is correct type', () {
      expect(const ABTestDetailLoading(), isA<ABTestDetailState>());
    });

    test('ABTestDetailLoaded holds test and variants', () {
      const state = ABTestDetailLoaded(
        test: {'name': 'Color Test', 'status': 'running', 'traffic_percentage': 80},
        variants: [
          {'variant_key': 'control', 'weight': 50, 'is_control': true},
          {'variant_key': 'treatment', 'weight': 50, 'is_control': false},
        ],
      );
      expect(state.test['name'], 'Color Test');
      expect(state.variants.length, 2);
      expect(state.variants[0]['is_control'], true);
    });

    test('ABTestDetailError holds message', () {
      const state = ABTestDetailError('Not found');
      expect(state.message, 'Not found');
    });

    test('ABTestDetailState sealed class pattern matching', () {
      const ABTestDetailState state = ABTestDetailInitial();
      final result = switch (state) {
        ABTestDetailInitial() => 'initial',
        ABTestDetailLoading() => 'loading',
        ABTestDetailLoaded() => 'loaded',
        ABTestDetailError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - ABTestResultsState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - ABTestResultsState', () {
    test('ABTestResultsInitial is correct type', () {
      expect(const ABTestResultsInitial(), isA<ABTestResultsState>());
    });

    test('ABTestResultsLoading is correct type', () {
      expect(const ABTestResultsLoading(), isA<ABTestResultsState>());
    });

    test('ABTestResultsLoaded holds all fields', () {
      const state = ABTestResultsLoaded(
        test: {'name': 'Completed Test'},
        results: [
          {'variant_key': 'control', 'conversion_rate': 12.5},
          {'variant_key': 'treatment', 'conversion_rate': 15.3},
        ],
        winner: 'treatment',
        confidence: 0.95,
      );
      expect(state.test['name'], 'Completed Test');
      expect(state.results.length, 2);
      expect(state.winner, 'treatment');
      expect(state.confidence, 0.95);
    });

    test('ABTestResultsLoaded with no winner', () {
      const state = ABTestResultsLoaded(test: {'name': 'Running Test'}, results: [], winner: null, confidence: 0.0);
      expect(state.winner, isNull);
      expect(state.confidence, 0.0);
    });

    test('ABTestResultsError holds message', () {
      const state = ABTestResultsError('Failed');
      expect(state.message, 'Failed');
    });

    test('ABTestResultsState sealed class pattern matching', () {
      const ABTestResultsState state = ABTestResultsLoaded(test: {}, results: [], winner: null, confidence: 0.0);
      final result = switch (state) {
        ABTestResultsInitial() => 'initial',
        ABTestResultsLoading() => 'loading',
        ABTestResultsLoaded() => 'loaded',
        ABTestResultsError() => 'error',
      };
      expect(result, 'loaded');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 State - ABTestActionState
  // ═══════════════════════════════════════════════════════════════

  group('P7 State - ABTestActionState', () {
    test('ABTestActionInitial is correct type', () {
      expect(const ABTestActionInitial(), isA<ABTestActionState>());
    });

    test('ABTestActionLoading is correct type', () {
      expect(const ABTestActionLoading(), isA<ABTestActionState>());
    });

    test('ABTestActionSuccess holds message', () {
      const state = ABTestActionSuccess('Test started');
      expect(state.message, 'Test started');
    });

    test('ABTestActionError holds message', () {
      const state = ABTestActionError('Cannot start');
      expect(state.message, 'Cannot start');
    });

    test('ABTestActionState pattern matching covers all cases', () {
      const ABTestActionState state = ABTestActionLoading();
      final result = switch (state) {
        ABTestActionInitial() => 'initial',
        ABTestActionLoading() => 'loading',
        ABTestActionSuccess() => 'success',
        ABTestActionError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 Endpoint Integrity
  // ═══════════════════════════════════════════════════════════════

  group('P7 Endpoint Integrity', () {
    test('all feature flag endpoints start with /admin/feature-flags', () {
      expect(ApiEndpoints.adminFeatureFlags, startsWith('/admin/feature-flags'));
      expect(ApiEndpoints.adminFeatureFlagById('x'), startsWith('/admin/feature-flags'));
      expect(ApiEndpoints.adminFeatureFlagToggle('x'), startsWith('/admin/feature-flags'));
    });

    test('all A/B test endpoints start with /admin/ab-tests', () {
      expect(ApiEndpoints.adminABTests, startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestById('x'), startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestStart('x'), startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestStop('x'), startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestResults('x'), startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestVariants('x'), startsWith('/admin/ab-tests'));
      expect(ApiEndpoints.adminABTestVariantById('x', 'y'), startsWith('/admin/ab-tests'));
    });

    test('dynamic endpoints include provided IDs', () {
      expect(ApiEndpoints.adminFeatureFlagById('flag-uuid'), contains('flag-uuid'));
      expect(ApiEndpoints.adminABTestById('test-uuid'), contains('test-uuid'));
      expect(ApiEndpoints.adminABTestVariantById('test-uuid', 'var-uuid'), contains('var-uuid'));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 Data Shape Validation
  // ═══════════════════════════════════════════════════════════════

  group('P7 Data Shape Validation', () {
    test('FeatureFlagListLoaded with empty flags', () {
      const state = FeatureFlagListLoaded(flags: [], total: 0);
      expect(state.flags, isEmpty);
      expect(state.total, 0);
    });

    test('FeatureFlagDetailLoaded with empty abTests', () {
      const state = FeatureFlagDetailLoaded(flag: {'flag_key': 'solo'}, abTests: []);
      expect(state.abTests, isEmpty);
    });

    test('ABTestListLoaded single page result', () {
      const state = ABTestListLoaded(
        tests: [
          {'name': 'Only'},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.currentPage, state.lastPage);
    });

    test('ABTestDetailLoaded with many variants', () {
      const state = ABTestDetailLoaded(
        test: {'name': 'Multi Variant'},
        variants: [
          {'variant_key': 'a', 'weight': 25},
          {'variant_key': 'b', 'weight': 25},
          {'variant_key': 'c', 'weight': 25},
          {'variant_key': 'd', 'weight': 25},
        ],
      );
      expect(state.variants.length, 4);
    });

    test('ABTestResultsLoaded with rich result data', () {
      const state = ABTestResultsLoaded(
        test: {'name': 'Rich Results', 'status': 'completed'},
        results: [
          {'variant_key': 'control', 'is_control': true, 'impressions': 5000, 'conversions': 250, 'conversion_rate': 5.0},
          {'variant_key': 'treatment', 'is_control': false, 'impressions': 5000, 'conversions': 350, 'conversion_rate': 7.0},
        ],
        winner: 'treatment',
        confidence: 0.98,
      );
      expect(state.results[0]['impressions'], 5000);
      expect(state.results[1]['conversion_rate'], 7.0);
      expect(state.confidence, greaterThan(0.95));
    });

    test('FeatureFlagListLoaded flags contain expected keys', () {
      const state = FeatureFlagListLoaded(
        flags: [
          {
            'id': 'uuid-1',
            'flag_key': 'dark_mode',
            'is_enabled': true,
            'rollout_percentage': 50,
            'description': 'Dark mode toggle',
            'target_plan_ids': ['plan-1'],
            'target_store_ids': null,
          },
        ],
        total: 1,
      );
      final flag = state.flags[0];
      expect(flag.containsKey('flag_key'), true);
      expect(flag.containsKey('is_enabled'), true);
      expect(flag.containsKey('rollout_percentage'), true);
      expect(flag['target_plan_ids'], isA<List>());
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P7 Edge Cases
  // ═══════════════════════════════════════════════════════════════

  group('P7 Edge Cases', () {
    test('FeatureFlagActionSuccess and Error have consistent shape', () {
      const success = FeatureFlagActionSuccess('ok');
      const error = FeatureFlagActionError('fail');
      expect(success.message, isNotEmpty);
      expect(error.message, isNotEmpty);
    });

    test('ABTestActionSuccess and Error have consistent shape', () {
      const success = ABTestActionSuccess('started');
      const error = ABTestActionError('cannot start');
      expect(success.message, isNotEmpty);
      expect(error.message, isNotEmpty);
    });

    test('ABTestResultsLoaded confidence range is valid', () {
      const state = ABTestResultsLoaded(test: {}, results: [], confidence: 0.5);
      expect(state.confidence, greaterThanOrEqualTo(0.0));
      expect(state.confidence, lessThanOrEqualTo(1.0));
    });

    test('multiple feature flags with different states', () {
      const state = FeatureFlagListLoaded(
        flags: [
          {'flag_key': 'enabled_full', 'is_enabled': true, 'rollout_percentage': 100},
          {'flag_key': 'enabled_partial', 'is_enabled': true, 'rollout_percentage': 25},
          {'flag_key': 'disabled', 'is_enabled': false, 'rollout_percentage': 0},
        ],
        total: 3,
      );
      final enabled = state.flags.where((f) => f['is_enabled'] == true).toList();
      expect(enabled.length, 2);
    });

    test('ABTestListLoaded with multiple pages', () {
      const state = ABTestListLoaded(
        tests: [
          {'name': 'T1'},
          {'name': 'T2'},
        ],
        total: 50,
        currentPage: 3,
        lastPage: 10,
      );
      expect(state.currentPage, lessThanOrEqualTo(state.lastPage));
      expect(state.tests.length, lessThanOrEqualTo(state.total));
    });
  });
}
