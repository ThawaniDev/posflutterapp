import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/services/payment_calculation_service.dart';

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

    return PosListPage(
      title: AppLocalizations.of(context)!.cashMgmtTitle,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showCashManagementInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      child: SingleChildScrollView(
        padding: context.responsivePagePadding,
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
      return PosCard(
        borderRadius: AppRadius.borderLg,
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
              context.isPhone
                  ? Column(
                      children: [
                        _infoTileCompact(
                          theme,
                          AppLocalizations.of(context)!.cashMgmtOpeningFloat,
                          '${activeSession.openingFloat.toStringAsFixed(2)} ${AppLocalizations.of(context)!.sarCurrency}',
                        ),
                        AppSpacing.gapH8,
                        _infoTileCompact(
                          theme,
                          AppLocalizations.of(context)!.cashMgmtExpectedCash,
                          '${(activeSession.expectedCash ?? 0).toStringAsFixed(2)} ${AppLocalizations.of(context)!.sarCurrency}',
                        ),
                        AppSpacing.gapH8,
                        _infoTileCompact(
                          theme,
                          AppLocalizations.of(context)!.cashMgmtTerminal,
                          activeSession.terminalId ?? AppLocalizations.of(context)!.cashMgmtNA,
                        ),
                      ],
                    )
                  : Row(
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
              context.isPhone
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: PosButton(
                                onPressed: () => _showCashInOutDialog(context, 'cash_in', activeSession.id),
                                icon: Icons.add,
                                variant: PosButtonVariant.outline,
                                label: AppLocalizations.of(context)!.cashMgmtCashIn,
                                isFullWidth: true,
                              ),
                            ),
                            AppSpacing.gapW8,
                            Expanded(
                              child: PosButton(
                                onPressed: () => _showCashInOutDialog(context, 'cash_out', activeSession.id),
                                icon: Icons.remove,
                                variant: PosButtonVariant.outline,
                                label: AppLocalizations.of(context)!.cashMgmtCashOut,
                                isFullWidth: true,
                              ),
                            ),
                          ],
                        ),
                        AppSpacing.gapH8,
                        PosButton(
                          onPressed: () => _showCloseSessionDialog(context, activeSession.id),
                          icon: Icons.lock,
                          variant: PosButtonVariant.danger,
                          label: AppLocalizations.of(context)!.cashMgmtCloseSession,
                          isFullWidth: true,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        PosButton(
                          onPressed: () => _showCashInOutDialog(context, 'cash_in', activeSession.id),
                          icon: Icons.add,
                          variant: PosButtonVariant.outline,
                          label: AppLocalizations.of(context)!.cashMgmtCashIn,
                        ),
                        AppSpacing.gapW8,
                        PosButton(
                          onPressed: () => _showCashInOutDialog(context, 'cash_out', activeSession.id),
                          icon: Icons.remove,
                          variant: PosButtonVariant.outline,
                          label: AppLocalizations.of(context)!.cashMgmtCashOut,
                        ),
                        AppSpacing.gapW8,
                        PosButton(
                          onPressed: () => _showCloseSessionDialog(context, activeSession.id),
                          icon: Icons.lock,
                          variant: PosButtonVariant.danger,
                          label: AppLocalizations.of(context)!.cashMgmtCloseSession,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      );
    }

    // No active session — show open button
    return PosCard(
      borderRadius: AppRadius.borderLg,
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
            PosButton(
              onPressed: () => _showOpenSessionDialog(context),
              icon: Icons.lock_open,
              label: AppLocalizations.of(context)!.cashMgmtOpenCashSession,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDenominationCounter(ThemeData theme) {
    final total = PaymentCalculationService.calculateDenominationTotal(_denominationCounts);

    return PosCard(
      borderRadius: AppRadius.borderMd,
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
                      width: context.isPhone ? 80 : 120,
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
                      width: context.isPhone ? 60 : 80,
                      child: PosTextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
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
                    Expanded(
                      child: Text(
                        '${dc.total.toStringAsFixed(2)} \u0081',
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
                  '${total.toStringAsFixed(2)} \u0081',
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
      CashSessionsInitial() || CashSessionsLoading() => const PosLoading(),
      CashSessionsError(:final message) => PosCard(
        color: AppColors.error.withValues(alpha: 0.08),
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Text(message, style: const TextStyle(color: AppColors.error)),
        ),
      ),
      CashSessionsLoaded(:final sessions) =>
        sessions.isEmpty
            ? PosCard(
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
                  return PosCard(
                    borderRadius: AppRadius.borderMd,
                    child: ListTile(
                      leading: Icon(
                        isActive ? Icons.lock_open : Icons.lock,
                        color: isActive ? AppColors.success : Theme.of(context).hintColor,
                      ),
                      title: Text(AppLocalizations.of(context)!.cashMgmtFloatLabel(session.openingFloat.toStringAsFixed(2))),
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

  Widget _infoTileCompact(ThemeData theme, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }

  void _showOpenSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.cashMgmtOpenCashSession),
        content: PosTextField(
          controller: _openingFloatController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          label: AppLocalizations.of(ctx)!.cashMgmtOpeningFloatSar,
          autofocus: true,
        ),
        actions: [
          PosButton(
            onPressed: () => Navigator.pop(ctx),
            variant: PosButtonVariant.ghost,
            label: AppLocalizations.of(ctx)!.posCancel,
          ),
          PosButton(
            onPressed: () {
              final amount = double.tryParse(_openingFloatController.text);
              if (amount != null && amount >= 0) {
                ref.read(cashSessionsProvider.notifier).openSession({'opening_float': amount});
                Navigator.pop(ctx);
                _openingFloatController.clear();
              }
            },
            variant: PosButtonVariant.soft,
            label: AppLocalizations.of(ctx)!.cashMgmtOpenSession,
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
            PosTextField(controller: _closeNotesController, maxLines: 3, label: AppLocalizations.of(ctx)!.cashMgmtNotesOptional),
          ],
        ),
        actions: [
          PosButton(
            onPressed: () => Navigator.pop(ctx),
            variant: PosButtonVariant.ghost,
            label: AppLocalizations.of(ctx)!.posCancel,
          ),
          PosButton(
            onPressed: () {
              ref.read(cashSessionsProvider.notifier).closeSession(sessionId, {
                'actual_cash': totalCount,
                'close_notes': _closeNotesController.text.isEmpty ? null : _closeNotesController.text,
              });
              Navigator.pop(ctx);
              _closeNotesController.clear();
            },
            variant: PosButtonVariant.soft,
            label: AppLocalizations.of(ctx)!.cashMgmtCloseSession,
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
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosTextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                label: AppLocalizations.of(ctx)!.cashMgmtAmountSar,
                autofocus: true,
              ),
              AppSpacing.gapH12,
              PosSearchableDropdown<String>(
                hint: AppLocalizations.of(ctx)!.selectReason,
                items:
                    (type == 'cash_out'
                            ? ['petty_cash', 'supplier_payment', 'bank_deposit', 'other']
                            : ['tips', 'change_replenish', 'other'])
                        .map((r) => PosDropdownItem(value: r, label: r.replaceAll('_', ' ')))
                        .toList(),
                selectedValue: reasonController.text.isEmpty ? null : reasonController.text,
                onChanged: (v) => reasonController.text = v ?? '',
                label: AppLocalizations.of(ctx)!.cashMgmtReason,
                showSearch: false,
                clearable: false,
              ),
              AppSpacing.gapH12,
              PosTextField(controller: notesController, label: AppLocalizations.of(ctx)!.cashMgmtNotesOptional),
            ],
          ),
        ),
        actions: [
          PosButton(
            onPressed: () => Navigator.pop(ctx),
            variant: PosButtonVariant.ghost,
            label: AppLocalizations.of(ctx)!.posCancel,
          ),
          PosButton(
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
            variant: PosButtonVariant.soft,
            label: AppLocalizations.of(ctx)!.cashMgmtRecord,
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
