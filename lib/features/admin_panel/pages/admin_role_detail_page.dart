import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminRoleDetailPage extends ConsumerStatefulWidget {
  final String roleId;
  const AdminRoleDetailPage({super.key, required this.roleId});

  @override
  ConsumerState<AdminRoleDetailPage> createState() => _AdminRoleDetailPageState();
}

class _AdminRoleDetailPageState extends ConsumerState<AdminRoleDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminRoleDetailProvider.notifier).load(widget.roleId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRoleDetailProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Role Details')),
      body: switch (state) {
        AdminRoleDetailInitial() || AdminRoleDetailLoading() => const Center(child: CircularProgressIndicator()),
        AdminRoleDetailError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg, style: theme.textTheme.bodyLarge),
              AppSpacing.gapH16,
              PosButton(label: 'Retry', onPressed: () => ref.read(adminRoleDetailProvider.notifier).load(widget.roleId)),
            ],
          ),
        ),
        AdminRoleDetailLoaded(role: final role) => _buildRoleDetail(role, theme),
      },
    );
  }

  Widget _buildRoleDetail(Map<String, dynamic> role, ThemeData theme) {
    final isSystem = role['is_system'] == true;
    final permissions = role['permissions'] as List<dynamic>? ?? <dynamic>[];

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───────────────────────────────────
          Card(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(role['name'] as String? ?? '', style: theme.textTheme.headlineSmall)),
                      if (isSystem)
                        Chip(
                          label: const Text('System Role'),
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          labelStyle: TextStyle(color: AppColors.primary),
                        ),
                    ],
                  ),
                  if (role['slug'] != null) ...[
                    AppSpacing.gapH4,
                    Text(
                      role['slug'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary, fontFamily: 'monospace'),
                    ),
                  ],
                  if (role['description'] != null) ...[AppSpacing.gapH8, Text(role['description'] as String)],
                  AppSpacing.gapH8,
                  Text('${role['users_count'] ?? 0} users assigned', style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // ─── Permissions ──────────────────────────────
          Text('Permissions (${permissions.length})', style: theme.textTheme.titleMedium),
          AppSpacing.gapH8,
          if (permissions.isEmpty)
            const Card(
              child: Padding(padding: EdgeInsets.all(16), child: Text('No permissions assigned')),
            )
          else
            ...permissions.map((p) {
              final perm = p as Map<String, dynamic>;
              return Card(
                child: ListTile(
                  dense: true,
                  leading: const Icon(Icons.check_circle_outline, size: 20),
                  title: Text(perm['name'] as String? ?? ''),
                  subtitle: Text(perm['group'] as String? ?? ''),
                ),
              );
            }),

          // ─── Actions ──────────────────────────────────
          if (!isSystem) ...[
            AppSpacing.gapH24,
            Row(
              children: [
                Expanded(
                  child: PosButton(
                    label: 'Delete Role',
                    variant: PosButtonVariant.danger,
                    onPressed: () => _confirmDelete(role['id'] as String),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _confirmDelete(String roleId) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Delete Role',
      message: 'Are you sure you want to delete this role? This cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(roleActionProvider.notifier).deleteRole(roleId);
      Navigator.pop(context);
    }
  }
}
