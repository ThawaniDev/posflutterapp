import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';

class AdminMarketplaceStoreListPage extends ConsumerStatefulWidget {
  const AdminMarketplaceStoreListPage({super.key});

  @override
  ConsumerState<AdminMarketplaceStoreListPage> createState() => _AdminMarketplaceStoreListPageState();
}

class _AdminMarketplaceStoreListPageState extends ConsumerState<AdminMarketplaceStoreListPage> {
  final _searchController = TextEditingController();
  String? _connectedFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(marketplaceStoreListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final params = <String, dynamic>{};
    if (_searchController.text.isNotEmpty) params['search'] = _searchController.text;
    if (_connectedFilter != null) params['is_connected'] = _connectedFilter;
    ref.read(marketplaceStoreListProvider.notifier).load(params: params);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(marketplaceStoreListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace Stores'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      body: Column(
        children: [
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
                  child: DropdownButtonFormField<String>(
                    value: _connectedFilter,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(value: '1', child: Text('Connected')),
                      DropdownMenuItem(value: '0', child: Text('Disconnected')),
                    ],
                    onChanged: (v) {
                      setState(() => _connectedFilter = v);
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              MarketplaceStoreListLoading() => const Center(child: CircularProgressIndicator()),
              MarketplaceStoreListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: Colors.red)),
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
            leading: Icon(Icons.storefront, color: isConnected ? Colors.green : Colors.grey),
            title: Text(store?['name']?.toString() ?? 'Unknown Store'),
            subtitle: Text('Commission: ${s['commission_rate'] ?? 'N/A'}%'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: (isConnected ? Colors.green : Colors.grey).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isConnected ? 'CONNECTED' : 'DISCONNECTED',
                style: TextStyle(color: isConnected ? Colors.green : Colors.grey, fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      },
    );
  }
}
