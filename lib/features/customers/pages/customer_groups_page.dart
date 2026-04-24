import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer_group.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';

class CustomerGroupsPage extends ConsumerStatefulWidget {
  const CustomerGroupsPage({super.key});

  @override
  ConsumerState<CustomerGroupsPage> createState() => _CustomerGroupsPageState();
}

class _CustomerGroupsPageState extends ConsumerState<CustomerGroupsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(customerGroupsProvider.notifier).load());
  }

  Future<void> _showForm({CustomerGroup? group}) async {
    final l10n = AppLocalizations.of(context)!;
    final name = TextEditingController(text: group?.name ?? '');
    final discount = TextEditingController(text: (group?.discountPercent ?? 0).toString());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(group == null ? l10n.customersGroupAdd : l10n.commonEdit),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          PosTextField(controller: name, label: l10n.customersGroupName),
          AppSpacing.gapH8,
          PosTextField(
            controller: discount,
            label: l10n.customersGroupDiscount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.commonSave)),
        ],
      ),
    );
    if (ok == true) {
      final data = {
        'name': name.text.trim(),
        'discount_percent': double.tryParse(discount.text.trim()) ?? 0,
      };
      await ref.read(customerGroupsProvider.notifier).createGroup(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(customerGroupsProvider);
    final isLoading = state is CustomerGroupsInitial || state is CustomerGroupsLoading;
    final error = state is CustomerGroupsError ? state.message : null;
    final groups = state is CustomerGroupsLoaded ? state.groups : const <CustomerGroup>[];

    return PosListPage(
      title: l10n.customersGroupsTitle,
      onBack: () => context.pop(),
      showSearch: false,
      actions: [
        PosButton(label: l10n.customersGroupAdd, icon: Icons.add, onPressed: () => _showForm()),
      ],
      child: PosDataTable<CustomerGroup>(
        items: groups,
        isLoading: isLoading,
        error: error,
        emptyConfig: PosTableEmptyConfig(
          icon: Icons.group_outlined,
          title: l10n.customersNoMatches,
          actionLabel: l10n.customersGroupAdd,
          action: _showForm,
        ),
        columns: [
          PosTableColumn(title: l10n.customersGroupName),
          PosTableColumn(title: l10n.customersGroupDiscount, numeric: true),
        ],
        cellBuilder: (g, i, c) {
          if (i == 0) return Text(g.name);
          return Text('${(g.discountPercent ?? 0).toStringAsFixed(2)}%');
        },
        actions: [
          PosTableRowAction<CustomerGroup>(
            label: l10n.commonEdit,
            icon: Icons.edit_outlined,
            onTap: (g) => _showForm(group: g),
          ),
          PosTableRowAction<CustomerGroup>(
            label: l10n.commonDelete,
            icon: Icons.delete_outline,
            isDestructive: true,
            onTap: (g) async {
              final ok = await showPosConfirmDialog(
                context,
                title: l10n.customersDeleteConfirm,
                message: g.name,
                confirmLabel: l10n.commonDelete,
                cancelLabel: l10n.cancel,
                isDanger: true,
              );
              if (ok == true) {
                await ref.read(customerGroupsProvider.notifier).deleteGroup(g.id);
              }
            },
          ),
        ],
      ),
    );
  }
}
