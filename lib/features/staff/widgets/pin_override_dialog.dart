import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/features/staff/repositories/roles_repository.dart';

/// Result object returned on successful PIN override authorization.
class PinOverrideResult {
  final String authorizedBy;
  final String authorizedByName;

  const PinOverrideResult({required this.authorizedBy, required this.authorizedByName});
}

/// A modal dialog that requests a supervisor/manager PIN to authorize
/// a protected action (e.g. void sale, apply discount, price override).
///
/// Usage:
/// ```dart
/// final result = await PinOverrideDialog.show(
///   context: context,
///   ref: ref,
///   permissionCode: 'pos.void_transaction',
///   actionDescription: 'Void this transaction',
/// );
/// if (result != null) { /* authorized */ }
/// ```
class PinOverrideDialog extends ConsumerStatefulWidget {
  final String permissionCode;
  final String actionDescription;

  const PinOverrideDialog({super.key, required this.permissionCode, required this.actionDescription});

  /// Static helper to show the dialog and return the result.
  static Future<PinOverrideResult?> show({
    required BuildContext context,
    required WidgetRef ref,
    required String permissionCode,
    String? actionDescription,
  }) {
    return showDialog<PinOverrideResult>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ProviderScope(
        parent: ProviderScope.containerOf(context),
        child: PinOverrideDialog(permissionCode: permissionCode, actionDescription: actionDescription ?? 'Authorize action'),
      ),
    );
  }

  @override
  ConsumerState<PinOverrideDialog> createState() => _PinOverrideDialogState();
}

class _PinOverrideDialogState extends ConsumerState<PinOverrideDialog> {
  String _pin = '';
  bool _isLoading = false;
  String? _error;

  void _onDigit(int digit) {
    if (_pin.length >= 4) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin += digit.toString();
      _error = null;
    });
    if (_pin.length == 4) {
      _submit();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
      _error = null;
    });
  }

  void _onClear() {
    setState(() {
      _pin = '';
      _error = null;
    });
  }

  Future<void> _submit() async {
    if (_pin.length != 4) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await ref
          .read(rolesRepositoryProvider)
          .requestPinOverride(pin: _pin, permissionCode: widget.permissionCode, context: {'action': widget.actionDescription});

      if (!mounted) return;
      Navigator.pop(
        context,
        PinOverrideResult(
          authorizedBy: result['authorized_by']?.toString() ?? '',
          authorizedByName: result['authorized_by_name']?.toString() ?? 'Manager',
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pin = '';
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.12), shape: BoxShape.circle),
                child: Icon(Icons.security, size: 28, color: AppColors.warning),
              ),
              const SizedBox(height: AppSpacing.md),

              Text(
                'Authorization Required',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.xs),

              Text(
                widget.actionDescription,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Enter a supervisor PIN to continue',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // PIN Dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _pin.length;
                  return Container(
                    width: 18,
                    height: 18,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? AppColors.primary : Colors.transparent,
                      border: Border.all(color: filled ? AppColors.primary : AppColors.borderLight, width: 2),
                    ),
                  );
                }),
              ),
              const SizedBox(height: AppSpacing.sm),

              // Error message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    _error!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Loading indicator
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                ),

              // Numpad
              if (!_isLoading) ...[_buildNumpad(), const SizedBox(height: AppSpacing.md)],

              // Cancel button
              PosButton(
                label: 'Cancel',
                onPressed: () => Navigator.pop(context),
                variant: PosButtonVariant.ghost,
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNumpad() {
    return Column(
      children: [
        _numpadRow([1, 2, 3]),
        const SizedBox(height: AppSpacing.sm),
        _numpadRow([4, 5, 6]),
        const SizedBox(height: AppSpacing.sm),
        _numpadRow([7, 8, 9]),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _numpadKey(
              child: const Text('C', style: TextStyle(fontSize: 18)),
              onTap: _onClear,
            ),
            _numpadKey(
              child: const Text('0', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              onTap: () => _onDigit(0),
            ),
            _numpadKey(child: const Icon(Icons.backspace_outlined, size: 20), onTap: _onBackspace),
          ],
        ),
      ],
    );
  }

  Widget _numpadRow(List<int> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits
          .map(
            (d) => _numpadKey(
              child: Text('$d', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              onTap: () => _onDigit(d),
            ),
          )
          .toList(),
    );
  }

  Widget _numpadKey({required Widget child, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Container(width: 64, height: 52, alignment: Alignment.center, child: child),
      ),
    );
  }
}
