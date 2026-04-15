import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/security/models/security_audit_log.dart';

class AuditLogListWidget extends StatelessWidget {
  final List<SecurityAuditLog> logs;

  const AuditLogListWidget({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Center(child: Text('No audit logs found.'));
    }

    return ListView.separated(
      itemCount: logs.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _AuditLogTile(log: log);
      },
    );
  }
}

class _AuditLogTile extends StatelessWidget {
  final SecurityAuditLog log;

  const _AuditLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final severityColor = switch (log.severity?.value) {
      'critical' => AppColors.error,
      'warning' => AppColors.warning,
      _ => AppColors.info,
    };

    return ListTile(
      leading: CircleAvatar(
        radius: 16,
        backgroundColor: severityColor.withValues(alpha: 0.15),
        child: Icon(_actionIcon(log.action.value), size: 18, color: severityColor),
      ),
      title: Text(
        log.action.value.replaceAll('_', ' ').toUpperCase(),
        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (log.userType != null) Text('User: ${log.userType!.value}', style: theme.textTheme.bodySmall),
          if (log.ipAddress != null) Text('IP: ${log.ipAddress}', style: theme.textTheme.bodySmall),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: AppSpacing.paddingH8,
            decoration: BoxDecoration(color: severityColor.withValues(alpha: 0.1), borderRadius: AppRadius.borderSm),
            child: Text(log.severity?.value ?? 'info', style: theme.textTheme.labelSmall?.copyWith(color: severityColor)),
          ),
        ],
      ),
    );
  }

  IconData _actionIcon(String action) {
    return switch (action) {
      'login' => Icons.login,
      'logout' => Icons.logout,
      'failed_login' => Icons.warning,
      'pin_override' => Icons.pin,
      'settings_change' => Icons.settings,
      'remote_wipe' => Icons.delete_forever,
      _ => Icons.info_outline,
    };
  }
}
