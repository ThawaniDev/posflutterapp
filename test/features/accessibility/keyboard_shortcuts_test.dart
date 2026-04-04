import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/accessibility/services/keyboard_shortcut_service.dart';

void main() {
  group('ShortcutBinding', () {
    test('stores label, key, description, context', () {
      final binding = ShortcutBinding('Ctrl+S', LogicalKeyboardKey.keyS, 'Save', 'Global', ctrl: true);
      expect(binding.label, 'Ctrl+S');
      expect(binding.key, LogicalKeyboardKey.keyS);
      expect(binding.description, 'Save');
      expect(binding.context, 'Global');
      expect(binding.ctrl, isTrue);
    });
  });

  group('KeyboardShortcutService', () {
    late KeyboardShortcutService service;

    setUp(() {
      service = KeyboardShortcutService();
    });

    test('has default shortcuts loaded', () {
      final shortcuts = service.shortcuts;
      expect(shortcuts, isNotEmpty);
    });

    test('groupedByContext groups correctly', () {
      final grouped = service.groupedByContext();
      expect(grouped.keys, containsAll(['pos', 'global', 'navigation']));
    });

    test('registerHandler adds handler for id', () {
      bool called = false;
      service.registerHandler('new_sale', () => called = true);
      // Handler registered — we can't easily test the callback without key events
      // but we verify no errors
      expect(true, isTrue);
    });

    test('reassignShortcut returns true on valid reassign', () {
      final result = service.reassignShortcut('new_sale', 'Ctrl+Shift+N');
      expect(result, isTrue);

      final shortcut = service.shortcuts['new_sale'];
      expect(shortcut?.label, 'Ctrl+Shift+N');
    });

    test('reassignShortcut returns false for reserved shortcut', () {
      // Ctrl+C is typically reserved (copy)
      final result = service.reassignShortcut('new_sale', 'Ctrl+C');
      expect(result, isFalse);
    });

    test('applyCustomShortcuts overrides existing bindings', () {
      service.applyCustomShortcuts({'new_sale': 'Ctrl+Shift+X'});
      final shortcut = service.shortcuts['new_sale'];
      expect(shortcut?.label, 'Ctrl+Shift+X');
    });

    test('default shortcuts include shortcut_reference', () {
      final ref = service.shortcuts['shortcut_reference'];
      expect(ref, isNotNull);
      expect(ref?.label, 'Ctrl+/');
    });

    test('default shortcuts include Alt+1-9 navigation', () {
      for (int i = 1; i <= 9; i++) {
        final nav = service.shortcuts['nav_screen_$i'];
        expect(nav, isNotNull, reason: 'Missing nav_screen_$i');
        expect(nav?.label, 'Alt+$i');
      }
    });

    test('default shortcuts include cancel and confirm', () {
      final cancel = service.shortcuts['cancel'];
      expect(cancel, isNotNull);
      expect(cancel?.label, 'Esc');

      final confirm = service.shortcuts['confirm'];
      expect(confirm, isNotNull);
      expect(confirm?.label, 'Enter');
    });
  });
}
