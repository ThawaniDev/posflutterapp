import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/services/payment_calculation_service.dart';

class FinancialReconciliationPage extends ConsumerStatefulWidget {
  const FinancialReconciliationPage({super.key});

  @override
  ConsumerState<FinancialReconciliationPage> createState() => _FinancialReconciliationPageState();
}

class _FinancialReconciliationPageState extends ConsumerState<FinancialReconciliationPage> {
  late List<DenominationCount> _denominationCounts;
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 6));
  DateTime _endDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _denominationCounts = PaymentCalculationService.createDenominationCounts();
    Future.microtask(_reload);
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _reload() {
    ref.read(reconciliationProvider.notifier).load(startDate: _fmt(_startDate), endDate: _fmt(_endDate));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(reconciliationProvider);
    final data = state is ReconciliationLoaded ? state.data : null;
    final isLoading = state is ReconciliationLoading || state is ReconciliationInitial;

    return PosListPage(
      title: l10n.finReconTitle,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showFinancialReconciliationInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(
          label: '${_fmt(_startDate)} – ${_fmt(_endDate)}',
          icon: Icons.date_range,
          variant: PosButtonVariant.outline,
          onPressed: () => _pickDateRange(context),
        ),
      ],
      isLoading: isLoading,
      hasError: state is ReconciliationError,
      errorMessage: state is ReconciliationError ? (state).message : null,
      onRetry: _reload,
      child: data == null
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              padding: context.responsivePagePadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Revenue Summary ──
                  _buildRevenueSection(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Payment Method Breakdown ──
                  _buildPaymentBreakdown(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Cash Reconciliation ──
                  _buildCashReconciliation(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Expenses Summary ──
                  _buildExpensesSummary(theme, data, l10n),
                  AppSpacing.gapH24,

                  // ── Denomination Count ──
                  Text(l10n.finReconPhysicalCashCount, style: theme.textTheme.titleMedium),
                  AppSpacing.gapH12,
                  _buildCompactDenominations(theme, l10n),
                  AppSpacing.gapH24,

                  // ── Actions ──
                  context.isPhone
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: PosButton(
                                    onPressed: () => _printReport(context, data, l10n),
                                    variant: PosButtonVariant.outline,
                                    icon: Icons.print,
                                    label: l10n.finReconPrintReport,
                                  ),
                                ),
                                AppSpacing.gapW8,
                                Expanded(
                                  child: PosButton(
                                    onPressed: () => _exportPdf(context, data, l10n),
                                    variant: PosButtonVariant.outline,
                                    icon: Icons.download,
                                    label: l10n.finReconExportPdf,
                                  ),
                                ),
                              ],
                            ),
                            AppSpacing.gapH8,
                            PosButton(
                              onPressed: () => _confirmReconciliation(context),
                              icon: Icons.check_circle_outline,
                              label: l10n.finReconConfirmRecon,
                              isFullWidth: true,
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            PosButton(
                              onPressed: () => _printReport(context, data, l10n),
                              variant: PosButtonVariant.outline,
                              icon: Icons.print,
                              label: l10n.finReconPrintReport,
                            ),
                            AppSpacing.gapW8,
                            PosButton(
                              onPressed: () => _exportPdf(context, data, l10n),
                              variant: PosButtonVariant.outline,
                              icon: Icons.download,
                              label: l10n.finReconExportPdf,
                            ),
                            AppSpacing.gapW8,
                            PosButton(
                              onPressed: () => _confirmReconciliation(context),
                              icon: Icons.check_circle_outline,
                              label: l10n.finReconConfirmRecon,
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }

  Widget _buildRevenueSection(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final totalRevenue = _toDouble(data['total_revenue']);
    final txCount = data['transaction_count'] as int? ?? 0;

    return PosCard(
      borderRadius: AppRadius.borderLg,
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.finReconRevenueSummary, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            _buildSummaryTiles(theme, l10n, txCount, totalRevenue),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentBreakdown(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final byMethod = data['by_method'] as List? ?? [];
    final total = byMethod.fold<double>(0, (s, item) => s + _toDouble(item['amount']));

    return PosCard(
      borderRadius: AppRadius.borderLg,
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
              ...byMethod.map((item) {
                final method = item['method'] as String? ?? '';
                final amount = _toDouble(item['amount']);
                final pct = total > 0 ? (amount / total * 100) : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(method.replaceAll('_', ' '), style: theme.textTheme.bodyMedium),
                          Text(
                            '${amount.toStringAsFixed(2)} \u0631 (${pct.toStringAsFixed(1)}%)',
                            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      AppSpacing.gapH4,
                      LinearProgressIndicator(
                        value: total > 0 ? amount / total : 0,
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

  Widget _buildCashReconciliation(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final totalExpected = _toDouble(data['expected_cash']);
    final totalActual = _toDouble(data['actual_cash']);
    final totalVariance = _toDouble(data['cash_variance'] ?? (totalActual - totalExpected));
    final sessionsClosed = data['sessions_closed'] as int? ?? 0;

    return PosCard(
      borderRadius: AppRadius.borderLg,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.finReconCashRecon, style: theme.textTheme.titleMedium),
            AppSpacing.gapH16,
            _buildCashReconTiles(theme, l10n, totalExpected, totalActual, totalVariance),
            if (sessionsClosed > 0) ...[
              AppSpacing.gapH16,
              Text(
                l10n.finReconSessionsClosed(sessionsClosed),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExpensesSummary(ThemeData theme, Map<String, dynamic> data, AppLocalizations l10n) {
    final totalExpenses = _toDouble(data['total_expenses']);
    final byCategory = data['expenses_by_category'] as List? ?? [];

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
                Text(l10n.finReconExpenses, style: theme.textTheme.titleMedium),
                Text(
                  '${totalExpenses.toStringAsFixed(2)} \u0631',
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
                children: byCategory.map((e) {
                  final cat = e['category'] as String? ?? '';
                  final amt = _toDouble(e['amount']);
                  return Chip(
                    label: Text('${cat.replaceAll('_', ' ')}: ${amt.toStringAsFixed(2)} \u0631', style: const TextStyle(fontSize: 12)),
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
    return PosCard(
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: context.isPhone ? 2 : 4,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _denominationCounts.length,
              itemBuilder: (context, index) {
                final dc = _denominationCounts[index];
                return PosTextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  label: dc.denomination.label,
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
                  '${total.toStringAsFixed(2)} \u0631',
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
            Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
            AppSpacing.gapH2,
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          ],
        ),
      ),
    );
  }

  Widget _summaryTileFullWidth(ThemeData theme, String label, String value, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: AppRadius.borderMd),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryTiles(ThemeData theme, AppLocalizations l10n, int txCount, double totalRevenue) {
    if (context.isPhone) {
      return Column(
        children: [
          _summaryTileFullWidth(theme, l10n.finReconTotalRevenue, '${totalRevenue.toStringAsFixed(2)} \u0631', Icons.trending_up, AppColors.success),
          AppSpacing.gapH8,
          _summaryTileFullWidth(theme, l10n.finReconTransactions, '$txCount', Icons.receipt_long, AppColors.info),
          AppSpacing.gapH8,
          _summaryTileFullWidth(
            theme,
            l10n.finReconAvgTransaction,
            txCount > 0 ? '${(totalRevenue / txCount).toStringAsFixed(2)} \u0631' : '0.00 \u0631',
            Icons.analytics,
            AppColors.primary,
          ),
        ],
      );
    }
    return Row(
      children: [
        _summaryTile(theme, l10n.finReconTotalRevenue, '${totalRevenue.toStringAsFixed(2)} \u0631', Icons.trending_up, AppColors.success),
        AppSpacing.gapW16,
        _summaryTile(theme, l10n.finReconTransactions, '$txCount', Icons.receipt_long, AppColors.info),
        AppSpacing.gapW16,
        _summaryTile(
          theme,
          l10n.finReconAvgTransaction,
          txCount > 0 ? '${(totalRevenue / txCount).toStringAsFixed(2)} \u0631' : '0.00 \u0631',
          Icons.analytics,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildCashReconTiles(ThemeData theme, AppLocalizations l10n, double totalExpected, double totalActual, double totalVariance) {
    final varianceColor = totalVariance.abs() > 5 ? AppColors.error : AppColors.success;
    if (context.isPhone) {
      return Column(
        children: [
          _summaryTileFullWidth(theme, l10n.finReconExpectedCash, '${totalExpected.toStringAsFixed(2)} \u0631', Icons.calculate, AppColors.info),
          AppSpacing.gapH8,
          _summaryTileFullWidth(theme, l10n.finReconActualCash, '${totalActual.toStringAsFixed(2)} \u0631', Icons.payments, AppColors.primary),
          AppSpacing.gapH8,
          _summaryTileFullWidth(theme, l10n.finReconVariance, '${totalVariance >= 0 ? '+' : ''}${totalVariance.toStringAsFixed(2)} \u0631', Icons.compare_arrows, varianceColor),
        ],
      );
    }
    return Row(
      children: [
        _summaryTile(theme, l10n.finReconExpectedCash, '${totalExpected.toStringAsFixed(2)} \u0631', Icons.calculate, AppColors.info),
        AppSpacing.gapW16,
        _summaryTile(theme, l10n.finReconActualCash, '${totalActual.toStringAsFixed(2)} \u0631', Icons.payments, AppColors.primary),
        AppSpacing.gapW16,
        _summaryTile(theme, l10n.finReconVariance, '${totalVariance >= 0 ? '+' : ''}${totalVariance.toStringAsFixed(2)} \u0631', Icons.compare_arrows, varianceColor),
      ],
    );
  }

  void _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _reload();
    }
  }

  Future<void> _printReport(BuildContext context, Map<String, dynamic> data, AppLocalizations l10n) async {
    await _generateAndPrint(data, l10n, printMode: true);
  }

  Future<void> _exportPdf(BuildContext context, Map<String, dynamic> data, AppLocalizations l10n) async {
    await _generateAndPrint(data, l10n, printMode: false);
  }

  Future<void> _generateAndPrint(Map<String, dynamic> data, AppLocalizations l10n, {required bool printMode}) async {
    final totalRevenue = _toDouble(data['total_revenue']);
    final totalExpenses = _toDouble(data['total_expenses']);
    final cashVariance = _toDouble(data['cash_variance']);
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
                pw.Text(l10n.finReconTitle, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('${_fmt(_startDate)} – ${_fmt(_endDate)}', style: const pw.TextStyle(fontSize: 12)),
                pw.Divider(),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${l10n.finReconTotalRevenue}: ${totalRevenue.toStringAsFixed(2)} SAR'),
                    pw.Text('${l10n.finReconTransactions}: $txCount'),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('${l10n.finReconExpenses}: ${totalExpenses.toStringAsFixed(2)} SAR'),
                    pw.Text('${l10n.finReconVariance}: ${cashVariance >= 0 ? '+' : ''}${cashVariance.toStringAsFixed(2)} SAR'),
                  ],
                ),
                pw.SizedBox(height: 12),
                pw.Text(l10n.finReconPaymentMethods, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                ...byMethod.map((item) {
                  final method = item['method'] as String? ?? '';
                  final amount = _toDouble(item['amount']);
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(method.replaceAll('_', ' ')),
                        pw.Text('${amount.toStringAsFixed(2)} SAR'),
                      ],
                    ),
                  );
                }),
                pw.SizedBox(height: 12),
                pw.Text(
                  l10n.finReconPhysicalCashCount,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 6),
                pw.Text('${l10n.finReconCountedTotal}: ${PaymentCalculationService.calculateDenominationTotal(_denominationCounts).toStringAsFixed(2)} SAR'),
              ],
            ),
          ),
        );
        return doc.save();
      },
    );
  }

  void _confirmReconciliation(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.finReconConfirmRecon,
      message: l10n.finReconConfirmMessage,
      confirmLabel: l10n.commonConfirm,
    );
    if (confirmed == true && mounted) {
      showPosSuccessSnackbar(context, l10n.finReconConfirmed);
    }
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    return double.tryParse(value.toString()) ?? 0.0;
  }
}

void showFinancialReconciliationInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showPosInfoDialog(context, title: l10n.finReconTitle, message: l10n.finReconInfoMessage);
}

