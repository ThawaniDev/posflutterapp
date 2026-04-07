import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/payments/enums/payment_method_key.dart';
import 'package:thawani_pos/features/payments/providers/payment_providers.dart';
import 'package:thawani_pos/features/payments/providers/payment_state.dart';
import 'package:thawani_pos/features/payments/services/payment_calculation_service.dart';

class DailySummaryPage extends ConsumerStatefulWidget {
  const DailySummaryPage({super.key});

  @override
  ConsumerState<DailySummaryPage> createState() => _DailySummaryPageState();
}

class _DailySummaryPageState extends ConsumerState<DailySummaryPage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(paymentsProvider.notifier).load();
      ref.read(cashSessionsProvider.notifier).load();
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

    final payments = switch (paymentsState) {
      PaymentsLoaded(:final payments) => payments,
      _ => <dynamic>[],
    };
    final sessions = switch (sessionsState) {
      CashSessionsLoaded(:final sessions) => sessions,
      _ => <dynamic>[],
    };
    final expenses = switch (expensesState) {
      ExpensesLoaded(:final expenses) => expenses,
      _ => <dynamic>[],
    };

    final totalRevenue = payments.fold<double>(0, (sum, p) => sum + p.amount);
    final totalExpenses = expenses.fold<double>(0, (sum, e) => sum + e.amount);
    final netRevenue = totalRevenue - totalExpenses;
    final txCount = payments.length;

    // Payment method breakdown
    final byMethod = <String, double>{};
    for (final p in payments) {
      final key = p.method.value;
      byMethod[key] = (byMethod[key] ?? 0) + p.amount;
    }

    // Cash variance
    final closedSessions = sessions.where((s) => s.status?.value == 'closed').toList();
    final totalVariance = closedSessions.fold<double>(0, (sum, s) => sum + ((s.actualCash ?? 0) - (s.expectedCash ?? 0)));

    final isLoading =
        paymentsState is PaymentsLoading || sessionsState is CashSessionsLoading || expensesState is ExpensesLoading;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.dailySummaryTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
              _reload();
            },
          ),
          TextButton(
            onPressed: () => _pickDate(context),
            child: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}', style: theme.textTheme.titleSmall),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))
                ? () {
                    setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
                    _reload();
                  }
                : null,
          ),
          AppSpacing.gapW8,
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.print, size: 18), label: Text(l10n.dailySummaryPrint)),
          AppSpacing.gapW12,
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(context.isPhone ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top KPI Cards ──
                  context.isPhone
                      ? Column(
                          children: [
                            Row(
                              children: [
                                _kpiCard(
                                  theme,
                                  l10n.dailySummaryGrossRevenue,
                                  '${totalRevenue.toStringAsFixed(2)} \u0081',
                                  Icons.trending_up,
                                  AppColors.success,
                                ),
                                AppSpacing.gapW8,
                                _kpiCard(
                                  theme,
                                  l10n.dailySummaryExpenses,
                                  '${totalExpenses.toStringAsFixed(2)} \u0081',
                                  Icons.trending_down,
                                  AppColors.error,
                                ),
                              ],
                            ),
                            AppSpacing.gapH8,
                            Row(
                              children: [
                                _kpiCard(
                                  theme,
                                  l10n.dailySummaryNetRevenue,
                                  '${netRevenue.toStringAsFixed(2)} \u0081',
                                  Icons.account_balance,
                                  netRevenue >= 0 ? AppColors.success : AppColors.error,
                                ),
                                AppSpacing.gapW8,
                                _kpiCard(theme, l10n.dailySummaryTransactions, '$txCount', Icons.receipt, AppColors.info),
                              ],
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            _kpiCard(
                              theme,
                              l10n.dailySummaryGrossRevenue,
                              '${totalRevenue.toStringAsFixed(2)} \u0081',
                              Icons.trending_up,
                              AppColors.success,
                            ),
                            AppSpacing.gapW12,
                            _kpiCard(
                              theme,
                              l10n.dailySummaryExpenses,
                              '${totalExpenses.toStringAsFixed(2)} \u0081',
                              Icons.trending_down,
                              AppColors.error,
                            ),
                            AppSpacing.gapW12,
                            _kpiCard(
                              theme,
                              l10n.dailySummaryNetRevenue,
                              '${netRevenue.toStringAsFixed(2)} \u0081',
                              Icons.account_balance,
                              netRevenue >= 0 ? AppColors.success : AppColors.error,
                            ),
                            AppSpacing.gapW12,
                            _kpiCard(theme, l10n.dailySummaryTransactions, '$txCount', Icons.receipt, AppColors.info),
                          ],
                        ),
                  AppSpacing.gapH24,

                  // ── Revenue by Payment Method ──
                  context.isPhone
                      ? Column(
                          children: [
                            _buildMethodBreakdownCard(theme, byMethod, totalRevenue, l10n),
                            AppSpacing.gapH16,
                            _buildCashVarianceCard(theme, closedSessions, totalVariance, l10n),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 3, child: _buildMethodBreakdownCard(theme, byMethod, totalRevenue, l10n)),
                            AppSpacing.gapW16,
                            Expanded(flex: 2, child: _buildCashVarianceCard(theme, closedSessions, totalVariance, l10n)),
                          ],
                        ),
                  AppSpacing.gapH24,

                  // ── Hourly Activity ──
                  _buildHourlyActivityCard(theme, payments, l10n),
                  AppSpacing.gapH24,

                  // ── Session Details ──
                  _buildSessionDetailsCard(theme, sessions, l10n),
                ],
              ),
            ),
    );
  }

  Widget _kpiCard(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 20),
                  const Spacer(),
                ],
              ),
              AppSpacing.gapH12,
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
              ),
              AppSpacing.gapH4,
              Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMethodBreakdownCard(ThemeData theme, Map<String, double> byMethod, double total, AppLocalizations l10n) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailySummaryRevenueByMethod, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            if (byMethod.isEmpty)
              Padding(
                padding: AppSpacing.paddingAll16,
                child: Text(l10n.dailySummaryNoPayments, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
              )
            else
              ...byMethod.entries.map((entry) {
                final methodKey = PaymentMethodKey.tryFromValue(entry.key);
                final displayName = methodKey != null ? PaymentCalculationService.methodDisplayName(methodKey) : entry.key;
                final pct = total > 0 ? entry.value / total : 0.0;
                final color = _methodColor(entry.key);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(color: color, borderRadius: AppRadius.borderFull),
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(displayName, style: theme.textTheme.bodyMedium),
                            AppSpacing.gapH4,
                            LinearProgressIndicator(
                              value: pct,
                              backgroundColor: theme.dividerColor,
                              color: color,
                              minHeight: 4,
                              borderRadius: AppRadius.borderFull,
                            ),
                          ],
                        ),
                      ),
                      AppSpacing.gapW12,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${entry.value.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '${(pct * 100).toStringAsFixed(1)}%',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                        ],
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

  Widget _buildCashVarianceCard(ThemeData theme, List<dynamic> closedSessions, double totalVariance, AppLocalizations l10n) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailySummaryCashVariance, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            Center(
              child: Column(
                children: [
                  Icon(
                    totalVariance.abs() > 5 ? Icons.warning_amber : Icons.check_circle,
                    size: 48,
                    color: totalVariance.abs() > 5 ? AppColors.warning : AppColors.success,
                  ),
                  AppSpacing.gapH12,
                  Text(
                    '${totalVariance >= 0 ? '+' : ''}${totalVariance.toStringAsFixed(2)} \u0081',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: totalVariance.abs() > 5 ? AppColors.error : AppColors.success,
                    ),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    totalVariance.abs() <= 5 ? l10n.dailySummaryWithinTolerance : l10n.dailySummaryNeedsReview,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,
            Text(
              l10n.dailySummarySessions(closedSessions.length),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyActivityCard(ThemeData theme, List<dynamic> payments, AppLocalizations l10n) {
    // Group payments by hour
    final byHour = <int, int>{};
    for (final p in payments) {
      if (p.createdAt != null) {
        final hour = p.createdAt!.hour;
        byHour[hour] = (byHour[hour] ?? 0) + 1;
      }
    }

    final maxCount = byHour.values.fold<int>(0, (m, v) => v > m ? v : m);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailySummaryHourlyActivity, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            SizedBox(
              height: 120,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(24, (hour) {
                  final count = byHour[hour] ?? 0;
                  final fraction = maxCount > 0 ? count / maxCount : 0.0;

                  return Expanded(
                    child: Tooltip(
                      message: '${hour.toString().padLeft(2, '0')}:00 — $count txn',
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: count > 0
                              ? AppColors.primary.withValues(alpha: 0.2 + fraction * 0.8)
                              : theme.dividerColor.withValues(alpha: 0.3),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
                        ),
                        height: count > 0 ? 20 + (100 * fraction) : 4,
                      ),
                    ),
                  );
                }),
              ),
            ),
            AppSpacing.gapH4,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('00', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor)),
                Text('06', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor)),
                Text('12', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor)),
                Text('18', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor)),
                Text('23', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetailsCard(ThemeData theme, List<dynamic> sessions, AppLocalizations l10n) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.dailySummarySessionDetails, style: theme.textTheme.titleMedium),
            AppSpacing.gapH12,
            if (sessions.isEmpty)
              Text(l10n.dailySummaryNoSessions, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
            else
              ...sessions.map(
                (s) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        s.status?.value == 'active' ? Icons.lock_open : Icons.lock,
                        color: s.status?.value == 'active' ? AppColors.success : theme.hintColor,
                        size: 20,
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dailySummaryFloat(s.openingFloat.toStringAsFixed(2)),
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              l10n.dailySummaryTerminal(s.terminalId ?? 'N/A'),
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                      if (s.variance != null)
                        Text(
                          '${s.variance! >= 0 ? '+' : ''}${s.variance!.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: s.variance!.abs() > 5 ? AppColors.error : AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _methodColor(String method) {
    return switch (method) {
      'cash' => AppColors.success,
      'card_mada' => const Color(0xFF00897B),
      'card_visa' => const Color(0xFF1A237E),
      'card_mastercard' => const Color(0xFFE65100),
      'store_credit' => AppColors.info,
      'gift_card' => AppColors.warning,
      'mobile_payment' => const Color(0xFF8E24AA),
      _ => AppColors.primary,
    };
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
      _reload();
    }
  }

  void _reload() {
    ref.read(paymentsProvider.notifier).load();
    ref.read(cashSessionsProvider.notifier).load();
    ref.read(expensesProvider.notifier).load();
  }
}
