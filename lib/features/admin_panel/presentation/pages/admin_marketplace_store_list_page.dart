import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminMarketplaceStoreListPage extends ConsumerStatefulWidget {
  const AdminMarketplaceStoreListPage({super.key});

  @override
  ConsumerState<AdminMarketplaceStoreListPage> createState() => _AdminMarketplaceStoreListPageState();
}

class _AdminMarketplaceStoreListPageState extends ConsumerState<AdminMarketplaceStoreListPage> {
  final _searchController = TextEditingController();
  String? _connectedFilter;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _applyFilters();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_storeId != null) params['store_id'] = _storeId!;
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_connectedFilter != null) params['is_connected'] = _connectedFilter;
    ref.read(marketplaceStoreListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceStoreListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Stores'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search stores...',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      ),
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    ),
                    onSubmitted: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: '1', label: 'Connected'),
                      PosDropdownItem(value: '0', label: 'Disconnected'),
                    ],
                    selectedValue: _connectedFilter,
                    onChanged: (v) {
                      setState(() => _connectedFilter = v);
                      _applyFilters();
                    },
                    label: 'Status',
                    hint: 'All',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              MarketplaceStoreListLoading() => const Center(child: CircularProgressIndicator()),
              MarketplaceStoreListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: AppColors.error)),
              ),
              MarketplaceStoreListLoaded(:final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final stores = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (stores.isEmpty) {
      return const Center(child: Text('No marketplace stores found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final s = stores[index];
        final isConnected = s['is_connected'] == true;
        final store = s['store'] as Map<String, dynamic>?;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(Icons.storefront, color: isConnected ? AppColors.success : AppColors.textSecondary),
            title: Text(store?['name']?.toString() ?? 'Unknown Store'),
            subtitle: Text('Commission: ${s['commission_rate'] ?? 'N/A'}%'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isConnected ? AppColors.success : AppColors.textSecondary).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isConnected ? 'CONNECTED' : 'DISCONNECTED',
                style: TextStyle(
                  color: isConnected ? AppColors.success : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
