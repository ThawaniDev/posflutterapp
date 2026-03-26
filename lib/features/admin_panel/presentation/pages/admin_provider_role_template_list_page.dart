import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart' show Routes;
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminProviderRoleTemplateListPage extends ConsumerStatefulWidget {
  const AdminProviderRoleTemplateListPage({super.key});

  @override
  ConsumerState<AdminProviderRoleTemplateListPage> createState() => _State();
}

class _State extends ConsumerState<AdminProviderRoleTemplateListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(providerRoleTemplateListProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerRoleTemplateListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Templates'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(providerRoleTemplateListProvider.notifier).load(),
          ),
        ],
      ),
      body: switch (state) {
        ProviderRoleTemplateListLoading() => const Center(child: CircularProgressIndicator()),
        ProviderRoleTemplateListLoaded(data: final resp) => _buildList(resp),
        ProviderRoleTemplateListError(message: final msg) => Center(
          child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
        ),
        _ => const Center(child: Text('Loading...')),
      },
    );
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No role templates'));

    return RefreshIndicator(
      onRefresh: () async => ref.read(providerRoleTemplateListProvider.notifier).load(),
      child: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.sm),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, i) {
          final item = items[i];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: const Icon(Icons.badge_outlined, color: AppColors.primary, size: 20),
              ),
              title: Text(item['name']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Slug: ${item['slug'] ?? ''}', style: const TextStyle(fontSize: 12)),
                  if (item['description'] != null)
                    Text(
                      item['description'].toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              isThreeLine: item['description'] != null,
              onTap: () =>
                  context.pushNamed(Routes.adminProviderRoleTemplateDetail, pathParameters: {'id': item['id'].toString()}),
            ),
          );
        },
      ),
    );
  }
}
