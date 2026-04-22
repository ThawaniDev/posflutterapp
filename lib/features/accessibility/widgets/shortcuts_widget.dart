import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';
import 'package:wameedpos/features/accessibility/services/keyboard_shortcut_service.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ShortcutsWidget extends ConsumerWidget {
  const ShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shortcutsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      ShortcutsInitial() => Center(child: Text(l10n.accessibilityShortcuts)),
      ShortcutsLoading() => const PosLoading(),
      ShortcutsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      ShortcutsLoaded(:final shortcuts) => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // ─── POS Shortcuts ─────────────
          _ShortcutGroup(title: l10n.accessibilityShortcutsPOS, shortcuts: _filterByContext(shortcuts, 'pos'), theme: theme),
          AppSpacing.gapH16,
          // ─── Global Shortcuts ─────────────
          _ShortcutGroup(
            title: l10n.accessibilityShortcutsGlobal,
            shortcuts: _filterByContext(shortcuts, 'global'),
            theme: theme,
          ),
          AppSpacing.gapH16,
          // ─── Navigation Shortcuts ─────────────
          PosCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.accessibilityShortcutsNavigation, style: theme.textTheme.titleMedium),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: Text(l10n.accessibilityNavScreens),
                  trailing: Chip(
                    label: Text(l10n.accessShortcutAlt19, style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: Text(l10n.accessibilityNavTab),
                  trailing: Chip(
                    label: Text(l10n.accessShortcutTab, style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: Text(l10n.accessibilityNavCancel),
                  trailing: Chip(
                    label: Text(l10n.accessShortcutEsc, style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.keyboard),
                  title: Text(l10n.accessibilityNavConfirm),
                  trailing: Chip(
                    label: Text(l10n.accessShortcutEnter, style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace')),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    };
  }

  Map<String, dynamic> _filterByContext(Map<String, dynamic> shortcuts, String context) {
    // Match shortcuts to defaults to get context
    final result = <String, dynamic>{};
    for (final entry in shortcuts.entries) {
      final defaultBinding = kDefaultShortcuts[entry.key];
      if (defaultBinding != null && defaultBinding.context == context) {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }
}

class _ShortcutGroup extends StatelessWidget {
  const _ShortcutGroup({required this.title, required this.shortcuts, required this.theme});

  final String title;
  final Map<String, dynamic> shortcuts;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Text(title, style: theme.textTheme.titleMedium),
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
    );
  }

  String _formatLabel(String key) {
    return key.replaceAll('_', ' ').replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
  }
}
