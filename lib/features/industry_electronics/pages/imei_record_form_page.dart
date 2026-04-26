import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/customers/enums/condition_grade.dart';
import 'package:wameedpos/features/industry_electronics/enums/device_imei_status.dart';
import 'package:wameedpos/features/industry_electronics/models/device_imei_record.dart';
import 'package:wameedpos/features/industry_electronics/providers/electronics_providers.dart';
import 'package:wameedpos/features/industry_electronics/repositories/electronics_repository.dart';
import 'package:wameedpos/features/industry_electronics/utils/imei_validator.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ImeiRecordFormPage extends ConsumerStatefulWidget {
  const ImeiRecordFormPage({super.key, this.record});
  final DeviceImeiRecord? record;

  @override
  ConsumerState<ImeiRecordFormPage> createState() => _ImeiRecordFormPageState();
}

class _ImeiRecordFormPageState extends ConsumerState<ImeiRecordFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool _checkingImei = false;
  ({bool valid, bool exists})? _imeiServerResult;
  bool get _isEditing => widget.record != null;

  String? _selectedProductId;
  late final TextEditingController _imeiCtrl;
  late final TextEditingController _imei2Ctrl;
  late final TextEditingController _serialNumberCtrl;
  late final TextEditingController _purchasePriceCtrl;
  ConditionGrade? _conditionGrade;
  DeviceImeiStatus? _status;
  DateTime? _warrantyEndDate;
  DateTime? _storeWarrantyEndDate;

  @override
  void initState() {
    super.initState();
    final r = widget.record;
    _selectedProductId = r?.productId;
    _imeiCtrl = TextEditingController(text: r?.imei ?? '');
    _imei2Ctrl = TextEditingController(text: r?.imei2 ?? '');
    _serialNumberCtrl = TextEditingController(text: r?.serialNumber ?? '');
    _purchasePriceCtrl = TextEditingController(text: r?.purchasePrice?.toStringAsFixed(2) ?? '');
    _conditionGrade = r?.conditionGrade;
    _status = r?.status;
    _warrantyEndDate = r?.warrantyEndDate;
    _storeWarrantyEndDate = r?.storeWarrantyEndDate;
    Future.microtask(() => ref.read(productsProvider.notifier).load());
  }

  @override
  void dispose() {
    _imeiCtrl.dispose();
    _imei2Ctrl.dispose();
    _serialNumberCtrl.dispose();
    _purchasePriceCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkImeiOnServer() async {
    final imei = _imeiCtrl.text.trim();
    if (!ImeiValidator.isValid(imei)) return;
    setState(() { _checkingImei = true; _imeiServerResult = null; });
    try {
      final result = await ref.read(electronicsRepositoryProvider).validateImei(imei);
      setState(() => _imeiServerResult = result);
    } catch (_) {
      // silently ignore server errors for the check
    } finally {
      setState(() => _checkingImei = false);
    }
  }

  Future<void> _pickDate({required bool isStoreWarranty}) async {
    final initial = isStoreWarranty ? _storeWarrantyEndDate : _warrantyEndDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() {
        if (isStoreWarranty) {
          _storeWarrantyEndDate = picked;
        } else {
          _warrantyEndDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? d) {
    if (d == null) return 'Not set';
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'product_id': _selectedProductId ?? '',
      'imei': _imeiCtrl.text.trim(),
      if (_imei2Ctrl.text.isNotEmpty) 'imei2': _imei2Ctrl.text.trim(),
      if (_serialNumberCtrl.text.isNotEmpty) 'serial_number': _serialNumberCtrl.text.trim(),
      if (_conditionGrade != null) 'condition_grade': _conditionGrade!.value,
      if (_purchasePriceCtrl.text.isNotEmpty) 'purchase_price': double.parse(_purchasePriceCtrl.text.trim()),
      if (_status != null) 'status': _status!.value,
      if (_warrantyEndDate != null) 'warranty_end_date': _warrantyEndDate!.toIso8601String().split('T').first,
      if (_storeWarrantyEndDate != null) 'store_warranty_end_date': _storeWarrantyEndDate!.toIso8601String().split('T').first,
    };

    final notifier = ref.read(electronicsProvider.notifier);
    if (_isEditing) {
      await notifier.updateImeiRecord(widget.record!.id, data);
    } else {
      await notifier.createImeiRecord(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : <Product>[];
    return PosFormPage(
      title: _isEditing ? l10n.electronicsEditImeiRecord : l10n.electronicsNewImeiRecord,
      bottomBar: PosButton(
          label: _isEditing ? l10n.electronicsUpdateRecord : l10n.electronicsCreateRecord,
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PosSearchableDropdown<String>(
              hint: l10n.selectProduct,
              label: l10n.wameedAIProduct,
              items: products.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
              selectedValue: _selectedProductId,
              onChanged: _isEditing ? null : (v) => setState(() => _selectedProductId = v),
              showSearch: true,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _imeiCtrl,
              label: l10n.electronicsImei,
              hint: l10n.electronicsImeiHint,
              keyboardType: TextInputType.number,
              validator: (v) => ImeiValidator.validate(v, errorMessage: l10n.electronicsInvalidImei),
              onChanged: (_) => setState(() => _imeiServerResult = null),
            ),
            Row(
              children: [
                if (_imeiServerResult != null) ...[
                  Icon(
                    _imeiServerResult!.exists ? Icons.warning_amber : Icons.check_circle_outline,
                    size: 16,
                    color: _imeiServerResult!.exists ? Theme.of(context).colorScheme.error : Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _imeiServerResult!.exists ? l10n.electronicsImeiDuplicate : l10n.electronicsImeiUnique,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: _imeiServerResult!.exists ? Theme.of(context).colorScheme.error : Colors.green,
                    ),
                  ),
                  const Spacer(),
                ],
                TextButton.icon(
                  onPressed: _checkingImei ? null : _checkImeiOnServer,
                  icon: _checkingImei
                      ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.cloud_done_outlined, size: 16),
                  label: Text(l10n.electronicsCheckImeiServer, style: const TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _imei2Ctrl,
              label: l10n.electronicsImei2Optional,
              hint: l10n.electronicsDualSimImei,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _serialNumberCtrl, label: l10n.electronicsSerialOptional, hint: l10n.electronicsSerialHint),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<ConditionGrade>(
              hint: l10n.selectGrade,
              label: l10n.electronicsConditionGrade,
              items: ConditionGrade.values.map((g) => PosDropdownItem(value: g, label: l10n.electronicsGradeValue(g.value))).toList(),
              selectedValue: _conditionGrade,
              onChanged: (v) => setState(() => _conditionGrade = v),
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _purchasePriceCtrl,
              label: l10n.electronicsPurchasePrice,
              hint: '0.000',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            if (_isEditing) ...[
              const SizedBox(height: AppSpacing.md),
              PosSearchableDropdown<DeviceImeiStatus>(
                hint: l10n.selectStatus,
                label: l10n.status,
                items: DeviceImeiStatus.values.map((s) => PosDropdownItem(value: s, label: s.value)).toList(),
                selectedValue: _status,
                onChanged: (v) => setState(() => _status = v),
                showSearch: false,
                clearable: false,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () => _pickDate(isStoreWarranty: false),
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: _formatDate(_warrantyEndDate)),
                  label: l10n.electronicsMfgWarrantyEnd,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            GestureDetector(
              onTap: () => _pickDate(isStoreWarranty: true),
              child: AbsorbPointer(
                child: PosTextField(
                  controller: TextEditingController(text: _formatDate(_storeWarrantyEndDate)),
                  label: l10n.electronicsStoreWarrantyEnd,
                  suffixIcon: Icons.calendar_today,
                  readOnly: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
