import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/features/admin_panel/widgets/admin_branch_bar.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminHardwareSaleListPage extends ConsumerStatefulWidget {
  const AdminHardwareSaleListPage({super.key});

  @override
  ConsumerState<AdminHardwareSaleListPage> createState() => _AdminHardwareSaleListPageState();
}

class _AdminHardwareSaleListPageState extends ConsumerState<AdminHardwareSaleListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _searchCtrl = TextEditingController();
  String? _storeId;
  String _typeFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(hardwareSaleListProvider.notifier).loadSales(storeId: _storeId);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(hardwareSaleListProvider.notifier)
        .loadSales(
          search: _searchCtrl.text.isEmpty ? null : _searchCtrl.text,
          itemType: _typeFilter == 'all' ? null : _typeFilter,
          storeId: _storeId,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hardwareSaleListProvider);

    return PosListPage(
      title: l10n.hardwareSales,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.add, onPressed: _showCreateDialog, tooltip: l10n.adminAdd)],
      child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // Search
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search by description or serial...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchCtrl.clear();
                    _applyFilters();
                  },
                ),
                border: OutlineInputBorder(borderRadius: AppRadius.borderMd),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),

          // Type filter chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip('All', 'all'),
                  const SizedBox(width: AppSpacing.xs),
                  _filterChip('Terminal', 'terminal'),
                  const SizedBox(width: AppSpacing.xs),
                  _filterChip('Printer', 'printer'),
                  const SizedBox(width: AppSpacing.xs),
                  _filterChip('Scanner', 'scanner'),
                  const SizedBox(width: AppSpacing.xs),
                  _filterChip('Other', 'other'),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),

          Expanded(
            child: switch (state) {
              HardwareSaleListLoading() => const Center(child: CircularProgressIndicator()),
              HardwareSaleListLoaded(sales: final items) =>
                items.isEmpty
                    ? Center(child: Text(l10n.adminNoHardwareSales))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        itemCount: items.length,
                        itemBuilder: (context, index) => _saleCard(items[index]),
                      ),
              HardwareSaleListError(message: final msg) => Center(child: Text(l10n.genericError(msg))),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final selected = _typeFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      onSelected: (_) {
        setState(() => _typeFilter = value);
        _applyFilters();
      },
    );
  }

  Widget _saleCard(Map<String, dynamic> sale) {
    final typeIcons = {
      'terminal': Icons.point_of_sale,
      'printer': Icons.print,
      'scanner': Icons.qr_code_scanner,
      'other': Icons.devices_other,
    };
    final type = sale['item_type'] ?? 'other';

    return PosCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcons[type] ?? Icons.devices_other, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(sale['item_description'] ?? type, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(type.toUpperCase(), style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                    ],
                  ),
                ),
                Text('${sale['amount'] ?? 0} \u0081', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (sale['serial_number'] != null)
              Text('S/N: ${sale['serial_number']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            if (sale['store_name'] != null)
              Text('Store: ${sale['store_name']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            if (sale['sold_at'] != null)
              Text('Sold: ${sale['sold_at']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.edit),
                  onPressed: () => _showEditDialog(sale),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: Text(l10n.delete, style: TextStyle(color: AppColors.error)),
                  onPressed: () => _confirmDelete(sale['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    final descCtrl = TextEditingController();
    final serialCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String itemType = 'terminal';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminRecordHardwareSale),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setInnerState) => PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'terminal', label: l10n.terminal),
                    PosDropdownItem(value: 'printer', label: l10n.hardwarePrinter),
                    PosDropdownItem(value: 'scanner', label: l10n.adminItemTypeScanner),
                    PosDropdownItem(value: 'other', label: l10n.acquirerOther),
                  ],
                  selectedValue: itemType,
                  onChanged: (v) => setInnerState(() => itemType = v ?? itemType),
                  label: l10n.adminItemType,
                  hint: l10n.adminSelectItemType,
                  showSearch: false,
                  clearable: false,
                ),
              ),
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(labelText: l10n.description),
              ),
              TextField(
                controller: serialCtrl,
                decoration: InputDecoration(labelText: l10n.serialNumber),
              ),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (\u0081)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: l10n.posNotes),
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () async {
              await ref.read(hardwareSaleActionProvider.notifier).createSale({
                'item_type': itemType,
                'item_description': descCtrl.text,
                'serial_number': serialCtrl.text,
                'amount': double.tryParse(amountCtrl.text) ?? 0,
                'notes': notesCtrl.text,
                'store_id': 1,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(hardwareSaleListProvider.notifier).loadSales();
            },
            label: l10n.create,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> sale) {
    final descCtrl = TextEditingController(text: sale['item_description'] ?? '');
    final amountCtrl = TextEditingController(text: '${sale['amount'] ?? ''}');
    final notesCtrl = TextEditingController(text: sale['notes'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.adminEditHardwareSale),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descCtrl,
                decoration: InputDecoration(labelText: l10n.description),
              ),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (\u0081)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: l10n.posNotes),
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () async {
              await ref.read(hardwareSaleActionProvider.notifier).updateSale(sale['id'], {
                'item_description': descCtrl.text,
                'amount': double.tryParse(amountCtrl.text) ?? 0,
                'notes': notesCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(hardwareSaleListProvider.notifier).loadSales();
            },
            label: l10n.hwUpdate,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.adminDeleteSale,
      message: l10n.adminDeleteSaleConfirm,
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      await ref.read(hardwareSaleActionProvider.notifier).deleteSale(id.toString());
      ref.read(hardwareSaleListProvider.notifier).loadSales();
    }
  }
}
