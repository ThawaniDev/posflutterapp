import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';

class AdminDeploymentReleaseListPage extends ConsumerStatefulWidget {
  const AdminDeploymentReleaseListPage({super.key});

  @override
  ConsumerState<AdminDeploymentReleaseListPage> createState() => _AdminDeploymentReleaseListPageState();
}

class _AdminDeploymentReleaseListPageState extends ConsumerState<AdminDeploymentReleaseListPage> {
  String? _platformFilter;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
  }

  void _load() {
    final params = <String, dynamic>{};
    if (_platformFilter != null) params['platform'] = _platformFilter;
    if (_searchController.text.isNotEmpty) {
      params['search'] = _searchController.text;
    }
    ref.read(deploymentReleaseListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(deploymentReleaseListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Deployment Releases'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _load)],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // Filters
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search versions...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onSubmitted: (_) => _load(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                DropdownButton<String?>(
                  value: _platformFilter,
                  hint: const Text('Platform'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'ios', child: Text('iOS')),
                    DropdownMenuItem(value: 'android', child: Text('Android')),
                    DropdownMenuItem(value: 'windows', child: Text('Windows')),
                    DropdownMenuItem(value: 'macos', child: Text('macOS')),
                  ],
                  onChanged: (v) {
                    setState(() => _platformFilter = v);
                    _load();
                  },
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: switch (state) {
              DeploymentReleaseListLoading() => const Center(child: CircularProgressIndicator()),
              DeploymentReleaseListError(message: final m) => Center(
                child: Text(m, style: const TextStyle(color: AppColors.error)),
              ),
              DeploymentReleaseListLoaded(data: final d) => _buildList(d),
              _ => const Center(child: Text('Load releases')),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final items = (data['data']?['data'] as List?) ?? [];
    if (items.isEmpty) {
      return const Center(child: Text('No releases found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final r = items[index] as Map<String, dynamic>;
        final isActive = r['is_active'] == true || r['is_active'] == 1;
        final isMandatory = r['is_mandatory'] == true || r['is_mandatory'] == 1;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(_platformIcon(r['platform'] ?? ''), color: isActive ? AppColors.success : AppColors.textSecondary),
            title: Text('v${r['version']} (${r['platform']})', style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(
              'Build: ${r['build_number'] ?? 'N/A'} · '
              'Rollout: ${r['rollout_percentage']}% · '
              '${isMandatory ? 'Mandatory' : 'Optional'}',
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? AppColors.success.withOpacity(0.1) : AppColors.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: TextStyle(color: isActive ? AppColors.success : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _platformIcon(String platform) {
    return switch (platform) {
      'ios' => Icons.phone_iphone,
      'android' => Icons.android,
      'windows' => Icons.desktop_windows,
      'macos' => Icons.laptop_mac,
      _ => Icons.devices,
    };
  }
}
