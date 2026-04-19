import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/models/customer.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/features/receivables/enums/receivable_enums.dart';
import 'package:wameedpos/features/receivables/providers/receivables_providers.dart';
import 'package:wameedpos/features/receivables/repositories/receivable_repository.dart';

class ReceivableFormPage extends ConsumerStatefulWidget {
  final String? receivableId;

  const ReceivableFormPage({super.key, this.receivableId});

  @override
  ConsumerState<ReceivableFormPage> createState() => _ReceivableFormPageState();
}

class _ReceivableFormPageState extends ConsumerState<ReceivableFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _referenceController = TextEditingController();

  bool get _isEdit => widget.receivableId != null;
  bool _isLoading = false;
  bool _isSaving = false;

  String? _selectedCustomerId;
  ReceivableType? _selectedType;
  ReceivableSource? _selectedSource;

  @override
  void initState() {
    super.initState();
    // Load customers for picker
    Future.microtask(() {
      ref.read(customersProvider.notifier).load();
      if (_isEdit) _loadExistingReceivable();
    });
  }

  Future<void> _loadExistingReceivable() async {
    setState(() => _isLoading = true);
    try {
      final receivable = await ref.read(receivableRepositoryProvider).getReceivable(widget.receivableId!);
      if (mounted) {
        setState(() {
          _selectedCustomerId = receivable.customerId;
          _selectedType = ReceivableType.fromValue(receivable.receivableType);
          _selectedSource = ReceivableSource.fromValue(receivable.source);
          _descriptionController.text = receivable.description ?? '';
          _descriptionArController.text = receivable.descriptionAr ?? '';
          _amountController.text = receivable.amount.toStringAsFixed(2);
          _notesController.text = receivable.notes ?? '';
          _referenceController.text = receivable.referenceNumber ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _descriptionArController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  String _typeLabel(ReceivableType type, AppLocalizations l10n) {
    switch (type) {
      case ReceivableType.creditSale:
        return l10n.receivablesTypeCreditSale;
      case ReceivableType.loan:
        return l10n.receivablesTypeLoan;
      case ReceivableType.inventoryAdjustment:
        return l10n.receivablesTypeInventoryAdjustment;
      case ReceivableType.manual:
        return l10n.receivablesTypeManual;
    }
  }

  String _sourceLabel(ReceivableSource source, AppLocalizations l10n) {
    switch (source) {
      case ReceivableSource.posTerminal:
        return l10n.receivablesSourcePosTerminal;
      case ReceivableSource.invoice:
        return l10n.receivablesSourceInvoice;
      case ReceivableSource.returnSource:
        return l10n.receivablesSourceReturn;
      case ReceivableSource.manual:
        return l10n.receivablesSourceManual;
      case ReceivableSource.inventorySystem:
        return l10n.receivablesSourceInventorySystem;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null || _selectedType == null || _selectedSource == null) return;

    setState(() => _isSaving = true);

    try {
      if (_isEdit) {
        final data = <String, dynamic>{
          'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          'description_ar': _descriptionArController.text.isNotEmpty ? _descriptionArController.text : null,
          'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
          'reference_number': _referenceController.text.isNotEmpty ? _referenceController.text : null,
        };
        await ref.read(receivablesProvider.notifier).updateReceivable(widget.receivableId!, data);
        if (mounted) {
          context.pop('updated');
        }
      } else {
        await ref
            .read(receivablesProvider.notifier)
            .createReceivable(
              customerId: _selectedCustomerId!,
              receivableType: _selectedType!.value,
              source: _selectedSource!.value,
              amount: double.parse(_amountController.text),
              description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
              descriptionAr: _descriptionArController.text.isNotEmpty ? _descriptionArController.text : null,
              notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              referenceNumber: _referenceController.text.isNotEmpty ? _referenceController.text : null,
            );
        if (mounted) {
          context.pop('created');
        }
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final customersState = ref.watch(customersProvider);
    final customers = customersState is CustomersLoaded ? customersState.customers : <Customer>[];

    return PosFormPage(
      title: _isEdit ? l10n.receivablesEdit : l10n.receivablesCreate,
      isLoading: _isLoading,
      bottomBar: PosButton(
        label: _isEdit ? l10n.save : l10n.receivablesCreate,
        onPressed: _isSaving ? null : _handleSave,
        isLoading: _isSaving,
        isFullWidth: true,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Customer picker
            PosSearchableDropdown<String>(
              items: customers.map((c) => PosDropdownItem(value: c.id, label: c.name, subtitle: c.phone)).toList(),
              selectedValue: _selectedCustomerId,
              onChanged: _isEdit ? null : (v) => setState(() => _selectedCustomerId = v),
              label: l10n.receivablesSelectCustomer,
              hint: l10n.receivablesSelectCustomer,
              showSearch: true,
              clearable: false,
              enabled: !_isEdit,
              validator: (v) => v == null ? l10n.receivablesSelectCustomer : null,
            ),
            AppSpacing.gapH16,

            // Type & Source row
            Row(
              children: [
                Expanded(
                  child: PosSearchableDropdown<ReceivableType>(
                    items: ReceivableType.values.map((t) => PosDropdownItem(value: t, label: _typeLabel(t, l10n))).toList(),
                    selectedValue: _selectedType,
                    onChanged: _isEdit ? null : (v) => setState(() => _selectedType = v),
                    label: l10n.receivablesSelectType,
                    hint: l10n.receivablesSelectType,
                    showSearch: false,
                    clearable: false,
                    enabled: !_isEdit,
                    validator: (v) => v == null ? l10n.receivablesSelectType : null,
                  ),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: PosSearchableDropdown<ReceivableSource>(
                    items: ReceivableSource.values.map((s) => PosDropdownItem(value: s, label: _sourceLabel(s, l10n))).toList(),
                    selectedValue: _selectedSource,
                    onChanged: _isEdit ? null : (v) => setState(() => _selectedSource = v),
                    label: l10n.receivablesSelectSource,
                    hint: l10n.receivablesSelectSource,
                    showSearch: false,
                    clearable: false,
                    enabled: !_isEdit,
                    validator: (v) => v == null ? l10n.receivablesSelectSource : null,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,

            // Amount
            PosTextField(
              controller: _amountController,
              label: l10n.receivablesAmount,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              readOnly: _isEdit,
            ),
            AppSpacing.gapH16,

            // Reference number
            PosTextField(controller: _referenceController, label: l10n.receivablesReferenceNumber, hint: l10n.receivablesReferenceNumber),
            AppSpacing.gapH16,

            // Description
            PosTextField(
              controller: _descriptionController,
              label: l10n.receivablesDescription,
              hint: l10n.receivablesDescription,
              maxLines: 2,
            ),
            AppSpacing.gapH16,

            // Description Arabic
            PosTextField(
              controller: _descriptionArController,
              label: l10n.receivablesDescriptionAr,
              hint: l10n.receivablesDescriptionAr,
              maxLines: 2,
              textDirection: TextDirection.rtl,
            ),
            AppSpacing.gapH16,

            // Notes
            PosTextField(
              controller: _notesController,
              label: l10n.commonNotesOptional,
              hint: l10n.commonNotesOptional,
              maxLines: 3,
            ),
            AppSpacing.gapH32,
          ],
        ),
      ),
    );
  }
}
