import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class QuickActionsWidget extends ConsumerWidget {
  const QuickActionsWidget({super.key});

  static const _iconMap = <String, IconData>{
    'point_of_sale': Icons.point_of_sale,
    'list_alt': Icons.list_alt,
    'add_box': Icons.add_box,
    'schedule': Icons.schedule,
    'nightlight_round': Icons.nightlight_round,
    'shopping_cart': Icons.shopping_cart,
    'inventory': Icons.inventory,
    'people': Icons.people,
    'settings': Icons.settings,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(quickActionsProvider);
    final theme = Theme.of(context);

    return switch (state) {
      QuickActionsInitial() || QuickActionsLoading() => const Center(child: CircularProgressIndicator()),
      QuickActionsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      QuickActionsLoaded(:final actions) => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deliveryQuickActions, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapH16,
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: actions.length,
              itemBuilder: (context, index) {
                final action = actions[index];
                final enabled = action['enabled'] as bool? ?? true;
                final iconName = action['icon'] as String? ?? 'settings';
                final icon = _iconMap[iconName] ?? Icons.touch_app;

                return Card(
                  elevation: enabled ? 2 : 0,
                  color: enabled ? null : theme.colorScheme.surfaceContainerHighest,
                  child: InkWell(
                    borderRadius: AppRadius.borderLg,
                    onTap: enabled ? () {} : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          size: 32,
                          color: enabled ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(100),
                        ),
                        AppSpacing.gapH8,
                        Text(
                          action['label'] as String? ?? '',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: enabled ? null : theme.colorScheme.onSurface.withAlpha(100),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    };
  }
}
