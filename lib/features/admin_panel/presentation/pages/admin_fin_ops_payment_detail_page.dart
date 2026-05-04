import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminFinOpsPaymentDetailPage extends ConsumerStatefulWidget {
  const AdminFinOpsPaymentDetailPage({super.key, required this.id});
  final String id;

  @override
  ConsumerState<AdminFinOpsPaymentDetailPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsPaymentDetailPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(finOpsPaymentDetailProvider.notifier).load(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(finOpsPaymentDetailProvider);

    return PosListPage(
  title: l10n.providerPaymentDetail,
  showSearch: false,
    child: switch (state) {
        FinOpsDetailLoading() => const Center(child: CircularProgressIndicator()),
        FinOpsDetailLoaded(data: final resp) => _buildDetail(resp),
        FinOpsDetailError(message: final msg) => Center(
          child: Text(l10n.genericError(msg), style: const TextStyle(color: AppColors.error)),
        ),
        _ => Center(child: Text(l10n.loading)),
      },
);
  }

  Widget _buildDetail(Map<String, dynamic> resp) {
    final item = resp['data'] as Map<String, dynamic>? ?? resp;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          PosCard(
            borderRadius: BorderRadius.circular(12,),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.adminPaymentInformation, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const Divider(),
                  _infoRow('ID', item['id']),
                  _infoRow('Transaction ID', item['transaction_id']),
                  _infoRow('Method', (item['method'] ?? '').toString().replaceAll('_', ' ').toUpperCase()),
                  _infoRow('Amount', '\u0081. ${_fmt(item['amount'])}'),
                  _infoRow('Cash Tendered', '\u0081. ${_fmt(item['cash_tendered'])}'),
                  _infoRow('Change Given', '\u0081. ${_fmt(item['change_given'])}'),
                  _infoRow('Tip Amount', '\u0081. ${_fmt(item['tip_amount'])}'),
                  if (item['card_brand'] != null) _infoRow('Card Brand', item['card_brand']),
                  if (item['card_last_four'] != null) _infoRow('Card Last 4', item['card_last_four']),
                  if (item['card_auth_code'] != null) _infoRow('Auth Code', item['card_auth_code']),
                  if (item['gift_card_code'] != null) _infoRow('Gift Card Code', item['gift_card_code']),
                  if (item['coupon_code'] != null) _infoRow('Coupon Code', item['coupon_code']),
                  _infoRow('Created', item['created_at']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
            ),
          ),
          Expanded(
            child: Text(value?.toString() ?? '—', style: const TextStyle(color: AppColors.textPrimaryLight)),
          ),
        ],
      ),
    );
  }

  String _fmt(dynamic v) {
    if (v == null) return '0.00';
    final n = v is num ? v : num.tryParse(v.toString()) ?? 0;
    return n.toStringAsFixed(2);
  }
}
