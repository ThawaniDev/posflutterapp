import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/enums/gift_card_status.dart';
import 'package:wameedpos/features/payments/models/gift_card.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
                PosTabItem(label: l10n.giftCardManage, icon: Icons.list_alt),
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
                const _ManageTab(),
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
  const _IssueTab({required this.theme});
  final ThemeData theme;

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
    final l10n = AppLocalizations.of(context)!;
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

          PosTextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            label: l10n.paymentsAmountSar,
            onChanged: (_) => setState(() => _selectedPreset = null),
          ),
          AppSpacing.gapH16,

          PosTextField(controller: _recipientController, label: l10n.recipientNameOptional, prefixIcon: Icons.person_outline),
          AppSpacing.gapH24,

          SizedBox(
            width: double.infinity,
            child: PosButton(
              isLoading: state is GiftCardLoading,
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
              icon: Icons.card_giftcard,
              label: l10n.issueGiftCard,
              isFullWidth: true,
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
                    const Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: const TextStyle(color: AppColors.error)),
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
  const _CheckBalanceTab({required this.theme});
  final ThemeData theme;

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
    final l10n = AppLocalizations.of(context)!;
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
                child: PosTextField(
                  controller: _codeController,
                  label: l10n.giftCardCode,
                  hint: l10n.enterOrScanCode,
                  prefixIcon: Icons.qr_code,
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
                    const Icon(Icons.account_balance_wallet, size: 48, color: AppColors.primary),
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
                    const Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: const TextStyle(color: AppColors.error)),
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
  const _RedeemTab({required this.theme});
  final ThemeData theme;

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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(giftCardProvider);
    final theme = widget.theme;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.redeemGiftCard, style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,
          PosTextField(controller: _codeController, label: l10n.giftCardCode, prefixIcon: Icons.qr_code),
          AppSpacing.gapH16,
          PosTextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            label: l10n.paymentsRedemptionAmount,
          ),
          AppSpacing.gapH24,
          SizedBox(
            width: double.infinity,
            child: PosButton(
              isLoading: state is GiftCardLoading,
              onPressed: state is GiftCardLoading
                  ? null
                  : () {
                      final amount = double.tryParse(_amountController.text);
                      if (_codeController.text.isEmpty || amount == null || amount <= 0) return;
                      ref.read(giftCardProvider.notifier).redeemGiftCard(_codeController.text, amount);
                    },
              icon: Icons.redeem,
              label: l10n.redeem,
              isFullWidth: true,
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
                    const Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW8,
                    Expanded(
                      child: Text(state.message, style: const TextStyle(color: AppColors.error)),
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

// ─── Manage Tab ─────────────────────────────────────────────────

class _ManageTab extends ConsumerStatefulWidget {
  const _ManageTab();

  @override
  ConsumerState<_ManageTab> createState() => _ManageTabState();
}

class _ManageTabState extends ConsumerState<_ManageTab> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _selectedStatus;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(giftCardListProvider.notifier).load());
  }

  void _reload() {
    ref.read(giftCardListProvider.notifier).load(status: _selectedStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(giftCardListProvider);

    return Column(
      children: [
        // ── Filter bar ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: PosSearchableDropdown<String>(
                  hint: l10n.giftCardManageFilterStatus,
                  items: [
                    PosDropdownItem(value: 'active', label: l10n.giftCardStatusActive),
                    PosDropdownItem(value: 'redeemed', label: l10n.giftCardStatusRedeemed),
                    PosDropdownItem(value: 'expired', label: l10n.giftCardStatusExpired),
                    PosDropdownItem(value: 'deactivated', label: l10n.giftCardStatusDeactivated),
                  ],
                  selectedValue: _selectedStatus,
                  onChanged: (v) {
                    setState(() => _selectedStatus = v);
                    _reload();
                  },
                  label: l10n.giftCardManageFilterStatus,
                  showSearch: false,
                  clearable: true,
                ),
              ),
              AppSpacing.gapW8,
              PosButton.icon(
                icon: Icons.refresh,
                tooltip: l10n.commonRefresh,
                onPressed: _reload,
                variant: PosButtonVariant.ghost,
              ),
            ],
          ),
        ),

        // ── List ──
        Expanded(
          child: switch (state) {
            GiftCardListInitial() || GiftCardListLoading() => const Center(child: CircularProgressIndicator()),
            GiftCardListError(:final message) => Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message, style: const TextStyle(color: AppColors.error)),
                  AppSpacing.gapH12,
                  PosButton(label: l10n.retry, variant: PosButtonVariant.outline, onPressed: _reload),
                ],
              ),
            ),
            GiftCardListLoaded(:final cards, :final hasMore) =>
              cards.isEmpty
                  ? Center(
                      child: Text(l10n.giftCardManageEmpty, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                    )
                  : ListView.separated(
                      padding: AppSpacing.paddingAll16,
                      itemCount: cards.length + (hasMore ? 1 : 0),
                      separatorBuilder: (_, __) => AppSpacing.gapH8,
                      itemBuilder: (context, index) {
                        if (index == cards.length) {
                          return Padding(
                            padding: AppSpacing.paddingAll16,
                            child: Center(
                              child: PosButton(
                                label: l10n.commonLoadMore,
                                variant: PosButtonVariant.outline,
                                onPressed: () => ref.read(giftCardListProvider.notifier).loadMore(),
                              ),
                            ),
                          );
                        }
                        final card = cards[index];
                        return _GiftCardManageRow(
                          card: card,
                          theme: theme,
                          onDeactivate: () => _confirmDeactivate(context, card),
                        );
                      },
                    ),
          },
        ),
      ],
    );
  }

  void _confirmDeactivate(BuildContext context, GiftCard card) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.giftCardDeactivateTitle,
      message: l10n.giftCardDeactivateConfirm(card.code),
      confirmLabel: l10n.giftCardDeactivateAction,
      isDanger: true,
    );
    if (confirmed == true && mounted) {
      final updated = await ref.read(giftCardListProvider.notifier).deactivate(card.code);
      if (updated != null && mounted) {
        showPosSuccessSnackbar(context, l10n.giftCardDeactivatedSuccess);
      }
    }
  }
}

