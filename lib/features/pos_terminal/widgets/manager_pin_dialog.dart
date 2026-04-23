import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/pos_terminal/data/remote/pos_terminal_api_service.dart';

/// Result of a successful manager-PIN verification.
class ManagerApproval {
  const ManagerApproval({required this.approvalToken, required this.approverId, required this.expiresIn});
  final String approvalToken;
  final String approverId;
  final int expiresIn;
}

/// Step-up authentication dialog. Returns a [ManagerApproval] when the
/// supplied PIN is verified by the backend for the requested action,
/// otherwise `null` if cancelled.
Future<ManagerApproval?> showPosManagerPinDialog(
  BuildContext context, {
  required String action,
  required WidgetRef ref,
}) {
  return showDialog<ManagerApproval>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ManagerPinDialog(action: action, ref: ref),
  );
}

class _ManagerPinDialog extends StatefulWidget {
  const _ManagerPinDialog({required this.action, required this.ref});
  final String action;
  final WidgetRef ref;

  @override
  State<_ManagerPinDialog> createState() => _ManagerPinDialogState();
}

class _ManagerPinDialogState extends State<_ManagerPinDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pin = _controller.text.trim();
    if (pin.length < 4) {
      setState(() => _error = AppLocalizations.of(context)!.posManagerPinInvalid);
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final api = widget.ref.read(posTerminalApiServiceProvider);
      final response = await api.verifyManagerPin(pin: pin, action: widget.action);
      if (!mounted) return;
      Navigator.pop(
        context,
        ManagerApproval(
          approvalToken: response['approval_token'] as String,
          approverId: response['approver_id'] as String,
          expiresIn: response['expires_in'] as int? ?? 300,
        ),
      );
    } on DioException catch (e) {
      setState(() {
        _submitting = false;
        _error = e.response?.data is Map
            ? (e.response!.data['message'] as String? ?? AppLocalizations.of(context)!.posManagerPinInvalid)
            : AppLocalizations.of(context)!.posManagerPinInvalid;
      });
    } catch (_) {
      setState(() {
        _submitting = false;
        _error = AppLocalizations.of(context)!.posManagerPinInvalid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
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
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Center(child: Icon(Icons.shield_outlined, color: AppColors.warning, size: 28)),
              ),
              AppSpacing.gapH16,
              Text(
                l.posManagerPinTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH8,
              Text(
                l.posManagerPinAction(widget.action),
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.gapH24,
              PosTextField(
                controller: _controller,
                focusNode: _focusNode,
                hint: l.posManagerPinHint,
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(12)],
                textAlign: TextAlign.center,
                onSubmitted: (_) => _submit(),
                errorText: _error,
                enabled: !_submitting,
              ),
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
                      label: l.posManagerPinSubmit,
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
