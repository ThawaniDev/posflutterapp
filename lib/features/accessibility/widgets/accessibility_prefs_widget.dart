import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_providers.dart';
import 'package:wameedpos/features/accessibility/providers/accessibility_state.dart';

class AccessibilityPrefsWidget extends ConsumerWidget {
  const AccessibilityPrefsWidget({super.key});

  void _updatePref(WidgetRef ref, Map<String, dynamic> data) {
    ref.read(accessibilityPrefsProvider.notifier).update(data);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessibilityPrefsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      PrefsInitial() => Center(child: Text(l10n.accessibilityPreferences)),
      PrefsLoading() => const PosLoading(),
      PrefsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      final PrefsLoaded s => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // ─── Live Preview ─────────────
          _LivePreviewCard(prefs: s),
          AppSpacing.gapH16,
          // ─── Visual Settings ─────────────
          PosCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.accessibilityVisual, style: theme.textTheme.titleMedium),
                ),
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: Text(l10n.accessibilityFontSize),
                  trailing: Text('${(s.fontScale * 100).round()}%'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Slider(
                    value: s.fontScale,
                    min: 0.8,
                    max: 1.5,
                    divisions: 14,
                    label: '${(s.fontScale * 100).round()}%',
                    onChanged: (val) {
                      _updatePref(ref, {'font_scale': val});
                    },
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.contrast),
                  title: Text(l10n.accessibilityHighContrast),
                  subtitle: Text(l10n.accessibilityHighContrastDesc),
                  value: s.highContrast,
                  onChanged: (val) {
                    _updatePref(ref, {'high_contrast': val});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: Text(l10n.accessibilityColorBlind),
                  trailing: SizedBox(
                    width: 160,
                    child: PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'none', label: l10n.notificationsDigestNone),
                        PosDropdownItem(value: 'protanopia', label: l10n.accessProtanopia),
                        PosDropdownItem(value: 'deuteranopia', label: l10n.accessDeuteranopia),
                        PosDropdownItem(value: 'tritanopia', label: l10n.accessTritanopia),
                      ],
                      selectedValue: s.colorBlindMode,
                      onChanged: (val) {
                        if (val != null) _updatePref(ref, {'color_blind_mode': val});
                      },
                      showSearch: false,
                      clearable: false,
                    ),
                  ),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.animation),
                  title: Text(l10n.accessibilityReducedMotion),
                  subtitle: Text(l10n.accessibilityReducedMotionDesc),
                  value: s.reducedMotion,
                  onChanged: (val) {
                    _updatePref(ref, {'reduced_motion': val});
                  },
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          // ─── Audio & Interaction Settings ─────────────
          PosCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.accessibilityAudio, style: theme.textTheme.titleMedium),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up),
                  title: Text(l10n.accessibilityAudioFeedback),
                  subtitle: Text('${l10n.accessibilityVolume}: ${(s.audioVolume * 100).round()}%'),
                  value: s.audioFeedback,
                  onChanged: (val) {
                    _updatePref(ref, {'audio_feedback': val});
                  },
                ),
                if (s.audioFeedback)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Slider(
                      value: s.audioVolume,
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(s.audioVolume * 100).round()}%',
                      onChanged: (val) {
                        _updatePref(ref, {'audio_volume': val});
                      },
                    ),
                  ),
                SwitchListTile(
                  secondary: const Icon(Icons.touch_app),
                  title: Text(l10n.accessibilityLargeTouchTargets),
                  subtitle: Text(l10n.accessibilityLargeTouchTargetsDesc),
                  value: s.largeTouchTargets,
                  onChanged: (val) {
                    _updatePref(ref, {'large_touch_targets': val});
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.center_focus_strong),
                  title: Text(l10n.accessibilityVisibleFocus),
                  subtitle: Text(l10n.accessibilityVisibleFocusDesc),
                  value: s.visibleFocus,
                  onChanged: (val) {
                    _updatePref(ref, {'visible_focus': val});
                  },
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.record_voice_over),
                  title: Text(l10n.accessibilityScreenReader),
                  subtitle: Text(l10n.accessibilityScreenReaderDesc),
                  value: s.screenReaderHints,
                  onChanged: (val) {
                    _updatePref(ref, {'screen_reader_hints': val});
                  },
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          // ─── Reset Button ─────────────
          SizedBox(
            width: double.infinity,
            child: PosButton(
              icon: Icons.restore,
              label: l10n.accessibilityReset,
              variant: PosButtonVariant.outline,
              onPressed: () {
                ref.read(accessibilityPrefsProvider.notifier).reset();
              },
            ),
          ),
        ],
      ),
    };
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Live Preview Card — shows a realistic POS receipt card using current settings
// ─────────────────────────────────────────────────────────────────────────────
class _LivePreviewCard extends StatelessWidget {
  const _LivePreviewCard({required this.prefs});
  final PrefsLoaded prefs;

