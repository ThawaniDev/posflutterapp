import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Confirmation prompt before adding an age-restricted product to the cart.
/// Returns `true` if the cashier visually verified the customer's age.
Future<bool> showPosAgeVerificationDialog(BuildContext context, {required int minimumAge}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _AgeVerificationDialog(minimumAge: minimumAge),
  );
  return result ?? false;
}

class _AgeVerificationDialog extends StatelessWidget {
  const _AgeVerificationDialog({required this.minimumAge});
  final int minimumAge;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.10), shape: BoxShape.circle),
                child: const Center(child: Icon(Icons.verified_user_outlined, color: AppColors.warning, size: 28)),
              ),
              AppSpacing.gapH16,
              Text(
                l.posAgeVerificationTitle,
                textAlign: TextAlign.center,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH8,
              Text(
                l.posAgeVerificationBody(minimumAge),
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: l.posAgeVerifyDecline,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(label: l.posAgeVerifiedConfirm, onPressed: () => Navigator.pop(context, true)),
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
