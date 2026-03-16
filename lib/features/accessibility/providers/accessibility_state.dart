// ─── Accessibility Preferences State ──────────────────
sealed class AccessibilityPrefsState {
  const AccessibilityPrefsState();
}

class PrefsInitial extends AccessibilityPrefsState {
  const PrefsInitial();
}

class PrefsLoading extends AccessibilityPrefsState {
  const PrefsLoading();
}

class PrefsLoaded extends AccessibilityPrefsState {
  final double fontScale;
  final bool highContrast;
  final String colorBlindMode;
  final bool reducedMotion;
  final bool audioFeedback;
  final double audioVolume;
  final bool largeTouchTargets;
  final bool visibleFocus;
  final bool screenReaderHints;
  final Map<String, dynamic> customShortcuts;
  final Map<String, dynamic> raw;

  const PrefsLoaded({
    required this.fontScale,
    required this.highContrast,
    required this.colorBlindMode,
    required this.reducedMotion,
    required this.audioFeedback,
    required this.audioVolume,
    required this.largeTouchTargets,
    required this.visibleFocus,
    required this.screenReaderHints,
    required this.customShortcuts,
    required this.raw,
  });
}

class PrefsError extends AccessibilityPrefsState {
  final String message;
  const PrefsError(this.message);
}

// ─── Shortcuts State ──────────────────────────────────
sealed class ShortcutsState {
  const ShortcutsState();
}

class ShortcutsInitial extends ShortcutsState {
  const ShortcutsInitial();
}

class ShortcutsLoading extends ShortcutsState {
  const ShortcutsLoading();
}

class ShortcutsLoaded extends ShortcutsState {
  final Map<String, dynamic> shortcuts;
  const ShortcutsLoaded({required this.shortcuts});
}

class ShortcutsError extends ShortcutsState {
  final String message;
  const ShortcutsError(this.message);
}

// ─── Accessibility Operation State ────────────────────
sealed class AccessibilityOperationState {
  const AccessibilityOperationState();
}

class AccessibilityOpIdle extends AccessibilityOperationState {
  const AccessibilityOpIdle();
}

class AccessibilityOpRunning extends AccessibilityOperationState {
  final String operation;
  const AccessibilityOpRunning(this.operation);
}

class AccessibilityOpSuccess extends AccessibilityOperationState {
  final String message;
  const AccessibilityOpSuccess(this.message);
}

class AccessibilityOpError extends AccessibilityOperationState {
  final String message;
  const AccessibilityOpError(this.message);
}
