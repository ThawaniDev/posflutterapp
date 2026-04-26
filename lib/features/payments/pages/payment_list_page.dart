import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/payment_method_key.dart';
import 'package:wameedpos/features/payments/models/payment.dart';
import 'package:wameedpos/features/payments/models/refund.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';
import 'package:wameedpos/features/payments/repositories/payment_repository.dart';
import 'package:wameedpos/features/payments/services/payment_calculation_service.dart';

class PaymentListPage extends ConsumerStatefulWidget {
  const PaymentListPage({super.key});

  @override
  ConsumerState<PaymentListPage> createState() => _PaymentListPageState();
}

class _PaymentListPageState extends ConsumerState<PaymentListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  String? _selectedMethod;
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;
  final _searchController = TextEditingController();
  bool _filtersExpanded = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_reload);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    ref.read(paymentsProvider.notifier).load(
          method: _selectedMethod,
          status: _selectedStatus,
          startDate: _startDate != null ? _fmt(_startDate!) : null,
          endDate: _endDate != null ? _fmt(_endDate!) : null,
          search: _searchController.text.isEmpty ? null : _searchController.text,
        );
  }

  String _fmt(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(paymentsProvider);

    return PosListPage(
      title: l10n.paymentListTitle,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showPaymentListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: _filtersExpanded ? Icons.filter_list_off : Icons.filter_list,
          tooltip: l10n.paymentListFilters,
          onPressed: () => setState(() => _filtersExpanded = !_filtersExpanded),
          variant: _filtersExpanded ? PosButtonVariant.soft : PosButtonVariant.ghost,
        ),
      ],
      isLoading: state is PaymentsInitial || state is PaymentsLoading,
      hasError: state is PaymentsError,
      errorMessage: state is PaymentsError ? (state).message : null,
      onRetry: _reload,
      isEmpty: state is PaymentsLoaded && (state).payments.isEmpty,
      emptyTitle: l10n.paymentListEmpty,
      emptyIcon: Icons.payments_outlined,
      child: Column(
        children: [
          // ── Filter Panel ──
          if (_filtersExpanded) _buildFilterPanel(theme),

          // ── Payment List ──
          Expanded(
            child: switch (state) {
              PaymentsLoaded(:final payments, :final hasMore) => _buildList(theme, payments, hasMore),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterPanel(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          // Search + Date Range
          Row(
            children: [
              Expanded(
                flex: 3,
                child: PosTextField(
                  controller: _searchController,
                  label: l10n.paymentListSearchHint,
                  prefixIcon: Icons.search,
                  onChanged: (_) => _debounceReload(),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                flex: 2,
                child: GestureDetector(
                  onTap: () => _pickDateRange(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor),
                      borderRadius: AppRadius.borderMd,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.date_range, size: 18, color: theme.hintColor),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            _startDate != null && _endDate != null
                                ? '${_fmt(_startDate!)} – ${_fmt(_endDate!)}'
                                : l10n.paymentListDateRange,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: _startDate != null ? null : theme.hintColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (_startDate != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _startDate = null;
                                _endDate = null;
                              });
                              _reload();
                            },
                            child: Icon(Icons.clear, size: 16, color: theme.hintColor),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH12,
          // Method + Status dropdowns
          Row(
            children: [
              Expanded(
                child: PosSearchableDropdown<String>(
                  hint: l10n.paymentListMethod,
                  items: [
                    ...PaymentMethodKey.values.map(
                      (m) => PosDropdownItem(value: m.value, label: PaymentCalculationService.methodDisplayName(m)),
                    ),
                  ],
                  selectedValue: _selectedMethod,
                  onChanged: (v) {
                    setState(() => _selectedMethod = v);
                    _reload();
                  },
                  label: l10n.paymentListMethod,
                  showSearch: false,
                  clearable: true,
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: PosSearchableDropdown<String>(
                  hint: l10n.paymentListStatus,
                  items: [
                    PosDropdownItem(value: 'completed', label: l10n.paymentStatusCompleted),
                    PosDropdownItem(value: 'refunded', label: l10n.paymentStatusRefunded),
                    PosDropdownItem(value: 'partial_refund', label: l10n.paymentStatusPartialRefund),
                    PosDropdownItem(value: 'failed', label: l10n.paymentStatusFailed),
                  ],
                  selectedValue: _selectedStatus,
                  onChanged: (v) {
                    setState(() => _selectedStatus = v);
                    _reload();
                  },
                  label: l10n.paymentListStatus,
                  showSearch: false,
                  clearable: true,
                ),
              ),
              AppSpacing.gapW8,
              PosButton(
                label: l10n.commonClear,
                variant: PosButtonVariant.ghost,
                onPressed: () {
                  setState(() {
                    _selectedMethod = null;
                    _selectedStatus = null;
                    _startDate = null;
                    _endDate = null;
                    _searchController.clear();
                  });
                  _reload();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildList(ThemeData theme, List<Payment> payments, bool hasMore) {
    return ListView.separated(
      padding: AppSpacing.paddingAll16,
      itemCount: payments.length + (hasMore ? 1 : 0),
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        if (index == payments.length) {
          return Padding(
            padding: AppSpacing.paddingAll16,
            child: Center(
              child: PosButton(
                label: 'Load more',
                variant: PosButtonVariant.outline,
                onPressed: () => ref.read(paymentsProvider.notifier).loadMore(),
              ),
            ),
          );
        }
        final payment = payments[index];
        return _PaymentRow(
          payment: payment,
          onTap: () => _showPaymentDetail(context, payment),
        );
      },
    );
  }

  void _showPaymentDetail(BuildContext context, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _PaymentDetailSheet(payment: payment),
    );
  }

  void _pickDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _reload();
    }
  }

  void _debounceReload() {
    Future.delayed(const Duration(milliseconds: 400), _reload);
  }
}

// ─── Payment Row ────────────────────────────────────────────────

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment, required this.onTap});
  final Payment payment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final methodColor = _methodColor(payment.method.value);
    final status = payment.status ?? 'completed';

    return PosCard(
      borderRadius: AppRadius.borderMd,
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Row(
          children: [
            // Method badge
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: methodColor.withValues(alpha: 0.12),
                borderRadius: AppRadius.borderMd,
              ),
              child: Icon(_methodIcon(payment.method), color: methodColor, size: 20),
            ),
            AppSpacing.gapW12,
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        PaymentCalculationService.methodDisplayName(payment.method),
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      AppSpacing.gapW8,
                      _StatusChip(status: status),
                    ],
                  ),
                  AppSpacing.gapH2,
                  Text(
                    payment.transactionId,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (payment.createdAt != null)
                    Text(
                      _formatDateTime(payment.createdAt!),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                    ),
                ],
              ),
            ),
            // Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${payment.amount.toStringAsFixed(2)} \u0631',
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Icon(Icons.chevron_right, size: 16, color: theme.hintColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _methodColor(String method) => switch (method) {
        'cash' => AppColors.success,
        'card_mada' => const Color(0xFF00897B),
        'card_visa' => const Color(0xFF1A237E),
        'card_mastercard' => const Color(0xFFE65100),
        'store_credit' => AppColors.info,
        'gift_card' => AppColors.warning,
        _ => AppColors.primary,
      };

  IconData _methodIcon(PaymentMethodKey method) => switch (method) {
        PaymentMethodKey.cash => Icons.payments,
        PaymentMethodKey.cardMada || PaymentMethodKey.card => Icons.credit_card,
        PaymentMethodKey.cardVisa => Icons.credit_card,
        PaymentMethodKey.cardMastercard => Icons.credit_card,
        PaymentMethodKey.mada => Icons.credit_card,
        PaymentMethodKey.applePay => Icons.phone_iphone,
        PaymentMethodKey.stcPay => Icons.phone_android,
        PaymentMethodKey.giftCard => Icons.card_giftcard,
        PaymentMethodKey.storeCredit => Icons.account_balance_wallet,
        PaymentMethodKey.loyaltyPoints => Icons.stars,
        PaymentMethodKey.bankTransfer => Icons.account_balance,
        _ => Icons.payment,
      };

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Status Chip ────────────────────────────────────────────────

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      'completed' => (AppColors.success, AppLocalizations.of(context)!.paymentStatusCompleted),
      'refunded' => (AppColors.error, AppLocalizations.of(context)!.paymentStatusRefunded),
      'partial_refund' => (AppColors.warning, AppLocalizations.of(context)!.paymentStatusPartialRefund),
      'failed' => (AppColors.error, AppLocalizations.of(context)!.paymentStatusFailed),
      _ => (AppColors.info, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.borderFull,
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Payment Detail Sheet ────────────────────────────────────────

class _PaymentDetailSheet extends ConsumerStatefulWidget {
  const _PaymentDetailSheet({required this.payment});
  final Payment payment;

  @override
  ConsumerState<_PaymentDetailSheet> createState() => _PaymentDetailSheetState();
}

class _PaymentDetailSheetState extends ConsumerState<_PaymentDetailSheet> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  List<Refund> _refunds = [];
  bool _loadingRefunds = false;

  @override
  void initState() {
    super.initState();
    _loadRefunds();
  }

  Future<void> _loadRefunds() async {
    setState(() => _loadingRefunds = true);
    try {
      final result = await ref.read(paymentRepositoryProvider).listPaymentRefunds(widget.payment.id);
      if (mounted) setState(() => _refunds = result.items);
    } catch (_) {
      // ignore
    } finally {
      if (mounted) setState(() => _loadingRefunds = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final payment = widget.payment;
    final canRefund = payment.status == 'completed' || payment.status == null;

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, controller) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: theme.dividerColor, borderRadius: AppRadius.borderFull),
              ),
            ),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.paymentDetailTitle, style: theme.textTheme.titleLarge),
                if (canRefund)
                  PosButton(
                    label: l10n.paymentListRefund,
                    icon: Icons.undo,
                    variant: PosButtonVariant.outline,
                    onPressed: () => _showRefundDialog(context, payment),
                  ),
              ],
            ),
            AppSpacing.gapH16,
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  // Transaction Details
                  _DetailSection(
                    theme: theme,
                    title: l10n.paymentDetailInfo,
                    rows: [
                      (l10n.paymentDetailMethod, PaymentCalculationService.methodDisplayName(payment.method)),
                      (l10n.paymentDetailAmount, '${payment.amount.toStringAsFixed(2)} \u0631'),
                      if (payment.cashTendered != null)
                        (l10n.paymentDetailCashTendered, '${payment.cashTendered!.toStringAsFixed(2)} \u0631'),
                      if (payment.changeGiven != null)
                        (l10n.paymentDetailChange, '${payment.changeGiven!.toStringAsFixed(2)} \u0631'),
                      if (payment.tipAmount != null && payment.tipAmount! > 0)
                        (l10n.paymentDetailTip, '${payment.tipAmount!.toStringAsFixed(2)} \u0631'),
                      (l10n.paymentDetailStatus, payment.status ?? 'completed'),
                      (l10n.paymentDetailTransactionId, payment.transactionId),
                      if (payment.cardBrand != null) (l10n.paymentDetailCard, '${payment.cardBrand} **** ${payment.cardLastFour ?? ''}'),
                      if (payment.nearpayTransactionId != null) ('NearPay ID', payment.nearpayTransactionId!),
                      if (payment.giftCardCode != null) (l10n.paymentDetailGiftCard, payment.giftCardCode!),
                      if (payment.createdAt != null)
                        (l10n.paymentDetailDate, _formatDateTime(payment.createdAt!)),
                    ],
                  ),
                  AppSpacing.gapH16,

                  // Refund History
                  Text(l10n.paymentDetailRefunds, style: theme.textTheme.titleSmall),
                  AppSpacing.gapH8,
                  if (_loadingRefunds)
                    const Center(child: CircularProgressIndicator())
                  else if (_refunds.isEmpty)
                    Text(l10n.paymentDetailNoRefunds, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor))
                  else
                    ..._refunds.map(
                      (r) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: AppSpacing.paddingAll12,
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.05),
                          border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
                          borderRadius: AppRadius.borderMd,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${r.amount.toStringAsFixed(2)} \u0631',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  r.method.value.replaceAll('_', ' '),
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                                ),
                              ],
                            ),
                            if (r.createdAt != null)
                              Text(
                                _formatDateTime(r.createdAt!),
                                style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor, fontSize: 11),
                              ),
                          ],
                        ),
                      ),
                    ),
                  AppSpacing.gapH24,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRefundDialog(BuildContext context, Payment payment) {
    final amountController = TextEditingController(text: payment.amount.toStringAsFixed(2));
    final refController = TextEditingController();
    PaymentMethodKey selectedMethod = payment.method;
    bool isLoading = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.paymentListRefund),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(
                  controller: amountController,
                  label: l10n.refundAmount,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                AppSpacing.gapH16,
                PosSearchableDropdown<PaymentMethodKey>(
                  hint: l10n.refundMethod,
                  items: PaymentMethodKey.values
                      .map((m) => PosDropdownItem(value: m, label: PaymentCalculationService.methodDisplayName(m)))
                      .toList(),
                  selectedValue: selectedMethod,
                  onChanged: (v) => setDialogState(() => selectedMethod = v ?? selectedMethod),
                  label: l10n.refundMethod,
                  showSearch: false,
                  clearable: false,
                ),
                AppSpacing.gapH16,
                PosTextField(
                  controller: refController,
                  label: l10n.refundReference,
                ),
              ],
            ),
          ),
          actions: [
            PosButton(
              onPressed: () => Navigator.pop(ctx),
              variant: PosButtonVariant.ghost,
              label: l10n.cancel,
            ),
            PosButton(
              isLoading: isLoading,
              onPressed: isLoading
                  ? null
                  : () async {
                      final amount = double.tryParse(amountController.text);
                      if (amount == null || amount <= 0) return;
                      setDialogState(() => isLoading = true);
                      final refund = await ref.read(refundsProvider.notifier).createRefund(payment.id, {
                        'amount': amount,
                        'method': selectedMethod.value,
                        if (refController.text.isNotEmpty) 'reference_number': refController.text,
                      });
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (refund != null && context.mounted) {
                        showPosSuccessSnackbar(context, l10n.refundCreatedSuccess);
                        _loadRefunds();
                      }
                    },
              label: l10n.refundSubmit,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ─── Detail Section ──────────────────────────────────────────────

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.theme, required this.title, required this.rows});
  final ThemeData theme;
  final String title;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return PosCard(
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall),
            AppSpacing.gapH12,
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(row.$1, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    Flexible(
                      child: Text(
                        row.$2,
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.end,
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
}

void showPaymentListInfo(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  showPosInfoDialog(context, title: l10n.paymentListTitle, message: l10n.paymentListInfoMessage);
}
