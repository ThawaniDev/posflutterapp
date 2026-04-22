import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

/// Lookup a transaction by number and render its receipt for reprint.
/// Uses GET /pos/transactions/{id}/receipt which returns store info,
/// settings and the full transaction with items + payments.
class PosReprintReceiptDialog extends ConsumerStatefulWidget {
  const PosReprintReceiptDialog({super.key});

  @override
  ConsumerState<PosReprintReceiptDialog> createState() => _PosReprintReceiptDialogState();
}

class _PosReprintReceiptDialogState extends ConsumerState<PosReprintReceiptDialog> {
  final _numberController = TextEditingController();
  Map<String, dynamic>? _receipt;
  String? _error;
  bool _loading = false;

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _lookup() async {
    final number = _numberController.text.trim();
    if (number.isEmpty) {
      setState(() => _error = 'Enter a receipt number');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _receipt = null;
    });
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      // First find by number to get the id, then fetch the formatted receipt.
      final tx = await repo.getTransactionByNumber(number);
      final data = await repo.getReceipt(tx.id);
      setState(() {
        _receipt = data;
        _loading = false;
      });
    } on DioException catch (e) {
      setState(() {
        _error = (e.response?.data is Map ? e.response!.data['message'] as String? : null) ?? 'Not found';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  String _money(dynamic v) {
    final d = v is num ? v.toDouble() : double.tryParse('${v ?? 0}') ?? 0.0;
    return d.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.receipt_long, color: AppColors.primary),
          SizedBox(width: AppSpacing.sm),
          Text('Reprint Receipt'),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _numberController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      labelText: 'Receipt Number',
                      hintText: 'TXN-20260421-0001',
                      prefixIcon: Icon(Icons.qr_code_2),
                    ),
                    onSubmitted: (_) => _lookup(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: _loading ? null : _lookup,
                  child: _loading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Find'),
                ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
            if (_receipt != null) ...[const SizedBox(height: AppSpacing.md), const Divider(), Expanded(child: _buildReceipt())],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        if (_receipt != null)
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sent to printer')));
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
          ),
      ],
    );
  }

  Widget _buildReceipt() {
    final r = _receipt!;
    final store = (r['store'] as Map?) ?? {};
    final tx = (r['transaction'] as Map?) ?? {};
    final items = (tx['transaction_items'] as List?) ?? const [];
    final payments = (tx['payments'] as List?) ?? const [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (store['name'] != null) Center(child: Text('${store['name']}', style: AppTypography.titleMedium)),
          if (store['tax_number'] != null) Center(child: Text('VAT: ${store['tax_number']}', style: AppTypography.bodySmall)),
          const SizedBox(height: AppSpacing.sm),
          Text('# ${tx['transaction_number'] ?? ''}', style: AppTypography.bodyMedium),
          Text('${tx['type'] ?? ''}  •  ${tx['status'] ?? ''}', style: AppTypography.bodySmall),
          const Divider(),
          ...items.map((it) {
            final m = it as Map;
            final qty = m['quantity'];
            final price = _money(m['unit_price']);
            final total = _money(m['line_total']);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(child: Text('${m['product_name'] ?? ''}  ($qty × $price)', style: AppTypography.bodySmall)),
                  Text(total, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }),
          const Divider(),
          _line('Subtotal', tx['subtotal']),
          _line('Discount', tx['discount_amount']),
          _line('Tax', tx['tax_amount']),
          if ((tx['tip_amount'] ?? 0) != 0) _line('Tip', tx['tip_amount']),
          _line('Total', tx['total_amount'], bold: true),
          const Divider(),
          ...payments.map((p) {
            final m = p as Map;
            return _line('${m['method']}', m['amount']);
          }),
        ],
      ),
    );
  }

  Widget _line(String label, dynamic value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodySmall)),
          Text(_money(value), style: AppTypography.bodySmall.copyWith(fontWeight: bold ? FontWeight.bold : FontWeight.w600)),
        ],
      ),
    );
  }
}
