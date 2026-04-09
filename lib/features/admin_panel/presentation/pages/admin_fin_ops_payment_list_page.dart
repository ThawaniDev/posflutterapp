import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:thawani_pos/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart';

class AdminFinOpsPaymentListPage extends ConsumerStatefulWidget {
  const AdminFinOpsPaymentListPage({super.key});

  @override
  ConsumerState<AdminFinOpsPaymentListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsPaymentListPage> {
  String? _storeId;
  String? _methodFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilter();
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilter();
  }

  void _applyFilter() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
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
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
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
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: PosSearchableDropdown<String>(
              items: [
                PosDropdownItem(value: 'cash', label: 'CASH'),
                PosDropdownItem(value: 'card_mada', label: 'CARD MADA'),
                PosDropdownItem(value: 'card_visa', label: 'CARD VISA'),
                PosDropdownItem(value: 'card_mastercard', label: 'CARD MASTERCARD'),
                PosDropdownItem(value: 'store_credit', label: 'STORE CREDIT'),
                PosDropdownItem(value: 'gift_card', label: 'GIFT CARD'),
                PosDropdownItem(value: 'mobile_payment', label: 'MOBILE PAYMENT'),
              ],
              selectedValue: _methodFilter,
              onChanged: (v) {
                setState(() => _methodFilter = v);
                _applyFilter();
              },
              label: 'Method',
              hint: 'All Methods',
              showSearch: false,
              clearable: true,
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
        title: Text('\u0081. ${amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
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
