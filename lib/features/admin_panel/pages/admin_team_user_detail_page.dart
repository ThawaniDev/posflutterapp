import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminTeamUserDetailPage extends ConsumerStatefulWidget {
  const AdminTeamUserDetailPage({super.key, required this.userId});
  final String userId;

  @override
  ConsumerState<AdminTeamUserDetailPage> createState() => _AdminTeamUserDetailPageState();
}

class _AdminTeamUserDetailPageState extends ConsumerState<AdminTeamUserDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminTeamUserDetailProvider.notifier).load(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(adminTeamUserDetailProvider);
    final theme = Theme.of(context);
    final isLoading = state is AdminTeamUserDetailInitial || state is AdminTeamUserDetailLoading;

    return PosFormPage(
      title: l10n.adminTeamMember,
      isLoading: isLoading,
      child: switch (state) {
        AdminTeamUserDetailError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
              AppSpacing.gapH16,
              PosButton(label: l10n.retry, onPressed: () => ref.read(adminTeamUserDetailProvider.notifier).load(widget.userId)),
            ],
          ),
        ),
        AdminTeamUserDetailLoaded(user: final user) => _buildUserDetail(user, theme),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildUserDetail(Map<String, dynamic> user, ThemeData theme) {
    final isActive = user['is_active'] == true;
    final roles = user['roles'] as List<dynamic>? ?? <dynamic>[];
    final twoFactor = user['two_factor_enabled'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ───────────────────────────────
        PosCard(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                  child: Icon(Icons.person, size: 32, color: isActive ? AppColors.success : AppColors.error),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user['name'] as String? ?? '', style: theme.textTheme.titleLarge),
                      Text(
                        user['email'] as String? ?? '',
                        style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mutedFor(context)),
                      ),
                      AppSpacing.gapH4,
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                              borderRadius: AppRadius.borderLg,
                            ),
                            child: Text(
                              isActive ? 'Active' : 'Inactive',
                              style: theme.textTheme.labelSmall?.copyWith(color: isActive ? AppColors.success : AppColors.error),
                            ),
                          ),
                          if (twoFactor) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.verified_user, size: 16, color: AppColors.success),
                            const SizedBox(width: 4),
                            Text('2FA', style: theme.textTheme.labelSmall),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AppSpacing.gapH16,

        // ─── Details ──────────────────────────────
        PosCard(
          child: Padding(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.wameedAISuggestionBody, style: theme.textTheme.titleMedium),
                AppSpacing.gapH8,
                _detailRow('Phone', user['phone'] as String? ?? 'N/A'),
                _detailRow('Last Login', user['last_login_at'] as String? ?? 'Never'),
                _detailRow('Last Login IP', user['last_login_ip'] as String? ?? 'N/A'),
                _detailRow('Created', user['created_at'] as String? ?? 'N/A'),
              ],
            ),
          ),
        ),
        AppSpacing.gapH16,

        // ─── Roles ────────────────────────────────
        Text('Roles (${roles.length})', style: theme.textTheme.titleMedium),
        AppSpacing.gapH8,
        if (roles.isEmpty)
          PosCard(
            child: Padding(padding: const EdgeInsets.all(16), child: Text(l10n.adminNoRolesAssigned)),
          )
        else
          ...roles.map((r) {
            final role = r as Map<String, dynamic>;
            return PosCard(
              child: ListTile(
                dense: true,
                leading: const Icon(Icons.security, size: 20),
                title: Text(role['name'] as String? ?? ''),
                subtitle: Text(role['slug'] as String? ?? ''),
              ),
            );
          }),
        AppSpacing.gapH24,

        // ─── Actions ──────────────────────────────
        Row(
          children: [
            Expanded(
              child: PosButton(
                label: isActive ? 'Deactivate' : 'Activate',
                variant: isActive ? PosButtonVariant.danger : PosButtonVariant.primary,
                onPressed: () {
                  final userId = user['id'] as String;
                  if (isActive) {
                    ref.read(teamActionProvider.notifier).deactivateUser(userId);
                  } else {
                    ref.read(teamActionProvider.notifier).activateUser(userId);
                  }
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: AppColors.mutedFor(context))),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
