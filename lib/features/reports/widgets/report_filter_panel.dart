import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

/// Comprehensive filter panel with date presets, branch selector,
/// and advanced filter options. Responsive: collapsible on mobile.
class ReportFilterPanel extends ConsumerStatefulWidget {
  final ReportFilters filters;
  final ValueChanged<ReportFilters> onFiltersChanged;
  final VoidCallback onRefresh;

  /// Which filter sections to show — varies per report type.
  final bool showStaffFilter;
  final bool showCategoryFilter;
  final bool showPaymentMethodFilter;
  final bool showAmountRange;
  final bool showOrderStatus;
  final bool showGranularity;
  final bool showSortOptions;
  final bool showCompare;

  /// Available options for dropdowns (passed from page-level data).
  final List<DropdownOption> staffOptions;
  final List<DropdownOption> categoryOptions;

  const ReportFilterPanel({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
    required this.onRefresh,
    this.showStaffFilter = false,
    this.showCategoryFilter = false,
    this.showPaymentMethodFilter = false,
    this.showAmountRange = false,
    this.showOrderStatus = false,
    this.showGranularity = false,
    this.showSortOptions = false,
    this.showCompare = false,
    this.staffOptions = const [],
    this.categoryOptions = const [],
  });

  @override
  ConsumerState<ReportFilterPanel> createState() => _ReportFilterPanelState();
}

