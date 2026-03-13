import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_input.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_providers.dart';
import 'package:thawani_pos/features/catalog/providers/catalog_state.dart';

class ProductFormPage extends ConsumerStatefulWidget {
  final String? productId;

  const ProductFormPage({super.key, this.productId});

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nameArController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _skuController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _taxRateController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String? _selectedCategoryId;
  bool _isActive = true;

  bool get _isEditing => widget.productId != null;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Load categories for dropdown
    Future.microtask(() {
      ref.read(categoriesProvider.notifier).load(activeOnly: true);

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
    _imageUrlController.dispose();
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
      _sellPriceController.text = p.sellPrice.toStringAsFixed(3);
      _costPriceController.text = p.costPrice?.toStringAsFixed(3) ?? '';
      _taxRateController.text = p.taxRate?.toString() ?? '';
      _imageUrlController.text = p.imageUrl ?? '';
      _selectedCategoryId = p.categoryId;
      _isActive = p.isActive ?? true;
    }
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
    data['is_active'] = _isActive;

    await ref.read(productDetailProvider(widget.productId).notifier).save(data);
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(productDetailProvider(widget.productId));
    final categoriesState = ref.watch(categoriesProvider);

    // Populate form when product loads
    if (_isEditing && detailState is ProductDetailLoaded) {
      // Only populate once
      if (_nameController.text.isEmpty) {
        _populateFromProduct();
      }
    }

    // Navigate back on save
    ref.listen(productDetailProvider(widget.productId), (prev, next) {
      if (next is ProductDetailSaved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Product updated.' : 'Product created.')),
        );
        context.pop();
      } else if (next is ProductDetailError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message), backgroundColor: AppColors.error),
        );
      }
    });

    final isSaving = detailState is ProductDetailSaving;
    final isLoading = _isEditing && (detailState is ProductDetailLoading || detailState is ProductDetailInitial);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Product' : 'Add Product'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Basic Info'),
            Tab(text: 'Pricing'),
            Tab(text: 'Media'),
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
                  _buildMediaTab(),
                ],
              ),
            ),
    );
  }

  Widget _buildBasicTab(CategoriesState categoriesState) {
    final categories = categoriesState is CategoriesLoaded ? categoriesState.categories : <Category>[];

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        PosTextField(
          controller: _nameController,
          label: 'Product Name *',
          hint: 'Enter product name',
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _nameArController,
          label: 'Product Name (Arabic)',
          hint: 'أدخل اسم المنتج',
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _descriptionController,
          label: 'Description',
          hint: 'Enter product description',
          maxLines: 3,
        ),
        const SizedBox(height: AppSpacing.md),

        // Category dropdown
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category', style: Theme.of(context).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              decoration: InputDecoration(
                hintText: 'Select category',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('No category')),
                ...categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))),
              ],
              onChanged: (value) => setState(() => _selectedCategoryId = value),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        PosTextField(
          controller: _skuController,
          label: 'SKU',
          hint: 'Stock Keeping Unit',
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _barcodeController,
          label: 'Barcode',
          hint: 'Enter or scan barcode',
          suffixIcon: Icons.qr_code_scanner,
        ),
        const SizedBox(height: AppSpacing.md),

        // Active toggle
        SwitchListTile(
          title: const Text('Active'),
          subtitle: const Text('Product is visible in POS'),
          value: _isActive,
          onChanged: (value) => setState(() => _isActive = value),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPricingTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        PosTextField(
          controller: _sellPriceController,
          label: 'Sell Price (OMR) *',
          hint: '0.000',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _costPriceController,
          label: 'Cost Price (OMR)',
          hint: '0.000',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        ),
        const SizedBox(height: AppSpacing.md),
        PosTextField(
          controller: _taxRateController,
          label: 'Tax Rate (%)',
          hint: '0',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[\d.]'))],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Margin hint
        if (_sellPriceController.text.isNotEmpty && _costPriceController.text.isNotEmpty) ...[
          Builder(builder: (context) {
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
                    Text('Margin: ${margin.toStringAsFixed(1)}%',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.info)),
                  ],
                ),
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildMediaTab() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
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
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
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
}
