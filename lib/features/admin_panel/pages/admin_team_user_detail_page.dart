import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminTeamUserDetailPage extends ConsumerStatefulWidget {
  final String userId;
  const AdminTeamUserDetailPage({super.key, required this.userId});

  @override
  ConsumerState<AdminTeamUserDetailPage> createState() => _AdminTeamUserDetailPageState();
}

class _AdminTeamUserDetailPageState extends ConsumerState<AdminTeamUserDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminTeamUserDetailProvider.notifier).load(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminTeamUserDetailProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Team Member')),
      body: switch (state) {
        AdminTeamUserDetailInitial() || AdminTeamUserDetailLoading() => const Center(child: CircularProgressIndicator()),
        AdminTeamUserDetailError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
              AppSpacing.gapH16,
              PosButton(label: 'Retry', onPressed: () => ref.read(adminTeamUserDetailProvider.notifier).load(widget.userId)),
            ],
          ),
        ),
        AdminTeamUserDetailLoaded(user: final user) => _buildUserDetail(user, theme),
      },
    );
  }

  Widget _buildUserDetail(Map<String, dynamic> user, ThemeData theme) {
    final isActive = user['is_active'] == true;
    final roles = user['roles'] as List<dynamic>? ?? <dynamic>[];
    final twoFactor = user['two_factor_enabled'] == true;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ───────────────────────────────
          Card(
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
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                        ),
                        AppSpacing.gapH4,
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColors.success.withValues(alpha: 0.1)
                                    : AppColors.error.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: isActive ? AppColors.success : AppColors.error,
                                ),
                              ),
                            ),
                            if (twoFactor) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.verified_user, size: 16, color: AppColors.success),
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
          Card(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Details', style: theme.textTheme.titleMedium),
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
            const Card(
              child: Padding(padding: EdgeInsets.all(16), child: Text('No roles assigned')),
            )
          else
            ...roles.map((r) {
              final role = r as Map<String, dynamic>;
              return Card(
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
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
