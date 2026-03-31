import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class SalesSummaryPage extends ConsumerStatefulWidget {
  const SalesSummaryPage({super.key});

  @override
  ConsumerState<SalesSummaryPage> createState() => _SalesSummaryPageState();
}

class _SalesSummaryPageState extends ConsumerState<SalesSummaryPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(salesSummaryProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.end) : null,
        );
  }

  Future<void> _pickDate() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(salesSummaryProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ReportPageScaffold(
      title: 'Sales Summary',
      dateRange: _dateRange,
      onPickDate: _pickDate,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
      body: switch (state) {
        SalesSummaryInitial() || SalesSummaryLoading() => PosLoadingSkeleton.list(),
        SalesSummaryError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        SalesSummaryLoaded(:final totals, :final daily) => ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ReportKpiGrid(
              cards: [
                ReportKpiCard(
                  label: 'Total Revenue',
                  value: formatCurrency(totals['total_revenue'] as num),
                  icon: Icons.trending_up_rounded,
                  color: AppColors.success,
                ),
                ReportKpiCard(
                  label: 'Net Revenue',
                  value: formatCurrency(totals['net_revenue'] as num),
                  icon: Icons.account_balance_wallet_rounded,
                  color: AppColors.primary,
                ),
                ReportKpiCard(
                  label: 'Transactions',
                  value: '${totals['total_transactions']}',
                  icon: Icons.receipt_long_rounded,
                  color: AppColors.info,
                ),
                ReportKpiCard(
                  label: 'Avg Basket',
                  value: formatCurrency(totals['avg_basket_size'] as num),
                  icon: Icons.shopping_basket_rounded,
                  color: AppColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 20),

            const ReportSectionHeader(title: 'Breakdown', icon: Icons.pie_chart_rounded),
            ReportDataCard(
              child: Column(
                children: [
                  ReportStatRow(label: 'Cost of Goods', value: formatCurrency(totals['total_cost'] as num)),
                  ReportStatRow(
                    label: 'Discounts',
                    value: formatCurrency(totals['total_discount'] as num),
                    valueColor: AppColors.warning,
                  ),
                  ReportStatRow(label: 'Tax Collected', value: formatCurrency(totals['total_tax'] as num)),
                  ReportStatRow(
                    label: 'Refunds',
                    value: formatCurrency(totals['total_refunds'] as num),
                    valueColor: AppColors.error,
                  ),
                  const Divider(height: 24),
                  ReportStatRow(label: 'Cash Revenue', value: formatCurrency(totals['cash_revenue'] as num)),
                  ReportStatRow(label: 'Card Revenue', value: formatCurrency(totals['card_revenue'] as num)),
                  ReportStatRow(label: 'Other Revenue', value: formatCurrency(totals['other_revenue'] as num)),
                  ReportStatRow(label: 'Unique Customers', value: '${totals['unique_customers']}'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const ReportSectionHeader(title: 'Daily Breakdown', icon: Icons.calendar_month_rounded),
            if (daily.isEmpty)
              const ReportDataCard(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text('No data for selected period')),
                ),
              )
            else
              ReportDataCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    for (int i = 0; i < daily.length; i++) ...[
                      if (i > 0) Divider(height: 1, color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    daily[i]['date'] as String,
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${daily[i]['total_transactions']} orders',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatCurrency(daily[i]['total_revenue'] as num),
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  'Net: ${formatCurrency(daily[i]['net_revenue'] as num)}',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.success, fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            const SizedBox(height: 20),
          ],
        ),
      },
    );
  }
}
