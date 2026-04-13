import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

class SecurityOverviewWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const SecurityOverviewWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final activeDevices = data['active_devices'] ?? 0;
    final activeSessions = data['active_sessions'] ?? 0;
    final unresolvedIncidents = data['unresolved_incidents'] ?? 0;
    final failedLoginsToday = data['failed_logins_today'] ?? 0;
    final totalAuditLogs = data['total_audit_logs'] ?? 0;
    final lockedOutUsers = data['locked_out_users'] ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI grid
          PosKpiGrid(
            desktopCols: 3,
            tabletCols: 3,
            mobileCols: 2,
            cards: [
              PosKpiCard(
                label: l10n.securityActiveDevices,
                value: '$activeDevices',
                icon: Icons.devices,
                iconColor: AppColors.info,
              ),
              PosKpiCard(
                label: l10n.securityActiveSessions,
                value: '$activeSessions',
                icon: Icons.computer,
                iconColor: AppColors.success,
              ),
              PosKpiCard(
                label: l10n.securityUnresolvedIncidents,
                value: '$unresolvedIncidents',
                icon: Icons.warning_amber,
                iconColor: unresolvedIncidents > 0 ? AppColors.error : AppColors.success,
              ),
              PosKpiCard(
                label: l10n.securityFailedLoginsToday,
                value: '$failedLoginsToday',
                icon: Icons.lock,
                iconColor: failedLoginsToday > 5 ? AppColors.error : AppColors.warning,
              ),
              PosKpiCard(
                label: l10n.securityTotalAuditLogs,
                value: '$totalAuditLogs',
                icon: Icons.description,
                iconColor: AppColors.textSecondary,
              ),
              PosKpiCard(
                label: l10n.securityLockedOutUsers,
                value: '$lockedOutUsers',
                icon: Icons.person_off,
                iconColor: lockedOutUsers > 0 ? AppColors.error : AppColors.success,
              ),
            ],
          ),

          AppSpacing.gapH16,

          // Recent activity
          if (data['recent_activity'] is List) ...[
            Text(l10n.securityRecentActivity, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            AppSpacing.gapH8,
            ...(data['recent_activity'] as List).take(10).map((item) {
              final activity = item as Map<String, dynamic>;
              return ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(_activityIcon(activity['type'] as String?), size: 20, color: AppColors.textSecondary),
                title: Text(activity['description'] as String? ?? '', style: const TextStyle(fontSize: 13)),
                trailing: Text(
                  _formatTime(activity['created_at'] as String?),
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  IconData _activityIcon(String? type) {
    return switch (type) {
      'login' => Icons.login,
      'logout' => Icons.logout,
      'device_registered' => Icons.devices,
      'incident' => Icons.warning,
      'policy_change' => Icons.policy,
      _ => Icons.circle,
    };
  }

  String _formatTime(String? isoDate) {
    if (isoDate == null) return '';
    try {
      final dt = DateTime.parse(isoDate);
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (_) {
      return '';
    }
  }
}
