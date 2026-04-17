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
import 'package:wameedpos/features/debits/enums/debit_enums.dart';
import 'package:wameedpos/features/debits/providers/debits_providers.dart';
import 'package:wameedpos/features/debits/repositories/debit_repository.dart';

class DebitFormPage extends ConsumerStatefulWidget {
  final String? debitId;

  const DebitFormPage({super.key, this.debitId});

  @override
  ConsumerState<DebitFormPage> createState() => _DebitFormPageState();
}

class _DebitFormPageState extends ConsumerState<DebitFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _descriptionArController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _referenceController = TextEditingController();

  bool get _isEdit => widget.debitId != null;
  bool _isLoading = false;
  bool _isSaving = false;

  String? _selectedCustomerId;
  DebitType? _selectedType;
  DebitSource? _selectedSource;

  @override
  void initState() {
    super.initState();
    // Load customers for picker
    Future.microtask(() {
      ref.read(customersProvider.notifier).load();
      if (_isEdit) _loadExistingDebit();
    });
  }

  Future<void> _loadExistingDebit() async {
    setState(() => _isLoading = true);
    try {
      final debit = await ref.read(debitRepositoryProvider).getDebit(widget.debitId!);
      if (mounted) {
        setState(() {
          _selectedCustomerId = debit.customerId;
          _selectedType = DebitType.fromValue(debit.debitType);
          _selectedSource = DebitSource.fromValue(debit.source);
          _descriptionController.text = debit.description ?? '';
          _descriptionArController.text = debit.descriptionAr ?? '';
          _amountController.text = debit.amount.toStringAsFixed(2);
          _notesController.text = debit.notes ?? '';
          _referenceController.text = debit.referenceNumber ?? '';
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

  String _typeLabel(DebitType type, AppLocalizations l10n) {
    switch (type) {
      case DebitType.customerCredit:
        return l10n.debitsTypeCustomerCredit;
      case DebitType.supplierReturn:
        return l10n.debitsTypeSupplierReturn;
      case DebitType.inventoryAdjustment:
        return l10n.debitsTypeInventoryAdjustment;
      case DebitType.manualCredit:
        return l10n.debitsTypeManualCredit;
    }
  }

  String _sourceLabel(DebitSource source, AppLocalizations l10n) {
    switch (source) {
      case DebitSource.posTerminal:
        return l10n.debitsSourcePosTerminal;
      case DebitSource.invoice:
        return l10n.debitsSourceInvoice;
      case DebitSource.returnSource:
        return l10n.debitsSourceReturn;
      case DebitSource.manual:
        return l10n.debitsSourceManual;
      case DebitSource.inventorySystem:
        return l10n.debitsSourceInventorySystem;
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCustomerId == null || _selectedType == null || _selectedSource == null) return;

    setState(() => _isSaving = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      if (_isEdit) {
        final data = <String, dynamic>{
          'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
          'description_ar': _descriptionArController.text.isNotEmpty ? _descriptionArController.text : null,
          'notes': _notesController.text.isNotEmpty ? _notesController.text : null,
          'reference_number': _referenceController.text.isNotEmpty ? _referenceController.text : null,
        };
        await ref.read(debitsProvider.notifier).updateDebit(widget.debitId!, data);
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.debitsUpdatedSuccess);
          context.pop();
        }
      } else {
        await ref
            .read(debitsProvider.notifier)
            .createDebit(
              customerId: _selectedCustomerId!,
              debitType: _selectedType!.value,
              source: _selectedSource!.value,
              amount: double.parse(_amountController.text),
              description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
              descriptionAr: _descriptionArController.text.isNotEmpty ? _descriptionArController.text : null,
              notes: _notesController.text.isNotEmpty ? _notesController.text : null,
              referenceNumber: _referenceController.text.isNotEmpty ? _referenceController.text : null,
            );
        if (mounted) {
          showPosSuccessSnackbar(context, l10n.debitsCreatedSuccess);
          context.pop();
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
      title: _isEdit ? l10n.debitsEdit : l10n.debitsCreate,
      isLoading: _isLoading,
      bottomBar: PosButton(
        label: _isEdit ? l10n.save : l10n.debitsCreate,
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
              label: l10n.debitsSelectCustomer,
              hint: l10n.debitsSelectCustomer,
              showSearch: true,
              clearable: false,
              enabled: !_isEdit,
              validator: (v) => v == null ? l10n.debitsSelectCustomer : null,
            ),
            AppSpacing.gapH16,

            // Type & Source row
            Row(
              children: [
                Expanded(
                  child: PosSearchableDropdown<DebitType>(
                    items: DebitType.values.map((t) => PosDropdownItem(value: t, label: _typeLabel(t, l10n))).toList(),
                    selectedValue: _selectedType,
                    onChanged: _isEdit ? null : (v) => setState(() => _selectedType = v),
                    label: l10n.debitsSelectType,
                    hint: l10n.debitsSelectType,
                    showSearch: false,
                    clearable: false,
                    enabled: !_isEdit,
                    validator: (v) => v == null ? l10n.debitsSelectType : null,
                  ),
                ),
                AppSpacing.gapW16,
                Expanded(
                  child: PosSearchableDropdown<DebitSource>(
                    items: DebitSource.values.map((s) => PosDropdownItem(value: s, label: _sourceLabel(s, l10n))).toList(),
                    selectedValue: _selectedSource,
                    onChanged: _isEdit ? null : (v) => setState(() => _selectedSource = v),
                    label: l10n.debitsSelectSource,
                    hint: l10n.debitsSelectSource,
                    showSearch: false,
                    clearable: false,
                    enabled: !_isEdit,
                    validator: (v) => v == null ? l10n.debitsSelectSource : null,
                  ),
                ),
              ],
            ),
            AppSpacing.gapH16,

            // Amount
            PosTextField(
              controller: _amountController,
              label: l10n.debitsAmount,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))],
              readOnly: _isEdit,
            ),
            AppSpacing.gapH16,

            // Reference number
            PosTextField(controller: _referenceController, label: l10n.debitsReferenceNumber, hint: l10n.debitsReferenceNumber),
            AppSpacing.gapH16,

            // Description
            PosTextField(
              controller: _descriptionController,
              label: l10n.debitsDescription,
              hint: l10n.debitsDescription,
              maxLines: 2,
            ),
            AppSpacing.gapH16,

            // Description Arabic
            PosTextField(
              controller: _descriptionArController,
              label: l10n.debitsDescriptionAr,
              hint: l10n.debitsDescriptionAr,
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
