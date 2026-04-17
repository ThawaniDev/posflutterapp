import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS COLOR PICKER
// ─────────────────────────────────────────────────────────────

/// Default palette of POS-friendly brand and semantic colors.
const List<Color> kPosDefaultColors = [
  AppColors.primary,
  AppColors.secondary,
  AppColors.success,
  AppColors.info,
  AppColors.warning,
  AppColors.error,
  AppColors.purple,
  AppColors.rose,
  Color(0xFF06B6D4), // cyan-500
  Color(0xFF14B8A6), // teal-500
  Color(0xFF8B5CF6), // violet-500
  Color(0xFF6366F1), // indigo-500
  Color(0xFF0EA5E9), // sky-500
  Color(0xFF84CC16), // lime-500
  Color(0xFFD946EF), // fuchsia-500
  Color(0xFF78716C), // stone-500
];

/// A grid of color swatches with selection state.
///
/// Suitable for category colors, tag colors, etc.
///
/// ```dart
/// PosColorPicker(
///   selectedColor: _color,
///   onChanged: (c) => setState(() => _color = c),
/// )
/// ```
class PosColorPicker extends StatelessWidget {
  const PosColorPicker({
    super.key,
    required this.onChanged,
    this.selectedColor,
    this.colors = kPosDefaultColors,
    this.swatchSize = 36,
    this.spacing = 10,
    this.label,
  });

  final Color? selectedColor;
  final ValueChanged<Color> onChanged;

  /// Colors to display. Defaults to [kPosDefaultColors].
  final List<Color> colors;

  /// Diameter of each swatch circle.
  final double swatchSize;

  /// Gap between swatches.
  final double spacing;

  /// Optional label above the grid.
  final String? label;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AppTypography.labelMedium.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
          ),
          AppSpacing.gapH8,
        ],
        Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: colors.map((color) {
            final isSelected = selectedColor != null && selectedColor!.value == color.value;
            return GestureDetector(
              onTap: () => onChanged(color),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: swatchSize,
                height: swatchSize,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? (isDark ? Colors.white : AppColors.textPrimaryLight) : Colors.transparent,
                    width: 2.5,
                  ),
                  boxShadow: isSelected
                      ? [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: isSelected ? const Center(child: Icon(Icons.check_rounded, color: Colors.white, size: 18)) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Show a PosColorPicker in a bottom sheet.
///
/// Returns the picked [Color] or `null` when dismissed.
Future<Color?> showPosColorPicker(
  BuildContext context, {
  Color? selectedColor,
  List<Color> colors = kPosDefaultColors,
  String title = 'Choose a color',
}) {
  return showModalBottomSheet<Color>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl))),
    builder: (ctx) {
      final isDark = Theme.of(ctx).brightness == Brightness.dark;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: AppRadius.borderFull,
                  ),
                ),
              ),
              AppSpacing.gapH16,
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              AppSpacing.gapH16,
              PosColorPicker(selectedColor: selectedColor, colors: colors, onChanged: (color) => Navigator.pop(ctx, color)),
              AppSpacing.gapH8,
            ],
          ),
        ),
      );
    },
  );
}