  /// Returns an adjusted color palette for the active color-blind mode.
  Map<String, Color> _palette(String mode) {
    switch (mode) {
      case 'protanopia': // Red-green: remove red channel distinction
        return {
          'primary': const Color(0xFF0070C0),
          'success': const Color(0xFF0070C0),
          'warning': const Color(0xFFF59E0B),
          'error': const Color(0xFF1F77B4),
        };
      case 'deuteranopia': // Red-green: green deficiency
        return {
          'primary': const Color(0xFF0070C0),
          'success': const Color(0xFF009AC7),
          'warning': const Color(0xFFDAA520),
          'error': const Color(0xFFD66E00),
        };
      case 'tritanopia': // Blue-yellow deficiency
        return {
          'primary': const Color(0xFFCC0000),
          'success': const Color(0xFF009900),
          'warning': const Color(0xFFCC0066),
          'error': const Color(0xFFCC0000),
        };
      default:
        return {
          'primary': AppColors.primary,
          'success': AppColors.success,
          'warning': AppColors.warning,
          'error': AppColors.error,
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final palette = _palette(prefs.colorBlindMode);
    final primaryColor = prefs.highContrast ? Colors.black : palette['primary']!;
    final successColor = prefs.highContrast ? Colors.black : palette['success']!;
    final bgColor = prefs.highContrast
        ? (isDark ? Colors.black : Colors.white)
        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));
    final borderColor = prefs.highContrast
        ? (isDark ? Colors.white : Colors.black)
        : AppColors.primary.withValues(alpha: 0.3);
    final textColor = prefs.highContrast
        ? (isDark ? Colors.white : Colors.black)
        : (isDark ? Colors.white : const Color(0xFF1E293B));
    final mutedColor = prefs.highContrast
        ? (isDark ? Colors.white70 : Colors.black54)
        : AppColors.mutedFor(context);

    final sampleScale = prefs.fontScale;

    return PosCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Row(
              children: [
                Icon(Icons.preview_outlined, size: 18, color: primaryColor),
                AppSpacing.gapW8,
                Text(
                  l10n.accessibilityPreview,
                  style: AppTypography.titleSmall.copyWith(color: primaryColor),
                ),
                const Spacer(),
                if (prefs.highContrast)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: AppRadius.borderFull,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: Text(
                      l10n.accessibilityHighContrast,
                      style: AppTypography.labelSmall.copyWith(color: Colors.white, fontSize: 10),
                    ),
                  ),
                if (prefs.colorBlindMode != 'none') ...[
                  if (prefs.highContrast) AppSpacing.gapW8,
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: palette['primary']!.withValues(alpha: 0.15),
                      borderRadius: AppRadius.borderFull,
                    ),
                    child: Text(
                      prefs.colorBlindMode,
                      style: AppTypography.labelSmall.copyWith(
                        color: palette['primary']!,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Sample receipt content
          Container(
            color: bgColor,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Sample sale row
                _PreviewRow(
                  label: '${l10n.item} #001',
                  value: '\uFDFC 0.000',
                  labelColor: textColor,
                  valueColor: successColor,
                  fontScale: sampleScale,
                  largeTouchTargets: prefs.largeTouchTargets,
                  visibleFocus: prefs.visibleFocus,
                  primaryColor: primaryColor,
                  borderColor: borderColor,
                ),
                Divider(height: 16, color: borderColor),
                _PreviewRow(
                  label: l10n.accessibilityFontSize,
                  value: '${(prefs.fontScale * 100).round()}%',
                  labelColor: mutedColor,
                  valueColor: textColor,
                  fontScale: sampleScale,
                  largeTouchTargets: prefs.largeTouchTargets,
                  visibleFocus: prefs.visibleFocus,
                  primaryColor: primaryColor,
                  borderColor: borderColor,
                ),

                // Color palette row
                AppSpacing.gapH12,
                Row(
                  children: [
                    _ColorSwatch(color: palette['primary']!, label: 'P'),
                    AppSpacing.gapW8,
                    _ColorSwatch(color: palette['success']!, label: 'S'),
                    AppSpacing.gapW8,
                    _ColorSwatch(color: palette['warning']!, label: 'W'),
                    AppSpacing.gapW8,
                    _ColorSwatch(color: palette['error']!, label: 'E'),
                    const Spacer(),
                    // Motion indicator
                    AnimatedOpacity(
                      opacity: prefs.reducedMotion ? 0.4 : 1.0,
                      duration: prefs.reducedMotion
                          ? Duration.zero
                          : const Duration(milliseconds: 400),
                      child: Row(
                        children: [
                          Icon(
                            prefs.reducedMotion
                                ? Icons.motion_photos_off
                                : Icons.motion_photos_on,
                            size: 16,
                            color: mutedColor,
                          ),
                          AppSpacing.gapW4,
                          Text(
                            prefs.reducedMotion
                                ? l10n.accessibilityReducedMotion
                                : l10n.accessibilityReducedMotionDesc,
                            style: AppTypography.labelSmall.copyWith(
                              color: mutedColor,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.fontScale,
    required this.largeTouchTargets,
    required this.visibleFocus,
    required this.primaryColor,
    required this.borderColor,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final double fontScale;
  final bool largeTouchTargets;
  final bool visibleFocus;
  final Color primaryColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final minH = largeTouchTargets ? 48.0 : 32.0;
    return Container(
      constraints: BoxConstraints(minHeight: minH),
      decoration: visibleFocus
          ? BoxDecoration(
              borderRadius: AppRadius.borderMd,
              border: Border.all(color: borderColor.withValues(alpha: 0.0)),
            )
          : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyMedium.copyWith(
              color: labelColor,
              fontSize: 14 * fontScale,
            ),
          ),
          Text(
            value,
            style: AppTypography.titleSmall.copyWith(
              color: valueColor,
              fontSize: 14 * fontScale,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
