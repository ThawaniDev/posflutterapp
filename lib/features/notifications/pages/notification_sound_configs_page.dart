import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/models/notification_sound_config.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';

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

    return PosListPage(
  title: l10n.notifSoundConfigsTitle,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.refresh_rounded, onPressed: () => ref.read(soundConfigsProvider.notifier).load(),
  ),
],
  child: switch (state) {
        SoundConfigsInitial() || SoundConfigsLoading() => const Center(child: PosLoading()),
        SoundConfigsError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(soundConfigsProvider.notifier).load(),
        ),
        SoundConfigsLoaded(:final configs) =>
          configs.isEmpty
              ? PosEmptyState(title: l10n.notifSoundConfigsEmpty, icon: Icons.volume_off_rounded)
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                  itemCount: configs.length,
                  separatorBuilder: (_, __) => AppSpacing.gapH8,
                  itemBuilder: (context, index) => _buildConfigCard(configs[index]),
                ),
      },
);
  }

  Widget _buildConfigCard(NotificationSoundConfig config) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEnabled = config.isEnabled;

    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isEnabled
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                  borderRadius: AppRadius.borderMd,
                ),
                child: Icon(
                  isEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
                  size: AppSizes.iconMd,
                  color: isEnabled ? AppColors.primary : (AppColors.mutedFor(context)),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_formatEventKey(config.eventKey), style: AppTypography.titleMedium),
                    Text(
                      config.soundFile,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
                    ),
                  ],
                ),
              ),
              PosToggle(
                label: '',
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
            AppSpacing.gapH12,
            Row(
              children: [
                Icon(Icons.volume_down_rounded, size: 16, color: AppColors.mutedFor(context)),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppColors.primary,
                      inactiveTrackColor: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight,
                      thumbColor: AppColors.primary,
                      overlayColor: AppColors.primary.withValues(alpha: 0.12),
                    ),
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
                ),
                Icon(Icons.volume_up_rounded, size: 16, color: AppColors.mutedFor(context)),
                AppSpacing.gapW8,
                SizedBox(
                  width: 40,
                  child: Text(
                    '${(config.volume * 100).round()}%',
                    style: AppTypography.labelMedium.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatEventKey(String key) {
    return key.replaceAll('_', ' ').split(' ').map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '').join(' ');
  }
}
