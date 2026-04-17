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

class AdminImplementationFeeListPage extends ConsumerStatefulWidget {
  const AdminImplementationFeeListPage({super.key});

  @override
  ConsumerState<AdminImplementationFeeListPage> createState() => _AdminImplementationFeeListPageState();
}

class _AdminImplementationFeeListPageState extends ConsumerState<AdminImplementationFeeListPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _storeId;
  String _typeFilter = 'all';
  String _statusFilter = 'all';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _storeId = ref.read(resolvedStoreIdProvider);
      ref.read(implementationFeeListProvider.notifier).loadFees(storeId: _storeId);
    });
  }

  void _applyFilters() {
    ref
        .read(implementationFeeListProvider.notifier)
        .loadFees(
          feeType: _typeFilter == 'all' ? null : _typeFilter,
          status: _statusFilter == 'all' ? null : _statusFilter,
          storeId: _storeId,
        );
  }

  void _onBranchChanged(String? storeId) {
    setState(() => _storeId = storeId);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(implementationFeeListProvider);

    return PosListPage(
  title: l10n.implementationFees,
  showSearch: false,
  actions: [
  PosButton.icon(
    icon: Icons.add,
    onPressed: _showCreateDialog,
    tooltip: 'Add',
  ),
],
  child: Column(
        children: [
          AdminBranchBar(selectedStoreId: _storeId, onBranchChanged: _onBranchChanged),
          // Type filter
          Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _typeChip('All', 'all'),
                  const SizedBox(width: AppSpacing.xs),
                  _typeChip('Setup', 'setup'),
                  const SizedBox(width: AppSpacing.xs),
                  _typeChip('Training', 'training'),
                  const SizedBox(width: AppSpacing.xs),
                  _typeChip('Custom Dev', 'custom_dev'),
                ],
              ),
            ),
          ),
          // Status filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              children: [
                _statusChip('All', 'all'),
                const SizedBox(width: AppSpacing.xs),
                _statusChip('Invoiced', 'invoiced'),
                const SizedBox(width: AppSpacing.xs),
                _statusChip('Paid', 'paid'),
              ],
            ),
          ),

          Expanded(
            child: switch (state) {
              ImplementationFeeListLoading() => const Center(child: CircularProgressIndicator()),
              ImplementationFeeListLoaded(fees: final items) =>
                items.isEmpty
                    ? const Center(child: Text('No implementation fees found'))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        itemCount: items.length,
                        itemBuilder: (context, index) => _feeCard(items[index]),
                      ),
              ImplementationFeeListError(message: final msg) => Center(child: Text('Error: $msg')),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
);
  }

  Widget _typeChip(String label, String value) {
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

  Widget _statusChip(String label, String value) {
    final selected = _statusFilter == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      selectedColor: AppColors.info.withValues(alpha: 0.2),
      onSelected: (_) {
        setState(() => _statusFilter = value);
        _applyFilters();
      },
    );
  }

  Widget _feeCard(Map<String, dynamic> fee) {
    final type = fee['fee_type'] ?? '';
    final status = fee['status'] ?? '';
    final isPaid = status == 'paid';
    final typeIcons = {'setup': Icons.settings, 'training': Icons.school, 'custom_dev': Icons.code};

    return PosCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(typeIcons[type] ?? Icons.receipt, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        type.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      if (fee['store_name'] != null)
                        Text('Store: ${fee['store_name']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
                Text('${fee['amount'] ?? 0} \u0081', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPaid ? AppColors.success.withValues(alpha: 0.15) : AppColors.warning.withValues(alpha: 0.15),
                    borderRadius: AppRadius.borderLg,
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isPaid ? AppColors.successDark : AppColors.warningDark,
                    ),
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  icon: const Icon(Icons.edit, size: 16),
                  label: Text(l10n.edit),
                  onPressed: () => _showEditDialog(fee),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete, size: 16, color: AppColors.error),
                  label: Text(l10n.delete, style: TextStyle(color: AppColors.error)),
                  onPressed: () => _confirmDelete(fee['id']),
                ),
              ],
            ),
            if (fee['notes'] != null && (fee['notes'] as String).isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: Text('Notes: ${fee['notes']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ),
          ],
        ),
      ),
    );
  }

  void _showCreateDialog() {
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String feeType = 'setup';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Implementation Fee'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setInnerState) => PosSearchableDropdown<String>(
                  items: [
                    PosDropdownItem(value: 'setup', label: 'Setup'),
                    PosDropdownItem(value: 'training', label: 'Training'),
                    PosDropdownItem(value: 'custom_dev', label: 'Custom Dev'),
                  ],
                  selectedValue: feeType,
                  onChanged: (v) => setInnerState(() => feeType = v ?? feeType),
                  label: 'Fee Type',
                  hint: 'Select fee type',
                  showSearch: false,
                  clearable: false,
                ),
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
              await ref.read(implementationFeeActionProvider.notifier).createFee({
                'fee_type': feeType,
                'amount': double.tryParse(amountCtrl.text) ?? 0,
                'notes': notesCtrl.text,
                'store_id': 1,
                'status': 'invoiced',
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(implementationFeeListProvider.notifier).loadFees();
            },
            label: l10n.create,
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> fee) {
    final amountCtrl = TextEditingController(text: '${fee['amount'] ?? ''}');
    final notesCtrl = TextEditingController(text: fee['notes'] ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Implementation Fee'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              await ref.read(implementationFeeActionProvider.notifier).updateFee(fee['id'], {
                'amount': double.tryParse(amountCtrl.text) ?? 0,
                'notes': notesCtrl.text,
              });
              if (ctx.mounted) Navigator.pop(ctx);
              ref.read(implementationFeeListProvider.notifier).loadFees();
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
      title: 'Delete Fee',
      message: 'Are you sure you want to delete this implementation fee?',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDanger: true,
    );
    if (confirmed == true) {
      await ref.read(implementationFeeActionProvider.notifier).deleteFee(id.toString());
      ref.read(implementationFeeListProvider.notifier).loadFees();
    }
  }
}
