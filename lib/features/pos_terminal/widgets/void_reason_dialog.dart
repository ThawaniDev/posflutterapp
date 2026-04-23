import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Result returned from the void dialog: the reason text. `null` if cancelled.
Future<String?> showPosVoidReasonDialog(BuildContext context) {
  return showDialog<String>(context: context, barrierDismissible: false, builder: (_) => const _VoidReasonDialog());
}

class _VoidReasonDialog extends StatefulWidget {
  const _VoidReasonDialog();

  @override
  State<_VoidReasonDialog> createState() => _VoidReasonDialogState();
}

class _VoidReasonDialogState extends State<_VoidReasonDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _controller.text.trim();
    if (reason.length < 5) {
      setState(() => _error = AppLocalizations.of(context)!.posVoidReasonError);
      return;
    }
    Navigator.pop(context, reason);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.10), shape: BoxShape.circle),
                child: const Center(child: Icon(Icons.cancel_outlined, color: AppColors.error, size: 28)),
              ),
              AppSpacing.gapH16,
              Text(
                l.posVoidReasonTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH16,
              PosTextField(
                controller: _controller,
                hint: l.posVoidReasonHint,
                maxLines: 3,
                minLines: 2,
                maxLength: 500,
                autofocus: true,
                errorText: _error,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
              ),
              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: MaterialLocalizations.of(context).cancelButtonLabel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(label: l.posVoidConfirmAction, variant: PosButtonVariant.danger, onPressed: _submit),
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
