import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import 'pos_button.dart';

// ─────────────────────────────────────────────────────────────
// DIALOG / POPUP HELPERS
// ─────────────────────────────────────────────────────────────

/// Show a Thawani-styled confirmation dialog.
///
/// Returns `true` if confirmed, `false`/`null` if dismissed.
Future<bool?> showPosConfirmDialog(
  BuildContext context, {
  required String title,
  String? message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  PosButtonVariant confirmVariant = PosButtonVariant.primary,
  bool isDanger = false,
  IconData? icon,
}) {
  return showDialog<bool>(
    context: context,
    builder: (_) => _PosConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmVariant: isDanger ? PosButtonVariant.danger : confirmVariant,
      icon: icon ?? (isDanger ? Icons.warning_amber_rounded : null),
      iconColor: isDanger ? AppColors.error : AppColors.primary,
    ),
  );
}

class _PosConfirmDialog extends StatelessWidget {
  const _PosConfirmDialog({
    required this.title,
    this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    required this.confirmVariant,
    this.icon,
    this.iconColor,
  });

  final String title;
  final String? message;
  final String confirmLabel;
  final String cancelLabel;
  final PosButtonVariant confirmVariant;
  final IconData? icon;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidthDialog),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppColors.primary).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Icon(icon, size: 28, color: iconColor)),
                ),
                AppSpacing.gapH16,
              ],
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                AppSpacing.gapH8,
                Text(
                  message!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              AppSpacing.gapH24,
              Row(
                children: [
                  Expanded(
                    child: PosButton(
                      label: cancelLabel,
                      variant: PosButtonVariant.outline,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  AppSpacing.gapW12,
                  Expanded(
                    child: PosButton(label: confirmLabel, variant: confirmVariant, onPressed: () => Navigator.pop(context, true)),
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

// ─────────────────────────────────────────────────────────────
// BOTTOM SHEET
// ─────────────────────────────────────────────────────────────

/// Show a Thawani-styled modal bottom sheet.
Future<T?> showPosBottomSheet<T>(
  BuildContext context, {
  required Widget Function(BuildContext) builder,
  bool isScrollControlled = true,
  bool useSafeArea = true,
  bool isDismissible = true,
  double maxHeightFraction = 0.9,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    isDismissible: isDismissible,
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * maxHeightFraction),
    builder: builder,
  );
}

/// Bottom sheet header with title, optional subtitle and close button.
class PosBottomSheetHeader extends StatelessWidget {
  const PosBottomSheetHeader({super.key, required this.title, this.subtitle, this.showClose = true, this.action});

  final String title;
  final String? subtitle;
  final bool showClose;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  ),
              ],
            ),
          ),
          if (action != null) action!,
          if (showClose) IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// FULL-SCREEN DIALOG
// ─────────────────────────────────────────────────────────────

/// Full-screen dialog (modal page) with app bar.
Future<T?> showPosFullScreenDialog<T>(
  BuildContext context, {
  required String title,
  required Widget body,
  List<Widget>? actions,
}) {
  return showDialog<T>(
    context: context,
    useSafeArea: false,
    builder: (_) => Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(icon: const Icon(Icons.close_rounded), onPressed: () => Navigator.pop(context)),
        actions: actions,
      ),
      body: body,
    ),
  );
}

// ─────────────────────────────────────────────────────────────
// ALERT SNACKBAR
// ─────────────────────────────────────────────────────────────

/// Snackbar severity level — determines icon, color, and styling.
enum PosSnackbarLevel { success, error, warning, info }

/// Show a fully-themed snackbar with icon, colored accent bar, and optional action.
///
/// The snackbar uses a left accent border, matching icon, and theme-aware colors.
/// Use the convenience helpers below instead of calling this directly.
void showPosSnackbar(
  BuildContext context, {
  required String message,
  PosSnackbarLevel level = PosSnackbarLevel.info,
  IconData? icon,
  Color? iconColor,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  final resolvedIcon = icon ?? _iconForLevel(level);
  final accentColor = iconColor ?? _colorForLevel(level);
  final bgColor = isDark ? accentColor.withValues(alpha: 0.15) : accentColor.withValues(alpha: 0.08);
  final borderColor = accentColor.withValues(alpha: isDark ? 0.40 : 0.25);
  final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    width: 480,
    content: Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: AppRadius.borderMd,
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Color accent bar
            Container(
              width: 4,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              ),
            ),
            // Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(resolvedIcon, color: accentColor, size: 18),
              ),
            ),
            // Message
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  message,
                  style: AppTypography.bodySmall.copyWith(color: textColor, fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Action or close
            if (actionLabel != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    onAction?.call();
                  },
                  style: TextButton.styleFrom(foregroundColor: accentColor, padding: const EdgeInsets.symmetric(horizontal: 12)),
                  child: Text(actionLabel, style: AppTypography.labelSmall.copyWith(fontWeight: FontWeight.w700)),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.only(right: 4),
                child: IconButton(
                  icon: Icon(Icons.close_rounded, size: 16, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                  onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
                  splashRadius: 16,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                ),
              ),
          ],
        ),
      ),
    ),
    action: actionLabel != null
        ? SnackBarAction(label: '', onPressed: () {}) // invisible — custom action above
        : null,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

IconData _iconForLevel(PosSnackbarLevel level) => switch (level) {
  PosSnackbarLevel.success => Icons.check_circle_rounded,
  PosSnackbarLevel.error => Icons.error_rounded,
  PosSnackbarLevel.warning => Icons.warning_amber_rounded,
  PosSnackbarLevel.info => Icons.info_rounded,
};

Color _colorForLevel(PosSnackbarLevel level) => switch (level) {
  PosSnackbarLevel.success => AppColors.success,
  PosSnackbarLevel.error => AppColors.error,
  PosSnackbarLevel.warning => AppColors.warning,
  PosSnackbarLevel.info => AppColors.info,
};

/// Success snackbar (green).
void showPosSuccessSnackbar(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
  showPosSnackbar(context, message: message, level: PosSnackbarLevel.success, actionLabel: actionLabel, onAction: onAction);
}

/// Error snackbar (red).
void showPosErrorSnackbar(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 5),
}) {
  showPosSnackbar(
    context,
    message: message,
    level: PosSnackbarLevel.error,
    actionLabel: actionLabel,
    onAction: onAction,
    duration: duration,
  );
}

/// Warning snackbar (amber).
void showPosWarningSnackbar(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
  showPosSnackbar(context, message: message, level: PosSnackbarLevel.warning, actionLabel: actionLabel, onAction: onAction);
}

/// Info snackbar (blue).
void showPosInfoSnackbar(BuildContext context, String message, {String? actionLabel, VoidCallback? onAction}) {
  showPosSnackbar(context, message: message, level: PosSnackbarLevel.info, actionLabel: actionLabel, onAction: onAction);
}
