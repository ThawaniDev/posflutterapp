import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/admin_providers.dart';
import '../../providers/admin_state.dart';
import 'package:thawani_pos/core/providers/branch_context_provider.dart';
import 'package:thawani_pos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminCannedResponseListPage extends ConsumerStatefulWidget {
  const AdminCannedResponseListPage({super.key});

  @override
  ConsumerState<AdminCannedResponseListPage> createState() => _AdminCannedResponseListPageState();
}

class _AdminCannedResponseListPageState extends ConsumerState<AdminCannedResponseListPage> {
  final _searchController = TextEditingController();
  String? _categoryFilter;
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
    if (_categoryFilter != null) params['category'] = _categoryFilter;
    ref.read(cannedResponseListProvider.notifier).load(params: params.isEmpty ? null : params);
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cannedResponseListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Canned Responses'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
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
                      hintText: 'Search responses...',
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
                      PosDropdownItem(value: 'billing', label: 'Billing'),
                      PosDropdownItem(value: 'technical', label: 'Technical'),
                      PosDropdownItem(value: 'zatca', label: 'ZATCA'),
                      PosDropdownItem(value: 'feature_request', label: 'Feature'),
                      PosDropdownItem(value: 'general', label: 'General'),
                    ],
                    selectedValue: _categoryFilter,
                    onChanged: (v) {
                      setState(() => _categoryFilter = v);
                      _applyFilters();
                    },
                    label: 'Category',
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
              CannedResponseListLoading() => const Center(child: CircularProgressIndicator()),
              CannedResponseListError(:final message) => Center(
                child: Text(message, style: const TextStyle(color: AppColors.error)),
              ),
              CannedResponseListLoaded(:final data) => _buildList(data),
              _ => const SizedBox.shrink(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList(Map<String, dynamic> data) {
    final responses = (data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    if (responses.isEmpty) {
      return const Center(child: Text('No canned responses found'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      itemCount: responses.length,
      itemBuilder: (context, index) {
        final r = responses[index];
        final isActive = r['is_active'] == true;
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: Icon(Icons.quickreply, color: isActive ? AppColors.primary : AppColors.textSecondary),
            title: Text(r['title']?.toString() ?? ''),
            subtitle: Text(r['body']?.toString() ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (r['category'] != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(r['category'].toString(), style: const TextStyle(fontSize: 11)),
                  ),
                Icon(
                  isActive ? Icons.check_circle : Icons.cancel,
                  color: isActive ? AppColors.success : AppColors.error,
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
