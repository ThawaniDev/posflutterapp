import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminArticleListPage extends ConsumerStatefulWidget {
  const AdminArticleListPage({super.key});

  @override
  ConsumerState<AdminArticleListPage> createState() => _AdminArticleListPageState();
}

class _AdminArticleListPageState extends ConsumerState<AdminArticleListPage> {
  final _searchController = TextEditingController();
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(articleListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(articleListProvider.notifier)
        .load(search: _searchController.text.isNotEmpty ? _searchController.text : null, category: _selectedCategory);
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
                DropdownButton<String?>(
                  value: _selectedCategory,
                  hint: const Text('Category'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All')),
                    DropdownMenuItem(value: 'getting_started', child: Text('Getting Started')),
                    DropdownMenuItem(value: 'pos_usage', child: Text('POS Usage')),
                    DropdownMenuItem(value: 'inventory', child: Text('Inventory')),
                    DropdownMenuItem(value: 'delivery', child: Text('Delivery')),
                    DropdownMenuItem(value: 'billing', child: Text('Billing')),
                    DropdownMenuItem(value: 'troubleshooting', child: Text('Troubleshooting')),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedCategory = v);
                    _search();
                  },
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
