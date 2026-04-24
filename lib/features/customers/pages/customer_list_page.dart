import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

class CustomerListPage extends ConsumerStatefulWidget {
  const CustomerListPage({super.key});

  @override
  ConsumerState<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends ConsumerState<CustomerListPage> {
  final _searchController = TextEditingController();
  String? _selectedGroupId;
  bool? _hasLoyalty;
  DateTime? _lastVisitFrom;
  DateTime? _lastVisitTo;

  // Bulk-select state (Spec §4.1).
  final Set<String> _selectedIds = <String>{};

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(customersProvider.notifier).load();
      ref.read(customerGroupsProvider.notifier).load();
      ref.read(customerSyncProvider.notifier).sync();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reload() {
    _selectedIds.clear();
    ref.read(customersProvider.notifier).load(
          search: _searchController.text.isEmpty ? null : _searchController.text,
          groupId: _selectedGroupId,
          hasLoyalty: _hasLoyalty,
          lastVisitFrom: _lastVisitFrom,
          lastVisitTo: _lastVisitTo,
        );
  }

  Future<void> _confirmDelete(Customer c) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showPosConfirmDialog(
      context,
      title: l10n.customersDeleteConfirm,
      message: c.name,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.cancel,
      isDanger: true,
    );
    if (ok == true && mounted) {
      await ref.read(customersProvider.notifier).deleteCustomer(c.id);
      if (mounted) showPosSuccessSnackbar(context, l10n.customersDeleted);
    }
  }

