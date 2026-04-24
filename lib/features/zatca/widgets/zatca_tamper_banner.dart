import 'package:flutter/material.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/zatca/models/zatca_device.dart';

/// Red banner displayed when a ZATCA device's hash chain has been
/// tampered with. POS submissions are blocked until reset.
class ZatcaTamperBanner extends StatelessWidget {
  const ZatcaTamperBanner({super.key, required this.device, this.onReset});

  final ZatcaDevice device;
  final VoidCallback? onReset;

  @override
  Widget build(BuildContext context) {
    if (!device.isTampered) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.12),
        border: Border.all(color: AppColors.error),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.zatcaDeviceTampered,
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
          if (onReset != null) TextButton(onPressed: onReset, child: Text(l10n.zatcaResetTamper)),
        ],
      ),
    );
  }
}
