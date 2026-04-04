import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/notifications/models/notification_sound_config.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

class NotificationSoundConfigsPage extends ConsumerStatefulWidget {
  const NotificationSoundConfigsPage({super.key});

  @override
  ConsumerState<NotificationSoundConfigsPage> createState() => _NotificationSoundConfigsPageState();
}

class _NotificationSoundConfigsPageState extends ConsumerState<NotificationSoundConfigsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(soundConfigsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(soundConfigsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifSoundConfigsTitle),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () => ref.read(soundConfigsProvider.notifier).load())],
      ),
      body: switch (state) {
        SoundConfigsInitial() || SoundConfigsLoading() => Center(child: PosLoadingSkeleton.list()),
        SoundConfigsError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(soundConfigsProvider.notifier).load(),
        ),
        SoundConfigsLoaded(:final configs) =>
          configs.isEmpty
              ? PosEmptyState(title: l10n.notifSoundConfigsEmpty, icon: Icons.volume_off)
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: configs.length,
                  itemBuilder: (context, index) => _buildConfigCard(configs[index]),
                ),
      },
    );
  }

  Widget _buildConfigCard(NotificationSoundConfig config) {
    final isEnabled = config.isEnabled;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEnabled ? Icons.volume_up : Icons.volume_off,
                  color: isEnabled ? AppColors.primary : AppColors.textSecondary,
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_formatEventKey(config.eventKey), style: const TextStyle(fontWeight: FontWeight.w600)),
                      Text(config.soundFile, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: (v) {
                    ref
                        .read(soundConfigsProvider.notifier)
                        .updateConfig(eventKey: config.eventKey, isEnabled: v, volume: config.volume);
                  },
                ),
              ],
            ),
            if (isEnabled) ...[
              AppSpacing.gapH8,
              Row(
                children: [
                  const Icon(Icons.volume_down, size: 16, color: AppColors.textSecondary),
                  Expanded(
                    child: Slider(
                      value: config.volume.clamp(0.0, 1.0),
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: '${(config.volume * 100).round()}%',
                      onChanged: (v) {
                        ref
                            .read(soundConfigsProvider.notifier)
                            .updateConfig(eventKey: config.eventKey, isEnabled: isEnabled, volume: v);
                      },
                    ),
                  ),
                  const Icon(Icons.volume_up, size: 16, color: AppColors.textSecondary),
                  AppSpacing.gapW8,
                  SizedBox(
                    width: 40,
                    child: Text(
                      '${(config.volume * 100).round()}%',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatEventKey(String key) {
    return key.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }
}
