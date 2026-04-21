import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

/// Cash drop / payout / paid-in dialog. Records a row in cash_events for
/// the active session and shifts the drawer running balance so the
/// close-shift cash reconciliation reflects the movement.
class PosCashEventDialog extends ConsumerStatefulWidget {
  const PosCashEventDialog({
    required this.sessionId,
    required this.type, // 'cash_in' or 'cash_out'
    super.key,
  });

  final String sessionId;
  final String type;

  @override
  ConsumerState<PosCashEventDialog> createState() => _PosCashEventDialogState();
}

class _PosCashEventDialogState extends ConsumerState<PosCashEventDialog> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();
  final _notesController = TextEditingController();
  bool _saving = false;
  String? _error;

  bool get _isCashIn => widget.type == 'cash_in';

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _error = 'Enter a valid amount');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref.read(posTerminalRepositoryProvider).recordCashEvent(widget.sessionId, {
        'type': widget.type,
        'amount': amount,
        if (_reasonController.text.trim().isNotEmpty) 'reason': _reasonController.text.trim(),
        if (_notesController.text.trim().isNotEmpty) 'notes': _notesController.text.trim(),
      });
      if (mounted) Navigator.of(context).pop(true);
    } on DioException catch (e) {
      setState(() {
        _error = (e.response?.data is Map ? e.response!.data['message'] as String? : null) ?? e.message ?? 'Failed';
        _saving = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Row(
        children: [
          Icon(
            _isCashIn ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: _isCashIn ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(_isCashIn ? l.posCashIn : l.posCashOut),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}$'))],
              autofocus: true,
              decoration: InputDecoration(
                labelText: l.posAmountSar,
                prefixIcon: const Icon(Icons.payments_outlined),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: l.posReason,
                hintText: _isCashIn ? 'Owner top-up' : 'Bank deposit',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _notesController,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(labelText: l.posNotes),
            ),
            if (_error != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_error!, style: AppTypography.bodySmall.copyWith(color: AppColors.error)),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: Text(l.cancel),
        ),
        FilledButton(
          onPressed: _saving ? null : _submit,
          child: _saving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(l.posRecord),
        ),
      ],
    );
  }
}
