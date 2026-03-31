import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/payments/enums/gift_card_status.dart';
import 'package:thawani_pos/features/payments/providers/payment_providers.dart';
import 'package:thawani_pos/features/payments/providers/payment_state.dart';

class GiftCardsPage extends ConsumerStatefulWidget {
  const GiftCardsPage({super.key});

  @override
  ConsumerState<GiftCardsPage> createState() => _GiftCardsPageState();
}

class _GiftCardsPageState extends ConsumerState<GiftCardsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Cards'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Issue', icon: Icon(Icons.card_giftcard)),
            Tab(text: 'Check Balance', icon: Icon(Icons.search)),
            Tab(text: 'Redeem', icon: Icon(Icons.redeem)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _IssueTab(theme: theme),
          _CheckBalanceTab(theme: theme),
          _RedeemTab(theme: theme),
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
          Text('Issue New Gift Card', style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,

          // Preset amounts
          Text('Quick Amount', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
          AppSpacing.gapH8,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _presetAmounts.map((amount) {
              final selected = _selectedPreset == amount;
              return ChoiceChip(
                label: Text('${amount.toInt()} SAR'),
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
            decoration: const InputDecoration(labelText: 'Amount (SAR)', border: OutlineInputBorder(), prefixText: 'SAR '),
            onChanged: (_) => setState(() => _selectedPreset = null),
          ),
          AppSpacing.gapH16,

          TextField(
            controller: _recipientController,
            decoration: const InputDecoration(
              labelText: 'Recipient Name (optional)',
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
              label: const Text('Issue Gift Card'),
            ),
          ),
          AppSpacing.gapH24,

          // Result
          if (state is GiftCardReady && state.lastIssued != null) ...[_GiftCardResultCard(card: state.lastIssued!, theme: theme)],
          if (state is GiftCardError) ...[
            Card(
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
          Text('Check Gift Card Balance', style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Gift Card Code',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.qr_code),
                    hintText: 'Enter or scan code',
                  ),
                ),
              ),
              AppSpacing.gapW12,
              FilledButton(
                onPressed: state is GiftCardLoading
                    ? null
                    : () {
                        if (_codeController.text.isEmpty) return;
                        ref.read(giftCardProvider.notifier).checkBalance(_codeController.text);
                      },
                child: state is GiftCardLoading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Check'),
              ),
            ],
          ),
          AppSpacing.gapH24,
          if (state is GiftCardReady && state.lastBalance != null) ...[
            Card(
              shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
              child: Padding(
                padding: AppSpacing.paddingAll24,
                child: Column(
                  children: [
                    Icon(Icons.account_balance_wallet, size: 48, color: AppColors.primary),
                    AppSpacing.gapH12,
                    Text(
                      '${(state.lastBalance!['balance'] as num?)?.toStringAsFixed(2) ?? '0.00'} SAR',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    AppSpacing.gapH4,
                    Text('Available Balance', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
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
            Card(
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
          Text('Redeem Gift Card', style: theme.textTheme.titleMedium),
          AppSpacing.gapH16,
          TextField(
            controller: _codeController,
            decoration: const InputDecoration(
              labelText: 'Gift Card Code',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.qr_code),
            ),
          ),
          AppSpacing.gapH16,
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Redemption Amount (SAR)',
              border: OutlineInputBorder(),
              prefixText: 'SAR ',
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
              label: const Text('Redeem'),
            ),
          ),
          AppSpacing.gapH24,
          if (state is GiftCardReady && state.lastIssued != null) ...[_GiftCardResultCard(card: state.lastIssued!, theme: theme)],
          if (state is GiftCardError) ...[
            Card(
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
    return Card(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gift Card Issued', style: theme.textTheme.titleSmall),
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
                  Text('Code', style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
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
                _infoColumn(theme, 'Initial', '${card.initialAmount.toStringAsFixed(2)} SAR'),
                _infoColumn(theme, 'Balance', '${card.balance.toStringAsFixed(2)} SAR'),
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
