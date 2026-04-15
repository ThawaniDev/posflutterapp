import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminProviderRoleTemplateDetailPage extends ConsumerStatefulWidget {
  final String templateId;

  const AdminProviderRoleTemplateDetailPage({super.key, required this.templateId});

  @override
  ConsumerState<AdminProviderRoleTemplateDetailPage> createState() => _State();
}

class _State extends ConsumerState<AdminProviderRoleTemplateDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(providerRoleTemplateDetailProvider.notifier).load(widget.templateId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerRoleTemplateDetailProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Template Detail'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: switch (state) {
        ProviderRoleTemplateDetailLoading() => const Center(child: CircularProgressIndicator()),
        ProviderRoleTemplateDetailLoaded(data: final data) => _buildDetail(data),
        ProviderRoleTemplateDetailError(message: final msg) => Center(
          child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
        ),
        _ => const Center(child: Text('Loading...')),
      },
    );
  }

  Widget _buildDetail(Map<String, dynamic> resp) {
    final template = resp['data'] as Map<String, dynamic>? ?? resp;

    final permissions = (template['default_role_template_permissions'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header card
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 28),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              template['name']?.toString() ?? '',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            if (template['name_ar'] != null)
                              Text(
                                template['name_ar'].toString(),
                                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  _infoRow('Slug', template['slug']?.toString() ?? ''),
                  if (template['description'] != null) _infoRow('Description', template['description'].toString()),
                  if (template['description_ar'] != null) _infoRow('Description (AR)', template['description_ar'].toString()),
                  _infoRow('Created', template['created_at']?.toString().substring(0, 10) ?? ''),
                  _infoRow('Updated', template['updated_at']?.toString().substring(0, 10) ?? ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Permissions section
          Row(
            children: [
              const Icon(Icons.security, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                'Assigned Permissions (${permissions.length})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          if (permissions.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Center(
                  child: Text('No permissions assigned', style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            )
          else
            ..._buildGroupedPermissions(permissions),
        ],
      ),
    );
  }

  List<Widget> _buildGroupedPermissions(List<Map<String, dynamic>> permissions) {
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final tp in permissions) {
      final perm = tp['provider_permission'] as Map<String, dynamic>? ?? {};
      final group = perm['group']?.toString() ?? 'other';
      grouped.putIfAbsent(group, () => []).add(perm);
    }

    return grouped.entries.map((entry) {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
        child: ExpansionTile(
          leading: const Icon(Icons.folder_outlined, size: 20),
          title: Text(
            '${entry.key.toUpperCase()} (${entry.value.length})',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          children: entry.value.map((perm) {
            return ListTile(
              dense: true,
              leading: const Icon(Icons.check_circle, size: 16, color: AppColors.success),
              title: Text(perm['name']?.toString() ?? '', style: const TextStyle(fontSize: 13)),
              subtitle: perm['description'] != null
                  ? Text(perm['description'].toString(), style: const TextStyle(fontSize: 11))
                  : null,
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }
}
