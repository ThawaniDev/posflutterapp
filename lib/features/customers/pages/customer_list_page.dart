import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(customersProvider.notifier).load();
      ref.read(customerGroupsProvider.notifier).load();
      // Best-effort sync (offline cache).
      ref.read(customerSyncProvider.notifier).sync();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    final groups = groupsState is CustomerGroupsLoaded ? groupsState.groups : const [];

    return PosListPage(
      title: l10n.customers,
      searchController: _searchController,
      searchHint: l10n.commonSearch,
      onSearchSubmitted: (value) =>
          ref.read(customersProvider.notifier).load(search: value, groupId: _selectedGroupId),
      filters: [
        if (groups.isNotEmpty)
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            tooltip: l10n.customersGroup,
            onSelected: (value) {
              setState(() => _selectedGroupId = value);
              ref.read(customersProvider.notifier).load(
                    search: _searchController.text.isEmpty ? null : _searchController.text,
                    groupId: value,
                  );
            },
            itemBuilder: (ctx) => [
              PopupMenuItem<String?>(value: null, child: Text(l10n.commonAll)),
              for (final g in groups)
                PopupMenuItem<String?>(value: g.id, child: Text(g.name)),
            ],
          ),
      ],
      actions: [
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
                )
            : null,
        onNextPage: loaded != null
            ? () => ref.read(customersProvider.notifier).load(
                  page: loaded.currentPage + 1,
                  search: loaded.searchQuery,
                  groupId: loaded.groupId,
                )
            : null,
      ),
    );
  }
}
