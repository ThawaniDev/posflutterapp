import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';

/// Central accessibility state that applies font scaling, high contrast,
/// reduced motion, and other preferences to the app theme.
class AccessibilitySettings {

  const AccessibilitySettings({
    this.fontScale = 1.0,
    this.highContrast = false,
    this.colorBlindMode = 'none',
    this.reducedMotion = false,
    this.audioFeedback = true,
    this.audioVolume = 0.7,
    this.largeTouchTargets = false,
    this.visibleFocus = true,
    this.screenReaderHints = true,
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

  AccessibilitySettings copyWith({
    double? fontScale,
    bool? highContrast,
    String? colorBlindMode,
    bool? reducedMotion,
    bool? audioFeedback,
    double? audioVolume,
    bool? largeTouchTargets,
    bool? visibleFocus,
    bool? screenReaderHints,
  }) {
    return AccessibilitySettings(
      fontScale: fontScale ?? this.fontScale,
      highContrast: highContrast ?? this.highContrast,
      colorBlindMode: colorBlindMode ?? this.colorBlindMode,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      audioFeedback: audioFeedback ?? this.audioFeedback,
      audioVolume: audioVolume ?? this.audioVolume,
      largeTouchTargets: largeTouchTargets ?? this.largeTouchTargets,
      visibleFocus: visibleFocus ?? this.visibleFocus,
      screenReaderHints: screenReaderHints ?? this.screenReaderHints,
    );
  }

  /// Get the minimum interactive element size based on accessibility preferences.
  double get minInteractiveSize => largeTouchTargets ? 48.0 : 36.0;

  /// Get the animation duration — zero if reduced motion is enabled.
  Duration get animationDuration => reducedMotion ? Duration.zero : const Duration(milliseconds: 300);
}

/// Provider that exposes current accessibility settings derived from API state.
final accessibilitySettingsProvider = Provider<AccessibilitySettings>((ref) {
  final state = ref.watch(accessibilityPrefsProvider);
  if (state is PrefsLoaded) {
    return AccessibilitySettings(
      fontScale: state.fontScale,
      highContrast: state.highContrast,
      colorBlindMode: state.colorBlindMode,
      reducedMotion: state.reducedMotion,
      audioFeedback: state.audioFeedback,
      audioVolume: state.audioVolume,
      largeTouchTargets: state.largeTouchTargets,
      visibleFocus: state.visibleFocus,
      screenReaderHints: state.screenReaderHints,
    );
  }
  return const AccessibilitySettings();
});

/// Provider that computes a high-contrast theme when enabled.
final highContrastThemeProvider = Provider<ThemeData?>((ref) {
  final settings = ref.watch(accessibilitySettingsProvider);
  if (!settings.highContrast) return null;

  return ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Cairo',
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFFFFFFF),
      secondary: Color(0xFF1A1A1A),
      onSecondary: Color(0xFFFFFFFF),
      surface: Color(0xFFFFFFFF),
      onSurface: Color(0xFF000000),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF),
    cardColor: const Color(0xFFFFFFFF),
    dividerColor: const Color(0xFF000000),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF000000), fontSize: 16),
      bodyMedium: TextStyle(color: Color(0xFF000000), fontSize: 14),
      bodySmall: TextStyle(color: Color(0xFF1A1A1A), fontSize: 12),
      titleLarge: TextStyle(color: Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color(0xFF000000), fontSize: 14, fontWeight: FontWeight.w600),
    ),
    iconTheme: const IconThemeData(color: Color(0xFF000000)),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000), width: 2)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF000000), width: 3)),
    ),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Color(0xFFFFFFFF)),
        backgroundColor: WidgetStatePropertyAll(Color(0xFF000000)),
        side: WidgetStatePropertyAll(BorderSide(color: Color(0xFF000000), width: 2)),
      ),
    ),
    outlinedButtonTheme: const OutlinedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(Color(0xFF000000)),
        side: WidgetStatePropertyAll(BorderSide(color: Color(0xFF000000), width: 2)),
      ),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected) ? const Color(0xFF000000) : const Color(0xFF757575);
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        return states.contains(WidgetState.selected) ? const Color(0xFF424242) : const Color(0xFFBDBDBD);
      }),
    ),
    focusColor: const Color(0xFF000000).withValues(alpha: 0.3),
  );
});

/// Provider for font scale factor — applied via MediaQuery.
final fontScaleProvider = Provider<double>((ref) {
  return ref.watch(accessibilitySettingsProvider).fontScale;
});

/// Provider for reduced motion preference.
final reducedMotionProvider = Provider<bool>((ref) {
  return ref.watch(accessibilitySettingsProvider).reducedMotion;
});
