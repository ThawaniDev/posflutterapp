import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/pos_card.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

class CommissionSummaryPage extends ConsumerStatefulWidget {
  final String staffId;
  final String staffName;

  const CommissionSummaryPage({super.key, required this.staffId, required this.staffName});

  @override
  ConsumerState<CommissionSummaryPage> createState() => _CommissionSummaryPageState();
}

class _CommissionSummaryPageState extends ConsumerState<CommissionSummaryPage> {
  DateTimeRange? _dateRange;
  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _currencyFormat = NumberFormat.currency(symbol: '\u0081 ');

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  void _load() {
    ref
        .read(commissionProvider(widget.staffId).notifier)
        .load(
          dateFrom: _dateRange != null ? _dateFormat.format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? _dateFormat.format(_dateRange!.end) : null,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(commissionProvider(widget.staffId));
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: '${widget.staffName} - ${l10n.staffCommissions}',
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.date_range,
          tooltip: l10n.staffFilterByDate,
          onPressed: _pickDateRange,
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(icon: Icons.refresh, tooltip: l10n.commonRefresh, onPressed: _load, variant: PosButtonVariant.ghost),
      ],
      isLoading: state is CommissionInitial || state is CommissionLoading,
      hasError: state is CommissionError,
      errorMessage: state is CommissionError ? (state).message : null,
      onRetry: _load,
      child: switch (state) {
        CommissionLoaded(summary: final summary) => _buildContent(context, summary),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final totalEarnings =
        (summary['total_earnings'] != null ? double.tryParse(summary['total_earnings'].toString()) : null) ?? 0.0;
    final totalOrders = (summary['total_orders'] as num?)?.toInt() ?? 0;
    final avgPerOrder = (summary['avg_per_order'] != null ? double.tryParse(summary['avg_per_order'].toString()) : null) ?? 0.0;

    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        // Date range indicator
        if (_dateRange != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Chip(
              label: Text('${_dateFormat.format(_dateRange!.start)} – ${_dateFormat.format(_dateRange!.end)}'),
              onDeleted: () {
                setState(() => _dateRange = null);
                _load();
              },
            ),
          ),

        // Summary cards
        PosKpiGrid(
          desktopCols: 3,
          mobileCols: 2,
          cards: [
            PosKpiCard(
              label: l10n.staffTotalEarnings,
              value: _currencyFormat.format(totalEarnings),
              icon: Icons.attach_money,
              iconColor: AppColors.success,
            ),
            PosKpiCard(
              label: l10n.staffTotalOrders,
              value: totalOrders.toString(),
              icon: Icons.receipt_long,
              iconColor: AppColors.info,
            ),
            PosKpiCard(
              label: l10n.staffAvgPerOrder,
              value: _currencyFormat.format(avgPerOrder),
              icon: Icons.trending_up,
              iconColor: AppColors.purple,
            ),
          ],
        ),
        AppSpacing.gapH32,

        // Performance section
        Text(
          l10n.staffPerformanceOverview,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
        ),
        AppSpacing.gapH16,

        PosCard(
          elevation: 0,
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: AppRadius.borderMd,

          border: Border.fromBorderSide(BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: totalOrders == 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.analytics_outlined,
                          size: 48,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                        AppSpacing.gapH16,
                        Text(
                          l10n.staffNoCommissionData,
                          style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _MetricRow(label: l10n.staffTotalCommissionEarned, value: _currencyFormat.format(totalEarnings)),
                      const Divider(),
                      _MetricRow(label: l10n.staffOrdersWithCommission, value: '$totalOrders'),
                      const Divider(),
                      _MetricRow(label: l10n.staffAveragePerOrder, value: _currencyFormat.format(avgPerOrder)),
                      const Divider(),
                      _MetricRow(
                        label: l10n.staffEffectiveRate,
                        value: totalEarnings > 0 && totalOrders > 0
                            ? '${(avgPerOrder / totalEarnings * 100).toStringAsFixed(1)}%'
                            : '0.0%',
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDateRange() async {
    final range = await showPosDateRangePicker(
      context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: _dateRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
      _load();
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Metric Row
// ═══════════════════════════════════════════════════════════════

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;

  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
