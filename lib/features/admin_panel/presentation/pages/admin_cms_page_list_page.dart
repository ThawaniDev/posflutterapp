import 'package:flutter/material.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminCmsPageListPage extends ConsumerStatefulWidget {
  const AdminCmsPageListPage({super.key});

  @override
  ConsumerState<AdminCmsPageListPage> createState() => _AdminCmsPageListPageState();
}

class _AdminCmsPageListPageState extends ConsumerState<AdminCmsPageListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
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

    return PosListPage(
  title: l10n.cmsPages,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add, onPressed: () {},
  ),
],
  child: Column(
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
                      PosDropdownItem(value: 'legal', label: l10n.adminPageTypeLegal),
                      PosDropdownItem(value: 'marketing', label: l10n.adminPageTypeMarketing),
                      PosDropdownItem(value: 'general', label: l10n.settingsGeneral),
                    ],
                    selectedValue: _selectedType,
                    onChanged: (v) {
                      setState(() => _selectedType = v);
                      _search();
                    },
                    hint: l10n.adminType,
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
                    ? Center(child: Text(l10n.adminNoPagesFound))
                    : ListView.builder(
                        itemCount: pages.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final page = pages[index];
                          return PosCard(
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
                                        : AppColors.borderFor(context),
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
