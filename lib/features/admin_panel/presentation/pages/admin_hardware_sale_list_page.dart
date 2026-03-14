import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_providers.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

class AdminHardwareSaleListPage extends ConsumerStatefulWidget {
  const AdminHardwareSaleListPage({super.key});

  @override
  ConsumerState<AdminHardwareSaleListPage> createState() => _AdminHardwareSaleListPageState();
}

class _AdminHardwareSaleListPageState extends ConsumerState<AdminHardwareSaleListPage> {
  final _searchCtrl = TextEditingController();
  String _typeFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(hardwareSaleListProvider.notifier).loadSales());
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
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(hardwareSaleListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hardware Sales'), backgroundColor: AppColors.primary, foregroundColor: Colors.white),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                    ? const Center(child: Text('No hardware sales found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        itemCount: items.length,
                        itemBuilder: (context, index) => _saleCard(items[index]),
                      ),
              HardwareSaleListError(message: final msg) => Center(child: Text('Error: $msg')),
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

    return Card(
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
                      Text(type.toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                Text('${sale['amount'] ?? 0} SAR', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            if (sale['serial_number'] != null)
              Text('S/N: ${sale['serial_number']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (sale['store_name'] != null)
              Text('Store: ${sale['store_name']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            if (sale['sold_at'] != null)
              Text('Sold: ${sale['sold_at']}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                  onPressed: () => _showEditDialog(sale),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                  label: const Text('Delete', style: TextStyle(color: Colors.red)),
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
        title: const Text('Record Hardware Sale'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setInnerState) => DropdownButtonFormField<String>(
                  value: itemType,
                  items: [
                    'terminal',
                    'printer',
                    'scanner',
                    'other',
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setInnerState(() => itemType = v ?? itemType),
                  decoration: const InputDecoration(labelText: 'Item Type'),
                ),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: serialCtrl,
                decoration: const InputDecoration(labelText: 'Serial Number'),
              ),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (SAR)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
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
            child: const Text('Create'),
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
        title: const Text('Edit Hardware Sale'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: amountCtrl,
                decoration: const InputDecoration(labelText: 'Amount (SAR)'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: notesCtrl,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () async {
              await ref.read(hardwareSaleActionProvider.notifier).updateSale(sale['id'], {
                'item_description': descCtrl.text,
                'amount': double.tryParse(amountCtrl.text) ?? 0,
                'notes': notesCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(hardwareSaleListProvider.notifier).loadSales();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text('Are you sure you want to delete this hardware sale?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await ref.read(hardwareSaleActionProvider.notifier).deleteSale(id);
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(hardwareSaleListProvider.notifier).loadSales();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
