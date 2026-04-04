import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/payments/providers/payment_providers.dart';
import 'package:thawani_pos/features/payments/providers/payment_state.dart';
import 'package:thawani_pos/features/payments/services/payment_calculation_service.dart';

class FinancialReconciliationPage extends ConsumerStatefulWidget {
  const FinancialReconciliationPage({super.key});

  @override
  ConsumerState<FinancialReconciliationPage> createState() => _FinancialReconciliationPageState();
}

class _FinancialReconciliationPageState extends ConsumerState<FinancialReconciliationPage> {
  late List<DenominationCount> _denominationCounts;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _denominationCounts = PaymentCalculationService.createDenominationCounts();
    Future.microtask(() {
      ref.read(cashSessionsProvider.notifier).load();
      ref.read(paymentsProvider.notifier).load();
      ref.read(expensesProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final paymentsState = ref.watch(paymentsProvider);
    final sessionsState = ref.watch(cashSessionsProvider);
    final expensesState = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.finReconTitle),
        actions: [
          TextButton.icon(
            onPressed: () => _pickDate(context),
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
          ),
          AppSpacing.gapW12,
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Revenue Summary ──
            _buildRevenueSection(theme, paymentsState, l10n),
            AppSpacing.gapH24,

            // ── Payment Method Breakdown ──
            _buildPaymentBreakdown(theme, paymentsState, l10n),
            AppSpacing.gapH24,

            // ── Cash Reconciliation ──
            _buildCashReconciliation(theme, sessionsState, l10n),
            AppSpacing.gapH24,

            // ── Expenses Summary ──
            _buildExpensesSummary(theme, expensesState, l10n),
            AppSpacing.gapH24,

            // ── Denomination Count ──
            Text(l10n.finReconPhysicalCashCount, style: theme.textTheme.titleMedium),
            AppSpacing.gapH12,
            _buildCompactDenominations(theme, l10n),
            AppSpacing.gapH24,

            // ── Actions ──
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.print, size: 18),
                  label: Text(l10n.finReconPrintReport),
                ),
                AppSpacing.gapW8,
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download, size: 18),
                  label: Text(l10n.finReconExportPdf),
                ),
                AppSpacing.gapW8,
                FilledButton.icon(
                  onPressed: () => _confirmReconciliation(context),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: Text(l10n.finReconConfirmRecon),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueSection(ThemeData theme, PaymentsState state, AppLocalizations l10n) {
    final payments = switch (state) {
      PaymentsLoaded(:final payments) => payments,
      _ => <dynamic>[],
    };

    final totalRevenue = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final txCount = payments.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.finReconRevenueSummary, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            Row(
              children: [
                _summaryTile(
                  theme,
                  l10n.finReconTotalRevenue,
                  '${totalRevenue.toStringAsFixed(2)} SAR',
                  Icons.trending_up,
                  AppColors.success,
                ),
                AppSpacing.gapW16,
                _summaryTile(theme, l10n.finReconTransactions, '$txCount', Icons.receipt_long, AppColors.info),
                AppSpacing.gapW16,
                _summaryTile(
                  theme,
                  l10n.finReconAvgTransaction,
                  txCount > 0 ? '${(totalRevenue / txCount).toStringAsFixed(2)} SAR' : '0.00 SAR',
                  Icons.analytics,
                  AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentBreakdown(ThemeData theme, PaymentsState state, AppLocalizations l10n) {
    final payments = switch (state) {
      PaymentsLoaded(:final payments) => payments,
      _ => <dynamic>[],
    };

    // Group by method
    final byMethod = <String, double>{};
    for (final p in payments) {
      final key = PaymentCalculationService.methodDisplayName(p.method.value);
      byMethod[key] = (byMethod[key] ?? 0) + p.amount;
    }

    final total = byMethod.values.fold<double>(0, (s, v) => s + v);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.finReconPaymentMethods, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            if (byMethod.isEmpty)
              Text(l10n.finReconNoPayments, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
            else
              ...byMethod.entries.map((entry) {
                final pct = total > 0 ? (entry.value / total * 100) : 0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(entry.key, style: theme.textTheme.bodyMedium),
                          Text(
                            '${entry.value.toStringAsFixed(2)} SAR (${pct.toStringAsFixed(1)}%)',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      AppSpacing.gapH4,
                      LinearProgressIndicator(
                        value: total > 0 ? entry.value / total : 0,
                        backgroundColor: theme.dividerColor,
                        color: AppColors.primary,
                        minHeight: 6,
                        borderRadius: AppRadius.borderFull,
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildCashReconciliation(ThemeData theme, CashSessionsState state, AppLocalizations l10n) {
    final sessions = switch (state) {
      CashSessionsLoaded(:final sessions) => sessions,
      _ => <dynamic>[],
    };

    final closedSessions = sessions.where((s) => s.status?.value == 'closed').toList();
    final totalExpected = closedSessions.fold<double>(0, (sum, s) => sum + (s.expectedCash ?? 0));
    final totalActual = closedSessions.fold<double>(0, (sum, s) => sum + (s.actualCash ?? 0));
    final totalVariance = totalActual - totalExpected;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.finReconCashRecon, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            Row(
              children: [
                _summaryTile(
                  theme,
                  l10n.finReconExpectedCash,
                  '${totalExpected.toStringAsFixed(2)} SAR',
                  Icons.calculate,
                  AppColors.info,
                ),
                AppSpacing.gapW16,
                _summaryTile(
                  theme,
                  l10n.finReconActualCash,
                  '${totalActual.toStringAsFixed(2)} SAR',
                  Icons.payments,
                  AppColors.primary,
                ),
                AppSpacing.gapW16,
                _summaryTile(
                  theme,
                  l10n.finReconVariance,
                  '${totalVariance >= 0 ? '+' : ''}${totalVariance.toStringAsFixed(2)} SAR',
                  Icons.compare_arrows,
                  totalVariance.abs() > 5 ? AppColors.error : AppColors.success,
                ),
              ],
            ),
            if (closedSessions.isNotEmpty) ...[
              AppSpacing.gapH16,
              Text(
                l10n.finReconSessionsClosed(closedSessions.length),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesSummary(ThemeData theme, ExpensesState state, AppLocalizations l10n) {
    final expenses = switch (state) {
      ExpensesLoaded(:final expenses) => expenses,
      _ => <dynamic>[],
    };

    final totalExpenses = expenses.fold<double>(0, (sum, e) => sum + e.amount);

    // Group by category
    final byCategory = <String, double>{};
    for (final e in expenses) {
      final key = e.category.value.replaceAll('_', ' ');
      byCategory[key] = (byCategory[key] ?? 0) + e.amount;
    }

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.finReconExpenses, style: theme.textTheme.titleMedium),
                Text(
                  '${totalExpenses.toStringAsFixed(2)} SAR',
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSpacing.gapH12,
            if (byCategory.isEmpty)
              Text(l10n.finReconNoExpenses, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
            else
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: byCategory.entries.map((e) {
                  return Chip(
                    label: Text('${e.key}: ${e.value.toStringAsFixed(2)} SAR', style: const TextStyle(fontSize: 12)),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactDenominations(ThemeData theme, AppLocalizations l10n) {
    final total = PaymentCalculationService.calculateDenominationTotal(_denominationCounts);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _denominationCounts.length,
              itemBuilder: (context, index) {
                final dc = _denominationCounts[index];
                return TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: dc.denomination.label,
                    labelStyle: const TextStyle(fontSize: 10),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  ),
                  style: const TextStyle(fontSize: 14),
                  onChanged: (v) => setState(() => dc.count = int.tryParse(v) ?? 0),
                );
              },
            ),
            AppSpacing.gapH12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.finReconCountedTotal, style: theme.textTheme.titleSmall),
                Text(
                  '${total.toStringAsFixed(2)} SAR',
                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: AppSpacing.paddingAll16,
        decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: AppRadius.borderMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 20),
            AppSpacing.gapH8,
            Text(
              value,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            AppSpacing.gapH2,
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      // Reload with date filter
      ref.read(paymentsProvider.notifier).load();
      ref.read(cashSessionsProvider.notifier).load();
      ref.read(expensesProvider.notifier).load();
    }
  }

  void _confirmReconciliation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.finReconConfirmRecon),
        content: Text(l10n.finReconConfirmMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel)),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.finReconConfirmed)));
            },
            child: Text(l10n.commonConfirm),
          ),
        ],
      ),
    );
  }
}
