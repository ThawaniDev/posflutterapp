import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/security/data/remote/security_api_service.dart';

// ─── Result ─────────────────────────────────────────────────

/// Returned from [showPinOverrideDialog] when the override succeeds.
class PinOverrideResult {
  const PinOverrideResult({required this.overrideId, required this.authorizingUserId});
  final String overrideId;
  final String authorizingUserId;
}

// ─── Public helper ─────────────────────────────────────────

/// Shows the PIN override dialog and returns a [PinOverrideResult] on success
/// or null if dismissed.
Future<PinOverrideResult?> showPinOverrideDialog(
  BuildContext context, {
  required String storeId,
  required String requestingUserId,
  required String permissionCode,
  Map<String, dynamic>? actionContext,
}) {
  return showDialog<PinOverrideResult>(
    context: context,
    barrierDismissible: false,
    builder: (_) => PinOverrideDialog(
      storeId: storeId,
      requestingUserId: requestingUserId,
      permissionCode: permissionCode,
      actionContext: actionContext,
    ),
  );
}

// ─── Dialog ──────────────────────────────────────────────────

class PinOverrideDialog extends ConsumerStatefulWidget {
  const PinOverrideDialog({
    super.key,
    required this.storeId,
    required this.requestingUserId,
    required this.permissionCode,
    this.actionContext,
  });

  final String storeId;
  final String requestingUserId;
  final String permissionCode;
  final Map<String, dynamic>? actionContext;

  @override
  ConsumerState<PinOverrideDialog> createState() => _PinOverrideDialogState();
}

class _PinOverrideDialogState extends ConsumerState<PinOverrideDialog> {
  static const int _pinLength = 6;

  final List<String> _digits = [];
  bool _isLoading = false;
  String? _errorMessage;

  void _onDigitTap(String digit) {
    if (_digits.length >= _pinLength || _isLoading) return;
    setState(() {
      _digits.add(digit);
      _errorMessage = null;
    });
    if (_digits.length == _pinLength) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_digits.isEmpty || _isLoading) return;
    setState(() => _digits.removeLast());
  }

  void _onClear() {
    if (_isLoading) return;
    setState(() {
      _digits.clear();
      _errorMessage = null;
    });
  }

  Future<void> _submitPin() async {
    final pin = _digits.join();
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final api = ref.read(securityApiServiceProvider);
      final res = await api.requestPinOverride(
        storeId: widget.storeId,
        requestingUserId: widget.requestingUserId,
        pin: pin,
        permissionCode: widget.permissionCode,
        actionContext: widget.actionContext,
      );
      final data = (res['data'] ?? res) as Map<String, dynamic>;
      if (mounted) {
        Navigator.of(context).pop(
          PinOverrideResult(
            overrideId: data['id'] as String? ?? '',
            authorizingUserId: data['authorizing_user_id'] as String? ?? '',
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _digits.clear();
          _errorMessage = _extractError(e);
        });
      }
    }
  }

  String _extractError(Object e) {
    // DioException message extraction
    final str = e.toString();
    if (str.contains('Invalid PIN')) return AppLocalizations.of(context)!.securityPinOverrideInvalidPin;
    if (str.contains('locked out')) return AppLocalizations.of(context)!.securityPinOverrideLockout;
    return AppLocalizations.of(context)!.securityPinOverrideError;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─── Header ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.warning, size: 32),
              ),
              AppSpacing.gapH12,
              Text(
                l10n.securityPinOverrideTitle,
                style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH8,
              Text(
                l10n.securityManagerAuthorization,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapH4,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.permissionCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              AppSpacing.gapH20,

              // ─── PIN Dots ─────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pinLength, (i) {
                  final filled = i < _digits.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.primary : Colors.transparent,
                      border: Border.all(
                        color: _errorMessage != null
                            ? AppColors.error
                            : filled
                            ? AppColors.primary
                            : AppColors.mutedFor(context),
                        width: 2,
                      ),
                    ),
                  );
                }),
              ),

              // ─── Error ────────────────────────────────────────
              if (_errorMessage != null) ...[
                AppSpacing.gapH8,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 14),
                    AppSpacing.gapW4,
                    Flexible(
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: AppColors.error, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],

              AppSpacing.gapH20,

              // ─── Numpad ────────────────────────────────────────
              if (_isLoading)
                const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: CircularProgressIndicator())
              else
                _buildNumpad(context),

              AppSpacing.gapH16,

              // ─── Cancel ────────────────────────────────────────
              PosButton(
                label: l10n.cancel,
                variant: PosButtonVariant.ghost,
                onPressed: () => Navigator.of(context).pop(null),
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', '⌫'],
    ];
    return Column(
      children: keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.map((key) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _NumpadKey(
                  label: key,
                  onTap: () {
                    if (key == '⌫') {
                      _onBackspace();
                    } else if (key == 'C') {
                      _onClear();
                    } else {
                      _onDigitTap(key);
                    }
                  },
                  isAction: key == '⌫' || key == 'C',
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

// ─── Numpad Key ─────────────────────────────────────────────

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({required this.label, required this.onTap, this.isAction = false});

  final String label;
  final VoidCallback onTap;
  final bool isAction;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isAction ? Theme.of(context).colorScheme.surfaceContainerHighest : Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 72,
          height: 56,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.3)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: isAction ? 18 : 22,
              fontWeight: FontWeight.w500,
              color: isAction ? AppColors.mutedFor(context) : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
