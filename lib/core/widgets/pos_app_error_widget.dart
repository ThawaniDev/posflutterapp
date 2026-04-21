import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

/// Custom error widget that replaces Flutter's default red error screen.
/// Shows the error message in a styled, user-friendly card.
class PosAppErrorWidget extends StatelessWidget {

  const PosAppErrorWidget({super.key, required this.details});
  final FlutterErrorDetails details;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: AppSpacing.paddingAll24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(isDark ? 'assets/images/wameedlogowhite.png' : 'assets/images/wameedlogo.png', width: 96, height: 96),
                const SizedBox(height: AppSpacing.xl),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: const Icon(Icons.bug_report_outlined, size: 28, color: AppColors.error),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Something went wrong',
                  style: AppTypography.titleMedium.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'An unexpected error occurred while rendering this view.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: AppSpacing.xl),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.base),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: SelectableText(
                      details.exceptionAsString(),
                      style: AppTypography.bodySmall.copyWith(color: AppColors.error, fontFamily: 'monospace', fontSize: 12),
                      maxLines: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
