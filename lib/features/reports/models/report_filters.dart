import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Unified filter model for all report pages.
class ReportFilters {
  final DateTimeRange? dateRange;
  final String? branchId;
  final String? staffId;
  final String? categoryId;
  final String? paymentMethod;
  final double? minAmount;
  final double? maxAmount;
  final String? orderStatus;
  final String? sortBy;
  final String? sortDir;
  final String? granularity;
  final String? productId;
  final int? limit;
  final bool compare;

  const ReportFilters({
    this.dateRange,
    this.branchId,
    this.staffId,
    this.categoryId,
    this.paymentMethod,
    this.minAmount,
    this.maxAmount,
    this.orderStatus,
    this.sortBy,
    this.sortDir,
    this.granularity,
    this.productId,
    this.limit,
    this.compare = false,
  });

  ReportFilters copyWith({
    DateTimeRange? Function()? dateRange,
    String? Function()? branchId,
    String? Function()? staffId,
    String? Function()? categoryId,
    String? Function()? paymentMethod,
    double? Function()? minAmount,
    double? Function()? maxAmount,
    String? Function()? orderStatus,
    String? Function()? sortBy,
    String? Function()? sortDir,
    String? Function()? granularity,
    String? Function()? productId,
    int? Function()? limit,
    bool? compare,
  }) {
    return ReportFilters(
      dateRange: dateRange != null ? dateRange() : this.dateRange,
      branchId: branchId != null ? branchId() : this.branchId,
      staffId: staffId != null ? staffId() : this.staffId,
      categoryId: categoryId != null ? categoryId() : this.categoryId,
      paymentMethod: paymentMethod != null ? paymentMethod() : this.paymentMethod,
      minAmount: minAmount != null ? minAmount() : this.minAmount,
      maxAmount: maxAmount != null ? maxAmount() : this.maxAmount,
      orderStatus: orderStatus != null ? orderStatus() : this.orderStatus,
      sortBy: sortBy != null ? sortBy() : this.sortBy,
      sortDir: sortDir != null ? sortDir() : this.sortDir,
      granularity: granularity != null ? granularity() : this.granularity,
      productId: productId != null ? productId() : this.productId,
      limit: limit != null ? limit() : this.limit,
      compare: compare ?? this.compare,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (dateRange != null) {
      params['date_from'] = _fmtDate(dateRange!.start);
      params['date_to'] = _fmtDate(dateRange!.end);
    }
    if (branchId != null) params['branch_id'] = branchId;
    if (staffId != null) params['staff_id'] = staffId;
    if (categoryId != null) params['category_id'] = categoryId;
    if (paymentMethod != null) params['payment_method'] = paymentMethod;
    if (minAmount != null) params['min_amount'] = minAmount;
    if (maxAmount != null) params['max_amount'] = maxAmount;
    if (orderStatus != null) params['order_status'] = orderStatus;
    if (sortBy != null) params['sort_by'] = sortBy;
    if (sortDir != null) params['sort_dir'] = sortDir;
    if (granularity != null) params['granularity'] = granularity;
    if (productId != null) params['product_id'] = productId;
    if (limit != null) params['limit'] = limit;
    if (compare) params['compare'] = '1';
    return params;
  }

  String? get dateFromStr => dateRange != null ? _fmtDate(dateRange!.start) : null;
  String? get dateToStr => dateRange != null ? _fmtDate(dateRange!.end) : null;

  bool get hasAdvancedFilters =>
      staffId != null ||
      paymentMethod != null ||
      minAmount != null ||
      maxAmount != null ||
      orderStatus != null ||
      (granularity != null && granularity != 'daily');

  int get activeFilterCount {
    int count = 0;
    if (dateRange != null) count++;
    if (branchId != null) count++;
    if (staffId != null) count++;
    if (categoryId != null) count++;
    if (paymentMethod != null) count++;
    if (minAmount != null || maxAmount != null) count++;
    if (orderStatus != null) count++;
    if (granularity != null && granularity != 'daily') count++;
    return count;
  }

  static String _fmtDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

/// Date presets for quick selection.
enum DatePreset {
  today('Today'),
  yesterday('Yesterday'),
  last7Days('Last 7 Days'),
  last30Days('Last 30 Days'),
  thisMonth('This Month'),
  lastMonth('Last Month'),
  thisQuarter('This Quarter'),
  custom('Custom');

  final String label;
  const DatePreset(this.label);

  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      DatePreset.today => l10n.presetToday,
      DatePreset.yesterday => l10n.presetYesterday,
      DatePreset.last7Days => l10n.presetLast7Days,
      DatePreset.last30Days => l10n.presetLast30Days,
      DatePreset.thisMonth => l10n.presetThisMonth,
      DatePreset.lastMonth => l10n.presetLastMonth,
      DatePreset.thisQuarter => l10n.presetThisQuarter,
      DatePreset.custom => l10n.presetCustom,
    };
  }

  DateTimeRange? toDateRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return switch (this) {
      DatePreset.today => DateTimeRange(start: today, end: today),
      DatePreset.yesterday => DateTimeRange(
        start: today.subtract(const Duration(days: 1)),
        end: today.subtract(const Duration(days: 1)),
      ),
      DatePreset.last7Days => DateTimeRange(start: today.subtract(const Duration(days: 6)), end: today),
      DatePreset.last30Days => DateTimeRange(start: today.subtract(const Duration(days: 29)), end: today),
      DatePreset.thisMonth => DateTimeRange(start: DateTime(now.year, now.month, 1), end: today),
      DatePreset.lastMonth => DateTimeRange(start: DateTime(now.year, now.month - 1, 1), end: DateTime(now.year, now.month, 0)),
      DatePreset.thisQuarter => DateTimeRange(start: DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1), end: today),
      DatePreset.custom => null,
    };
  }
}
