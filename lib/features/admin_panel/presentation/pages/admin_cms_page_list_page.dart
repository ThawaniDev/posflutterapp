import 'package:flutter/material.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminCmsPageListPage extends ConsumerStatefulWidget {
  const AdminCmsPageListPage({super.key});

  @override
  ConsumerState<AdminCmsPageListPage> createState() => _AdminCmsPageListPageState();
}

class _AdminCmsPageListPageState extends ConsumerState<AdminCmsPageListPage> {
  final _searchController = TextEditingController();
  String? _selectedType;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(cmsPageListProvider.notifier).load(storeId: _storeId);
    });
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _search();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(cmsPageListProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          pageType: _selectedType,
          storeId: _storeId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cmsPageListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS Pages'),
        actions: [IconButton(icon: const Icon(Icons.add), onPressed: () {})],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search pages...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PosSearchableDropdown<String>(
                    items: [
                      PosDropdownItem(value: 'legal', label: 'Legal'),
                      PosDropdownItem(value: 'marketing', label: 'Marketing'),
                      PosDropdownItem(value: 'general', label: 'General'),
                    ],
                    selectedValue: _selectedType,
                    onChanged: (v) {
                      setState(() => _selectedType = v);
                      _search();
                    },
                    hint: 'Type',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              CmsPageListInitial() || CmsPageListLoading() => const Center(child: CircularProgressIndicator()),
              CmsPageListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
              ),
              CmsPageListLoaded(:final pages, :final total) =>
                pages.isEmpty
                    ? const Center(child: Text('No pages found'))
                    : ListView.builder(
                        itemCount: pages.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final page = pages[index];
                          return Card(
                            child: ListTile(
                              title: Text(page['title'] ?? ''),
                              subtitle: Text('/${page['slug'] ?? ''} • ${page['page_type'] ?? 'general'}'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Chip(
                                    label: Text(page['is_published'] == true ? 'Published' : 'Draft'),
                                    backgroundColor: page['is_published'] == true
                                        ? AppColors.success.withValues(alpha: 0.15)
                                        : AppColors.borderLight,
                                  ),
                                  const SizedBox(width: 8),
                                  Text('$total total'),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            },
          ),
        ],
      ),
    );
  }
}
