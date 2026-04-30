import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/providers/staff_providers.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/features/staff/repositories/staff_repository.dart';

class CommissionSummaryPage extends ConsumerStatefulWidget {
  const CommissionSummaryPage({super.key, required this.staffId, required this.staffName});
  final String staffId;
  final String staffName;

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
      title: l10n.staffCommissionTitle(widget.staffName, l10n.staffCommissions),
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.settings_outlined,
          tooltip: l10n.staffCommissionConfig,
          onPressed: () => _showConfigDialog(context, l10n),
          variant: PosButtonVariant.ghost,
        ),
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
              label: Text(l10n.staffDateRangeLabel(_dateFormat.format(_dateRange!.start), _dateFormat.format(_dateRange!.end))),
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

          border: Border.fromBorderSide(BorderSide(color: AppColors.borderFor(context))),
          child: Padding(
            padding: AppSpacing.paddingAll24,
            child: totalOrders == 0
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.analytics_outlined, size: 48, color: AppColors.mutedFor(context)),
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

  void _showConfigDialog(BuildContext context, AppLocalizations l10n) {
    String selectedType = 'flat_percentage';
    final percentageController = TextEditingController();
    final tiers = <Map<String, TextEditingController>>[];
    final formKey = GlobalKey<FormState>();

    void addTier() {
      tiers.add({'min': TextEditingController(), 'max': TextEditingController(), 'rate': TextEditingController()});
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: Text(l10n.staffCommissionConfig),
          content: SizedBox(
            width: 380,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(labelText: l10n.staffCommissionType),
                      items: [
                        DropdownMenuItem(value: 'flat_percentage', child: Text(l10n.staffCommissionFlat)),
                        DropdownMenuItem(value: 'per_item', child: Text(l10n.staffCommissionPerItem)),
                        DropdownMenuItem(value: 'tiered', child: Text(l10n.staffCommissionTiered)),
                      ],
                      onChanged: (v) => setStateDialog(() {
                        selectedType = v ?? selectedType;
                        if (selectedType == 'tiered' && tiers.isEmpty) addTier();
                      }),
                    ),
                    if (selectedType != 'tiered') ...[
                      AppSpacing.gapH16,
                      TextFormField(
                        controller: percentageController,
                        decoration: InputDecoration(labelText: l10n.staffCommissionPercentage, suffixText: '%'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) return 'Invalid number';
                          return null;
                        },
                      ),
                    ] else ...[
                      AppSpacing.gapH16,
                      Text(l10n.staffCommissionTiers, style: const TextStyle(fontWeight: FontWeight.w600)),
                      AppSpacing.gapH8,
                      ...tiers.asMap().entries.map((entry) {
                        final i = entry.key;
                        final t = entry.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: t['min'],
                                  decoration: InputDecoration(labelText: l10n.staffTierMin),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              AppSpacing.gapW8,
                              Expanded(
                                child: TextFormField(
                                  controller: t['max'],
                                  decoration: InputDecoration(labelText: l10n.staffTierMax),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              AppSpacing.gapW8,
                              Expanded(
                                child: TextFormField(
                                  controller: t['rate'],
                                  decoration: InputDecoration(labelText: l10n.staffTierRate, suffixText: '%'),
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                                onPressed: () => setStateDialog(() => tiers.removeAt(i)),
                              ),
                            ],
                          ),
                        );
                      }),
                      TextButton.icon(
                        onPressed: () => setStateDialog(addTier),
                        icon: const Icon(Icons.add),
                        label: Text(l10n.staffAddTier),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
            PosButton(
              label: l10n.save,
              onPressed: () async {
                if (!formKey.currentState!.validate()) return;
                Navigator.pop(ctx);
                final data = <String, dynamic>{'commission_type': selectedType};
                if (selectedType != 'tiered') {
                  data['percentage'] = double.parse(percentageController.text);
                } else {
                  data['tiers'] = tiers
                      .map(
                        (t) => {
                          'min_amount': double.tryParse(t['min']!.text) ?? 0,
                          'max_amount': double.tryParse(t['max']!.text),
                          'rate': double.tryParse(t['rate']!.text) ?? 0,
                        },
                      )
                      .toList();
                }
                try {
                  await ref.read(staffRepositoryProvider).setCommissionConfig(widget.staffId, data);
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(l10n.staffCommissionSaveSuccess), backgroundColor: AppColors.success));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Metric Row
// ═══════════════════════════════════════════════════════════════

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.value});
  final String label;
  final String value;

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
