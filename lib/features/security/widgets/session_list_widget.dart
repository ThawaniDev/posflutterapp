import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/security/models/security_session.dart';

class SessionListWidget extends StatelessWidget {

  const SessionListWidget({
    super.key,
    required this.sessions,
    this.onEndSession,
    this.onEndAllSessions,
    this.isActionLoading = false,
  });
  final List<SecuritySession> sessions;
  final ValueChanged<String>? onEndSession;
  final VoidCallback? onEndAllSessions;
  final bool isActionLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (sessions.isEmpty) {
      return PosEmptyState(title: l10n.securityNoSessions, icon: Icons.computer);
    }

    final activeSessions = sessions.where((s) => s.isActive).toList();
    final endedSessions = sessions.where((s) => !s.isActive).toList();

    return Column(
      children: [
        if (activeSessions.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: PosButton(
                icon: Icons.close_fullscreen,
                label: l10n.securityEndAllSessions,
                variant: PosButtonVariant.danger,
                size: PosButtonSize.sm,
                onPressed: isActionLoading ? null : onEndAllSessions,
              ),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = index < activeSessions.length
                  ? activeSessions[index]
                  : endedSessions[index - activeSessions.length];
              return _buildSessionCard(context, session);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(BuildContext context, SecuritySession session) {
    final l10n = AppLocalizations.of(context)!;
    final isActive = session.isActive;
    final mutedColor = AppColors.mutedFor(context);
    final statusColor = isActive ? AppColors.success : mutedColor;
    final statusLabel = isActive ? l10n.securityActive : l10n.securityEnded;

    return PosCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isActive ? Icons.computer : Icons.desktop_access_disabled, color: statusColor, size: 20),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(session.ipAddress ?? l10n.securityNA, style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
                PosStatusBadge(
                  label: statusLabel,
                  variant: isActive ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.neutral,
                ),
              ],
            ),
            AppSpacing.gapH4,
            if (session.userAgent != null)
              Text(
                session.userAgent!,
                style: TextStyle(fontSize: 12, color: mutedColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            AppSpacing.gapH4,
            Row(
              children: [
                Icon(Icons.access_time, size: 14, color: mutedColor),
                AppSpacing.gapW4,
                Text(
                  session.startedAt != null ? '${l10n.securityStarted}: ${_formatDateTime(session.startedAt!)}' : '',
                  style: TextStyle(fontSize: 12, color: mutedColor),
                ),
              ],
            ),
            if (session.lastActivityAt != null)
              Text(
                '${l10n.securityLastActivity}: ${_formatDateTime(session.lastActivityAt!)}',
                style: TextStyle(fontSize: 12, color: mutedColor),
              ),
            if (session.endedAt != null)
              Text(
                '${l10n.securityEnded}: ${_formatDateTime(session.endedAt!)}',
                style: TextStyle(fontSize: 12, color: mutedColor),
              ),
            if (isActive) ...[
              AppSpacing.gapH8,
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: PosButton(
                  icon: Icons.stop_circle_outlined,
                  label: l10n.securityEndSession,
                  variant: PosButtonVariant.danger,
                  size: PosButtonSize.sm,
                  onPressed: isActionLoading ? null : () => onEndSession?.call(session.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
