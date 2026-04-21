import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Default keyboard shortcuts for POS operations.
const Map<String, ShortcutBinding> kDefaultShortcuts = {
  'help': ShortcutBinding('F1', LogicalKeyboardKey.f1, 'Help / Shortcut reference', 'global'),
  'new_sale': ShortcutBinding('F2', LogicalKeyboardKey.f2, 'New Sale', 'pos'),
  'search_product': ShortcutBinding('F3', LogicalKeyboardKey.f3, 'Search Product', 'pos'),
  'hold_cart': ShortcutBinding('F4', LogicalKeyboardKey.f4, 'Hold Cart', 'pos'),
  'pay': ShortcutBinding('F5', LogicalKeyboardKey.f5, 'Pay / Checkout', 'pos'),
  'apply_discount': ShortcutBinding('F6', LogicalKeyboardKey.f6, 'Apply Discount', 'pos'),
  'customer_lookup': ShortcutBinding('F7', LogicalKeyboardKey.f7, 'Customer Lookup', 'pos'),
  'void_item': ShortcutBinding('F8', LogicalKeyboardKey.f8, 'Void Last Item', 'pos'),
  'recall_cart': ShortcutBinding('F9', LogicalKeyboardKey.f9, 'Recall Held Cart', 'pos'),
  'open_drawer': ShortcutBinding('F10', LogicalKeyboardKey.f10, 'Open Cash Drawer', 'pos'),
  'print_receipt': ShortcutBinding('F11', LogicalKeyboardKey.f11, 'Print Last Receipt', 'pos'),
  'manager_override': ShortcutBinding('F12', LogicalKeyboardKey.f12, 'Manager Override (PIN)', 'pos'),
  'undo': ShortcutBinding('Ctrl+Z', LogicalKeyboardKey.keyZ, 'Undo Last Action', 'pos', ctrl: true),
  'lock_screen': ShortcutBinding('Ctrl+L', LogicalKeyboardKey.keyL, 'Lock Screen', 'global', ctrl: true),
  'shortcut_reference': ShortcutBinding('Ctrl+/', LogicalKeyboardKey.slash, 'Shortcut Reference', 'global', ctrl: true),
  'cancel': ShortcutBinding('Esc', LogicalKeyboardKey.escape, 'Cancel / Close Dialog', 'global'),
  'confirm': ShortcutBinding('Enter', LogicalKeyboardKey.enter, 'Confirm / Submit', 'global'),
  'nav_screen_1': ShortcutBinding('Alt+1', LogicalKeyboardKey.digit1, 'Navigate to Screen 1', 'navigation', alt: true),
  'nav_screen_2': ShortcutBinding('Alt+2', LogicalKeyboardKey.digit2, 'Navigate to Screen 2', 'navigation', alt: true),
  'nav_screen_3': ShortcutBinding('Alt+3', LogicalKeyboardKey.digit3, 'Navigate to Screen 3', 'navigation', alt: true),
  'nav_screen_4': ShortcutBinding('Alt+4', LogicalKeyboardKey.digit4, 'Navigate to Screen 4', 'navigation', alt: true),
  'nav_screen_5': ShortcutBinding('Alt+5', LogicalKeyboardKey.digit5, 'Navigate to Screen 5', 'navigation', alt: true),
  'nav_screen_6': ShortcutBinding('Alt+6', LogicalKeyboardKey.digit6, 'Navigate to Screen 6', 'navigation', alt: true),
  'nav_screen_7': ShortcutBinding('Alt+7', LogicalKeyboardKey.digit7, 'Navigate to Screen 7', 'navigation', alt: true),
  'nav_screen_8': ShortcutBinding('Alt+8', LogicalKeyboardKey.digit8, 'Navigate to Screen 8', 'navigation', alt: true),
  'nav_screen_9': ShortcutBinding('Alt+9', LogicalKeyboardKey.digit9, 'Navigate to Screen 9', 'navigation', alt: true),
};

/// Reserved system shortcuts that cannot be overridden.
const Set<String> kReservedShortcuts = {'Ctrl+C', 'Ctrl+V', 'Ctrl+X', 'Ctrl+A', 'Ctrl+S', 'Alt+F4', 'Ctrl+Alt+Delete'};

class ShortcutBinding {

  const ShortcutBinding(
    this.label,
    this.key,
    this.description,
    this.context, {
    this.ctrl = false,
    this.shift = false,
    this.alt = false,
  });
  final String label;
  final LogicalKeyboardKey key;
  final String description;
  final String context;
  final bool ctrl;
  final bool shift;
  final bool alt;

  /// Check if a keyboard event matches this shortcut.
  bool matches(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (event.logicalKey != key) return false;
    if (ctrl && !HardwareKeyboard.instance.isControlPressed) return false;
    if (shift && !HardwareKeyboard.instance.isShiftPressed) return false;
    if (alt && !HardwareKeyboard.instance.isAltPressed) return false;
    return true;
  }
}

/// Manages keyboard shortcuts: registration, conflict detection, and dispatch.
class KeyboardShortcutService {
  final Map<String, ShortcutBinding> _shortcuts = Map.from(kDefaultShortcuts);
  final Map<String, VoidCallback> _handlers = {};

  Map<String, ShortcutBinding> get shortcuts => Map.unmodifiable(_shortcuts);

  /// Register a handler for a shortcut action.
  void registerHandler(String action, VoidCallback handler) {
    _handlers[action] = handler;
  }

  /// Unregister a handler.
  void unregisterHandler(String action) {
    _handlers.remove(action);
  }

