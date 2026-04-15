import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminPermissionsPage extends ConsumerStatefulWidget {
  const AdminPermissionsPage({super.key});

  @override
  ConsumerState<AdminPermissionsPage> createState() => _AdminPermissionsPageState();
}

class _AdminPermissionsPageState extends ConsumerState<AdminPermissionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(permissionListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(permissionListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: switch (state) {
        PermissionListInitial() || PermissionListLoading() => const Center(child: CircularProgressIndicator()),
        PermissionListError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
              AppSpacing.gapH16,
              PosButton(label: 'Retry', onPressed: () => ref.read(permissionListProvider.notifier).load()),
            ],
          ),
        ),
        PermissionListLoaded(groupedPermissions: final groups) => ListView.builder(
          padding: AppSpacing.paddingAll16,
          itemCount: groups.keys.length,
          itemBuilder: (context, index) {
            final groupName = groups.keys.elementAt(index);
            final permissions = groups[groupName]!;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
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
