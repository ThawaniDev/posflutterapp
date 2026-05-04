import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/enums/product_unit.dart';
import 'package:wameedpos/features/catalog/models/category.dart';
import 'package:wameedpos/features/catalog/models/modifier_group.dart';
import 'package:wameedpos/features/catalog/models/modifier_option.dart';
import 'package:wameedpos/features/catalog/models/product_barcode.dart';
import 'package:wameedpos/features/catalog/models/product_supplier.dart';
import 'package:wameedpos/features/catalog/models/product_variant.dart';
import 'package:wameedpos/features/catalog/models/store_price.dart';
import 'package:wameedpos/features/catalog/models/supplier.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/catalog/repositories/catalog_repository.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({super.key, this.productId, this.initialBarcode});
  final String? productId;
  final String? initialBarcode;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  int _currentTab = 0;

  final _formKey = GlobalKey<FormState>();

  // ─── Basic Info ──────────────────────────────────────────────
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  String? _selectedCategoryId;
  ProductUnit? _selectedUnit;
  bool _isActive = true;
  bool _isWeighable = false;
  bool _ageRestricted = false;
  final _tareWeightController = TextEditingController();
  final _minOrderQtyController = TextEditingController();
  final _maxOrderQtyController = TextEditingController();

  // ─── Pricing ─────────────────────────────────────────────────
  final _sellPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _taxRateController = TextEditingController();
  final _offerPriceController = TextEditingController();
  final _offerStartController = TextEditingController();
  final _offerEndController = TextEditingController();
  DateTime? _offerStart;
  DateTime? _offerEnd;

  // ─── Media ───────────────────────────────────────────────────
  final _imageUrlController = TextEditingController();

  // ─── Variants ────────────────────────────────────────────────
  List<ProductVariant> _variants = [];
  bool _variantsLoaded = false;

  // ─── Modifiers ───────────────────────────────────────────────
  List<ModifierGroup> _modifierGroups = [];
  final List<ModifierOption> _modifierOptions = [];
  bool _modifiersLoaded = false;

  // ─── Barcodes ────────────────────────────────────────────────
  List<ProductBarcode> _barcodes = [];
  bool _barcodesLoaded = false;

  // ─── Suppliers ───────────────────────────────────────────────
  List<ProductSupplier> _productSuppliers = [];
  bool _suppliersLoaded = false;

  // ─── Store Prices ────────────────────────────────────────────
  List<StorePrice> _storePrices = [];
  bool _storePricesLoaded = false;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();

    if (widget.initialBarcode != null && widget.initialBarcode!.isNotEmpty) {
      _barcodeController.text = widget.initialBarcode!;
    }

    Future.microtask(() {
      ref.read(categoriesProvider.notifier).load(activeOnly: true);
      ref.read(suppliersProvider.notifier).load();
      if (_isEditing) {
        ref.read(productDetailProvider(widget.productId).notifier).load();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameArController.dispose();
    _descriptionController.dispose();
    _skuController.dispose();
    _barcodeController.dispose();
    _sellPriceController.dispose();
    _costPriceController.dispose();
    _taxRateController.dispose();
    _offerPriceController.dispose();
    _offerStartController.dispose();
    _offerEndController.dispose();
    _imageUrlController.dispose();
    _tareWeightController.dispose();
    _minOrderQtyController.dispose();
    _maxOrderQtyController.dispose();
    super.dispose();
  }

  void _populateFromProduct() {
    final state = ref.read(productDetailProvider(widget.productId));
    if (state is ProductDetailLoaded) {
      final p = state.product;
      _nameController.text = p.name;
      _nameArController.text = p.nameAr ?? '';
      _descriptionController.text = p.description ?? '';
      _skuController.text = p.sku ?? '';
      _barcodeController.text = p.barcode ?? '';
      _sellPriceController.text = p.sellPrice.toStringAsFixed(2);
      _costPriceController.text = p.costPrice?.toStringAsFixed(2) ?? '';
      _taxRateController.text = p.taxRate?.toString() ?? '';
      _imageUrlController.text = p.imageUrl ?? '';
      _selectedCategoryId = p.categoryId;
      _selectedUnit = p.unit;
      _isActive = p.isActive ?? true;
      _isWeighable = p.isWeighable ?? false;
      _ageRestricted = p.ageRestricted ?? false;
      _tareWeightController.text = p.tareWeight?.toString() ?? '';
      _minOrderQtyController.text = p.minOrderQty?.toString() ?? '';
      _maxOrderQtyController.text = p.maxOrderQty?.toString() ?? '';
      _offerPriceController.text = p.offerPrice?.toStringAsFixed(2) ?? '';
      if (p.offerStart != null) {
        _offerStart = p.offerStart;
        _offerStartController.text = _formatDate(p.offerStart!);
      }
      if (p.offerEnd != null) {
        _offerEnd = p.offerEnd;
        _offerEndController.text = _formatDate(p.offerEnd!);
      }
    }
  }

  String _formatDate(DateTime dt) => '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  Future<void> _loadRelatedData() async {
    if (!_isEditing) return;
    final repo = ref.read(catalogRepositoryProvider);
    final pid = widget.productId!;

    if (!_variantsLoaded) {
      try {
        _variants = await repo.getVariants(pid);
      } catch (_) {}
      _variantsLoaded = true;
    }
    if (!_modifiersLoaded) {
      try {
        _modifierGroups = await repo.getModifiers(pid);
      } catch (_) {}
      _modifiersLoaded = true;
    }
    if (!_barcodesLoaded) {
      try {
        _barcodes = await repo.getBarcodes(pid);
      } catch (_) {}
      _barcodesLoaded = true;
    }
    if (!_suppliersLoaded) {
      try {
        _productSuppliers = await repo.getProductSuppliers(pid);
      } catch (_) {}
      _suppliersLoaded = true;
    }
    if (!_storePricesLoaded) {
      try {
        _storePrices = await repo.getStorePrices(pid);
      } catch (_) {}
      _storePricesLoaded = true;
    }
    if (mounted) setState(() {});
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'name': _nameController.text.trim(),
      'sell_price': double.parse(_sellPriceController.text.trim()),
    };

    if (_nameArController.text.trim().isNotEmpty) data['name_ar'] = _nameArController.text.trim();
    if (_descriptionController.text.trim().isNotEmpty) data['description'] = _descriptionController.text.trim();
    if (_skuController.text.trim().isNotEmpty) data['sku'] = _skuController.text.trim();
    if (_barcodeController.text.trim().isNotEmpty) data['barcode'] = _barcodeController.text.trim();
    if (_costPriceController.text.trim().isNotEmpty) data['cost_price'] = double.parse(_costPriceController.text.trim());
    if (_taxRateController.text.trim().isNotEmpty) data['tax_rate'] = double.parse(_taxRateController.text.trim());
    if (_imageUrlController.text.trim().isNotEmpty) data['image_url'] = _imageUrlController.text.trim();
    if (_selectedCategoryId != null) data['category_id'] = _selectedCategoryId;
    if (_selectedUnit != null) data['unit'] = _selectedUnit!.value;
    data['is_active'] = _isActive;
    data['is_weighable'] = _isWeighable;
    data['age_restricted'] = _ageRestricted;
    if (_isWeighable && _tareWeightController.text.trim().isNotEmpty) {
      data['tare_weight'] = double.parse(_tareWeightController.text.trim());
    }
    if (_minOrderQtyController.text.trim().isNotEmpty) data['min_order_qty'] = int.parse(_minOrderQtyController.text.trim());
    if (_maxOrderQtyController.text.trim().isNotEmpty) data['max_order_qty'] = int.parse(_maxOrderQtyController.text.trim());
    if (_offerPriceController.text.trim().isNotEmpty) data['offer_price'] = double.parse(_offerPriceController.text.trim());
    if (_offerStart != null) data['offer_start'] = _offerStart!.toIso8601String();
    if (_offerEnd != null) data['offer_end'] = _offerEnd!.toIso8601String();

    await ref.read(productDetailProvider(widget.productId).notifier).save(data);
  }

  Future<void> _pickDate(TextEditingController controller, DateTime? current, ValueChanged<DateTime> onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
    );
    if (picked != null) {
      controller.text = _formatDate(picked);
      onPicked(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(productDetailProvider(widget.productId));
    final categoriesState = ref.watch(categoriesProvider);
    final suppliersState = ref.watch(suppliersProvider);

    // Populate form when product loads
    if (_isEditing && detailState is ProductDetailLoaded) {
      if (_nameController.text.isEmpty) {
        _populateFromProduct();
        _loadRelatedData();
      }
    }

    // Navigate back on save
    ref.listen(productDetailProvider(widget.productId), (prev, next) {
      if (next is ProductDetailSaved) {
        final l10n = AppLocalizations.of(context)!;
        showPosSuccessSnackbar(context, _isEditing ? l10n.productUpdated : l10n.productCreated);
        context.pop();
      } else if (next is ProductDetailError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final isSaving = detailState is ProductDetailSaving;
    final isLoading = _isEditing && (detailState is ProductDetailLoading || detailState is ProductDetailInitial);

    return PosFormPage(
      title: _isEditing ? l10n.catalogEditProduct : l10n.catalogAddProduct,
      isLoading: isLoading,
      bottomBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosButton(
          label: isSaving ? l10n.catalogSaving : (_isEditing ? l10n.catalogUpdateProduct : l10n.catalogCreateProduct),
          onPressed: isSaving || isLoading ? null : _handleSave,
          isLoading: isSaving,
          isFullWidth: true,
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PosTabs(
              selectedIndex: _currentTab,
              onChanged: (i) => setState(() => _currentTab = i),
              isScrollable: true,
              tabs: [
                PosTabItem(label: l10n.catalogTabBasicInfo, icon: Icons.info_outline),
                PosTabItem(label: l10n.catalogTabPricing, icon: Icons.attach_money),
                PosTabItem(label: l10n.catalogTabVariants, icon: Icons.style_outlined),
                PosTabItem(label: l10n.catalogTabModifiers, icon: Icons.tune),
                PosTabItem(label: l10n.catalogTabBarcodes, icon: Icons.qr_code),
                PosTabItem(label: l10n.supplierTitle, icon: Icons.local_shipping_outlined),
                PosTabItem(label: l10n.branchesMedia, icon: Icons.image_outlined),
              ],
            ),
            // Render only the active tab. IndexedStack cannot be used inside
            // a SingleChildScrollView (the parent PosFormPage child) because
            // Stack needs bounded vertical constraints.
            switch (_currentTab) {
              0 => _buildBasicTab(categoriesState),
              1 => _buildPricingTab(),
              2 => _buildVariantsTab(),
              3 => _buildModifiersTab(),
              4 => _buildBarcodesTab(),
              5 => _buildSuppliersTab(suppliersState),
              6 => _buildMediaTab(),
              _ => const SizedBox.shrink(),
            },
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 1: Basic Info
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBasicTab(CategoriesState categoriesState) {
    final categories = categoriesState is CategoriesLoaded ? categoriesState.categories : <Category>[];

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Product Identity'),
          PosTextField(controller: _nameController, label: l10n.catalogProductNameRequired, hint: l10n.catalogProductNameHint),
          const SizedBox(height: AppSpacing.md),
          PosTextField(
            controller: _nameArController,
            label: l10n.catalogProductNameArabic,
            hint: 'أدخل اسم المنتج',
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: AppSpacing.md),
          PosTextField(
            controller: _descriptionController,
            label: l10n.description,
            hint: l10n.catalogProductDescHint,
            maxLines: 3,
          ),
          const SizedBox(height: AppSpacing.lg),

          _sectionHeader('Classification'),
          // Category dropdown
          PosSearchableDropdown<String>(
            selectedValue: _selectedCategoryId,
            items: categories.map((c) => PosDropdownItem(value: c.id, label: c.name)).toList(),
            onChanged: (value) => setState(() => _selectedCategoryId = value),
            label: l10n.category,
            hint: l10n.catalogSelectCategory,
            clearable: true,
          ),
          const SizedBox(height: AppSpacing.md),

          // Unit type
          PosSearchableDropdown<ProductUnit>(
            selectedValue: _selectedUnit,
            items: ProductUnit.values.map((u) => PosDropdownItem(value: u, label: u.value)).toList(),
            onChanged: (value) => setState(() => _selectedUnit = value),
            label: l10n.catalogUnitType,
            hint: l10n.catalogSelectUnit,
            showSearch: false,
          ),
          const SizedBox(height: AppSpacing.lg),

          _sectionHeader('Identifiers'),
          PosTextField(controller: _skuController, label: l10n.catalogSku, hint: l10n.catalogSkuHint),
          const SizedBox(height: AppSpacing.md),
          PosTextField(
            controller: _barcodeController,
            label: l10n.catalogPrimaryBarcode,
            hint: l10n.catalogBarcodeHint,
            suffixIcon: Icons.qr_code_scanner,
          ),
          const SizedBox(height: AppSpacing.lg),

          _sectionHeader('Ordering'),
          Row(
            children: [
              Expanded(
                child: PosTextField(
                  controller: _minOrderQtyController,
                  label: l10n.catalogMinOrderQty,
                  hint: '1',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PosTextField(
                  controller: _maxOrderQtyController,
                  label: l10n.catalogMaxOrderQty,
                  hint: l10n.catalogUnlimited,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          _sectionHeader('Properties'),
          // Active toggle
          SwitchListTile(
            title: Text(l10n.active),
            subtitle: Text(l10n.catalogProductVisibleInPos),
            value: _isActive,
            onChanged: (value) => setState(() => _isActive = value),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          // Weighable toggle
          SwitchListTile(
            title: Text(l10n.catalogWeighable),
            subtitle: Text(l10n.catalogSoldByWeight),
            value: _isWeighable,
            onChanged: (value) => setState(() => _isWeighable = value),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),
          if (_isWeighable) ...[
            const SizedBox(height: AppSpacing.sm),
            PosTextField(
              controller: _tareWeightController,
              label: l10n.catalogTareWeight,
              hint: 'e.g. 0.05',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
            ),
          ],

          // Age restricted
          SwitchListTile(
            title: Text(l10n.catalogAgeRestricted),
            subtitle: Text(l10n.catalogAgeRestriction),
            value: _ageRestricted,
            onChanged: (value) => setState(() => _ageRestricted = value),
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
          ),

          // Combo / bundle entry — only meaningful once the product exists.
          if (_isEditing) ...[
            const SizedBox(height: AppSpacing.md),
            PosCard(
              child: ListTile(
                leading: const Icon(Icons.layers_outlined, color: AppColors.primary),
                title: Text(l10n.catalogComboTitle),
                subtitle: Text(l10n.catalogComboHeading),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('${Routes.productsCombo}/${widget.productId}'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 2: Pricing
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPricingTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Base Pricing'),
          Row(
            children: [
              Expanded(
                child: PosTextField(
                  controller: _sellPriceController,
                  label: l10n.catalogSellPriceRequired,
                  hint: 'e.g. 5.50',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PosTextField(
                  controller: _costPriceController,
                  label: l10n.catalogCostPrice,
                  hint: 'e.g. 3.20',
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          PosTextField(
            controller: _taxRateController,
            label: l10n.settingsTaxRate,
            hint: 'e.g. 15',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          ),
          const SizedBox(height: AppSpacing.md),

          // Margin hint
          if (_sellPriceController.text.isNotEmpty && _costPriceController.text.isNotEmpty) ...[
            Builder(
              builder: (context) {
                final sell = double.tryParse(_sellPriceController.text) ?? 0;
                final cost = double.tryParse(_costPriceController.text) ?? 0;
                final margin = sell > 0 ? ((sell - cost) / sell * 100) : 0;
                return PosCard(
                  color: AppColors.info.withValues(alpha: 0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          'Margin: ${margin.toStringAsFixed(1)}%',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.info),
                        ),
                        const SizedBox(width: AppSpacing.lg),
                        Text(
                          'Profit: ${(sell - cost).toStringAsFixed(2)} \u0081',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.info),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          _sectionHeader('Offer / Promotion'),
          PosTextField(
            controller: _offerPriceController,
            label: l10n.catalogOfferPrice,
            hint: l10n.catalogOfferPriceHint,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: PosTextField(
                  controller: _offerStartController,
                  label: l10n.catalogOfferStart,
                  hint: l10n.catalogDatePlaceholder,
                  readOnly: true,
                  suffixIcon: Icons.calendar_today,
                  onTap: () => _pickDate(_offerStartController, _offerStart, (d) => setState(() => _offerStart = d)),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PosTextField(
                  controller: _offerEndController,
                  label: l10n.catalogOfferEnd,
                  hint: l10n.catalogDatePlaceholder,
                  readOnly: true,
                  suffixIcon: Icons.calendar_today,
                  onTap: () => _pickDate(_offerEndController, _offerEnd, (d) => setState(() => _offerEnd = d)),
                ),
              ),
            ],
          ),

          // Store-specific prices
          if (_isEditing && _storePricesLoaded) ...[
            const SizedBox(height: AppSpacing.xl),
            _sectionHeader('Store-Specific Prices'),
            if (_storePrices.isEmpty)
              _emptyState('No store-specific price overrides.', Icons.store_outlined)
            else
              ..._storePrices.map(
                (sp) => PosCard(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    leading: const Icon(Icons.store, size: 20),
                    title: Text(l10n.catalogStoreWithId(sp.storeId)),
                    subtitle: Text('${sp.sellPrice.toStringAsFixed(2)} \u0081'),
                    trailing: sp.validFrom != null
                        ? Text(
                            '${_formatDate(sp.validFrom!)} – ${sp.validTo != null ? _formatDate(sp.validTo!) : '∞'}',
                            style: Theme.of(context).textTheme.labelSmall,
                          )
                        : null,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 3: Variants
  // ═══════════════════════════════════════════════════════════════

  Widget _buildVariantsTab() {
    if (!_isEditing) {
      return Center(child: _emptyState('Save the product first, then manage variants.', Icons.style_outlined));
    }

    if (!_variantsLoaded) {
      return const PosLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Product Variants'),
              PosButton(
                label: l10n.catalogAddVariant,
                icon: Icons.add,
                size: PosButtonSize.sm,
                variant: PosButtonVariant.outline,
                onPressed: () => _showVariantDialog(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_variants.isEmpty)
            _emptyState('No variants. Add sizes, colours, etc.', Icons.style_outlined)
          else
            ..._variants.map(
              (v) => PosCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text(v.variantValue, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    [
                      if (v.sku != null) 'SKU: ${v.sku}',
                      if (v.barcode != null) 'Barcode: ${v.barcode}',
                      if (v.priceAdjustment != null)
                        'Price adj: ${v.priceAdjustment! >= 0 ? '+' : ''}${v.priceAdjustment!.toStringAsFixed(2)}',
                    ].join(' · '),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: v.isActive == true
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.borderXs,
                        ),
                        child: Text(
                          v.isActive == true ? l10n.active : l10n.inactive,
                          style: Theme.of(
                            context,
                          ).textTheme.labelSmall?.copyWith(color: v.isActive == true ? AppColors.success : AppColors.error),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showVariantDialog() async {
    final valueController = TextEditingController();
    final skuController = TextEditingController();
    final priceAdjController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.catalogAddVariant),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosTextField(
                controller: valueController,
                label: l10n.catalogVariantValueRequired,
                hint: l10n.catalogVariantValueHint,
              ),
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: skuController, label: l10n.catalogSku, hint: l10n.catalogVariantSkuHint),
              const SizedBox(height: AppSpacing.md),
              PosTextField(
                controller: priceAdjController,
                label: l10n.catalogPriceAdjustment,
                hint: 'e.g. +2.00 or -1.50',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]'))],
              ),
            ],
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () {
              if (valueController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              // API sync would happen through provider in production
            },
            variant: PosButtonVariant.soft,
            label: l10n.add,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 4: Modifiers
  // ═══════════════════════════════════════════════════════════════

  Widget _buildModifiersTab() {
    if (!_isEditing) {
      return Center(child: _emptyState('Save the product first, then manage modifiers.', Icons.tune));
    }

    if (!_modifiersLoaded) {
      return const PosLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Modifier Groups'),
              PosButton(
                label: l10n.catalogAddGroup,
                icon: Icons.add,
                size: PosButtonSize.sm,
                variant: PosButtonVariant.outline,
                onPressed: () => _showModifierGroupDialog(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_modifierGroups.isEmpty)
            _emptyState('No modifier groups. Add extras, toppings, etc.', Icons.tune)
          else
            ..._modifierGroups.map((group) {
              final options = _modifierOptions.where((o) => o.modifierGroupId == group.id).toList();
              return PosCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.name,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  [
                                    if (group.isRequired == true) 'Required',
                                    if (group.minSelect != null) 'Min: ${group.minSelect}',
                                    if (group.maxSelect != null) 'Max: ${group.maxSelect}',
                                  ].join(' · '),
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
                                ),
                              ],
                            ),
                          ),
                          if (group.isRequired == true)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.1),
                                borderRadius: AppRadius.borderXs,
                              ),
                              child: Text(
                                l10n.staffRequired,
                                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.warning),
                              ),
                            ),
                        ],
                      ),
                      if (options.isNotEmpty) ...[
                        const Divider(height: AppSpacing.lg),
                        ...options.map(
                          (opt) => Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                            child: Row(
                              children: [
                                Icon(
                                  opt.isDefault == true ? Icons.radio_button_checked : Icons.radio_button_off,
                                  size: 16,
                                  color: opt.isDefault == true ? AppColors.primary : AppColors.mutedFor(context),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(child: Text(opt.name)),
                                if (opt.priceAdjustment != null && opt.priceAdjustment != 0)
                                  Text(
                                    '${opt.priceAdjustment! >= 0 ? '+' : ''}${opt.priceAdjustment!.toStringAsFixed(2)} \u0081',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _showModifierGroupDialog() async {
    final nameController = TextEditingController();
    bool isRequired = false;
    final minController = TextEditingController();
    final maxController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.catalogAddModifierGroup),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(controller: nameController, label: l10n.catalogGroupNameRequired, hint: l10n.catalogGroupNameHint),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: Text(l10n.staffRequired),
                  value: isRequired,
                  onChanged: (v) => setDialogState(() => isRequired = v),
                  activeThumbColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: minController,
                        label: l10n.catalogMinSelect,
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PosTextField(
                        controller: maxController,
                        label: l10n.catalogMaxSelect,
                        hint: l10n.catalogUnlimited,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
              },
              variant: PosButtonVariant.soft,
              label: l10n.add,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 5: Barcodes
  // ═══════════════════════════════════════════════════════════════

  Widget _buildBarcodesTab() {
    if (!_isEditing) {
      return Center(child: _emptyState('Save the product first, then manage barcodes.', Icons.qr_code));
    }

    if (!_barcodesLoaded) {
      return const PosLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Product Barcodes'),
              Row(
                children: [
                  PosButton(
                    label: l10n.generate,
                    icon: Icons.auto_awesome,
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.soft,
                    onPressed: _generateBarcode,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  PosButton(
                    label: l10n.catalogAddBarcode,
                    icon: Icons.add,
                    size: PosButtonSize.sm,
                    variant: PosButtonVariant.outline,
                    onPressed: () => _showBarcodeDialog(),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // Primary barcode from product
          if (_barcodeController.text.isNotEmpty)
            PosCard(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.qr_code, size: 20),
                title: Text(_barcodeController.text, style: const TextStyle(fontFamily: 'monospace')),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderXs),
                  child: Text(
                    l10n.staffPrimary,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary),
                  ),
                ),
              ),
            ),

          if (_barcodes.isEmpty && _barcodeController.text.isEmpty)
            _emptyState('No barcodes assigned to this product.', Icons.qr_code)
          else
            ..._barcodes.map(
              (b) => PosCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: const Icon(Icons.qr_code_2, size: 20),
                  title: Text(b.barcode, style: const TextStyle(fontFamily: 'monospace')),
                  trailing: b.isPrimary == true
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: AppRadius.borderXs,
                          ),
                          child: Text(
                            l10n.staffPrimary,
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary),
                          ),
                        )
                      : null,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _generateBarcode() async {
    try {
      final barcode = await ref.read(catalogRepositoryProvider).generateBarcode(widget.productId!);
      if (mounted) {
        setState(() => _barcodeController.text = barcode);
        showPosInfoSnackbar(context, AppLocalizations.of(context)!.generatedBarcode(barcode));
      }
    } catch (e) {
      if (mounted) {
        showPosErrorSnackbar(context, e.toString());
      }
    }
  }

  Future<void> _showBarcodeDialog() async {
    final barcodeController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.catalogAddBarcode),
        content: SizedBox(
          width: 400,
          child: PosTextField(
            controller: barcodeController,
            label: l10n.catalogBarcodeRequired,
            hint: l10n.catalogBarcodeHint,
            suffixIcon: Icons.qr_code_scanner,
          ),
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () {
              if (barcodeController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
            },
            variant: PosButtonVariant.soft,
            label: l10n.add,
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 6: Suppliers
  // ═══════════════════════════════════════════════════════════════

  Widget _buildSuppliersTab(SuppliersState suppliersState) {
    if (!_isEditing) {
      return Center(child: _emptyState('Save the product first, then link suppliers.', Icons.local_shipping_outlined));
    }

    final allSuppliers = suppliersState is SuppliersLoaded ? suppliersState.suppliers : <Supplier>[];

    if (!_suppliersLoaded) {
      return const PosLoading();
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _sectionHeader('Linked Suppliers'),
              PosButton(
                label: l10n.catalogLinkSupplier,
                icon: Icons.add,
                size: PosButtonSize.sm,
                variant: PosButtonVariant.outline,
                onPressed: () => _showLinkSupplierDialog(allSuppliers),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          if (_productSuppliers.isEmpty)
            _emptyState('No suppliers linked. Add suppliers for procurement.', Icons.local_shipping_outlined)
          else
            ..._productSuppliers.map((ps) {
              final supplier = allSuppliers.where((s) => s.id == ps.supplierId).firstOrNull;
              return PosCard(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary10,
                    child: const Icon(Icons.business, size: 18, color: AppColors.primary),
                  ),
                  title: Text(supplier?.name ?? ps.supplierId, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    [
                      if (ps.supplierSku != null) 'Supplier SKU: ${ps.supplierSku}',
                      if (ps.costPrice != null) 'Cost: ${ps.costPrice!.toStringAsFixed(2)} \u0081',
                      if (ps.leadTimeDays != null) 'Lead time: ${ps.leadTimeDays} days',
                    ].join(' · '),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _showLinkSupplierDialog(List<Supplier> suppliers) async {
    String? selectedSupplierId;
    final costController = TextEditingController();
    final leadTimeController = TextEditingController();
    final supplierSkuController = TextEditingController();

    // Filter out already linked
    final linkedIds = _productSuppliers.map((ps) => ps.supplierId).toSet();
    final available = suppliers.where((s) => !linkedIds.contains(s.id)).toList();

    if (available.isEmpty) {
      showPosWarningSnackbar(context, AppLocalizations.of(context)!.allSuppliersAlreadyLinked);
      return;
    }

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text(l10n.catalogLinkSupplier),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosSearchableDropdown<String>(
                  selectedValue: selectedSupplierId,
                  items: available.map((s) => PosDropdownItem(value: s.id, label: s.name)).toList(),
                  onChanged: (v) => setDialogState(() => selectedSupplierId = v),
                  label: l10n.catalogSupplierRequired,
                  hint: l10n.catalogSelectSupplier,
                ),
                const SizedBox(height: AppSpacing.md),
                PosTextField(controller: supplierSkuController, label: l10n.catalogSupplierSku, hint: "Supplier's product code"),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: costController,
                        label: l10n.catalogCostPrice,
                        hint: l10n.catalogSupplierCostHint,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PosTextField(
                        controller: leadTimeController,
                        label: l10n.catalogLeadTimeDays,
                        hint: 'e.g. 7',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
            PosButton(
              onPressed: () {
                if (selectedSupplierId == null) return;
                Navigator.pop(ctx);
              },
              variant: PosButtonVariant.soft,
              label: l10n.catalogLink,
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 7: Media
  // ═══════════════════════════════════════════════════════════════

  Widget _buildMediaTab() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Product Image'),
          PosTextField(
            controller: _imageUrlController,
            label: l10n.catalogImageUrl,
            hint: 'https://example.com/image.jpg',
            keyboardType: TextInputType.url,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Preview
          if (_imageUrlController.text.isNotEmpty)
            ClipRRect(
              borderRadius: AppRadius.borderLg,
              child: Image.network(
                _imageUrlController.text,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 200,
                  decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.broken_image, size: 48, color: AppColors.error),
                        const SizedBox(height: AppSpacing.sm),
                        Text(l10n.catalogImageLoadFailed, style: const TextStyle(color: AppColors.error)),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary10,
                borderRadius: AppRadius.borderLg,
                border: Border.all(color: AppColors.borderFor(context), style: BorderStyle.solid),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.primary),
                    const SizedBox(height: AppSpacing.sm),
                    Text(l10n.catalogImagePasteHint, style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Shared Helpers
  // ═══════════════════════════════════════════════════════════════

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
      ),
    );
  }

  Widget _emptyState(String message, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
