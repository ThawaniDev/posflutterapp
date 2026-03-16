import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_providers.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_state.dart';

class ShortcutsWidget extends ConsumerWidget {
  const ShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shortcutsProvider);
    final theme = Theme.of(context);

    return switch (state) {
      ShortcutsInitial() => const Center(child: Text('Loading shortcuts...')),
      ShortcutsLoading() => const Center(child: CircularProgressIndicator()),
      ShortcutsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      ShortcutsLoaded(:final shortcuts) => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text('Keyboard Shortcuts', style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ...shortcuts.entries.map(
                  (e) => ListTile(
                    leading: const Icon(Icons.keyboard),
                    title: Text(_formatLabel(e.key)),
                    trailing: Chip(
                      label: Text(e.value.toString(), style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    };
  }

  String _formatLabel(String key) {
    return key.replaceAll('_', ' ').replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
  }
}
