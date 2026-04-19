import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminProviderUserDetailPage extends ConsumerStatefulWidget {
  final String userId;
  const AdminProviderUserDetailPage({super.key, required this.userId});

  @override
  ConsumerState<AdminProviderUserDetailPage> createState() => _AdminProviderUserDetailPageState();
}

class _AdminProviderUserDetailPageState extends ConsumerState<AdminProviderUserDetailPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(providerUserDetailProvider.notifier).loadUser(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(providerUserDetailProvider);

    return PosListPage(
  title: l10n.userDetail,
  showSearch: false,
    child: switch (state) {
        ProviderUserDetailLoading() => const Center(child: CircularProgressIndicator()),
        ProviderUserDetailError(:final message) => Center(
          child: Text(message, style: const TextStyle(color: AppColors.error)),
        ),
        ProviderUserDetailLoaded(:final user) => _buildDetail(user),
        _ => const SizedBox.shrink(),
      },
);
  }

  Widget _buildDetail(Map<String, dynamic> user) {
    final isActive = user['is_active'] == true;
    final mustChangePassword = user['must_change_password'] == true;

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
                    (user['name'] as String? ?? 'U')[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 32),
                  ),
                ),
                AppSpacing.gapH8,
                Text(user['name']?.toString() ?? 'Unknown', style: Theme.of(context).textTheme.titleLarge),
                Text(user['email']?.toString() ?? '', style: Theme.of(context).textTheme.bodyMedium),
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
                  _infoRow('Phone', user['phone']?.toString() ?? 'N/A'),
                  _infoRow('Role', user['role']?.toString() ?? 'N/A'),
                  _infoRow('Locale', user['locale']?.toString() ?? 'N/A'),
                  _infoRow('Store', user['store_name']?.toString() ?? user['store_id']?.toString() ?? 'N/A'),
                  _infoRow('Organization', user['organization_name']?.toString() ?? user['organization_id']?.toString() ?? 'N/A'),
                  _infoRow('Status', isActive ? 'Active' : 'Inactive'),
                  if (mustChangePassword) _infoRow('Password', 'Must change on next login'),
                  _infoRow('Last Login', user['last_login_at']?.toString() ?? 'Never'),
                  _infoRow('Created', user['created_at']?.toString() ?? ''),
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
                  ListTile(
                    leading: const Icon(Icons.lock_reset, color: AppColors.primary),
                    title: Text(l10n.resetPassword),
                    subtitle: Text(l10n.adminGenerateTempPassword),
                    onTap: () => _resetPassword(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.password, color: AppColors.warning),
                    title: Text(l10n.adminForcePasswordChange),
                    subtitle: Text(l10n.adminForcePasswordChangeDesc),
                    onTap: () => _forcePasswordChange(),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(
                      isActive ? Icons.block : Icons.check_circle,
                      color: isActive ? AppColors.error : AppColors.success,
                    ),
                    title: Text(isActive ? 'Disable Account' : 'Enable Account'),
                    subtitle: Text(isActive ? 'Prevent user from logging in' : 'Allow user to log in again'),
                    onTap: () => _toggleActive(),
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
              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Future<void> _resetPassword() async {
    await ref.read(providerUserActionProvider.notifier).resetPassword(widget.userId);
    if (mounted) {
      ref.read(providerUserDetailProvider.notifier).loadUser(widget.userId);
    }
  }

  Future<void> _forcePasswordChange() async {
    await ref.read(providerUserActionProvider.notifier).forcePasswordChange(widget.userId);
    if (mounted) {
      ref.read(providerUserDetailProvider.notifier).loadUser(widget.userId);
    }
  }

  Future<void> _toggleActive() async {
    await ref.read(providerUserActionProvider.notifier).toggleActive(widget.userId);
    if (mounted) {
      ref.read(providerUserDetailProvider.notifier).loadUser(widget.userId);
    }
  }
}
