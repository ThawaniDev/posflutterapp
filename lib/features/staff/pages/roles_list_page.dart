import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/staff/models/role.dart';
import 'package:thawani_pos/features/staff/providers/roles_providers.dart';
import 'package:thawani_pos/features/staff/providers/roles_state.dart';

class RolesListPage extends ConsumerStatefulWidget {
  const RolesListPage({super.key});

  @override
  ConsumerState<RolesListPage> createState() => _RolesListPageState();
}

class _RolesListPageState extends ConsumerState<RolesListPage> {
  @override
  void initState() {
    super.initState();
    // Load roles on page init
    Future.microtask(() => ref.read(rolesProvider.notifier).load());
  }

  Future<void> _handleDelete(Role role) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Role'),
        content: Text(
          'Are you sure you want to delete "${role.displayName}"?\n'
          'This cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(rolesProvider.notifier).deleteRole(role.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Role "${role.displayName}" deleted.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rolesState = ref.watch(rolesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roles & Permissions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(rolesProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Role', icon: Icons.add, onPressed: () => context.push(Routes.staffRoleCreate)),
      body: _buildBody(rolesState),
    );
  }

  Widget _buildBody(RolesState state) {
    if (state is RolesLoading || state is RolesInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is RolesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: AppSpacing.md),
            Text(state.message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: 'Retry',
              onPressed: () => ref.read(rolesProvider.notifier).load(),
              variant: PosButtonVariant.outline,
            ),
          ],
        ),
      );
    }

    if (state is RolesLoaded) {
      if (state.roles.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.admin_panel_settings_outlined, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
              const SizedBox(height: AppSpacing.md),
              Text('No roles configured yet', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Create roles to manage staff permissions.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () => ref.read(rolesProvider.notifier).load(),
        child: ListView.separated(
          padding: const EdgeInsets.all(AppSpacing.lg),
          itemCount: state.roles.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _RoleCard(
            role: state.roles[index],
            onTap: () => context.push('${Routes.staffRoleDetail}/${state.roles[index].id}'),
            onDelete: state.roles[index].isPredefined == true ? null : () => _handleDelete(state.roles[index]),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// Card widget for a single role in the list
class _RoleCard extends StatelessWidget {
  final Role role;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _RoleCard({required this.role, required this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isPredefined = role.isPredefined == true;
    final permCount = role.permissions?.length ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isPredefined ? AppColors.primary10 : AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPredefined ? Icons.verified_user : Icons.admin_panel_settings,
                  color: isPredefined ? AppColors.primary : AppColors.info,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            role.displayName,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isPredefined) ...[
                          const SizedBox(width: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.primary10, borderRadius: BorderRadius.circular(4)),
                            child: Text(
                              'System',
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      role.description ?? role.name,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$permCount permission${permCount == 1 ? '' : 's'}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textMutedLight),
                    ),
                  ],
                ),
              ),

              // Actions
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  tooltip: 'Delete role',
                  onPressed: onDelete,
                ),
              Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}
