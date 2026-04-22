import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

class AdminCmsPageDetailPage extends ConsumerStatefulWidget {
  const AdminCmsPageDetailPage({super.key, required this.pageId});
  final String pageId;

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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(cmsPageDetailProvider);

    return PosListPage(
  title: l10n.adminCmsPageDetail,
  showSearch: false,
    child: switch (state) {
        CmsPageDetailInitial() || CmsPageDetailLoading() => const Center(child: CircularProgressIndicator()),
        CmsPageDetailError(:final message) => Center(
          child: Text(AppLocalizations.of(context)!.genericError(message), style: const TextStyle(color: AppColors.error)),
        ),
        CmsPageDetailLoaded(:final page) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PosCard(
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
                            backgroundColor: page['is_published'] == true
                                ? AppColors.success.withValues(alpha: 0.15)
                                : AppColors.borderFor(context),
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
              PosCard(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.adminContentEn, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(page['body'] ?? 'No content'),
                      if (page['body_ar'] != null) ...[
                        const Divider(height: 24),
                        Text(l10n.adminContentAr, style: Theme.of(context).textTheme.titleMedium),
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