  /// Override a shortcut key binding. Returns false if the new key conflicts
  /// with a reserved shortcut or another action.
  bool reassignShortcut(String action, String newLabel) {
    if (kReservedShortcuts.contains(newLabel)) return false;

    // Check for conflicts with other assigned shortcuts
    for (final entry in _shortcuts.entries) {
      if (entry.key != action && entry.value.label == newLabel) return false;
    }

    final existing = _shortcuts[action];
    if (existing == null) return false;

    // Parse the new label into a ShortcutBinding
    final parsed = _parseLabel(newLabel, existing.description, existing.context);
    if (parsed == null) return false;

    _shortcuts[action] = parsed;
    return true;
  }

  /// Apply custom shortcut overrides from saved preferences.
  void applyCustomShortcuts(Map<String, dynamic> customShortcuts) {
    for (final entry in customShortcuts.entries) {
      final existing = _shortcuts[entry.key] ?? kDefaultShortcuts[entry.key];
      if (existing != null) {
        final parsed = _parseLabel(entry.value.toString(), existing.description, existing.context);
        if (parsed != null) {
          _shortcuts[entry.key] = parsed;
        }
      }
    }
  }

  /// Reset all shortcuts to defaults.
  void resetToDefaults() {
    _shortcuts
      ..clear()
      ..addAll(kDefaultShortcuts);
  }

  /// Handle a keyboard event — dispatch to registered handler if matched.
  bool handleKeyEvent(KeyEvent event) {
    for (final entry in _shortcuts.entries) {
      if (entry.value.matches(event)) {
        final handler = _handlers[entry.key];
        if (handler != null) {
          handler();
          return true;
        }
      }
    }
    return false;
  }

  /// Get shortcuts grouped by context.
  Map<String, List<MapEntry<String, ShortcutBinding>>> groupedByContext() {
    final grouped = <String, List<MapEntry<String, ShortcutBinding>>>{};
    for (final entry in _shortcuts.entries) {
      grouped.putIfAbsent(entry.value.context, () => []).add(entry);
    }
    return grouped;
  }

  ShortcutBinding? _parseLabel(String label, String description, String context) {
    final ctrl = label.contains('Ctrl+');
    final shift = label.contains('Shift+');
    final alt = label.contains('Alt+');

    // Extract the key part
    final keyPart = label.replaceAll('Ctrl+', '').replaceAll('Shift+', '').replaceAll('Alt+', '');

    final keyMap = <String, LogicalKeyboardKey>{
      'F1': LogicalKeyboardKey.f1,
      'F2': LogicalKeyboardKey.f2,
      'F3': LogicalKeyboardKey.f3,
      'F4': LogicalKeyboardKey.f4,
      'F5': LogicalKeyboardKey.f5,
      'F6': LogicalKeyboardKey.f6,
      'F7': LogicalKeyboardKey.f7,
      'F8': LogicalKeyboardKey.f8,
      'F9': LogicalKeyboardKey.f9,
      'F10': LogicalKeyboardKey.f10,
      'F11': LogicalKeyboardKey.f11,
      'F12': LogicalKeyboardKey.f12,
      '/': LogicalKeyboardKey.slash,
      'Esc': LogicalKeyboardKey.escape,
      'Enter': LogicalKeyboardKey.enter,
      '1': LogicalKeyboardKey.digit1,
      '2': LogicalKeyboardKey.digit2,
      '3': LogicalKeyboardKey.digit3,
      '4': LogicalKeyboardKey.digit4,
      '5': LogicalKeyboardKey.digit5,
      '6': LogicalKeyboardKey.digit6,
      '7': LogicalKeyboardKey.digit7,
      '8': LogicalKeyboardKey.digit8,
      '9': LogicalKeyboardKey.digit9,
      'A': LogicalKeyboardKey.keyA,
      'B': LogicalKeyboardKey.keyB,
      'C': LogicalKeyboardKey.keyC,
      'D': LogicalKeyboardKey.keyD,
      'E': LogicalKeyboardKey.keyE,
      'F': LogicalKeyboardKey.keyF,
      'G': LogicalKeyboardKey.keyG,
      'H': LogicalKeyboardKey.keyH,
      'I': LogicalKeyboardKey.keyI,
      'J': LogicalKeyboardKey.keyJ,
      'K': LogicalKeyboardKey.keyK,
      'L': LogicalKeyboardKey.keyL,
      'M': LogicalKeyboardKey.keyM,
      'N': LogicalKeyboardKey.keyN,
      'O': LogicalKeyboardKey.keyO,
      'P': LogicalKeyboardKey.keyP,
      'Q': LogicalKeyboardKey.keyQ,
      'R': LogicalKeyboardKey.keyR,
      'S': LogicalKeyboardKey.keyS,
      'T': LogicalKeyboardKey.keyT,
      'U': LogicalKeyboardKey.keyU,
      'V': LogicalKeyboardKey.keyV,
      'W': LogicalKeyboardKey.keyW,
      'X': LogicalKeyboardKey.keyX,
      'Y': LogicalKeyboardKey.keyY,
      'Z': LogicalKeyboardKey.keyZ,
    };

    final logicalKey = keyMap[keyPart];
    if (logicalKey == null) return null;

    return ShortcutBinding(label, logicalKey, description, context, ctrl: ctrl, shift: shift, alt: alt);
  }
}

final keyboardShortcutServiceProvider = Provider<KeyboardShortcutService>((ref) {
  return KeyboardShortcutService();
});
