import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/settings/models/master_translation_string.dart';

class TranslationStringCard extends StatelessWidget {
  final MasterTranslationString translation;
  final String? overrideValue;
  final VoidCallback? onEdit;

  const TranslationStringCard({super.key, required this.translation, this.overrideValue, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    translation.stringKey,
                    style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace', color: theme.colorScheme.primary),
                  ),
                ),
                Chip(
                  label: Text(translation.category.value),
                  labelStyle: const TextStyle(fontSize: 10),
                  visualDensity: VisualDensity.compact,
                ),
                if (onEdit != null) IconButton(icon: const Icon(Icons.edit, size: 18), onPressed: onEdit, tooltip: 'Edit'),
              ],
            ),
            AppSpacing.gapH8,
            _buildRow(context, 'EN', translation.valueEn),
            AppSpacing.gapH4,
            _buildRow(context, 'AR', translation.valueAr),
            if (overrideValue != null) ...[AppSpacing.gapH4, _buildRow(context, 'Override', overrideValue!, highlight: true)],
            if (translation.description != null && translation.description!.isNotEmpty) ...[
              AppSpacing.gapH4,
              Text(translation.description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, String label, String value, {bool highlight = false}) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: highlight ? theme.colorScheme.tertiary : null,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: highlight
                ? theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w600)
                : theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
