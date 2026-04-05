import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/accessibility/services/keyboard_shortcut_service.dart';

/// Dialog for reassigning a keyboard shortcut.
/// Listens for key events and validates against reserved/conflicting shortcuts.
class ShortcutReassignDialog extends StatefulWidget {
  const ShortcutReassignDialog({super.key, required this.actionName, required this.currentLabel, required this.service});

  final String actionName;
  final String currentLabel;
  final KeyboardShortcutService service;

  static Future<String?> show(
    BuildContext context, {
    required String actionName,
    required String currentLabel,
    required KeyboardShortcutService service,
  }) {
    return showDialog<String>(
      context: context,
      builder: (_) => ShortcutReassignDialog(actionName: actionName, currentLabel: currentLabel, service: service),
    );
  }

  @override
  State<ShortcutReassignDialog> createState() => _ShortcutReassignDialogState();
}

class _ShortcutReassignDialogState extends State<ShortcutReassignDialog> {
  String? _capturedLabel;
  String? _error;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return;

    // Ignore modifier-only presses
    if (event.logicalKey == LogicalKeyboardKey.controlLeft ||
        event.logicalKey == LogicalKeyboardKey.controlRight ||
        event.logicalKey == LogicalKeyboardKey.shiftLeft ||
        event.logicalKey == LogicalKeyboardKey.shiftRight ||
        event.logicalKey == LogicalKeyboardKey.altLeft ||
        event.logicalKey == LogicalKeyboardKey.altRight) {
      return;
    }

    final ctrl = HardwareKeyboard.instance.isControlPressed;
    final shift = HardwareKeyboard.instance.isShiftPressed;
    final alt = HardwareKeyboard.instance.isAltPressed;

    // Build label
    final parts = <String>[];
    if (ctrl) parts.add('Ctrl');
    if (shift) parts.add('Shift');
    if (alt) parts.add('Alt');

    final keyLabel = event.logicalKey.keyLabel;
    parts.add(keyLabel.isNotEmpty ? keyLabel : event.logicalKey.debugName ?? '?');

    final label = parts.join('+');

    // Validate
    if (kReservedShortcuts.contains(label)) {
      setState(() {
        _capturedLabel = null;
        _error = AppLocalizations.of(context)!.accessibilityShortcutReserved;
      });
      return;
    }

    // Check conflicts
    for (final entry in widget.service.shortcuts.entries) {
      if (entry.key != widget.actionName && entry.value.label == label) {
        setState(() {
          _capturedLabel = null;
          _error = '${AppLocalizations.of(context)!.accessibilityShortcutConflict} "${entry.value.description}"';
        });
        return;
      }
    }

    setState(() {
      _capturedLabel = label;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(l10n.accessibilityReassignShortcut),
      content: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyEvent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.accessibilityReassignDesc, style: theme.textTheme.bodyMedium),
            AppSpacing.gapH16,
            Container(
              padding: AppSpacing.paddingAll16,
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _error != null ? theme.colorScheme.error : theme.colorScheme.outline, width: 2),
              ),
              child: Center(
                child: Text(
                  _capturedLabel ?? l10n.accessibilityPressKey,
                  style: theme.textTheme.headlineSmall?.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                ),
              ),
            ),
            if (_error != null) ...[
              AppSpacing.gapH8,
              Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
            ],
            AppSpacing.gapH12,
            Text(
              '${l10n.accessibilityCurrentShortcut}: ${widget.currentLabel}',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _capturedLabel != null && _error == null ? () => Navigator.of(context).pop(_capturedLabel) : null,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
