import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminCmsPageDetailPage extends ConsumerStatefulWidget {
  final String pageId;
  const AdminCmsPageDetailPage({super.key, required this.pageId});

  @override
  ConsumerState<AdminCmsPageDetailPage> createState() => _AdminCmsPageDetailPageState();
}

class _AdminCmsPageDetailPageState extends ConsumerState<AdminCmsPageDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cmsPageDetailProvider.notifier).load(widget.pageId));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cmsPageDetailProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CMS Page Detail')),
      body: switch (state) {
        CmsPageDetailInitial() || CmsPageDetailLoading() => const Center(child: CircularProgressIndicator()),
        CmsPageDetailError(:final message) => Center(
          child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
        ),
        CmsPageDetailLoaded(:final page) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(page['title'] ?? '', style: Theme.of(context).textTheme.headlineSmall)),
                          Chip(
                            label: Text(page['is_published'] == true ? 'Published' : 'Draft'),
                            backgroundColor: page['is_published'] == true ? Colors.green.shade100 : Colors.grey.shade200,
                          ),
                        ],
                      ),
                      if (page['title_ar'] != null) ...[
                        const SizedBox(height: 8),
                        Text(page['title_ar'], style: Theme.of(context).textTheme.titleMedium, textDirection: TextDirection.rtl),
                      ],
                      const Divider(height: 24),
                      _infoRow('Slug', '/${page['slug'] ?? ''}'),
                      _infoRow('Type', page['page_type'] ?? 'general'),
                      _infoRow('Sort Order', '${page['sort_order'] ?? 0}'),
                      if (page['meta_title'] != null) _infoRow('Meta Title', page['meta_title']),
                      if (page['meta_description'] != null) _infoRow('Meta Description', page['meta_description']),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Content (EN)', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(page['body'] ?? 'No content'),
                      if (page['body_ar'] != null) ...[
                        const Divider(height: 24),
                        Text('Content (AR)', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(page['body_ar'], textDirection: TextDirection.rtl),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      },
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
