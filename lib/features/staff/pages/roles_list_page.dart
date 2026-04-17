import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/staff/models/role.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/features/staff/providers/roles_state.dart';

class RolesListPage extends ConsumerStatefulWidget {
  const RolesListPage({super.key});

  @override
  ConsumerState<RolesListPage> createState() => _RolesListPageState();
}

class _RolesListPageState extends ConsumerState<RolesListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    // Load roles on page init
    Future.microtask(() => ref.read(rolesProvider.notifier).load());
  }

  Future<void> _handleDelete(Role role) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.delete,
      message: '${l10n.deleteConfirmation} "${role.displayName}"?',
      confirmLabel: l10n.delete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(rolesProvider.notifier).deleteRole(role.id);
        if (mounted) {
          showPosSuccessSnackbar(context, '${role.displayName} ${l10n.deleted}');
        }
      } catch (e) {
        if (mounted) {
          showPosErrorSnackbar(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rolesState = ref.watch(rolesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: l10n.staffRolesPermissions,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showRolesListInfo(context),
          variant: PosButtonVariant.ghost,
        ),
        PosButton.icon(
          icon: Icons.refresh,
          tooltip: l10n.commonRefresh,
          onPressed: () => ref.read(rolesProvider.notifier).load(),
          variant: PosButtonVariant.ghost,
        ),
        PosButton(label: l10n.staffNewRole, icon: Icons.add, onPressed: () => context.push(Routes.staffRoleCreate)),
      ],
      child: _buildBody(rolesState, isDark, l10n),
    );
  }

  Widget _buildBody(RolesState state, bool isDark, AppLocalizations l10n) {
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
            Text(
              state.message,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            PosButton(
              label: l10n.retry,
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
              Icon(
                Icons.admin_panel_settings_outlined,
                size: 64,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                l10n.staffNoRoles,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                l10n.staffNoRolesDesc,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
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
            isDark: isDark,
            l10n: l10n,
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
  final bool isDark;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const _RoleCard({required this.role, required this.isDark, required this.l10n, required this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isPredefined = role.isPredefined == true;
    final permCount = role.permissions?.length ?? 0;

    return PosCard(
      elevation: 0,
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: AppRadius.borderLg,

      border: Border.fromBorderSide(BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderLg,
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
                  borderRadius: AppRadius.borderLg,
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
                            decoration: BoxDecoration(color: AppColors.primary10, borderRadius: AppRadius.borderXs),
                            child: Text(
                              l10n.staffSystemRole,
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
                      ).textTheme.bodySmall?.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.staffPermissionCount(permCount),
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                    ),
                  ],
                ),
              ),

              // Actions
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete_outline, color: AppColors.error),
                  tooltip: l10n.deleteRole,
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
