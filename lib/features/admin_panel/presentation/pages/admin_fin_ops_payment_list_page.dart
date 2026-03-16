import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart';

class AdminFinOpsPaymentListPage extends ConsumerStatefulWidget {
  const AdminFinOpsPaymentListPage({super.key});

  @override
  ConsumerState<AdminFinOpsPaymentListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsPaymentListPage> {
  String? _methodFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(finOpsPaymentsProvider.notifier).load());
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_methodFilter != null && _methodFilter!.isNotEmpty) params['method'] = _methodFilter;
    ref.read(finOpsPaymentsProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(finOpsPaymentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Payments'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: switch (state) {
              FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
              FinOpsListLoaded(data: final resp) => _buildList(resp),
              FinOpsListError(message: final msg) => Center(
                child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
              ),
              _ => const Center(child: Text('Select filters to load payments')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    const methods = ['', 'cash', 'card_mada', 'card_visa', 'card_mastercard', 'store_credit', 'gift_card', 'mobile_payment'];
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _methodFilter ?? '',
              decoration: const InputDecoration(
                labelText: 'Method',
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
              items: methods
                  .map(
                    (m) =>
                        DropdownMenuItem(value: m, child: Text(m.isEmpty ? 'All Methods' : m.replaceAll('_', ' ').toUpperCase())),
                  )
                  .toList(),
              onChanged: (v) {
                setState(() => _methodFilter = v);
                _applyFilter();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No payments found'));

    return RefreshIndicator(
      onRefresh: () async => _applyFilter(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) => _paymentCard(items[i]),
      ),
    );
  }

  Widget _paymentCard(Map<String, dynamic> item) {
    final method = (item['method'] ?? '').toString();
    final amount = num.tryParse(item['amount']?.toString() ?? '') ?? 0;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _methodColor(method).withValues(alpha: 0.15),
          child: Icon(_methodIcon(method), color: _methodColor(method), size: 20),
        ),
        title: Text('ر.ع. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(method.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontSize: 12)),
        trailing: Text(
          item['created_at']?.toString().substring(0, 10) ?? '',
          style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
        ),
        onTap: () {
          final id = item['id']?.toString();
          if (id != null) Navigator.of(context).push(MaterialPageRoute(builder: (_) => AdminFinOpsPaymentDetailPage(id: id)));
        },
      ),
    );
  }

  Color _methodColor(String method) => switch (method) {
    'cash' => AppColors.success,
    'card_mada' || 'card_visa' || 'card_mastercard' => AppColors.info,
    'gift_card' => const Color(0xFFF59E0B),
    'store_credit' => const Color(0xFF8B5CF6),
    _ => AppColors.primary,
  };

  IconData _methodIcon(String method) => switch (method) {
    'cash' => Icons.money,
    'card_mada' || 'card_visa' || 'card_mastercard' => Icons.credit_card,
    'gift_card' => Icons.card_giftcard,
    'store_credit' => Icons.account_balance_wallet,
    'mobile_payment' => Icons.phone_android,
    _ => Icons.payment,
  };
}
