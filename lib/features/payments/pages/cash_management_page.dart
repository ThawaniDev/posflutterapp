import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/payments/providers/payment_providers.dart';
import 'package:thawani_pos/features/payments/providers/payment_state.dart';
import 'package:thawani_pos/features/payments/services/payment_calculation_service.dart';

class CashManagementPage extends ConsumerStatefulWidget {
  const CashManagementPage({super.key});

  @override
  ConsumerState<CashManagementPage> createState() => _CashManagementPageState();
}

class _CashManagementPageState extends ConsumerState<CashManagementPage> {
  final _openingFloatController = TextEditingController();
  final _closeNotesController = TextEditingController();
  late List<DenominationCount> _denominationCounts;

  @override
  void initState() {
    super.initState();
    _denominationCounts = PaymentCalculationService.createDenominationCounts();
    Future.microtask(() => ref.read(cashSessionsProvider.notifier).load());
  }

  @override
  void dispose() {
    _openingFloatController.dispose();
    _closeNotesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sessionsState = ref.watch(cashSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.cashMgmtTitle)),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Active Session Card ──
            _buildActiveSessionCard(theme, sessionsState),

            AppSpacing.gapH24,

            // ── Denomination Counter ──
            Text(AppLocalizations.of(context)!.cashMgmtCashCount, style: theme.textTheme.titleMedium),
            AppSpacing.gapH12,
            _buildDenominationCounter(theme),

            AppSpacing.gapH24,

