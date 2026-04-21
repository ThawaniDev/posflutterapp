import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class PosErrorState extends StatelessWidget {

  const PosErrorState({super.key, required this.message, this.onRetry, this.icon = Icons.error_outline});
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingAll24,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: Icon(icon, size: 40, color: AppColors.error),
            ),
            AppSpacing.gapH24,
            Text(
              message,
              style: AppTypography.bodyLarge.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              AppSpacing.gapH24,
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(AppLocalizations.of(context)!.commonRetry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
