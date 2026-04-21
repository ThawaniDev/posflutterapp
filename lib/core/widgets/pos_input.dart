import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

// ─────────────────────────────────────────────────────────────
// POS TEXT FIELD
// ─────────────────────────────────────────────────────────────

/// Thawani-styled text field with label, hint, prefix/suffix icon,
/// error state, and optional helper text.
class PosTextField extends StatelessWidget {
  const PosTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.validator,
    this.autovalidateMode,
    this.decoration,
    this.prefixIcon,
    this.suffixIcon,
    this.suffix,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textDirection,
  });

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode? autovalidateMode;
  final InputDecoration? decoration;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffix;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH4,
        ],
        TextFormField(
          controller: controller,
          initialValue: controller == null ? initialValue : null,
          focusNode: focusNode,
          obscureText: obscureText,
          enabled: enabled,
          readOnly: readOnly,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          autofocus: autofocus,
          textCapitalization: textCapitalization,
          textAlign: textAlign,
          textDirection: textDirection,
          validator: validator,
          autovalidateMode: autovalidateMode,
          decoration: (decoration ?? const InputDecoration()).copyWith(
            hintText: decoration?.hintText ?? hint,
            errorText: decoration?.errorText ?? errorText,
            helperText: decoration?.helperText ?? helperText,
            prefixIcon: decoration?.prefixIcon ?? (prefixIcon != null ? Icon(prefixIcon) : null),
            suffixIcon: decoration?.suffixIcon ?? suffix ?? (suffixIcon != null ? Icon(suffixIcon) : null),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POS SEARCH FIELD
// ─────────────────────────────────────────────────────────────

/// Compact search input with clear button.
class PosSearchField extends StatefulWidget {
  const PosSearchField({
    super.key,
    this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool autofocus;

  @override
  State<PosSearchField> createState() => _PosSearchFieldState();
}

class _PosSearchFieldState extends State<PosSearchField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChange);
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onTextChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: const Icon(Icons.search_rounded, size: 20),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 18),
                onPressed: () {
                  _controller.clear();
                  widget.onChanged?.call('');
                  widget.onClear?.call();
                },
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        isDense: true,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POS DROPDOWN
// ─────────────────────────────────────────────────────────────

/// Styled dropdown with label.
class PosDropdown<T> extends StatelessWidget {
  const PosDropdown({
    super.key,
    required this.items,
    this.value,
    this.label,
    this.hint,
    this.onChanged,
    this.errorText,
    this.isExpanded = true,
  });

  final List<DropdownMenuItem<T>> items;
  final T? value;
  final String? label;
  final String? hint;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          AppSpacing.gapH4,
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          isExpanded: isExpanded,
          hint: hint != null ? Text(hint!) : null,
          decoration: InputDecoration(errorText: errorText),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POS TOGGLE / SWITCH
// ─────────────────────────────────────────────────────────────

/// Labeled toggle switch row.
class PosToggle extends StatelessWidget {
  const PosToggle({super.key, required this.value, required this.onChanged, required this.label, this.subtitle});

  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTypography.titleSmall.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POS CHECKBOX TILE
// ─────────────────────────────────────────────────────────────

/// Checkbox with label text.
class PosCheckboxTile extends StatelessWidget {
  const PosCheckboxTile({super.key, required this.value, required this.onChanged, required this.label, this.subtitle});

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: AppRadius.borderMd,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: onChanged),
            AppSpacing.gapW8,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: AppTypography.caption.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POS NUMERIC COUNTER
// ─────────────────────────────────────────────────────────────

/// Qty stepper with – and + buttons.
class PosNumericCounter extends StatelessWidget {
  const PosNumericCounter({super.key, required this.value, this.onChanged, this.min = 0, this.max = 999, this.step = 1});

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final int step;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        borderRadius: AppRadius.borderMd,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterButton(icon: Icons.remove_rounded, onTap: value > min ? () => onChanged?.call(value - step) : null),
          Container(
            constraints: const BoxConstraints(minWidth: 40),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: AppTypography.titleMedium.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
            ),
          ),
          _CounterButton(icon: Icons.add_rounded, onTap: value < max ? () => onChanged?.call(value + step) : null),
        ],
      ),
    );
  }
}

class _CounterButton extends StatelessWidget {
  const _CounterButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderSm,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? AppColors.primary : (isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
        ),
      ),
    );
  }
}
