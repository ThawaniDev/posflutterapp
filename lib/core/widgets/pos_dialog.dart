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
              Text(title, style: AppTypography.headlineSmall, textAlign: TextAlign.center),
              if (message != null) ...[
                AppSpacing.gapH8,
                Text(
                  message!,
                  style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.headlineSmall),
                if (subtitle != null) Text(subtitle!, style: AppTypography.bodySmall.copyWith(color: AppColors.textMutedLight)),
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

/// Show a themed snackbar with optional icon + action.
void showPosSnackbar(
  BuildContext context, {
  required String message,
  IconData? icon,
  Color? iconColor,
  String? actionLabel,
  VoidCallback? onAction,
  Duration duration = const Duration(seconds: 3),
}) {
  final snackBar = SnackBar(
    duration: duration,
    content: Row(
      children: [
        if (icon != null) ...[Icon(icon, color: iconColor ?? Colors.white, size: 20), AppSpacing.gapW8],
        Expanded(child: Text(message)),
      ],
    ),
    action: actionLabel != null
        ? SnackBarAction(label: actionLabel, textColor: AppColors.primary, onPressed: onAction ?? () {})
        : null,
  );
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

/// Convenience: success snackbar.
void showPosSuccessSnackbar(BuildContext context, String message) {
  showPosSnackbar(context, message: message, icon: Icons.check_circle_rounded, iconColor: AppColors.success);
}

/// Convenience: error snackbar.
void showPosErrorSnackbar(BuildContext context, String message) {
  showPosSnackbar(context, message: message, icon: Icons.error_rounded, iconColor: AppColors.error);
}
