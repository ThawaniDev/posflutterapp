import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminRoleListPage extends ConsumerStatefulWidget {
  const AdminRoleListPage({super.key});

  @override
  ConsumerState<AdminRoleListPage> createState() => _AdminRoleListPageState();
}

class _AdminRoleListPageState extends ConsumerState<AdminRoleListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminRoleListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRoleListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Roles'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Permissions',
            onPressed: () => context.push(Routes.adminPermissions),
          ),
          IconButton(icon: const Icon(Icons.add), tooltip: 'Create Role', onPressed: () => context.push(Routes.adminRoleCreate)),
        ],
      ),
      body: switch (state) {
        AdminRoleListInitial() || AdminRoleListLoading() => const Center(child: CircularProgressIndicator()),
        AdminRoleListError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg, style: theme.textTheme.bodyLarge),
              AppSpacing.gapH16,
              PosButton(label: 'Retry', onPressed: () => ref.read(adminRoleListProvider.notifier).load()),
            ],
          ),
        ),
        AdminRoleListLoaded(roles: final roles) =>
          roles.isEmpty
              ? const Center(child: Text('No roles found'))
              : ListView.separated(
                  padding: AppSpacing.paddingAll16,
                  itemCount: roles.length,
                  separatorBuilder: (_, __) => AppSpacing.gapH8,
                  itemBuilder: (context, index) {
                    final role = roles[index];
                    final isSystem = role['is_system'] == true;
                    return Card(
                      child: ListTile(
                        leading: Icon(
                          isSystem ? Icons.admin_panel_settings : Icons.security,
                          color: isSystem ? AppColors.primary : AppColors.textSecondary,
                        ),
                        title: Text(role['name'] as String? ?? ''),
                        subtitle: Text(role['description'] as String? ?? role['slug'] as String? ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSystem)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('System', style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                              ),
                            const SizedBox(width: 8),
                            Text('${role['permissions_count'] ?? 0} perms', style: theme.textTheme.bodySmall),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => context.push('${Routes.adminRoleDetail}/${role['id']}'),
                      ),
                    );
                  },
                ),
      },
    );
  }
}
