import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_button.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/widgets/pos_input.dart';
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
  final String? productId;
  final String? initialBarcode;

  const ProductFormPage({super.key, this.productId, this.initialBarcode});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  List<ModifierOption> _modifierOptions = [];
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
    _tabController = TabController(length: 7, vsync: this);

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
    _tabController.dispose();
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

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.info_outline, size: 18), text: 'Basic Info'),
            Tab(icon: Icon(Icons.attach_money, size: 18), text: 'Pricing'),
            Tab(icon: Icon(Icons.style_outlined, size: 18), text: 'Variants'),
            Tab(icon: Icon(Icons.tune, size: 18), text: 'Modifiers'),
            Tab(icon: Icon(Icons.qr_code, size: 18), text: 'Barcodes'),
            Tab(icon: Icon(Icons.local_shipping_outlined, size: 18), text: 'Suppliers'),
            Tab(icon: Icon(Icons.image_outlined, size: 18), text: 'Media'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: PosButton(
          label: isSaving ? 'Saving...' : (_isEditing ? 'Update Product' : 'Create Product'),
          onPressed: isSaving || isLoading ? null : _handleSave,
          isLoading: isSaving,
          isFullWidth: true,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildBasicTab(categoriesState),
                  _buildPricingTab(),
                  _buildVariantsTab(),
                  _buildModifiersTab(),
                  _buildBarcodesTab(),
                  _buildSuppliersTab(suppliersState),
                  _buildMediaTab(),
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

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionHeader('Product Identity'),
        PosTextField(controller: _nameController, label: 'Product Name *', hint: 'Enter product name'),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _nameArController,
          label: 'Product Name (Arabic)',
          hint: 'أدخل اسم المنتج',
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(controller: _descriptionController, label: 'Description', hint: 'Enter product description', maxLines: 3),
        const SizedBox(height: AppSpacing.lg),

        _sectionHeader('Classification'),
        // Category dropdown
        PosSearchableDropdown<String>(
          selectedValue: _selectedCategoryId,
          items: categories.map((c) => PosDropdownItem(value: c.id, label: c.name)).toList(),
          onChanged: (value) => setState(() => _selectedCategoryId = value),
          label: 'Category',
          hint: 'Select category',
          clearable: true,
        ),
        const SizedBox(height: AppSpacing.md),

        // Unit type
        PosSearchableDropdown<ProductUnit>(
          selectedValue: _selectedUnit,
          items: ProductUnit.values.map((u) => PosDropdownItem(value: u, label: u.value)).toList(),
          onChanged: (value) => setState(() => _selectedUnit = value),
          label: 'Unit Type',
          hint: 'Select unit',
          showSearch: false,
        ),
        const SizedBox(height: AppSpacing.lg),

        _sectionHeader('Identifiers'),
        PosTextField(controller: _skuController, label: 'SKU', hint: 'Stock Keeping Unit'),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _barcodeController,
          label: 'Primary Barcode',
          hint: 'Enter or scan barcode',
          suffixIcon: Icons.qr_code_scanner,
        ),
        const SizedBox(height: AppSpacing.lg),

        _sectionHeader('Ordering'),
        Row(
          children: [
            Expanded(
              child: PosTextField(
                controller: _minOrderQtyController,
                label: 'Min Order Qty',
                hint: '1',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PosTextField(
                controller: _maxOrderQtyController,
                label: 'Max Order Qty',
                hint: 'Unlimited',
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
          title: const Text('Active'),
          subtitle: const Text('Product is visible in POS'),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),

        // Weighable toggle
        SwitchListTile(
          title: const Text('Weighable'),
          subtitle: const Text('Sold by weight (use scale at POS)'),
          value: _isWeighable,
          onChanged: (value) => setState(() => _isWeighable = value),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
        if (_isWeighable) ...[
          const SizedBox(height: AppSpacing.sm),
          PosTextField(
            controller: _tareWeightController,
            label: 'Tare Weight (kg)',
            hint: 'e.g. 0.05',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
          ),
        ],

        // Age restricted
        SwitchListTile(
          title: const Text('Age Restricted'),
          subtitle: const Text('Requires age verification at POS'),
          value: _ageRestricted,
          onChanged: (value) => setState(() => _ageRestricted = value),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // Tab 2: Pricing
  // ═══════════════════════════════════════════════════════════════

  Widget _buildPricingTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionHeader('Base Pricing'),
        Row(
          children: [
            Expanded(
              child: PosTextField(
                controller: _sellPriceController,
                label: 'Sell Price (\u0081) *',
                hint: 'e.g. 5.50',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PosTextField(
                controller: _costPriceController,
                label: 'Cost Price (\u0081)',
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
          label: 'Tax Rate (%)',
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
              return Card(
                color: AppColors.info.withValues(alpha: 0.05),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.info, size: 20),
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
          label: 'Offer Price (\u0081)',
          hint: 'Leave empty for no offer',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: PosTextField(
                controller: _offerStartController,
                label: 'Offer Start',
                hint: 'YYYY-MM-DD',
                readOnly: true,
                suffixIcon: Icons.calendar_today,
                onTap: () => _pickDate(_offerStartController, _offerStart, (d) => setState(() => _offerStart = d)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: PosTextField(
                controller: _offerEndController,
                label: 'Offer End',
                hint: 'YYYY-MM-DD',
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
              (sp) => Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: const Icon(Icons.store, size: 20),
                  title: Text('Store: ${sp.storeId}'),
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
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader('Product Variants'),
            PosButton(
              label: 'Add Variant',
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
            (v) => Card(
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
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        v.isActive == true ? 'Active' : 'Inactive',
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
    );
  }

  Future<void> _showVariantDialog() async {
    final valueController = TextEditingController();
    final skuController = TextEditingController();
    final priceAdjController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Variant'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosTextField(controller: valueController, label: 'Variant Value *', hint: 'e.g. Large, Red, 500ml'),
              const SizedBox(height: AppSpacing.md),
              PosTextField(controller: skuController, label: 'SKU', hint: 'Optional variant SKU'),
              const SizedBox(height: AppSpacing.md),
              PosTextField(
                controller: priceAdjController,
                label: 'Price Adjustment',
                hint: 'e.g. +2.00 or -1.50',
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.\-]'))],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (valueController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
              // API sync would happen through provider in production
            },
            child: const Text('Add'),
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
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader('Modifier Groups'),
            PosButton(
              label: 'Add Group',
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
            return Card(
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
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                        ),
                        if (group.isRequired == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Required',
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
                                color: opt.isDefault == true ? AppColors.primary : AppColors.textMutedLight,
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
          title: const Text('Add Modifier Group'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosTextField(controller: nameController, label: 'Group Name *', hint: 'e.g. Size, Extras, Toppings'),
                const SizedBox(height: AppSpacing.md),
                SwitchListTile(
                  title: const Text('Required'),
                  value: isRequired,
                  onChanged: (v) => setDialogState(() => isRequired = v),
                  activeColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: minController,
                        label: 'Min Select',
                        hint: '0',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PosTextField(
                        controller: maxController,
                        label: 'Max Select',
                        hint: 'Unlimited',
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (nameController.text.trim().isEmpty) return;
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
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
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader('Product Barcodes'),
            Row(
              children: [
                PosButton(
                  label: 'Generate',
                  icon: Icons.auto_awesome,
                  size: PosButtonSize.sm,
                  variant: PosButtonVariant.soft,
                  onPressed: _generateBarcode,
                ),
                const SizedBox(width: AppSpacing.sm),
                PosButton(
                  label: 'Add Barcode',
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
          Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ListTile(
              leading: const Icon(Icons.qr_code, size: 20),
              title: Text(_barcodeController.text, style: const TextStyle(fontFamily: 'monospace')),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Primary', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
              ),
            ),
          ),

        if (_barcodes.isEmpty && _barcodeController.text.isEmpty)
          _emptyState('No barcodes assigned to this product.', Icons.qr_code)
        else
          ..._barcodes.map(
            (b) => Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: const Icon(Icons.qr_code_2, size: 20),
                title: Text(b.barcode, style: const TextStyle(fontFamily: 'monospace')),
                trailing: b.isPrimary == true
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text('Primary', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                      )
                    : null,
              ),
            ),
          ),
      ],
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
        title: const Text('Add Barcode'),
        content: SizedBox(
          width: 400,
          child: PosTextField(
            controller: barcodeController,
            label: 'Barcode *',
            hint: 'Enter or scan barcode',
            suffixIcon: Icons.qr_code_scanner,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (barcodeController.text.trim().isEmpty) return;
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
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
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _sectionHeader('Linked Suppliers'),
            PosButton(
              label: 'Link Supplier',
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
            return Card(
              margin: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary10,
                  child: Icon(Icons.business, size: 18, color: AppColors.primary),
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
          title: const Text('Link Supplier'),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PosSearchableDropdown<String>(
                  selectedValue: selectedSupplierId,
                  items: available.map((s) => PosDropdownItem(value: s.id, label: s.name)).toList(),
                  onChanged: (v) => setDialogState(() => selectedSupplierId = v),
                  label: 'Supplier *',
                  hint: 'Select supplier',
                ),
                const SizedBox(height: AppSpacing.md),
                PosTextField(controller: supplierSkuController, label: 'Supplier SKU', hint: "Supplier's product code"),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: PosTextField(
                        controller: costController,
                        label: 'Cost Price (\u0081)',
                        hint: 'Cost from this supplier',
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: PosTextField(
                        controller: leadTimeController,
                        label: 'Lead Time (days)',
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
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            FilledButton(
              onPressed: () {
                if (selectedSupplierId == null) return;
                Navigator.pop(ctx);
              },
              child: const Text('Link'),
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
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        _sectionHeader('Product Image'),
        PosTextField(
          controller: _imageUrlController,
          label: 'Image URL',
          hint: 'https://example.com/image.jpg',
          keyboardType: TextInputType.url,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Preview
        if (_imageUrlController.text.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _imageUrlController.text,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, size: 48, color: AppColors.error),
                      const SizedBox(height: AppSpacing.sm),
                      Text('Could not load image', style: TextStyle(color: AppColors.error)),
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight, style: BorderStyle.solid),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate_outlined, size: 48, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Paste an image URL above', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
      ],
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
