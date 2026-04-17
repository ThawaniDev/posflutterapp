import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AIModelSelector extends StatelessWidget {
  final List<LlmModel> models;
  final LlmModel? selectedModel;
  final ValueChanged<LlmModel> onSelected;

  const AIModelSelector({super.key, required this.models, this.selectedModel, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final displayName = selectedModel?.displayName ?? l10n.wameedAISelectModel;

    return PopupMenuButton<LlmModel>(
      onSelected: onSelected,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderXxl),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_providerIcon(selectedModel?.provider ?? ''), size: 16, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              displayName,
              style: theme.textTheme.labelMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down, size: 18, color: AppColors.primary),
          ],
        ),
      ),
      itemBuilder: (context) {
        // Group by provider
        final grouped = <String, List<LlmModel>>{};
        for (final m in models) {
          (grouped[m.provider] ??= []).add(m);
        }

        final items = <PopupMenuEntry<LlmModel>>[];
        for (final entry in grouped.entries) {
          items.add(
            PopupMenuItem<LlmModel>(
              enabled: false,
              height: 32,
              child: Text(
                entry.key == 'openai'
                    ? 'OpenAI'
                    : entry.key == 'anthropic'
                    ? 'Anthropic'
                    : entry.key == 'google'
                    ? 'Google'
                    : entry.key,
                style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.hintColor),
              ),
            ),
          );
          for (final model in entry.value) {
            final isSelected = selectedModel?.id == model.id;
            items.add(
              PopupMenuItem<LlmModel>(
                value: model,
                child: Row(
                  children: [
                    if (isSelected) const Icon(Icons.check, size: 16, color: AppColors.primary) else const SizedBox(width: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.displayName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          if (model.description != null)
                            Text(
                              model.description!,
                              style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (model.supportsVision)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Icon(Icons.image, size: 14, color: theme.hintColor),
                      ),
                    if (model.isDefault)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: AppRadius.borderXs,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.wameedAIDefault,
                            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.success, fontSize: 9),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }
          if (entry.key != grouped.keys.last) {
            items.add(const PopupMenuDivider());
          }
        }

        return items;
      },
    );
  }

  IconData _providerIcon(String provider) {
    return switch (provider) {
      'openai' => Icons.lightbulb_outline,
      'anthropic' => Icons.psychology_outlined,
      'google' => Icons.auto_awesome_outlined,
      _ => Icons.smart_toy_outlined,
    };
  }
}
