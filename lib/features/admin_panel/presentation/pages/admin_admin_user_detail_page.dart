import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAdminUserDetailPage extends ConsumerStatefulWidget {
  final String userId;
  const AdminAdminUserDetailPage({super.key, required this.userId});

  @override
  ConsumerState<AdminAdminUserDetailPage> createState() => _AdminAdminUserDetailPageState();
}

class _AdminAdminUserDetailPageState extends ConsumerState<AdminAdminUserDetailPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(adminUserDetailProvider.notifier).loadAdmin(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUserDetailProvider);

    return PosListPage(
  title: l10n.adminAdminDetail,
  showSearch: false,
    child: switch (state) {
        AdminUserDetailLoading() => const Center(child: CircularProgressIndicator()),
        AdminUserDetailError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: AppColors.error)),
        ),
        AdminUserDetailLoaded(:final admin) => _buildDetail(admin),
        _ => const SizedBox.shrink(),
      },
);
  }

  Widget _buildDetail(Map<String, dynamic> admin) {
    final isActive = admin['is_active'] == true;
    final has2fa = admin['two_factor_enabled'] == true;
    final roles = (admin['roles'] as List?) ?? [];

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: isActive ? AppColors.primary : AppColors.error,
                  child: Text(
                    (admin['name'] as String? ?? 'A')[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
                AppSpacing.gapH8,
                Text(admin['name']?.toString() ?? 'Unknown', style: Theme.of(context).textTheme.titleLarge),
                Text(admin['email']?.toString() ?? '', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          AppSpacing.gapH24,

          // Info card
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Account Info', style: Theme.of(context).textTheme.titleMedium),
                  AppSpacing.gapH16,
                  _infoRow('Phone', admin['phone']?.toString() ?? 'N/A'),
                  _infoRow('Status', isActive ? 'Active' : 'Inactive'),
                  _infoRow('2FA', has2fa ? 'Enabled' : 'Disabled'),
                  _infoRow('Last Login', admin['last_login_at']?.toString() ?? 'Never'),
                  _infoRow('Last Login IP', admin['last_login_ip']?.toString() ?? 'N/A'),
                  _infoRow('Created', admin['created_at']?.toString() ?? ''),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // Roles
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.roles, style: Theme.of(context).textTheme.titleMedium),
                  AppSpacing.gapH8,
                  if (roles.isEmpty)
                    Text('No roles assigned', style: TextStyle(color: AppColors.textSecondary))
                  else
                    ...roles.map((r) {
                      final role = r as Map<String, dynamic>;
                      return ListTile(
                        dense: true,
                        leading: const Icon(Icons.admin_panel_settings, size: 20, color: AppColors.primary),
                        title: Text(role['role_name']?.toString() ?? 'Role'),
                        subtitle: Text(role['role_slug']?.toString() ?? ''),
                      );
                    }),
                ],
              ),
            ),
          ),
          AppSpacing.gapH16,

          // Actions
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.actions, style: Theme.of(context).textTheme.titleMedium),
                  AppSpacing.gapH8,
                  if (has2fa)
                    ListTile(
                      leading: const Icon(Icons.security, color: AppColors.warning),
                      title: Text(l10n.adminReset2FA),
                      subtitle: Text(l10n.adminClear2FAHint),
                      onTap: () => _reset2fa(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _reset2fa() async {
    await ref.read(adminUserActionProvider.notifier).reset2fa(widget.userId);
    if (mounted) {
      ref.read(adminUserDetailProvider.notifier).loadAdmin(widget.userId);
    }
  }
}
