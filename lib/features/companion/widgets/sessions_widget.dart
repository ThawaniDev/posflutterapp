import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';

/// Widget that displays active companion sessions with device info
/// and the ability to end sessions remotely.
class SessionsWidget extends ConsumerStatefulWidget {
  const SessionsWidget({super.key});

  @override
  ConsumerState<SessionsWidget> createState() => _SessionsWidgetState();
}

class _SessionsWidgetState extends ConsumerState<SessionsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(companionOperationProvider.notifier)
          .registerSession(deviceName: Platform.localHostname, deviceOs: Platform.operatingSystem, appVersion: '1.0.0');
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final operation = ref.watch(companionOperationProvider);

    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppSpacing.paddingAll16,
                child: Row(
                  children: [
                    const Icon(Icons.devices, size: 20),
                    AppSpacing.gapW8,
                    Text(l10n.companionSessions, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (operation is CompanionOperationRunning)
                const LinearProgressIndicator()
              else if (operation is CompanionOperationSuccess)
                _buildSessionInfo(context, operation.data)
              else if (operation is CompanionOperationError)
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(operation.message, style: TextStyle(color: theme.colorScheme.error)),
                )
              else
                Padding(
                  padding: AppSpacing.paddingAll16,
                  child: Text(l10n.companionNoActiveSessions, style: theme.textTheme.bodyMedium),
                ),
            ],
          ),
        ),
        AppSpacing.gapH16,
        // Connection guide card
        Card(
          color: AppColors.info.withValues(alpha: 0.08),
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                    AppSpacing.gapW8,
                    Text(l10n.companionConnectionGuide, style: theme.textTheme.titleSmall?.copyWith(color: AppColors.info)),
                  ],
                ),
                AppSpacing.gapH8,
                Text(l10n.companionConnectionGuideDesc, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSessionInfo(BuildContext context, Map<String, dynamic>? data) {
    if (data == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.check_circle, color: AppColors.success, size: 16),
              AppSpacing.gapW8,
              Text(l10n.companionSessionActive, style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.success)),
            ],
          ),
          if (data['session_id'] != null) ...[
            AppSpacing.gapH8,
            Text('${l10n.companionSessionId}: ${data['session_id']}', style: theme.textTheme.bodySmall),
          ],
          if (data['started_at'] != null) ...[
            AppSpacing.gapH4,
            Text('${l10n.companionSessionStarted}: ${data['started_at']}', style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}