  Future<void> _pickDateRange() async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: now,
      helpText: l10n.customersDateRange,
      initialDateRange: (_lastVisitFrom != null && _lastVisitTo != null)
          ? DateTimeRange(start: _lastVisitFrom!, end: _lastVisitTo!)
          : null,
    );
    if (picked != null) {
      setState(() {
        _lastVisitFrom = picked.start;
        _lastVisitTo = picked.end;
      });
      _reload();
    }
  }

  Future<void> _bulkAddToGroup(List<CustomerGroup> groups) async {
    if (_selectedIds.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    String? choice;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customersBulkAddToGroup),
        content: StatefulBuilder(
          builder: (ctx, setLocal) => DropdownButtonFormField<String?>(
            initialValue: choice,
            items: [
              DropdownMenuItem<String?>(value: null, child: Text(l10n.customersBulkRemoveGroup)),
              for (final g in groups)
                DropdownMenuItem<String?>(value: g.id, child: Text(g.name)),
            ],
            onChanged: (v) => setLocal(() => choice = v),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final n = await ref
        .read(customersProvider.notifier)
        .bulkAssignGroup(customerIds: _selectedIds.toList(), groupId: choice);
    if (mounted) {
      showPosSuccessSnackbar(context, l10n.customersBulkUpdated(n));
      setState(_selectedIds.clear);
    }
  }

  Future<void> _exportCsv(List<Customer> customers, List<CustomerGroup> groups) async {
    final l10n = AppLocalizations.of(context)!;
    final rows = <List<String>>[
      [
        'name',
        'phone',
        'email',
        'group',
        'loyalty_code',
        'loyalty_points',
        'store_credit',
        'total_spend',
        'visit_count',
        'last_visit_at',
      ],
    ];
    final filtered = _selectedIds.isEmpty
        ? customers
        : customers.where((c) => _selectedIds.contains(c.id)).toList();
    for (final c in filtered) {
      final groupName = groups.where((g) => g.id == c.groupId).map((g) => g.name).join();
      rows.add([
        c.name,
        c.phone,
        c.email ?? '',
        groupName,
        c.loyaltyCode ?? '',
        '${c.loyaltyPoints ?? 0}',
        (c.storeCreditBalance ?? 0).toStringAsFixed(2),
        (c.totalSpend ?? 0).toStringAsFixed(2),
        '${c.visitCount ?? 0}',
        c.lastVisitAt?.toIso8601String() ?? '',
      ]);
    }
    final csv = rows.map((r) => r.map(_csvEscape).join(',')).join('\n');

    String savedPath;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final ts = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final file = File('${dir.path}${Platform.pathSeparator}customers_$ts.csv');
      await file.writeAsString(csv, flush: true);
      savedPath = file.path;
    } catch (_) {
      // Fallback: copy CSV content to clipboard so the user still gets it.
      await Clipboard.setData(ClipboardData(text: csv));
      savedPath = 'clipboard';
    }
    if (mounted) {
      showPosSuccessSnackbar(context, l10n.customersExportSaved(savedPath));
    }
  }

  String _csvEscape(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      final escaped = value.replaceAll('"', '""');
      return '"$escaped"';
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customersProvider);
    final groupsState = ref.watch(customerGroupsProvider);
    final syncState = ref.watch(customerSyncProvider);

    final isLoading = state is CustomersInitial || state is CustomersLoading;
    final hasError = state is CustomersError;
    final errorMessage = state is CustomersError ? state.message : null;
    final customers = state is CustomersLoaded ? state.customers : const <Customer>[];
    final loaded = state is CustomersLoaded ? state : null;
    final groups = groupsState is CustomerGroupsLoaded ? groupsState.groups : const <CustomerGroup>[];

    final filtersActive = _selectedGroupId != null ||
        _hasLoyalty != null ||
        _lastVisitFrom != null ||
        _lastVisitTo != null;
    final hasSelection = _selectedIds.isNotEmpty;

    return PosListPage(
      title: hasSelection
          ? l10n.customersSelectionCount(_selectedIds.length)
          : l10n.customers,
      searchController: _searchController,
      searchHint: l10n.commonSearch,
      onSearchSubmitted: (_) => _reload(),
      filters: [
        if (groups.isNotEmpty)
          PopupMenuButton<String?>(
            icon: const Icon(Icons.groups_outlined),
            tooltip: l10n.customersGroup,
            onSelected: (value) {
              setState(() => _selectedGroupId = value);
              _reload();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem<String?>(value: null, child: Text(l10n.commonAll)),
              for (final g in groups)
                PopupMenuItem<String?>(value: g.id, child: Text(g.name)),
            ],
          ),
        PopupMenuButton<bool?>(
          icon: const Icon(Icons.workspace_premium_outlined),
          tooltip: l10n.customersHasLoyalty,
          onSelected: (value) {
            setState(() => _hasLoyalty = value);
            _reload();
          },
          itemBuilder: (ctx) => [
            PopupMenuItem<bool?>(value: null, child: Text(l10n.commonAll)),
            PopupMenuItem<bool?>(value: true, child: Text(l10n.customersHasLoyalty)),
            PopupMenuItem<bool?>(value: false, child: Text(l10n.customersWithoutLoyalty)),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.event_outlined),
          tooltip: l10n.customersDateRange,
          onPressed: _pickDateRange,
        ),
        if (filtersActive)
          IconButton(
            icon: const Icon(Icons.filter_alt_off_outlined),
            tooltip: l10n.customersClearFilters,
            onPressed: () {
              setState(() {
                _selectedGroupId = null;
                _hasLoyalty = null;
                _lastVisitFrom = null;
                _lastVisitTo = null;
              });
              _reload();
            },
          ),
      ],
      actions: hasSelection
          ? [
              PosButton.icon(
                icon: Icons.group_add_outlined,
                tooltip: l10n.customersBulkAddToGroup,
                onPressed: () => _bulkAddToGroup(groups),
                variant: PosButtonVariant.ghost,
              ),
              PosButton.icon(
                icon: Icons.download_outlined,
                tooltip: l10n.customersBulkExportCsv,
                onPressed: () => _exportCsv(customers, groups),
                variant: PosButtonVariant.ghost,
              ),
              PosButton.icon(
                icon: Icons.close,
                tooltip: l10n.cancel,
                onPressed: () => setState(_selectedIds.clear),
                variant: PosButtonVariant.ghost,
              ),
            ]
          : [
              PosButton.icon(
                icon: Icons.sync,
                tooltip: l10n.customersSync,
                onPressed: syncState is CustomerSyncRunning
                    ? null
                    : () async {
                        await ref.read(customerSyncProvider.notifier).sync(force: true);
                        if (mounted) showPosSuccessSnackbar(context, l10n.customersSynced);
                      },
                variant: PosButtonVariant.ghost,
              ),
              PosButton.icon(
                icon: Icons.download_outlined,
                tooltip: l10n.customersBulkExportCsv,
                onPressed: () => _exportCsv(customers, groups),
                variant: PosButtonVariant.ghost,
              ),
              PosButton.icon(
                icon: Icons.group_outlined,
                tooltip: l10n.customersGroupsTitle,
                onPressed: () => context.push(Routes.customerGroups),
                variant: PosButtonVariant.ghost,
              ),
              PosButton.icon(
                icon: Icons.workspace_premium_outlined,
                tooltip: l10n.customersLoyaltyConfig,
                onPressed: () => context.push(Routes.loyaltyConfig),
                variant: PosButtonVariant.ghost,
              ),
              PosButton(
                label: l10n.customersAdd,
                icon: Icons.add,
                onPressed: () => context.push(Routes.customerCreate),
              ),
            ],
      child: PosDataTable<Customer>(
        items: customers,
        isLoading: isLoading,
        error: hasError ? errorMessage : null,
        onRetry: () => ref.read(customersProvider.notifier).load(),
        selectable: true,
        itemId: (c) => c.id,
        selectedItems: _selectedIds,
        onSelectItem: (c, sel) => setState(() {
          sel ? _selectedIds.add(c.id) : _selectedIds.remove(c.id);
        }),
        onSelectAll: (sel) => setState(() {
          if (sel) {
            _selectedIds
              ..clear()
              ..addAll(customers.map((c) => c.id));
          } else {
            _selectedIds.clear();
          }
        }),
        emptyConfig: PosTableEmptyConfig(
          icon: Icons.people_outline_rounded,
          title: l10n.customersNoCustomersFound,
          actionLabel: l10n.customersAdd,
          action: () => context.push(Routes.customerCreate),
        ),
        columns: [
          PosTableColumn(title: l10n.customersName),
          PosTableColumn(title: l10n.customersPhone),
          PosTableColumn(title: l10n.customersEmail),
          PosTableColumn(title: l10n.customersGroup),
          PosTableColumn(title: l10n.customersTotalSpend, numeric: true),
          PosTableColumn(title: l10n.customersVisitCount, numeric: true),
          PosTableColumn(title: l10n.customersLoyaltyPoints, numeric: true),
          PosTableColumn(title: l10n.customersLastVisit),
        ],
        onRowTap: (c) => context.push('/customers/${c.id}'),
        cellBuilder: (c, colIndex, col) {
          switch (colIndex) {
            case 0:
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PosAvatar(name: c.name, radius: 14),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(c.name,
                        style: const TextStyle(fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            case 1:
              return Text(c.phone);
            case 2:
              return Text(c.email ?? '-');
            case 3:
              final groupName = groups
                  .where((g) => g.id == c.groupId)
                  .map((g) => g.name)
                  .firstWhere((_) => true, orElse: () => '-');
              return Text(groupName);
            case 4:
              return Text((c.totalSpend ?? 0).toStringAsFixed(2));
            case 5:
              return Text('${c.visitCount ?? 0}');
            case 6:
              return Text('${c.loyaltyPoints ?? 0}');
            case 7:
              return Text(c.lastVisitAt != null
                  ? '${c.lastVisitAt!.year}-${c.lastVisitAt!.month.toString().padLeft(2, '0')}-${c.lastVisitAt!.day.toString().padLeft(2, '0')}'
                  : '-');
            default:
              return const SizedBox.shrink();
          }
        },
        actions: [
          PosTableRowAction<Customer>(
            label: l10n.commonEdit,
            icon: Icons.edit_outlined,
            onTap: (c) => context.push('/customers/${c.id}/edit'),
          ),
          PosTableRowAction<Customer>(
            label: l10n.commonDelete,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: _confirmDelete,
          ),
        ],
        currentPage: loaded?.currentPage,
        totalPages: loaded?.lastPage,
        totalItems: loaded?.total,
        itemsPerPage: loaded?.perPage ?? 25,
        onPreviousPage: loaded != null
            ? () => ref.read(customersProvider.notifier).load(
                  page: loaded.currentPage - 1,
                  search: loaded.searchQuery,
                  groupId: loaded.groupId,
                  hasLoyalty: loaded.hasLoyalty,
                  lastVisitFrom: loaded.lastVisitFrom,
                  lastVisitTo: loaded.lastVisitTo,
                )
            : null,
        onNextPage: loaded != null
            ? () => ref.read(customersProvider.notifier).load(
                  page: loaded.currentPage + 1,
                  search: loaded.searchQuery,
                  groupId: loaded.groupId,
                  hasLoyalty: loaded.hasLoyalty,
                  lastVisitFrom: loaded.lastVisitFrom,
                  lastVisitTo: loaded.lastVisitTo,
                )
            : null,
      ),
    );
  }
}
