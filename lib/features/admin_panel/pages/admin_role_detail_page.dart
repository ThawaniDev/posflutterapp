import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminRoleDetailPage extends ConsumerStatefulWidget {
  final String roleId;
  const AdminRoleDetailPage({super.key, required this.roleId});

  @override
  ConsumerState<AdminRoleDetailPage> createState() => _AdminRoleDetailPageState();
}

class _AdminRoleDetailPageState extends ConsumerState<AdminRoleDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminRoleDetailProvider.notifier).load(widget.roleId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRoleDetailProvider);
    final theme = Theme.of(context);
    final isLoading = state is AdminRoleDetailInitial || state is AdminRoleDetailLoading;

    return PosFormPage(
      title: l10n.staffRoleDetails,
      isLoading: isLoading,
      child: switch (state) {
        AdminRoleDetailError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg, style: theme.textTheme.bodyLarge),
              AppSpacing.gapH16,
              PosButton(label: l10n.retry, onPressed: () => ref.read(adminRoleDetailProvider.notifier).load(widget.roleId)),
            ],
          ),
        ),
        AdminRoleDetailLoaded(role: final role) => _buildRoleDetail(role, theme),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildRoleDetail(Map<String, dynamic> role, ThemeData theme) {
    final isSystem = role['is_system'] == true;
    final permissions = role['permissions'] as List<dynamic>? ?? <dynamic>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ───────────────────────────────────
        PosCard(
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
                        label: Text(l10n.adminSystemRole),
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        labelStyle: TextStyle(color: AppColors.primary),
                      ),
                  ],
                ),
                if (role['slug'] != null) ...[
                  AppSpacing.gapH4,
                  Text(
                    role['slug'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context), fontFamily: 'monospace'),
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
          PosCard(
            child: Padding(padding: EdgeInsets.all(16), child: Text(l10n.noPermissionsAssigned)),
          )
        else
          ...permissions.map((p) {
            final perm = p as Map<String, dynamic>;
            return PosCard(
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
                  label: l10n.adminDeleteRole,
                  variant: PosButtonVariant.danger,
                  onPressed: () => _confirmDelete(role['id'] as String),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _confirmDelete(String roleId) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.adminDeleteRole,
      message: l10n.adminDeleteRoleConfirm,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(roleActionProvider.notifier).deleteRole(roleId);
      Navigator.pop(context);
    }
  }
}
