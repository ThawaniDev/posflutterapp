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
}

class PrefsError extends AccessibilityPrefsState {
  const PrefsError(this.message);
  final String message;
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
  const ShortcutsLoaded({required this.shortcuts});
  final Map<String, dynamic> shortcuts;
}

class ShortcutsError extends ShortcutsState {
  const ShortcutsError(this.message);
  final String message;
}

// ─── Accessibility Operation State ────────────────────
sealed class AccessibilityOperationState {
  const AccessibilityOperationState();
}

class AccessibilityOpIdle extends AccessibilityOperationState {
  const AccessibilityOpIdle();
}

class AccessibilityOpRunning extends AccessibilityOperationState {
  const AccessibilityOpRunning(this.operation);
  final String operation;
}

class AccessibilityOpSuccess extends AccessibilityOperationState {
  const AccessibilityOpSuccess(this.message);
  final String message;
}

class AccessibilityOpError extends AccessibilityOperationState {
  const AccessibilityOpError(this.message);
  final String message;
}
