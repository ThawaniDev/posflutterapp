import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/settings/enums/locale_direction.dart';
import 'package:thawani_pos/features/settings/models/supported_locale.dart';

class LocaleSelector extends StatelessWidget {
  final List<SupportedLocale> locales;
  final String? selectedCode;
  final ValueChanged<SupportedLocale> onSelected;

  const LocaleSelector({super.key, required this.locales, this.selectedCode, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Supported Languages', style: theme.textTheme.titleMedium),
            AppSpacing.gapH12,
            ...locales.map((locale) {
              final isSelected = locale.localeCode == selectedCode;
              return ListTile(
                leading: Icon(
                  locale.direction == LocaleDirection.rtl ? Icons.format_textdirection_r_to_l : Icons.format_textdirection_l_to_r,
                  color: isSelected ? theme.colorScheme.primary : null,
                ),
                title: Text(locale.languageName),
                subtitle: Text(locale.languageNameNative),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (locale.isDefault == true)
                      Chip(
                        label: const Text('Default'),
                        backgroundColor: theme.colorScheme.primaryContainer,
                        labelStyle: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 12),
                      ),
                    AppSpacing.gapW8,
                    Icon(
                      locale.isActive == true ? Icons.check_circle : Icons.cancel,
                      color: locale.isActive == true ? AppColors.success : AppColors.textSecondary,
                      size: 20,
                    ),
                  ],
                ),
                selected: isSelected,
                onTap: () => onSelected(locale),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
              );
            }),
          ],
        ),
      ),
    );
  }
}
