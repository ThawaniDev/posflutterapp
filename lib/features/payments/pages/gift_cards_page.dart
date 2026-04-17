import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';

class GiftCardsPage extends ConsumerStatefulWidget {
  const GiftCardsPage({super.key});

  @override
  ConsumerState<GiftCardsPage> createState() => _GiftCardsPageState();
}

class _GiftCardsPageState extends ConsumerState<GiftCardsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PosListPage(
      title: l10n.giftCards,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showGiftCardsInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: PosTabs(
              selectedIndex: _currentTab,
              onChanged: (i) => setState(() => _currentTab = i),
              tabs: [
                PosTabItem(label: l10n.issue, icon: Icons.card_giftcard),
                PosTabItem(label: l10n.checkBalance, icon: Icons.search),
                PosTabItem(label: l10n.redeem, icon: Icons.redeem),
              ],
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: [
                _IssueTab(theme: theme),
                _CheckBalanceTab(theme: theme),
                _RedeemTab(theme: theme),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Issue Tab ──────────────────────────────────────────────────

class _IssueTab extends ConsumerStatefulWidget {
  final ThemeData theme;
  const _IssueTab({required this.theme});

  @override
  ConsumerState<_IssueTab> createState() => _IssueTabState();
}

class _IssueTabState extends ConsumerState<_IssueTab> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _presetAmounts = [50.0, 100.0, 200.0, 500.0];
  double? _selectedPreset;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(giftCardProvider);
    final theme = widget.theme;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.issueNewGiftCard, style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,

          // Preset amounts
          Text(l10n.quickAmount, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          AppSpacing.gapH8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetAmounts.map((amount) {
              final selected = _selectedPreset == amount;
              return ChoiceChip(
                label: Text('${amount.toInt()} \u0081'),
                selected: selected,
                onSelected: (v) {
                  setState(() {
                    _selectedPreset = v ? amount : null;
                    if (v) _amountController.text = amount.toStringAsFixed(0);
                  });
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.2),
              );
            }).toList(),
          ),
          AppSpacing.gapH16,

          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount (\u0081)', border: OutlineInputBorder(), prefixText: '\u0081 '),
            onChanged: (_) => setState(() => _selectedPreset = null),
          ),
          AppSpacing.gapH16,

          TextField(
            controller: _recipientController,
            decoration: InputDecoration(
              labelText: l10n.recipientNameOptional,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          AppSpacing.gapH24,

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state is GiftCardLoading
                  ? null
                  : () {
                      final amount = double.tryParse(_amountController.text);
                      if (amount == null || amount <= 0) return;
                      ref.read(giftCardProvider.notifier).issueGiftCard({
                        'initial_amount': amount,
                        'recipient_name': _recipientController.text.isEmpty ? null : _recipientController.text,
                      });
                    },
              icon: state is GiftCardLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.card_giftcard),
              label: Text(l10n.issueGiftCard),
            ),
          ),
          AppSpacing.gapH24,

          // Result
          if (state is GiftCardReady && state.lastIssued != null) ...[_GiftCardResultCard(card: state.lastIssued!, theme: theme)],
          if (state is GiftCardError) ...[
            PosCard(
              color: AppColors.error.withValues(alpha: 0.08),
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Check Balance Tab ──────────────────────────────────────────

class _CheckBalanceTab extends ConsumerStatefulWidget {
  final ThemeData theme;
  const _CheckBalanceTab({required this.theme});

  @override
  ConsumerState<_CheckBalanceTab> createState() => _CheckBalanceTabState();
}

class _CheckBalanceTabState extends ConsumerState<_CheckBalanceTab> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(giftCardProvider);
    final theme = widget.theme;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.checkGiftCardBalance, style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: l10n.giftCardCode,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
                    hintText: l10n.enterOrScanCode,
                  ),
                ),
              ),
              AppSpacing.gapW12,
              PosButton(
                onPressed: state is GiftCardLoading
                    ? null
                    : () {
                        if (_codeController.text.isEmpty) return;
                        ref.read(giftCardProvider.notifier).checkBalance(_codeController.text);
                      },
                isLoading: state is GiftCardLoading,
                variant: PosButtonVariant.soft,
                label: l10n.check,
              ),
            ],
          ),
          AppSpacing.gapH24,
          if (state is GiftCardReady && state.lastBalance != null) ...[
            PosCard(
              borderRadius: AppRadius.borderLg,
              child: Padding(
                padding: AppSpacing.paddingAll24,
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 48, color: AppColors.primary),
                    AppSpacing.gapH12,
                    Text(
                      '${(state.lastBalance!['balance'] as num?)?.toStringAsFixed(2) ?? '0.00'} \u0081',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    AppSpacing.gapH4,
                    Text(l10n.availableBalance, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    if (state.lastBalance!['status'] != null) ...[
                      AppSpacing.gapH12,
                      _statusBadge(GiftCardStatus.tryFromValue(state.lastBalance!['status'] as String?)),
                    ],
                    if (state.lastBalance!['expires_at'] != null) ...[
                      AppSpacing.gapH8,
                      Text(
                        'Expires: ${state.lastBalance!['expires_at']}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          if (state is GiftCardError) ...[
            PosCard(
              color: AppColors.error.withValues(alpha: 0.08),
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Redeem Tab ─────────────────────────────────────────────────

class _RedeemTab extends ConsumerStatefulWidget {
  final ThemeData theme;
  const _RedeemTab({required this.theme});

  @override
  ConsumerState<_RedeemTab> createState() => _RedeemTabState();
}

class _RedeemTabState extends ConsumerState<_RedeemTab> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _codeController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(giftCardProvider);
    final theme = widget.theme;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.redeemGiftCard, style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,
          TextField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: l10n.giftCardCode,
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
          AppSpacing.gapH16,
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Redemption Amount (\u0081)',
              border: OutlineInputBorder(),
              prefixText: '\u0081 ',
            ),
          ),
          AppSpacing.gapH24,
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: state is GiftCardLoading
                  ? null
                  : () {
                      final amount = double.tryParse(_amountController.text);
                      if (_codeController.text.isEmpty || amount == null || amount <= 0) return;
                      ref.read(giftCardProvider.notifier).redeemGiftCard(_codeController.text, amount);
                    },
              icon: state is GiftCardLoading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.redeem),
              label: Text(l10n.redeem),
            ),
          ),
          AppSpacing.gapH24,
          if (state is GiftCardReady && state.lastIssued != null) ...[_GiftCardResultCard(card: state.lastIssued!, theme: theme)],
          if (state is GiftCardError) ...[
            PosCard(
              color: AppColors.error.withValues(alpha: 0.08),
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────

class _GiftCardResultCard extends StatelessWidget {
  final dynamic card;
  final ThemeData theme;

  const _GiftCardResultCard({required this.card, required this.theme});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosCard(
      borderRadius: AppRadius.borderLg,
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.giftCardIssued, style: theme.textTheme.titleSmall),
                _statusBadge(card.status),
              ],
            ),
            AppSpacing.gapH16,
            Container(
              width: double.infinity,
              padding: AppSpacing.paddingAll16,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.06),
                borderRadius: AppRadius.borderMd,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Text(l10n.code, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                  AppSpacing.gapH4,
                  SelectableText(
                    card.code,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _infoColumn(theme, 'Initial', '${card.initialAmount.toStringAsFixed(2)} \u0081'),
                _infoColumn(theme, 'Balance', '${card.balance.toStringAsFixed(2)} \u0081'),
                if (card.recipientName != null) _infoColumn(theme, 'Recipient', card.recipientName!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(ThemeData theme, String label, String value) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
        AppSpacing.gapH4,
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

Widget _statusBadge(GiftCardStatus? status) {
  final (color, label) = switch (status) {
    GiftCardStatus.active => (AppColors.success, 'Active'),
    GiftCardStatus.redeemed => (AppColors.info, 'Redeemed'),
    GiftCardStatus.expired => (AppColors.warning, 'Expired'),
    GiftCardStatus.deactivated => (AppColors.error, 'Deactivated'),
    null => (const Color(0xFF6B7280), 'Unknown'),
  };

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: AppRadius.borderSm),
    child: Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
    ),
  );
}
