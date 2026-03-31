import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/reports/providers/report_providers.dart';
import 'package:thawani_pos/features/reports/providers/report_state.dart';
import 'package:thawani_pos/features/reports/widgets/report_widgets.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {
  DateTimeRange? _dateRange;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref
        .read(paymentMethodsProvider.notifier)
        .load(
          dateFrom: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.start) : null,
          dateTo: _dateRange != null ? DateFormat('yyyy-MM-dd').format(_dateRange!.end) : null,
        );
  }

  Future<void> _pickDateRange() async {
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
    final state = ref.watch(paymentMethodsProvider);

    return ReportPageScaffold(
      title: 'Payment Methods',
      dateRange: _dateRange,
      onPickDate: _pickDateRange,
      onClearDate: () {
        setState(() => _dateRange = null);
        _loadData();
      },
      onRefresh: _loadData,
      body: switch (state) {
        PaymentMethodsInitial() || PaymentMethodsLoading() => PosLoadingSkeleton.list(),
        PaymentMethodsError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        PaymentMethodsLoaded(:final methods) =>
          methods.isEmpty
              ? const PosEmptyState(title: 'No payment data for selected period', icon: Icons.payment)
              : _PaymentList(methods: methods),
      },
    );
  }
}

IconData _iconForMethod(String method) {
  return switch (method) {
    'cash' => Icons.payments_rounded,
    'card' => Icons.credit_card_rounded,
    'gift_card' => Icons.card_giftcard_rounded,
    'mobile' => Icons.phone_android_rounded,
    'bank_transfer' => Icons.account_balance_rounded,
    _ => Icons.attach_money_rounded,
  };
}

Color _colorForMethod(String method) {
  return switch (method) {
    'cash' => AppColors.success,
    'card' => AppColors.info,
    'gift_card' => AppColors.purple,
    'mobile' => AppColors.warning,
    'bank_transfer' => const Color(0xFF2E7D32),
    _ => AppColors.primary,
  };
}

class _PaymentList extends StatelessWidget {
  final List<Map<String, dynamic>> methods;

  const _PaymentList({required this.methods});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalAmount = methods.fold<double>(0, (sum, m) => sum + (m['total_amount'] as num).toDouble());
    final totalTx = methods.fold<int>(0, (sum, m) => sum + (m['transaction_count'] as num).toInt());
    final maxAmount = methods.isEmpty
        ? 1.0
        : methods.map((m) => (m['total_amount'] as num).toDouble()).reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: 'Total Revenue',
              value: formatCurrency(totalAmount),
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: 'Transactions',
              value: formatCompact(totalTx),
              icon: Icons.receipt_long_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: 'Methods Used',
              value: '${methods.length}',
              icon: Icons.payment_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: 'Avg per Tx',
              value: totalTx > 0 ? formatCurrency(totalAmount / totalTx) : '\$0',
              icon: Icons.calculate_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        const SizedBox(height: 24),
        const ReportSectionHeader(title: 'Breakdown by Method', icon: Icons.pie_chart_outline_rounded),

        ...methods.map((m) {
          final method = m['method'] as String;
          final amount = (m['total_amount'] as num).toDouble();
          final txCount = (m['transaction_count'] as num).toInt();
          final avg = (m['avg_amount'] as num).toDouble();
          final pct = totalAmount > 0 ? amount / totalAmount : 0.0;
          final color = _colorForMethod(method);

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ReportDataCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                        child: Icon(_iconForMethod(method), color: color, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.replaceAll('_', ' ').toUpperCase(),
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '$txCount transactions · Avg ${formatCurrency(avg)}',
                              style: Theme.of(
                                context,
                              ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatCurrency(amount),
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          ReportBadge(label: formatPercent(pct * 100), color: color),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ReportBar(value: amount, maxValue: maxAmount, color: color, height: 10),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
