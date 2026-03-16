import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminFinOpsAccountingConfigListPage extends ConsumerStatefulWidget {
  const AdminFinOpsAccountingConfigListPage({super.key});

  @override
  ConsumerState<AdminFinOpsAccountingConfigListPage> createState() => _State();
}

class _State extends ConsumerState<AdminFinOpsAccountingConfigListPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    Future.microtask(() {
      ref.read(finOpsAccountingConfigsProvider.notifier).load();
      ref.read(finOpsAccountingExportsProvider.notifier).load();
      ref.read(finOpsAutoExportConfigsProvider.notifier).load();
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
        title: const Text('Accounting'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Configs'),
            Tab(text: 'Mappings'),
            Tab(text: 'Exports'),
            Tab(text: 'Auto Export'),
          ],
        ),
      ),
      body: TabBarView(controller: _tabController, children: [_ConfigsTab(), _MappingsTab(), _ExportsTab(), _AutoExportTab()]),
    );
  }
}

class _ConfigsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(finOpsAccountingConfigsProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildConfigList(resp),
      FinOpsListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildConfigList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No accounting configs'));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(Icons.settings, color: Colors.green, size: 20),
            ),
            title: Text(
              item['provider']?.toString() ?? 'Config #${item['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Auto-export: ${item['auto_export'] == true ? 'ON' : 'OFF'}', style: const TextStyle(fontSize: 12)),
            trailing: Icon(
              item['is_active'] == true ? Icons.check_circle : Icons.cancel,
              color: item['is_active'] == true ? AppColors.success : AppColors.error,
              size: 20,
            ),
          ),
        );
      },
    );
  }
}

class _MappingsTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_MappingsTab> createState() => _MappingsTabState();
}

class _MappingsTabState extends ConsumerState<_MappingsTab> {
  @override
  void initState() {
    super.initState();
    // Account mappings loaded via configs – reuse the same provider or load separately
  }

  @override
  Widget build(BuildContext context) {
    // Account mappings are typically loaded from the accounting configs detail
    // For the list view, show a placeholder that directs to config detail
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.account_tree, size: 48, color: AppColors.textMutedLight),
            SizedBox(height: AppSpacing.sm),
            Text('Account Mappings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Select an accounting config to view its account mappings.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMutedLight),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExportsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(finOpsAccountingExportsProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildExportList(resp),
      FinOpsListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildExportList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No exports'));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        final status = (item['status'] ?? '').toString();
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF1E88E5).withValues(alpha: 0.1),
              child: const Icon(Icons.upload_file, color: Color(0xFF1E88E5), size: 20),
            ),
            title: Text(
              item['file_name']?.toString() ?? 'Export #${item['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${item['start_date'] ?? ''} → ${item['end_date'] ?? ''}', style: const TextStyle(fontSize: 12)),
            trailing: _statusChip(status),
          ),
        );
      },
    );
  }

  Widget _statusChip(String status) {
    final color = switch (status) {
      'completed' => AppColors.success,
      'pending' => AppColors.warning,
      'failed' => AppColors.error,
      _ => AppColors.textMutedLight,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }
}

class _AutoExportTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(finOpsAutoExportConfigsProvider);
    return switch (state) {
      FinOpsListLoading() => const Center(child: CircularProgressIndicator()),
      FinOpsListLoaded(data: final resp) => _buildAutoExportList(resp),
      FinOpsListError(message: final msg) => Center(
        child: Text('Error: $msg', style: const TextStyle(color: AppColors.error)),
      ),
      _ => const Center(child: Text('Loading...')),
    };
  }

  Widget _buildAutoExportList(Map<String, dynamic> resp) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final items = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (items.isEmpty) return const Center(child: Text('No auto-export configs'));
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.sm),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
      itemBuilder: (_, i) {
        final item = items[i];
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF7C3AED).withValues(alpha: 0.1),
              child: const Icon(Icons.schedule, color: Color(0xFF7C3AED), size: 20),
            ),
            title: Text(
              item['schedule']?.toString() ?? 'Config #${item['id']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Format: ${item['format'] ?? 'N/A'} · Active: ${item['is_active'] == true ? 'Yes' : 'No'}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Icon(
              item['is_active'] == true ? Icons.toggle_on : Icons.toggle_off,
              color: item['is_active'] == true ? AppColors.success : AppColors.textMutedLight,
              size: 32,
            ),
          ),
        );
      },
    );
  }
}
