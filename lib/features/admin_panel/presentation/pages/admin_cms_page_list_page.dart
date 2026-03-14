import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminCmsPageListPage extends ConsumerStatefulWidget {
  const AdminCmsPageListPage({super.key});

  @override
  ConsumerState<AdminCmsPageListPage> createState() => _AdminCmsPageListPageState();
}

class _AdminCmsPageListPageState extends ConsumerState<AdminCmsPageListPage> {
  final _searchController = TextEditingController();
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cmsPageListProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _search() {
    ref
        .read(cmsPageListProvider.notifier)
        .load(search: _searchController.text.isNotEmpty ? _searchController.text : null, pageType: _selectedType);
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
                DropdownButton<String?>(
                  value: _selectedType,
                  hint: const Text('Type'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('All Types')),
                    DropdownMenuItem(value: 'legal', child: Text('Legal')),
                    DropdownMenuItem(value: 'marketing', child: Text('Marketing')),
                    DropdownMenuItem(value: 'general', child: Text('General')),
                  ],
                  onChanged: (v) {
                    setState(() => _selectedType = v);
                    _search();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: switch (state) {
              CmsPageListInitial() || CmsPageListLoading() => const Center(child: CircularProgressIndicator()),
              CmsPageListError(:final message) => Center(
                child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
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
                                    backgroundColor: page['is_published'] == true ? Colors.green.shade100 : Colors.grey.shade200,
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
