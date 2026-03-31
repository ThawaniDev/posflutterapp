import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/core/widgets/pos_table.dart';
import 'package:thawani_pos/features/catalog/models/supplier.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';

class SupplierListPage extends ConsumerStatefulWidget {
  const SupplierListPage({super.key});

  @override
  ConsumerState<SupplierListPage> createState() => _SupplierListPageState();
}

class _SupplierListPageState extends ConsumerState<SupplierListPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(suppliersProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _showSupplierDialog({Supplier? supplier}) async {
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final phoneController = TextEditingController(text: supplier?.phone ?? '');
    final emailController = TextEditingController(text: supplier?.email ?? '');
    final addressController = TextEditingController(text: supplier?.address ?? '');
    final notesController = TextEditingController(text: supplier?.notes ?? '');
    final isEditing = supplier != null;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Supplier' : 'New Supplier'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosTextField(controller: nameController, label: 'Supplier Name *', hint: 'Enter supplier name'),
              const SizedBox(height: AppSpacing.md),
              PosTextField(
                controller: phoneController,
                label: 'Phone',
                hint: '+968 XXXX XXXX',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              PosTextField(
                controller: emailController,
                label: 'Email',
                hint: 'supplier@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: addressController, label: 'Address', hint: 'Enter address', maxLines: 2),
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: notesController, label: 'Notes', hint: 'Any additional notes', maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;
              Navigator.pop(ctx, {
                'name': nameController.text.trim(),
                if (phoneController.text.trim().isNotEmpty) 'phone': phoneController.text.trim(),
                if (emailController.text.trim().isNotEmpty) 'email': emailController.text.trim(),
                if (addressController.text.trim().isNotEmpty) 'address': addressController.text.trim(),
                if (notesController.text.trim().isNotEmpty) 'notes': notesController.text.trim(),
              });
            },
            child: Text(isEditing ? 'Update' : 'Create'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      try {
        if (isEditing) {
          await ref.read(suppliersProvider.notifier).updateSupplier(supplier.id, result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Supplier updated.')));
        } else {
          await ref.read(suppliersProvider.notifier).createSupplier(result);
          if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Supplier created.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  Future<void> _handleDelete(Supplier supplier) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text('Are you sure you want to delete "${supplier.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        await ref.read(suppliersProvider.notifier).deleteSupplier(supplier.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Supplier "${supplier.name}" deleted.')));
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final suppliersState = ref.watch(suppliersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.read(suppliersProvider.notifier).load(),
          ),
        ],
      ),
      floatingActionButton: PosButton(label: 'New Supplier', icon: Icons.add, onPressed: () => _showSupplierDialog()),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: PosTextField(
              controller: _searchController,
              hint: 'Search suppliers...',
              prefixIcon: Icons.search,
              onSubmitted: (value) => ref.read(suppliersProvider.notifier).search(value),
              onChanged: (value) {
                if (value.isEmpty) ref.read(suppliersProvider.notifier).search(null);
              },
            ),
          ),
          Expanded(child: _buildBody(suppliersState)),
        ],
      ),
    );
  }

  Widget _buildBody(SuppliersState state) {
    final isLoading = state is SuppliersLoading || state is SuppliersInitial;
    final error = state is SuppliersError ? state.message : null;
    final suppliers = state is SuppliersLoaded ? state.suppliers : <Supplier>[];
    final loaded = state is SuppliersLoaded ? state : null;

    return PosDataTable<Supplier>(
      columns: const [
        PosTableColumn(title: 'Name'),
        PosTableColumn(title: 'Phone'),
        PosTableColumn(title: 'Email'),
      ],
      items: suppliers,
      isLoading: isLoading,
      error: error,
      onRetry: () => ref.read(suppliersProvider.notifier).load(),
      emptyConfig: const PosTableEmptyConfig(
        icon: Icons.local_shipping_outlined,
        title: 'No suppliers yet',
        subtitle: 'Add suppliers to track your product sources.',
      ),
      actions: [
        PosTableRowAction<Supplier>(
          label: 'Edit',
          icon: Icons.edit_outlined,
          onTap: (s) => _showSupplierDialog(supplier: s),
        ),
        PosTableRowAction<Supplier>(
          label: 'Delete',
          icon: Icons.delete_outline,
          isDestructive: true,
          onTap: (s) => _handleDelete(s),
        ),
      ],
      cellBuilder: (supplier, colIndex, col) {
        switch (colIndex) {
          case 0:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Icon(Icons.local_shipping_outlined, size: 18, color: AppColors.info),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(supplier.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              ],
            );
          case 1:
            return Text(supplier.phone ?? '—');
          case 2:
            return Text(supplier.email ?? '—');
          default:
            return const SizedBox.shrink();
        }
      },
      currentPage: loaded?.currentPage,
      totalPages: loaded?.lastPage,
      totalItems: loaded?.total,
      itemsPerPage: loaded?.perPage ?? 10,
      onPreviousPage: loaded != null ? () => ref.read(suppliersProvider.notifier).load(page: loaded.currentPage - 1) : null,
      onNextPage: loaded != null ? () => ref.read(suppliersProvider.notifier).load(page: loaded.currentPage + 1) : null,
    );
  }
}
