import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

/// X-report = mid-shift snapshot; Z-report = end-of-shift (also flips
/// `z_report_printed` on the session). Both render the same payload.
class PosShiftReportDialog extends ConsumerStatefulWidget {
  const PosShiftReportDialog({
    required this.sessionId,
    required this.isZReport,
    super.key,
  });

  final String sessionId;
  final bool isZReport;

  @override
  ConsumerState<PosShiftReportDialog> createState() => _PosShiftReportDialogState();
}

class _PosShiftReportDialogState extends ConsumerState<PosShiftReportDialog> {
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final data = widget.isZReport ? await repo.zReport(widget.sessionId) : await repo.xReport(widget.sessionId);
      setState(() {
        _data = data;
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

  Widget _row(String label, dynamic value, {Color? color, FontWeight? weight}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTypography.bodyMedium)),
          Text(
            value is String ? value : _money(value),
            style: AppTypography.bodyMedium.copyWith(color: color, fontWeight: weight ?? FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.md),
        Text(title, style: AppTypography.titleSmall.copyWith(color: AppColors.primary)),
        const Divider(height: 12),
        ...children,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isZReport ? 'Z-Report (End of Shift)' : 'X-Report (Mid-Shift Snapshot)';

    return AlertDialog(
      title: Row(
        children: [
          Icon(widget.isZReport ? Icons.assessment : Icons.insights, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text(title)),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 600),
        child: _loading
            ? const SizedBox(height: 200, child: Center(child: CircularProgressIndicator()))
            : _error != null
            ? Text(_error!, style: TextStyle(color: AppColors.error))
            : _buildBody(),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Close')),
        FilledButton.icon(
          onPressed: _loading ? null : _load,
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh'),
        ),
      ],
    );
  }

  Widget _buildBody() {
    final data = _data!;
    final totals = (data['totals'] as Map?) ?? {};
    final drawer = (data['cash_drawer'] as Map?) ?? {};
    final breakdown = (data['payment_breakdown'] as List?) ?? const [];
    final events = (data['cash_events'] as List?) ?? const [];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _section('Transactions', [
            _row('Sales', '${totals['sale_count'] ?? 0}'),
            _row('Returns', '${totals['return_count'] ?? 0}'),
            _row('Voids', '${totals['void_count'] ?? 0}'),
            _row('Gross Sales', totals['gross_sales']),
            _row('Refunds', totals['total_refunds'], color: AppColors.warning),
            _row('Discounts', totals['total_discounts']),
            _row('Tax', totals['total_tax']),
            _row('Tips', totals['total_tips']),
            _row('Net Sales', totals['net_sales'], weight: FontWeight.bold, color: AppColors.success),
          ]),
          _section('Cash Drawer', [
            _row('Opening Cash', drawer['opening_cash']),
            _row('Net Cash Sales', drawer['cash_sales_net']),
            _row('Cash In (paid-in)', drawer['cash_in_total'], color: AppColors.success),
            _row('Cash Out (drops/payouts)', drawer['cash_out_total'], color: AppColors.warning),
            _row('Expected Cash', drawer['expected_cash'], weight: FontWeight.bold, color: AppColors.primary),
          ]),
          if (breakdown.isNotEmpty)
            _section('Payment Methods', [
              ...breakdown.map((b) {
                final m = b as Map;
                return _row(
                  '${m['method']}',
                  '${_money(m['sales_total'])} / -${_money(m['refund_total'])}',
                );
              }),
            ]),
          if (events.isNotEmpty)
            _section('Cash Events', [
              ...events.map((e) {
                final m = e as Map;
                final sign = m['type'] == 'cash_in' ? '+' : '-';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '$sign ${_money(m['amount'])}  ${m['reason'] ?? ''}',
                          style: AppTypography.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ]),
        ],
      ),
    );
  }
}
