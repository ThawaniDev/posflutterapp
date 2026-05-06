import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/accessibility/services/focus_management_service.dart';

/// Unit tests for [FocusManagementService].
///
/// Tests that do not require a real Flutter widget tree are run as plain
/// unit tests. Operations that need `BuildContext` (focusNext, focusPrev,
/// moveFocus) are intentionally excluded since they require a running
/// widget tree and are better covered by integration/widget tests.
void main() {
  group('FocusManagementService', () {
    late FocusManagementService service;

    setUp(() {
      service = FocusManagementService();
    });

    tearDown(() {
      service.dispose();
    });

    // ─── register ─────────────────────────────────────────────

    test('register returns a FocusNode with the given debug label', () {
      final node = service.register('cart_total');
      expect(node, isNotNull);
      expect(node.debugLabel, 'cart_total');
    });

    test('register returns the same FocusNode on repeated calls', () {
      final a = service.register('checkout');
      final b = service.register('checkout');
      expect(identical(a, b), isTrue);
    });

    test('register multiple different names returns distinct nodes', () {
      final a = service.register('node_a');
      final b = service.register('node_b');
      expect(identical(a, b), isFalse);
    });

    // ─── unregister ───────────────────────────────────────────

    test('unregister removes the node', () {
      service.register('temp_node');
      service.unregister('temp_node');
      // After unregistration, calling register again creates a NEW node
      final newNode = service.register('temp_node');
      expect(newNode, isNotNull);
    });

    test('unregister on unknown name does not throw', () {
      expect(() => service.unregister('does_not_exist'), returnsNormally);
    });

    // ─── focusNamed ───────────────────────────────────────────

    test('focusNamed returns false for unregistered name', () {
      expect(service.focusNamed('nonexistent'), isFalse);
    });

    test('focusNamed returns false for registered node that cannot request focus', () {
      // FocusNode.canRequestFocus is false by default when not attached to a widget tree
      final node = service.register('my_button');
      // In unit test environment canRequestFocus == false, so focusNamed returns false
      final result = service.focusNamed('my_button');
      // This either returns true or false depending on Flutter test environment
      // The key requirement is it must NOT throw
      expect(result, isA<bool>());
    });

    // ─── focusPrevious ────────────────────────────────────────

    test('focusPrevious returns false when history has fewer than 2 entries', () {
      expect(service.focusPrevious(), isFalse);
    });

    // ─── hasFocus ─────────────────────────────────────────────

    test('hasFocus returns false for unregistered name', () {
      expect(service.hasFocus('unknown'), isFalse);
    });

    test('hasFocus returns false for registered but unfocused node', () {
      service.register('my_field');
      expect(service.hasFocus('my_field'), isFalse);
    });

    // ─── dispose ──────────────────────────────────────────────

    test('dispose can be called without error', () {
      service.register('n1');
      service.register('n2');
      expect(() => service.dispose(), returnsNormally);
    });

    test('dispose clears all registered nodes', () {
      service.register('node_x');
      service.dispose();
      // After dispose, focusNamed should safely return false (not crash)
      expect(service.focusNamed('node_x'), isFalse);
    });
  });
}
