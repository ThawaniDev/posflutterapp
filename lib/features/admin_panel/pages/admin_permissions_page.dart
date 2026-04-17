import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminPermissionsPage extends ConsumerStatefulWidget {
  const AdminPermissionsPage({super.key});

  @override
  ConsumerState<AdminPermissionsPage> createState() => _AdminPermissionsPageState();
}

class _AdminPermissionsPageState extends ConsumerState<AdminPermissionsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(permissionListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(permissionListProvider);
    final theme = Theme.of(context);

    final isLoading = state is PermissionListInitial || state is PermissionListLoading;
    final hasError = state is PermissionListError;

    return PosListPage(
      title: l10n.permissions,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? state.message : null,
      onRetry: () => ref.read(permissionListProvider.notifier).load(),
      child: switch (state) {
        PermissionListLoaded(groupedPermissions: final groups) => ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: groups.keys.length,
          itemBuilder: (context, index) {
            final groupName = groups.keys.elementAt(index);
            final permissions = groups[groupName]!;
            return PosCard(
              margin: const EdgeInsetsDirectional.only(bottom: 12),
              child: ExpansionTile(
                leading: Icon(Icons.folder_outlined, color: AppColors.primary),
                title: Text(_formatGroupName(groupName), style: theme.textTheme.titleSmall),
                subtitle: Text('${permissions.length} permissions', style: theme.textTheme.bodySmall),
                children: permissions.map((perm) {
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.vpn_key_outlined, size: 18),
                    title: Text(perm['name'] as String? ?? ''),
                    subtitle: perm['description'] != null ? Text(perm['description'] as String) : null,
                  );
                }).toList(),
              ),
            );
          },
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }

  String _formatGroupName(String group) {
    return group
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
