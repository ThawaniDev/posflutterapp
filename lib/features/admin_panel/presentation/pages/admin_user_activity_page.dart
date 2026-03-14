import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminUserActivityPage extends ConsumerStatefulWidget {
  final String userId;
  final bool isAdmin;
  const AdminUserActivityPage({super.key, required this.userId, this.isAdmin = false});

  @override
  ConsumerState<AdminUserActivityPage> createState() => _AdminUserActivityPageState();
}

class _AdminUserActivityPageState extends ConsumerState<AdminUserActivityPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final notifier = ref.read(userActivityProvider.notifier);
      if (widget.isAdmin) {
        notifier.loadAdminActivity(widget.userId);
      } else {
        notifier.loadProviderActivity(widget.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userActivityProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.isAdmin ? 'Admin Activity' : 'User Activity')),
      body: switch (state) {
        UserActivityLoading() => const Center(child: CircularProgressIndicator()),
        UserActivityError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: AppColors.error)),
        ),
        UserActivityLoaded(:final logs) =>
          logs.isEmpty
              ? const Center(child: Text('No activity logged'))
              : ListView.builder(
                  itemCount: logs.length,
                  padding: AppSpacing.paddingAll8,
                  itemBuilder: (context, index) => _buildLogEntry(logs[index]),
                ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildLogEntry(Map<String, dynamic> log) {
    final action = log['action']?.toString() ?? 'unknown';
    final entityType = log['entity_type']?.toString() ?? '';
    final ipAddress = log['ip_address']?.toString() ?? '';
    final createdAt = log['created_at']?.toString() ?? '';
    final details = log['details'] as Map<String, dynamic>? ?? {};

    IconData actionIcon;
    Color iconColor;
    switch (action) {
      case 'reset_password':
        actionIcon = Icons.lock_reset;
        iconColor = AppColors.warning;
      case 'force_password_change':
        actionIcon = Icons.password;
        iconColor = AppColors.warning;
      case 'user_disabled':
        actionIcon = Icons.block;
        iconColor = AppColors.error;
      case 'user_enabled':
        actionIcon = Icons.check_circle;
        iconColor = AppColors.success;
      case 'admin_invited':
        actionIcon = Icons.person_add;
        iconColor = AppColors.primary;
      case 'admin_2fa_reset':
        actionIcon = Icons.security;
        iconColor = AppColors.warning;
      case 'login':
        actionIcon = Icons.login;
        iconColor = AppColors.success;
      default:
        actionIcon = Icons.info_outline;
        iconColor = AppColors.textSecondary;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Icon(actionIcon, color: iconColor),
        title: Text(action.replaceAll('_', ' ').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entityType.isNotEmpty) Text('Entity: $entityType'),
            if (ipAddress.isNotEmpty) Text('IP: $ipAddress', style: const TextStyle(fontSize: 11)),
            if (details.isNotEmpty)
              Text(
                'Details: ${details.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
                style: const TextStyle(fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: Text(
          createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        isThreeLine: true,
      ),
    );
  }
}
