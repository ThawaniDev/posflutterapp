// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // toQueryParams()
  // ═══════════════════════════════════════════════════════════

  group('ReportFilters.toQueryParams()', () {
    test('empty filters returns empty map', () {
      const filters = ReportFilters();
      expect(filters.toQueryParams(), isEmpty);
    });

    test('dateRange serialises to date_from and date_to in yyyy-MM-dd', () {
      final filters = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 1, 7), end: DateTime(2024, 1, 31)),
      );

      final params = filters.toQueryParams();

      expect(params['date_from'], '2024-01-07');
      expect(params['date_to'], '2024-01-31');
    });

    test('single-digit month and day are zero-padded', () {
      final filters = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 3, 5), end: DateTime(2024, 9, 1)),
      );

      final params = filters.toQueryParams();

      expect(params['date_from'], '2024-03-05');
      expect(params['date_to'], '2024-09-01');
    });

    test('branchId serialises to branch_id', () {
      const filters = ReportFilters(branchId: 'branch-42');
      expect(filters.toQueryParams()['branch_id'], 'branch-42');
    });

    test('staffId serialises to staff_id', () {
      const filters = ReportFilters(staffId: 'staff-99');
      expect(filters.toQueryParams()['staff_id'], 'staff-99');
    });

    test('categoryId serialises to category_id', () {
      const filters = ReportFilters(categoryId: 'cat-7');
      expect(filters.toQueryParams()['category_id'], 'cat-7');
    });

    test('paymentMethod serialises to payment_method', () {
      const filters = ReportFilters(paymentMethod: 'card');
      expect(filters.toQueryParams()['payment_method'], 'card');
    });

    test('minAmount serialises to min_amount', () {
      const filters = ReportFilters(minAmount: 100.0);
      expect(filters.toQueryParams()['min_amount'], 100.0);
    });

    test('maxAmount serialises to max_amount', () {
      const filters = ReportFilters(maxAmount: 999.99);
      expect(filters.toQueryParams()['max_amount'], 999.99);
    });

    test('orderStatus serialises to order_status', () {
      const filters = ReportFilters(orderStatus: 'completed');
      expect(filters.toQueryParams()['order_status'], 'completed');
    });

    test('orderSource serialises to order_source', () {
      const filters = ReportFilters(orderSource: 'delivery');
      expect(filters.toQueryParams()['order_source'], 'delivery');
    });

    test('sortBy serialises to sort_by', () {
      const filters = ReportFilters(sortBy: 'total_revenue');
      expect(filters.toQueryParams()['sort_by'], 'total_revenue');
    });

    test('sortDir serialises to sort_dir', () {
      const filters = ReportFilters(sortDir: 'desc');
      expect(filters.toQueryParams()['sort_dir'], 'desc');
    });

    test('granularity serialises to granularity', () {
      const filters = ReportFilters(granularity: 'weekly');
      expect(filters.toQueryParams()['granularity'], 'weekly');
    });

    test('productId serialises to product_id', () {
      const filters = ReportFilters(productId: 'prod-123');
      expect(filters.toQueryParams()['product_id'], 'prod-123');
    });

    test('limit serialises to limit', () {
      const filters = ReportFilters(limit: 10);
      expect(filters.toQueryParams()['limit'], 10);
    });

    test('compare=true serialises compare to string "1"', () {
      const filters = ReportFilters(compare: true);
      expect(filters.toQueryParams()['compare'], '1');
    });

    test('compare=false does NOT include compare key', () {
      const filters = ReportFilters(compare: false);
      expect(filters.toQueryParams().containsKey('compare'), isFalse);
    });

    test('null fields are omitted from params', () {
      const filters = ReportFilters(granularity: 'daily');
      final params = filters.toQueryParams();

      expect(params.containsKey('branch_id'), isFalse);
      expect(params.containsKey('staff_id'), isFalse);
      expect(params.containsKey('category_id'), isFalse);
      expect(params.containsKey('payment_method'), isFalse);
      expect(params.containsKey('min_amount'), isFalse);
      expect(params.containsKey('max_amount'), isFalse);
      expect(params.containsKey('order_status'), isFalse);
      expect(params.containsKey('order_source'), isFalse);
      expect(params.containsKey('date_from'), isFalse);
      expect(params.containsKey('date_to'), isFalse);
    });

    test('all fields set produces correct param count', () {
      final filters = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 6, 1), end: DateTime(2024, 6, 30)),
        branchId: 'br-1',
        staffId: 'st-1',
        categoryId: 'cat-1',
        paymentMethod: 'cash',
        minAmount: 50.0,
        maxAmount: 500.0,
        orderStatus: 'completed',
        orderSource: 'pos',
        sortBy: 'revenue',
        sortDir: 'desc',
        granularity: 'monthly',
        productId: 'prod-1',
        limit: 20,
        compare: true,
      );

      final params = filters.toQueryParams();

      // 2 (date) + 1 branchId + 1 staffId + 1 categoryId + 1 payment + 1 min + 1 max +
      // 1 orderStatus + 1 orderSource + 1 sortBy + 1 sortDir + 1 granularity + 1 productId +
      // 1 limit + 1 compare = 16
      expect(params.length, 16);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // dateFromStr / dateToStr
  // ═══════════════════════════════════════════════════════════

  group('dateFromStr / dateToStr', () {
    test('returns null when no dateRange', () {
      const filters = ReportFilters();
      expect(filters.dateFromStr, isNull);
      expect(filters.dateToStr, isNull);
    });

    test('returns formatted strings when dateRange is set', () {
      final filters = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 11, 5), end: DateTime(2024, 11, 25)),
      );

      expect(filters.dateFromStr, '2024-11-05');
      expect(filters.dateToStr, '2024-11-25');
    });
  });

  // ═══════════════════════════════════════════════════════════
  // activeFilterCount
  // ═══════════════════════════════════════════════════════════

  group('activeFilterCount', () {
    test('zero for empty filters', () {
      expect(const ReportFilters().activeFilterCount, 0);
    });

    test('dateRange counts as 1', () {
      final f = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31)),
      );
      expect(f.activeFilterCount, 1);
    });

    test('branchId counts as 1', () {
      expect(const ReportFilters(branchId: 'br-1').activeFilterCount, 1);
    });

    test('staffId counts as 1', () {
      expect(const ReportFilters(staffId: 'st-1').activeFilterCount, 1);
    });

    test('categoryId counts as 1', () {
      expect(const ReportFilters(categoryId: 'cat-1').activeFilterCount, 1);
    });

    test('paymentMethod counts as 1', () {
      expect(const ReportFilters(paymentMethod: 'cash').activeFilterCount, 1);
    });

    test('minAmount alone counts as 1', () {
      expect(const ReportFilters(minAmount: 50.0).activeFilterCount, 1);
    });

    test('maxAmount alone counts as 1', () {
      expect(const ReportFilters(maxAmount: 500.0).activeFilterCount, 1);
    });

    test('minAmount + maxAmount combined count as 1 (not 2)', () {
      expect(const ReportFilters(minAmount: 50.0, maxAmount: 500.0).activeFilterCount, 1);
    });

    test('orderStatus counts as 1', () {
      expect(const ReportFilters(orderStatus: 'completed').activeFilterCount, 1);
    });

    test('orderSource counts as 1', () {
      expect(const ReportFilters(orderSource: 'delivery').activeFilterCount, 1);
    });

    test('granularity=weekly counts as 1 (non-daily)', () {
      expect(const ReportFilters(granularity: 'weekly').activeFilterCount, 1);
    });

    test('granularity=monthly counts as 1 (non-daily)', () {
      expect(const ReportFilters(granularity: 'monthly').activeFilterCount, 1);
    });

    test('granularity=daily does NOT count', () {
      expect(const ReportFilters(granularity: 'daily').activeFilterCount, 0);
    });

    test('sortBy does NOT count', () {
      expect(const ReportFilters(sortBy: 'revenue').activeFilterCount, 0);
    });

    test('sortDir does NOT count', () {
      expect(const ReportFilters(sortDir: 'desc').activeFilterCount, 0);
    });

    test('productId does NOT count', () {
      expect(const ReportFilters(productId: 'prod-1').activeFilterCount, 0);
    });

    test('limit does NOT count', () {
      expect(const ReportFilters(limit: 10).activeFilterCount, 0);
    });

    test('compare does NOT count', () {
      expect(const ReportFilters(compare: true).activeFilterCount, 0);
    });

    test('all counted fields yield correct total', () {
      final f = ReportFilters(
        dateRange: DateTimeRange(start: DateTime(2024, 1, 1), end: DateTime(2024, 1, 31)),
        branchId: 'br-1',
        staffId: 'st-1',
        categoryId: 'cat-1',
        paymentMethod: 'cash',
        minAmount: 50.0,
        maxAmount: 500.0,
        orderStatus: 'completed',
        orderSource: 'delivery',
        granularity: 'weekly',
      );

      // date(1) + branch(1) + staff(1) + category(1) + payment(1) +
      // amount range(1) + orderStatus(1) + orderSource(1) + granularity(1) = 9
      expect(f.activeFilterCount, 9);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // hasAdvancedFilters
  // ═══════════════════════════════════════════════════════════

  group('hasAdvancedFilters', () {
    test('false for empty filters', () {
      expect(const ReportFilters().hasAdvancedFilters, isFalse);
    });

    test('true when staffId set', () {
      expect(const ReportFilters(staffId: 'st-1').hasAdvancedFilters, isTrue);
    });

    test('true when paymentMethod set', () {
      expect(const ReportFilters(paymentMethod: 'cash').hasAdvancedFilters, isTrue);
    });

    test('true when minAmount set', () {
      expect(const ReportFilters(minAmount: 50.0).hasAdvancedFilters, isTrue);
    });

    test('true when maxAmount set', () {
      expect(const ReportFilters(maxAmount: 500.0).hasAdvancedFilters, isTrue);
    });

    test('true when orderStatus set', () {
      expect(const ReportFilters(orderStatus: 'completed').hasAdvancedFilters, isTrue);
    });

    test('true when granularity is non-daily', () {
      expect(const ReportFilters(granularity: 'weekly').hasAdvancedFilters, isTrue);
    });

    test('false when granularity=daily', () {
      expect(const ReportFilters(granularity: 'daily').hasAdvancedFilters, isFalse);
    });

    test('branchId alone does NOT trigger hasAdvancedFilters', () {
      expect(const ReportFilters(branchId: 'br-1').hasAdvancedFilters, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // copyWith()
  // ═══════════════════════════════════════════════════════════

  group('ReportFilters.copyWith()', () {
    final base = ReportFilters(
      branchId: 'br-1',
      staffId: 'st-1',
      categoryId: 'cat-1',
      paymentMethod: 'cash',
      granularity: 'monthly',
      limit: 20,
      compare: true,
    );

    test('unchanged fields are preserved', () {
      final copy = base.copyWith(granularity: () => 'weekly');
      expect(copy.branchId, 'br-1');
      expect(copy.staffId, 'st-1');
      expect(copy.categoryId, 'cat-1');
      expect(copy.paymentMethod, 'cash');
      expect(copy.limit, 20);
      expect(copy.compare, isTrue);
    });

    test('can override granularity', () {
      final copy = base.copyWith(granularity: () => 'weekly');
      expect(copy.granularity, 'weekly');
    });

    test('can clear branchId by setting it to null via callback', () {
      final copy = base.copyWith(branchId: () => null);
      expect(copy.branchId, isNull);
    });

    test('can update compare flag', () {
      final copy = base.copyWith(compare: false);
      expect(copy.compare, isFalse);
    });

    test('can update limit', () {
      final copy = base.copyWith(limit: () => 50);
      expect(copy.limit, 50);
    });

    test('can add dateRange to previously empty filter', () {
      final range = DateTimeRange(start: DateTime(2024, 6, 1), end: DateTime(2024, 6, 30));
      final copy = const ReportFilters().copyWith(dateRange: () => range);
      expect(copy.dateRange, range);
    });

    test('can clear dateRange', () {
      final range = DateTimeRange(start: DateTime(2024, 6, 1), end: DateTime(2024, 6, 30));
      final withDate = ReportFilters(dateRange: range);
      final cleared = withDate.copyWith(dateRange: () => null);
      expect(cleared.dateRange, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // DatePreset.toDateRange()
  // ═══════════════════════════════════════════════════════════

  group('DatePreset.toDateRange()', () {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    test('today preset covers today', () {
      final range = DatePreset.today.toDateRange()!;
      expect(range.start, today);
      expect(range.end, today);
    });

    test('yesterday preset covers yesterday', () {
      final range = DatePreset.yesterday.toDateRange()!;
      final yesterday = today.subtract(const Duration(days: 1));
      expect(range.start, yesterday);
      expect(range.end, yesterday);
    });

    test('last7Days preset covers 7 days ending today', () {
      final range = DatePreset.last7Days.toDateRange()!;
      expect(range.end, today);
      expect(range.start, today.subtract(const Duration(days: 6)));
    });

    test('last30Days preset covers 30 days ending today', () {
      final range = DatePreset.last30Days.toDateRange()!;
      expect(range.end, today);
      expect(range.start, today.subtract(const Duration(days: 29)));
    });

    test('thisMonth preset starts on the 1st of current month', () {
      final range = DatePreset.thisMonth.toDateRange()!;
      expect(range.start, DateTime(now.year, now.month, 1));
      expect(range.end, today);
    });

    test('custom preset returns null', () {
      expect(DatePreset.custom.toDateRange(), isNull);
    });

    test('all non-custom presets return non-null range', () {
      for (final preset in DatePreset.values) {
        if (preset == DatePreset.custom) continue;
        expect(preset.toDateRange(), isNotNull, reason: '${preset.name} should return a range');
      }
    });
  });
}
