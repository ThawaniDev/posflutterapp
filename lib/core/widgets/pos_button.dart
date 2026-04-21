import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

/// Wameed POS Button — unified button component
///
/// Supports multiple [PosButtonVariant] styles derived from the
/// stitch HTML prototypes: primary, secondary, outline, danger, ghost,
/// dark, soft / tonal, and category-pill.
enum PosButtonVariant {
  /// Solid orange background, white text. Main CTA.
  primary,

  /// Light orange tint background, orange text.
  soft,

  /// Transparent with border.
  outline,

  /// Transparent with orange border.
  outlinePrimary,

  /// Red solid background, white text.
  danger,

  /// No background, primary text. Minimal weight.
  ghost,

  /// Dark / Black background, white text.
  dark,
}

enum PosButtonSize { sm, md, lg, xl }

class PosButton extends StatelessWidget {
  const PosButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = PosButtonVariant.primary,
    this.size = PosButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.borderRadius,
  });

  /// Factory for icon-only FAB-style circular button.
  const factory PosButton.icon({
    Key? key,
    required IconData icon,
    VoidCallback? onPressed,
    PosButtonVariant variant,
    double iconSize,
    String? tooltip,
  }) = _PosIconButton;

  /// Factory for category pills.
  const factory PosButton.pill({Key? key, required String label, VoidCallback? onPressed, bool isSelected, IconData? icon}) =
      _PosPillButton;

  final String label;
  final VoidCallback? onPressed;
  final PosButtonVariant variant;
  final PosButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final BorderRadius? borderRadius;

  bool get _enabled => onPressed != null && !isLoading;

  double get _height {
    switch (size) {
      case PosButtonSize.sm:
        return AppSizes.buttonHeightSm;
      case PosButtonSize.md:
        return AppSizes.buttonHeightMd;
      case PosButtonSize.lg:
        return AppSizes.buttonHeightLg;
      case PosButtonSize.xl:
        return AppSizes.buttonHeightXl;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case PosButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case PosButtonSize.md:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 10);
      case PosButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 14);
      case PosButtonSize.xl:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  TextStyle get _textStyle {
    switch (size) {
      case PosButtonSize.sm:
        return AppTypography.labelSmall;
      case PosButtonSize.md:
        return AppTypography.labelMedium;
      case PosButtonSize.lg:
        return AppTypography.labelLarge;
      case PosButtonSize.xl:
        return AppTypography.labelLarge;
    }
  }

  double get _iconSize {
    switch (size) {
      case PosButtonSize.sm:
        return 14;
      case PosButtonSize.md:
        return 18;
      case PosButtonSize.lg:
        return 20;
      case PosButtonSize.xl:
        return 22;
    }
  }

  // ─ Color resolution per variant ─

  Color _bg(BuildContext context) {
    switch (variant) {
      case PosButtonVariant.primary:
        return AppColors.primary;
      case PosButtonVariant.soft:
        return AppColors.primary10;
      case PosButtonVariant.outline:
      case PosButtonVariant.outlinePrimary:
      case PosButtonVariant.ghost:
        return Colors.transparent;
      case PosButtonVariant.danger:
        return AppColors.error;
      case PosButtonVariant.dark:
        return AppColors.textPrimaryLight;
    }
  }

  Color _fg(BuildContext context) {
    switch (variant) {
      case PosButtonVariant.primary:
      case PosButtonVariant.danger:
      case PosButtonVariant.dark:
        return Colors.white;
      case PosButtonVariant.soft:
      case PosButtonVariant.outlinePrimary:
      case PosButtonVariant.ghost:
        return AppColors.primary;
      case PosButtonVariant.outline:
        return Theme.of(context).brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    }
  }

  BorderSide? _border(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (variant) {
      case PosButtonVariant.outline:
        return BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight);
      case PosButtonVariant.outlinePrimary:
        return const BorderSide(color: AppColors.primary);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = _enabled ? _bg(context) : (isDark ? AppColors.borderDark : AppColors.borderLight);
    final fg = _enabled ? _fg(context) : (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight);
    final border = _enabled ? _border(context) : null;

    final Widget child = Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: _iconSize,
            height: _iconSize,
            child: CircularProgressIndicator(strokeWidth: 2, color: fg),
          ),
          const SizedBox(width: AppSpacing.sm),
        ] else if (icon != null) ...[
          Icon(icon, size: _iconSize),
          const SizedBox(width: AppSpacing.sm),
        ],
        Flexible(child: Text(label, overflow: TextOverflow.ellipsis, maxLines: 1)),
        if (trailingIcon != null) ...[const SizedBox(width: AppSpacing.sm), Icon(trailingIcon, size: _iconSize)],
      ],
    );

    final resolvedBorderRadius = borderRadius ?? AppRadius.borderMd;

    final style = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((_) => bg),
      foregroundColor: WidgetStateProperty.resolveWith((_) => fg),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return fg.withValues(alpha: 0.08);
        }
        if (states.contains(WidgetState.hovered)) {
          return fg.withValues(alpha: 0.05);
        }
        if (states.contains(WidgetState.focused)) {
          return fg.withValues(alpha: 0.06);
        }
        return null;
      }),
      elevation: WidgetStateProperty.all(0),
      padding: WidgetStateProperty.all(_padding),
      minimumSize: WidgetStateProperty.all(Size(0, _height)),
      textStyle: WidgetStateProperty.all(_textStyle),
      shape: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return RoundedRectangleBorder(
            borderRadius: resolvedBorderRadius,
            side: BorderSide(color: isDark ? AppColors.focusRingDark : AppColors.focusRing, width: 2),
          );
        }
        return RoundedRectangleBorder(borderRadius: resolvedBorderRadius, side: border ?? BorderSide.none);
      }),
    );

    return isFullWidth
        ? SizedBox(
            width: double.infinity,
            child: ElevatedButton(style: style, onPressed: _enabled ? onPressed : null, child: child),
          )
        : ElevatedButton(style: style, onPressed: _enabled ? onPressed : null, child: child);
  }
}

// ─── Icon-Only Button ────────────────────────────────────────

class _PosIconButton extends PosButton {
  const _PosIconButton({
    super.key,
    required IconData icon,
    super.onPressed,
    super.variant,
    this.iconSize = 24,
    this.tooltip,
  }) : _iconData = icon,
       super(label: '');

  final IconData _iconData;
  final double iconSize;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = _enabled ? _bg(context) : (isDark ? AppColors.borderDark : AppColors.borderLight);
    final fg = _enabled ? _fg(context) : (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight);

    Widget btn = Material(
      color: bg,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _enabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: iconSize + 24,
          height: iconSize + 24,
          child: Center(
            child: Icon(_iconData, size: iconSize, color: fg),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      btn = Tooltip(message: tooltip!, child: btn);
    }
    return btn;
  }
}

// ─── Category Pill Button ────────────────────────────────────

class _PosPillButton extends PosButton {
  const _PosPillButton({super.key, required super.label, super.onPressed, this.isSelected = false, super.icon})
    : super(variant: PosButtonVariant.soft);

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final bg = isSelected ? AppColors.primary : AppColors.primary10;
    final fg = isSelected ? Colors.white : AppColors.primary;

    return Material(
      color: bg,
      borderRadius: AppRadius.borderFull,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.borderFull,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: fg), const SizedBox(width: 6)],
              Text(label, style: AppTypography.labelMedium.copyWith(color: fg)),
            ],
          ),
        ),
      ),
    );
  }
}
