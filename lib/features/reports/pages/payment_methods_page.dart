import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/reports/models/report_filters.dart';
import 'package:wameedpos/features/reports/providers/report_providers.dart';
import 'package:wameedpos/features/reports/providers/report_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/features/reports/widgets/report_filter_panel.dart';
import 'package:wameedpos/features/reports/widgets/report_widgets.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class PaymentMethodsPage extends ConsumerStatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  ConsumerState<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends ConsumerState<PaymentMethodsPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  ReportFilters _filters = const ReportFilters();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    ref.read(paymentMethodsProvider.notifier).load(filters: _filters);
  }

  void _onFiltersChanged(ReportFilters filters) {
    setState(() => _filters = filters);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paymentMethodsProvider);

    return ReportPageScaffold(
      title: l10n.paymentMethods,
      filterPanel: ReportFilterPanel(
        filters: _filters,
        onFiltersChanged: _onFiltersChanged,
        onRefresh: _loadData,
        showStaffFilter: true,
        showPaymentMethodFilter: true,
        showAmountRange: true,
      ),
      body: switch (state) {
        PaymentMethodsInitial() || PaymentMethodsLoading() => PosLoadingSkeleton.list(),
        PaymentMethodsError(:final message) => PosErrorState(message: message, onRetry: _loadData),
        PaymentMethodsLoaded(:final methods) =>
          methods.isEmpty
              ? PosEmptyState(title: l10n.reportsNoPaymentData, icon: Icons.payment)
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
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final totalAmount = methods.fold<double>(0, (sum, m) => sum + (double.tryParse(m['total_amount'].toString()) ?? 0.0));
    final totalTx = methods.fold<int>(0, (sum, m) => sum + (m['transaction_count'] as num).toInt());
    final maxAmount = methods.isEmpty
        ? 1.0
        : methods.map((m) => double.tryParse(m['total_amount'].toString()) ?? 0.0).reduce((a, b) => a > b ? a : b);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Top KPIs
        ReportKpiGrid(
          cards: [
            ReportKpiCard(
              label: l10n.totalRevenue,
              value: formatCurrency(totalAmount),
              icon: Icons.account_balance_wallet_rounded,
              color: AppColors.success,
            ),
            ReportKpiCard(
              label: l10n.transactions,
              value: formatCompact(totalTx),
              icon: Icons.receipt_long_rounded,
              color: AppColors.info,
            ),
            ReportKpiCard(
              label: l10n.reportsMethodsUsed,
              value: '${methods.length}',
              icon: Icons.payment_rounded,
              color: AppColors.primary,
            ),
            ReportKpiCard(
              label: l10n.reportsAvgPerTx,
              value: totalTx > 0 ? formatCurrency(totalAmount / totalTx) : '\u00810',
              icon: Icons.calculate_rounded,
              color: AppColors.warning,
            ),
          ],
        ),

        // Pie Chart — Payment method distribution
        if (methods.isNotEmpty) ...[
          const SizedBox(height: 20),
          ReportSectionHeader(title: l10n.reportsPaymentDistribution, icon: Icons.donut_large_rounded),
          ReportDataCard(
            child: ReportPieChart(data: methods, labelKey: 'method', valueKey: 'total_amount', donut: true),
          ),
        ],

        const SizedBox(height: 24),
        ReportSectionHeader(title: l10n.reportsBreakdownByMethod, icon: Icons.pie_chart_outline_rounded),

        ...methods.map((m) {
          final method = m['method'] as String;
          final amount = double.tryParse(m['total_amount'].toString()) ?? 0.0;
          final txCount = (m['transaction_count'] as num).toInt();
          final avg = double.tryParse(m['avg_amount'].toString()) ?? 0.0;
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
                              '${l10n.reportNTransactions(txCount.toString())} · ${l10n.reportAvgAmount(formatCurrency(avg))}',
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
