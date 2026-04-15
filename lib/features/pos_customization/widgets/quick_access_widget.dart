import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_state.dart';
import 'package:wameedpos/features/pos_customization/providers/customization_providers.dart';

class QuickAccessWidget extends ConsumerWidget {
  const QuickAccessWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quickAccessProvider);
    final theme = Theme.of(context);

    return switch (state) {
      QuickAccessInitial() || QuickAccessLoading() => const Center(child: CircularProgressIndicator()),
      QuickAccessError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, color: theme.colorScheme.error),
            AppSpacing.gapH8,
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
          ],
        ),
      ),
      final QuickAccessLoaded s => SingleChildScrollView(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Grid Layout', style: theme.textTheme.titleMedium),
                          AppSpacing.gapH4,
                          Text('${s.gridRows} rows × ${s.gridCols} cols', style: theme.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Icon(Icons.grid_on, size: 40, color: theme.colorScheme.primary),
                  ],
                ),
              ),
            ),
            AppSpacing.gapH16,
            Text('Buttons (${s.buttons.length})', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            AppSpacing.gapH8,
            if (s.buttons.isEmpty)
              Center(child: Text('No quick access buttons configured', style: theme.textTheme.bodyMedium))
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: s.gridCols,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: s.buttons.length,
                itemBuilder: (context, index) {
                  final btn = s.buttons[index];
                  Color? bgColor;
                  try {
                    final hex = btn['color'] as String?;
                    if (hex != null) {
                      bgColor = Color(int.parse(hex.replaceFirst('#', '0xFF')));
                    }
                  } catch (_) {}

                  return Card(
                    color: bgColor,
                    child: Center(
                      child: Text(
                        btn['label'] as String? ?? '',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(color: bgColor != null ? Colors.white : null),
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
