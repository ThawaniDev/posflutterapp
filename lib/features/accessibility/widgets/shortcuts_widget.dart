import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';
import 'package:wameedpos/features/accessibility/services/keyboard_shortcut_service.dart';
import 'package:wameedpos/features/accessibility/widgets/shortcut_reassign_dialog.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ShortcutsWidget extends ConsumerWidget {
  const ShortcutsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(shortcutsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return switch (state) {
      ShortcutsInitial() => Center(child: Text(l10n.accessibilityShortcuts)),
      ShortcutsLoading() => const PosLoading(),
      ShortcutsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      ShortcutsLoaded(:final shortcuts) => _ShortcutsLoaded(
          customOverrides: shortcuts,
          isDark: isDark,
        ),
    };
  }
}

class _ShortcutsLoaded extends ConsumerStatefulWidget {
  const _ShortcutsLoaded({required this.customOverrides, required this.isDark});
  final Map<String, dynamic> customOverrides;
  final bool isDark;

  @override
  ConsumerState<_ShortcutsLoaded> createState() => _ShortcutsLoadedState();
}

class _ShortcutsLoadedState extends ConsumerState<_ShortcutsLoaded> {
  late final KeyboardShortcutService _service;

  @override
  void initState() {
    super.initState();
    _service = KeyboardShortcutService();
    _service.applyCustomShortcuts(widget.customOverrides);
  }

  @override
  void didUpdateWidget(_ShortcutsLoaded oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.customOverrides != widget.customOverrides) {
      _service.resetToDefaults();
      _service.applyCustomShortcuts(widget.customOverrides);
    }
  }

  Future<void> _reassign(BuildContext context, String actionKey, String currentLabel) async {
    final l10n = AppLocalizations.of(context)!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final newLabel = await ShortcutReassignDialog.show(
      context,
      actionName: actionKey,
      currentLabel: currentLabel,
      service: _service,
    );
    if (newLabel == null || !mounted) return;

    final ok = _service.reassignShortcut(actionKey, newLabel);
    if (!ok) return;

    // Persist to API: only send the customized overrides
    final updatedOverrides = <String, String>{};
    for (final e in _service.shortcuts.entries) {
      final def = kDefaultShortcuts[e.key];
      if (def != null && e.value.label != def.label) {
        updatedOverrides[e.key] = e.value.label;
      }
    }
    await ref.read(shortcutsProvider.notifier).update(updatedOverrides);

    scaffoldMessenger.showSnackBar(
      SnackBar(content: Text('${l10n.accessibilityShortcuts} — ${l10n.save}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final grouped = _service.groupedByContext();
    final posShortcuts = grouped['pos'] ?? [];
    final globalShortcuts = grouped['global'] ?? [];
    final navShortcuts = grouped['navigation'] ?? [];

    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        // ─── Hint Banner ──────────────────────────────
        _HintBanner(isDark: widget.isDark),
        AppSpacing.gapH16,
        // ─── POS Shortcuts ─────────────────────────
        _ShortcutGroup(
          title: l10n.accessibilityShortcutsPOS,
          icon: Icons.point_of_sale,
          shortcuts: posShortcuts,
          onReassign: _reassign,
          customKeys: widget.customOverrides.keys.toSet(),
        ),
        AppSpacing.gapH16,
        // ─── Global Shortcuts ─────────────────────────
        _ShortcutGroup(
          title: l10n.accessibilityShortcutsGlobal,
          icon: Icons.public,
          shortcuts: globalShortcuts,
          onReassign: _reassign,
          customKeys: widget.customOverrides.keys.toSet(),
        ),
        AppSpacing.gapH16,
        // ─── Navigation Shortcuts ─────────────────────────
        _NavigationShortcutsGroup(navShortcuts: navShortcuts),
        AppSpacing.gapH16,
        // ─── Reset All ─────────────────────────
        _ResetButton(
          onReset: () async {
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final resetLabel = l10n.accessibilityReset;
            final confirmed = await _confirmReset(context);
            if (!confirmed || !mounted) return;
            _service.resetToDefaults();
            await ref.read(shortcutsProvider.notifier).update({});
            scaffoldMessenger.showSnackBar(
              SnackBar(content: Text(resetLabel)),
            );
          },
        ),
        AppSpacing.gapH16,
      ],
    );
  }

  Future<bool> _confirmReset(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.accessibilityReset),
        content: Text(l10n.accessibilityReassignDesc),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: Theme.of(ctx).colorScheme.error),
            child: Text(l10n.accessibilityReset),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hint Banner
