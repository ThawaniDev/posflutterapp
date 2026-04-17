import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';

class AdminStoreListPage extends ConsumerStatefulWidget {
  const AdminStoreListPage({super.key});

  @override
  ConsumerState<AdminStoreListPage> createState() => _AdminStoreListPageState();
}

class _AdminStoreListPageState extends ConsumerState<AdminStoreListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchController = TextEditingController();
  String? _storeId;
  bool? _activeFilter;
  String? _businessTypeFilter;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      _loadStores();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadStores() {
    ref
        .read(adminStoreListProvider.notifier)
        .load(
          search: _searchController.text.isEmpty ? null : _searchController.text,
          isActive: _activeFilter,
          businessType: _businessTypeFilter,
          storeId: _storeId,
          page: _currentPage,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _loadStores();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminStoreListProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business),
            tooltip: 'Create Store',
            onPressed: () => _showCreateStoreDialog(context),
          ),
          IconButton(icon: const Icon(Icons.file_download_outlined), tooltip: 'Export Stores', onPressed: () => _exportStores()),
        ],
      ),
      body: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // ─── Filter Bar ─────────────────────────────────
          Container(
            padding: AppSpacing.paddingAll16,
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              border: Border(bottom: BorderSide(color: AppColors.borderLight)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: _searchController,
                        hint: 'Search stores by name...',
                        prefixIcon: Icons.search,
                        onSubmitted: (_) {
                          _currentPage = 1;
                          _loadStores();
                        },
                      ),
                    ),
                    AppSpacing.gapW12,
                    PosButton(
                      label: l10n.search,
                      onPressed: () {
                        _currentPage = 1;
                        _loadStores();
                      },
                      size: PosButtonSize.md,
                    ),
                  ],
                ),
                AppSpacing.gapH12,
                Row(
                  children: [
                    _buildFilterChip(
                      label: l10n.all,
                      selected: _activeFilter == null,
                      onTap: () => setState(() {
                        _activeFilter = null;
                        _currentPage = 1;
                        _loadStores();
                      }),
                    ),
                    AppSpacing.gapW8,
                    _buildFilterChip(
                      label: l10n.active,
                      selected: _activeFilter == true,
                      onTap: () => setState(() {
                        _activeFilter = true;
                        _currentPage = 1;
                        _loadStores();
                      }),
                    ),
                    AppSpacing.gapW8,
                    _buildFilterChip(
                      label: l10n.suspended,
                      selected: _activeFilter == false,
                      onTap: () => setState(() {
                        _activeFilter = false;
                        _currentPage = 1;
                        _loadStores();
                      }),
                    ),
                    const Spacer(),
                    if (_businessTypeFilter != null)
                      Chip(
                        label: Text(_businessTypeFilter!),
                        onDeleted: () => setState(() {
                          _businessTypeFilter = null;
                          _currentPage = 1;
                          _loadStores();
                        }),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // ─── Content ────────────────────────────────────
          Expanded(child: _buildBody(state, theme)),
        ],
      ),
    );
  }

  Widget _buildFilterChip({required String label, required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary10 : Colors.transparent,
          borderRadius: AppRadius.borderFull,
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : AppColors.textSecondaryLight,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(AdminStoreListState state, ThemeData theme) {
    if (state is AdminStoreListLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is AdminStoreListError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppColors.error),
            AppSpacing.gapH12,
            Text(state.message, style: theme.textTheme.bodyMedium),
            AppSpacing.gapH16,
            PosButton(label: l10n.retry, variant: PosButtonVariant.outline, onPressed: _loadStores),
          ],
        ),
      );
    }
    if (state is AdminStoreListLoaded) {
      if (state.stores.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.store_outlined, size: 64, color: AppColors.textMutedLight),
              AppSpacing.gapH12,
              Text(l10n.noStoresFound, style: theme.textTheme.titleMedium),
              AppSpacing.gapH4,
              Text(l10n.adjustFilters, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight)),
            ],
          ),
        );
      }
      return Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: AppSpacing.paddingAll16,
              itemCount: state.stores.length,
              separatorBuilder: (_, __) => AppSpacing.gapH8,
              itemBuilder: (context, index) {
                final store = state.stores[index];
                return _buildStoreCard(store, theme);
              },
            ),
          ),
          _buildPagination(state, theme),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStoreCard(Map<String, dynamic> store, ThemeData theme) {
    final isActive = store['is_active'] == true;
    final storeName = store['name'] as String? ?? 'Unnamed Store';
    final businessType = store['business_type'] as String? ?? '';
    final orgName = (store['organization'] as Map?)?['name'] as String? ?? '';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.borderLg,
        side: BorderSide(color: AppColors.borderLight),
      ),
      child: InkWell(
        borderRadius: AppRadius.borderLg,
        onTap: () {
          final id = store['id']?.toString() ?? '';
          context.push('${Routes.adminStoreDetail}/$id');
        },
        child: Padding(
          padding: AppSpacing.paddingAll16,
          child: Row(
            children: [
              // Status dot
              Container(
                width: AppSizes.dotMd,
                height: AppSizes.dotMd,
                decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? AppColors.success : AppColors.error),
              ),
              AppSpacing.gapW12,
              // Store info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(storeName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                    if (orgName.isNotEmpty) ...[
                      AppSpacing.gapH2,
                      Text(orgName, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight)),
                    ],
                  ],
                ),
              ),
              // Business type chip
              if (businessType.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(color: AppColors.primary5, borderRadius: AppRadius.borderFull),
                  child: Text(
                    businessType,
                    style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w500),
                  ),
                ),
              AppSpacing.gapW8,
              Icon(Icons.chevron_right, color: AppColors.textMutedLight),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(AdminStoreListLoaded state, ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingAll16,
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Showing ${state.stores.length} of ${state.total} stores',
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: state.currentPage > 1
                    ? () {
                        _currentPage = state.currentPage - 1;
                        _loadStores();
                      }
                    : null,
              ),
              Text('Page ${state.currentPage} of ${state.lastPage}', style: theme.textTheme.bodySmall),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: state.currentPage < state.lastPage
                    ? () {
                        _currentPage = state.currentPage + 1;
                        _loadStores();
                      }
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateStoreDialog(BuildContext context) {
    final orgNameCtrl = TextEditingController();
    final storeNameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Create Store'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosTextField(controller: orgNameCtrl, label: 'Organization Name', hint: 'Enter organization name'),
              AppSpacing.gapH12,
              PosTextField(controller: storeNameCtrl, label: l10n.sidebarStoreName, hint: 'Enter store name'),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancel)),
            PosButton(
              label: l10n.create,
              onPressed: () {
                ref
                    .read(adminActionProvider.notifier)
                    .createStore(organizationName: orgNameCtrl.text, storeName: storeNameCtrl.text);
                Navigator.of(ctx).pop();
                _loadStores();
              },
            ),
          ],
        );
      },
    );
  }

  void _exportStores() {
    ref.read(adminActionProvider.notifier).reset();
    showPosInfoSnackbar(context, AppLocalizations.of(context)!.storeExportInitiated);
  }
}
