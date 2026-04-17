import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/accessibility/services/keyboard_shortcut_service.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Full-screen overlay showing all keyboard shortcuts, accessible via Ctrl+/.
/// Groups shortcuts by context (POS, Global, Navigation).
class ShortcutReferenceOverlay extends StatelessWidget {
  const ShortcutReferenceOverlay({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const ShortcutReferenceOverlay(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final grouped = _buildGroupedShortcuts(l10n);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Row(
              children: [
                const Icon(Icons.keyboard, size: 24),
                AppSpacing.gapW12,
                Expanded(child: Text(l10n.accessibilityShortcutReference, style: theme.textTheme.titleLarge)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(), tooltip: l10n.close),
              ],
            ),
          ),
          const Divider(height: 1),
          // Shortcut groups
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: AppSpacing.paddingAll16,
              itemCount: grouped.length,
              itemBuilder: (context, index) {
                final group = grouped[index];
                return _ShortcutGroup(title: group.title, shortcuts: group.shortcuts);
              },
            ),
          ),
          // Footer
          Container(
            padding: AppSpacing.paddingAll12,
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.info_outline, size: 14),
                AppSpacing.gapW8,
                Text(
                  l10n.accessibilityShortcutHint,
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<_ShortcutGroupData> _buildGroupedShortcuts(AppLocalizations l10n) {
    final posShortcuts = <_ShortcutEntry>[];
    final globalShortcuts = <_ShortcutEntry>[];

    for (final entry in kDefaultShortcuts.entries) {
      final binding = entry.value;
      final shortcutEntry = _ShortcutEntry(action: entry.key, label: binding.label, description: binding.description);
      if (binding.context == 'pos') {
        posShortcuts.add(shortcutEntry);
      } else {
        globalShortcuts.add(shortcutEntry);
      }
    }

    return [
      _ShortcutGroupData(title: l10n.accessibilityShortcutsPOS, shortcuts: posShortcuts),
      _ShortcutGroupData(title: l10n.accessibilityShortcutsGlobal, shortcuts: globalShortcuts),
      _ShortcutGroupData(
        title: l10n.accessibilityShortcutsNavigation,
        shortcuts: [
          _ShortcutEntry(action: 'nav_screens', label: 'Alt+1-9', description: l10n.accessibilityNavScreens),
          _ShortcutEntry(action: 'nav_tab', label: 'Tab / Shift+Tab', description: l10n.accessibilityNavTab),
          _ShortcutEntry(action: 'nav_cancel', label: 'Esc', description: l10n.accessibilityNavCancel),
          _ShortcutEntry(action: 'nav_confirm', label: 'Enter', description: l10n.accessibilityNavConfirm),
          _ShortcutEntry(action: 'shortcut_ref', label: 'Ctrl+/', description: l10n.accessibilityShortcutReference),
        ],
      ),
    ];
  }
}

class _ShortcutGroupData {
  final String title;
  final List<_ShortcutEntry> shortcuts;

  const _ShortcutGroupData({required this.title, required this.shortcuts});
}

class _ShortcutEntry {
  final String action;
  final String label;
  final String description;

  const _ShortcutEntry({required this.action, required this.label, required this.description});
}

class _ShortcutGroup extends StatelessWidget {
  const _ShortcutGroup({required this.title, required this.shortcuts});

  final String title;
  final List<_ShortcutEntry> shortcuts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PosCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSpacing.paddingAll16,
            child: Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...shortcuts.map(
            (s) => ListTile(
              dense: true,
              title: Text(s.description),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: AppRadius.borderSm,
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Text(
                  s.label,
                  style: theme.textTheme.labelLarge?.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
