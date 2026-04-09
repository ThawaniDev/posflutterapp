import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_providers.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_state.dart';

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
      PrefsLoading() => const Center(child: CircularProgressIndicator()),
      PrefsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      final PrefsLoaded s => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // ─── Visual Settings ─────────────
          Card(
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
                      items: const [
                        PosDropdownItem(value: 'none', label: 'None'),
                        PosDropdownItem(value: 'protanopia', label: 'Protanopia'),
                        PosDropdownItem(value: 'deuteranopia', label: 'Deuteranopia'),
                        PosDropdownItem(value: 'tritanopia', label: 'Tritanopia'),
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
          Card(
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
            child: OutlinedButton.icon(
              icon: const Icon(Icons.restore),
              label: Text(l10n.accessibilityReset),
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
