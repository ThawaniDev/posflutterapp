import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS DATE RANGE PICKER
// ─────────────────────────────────────────────────────────────

/// Show a Thawani-themed date-range picker dialog.
///
/// Wraps [showDateRangePicker] with brand colors and sensible defaults.
/// Returns `null` when the user cancels.
///
/// ```dart
/// final range = await showPosDateRangePicker(context);
/// if (range != null) { /* use range.start / range.end */ }
/// ```
Future<DateTimeRange?> showPosDateRangePicker(
  BuildContext context, {
  DateTimeRange? initialDateRange,
  DateTime? firstDate,
  DateTime? lastDate,
  String? helpText,
  String? saveText,
}) {
  final now = DateTime.now();
  return showDateRangePicker(
    context: context,
    initialDateRange: initialDateRange,
    firstDate: firstDate ?? DateTime(now.year - 3),
    lastDate: lastDate ?? now,
    helpText: helpText,
    saveText: saveText,
    // Force the calendar entry mode so tablet always lands on the visual
    // grid. The default `input` mode on tablet was rendering blank because
    // our app's custom dialogTheme interfered with the Material3 picker
    // layout when the user toggled to calendar.
    initialEntryMode: DatePickerEntryMode.calendar,
    builder: (context, child) {
      final base = Theme.of(context);
      return Theme(
        // Reset the picker's surrounding theme to safe defaults so our
        // app-wide `dialogTheme` shape/elevation overrides don't clip the
        // date range picker's internal Dialog layout (Material 3 sizes the
        // calendar grid based on these values).
        data: base.copyWith(
          colorScheme: base.colorScheme.copyWith(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: base.brightness == Brightness.dark ? AppColors.cardDark : AppColors.surfaceLight,
            onSurface: base.brightness == Brightness.dark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
          dialogTheme: const DialogThemeData(),
        ),
        child: child!,
      );
    },
  );
}

/// Inline date-range display chip that opens the picker on tap.
///
/// Shows the selected range in a styled chip. When tapped, opens
/// [showPosDateRangePicker] and calls [onChanged] with the result.
class PosDateRangeChip extends StatelessWidget {
  const PosDateRangeChip({
    super.key,
    this.dateRange,
    required this.onChanged,
    this.label = 'Date range',
    this.firstDate,
    this.lastDate,
  });

  final DateTimeRange? dateRange;
  final ValueChanged<DateTimeRange?> onChanged;
  final String label;
  final DateTime? firstDate;
  final DateTime? lastDate;

  String _formatRange(DateTimeRange range) {
    final s = range.start;
    final e = range.end;
    String fmt(DateTime d) => '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    return '${fmt(s)} – ${fmt(e)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasRange = dateRange != null;

    return Material(
      color: hasRange ? AppColors.primary10 : (isDark ? AppColors.inputBgDark : AppColors.inputBgLight),
      borderRadius: AppRadius.borderFull,
      child: InkWell(
        borderRadius: AppRadius.borderFull,
        onTap: () async {
          final picked = await showPosDateRangePicker(
            context,
            initialDateRange: dateRange,
            firstDate: firstDate,
            lastDate: lastDate,
          );
          if (picked != null) {
            onChanged(picked);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range_rounded,
                size: 16,
                color: hasRange ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
              ),
              AppSpacing.gapW8,
              Text(
                hasRange ? _formatRange(dateRange!) : label,
                style: AppTypography.labelSmall.copyWith(
                  color: hasRange ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
              ),
              if (hasRange) ...[
                AppSpacing.gapW4,
                GestureDetector(
                  onTap: () => onChanged(null),
                  child: const Icon(Icons.close_rounded, size: 14, color: AppColors.primary),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
