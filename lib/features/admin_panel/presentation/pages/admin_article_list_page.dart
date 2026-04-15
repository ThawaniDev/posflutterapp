import 'package:flutter/material.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminArticleListPage extends ConsumerStatefulWidget {
  const AdminArticleListPage({super.key});

  @override
  ConsumerState<AdminArticleListPage> createState() => _AdminArticleListPageState();
}

class _AdminArticleListPageState extends ConsumerState<AdminArticleListPage> {
  final _searchController = TextEditingController();
  String? _selectedCategory;
  String? _storeId;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(articleListProvider.notifier).load(storeId: _storeId);
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
        .read(articleListProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          category: _selectedCategory,
          storeId: _storeId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(articleListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Base Articles'),
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
                      hintText: 'Search articles...',
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
                      PosDropdownItem(value: 'getting_started', label: 'Getting Started'),
                      PosDropdownItem(value: 'pos_usage', label: 'POS Usage'),
                      PosDropdownItem(value: 'inventory', label: 'Inventory'),
                      PosDropdownItem(value: 'delivery', label: 'Delivery'),
                      PosDropdownItem(value: 'billing', label: 'Billing'),
                      PosDropdownItem(value: 'troubleshooting', label: 'Troubleshooting'),
                    ],
                    selectedValue: _selectedCategory,
                    onChanged: (v) {
                      setState(() => _selectedCategory = v);
                      _search();
                    },
                    hint: 'Category',
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              ArticleListInitial() || ArticleListLoading() => const Center(child: CircularProgressIndicator()),
              ArticleListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
              ),
              ArticleListLoaded(:final articles, :final total, :final currentPage, :final lastPage) =>
                articles.isEmpty
                    ? const Center(child: Text('No articles found'))
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: articles.length,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemBuilder: (context, index) {
                                final article = articles[index];
                                return Card(
                                  child: ListTile(
                                    title: Text(article['title'] ?? ''),
                                    subtitle: Text(article['category'] ?? 'No category'),
                                    trailing: Chip(
                                      label: Text(article['is_published'] == true ? 'Published' : 'Draft'),
                                      backgroundColor: article['is_published'] == true
                                          ? AppColors.success.withValues(alpha: 0.15)
                                          : AppColors.borderLight,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text('Page $currentPage of $lastPage ($total total)'),
                          ),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }
}
