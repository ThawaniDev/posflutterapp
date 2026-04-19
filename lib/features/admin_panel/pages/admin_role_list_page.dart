import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminRoleListPage extends ConsumerStatefulWidget {
  const AdminRoleListPage({super.key});

  @override
  ConsumerState<AdminRoleListPage> createState() => _AdminRoleListPageState();
}

class _AdminRoleListPageState extends ConsumerState<AdminRoleListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminRoleListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRoleListProvider);
    final theme = Theme.of(context);

    final isLoading = state is AdminRoleListInitial || state is AdminRoleListLoading;
    final hasError = state is AdminRoleListError;
    final isEmpty = state is AdminRoleListLoaded && state.roles.isEmpty;

    return PosListPage(
      title: l10n.adminPlatformRoles,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(adminRoleListProvider.notifier).load(),
      isEmpty: isEmpty,
      emptyTitle: 'No roles found',
      emptyIcon: Icons.security,
      actions: [
        PosButton.icon(
          icon: Icons.shield_outlined,
          tooltip: l10n.permissions,
          onPressed: () => context.push(Routes.adminPermissions),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.createRole, icon: Icons.add, onPressed: () => context.push(Routes.adminRoleCreate)),
      ],
      child: switch (state) {
        AdminRoleListLoaded(roles: final roles) => ListView.separated(
          padding: AppSpacing.paddingAll16,
          itemCount: roles.length,
          separatorBuilder: (_, __) => AppSpacing.gapH8,
          itemBuilder: (context, index) {
            final role = roles[index];
            final isSystem = role['is_system'] == true;
            return PosCard(
              child: ListTile(
                leading: Icon(
                  isSystem ? Icons.admin_panel_settings : Icons.security,
                  color: isSystem ? AppColors.primary : AppColors.mutedFor(context),
                ),
                title: Text(role['name'] as String? ?? ''),
                subtitle: Text(role['description'] as String? ?? role['slug'] as String? ?? ''),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSystem)
                      Container(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderLg,
                        ),
                        child: Text(l10n.settingsSystem, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                      ),
                    AppSpacing.gapW8,
                    Text('${role['permissions_count'] ?? 0} perms', style: theme.textTheme.bodySmall),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                onTap: () => context.push('${Routes.adminRoleDetail}/${role['id']}'),
              ),
            );
          },
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