            // ── Session History ──
            Text(AppLocalizations.of(context)!.cashMgmtSessionHistory, style: theme.textTheme.titleMedium),
            AppSpacing.gapH12,
            _buildSessionHistory(sessionsState),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveSessionCard(ThemeData theme, CashSessionsState state) {
    final activeSession = switch (state) {
      CashSessionsLoaded(:final sessions) => sessions.where((s) => s.status?.value == 'open').firstOrNull,
      _ => null,
    };

    if (activeSession != null) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle),
                  ),
                  AppSpacing.gapW8,
                  Text(AppLocalizations.of(context)!.cashMgmtActiveSession, style: theme.textTheme.titleSmall),
                  const Spacer(),
                  Text(
                    '${AppLocalizations.of(context)!.cashMgmtOpened}: ${_formatTime(activeSession.openedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                ],
              ),
              AppSpacing.gapH16,
              Row(
                children: [
                  _infoTile(
                    theme,
                    AppLocalizations.of(context)!.cashMgmtOpeningFloat,
                    '${activeSession.openingFloat.toStringAsFixed(2)} ${AppLocalizations.of(context)!.sarCurrency}',
                  ),
                  AppSpacing.gapW16,
                  _infoTile(
                    theme,
                    AppLocalizations.of(context)!.cashMgmtExpectedCash,
                    '${(activeSession.expectedCash ?? 0).toStringAsFixed(2)} ${AppLocalizations.of(context)!.sarCurrency}',
                  ),
                  AppSpacing.gapW16,
                  _infoTile(
                    theme,
                    AppLocalizations.of(context)!.cashMgmtTerminal,
                    activeSession.terminalId ?? AppLocalizations.of(context)!.cashMgmtNA,
                  ),
                ],
              ),
              AppSpacing.gapH16,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _showCashInOutDialog(context, 'cash_in', activeSession.id),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(AppLocalizations.of(context)!.cashMgmtCashIn),
                  ),
                  AppSpacing.gapW8,
                  OutlinedButton.icon(
                    onPressed: () => _showCashInOutDialog(context, 'cash_out', activeSession.id),
                    icon: const Icon(Icons.remove, size: 18),
                    label: Text(AppLocalizations.of(context)!.cashMgmtCashOut),
                  ),
                  AppSpacing.gapW8,
                  FilledButton.icon(
                    onPressed: () => _showCloseSessionDialog(context, activeSession.id),
                    icon: const Icon(Icons.lock, size: 18),
                    label: Text(AppLocalizations.of(context)!.cashMgmtCloseSession),
                    style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // No active session — show open button
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          children: [
            Icon(Icons.point_of_sale, size: 48, color: theme.hintColor),
            AppSpacing.gapH12,
            Text(AppLocalizations.of(context)!.cashMgmtNoActiveSession, style: theme.textTheme.titleSmall),
            AppSpacing.gapH8,
            Text(
              AppLocalizations.of(context)!.cashMgmtNoActiveSessionSubtitle,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
            AppSpacing.gapH16,
            FilledButton.icon(
              onPressed: () => _showOpenSessionDialog(context),
              icon: const Icon(Icons.lock_open, size: 18),
              label: Text(AppLocalizations.of(context)!.cashMgmtOpenCashSession),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDenominationCounter(ThemeData theme) {
    final total = PaymentCalculationService.calculateDenominationTotal(_denominationCounts);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          children: [
            // Denomination rows
            ..._denominationCounts.map(
              (dc) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        dc.denomination.label,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: dc.denomination.isCoin ? FontWeight.normal : FontWeight.w600,
                        ),
                      ),
                    ),
                    const Text('×'),
                    AppSpacing.gapW8,
                    SizedBox(
                      width: 80,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                        ),
                        onChanged: (v) {
                          setState(() {
                            dc.count = int.tryParse(v) ?? 0;
                          });
                        },
                      ),
                    ),
                    AppSpacing.gapW12,
                    const Text('='),
                    AppSpacing.gapW8,
                    SizedBox(
                      width: 100,
                      child: Text(
                        '${dc.total.toStringAsFixed(2)} SAR',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 24),
            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.cashMgmtTotalCount, style: theme.textTheme.titleMedium),
                Text(
                  '${total.toStringAsFixed(2)} SAR',
                  style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionHistory(CashSessionsState state) {
    return switch (state) {
      CashSessionsInitial() || CashSessionsLoading() => const Center(child: CircularProgressIndicator()),
      CashSessionsError(:final message) => Card(
        color: AppColors.error.withValues(alpha: 0.08),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Text(message, style: TextStyle(color: AppColors.error)),
        ),
      ),
      CashSessionsLoaded(:final sessions) =>
        sessions.isEmpty
            ? Card(
                child: Padding(
                  padding: AppSpacing.paddingAll24,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.cashMgmtNoSessions,
                      style: TextStyle(color: Theme.of(context).hintColor),
                    ),
                  ),
                ),
              )
            : Column(
                children: sessions.map((session) {
                  final isActive = session.status?.value == 'open';
                  final hasVariance = session.variance != null && session.variance!.abs() > 5;
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
                    child: ListTile(
                      leading: Icon(
                        isActive ? Icons.lock_open : Icons.lock,
                        color: isActive ? AppColors.success : Theme.of(context).hintColor,
                      ),
                      title: Text('Float: ${session.openingFloat.toStringAsFixed(2)} SAR'),
                      subtitle: Text(
                        isActive ? 'Opened ${_formatTime(session.openedAt)}' : 'Closed ${_formatTime(session.closedAt)}',
                      ),
                      trailing: session.variance != null
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: hasVariance
                                    ? AppColors.error.withValues(alpha: 0.1)
                                    : AppColors.success.withValues(alpha: 0.1),
                                borderRadius: AppRadius.borderSm,
                              ),
                              child: Text(
                                '${session.variance! >= 0 ? '+' : ''}${session.variance!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: hasVariance ? AppColors.error : AppColors.successDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
    };
  }

  Widget _infoTile(ThemeData theme, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          AppSpacing.gapH4,
          Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _showOpenSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.cashMgmtOpenCashSession),
        content: TextField(
          controller: _openingFloatController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(ctx)!.cashMgmtOpeningFloatSar,
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(ctx)!.posCancel)),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(_openingFloatController.text);
              if (amount != null && amount >= 0) {
                ref.read(cashSessionsProvider.notifier).openSession({'opening_float': amount});
                Navigator.pop(ctx);
                _openingFloatController.clear();
              }
            },
            child: Text(AppLocalizations.of(ctx)!.cashMgmtOpenSession),
          ),
        ],
      ),
    );
  }

  void _showCloseSessionDialog(BuildContext context, String sessionId) {
    final totalCount = PaymentCalculationService.calculateDenominationTotal(_denominationCounts);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.cashMgmtCloseCashSession),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppLocalizations.of(ctx)!.cashMgmtCountedCash}: ${totalCount.toStringAsFixed(2)} ${AppLocalizations.of(ctx)!.sarCurrency}',
            ),
            AppSpacing.gapH12,
            TextField(
              controller: _closeNotesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx)!.cashMgmtNotesOptional,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(ctx)!.posCancel)),
          FilledButton(
            onPressed: () {
              ref.read(cashSessionsProvider.notifier).closeSession(sessionId, {
                'actual_cash': totalCount,
                'close_notes': _closeNotesController.text.isEmpty ? null : _closeNotesController.text,
              });
              Navigator.pop(ctx);
              _closeNotesController.clear();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.warning),
            child: Text(AppLocalizations.of(ctx)!.cashMgmtCloseSession),
          ),
        ],
      ),
    );
  }

  void _showCashInOutDialog(BuildContext context, String type, String sessionId) {
    final amountController = TextEditingController();
    final reasonController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(type == 'cash_in' ? AppLocalizations.of(ctx)!.cashMgmtCashIn : AppLocalizations.of(ctx)!.cashMgmtCashOut),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx)!.cashMgmtAmountSar,
                border: const OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            AppSpacing.gapH12,
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx)!.cashMgmtReason,
                border: const OutlineInputBorder(),
              ),
              items:
                  (type == 'cash_out'
                          ? ['petty_cash', 'supplier_payment', 'bank_deposit', 'other']
                          : ['tips', 'change_replenish', 'other'])
                      .map((r) => DropdownMenuItem(value: r, child: Text(r.replaceAll('_', ' '))))
                      .toList(),
              onChanged: (v) => reasonController.text = v ?? '',
            ),
            AppSpacing.gapH12,
            TextField(
              controller: notesController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(ctx)!.cashMgmtNotesOptional,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(ctx)!.posCancel)),
          FilledButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              if (amount != null && amount > 0 && reasonController.text.isNotEmpty) {
                ref.read(cashSessionsProvider.notifier).createCashEvent({
                  'cash_session_id': sessionId,
                  'type': type,
                  'amount': amount,
                  'reason': reasonController.text,
                  'notes': notesController.text.isEmpty ? null : notesController.text,
                });
                Navigator.pop(ctx);
              }
            },
            child: Text(AppLocalizations.of(ctx)!.cashMgmtRecord),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return 'N/A';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.day}/${dt.month}/${dt.year}';
  }
}