class _ReportFilterPanelState extends ConsumerState<ReportFilterPanel> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool _expanded = false;
  final _minCtrl = TextEditingController();
  final _maxCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.filters.minAmount != null) _minCtrl.text = widget.filters.minAmount.toString();
    if (widget.filters.maxAmount != null) _maxCtrl.text = widget.filters.maxAmount.toString();
  }

  @override
  void dispose() {
    _minCtrl.dispose();
    _maxCtrl.dispose();
    super.dispose();
  }

  bool get _hasAdvancedFilters {
    return widget.showStaffFilter ||
        widget.showCategoryFilter ||
        widget.showPaymentMethodFilter ||
        widget.showAmountRange ||
        widget.showOrderStatus ||
        widget.showGranularity ||
        widget.showSortOptions;
  }

  void _update(ReportFilters updated) => widget.onFiltersChanged(updated);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canSwitch = ref.watch(canSwitchBranchProvider);
    final branches = ref.watch(accessibleBranchIdsProvider);
    final isWide = MediaQuery.of(context).size.width > 600;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top bar: Date presets + Branch + Refresh ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: isWide ? _buildWideTopBar(isDark, canSwitch, branches) : _buildCompactTopBar(isDark, canSwitch, branches),
          ),

          // ── Advanced filter section (collapsible) ──
          if (_hasAdvancedFilters && _expanded) ...[
            Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
            Padding(
              padding: const EdgeInsets.all(16),
              child: isWide ? _buildWideAdvanced(isDark) : _buildCompactAdvanced(isDark),
            ),
          ],
        ],
      ),
    );
  }

  // ── Wide (desktop/tablet) top bar ──

  Widget _buildWideTopBar(bool isDark, bool canSwitch, List<String> branches) {
    return Row(
      children: [
        // Date presets
        Expanded(child: _buildDatePresets(isDark)),
        const SizedBox(width: 12),
        // Branch selector
        if (canSwitch && branches.length > 1) ...[
          SizedBox(width: 180, child: _buildBranchDropdown(isDark, branches)),
          const SizedBox(width: 12),
        ],
        // Expand/collapse button
        if (_hasAdvancedFilters) ...[_buildExpandButton(isDark), const SizedBox(width: 8)],
        // Compare toggle
        if (widget.showCompare) ...[_buildCompareToggle(isDark), const SizedBox(width: 8)],
        // Refresh button
        _buildRefreshButton(),
      ],
    );
  }

  // ── Compact (mobile) top bar ──

  Widget _buildCompactTopBar(bool isDark, bool canSwitch, List<String> branches) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Date presets row
        _buildDatePresets(isDark),
        const SizedBox(height: 8),
        Row(
          children: [
            if (canSwitch && branches.length > 1) ...[
              Expanded(child: _buildBranchDropdown(isDark, branches)),
              const SizedBox(width: 8),
            ],
            if (_hasAdvancedFilters) ...[_buildExpandButton(isDark), const SizedBox(width: 8)],
            if (widget.showCompare) ...[_buildCompareToggle(isDark), const SizedBox(width: 8)],
            _buildRefreshButton(),
          ],
        ),
      ],
    );
  }

  // ── Date Presets ──

  Widget _buildDatePresets(bool isDark) {
    final current = _detectCurrentPreset();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: DatePreset.values.map((preset) {
          final isActive = preset == current;
          return Padding(
            padding: const EdgeInsetsDirectional.only(end: 6),
            child: ChoiceChip(
              label: Text(preset.localizedLabel(l10n), style: TextStyle(fontSize: 12)),
              selected: isActive,
              onSelected: (_) => _selectPreset(preset),
              selectedColor: AppColors.primary.withValues(alpha: 0.15),
              labelStyle: TextStyle(
                color: isActive ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isActive
                    ? AppColors.primary.withValues(alpha: 0.3)
                    : (isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          );
        }).toList(),
      ),
    );
  }

  DatePreset? _detectCurrentPreset() {
    final range = widget.filters.dateRange;
    if (range == null) return null;
    for (final preset in DatePreset.values) {
      if (preset == DatePreset.custom) continue;
      final presetRange = preset.toDateRange();
      if (presetRange != null && _sameDay(presetRange.start, range.start) && _sameDay(presetRange.end, range.end)) {
        return preset;
      }
    }
    return DatePreset.custom;
  }

  bool _sameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _selectPreset(DatePreset preset) async {
    if (preset == DatePreset.custom) {
      final picked = await showPosDateRangePicker(
        context,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        initialDateRange: widget.filters.dateRange,
      );
      if (picked != null) {
        _update(widget.filters.copyWith(dateRange: () => picked));
      }
    } else {
      final range = preset.toDateRange();
      _update(widget.filters.copyWith(dateRange: () => range));
    }
  }

  // ── Branch Dropdown ──

  Widget _buildBranchDropdown(bool isDark, List<String> branches) {
    return PosSearchableDropdown<String?>(
      items: branches.map((id) => PosDropdownItem<String?>(value: id, label: id.substring(0, 8))).toList(),
      selectedValue: widget.filters.branchId,
      onChanged: (val) => _update(widget.filters.copyWith(branchId: () => val)),
      hint: l10n.reportAllBranches,
      prefixIcon: Icons.store_rounded,
      showSearch: true,
      clearable: true,
    );
  }

  // ── Expand/Collapse ──

  Widget _buildExpandButton(bool isDark) {
    final count = widget.filters.activeFilterCount;
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      borderRadius: AppRadius.borderSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: _expanded ? AppColors.primary.withValues(alpha: 0.1) : (isDark ? AppColors.cardDark : AppColors.backgroundLight),
          borderRadius: AppRadius.borderSm,
          border: Border.all(
            color: _expanded ? AppColors.primary.withValues(alpha: 0.3) : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.tune_rounded,
              size: 16,
              color: _expanded ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
            const SizedBox(width: 6),
            Text(
              l10n.reportFilters,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _expanded ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: AppRadius.borderMd),
                child: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(
              _expanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ],
        ),
      ),
    );
  }

  // ── Compare Toggle ──

  Widget _buildCompareToggle(bool isDark) {
    return FilterChip(
      label: Text(l10n.subscriptionCompare, style: TextStyle(fontSize: 12)),
      selected: widget.filters.compare,
      onSelected: (val) => _update(widget.filters.copyWith(compare: val)),
      selectedColor: AppColors.info.withValues(alpha: 0.15),
      checkmarkColor: AppColors.info,
      side: BorderSide(
        color: widget.filters.compare
            ? AppColors.info.withValues(alpha: 0.3)
            : (isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  // ── Refresh Button ──

  Widget _buildRefreshButton() {
    return IconButton.filled(
      onPressed: widget.onRefresh,
      icon: const Icon(Icons.refresh_rounded, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        minimumSize: const Size(40, 40),
      ),
    );
  }

  // ══════════ Advanced Filters ══════════

  Widget _buildWideAdvanced(bool isDark) {
    return Wrap(spacing: 12, runSpacing: 12, children: _buildAdvancedFilters(isDark));
  }

  Widget _buildCompactAdvanced(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: _buildAdvancedFilters(isDark)),
        const SizedBox(height: 12),
        Row(
          children: [
            const Spacer(),
            TextButton.icon(
              onPressed: _clearAdvancedFilters,
              icon: const Icon(Icons.clear_all_rounded, size: 16),
              label: Text(l10n.txClearFilters),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildAdvancedFilters(bool isDark) {
    final widgets = <Widget>[];

    if (widget.showGranularity) {
      widgets.add(_buildGranularitySelector(isDark));
    }
    if (widget.showStaffFilter && widget.staffOptions.isNotEmpty) {
      widgets.add(
        _buildDropdownFilter(
          isDark: isDark,
          icon: Icons.person_rounded,
          label: l10n.staff,
          value: widget.filters.staffId,
          options: widget.staffOptions,
          onChanged: (val) => _update(widget.filters.copyWith(staffId: () => val)),
        ),
      );
    }
    if (widget.showCategoryFilter && widget.categoryOptions.isNotEmpty) {
      widgets.add(
        _buildDropdownFilter(
          isDark: isDark,
          icon: Icons.category_rounded,
          label: l10n.category,
          value: widget.filters.categoryId,
          options: widget.categoryOptions,
          onChanged: (val) => _update(widget.filters.copyWith(categoryId: () => val)),
        ),
      );
    }
    if (widget.showPaymentMethodFilter) {
      widgets.add(
        _buildDropdownFilter(
          isDark: isDark,
          icon: Icons.payment_rounded,
          label: l10n.posPayment,
          value: widget.filters.paymentMethod,
          options: [
            DropdownOption(value: 'cash', label: l10n.filterCash),
            DropdownOption(value: 'card', label: l10n.card),
            DropdownOption(value: 'gift_card', label: l10n.filterGiftCard),
            DropdownOption(value: 'mobile', label: l10n.filterMobile),
            DropdownOption(value: 'bank_transfer', label: l10n.filterBankTransfer),
          ],
          onChanged: (val) => _update(widget.filters.copyWith(paymentMethod: () => val)),
        ),
      );
    }
    if (widget.showOrderStatus) {
      widgets.add(
        _buildDropdownFilter(
          isDark: isDark,
          icon: Icons.flag_rounded,
          label: l10n.status,
          value: widget.filters.orderStatus,
          options: [
            DropdownOption(value: 'completed', label: l10n.ordersCompleted),
            DropdownOption(value: 'refunded', label: l10n.filterRefunded),
            DropdownOption(value: 'partially_refunded', label: l10n.filterPartialRefund),
          ],
          onChanged: (val) => _update(widget.filters.copyWith(orderStatus: () => val)),
        ),
      );
    }
    if (widget.showAmountRange) {
      widgets.add(_buildAmountRange(isDark));
    }
    if (widget.showSortOptions) {
      widgets.add(_buildSortSelector(isDark));
    }
    return widgets;
  }

  Widget _buildGranularitySelector(bool isDark) {
    final current = widget.filters.granularity ?? 'daily';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: ['daily', 'weekly', 'monthly'].map((g) {
        final isActive = g == current;
        final label = g[0].toUpperCase() + g.substring(1);
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 4),
          child: ChoiceChip(
            label: Text(label, style: TextStyle(fontSize: 12)),
            selected: isActive,
            onSelected: (_) => _update(widget.filters.copyWith(granularity: () => g)),
            selectedColor: AppColors.primary.withValues(alpha: 0.15),
            side: BorderSide(
              color: isActive
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdownFilter({
    required bool isDark,
    required IconData icon,
    required String label,
    required String? value,
    required List<DropdownOption> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 200),
      child: PosSearchableDropdown<String?>(
        items: options.map((o) => PosDropdownItem<String?>(value: o.value, label: o.label)).toList(),
        selectedValue: value,
        onChanged: onChanged,
        hint: label,
        prefixIcon: icon,
        showSearch: true,
        clearable: true,
      ),
    );
  }

  Widget _buildAmountRange(bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 90,
          child: PosTextField(
            controller: _minCtrl,
            keyboardType: TextInputType.number,
            hint: l10n.filterMin,
            onSubmitted: (val) {
              final v = double.tryParse(val);
              _update(widget.filters.copyWith(minAmount: () => v));
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: Text('–', style: TextStyle(fontSize: 14)),
        ),
        SizedBox(
          width: 90,
          child: PosTextField(
            controller: _maxCtrl,
            keyboardType: TextInputType.number,
            hint: l10n.filterMax,
            onSubmitted: (val) {
              final v = double.tryParse(val);
              _update(widget.filters.copyWith(maxAmount: () => v));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortSelector(bool isDark) {
    final sortBy = widget.filters.sortBy ?? 'revenue';
    final sortDir = widget.filters.sortDir ?? 'desc';

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 150),
          child: PosSearchableDropdown<String>(
            items: [
              PosDropdownItem(value: 'revenue', label: l10n.reportsRevenue),
              PosDropdownItem(value: 'quantity', label: l10n.labelsQuantity),
              PosDropdownItem(value: 'profit', label: l10n.filterSortProfit),
              PosDropdownItem(value: 'orders', label: l10n.orders),
              PosDropdownItem(value: 'name', label: l10n.name),
            ],
            selectedValue: sortBy,
            onChanged: (val) => _update(widget.filters.copyWith(sortBy: () => val)),
            showSearch: false,
            clearable: false,
          ),
        ),
        const SizedBox(width: 4),
        IconButton(
          onPressed: () {
            final newDir = sortDir == 'desc' ? 'asc' : 'desc';
            _update(widget.filters.copyWith(sortDir: () => newDir));
          },
          icon: Icon(sortDir == 'desc' ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded, size: 18),
          style: IconButton.styleFrom(minimumSize: const Size(36, 36), foregroundColor: AppColors.primary),
        ),
      ],
    );
  }

  void _clearAdvancedFilters() {
    _minCtrl.clear();
    _maxCtrl.clear();
    _update(
      ReportFilters(dateRange: widget.filters.dateRange, branchId: widget.filters.branchId, compare: widget.filters.compare),
    );
  }
}

/// Simple dropdown option model.
class DropdownOption {
  final String value;
  final String label;

  const DropdownOption({required this.value, required this.label});
}
