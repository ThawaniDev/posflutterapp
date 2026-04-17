import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../enums/making_charges_type.dart';
import '../enums/metal_type.dart';
import '../models/jewelry_product_detail.dart';
import '../providers/jewelry_providers.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProductDetailFormPage extends ConsumerStatefulWidget {
  final JewelryProductDetail? detail;
  const ProductDetailFormPage({super.key, this.detail});

  @override
  ConsumerState<ProductDetailFormPage> createState() => _ProductDetailFormPageState();
}

class _ProductDetailFormPageState extends ConsumerState<ProductDetailFormPage> {

  AppLocalizations get l10n => AppLocalizations.of(context)!;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;
  bool get _isEditing => widget.detail != null;

  String? _selectedProductId;
  late final TextEditingController _karatCtrl;
  late final TextEditingController _grossWeightCtrl;
  late final TextEditingController _netWeightCtrl;
  late final TextEditingController _makingChargesValueCtrl;
  late final TextEditingController _stoneTypeCtrl;
  late final TextEditingController _stoneWeightCtrl;
  late final TextEditingController _stoneCountCtrl;
  late final TextEditingController _certificateNumberCtrl;

  MetalType _metalType = MetalType.gold;
  MakingChargesType? _makingChargesType;

  @override
  void initState() {
    super.initState();
    final d = widget.detail;
    _selectedProductId = d?.productId;
    _karatCtrl = TextEditingController(text: d?.karat ?? '');
    _grossWeightCtrl = TextEditingController(text: d?.grossWeightG.toStringAsFixed(2) ?? '');
    _netWeightCtrl = TextEditingController(text: d?.netWeightG.toStringAsFixed(2) ?? '');
    _makingChargesValueCtrl = TextEditingController(text: d?.makingChargesValue.toStringAsFixed(2) ?? '');
    _stoneTypeCtrl = TextEditingController(text: d?.stoneType ?? '');
    _stoneWeightCtrl = TextEditingController(text: d?.stoneWeightCarat?.toStringAsFixed(2) ?? '');
    _stoneCountCtrl = TextEditingController(text: d?.stoneCount?.toString() ?? '');
    _certificateNumberCtrl = TextEditingController(text: d?.certificateNumber ?? '');
    if (d != null) {
      _metalType = d.metalType;
      _makingChargesType = d.makingChargesType;
    }
    Future.microtask(() => ref.read(productsProvider.notifier).load());
  }

  @override
  void dispose() {
    _karatCtrl.dispose();
    _grossWeightCtrl.dispose();
    _netWeightCtrl.dispose();
    _makingChargesValueCtrl.dispose();
    _stoneTypeCtrl.dispose();
    _stoneWeightCtrl.dispose();
    _stoneCountCtrl.dispose();
    _certificateNumberCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'product_id': _selectedProductId ?? '',
      'metal_type': _metalType.value,
      'gross_weight_g': double.parse(_grossWeightCtrl.text.trim()),
      'net_weight_g': double.parse(_netWeightCtrl.text.trim()),
      'making_charges_value': double.parse(_makingChargesValueCtrl.text.trim()),
      if (_karatCtrl.text.isNotEmpty) 'karat': _karatCtrl.text.trim(),
      if (_makingChargesType != null) 'making_charges_type': _makingChargesType!.value,
      if (_stoneTypeCtrl.text.isNotEmpty) 'stone_type': _stoneTypeCtrl.text.trim(),
      if (_stoneWeightCtrl.text.isNotEmpty) 'stone_weight_carat': double.parse(_stoneWeightCtrl.text.trim()),
      if (_stoneCountCtrl.text.isNotEmpty) 'stone_count': int.parse(_stoneCountCtrl.text.trim()),
      if (_certificateNumberCtrl.text.isNotEmpty) 'certificate_number': _certificateNumberCtrl.text.trim(),
    };

    final notifier = ref.read(jewelryProvider.notifier);
    if (_isEditing) {
      await notifier.updateProductDetail(widget.detail!.id, data);
    } else {
      await notifier.createProductDetail(data);
    }

    setState(() => _saving = false);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : <Product>[];
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Product Detail' : 'New Jewelry Detail')),
      bottomNavigationBar: Padding(
        padding: AppSpacing.paddingAll16,
        child: PosButton(
          label: _isEditing ? 'Update Detail' : 'Create Detail',
          onPressed: _saving ? null : _handleSave,
          isLoading: _saving,
          isFullWidth: true,
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PosSearchableDropdown<String>(
              label: l10n.wameedAIProduct,
              items: products.map((p) => PosDropdownItem(value: p.id, label: p.name)).toList(),
              selectedValue: _selectedProductId,
              onChanged: _isEditing ? null : (v) => setState(() => _selectedProductId = v),
              showSearch: true,
            ),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<MetalType>(
              label: l10n.jewelryMetalType,
              items: MetalType.values
                  .map((m) => PosDropdownItem(value: m, label: m.value[0].toUpperCase() + m.value.substring(1)))
                  .toList(),
              selectedValue: _metalType,
              onChanged: (v) {
                if (v != null) setState(() => _metalType = v);
              },
              showSearch: false,
              clearable: false,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _karatCtrl, label: l10n.jewelryKarat, hint: 'e.g. 24K, 22K, 18K'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _grossWeightCtrl,
                    label: 'Gross Weight (g)',
                    hint: 'e.g. 15.50',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _netWeightCtrl,
                    label: 'Net Weight (g)',
                    hint: 'e.g. 14.20',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<MakingChargesType>(
              label: 'Making Charges Type',
              items: MakingChargesType.values
                  .map((t) => PosDropdownItem(value: t, label: t.value[0].toUpperCase() + t.value.substring(1)))
                  .toList(),
              selectedValue: _makingChargesType,
              onChanged: (v) => setState(() => _makingChargesType = v),
              showSearch: false,
              clearable: false,
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _makingChargesValueCtrl,
              label: 'Making Charges Value',
              hint: 'e.g. 150.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: AppSpacing.lg),
            Text('Stone Details', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: AppSpacing.sm),
            PosTextField(controller: _stoneTypeCtrl, label: 'Stone Type (optional)', hint: 'e.g. Diamond, Ruby, Emerald'),
            SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _stoneWeightCtrl,
                    label: 'Weight (carat)',
                    hint: 'e.g. 1.50',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _stoneCountCtrl,
                    label: 'Count',
                    hint: 'e.g. 4',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            PosTextField(controller: _certificateNumberCtrl, label: 'Certificate Number (optional)', hint: 'GIA, IGI, etc.'),
          ],
        ),
      ),
    );
  }
}
