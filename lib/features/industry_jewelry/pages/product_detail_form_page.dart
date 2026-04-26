import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_jewelry/enums/making_charges_type.dart';
import 'package:wameedpos/features/industry_jewelry/enums/metal_type.dart';
import 'package:wameedpos/features/industry_jewelry/models/jewelry_product_detail.dart';
import 'package:wameedpos/features/industry_jewelry/providers/jewelry_providers.dart';
import 'package:wameedpos/features/catalog/models/product.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProductDetailFormPage extends ConsumerStatefulWidget {
  const ProductDetailFormPage({super.key, this.detail});
  final JewelryProductDetail? detail;

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
    return PosFormPage(
      title: _isEditing ? l10n.jewelryEditProductDetail : l10n.jewelryNewProductDetail,
      bottomBar: PosButton(
          label: _isEditing ? l10n.jewelryUpdateDetail : l10n.jewelryCreateDetail,
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
            PosSearchableDropdown<MetalType>(
              hint: l10n.selectMetalType,
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
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _karatCtrl, label: l10n.jewelryKarat, hint: l10n.jewelryKaratHint),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _grossWeightCtrl,
                    label: l10n.jewelryGrossWeightG,
                    hint: 'e.g. 15.50',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _netWeightCtrl,
                    label: l10n.jewelryNetWeightG,
                    hint: 'e.g. 14.20',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosSearchableDropdown<MakingChargesType>(
              hint: l10n.selectChargesType,
              label: l10n.jewelryMakingChargesType,
              items: MakingChargesType.values
                  .map((t) => PosDropdownItem(value: t, label: t.value[0].toUpperCase() + t.value.substring(1)))
                  .toList(),
              selectedValue: _makingChargesType,
              onChanged: (v) => setState(() => _makingChargesType = v),
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(
              controller: _makingChargesValueCtrl,
              label: l10n.jewelryMakingChargesValue,
              hint: 'e.g. 150.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(l10n.jewelryStoneDetails, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            PosTextField(controller: _stoneTypeCtrl, label: l10n.jewelryStoneTypeOptional, hint: l10n.jewelryStoneTypeHint),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: PosTextField(
                    controller: _stoneWeightCtrl,
                    label: l10n.jewelryWeightCarat,
                    hint: 'e.g. 1.50',
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosTextField(
                    controller: _stoneCountCtrl,
                    label: l10n.jewelryCount,
                    hint: 'e.g. 4',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            PosTextField(controller: _certificateNumberCtrl, label: l10n.jewelryCertificateOptional, hint: l10n.jewelryCertificateHint),
          ],
        ),
      ),
    );
  }
}
