import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminProviderUserListPage extends ConsumerStatefulWidget {
  const AdminProviderUserListPage({super.key});

  @override
  ConsumerState<AdminProviderUserListPage> createState() => _AdminProviderUserListPageState();
}

class _AdminProviderUserListPageState extends ConsumerState<AdminProviderUserListPage> {
  final _searchController = TextEditingController();
  String? _storeId;
  String? _roleFilter;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(providerUserListProvider.notifier).loadUsers(storeId: _storeId);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(providerUserListProvider.notifier)
        .loadUsers(
          search: _searchController.text.isEmpty ? null : _searchController.text,
          role: _roleFilter,
          isActive: _activeFilter,
          storeId: _storeId,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(providerUserListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Provider Users')),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // Search bar
          Padding(
            padding: AppSpacing.paddingAll16,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, email, or phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _applyFilters();
                  },
                ),
                border: const OutlineInputBorder(),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterChip('All', _roleFilter == null && _activeFilter == null, () {
                  setState(() {
                    _roleFilter = null;
                    _activeFilter = null;
                  });
                  _applyFilters();
                }),
                AppSpacing.gapW8,
                _buildFilterChip('Active', _activeFilter == true, () {
                  setState(() {
                    _activeFilter = true;
                    _roleFilter = null;
                  });
                  _applyFilters();
                }),
                AppSpacing.gapW8,
                _buildFilterChip('Inactive', _activeFilter == false, () {
                  setState(() {
                    _activeFilter = false;
                    _roleFilter = null;
                  });
                  _applyFilters();
                }),
                AppSpacing.gapW8,
                _buildFilterChip('Cashier', _roleFilter == 'cashier', () {
                  setState(() {
                    _roleFilter = 'cashier';
                    _activeFilter = null;
                  });
                  _applyFilters();
                }),
                AppSpacing.gapW8,
                _buildFilterChip('Owner', _roleFilter == 'owner', () {
                  setState(() {
                    _roleFilter = 'owner';
                    _activeFilter = null;
                  });
                  _applyFilters();
                }),
              ],
            ),
          ),
          AppSpacing.gapH8,

          // User list
          Expanded(child: _buildContent(state)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool selected, VoidCallback onTap) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
    );
  }

  Widget _buildContent(ProviderUserListState state) {
    return switch (state) {
      ProviderUserListLoading() => const Center(child: CircularProgressIndicator()),
      ProviderUserListError(:final message) => Center(
        child: Text(message, style: const TextStyle(color: AppColors.error)),
      ),
      ProviderUserListLoaded(:final users, :final total) =>
        users.isEmpty
            ? const Center(child: Text('No users found'))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('$total users found', style: Theme.of(context).textTheme.bodySmall),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: users.length,
                      padding: AppSpacing.paddingAll8,
                      itemBuilder: (context, index) => _buildUserCard(users[index]),
                    ),
                  ),
                ],
              ),
      _ => const Center(child: Text('Search for users')),
    };
  }

  Widget _buildUserCard(Map<String, dynamic> user) {
    final isActive = user['is_active'] == true;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isActive ? AppColors.primary : AppColors.error,
          child: Text((user['name'] as String? ?? 'U')[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
        ),
        title: Text(user['name']?.toString() ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user['email']?.toString() ?? ''),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(user['role']?.toString() ?? 'unknown', style: const TextStyle(fontSize: 11)),
                ),
                AppSpacing.gapW8,
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  size: 14,
                  color: isActive ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  isActive ? 'Active' : 'Inactive',
                  style: TextStyle(fontSize: 11, color: isActive ? AppColors.success : AppColors.error),
                ),
              ],
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        isThreeLine: true,
      ),
    );
  }
}