class _GiftCardManageRow extends StatelessWidget {
  const _GiftCardManageRow({required this.card, required this.theme, required this.onDeactivate});
  final GiftCard card;
  final ThemeData theme;
  final VoidCallback onDeactivate;

  @override
  Widget build(BuildContext context) {
    final isActive = card.status == GiftCardStatus.active;

    return PosCard(
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
              child: const Icon(Icons.card_giftcard, color: AppColors.warning, size: 20),
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
                        card.code,
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 1.2),
                      ),
                      AppSpacing.gapW8,
                      _statusBadge(card.status),
                    ],
                  ),
                  AppSpacing.gapH2,
                  Row(
                    children: [
                      Text(
                        '${card.balance.toStringAsFixed(2)} / ${card.initialAmount.toStringAsFixed(2)} \u0631',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      ),
                      if (card.recipientName != null) ...[
                        Text(' · ', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                        Text(card.recipientName!, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                      ],
                    ],
                  ),
                  if (card.expiresAt != null)
                    Text(
                      'Exp: ${card.expiresAt!.day}/${card.expiresAt!.month}/${card.expiresAt!.year}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: card.expiresAt!.isBefore(DateTime.now()) ? AppColors.error : theme.hintColor,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),
            // Deactivate action
            if (isActive)
              PosButton.icon(
                icon: Icons.block,
                tooltip: AppLocalizations.of(context)!.giftCardDeactivateAction,
                onPressed: onDeactivate,
                variant: PosButtonVariant.ghost,
              ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ─────────────────────────────────────────────

class _GiftCardResultCard extends StatelessWidget {
  const _GiftCardResultCard({required this.card, required this.theme});
  final dynamic card;
  final ThemeData theme;

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
