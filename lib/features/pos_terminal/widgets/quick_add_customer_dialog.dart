import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';

/// Returns the freshly-created customer or `null` if cancelled.
Future<Customer?> showPosQuickAddCustomerDialog(BuildContext context, WidgetRef ref) {
  return showDialog<Customer>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _QuickAddCustomerDialog(ref: ref),
  );
}

class _QuickAddCustomerDialog extends StatefulWidget {
  const _QuickAddCustomerDialog({required this.ref});
  final WidgetRef ref;

  @override
  State<_QuickAddCustomerDialog> createState() => _QuickAddCustomerDialogState();
}

class _QuickAddCustomerDialogState extends State<_QuickAddCustomerDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l.posQuickAddCustomerName);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final api = widget.ref.read(posTerminalApiServiceProvider);
      final customer = await api.quickAddCustomer({
        'name': name,
        if (_phone.text.trim().isNotEmpty) 'phone': _phone.text.trim(),
      });
      if (!mounted) return;
      Navigator.pop(context, customer);
    } on DioException catch (e) {
      setState(() {
        _submitting = false;
        _error = e.response?.data is Map ? (e.response!.data['message'] as String? ?? e.message) : e.message;
      });
    } catch (e) {
      setState(() {
        _submitting = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l.posQuickAddCustomerTitle, textAlign: TextAlign.center, style: AppTypography.headlineSmall),
              AppSpacing.gapH16,
              PosTextField(controller: _name, label: l.posQuickAddCustomerName, autofocus: true, errorText: _error),
              AppSpacing.gapH12,
              PosTextField(controller: _phone, label: l.posQuickAddCustomerPhone, keyboardType: TextInputType.phone),
              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: MaterialLocalizations.of(context).cancelButtonLabel,
                      variant: PosButtonVariant.outline,
                      onPressed: _submitting ? null : () => Navigator.pop(context),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(
                      label: MaterialLocalizations.of(context).saveButtonLabel,
                      onPressed: _submitting ? null : _submit,
                      isLoading: _submitting,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