// ─────────────────────────────────────────────────────────────────────────────
class _HintBanner extends StatelessWidget {
  const _HintBanner({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: AppSpacing.paddingAll12,
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.keyboard_alt_outlined, color: AppColors.info, size: 20),
          AppSpacing.gapW12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.accessibilityShortcutReference,
                  style: AppTypography.titleSmall.copyWith(color: AppColors.infoDark),
                ),
                Text(
                  l10n.accessibilityShortcutHint,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shortcut Group
// ─────────────────────────────────────────────────────────────────────────────
class _ShortcutGroup extends StatelessWidget {
  const _ShortcutGroup({
    required this.title,
    required this.icon,
    required this.shortcuts,
    required this.onReassign,
    required this.customKeys,
  });

  final String title;
  final IconData icon;
  final List<MapEntry<String, ShortcutBinding>> shortcuts;
  final Future<void> Function(BuildContext, String, String) onReassign;
  final Set<String> customKeys;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Icon(icon, size: 18, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(title, style: AppTypography.headlineSmall),
              ],
            ),
          ),
          const Divider(height: 1),
          ...shortcuts.map(
            (entry) => _ShortcutTile(
              actionKey: entry.key,
              binding: entry.value,
              isCustomized: customKeys.contains(entry.key),
              isDark: isDark,
              onEdit: (ctx) => onReassign(ctx, entry.key, entry.value.label),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShortcutTile extends StatelessWidget {
  const _ShortcutTile({
    required this.actionKey,
    required this.binding,
    required this.isCustomized,
    required this.isDark,
    required this.onEdit,
  });

  final String actionKey;
  final ShortcutBinding binding;
  final bool isCustomized;
  final bool isDark;
  final void Function(BuildContext) onEdit;

  String _formatActionLabel(String key) {
    return key.replaceAll('_', ' ').replaceFirstMapped(RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(
        Icons.keyboard,
        size: 18,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
      title: Text(
        binding.description,
        style: theme.textTheme.bodyMedium,
      ),
      subtitle: isCustomized
          ? Text(
              _formatActionLabel(actionKey),
              style: AppTypography.labelSmall.copyWith(color: AppColors.primary),
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _KeyChip(label: binding.label, isCustomized: isCustomized),
          AppSpacing.gapW4,
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 16),
            tooltip: 'Reassign',
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            onPressed: () => onEdit(context),
          ),
        ],
      ),
    );
  }
}

class _KeyChip extends StatelessWidget {
  const _KeyChip({required this.label, required this.isCustomized});
  final String label;
  final bool isCustomized;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isCustomized
            ? AppColors.primary.withValues(alpha: 0.1)
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: AppRadius.borderSm,
        border: Border.all(
          color: isCustomized ? AppColors.primary : theme.dividerColor,
          width: isCustomized ? 1.5 : 1.0,
        ),
      ),
      child: Text(
        label,
        style: AppTypography.labelMedium.copyWith(
          fontFamily: 'monospace',
          color: isCustomized ? AppColors.primary : null,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Navigation Shortcuts Group (non-editable system shortcuts)
// ─────────────────────────────────────────────────────────────────────────────
class _NavigationShortcutsGroup extends StatelessWidget {
  const _NavigationShortcutsGroup({required this.navShortcuts});
  final List<MapEntry<String, ShortcutBinding>> navShortcuts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // System nav shortcuts that are non-editable
    final systemShortcuts = [
      _NavEntry(l10n.accessibilityNavScreens, l10n.accessShortcutAlt19),
      _NavEntry(l10n.accessibilityNavTab, l10n.accessShortcutTab),
      _NavEntry(l10n.accessibilityNavCancel, l10n.accessShortcutEsc),
      _NavEntry(l10n.accessibilityNavConfirm, l10n.accessShortcutEnter),
      _NavEntry(l10n.accessibilityShortcutReference, l10n.accessShortcutCtrlSlash),
    ];

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                const Icon(Icons.navigation, size: 18, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(l10n.accessibilityShortcutsNavigation, style: AppTypography.headlineSmall),
                AppSpacing.gapW8,
                const PosBadge(label: 'System', variant: PosBadgeVariant.info),
              ],
            ),
          ),
          const Divider(height: 1),
          ...systemShortcuts.map(
            (nav) => ListTile(
              leading: Icon(
                Icons.keyboard,
                size: 18,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              title: Text(nav.description),
              trailing: _KeyChip(label: nav.label, isCustomized: false),
              dense: true,
            ),
          ),
          // Also show any loaded navigation shortcuts from service
          ...navShortcuts.map(
            (e) => ListTile(
              leading: Icon(
                Icons.keyboard,
                size: 18,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              title: Text(e.value.description),
              trailing: _KeyChip(label: e.value.label, isCustomized: false),
              dense: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavEntry {
  const _NavEntry(this.description, this.label);
  final String description;
  final String label;
}

// ─────────────────────────────────────────────────────────────────────────────
// Reset Button
// ─────────────────────────────────────────────────────────────────────────────
class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset});
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: PosButton(
        icon: Icons.restore,
        label: l10n.accessibilityReset,
        variant: PosButtonVariant.outline,
        onPressed: onReset,
      ),
    );
  }
}

