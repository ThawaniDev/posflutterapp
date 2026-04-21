import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Consistent section card used across all settings sub-pages.
class SettingsSectionCard extends StatelessWidget {

  const SettingsSectionCard({super.key, required this.title, this.subtitle, this.icon, required this.children});
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PosCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[Icon(icon, size: 20, color: theme.colorScheme.primary), AppSpacing.gapW8],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      if (subtitle != null)
                        Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight)),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH12,
            const Divider(height: 1),
            AppSpacing.gapH12,
            ...children,
          ],
        ),
      ),
    );
  }
}

/// A toggle switch row within a settings section.
class SettingsToggleRow extends StatelessWidget {

  const SettingsToggleRow({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });
  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                if (description != null)
                  Text(description!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
          Switch.adaptive(value: value, onChanged: enabled ? onChanged : null),
        ],
      ),
    );
  }
}

/// Dropdown selector row within a settings section.
class SettingsDropdownRow<T> extends StatelessWidget {

  const SettingsDropdownRow({
    super.key,
    required this.label,
    this.description,
    required this.value,
    required this.items,
    required this.onChanged,
  });
  final String label;
  final String? description;
  final T value;
  final List<PosDropdownItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                if (description != null)
                  Text(description!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            child: PosSearchableDropdown<T>(
              items: items,
              selectedValue: value,
              onChanged: onChanged,
              showSearch: false,
              clearable: false,
            ),
          ),
        ],
      ),
    );
  }
}

/// Numeric stepper row within a settings section.
class SettingsNumberRow extends StatelessWidget {

  const SettingsNumberRow({
    super.key,
    required this.label,
    this.description,
    this.suffix,
    required this.value,
    this.min = 0,
    this.max = 999,
    required this.onChanged,
  });
  final String label;
  final String? description;
  final String? suffix;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium),
                if (description != null)
                  Text(description!, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondaryLight)),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline, size: 22),
                onPressed: value > min ? () => onChanged(value - 1) : null,
                visualDensity: VisualDensity.compact,
              ),
              SizedBox(
                width: 48,
                child: Text(
                  suffix != null ? '$value $suffix' : '$value',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline, size: 22),
                onPressed: value < max ? () => onChanged(value + 1) : null,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
