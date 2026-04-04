import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages focus traversal and programmatic focus movement for keyboard users.
/// Tracks focus history and supports Alt+1-9 for screen navigation.
class FocusManagementService {
  final Map<String, FocusNode> _namedNodes = {};
  final List<String> _focusHistory = [];
  FocusScopeNode? _currentScope;

  /// Register a named focus node for quick access.
  FocusNode register(String name) {
    return _namedNodes.putIfAbsent(name, () => FocusNode(debugLabel: name));
  }

  /// Unregister and dispose a named focus node.
  void unregister(String name) {
    final node = _namedNodes.remove(name);
    node?.dispose();
    _focusHistory.remove(name);
  }

  /// Focus a named node.
  bool focusNamed(String name) {
    final node = _namedNodes[name];
    if (node != null && node.canRequestFocus) {
      node.requestFocus();
      _focusHistory.add(name);
      return true;
    }
    return false;
  }

  /// Go back to the previously focused node.
  bool focusPrevious() {
    if (_focusHistory.length < 2) return false;
    _focusHistory.removeLast();
    final previousName = _focusHistory.last;
    return focusNamed(previousName);
  }

  /// Move focus to the next node in the current scope.
  void focusNext(BuildContext context) {
    FocusScope.of(context).nextFocus();
  }

  /// Move focus to the previous node in the current scope.
  void focusPrev(BuildContext context) {
    FocusScope.of(context).previousFocus();
  }

  /// Move focus in a specific direction.
  void moveFocus(BuildContext context, TraversalDirection direction) {
    FocusScope.of(context).focusInDirection(direction);
  }

  /// Set the current focus scope for tracking.
  void setScope(FocusScopeNode scope) {
    _currentScope = scope;
  }

  /// Get all registered focus node names.
  List<String> get registeredNames => _namedNodes.keys.toList();

  /// Check if a named node currently has focus.
  bool hasFocus(String name) {
    return _namedNodes[name]?.hasFocus ?? false;
  }

  void dispose() {
    for (final node in _namedNodes.values) {
      node.dispose();
    }
    _namedNodes.clear();
    _focusHistory.clear();
  }
}

final focusManagementServiceProvider = Provider<FocusManagementService>((ref) {
  final service = FocusManagementService();
  ref.onDispose(() => service.dispose());
  return service;
});
