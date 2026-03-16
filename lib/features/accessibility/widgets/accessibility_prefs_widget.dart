import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_providers.dart';
import 'package:thawani_pos/features/accessibility/providers/accessibility_state.dart';

class AccessibilityPrefsWidget extends ConsumerWidget {
  const AccessibilityPrefsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessibilityPrefsProvider);
    final theme = Theme.of(context);

    return switch (state) {
      PrefsInitial() => const Center(child: Text('Loading preferences...')),
      PrefsLoading() => const Center(child: CircularProgressIndicator()),
      PrefsError(:final message) => Center(
        child: Text(message, style: TextStyle(color: theme.colorScheme.error)),
      ),
      final PrefsLoaded s => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.text_fields),
                  title: const Text('Font Scale'),
                  trailing: Text('${(s.fontScale * 100).round()}%'),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.contrast),
                  title: const Text('High Contrast'),
                  value: s.highContrast,
                  onChanged: (_) {},
                ),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Color Blind Mode'),
                  trailing: Text(s.colorBlindMode),
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.animation),
                  title: const Text('Reduced Motion'),
                  value: s.reducedMotion,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
          AppSpacing.gapH16,
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.volume_up),
                  title: const Text('Audio Feedback'),
                  subtitle: Text('Volume: ${(s.audioVolume * 100).round()}%'),
                  value: s.audioFeedback,
                  onChanged: (_) {},
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.touch_app),
                  title: const Text('Large Touch Targets'),
                  value: s.largeTouchTargets,
                  onChanged: (_) {},
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.center_focus_strong),
                  title: const Text('Visible Focus'),
                  value: s.visibleFocus,
                  onChanged: (_) {},
                ),
                SwitchListTile(
                  secondary: const Icon(Icons.record_voice_over),
                  title: const Text('Screen Reader Hints'),
                  value: s.screenReaderHints,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ],
      ),
    };
  }
}
