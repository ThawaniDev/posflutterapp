import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/services/payment_calculation_service.dart';

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
    Future.microtask(_reload);
  }

  String get _dateString =>
      '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}';

  void _reload() {
    ref.read(dailySummaryProvider.notifier).load(date: _dateString);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(dailySummaryProvider);

    final isLoading = state is DailySummaryLoading || state is DailySummaryInitial;
    final data = state is DailySummaryLoaded ? state.data : null;

    return PosListPage(
      title: l10n.dailySummaryTitle,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showDailySummaryInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.chevron_left,
          tooltip: '',
          onPressed: () {
            setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
            _reload();
          },
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          onPressed: () => _pickDate(context),
          variant: PosButtonVariant.ghost,
          label: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
        ),
        PosButton.icon(
          icon: Icons.chevron_right,
          tooltip: '',
          onPressed: _selectedDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))
              ? () {
                  setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
                  _reload();
                }
              : null,
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: l10n.dailySummaryPrint,
          icon: Icons.print,
          variant: PosButtonVariant.outline,
          onPressed: data != null ? () => _printSummary(context, data, l10n) : null,
        ),
      ],
      isLoading: isLoading,
      hasError: state is DailySummaryError,
      errorMessage: state is DailySummaryError ? (state).message : null,
      onRetry: _reload,
      child: data == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: context.responsivePagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top KPI Cards ──
                  _buildKpiCards(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Revenue by Payment Method + Cash Variance ──
                  ResponsiveTwoColumn(
                    leftFlex: 3,
                    rightFlex: 2,
                    spacing: AppSpacing.base,
                    left: _buildMethodBreakdownCard(theme, data, l10n),
                    right: _buildCashVarianceCard(theme, data, l10n),
                  ),
                  AppSpacing.gapH24,

                  // ── Hourly Activity ──
                  _buildHourlyActivityCard(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Expenses by Category ──
                  _buildExpensesByCategoryCard(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Session Details ──
                  _buildSessionDetailsCard(theme, data, l10n),
                ],
              ),
            ),
    );
  }

  Widget _buildKpiCards(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final totalRevenue = _toDouble(data['total_revenue']);
    final totalExpenses = _toDouble(data['total_expenses']);
    final netRevenue = _toDouble(data['net_revenue'] ?? (totalRevenue - totalExpenses));
    final txCount = data['transaction_count'] as int? ?? 0;

    return PosKpiGrid(
      desktopCols: 4,
      mobileCols: 2,
      cards: [
        PosKpiCard(
          label: l10n.dailySummaryGrossRevenue,
          value: '${totalRevenue.toStringAsFixed(2)} \u0631',
          icon: Icons.trending_up,
          iconColor: AppColors.success,
        ),
        PosKpiCard(
          label: l10n.dailySummaryExpenses,
          value: '${totalExpenses.toStringAsFixed(2)} \u0631',
          icon: Icons.trending_down,
          iconColor: AppColors.error,
        ),
        PosKpiCard(
          label: l10n.dailySummaryNetRevenue,
          value: '${netRevenue.toStringAsFixed(2)} \u0631',
          icon: Icons.account_balance,
          iconColor: netRevenue >= 0 ? AppColors.success : AppColors.error,
        ),
        PosKpiCard(label: l10n.dailySummaryTransactions, value: '$txCount', icon: Icons.receipt, iconColor: AppColors.info),
      ],
    );
  }

  Widget _buildMethodBreakdownCard(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final byMethod = data['by_method'] as List? ?? [];
    final totalRevenue = _toDouble(data['total_revenue']);

    return PosCard(
      borderRadius: AppRadius.borderLg,
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
              ...byMethod.map((item) {
                final method = item['method'] as String? ?? '';
                final amount = _toDouble(item['amount']);
                final methodKey = PaymentMethodKey.tryFromValue(method);
                final displayName = methodKey != null ? PaymentCalculationService.methodDisplayName(methodKey) : method;
                final pct = totalRevenue > 0 ? amount / totalRevenue : 0.0;
                final color = _methodColor(method);

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
                            amount.toStringAsFixed(2),
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

  Widget _buildCashVarianceCard(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final cashVariance = _toDouble(data['cash_variance']);
    final sessionsClosed = data['sessions_closed'] as int? ?? 0;

    return PosCard(
      borderRadius: AppRadius.borderLg,
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
                    cashVariance.abs() > 5 ? Icons.warning_amber : Icons.check_circle,
                    size: 48,
                    color: cashVariance.abs() > 5 ? AppColors.warning : AppColors.success,
                  ),
                  AppSpacing.gapH12,
                  Text(
                    '${cashVariance >= 0 ? '+' : ''}${cashVariance.toStringAsFixed(2)} \u0631',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cashVariance.abs() > 5 ? AppColors.error : AppColors.success,
                    ),
                  ),
                  AppSpacing.gapH4,
                  Text(
                    cashVariance.abs() <= 5 ? l10n.dailySummaryWithinTolerance : l10n.dailySummaryNeedsReview,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,
            Text(l10n.dailySummarySessions(sessionsClosed), style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyActivityCard(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final hourlyBreakdown = data['hourly_breakdown'] as List? ?? [];
    final byHour = <int, int>{};
    for (final entry in hourlyBreakdown) {
      final hour = entry['hour'] as int? ?? 0;
      final count = entry['count'] as int? ?? 0;
      byHour[hour] = count;
    }
    final maxCount = byHour.values.fold<int>(0, (m, v) => v > m ? v : m);

    return PosCard(
      borderRadius: AppRadius.borderLg,
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
                '00',
                '06',
                '12',
                '18',
                '23',
              ].map((h) => Text(h, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.hintColor))).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesByCategoryCard(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final byCategory = data['expenses_by_category'] as List? ?? [];
    final totalExpenses = _toDouble(data['total_expenses']);

    return PosCard(
      borderRadius: AppRadius.borderLg,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.dailySummaryExpensesBreakdown, style: theme.textTheme.titleMedium),
                Text(
                  '${totalExpenses.toStringAsFixed(2)} \u0631',
                  style: theme.textTheme.titleSmall?.copyWith(color: AppColors.error, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            AppSpacing.gapH12,
            if (byCategory.isEmpty)
              Text(l10n.dailySummaryNoExpenses, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
            else
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: byCategory.map((e) {
                  final cat = e['category'] as String? ?? '';
                  final amt = _toDouble(e['amount']);
                  return Chip(
                    label: Text(
                      '${cat.replaceAll('_', ' ')}: ${amt.toStringAsFixed(2)} \u0631',
                      style: const TextStyle(fontSize: 12),
                    ),
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

  Widget _buildSessionDetailsCard(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final sessions = data['sessions'] as List? ?? [];

    return PosCard(
      borderRadius: AppRadius.borderLg,
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
              ...sessions.map((s) {
                final status = s['status'] as String? ?? '';
                final terminalId = s['terminal_id'] as String? ?? 'N/A';
                final openingFloat = _toDouble(s['opening_float']);
                final variance = s['variance'] != null ? _toDouble(s['variance']) : null;
                final isActive = status == 'active';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: AppSpacing.paddingAll12,
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.dividerColor),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isActive ? Icons.lock_open : Icons.lock,
                        color: isActive ? AppColors.success : theme.hintColor,
                        size: 20,
                      ),
                      AppSpacing.gapW12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.dailySummaryFloat(openingFloat.toStringAsFixed(2)),
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              l10n.dailySummaryTerminal(terminalId),
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                            ),
                          ],
                        ),
                      ),
                      if (variance != null)
                        Text(
                          '${variance >= 0 ? '+' : ''}${variance.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: variance.abs() > 5 ? AppColors.error : AppColors.success,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
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

  Future<void> _printSummary(BuildContext context, Map<String, dynamic> data, AppLocalizations l10n) async {
    final totalRevenue = _toDouble(data['total_revenue']);
    final totalExpenses = _toDouble(data['total_expenses']);
    final netRevenue = _toDouble(data['net_revenue'] ?? (totalRevenue - totalExpenses));
    final txCount = data['transaction_count'] as int? ?? 0;
    final byMethod = data['by_method'] as List? ?? [];

    await Printing.layoutPdf(
      onLayout: (_) async {
        final doc = pw.Document();
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context ctx) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${l10n.dailySummaryTitle} — $_dateString',
                  style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${l10n.dailySummaryGrossRevenue}: ${totalRevenue.toStringAsFixed(2)} SAR'),
                    pw.Text('${l10n.dailySummaryTransactions}: $txCount'),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${l10n.dailySummaryExpenses}: ${totalExpenses.toStringAsFixed(2)} SAR'),
                    pw.Text('${l10n.dailySummaryNetRevenue}: ${netRevenue.toStringAsFixed(2)} SAR'),
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(l10n.dailySummaryRevenueByMethod, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...byMethod.map((item) {
                  final method = item['method'] as String? ?? '';
                  final amount = _toDouble(item['amount']);
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [pw.Text(method), pw.Text('${amount.toStringAsFixed(2)} SAR')],
                    ),
                  );
                }),
              ],
            ),
          ),
        );
        return doc.save();
      },
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

void showDailySummaryInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showPosInfoDialog(context, title: l10n.dailySummaryTitle, message: l10n.dailySummaryInfoMessage);
}
