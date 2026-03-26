import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminInfraBackupsPage extends ConsumerStatefulWidget {
  const AdminInfraBackupsPage({super.key});

  @override
  ConsumerState<AdminInfraBackupsPage> createState() => _State();
}

class _State extends ConsumerState<AdminInfraBackupsPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.microtask(() {
      ref.read(infraDatabaseBackupsProvider.notifier).load();
      ref.read(infraProviderBackupsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Backups'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Database'),
            Tab(text: 'Provider'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_DatabaseBackupsTab(), _ProviderBackupsTab()]),
    );
  }
}

class _DatabaseBackupsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(infraDatabaseBackupsProvider);

    return switch (state) {
      InfraListLoading() => const Center(child: CircularProgressIndicator()),
      InfraListLoaded(data: final resp) => _buildList(resp),
      InfraListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No database backups'));

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final status = item['status']?.toString() ?? '';
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'completed' ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
              child: Icon(
                status == 'completed' ? Icons.check_circle_outline : Icons.schedule,
                size: 20,
                color: status == 'completed' ? AppColors.success : AppColors.warning,
              ),
            ),
            title: Text(
              item['disk_name']?.toString() ?? item['file_path']?.toString() ?? 'Backup',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Status: $status  •  Size: ${item['file_size'] ?? 'N/A'}'),
            trailing: Text(item['created_at']?.toString().substring(0, 10) ?? ''),
          ),
        );
      },
    );
  }
}

class _ProviderBackupsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(infraProviderBackupsProvider);

    return switch (state) {
      InfraListLoading() => const Center(child: CircularProgressIndicator()),
      InfraListLoaded(data: final resp) => _buildList(resp),
      InfraListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No provider backups'));

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final status = item['status']?.toString() ?? '';
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: status == 'success' ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
              child: Icon(
                status == 'success' ? Icons.cloud_done : Icons.cloud_off,
                size: 20,
                color: status == 'success' ? AppColors.success : AppColors.error,
              ),
            ),
            title: Text(
              'Provider: ${item['provider_name'] ?? item['provider_type'] ?? 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Status: $status  •  ${item['message'] ?? ''}'),
            trailing: Text(
              item['checked_at']?.toString().substring(0, 10) ?? item['created_at']?.toString().substring(0, 10) ?? '',
            ),
          ),
        );
      },
    );
  }
}
