import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/promotions/enums/promotion_type.dart';
import 'package:thawani_pos/features/promotions/models/promotion.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_providers.dart';
import 'package:thawani_pos/features/promotions/pages/promotion_analytics_page.dart';
import 'package:thawani_pos/features/promotions/providers/promotion_state.dart';
import 'package:thawani_pos/features/promotions/repositories/promotion_repository.dart';

class PromotionListPage extends ConsumerStatefulWidget {
  const PromotionListPage({super.key});

  @override
  ConsumerState<PromotionListPage> createState() => _PromotionListPageState();
}

class _PromotionListPageState extends ConsumerState<PromotionListPage> {
  final _searchController = TextEditingController();
  String? _typeFilter;
  bool? _activeFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(promotionsProvider.notifier).load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    ref
        .read(promotionsProvider.notifier)
        .load(
          search: _searchController.text.isNotEmpty ? _searchController.text : null,
          type: _typeFilter,
          isActive: _activeFilter,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(promotionsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Promotions & Coupons'),
        actions: [IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterSheet)],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _openPromotionForm(context), child: const Icon(Icons.add)),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search promotions...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onSubmitted: (_) => _applyFilters(),
            ),
          ),

          // Filter chips
          if (_typeFilter != null || _activeFilter != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  if (_typeFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text(_typeFilter!),
                        onDeleted: () => setState(() {
                          _typeFilter = null;
                          _applyFilters();
                        }),
                      ),
                    ),
                  if (_activeFilter != null)
                    Chip(
                      label: Text(_activeFilter! ? 'Active' : 'Inactive'),
                      onDeleted: () => setState(() {
                        _activeFilter = null;
                        _applyFilters();
                      }),
                    ),
                ],
              ),
            ),

          // List content
          Expanded(
            child: switch (state) {
              PromotionsInitial() || PromotionsLoading() => const Center(child: CircularProgressIndicator()),
              PromotionsError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
                    const SizedBox(height: 12),
                    Text(message, style: TextStyle(color: theme.colorScheme.error)),
                    const SizedBox(height: 16),
                    FilledButton.icon(onPressed: _applyFilters, icon: const Icon(Icons.refresh), label: const Text('Retry')),
                  ],
                ),
              ),
              PromotionsLoaded(:final promotions) =>
                promotions.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.local_offer_outlined, size: 64, color: theme.colorScheme.outline),
                            const SizedBox(height: 12),
                            Text('No promotions found', style: theme.textTheme.bodyLarge),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => ref.read(promotionsProvider.notifier).load(),
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: promotions.length,
                          itemBuilder: (context, index) => _PromotionCard(promotion: promotions[index]),
                        ),
                      ),
            },
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter Promotions', style: Theme.of(ctx).textTheme.titleMedium),
            const SizedBox(height: 16),
            PosSearchableDropdown<String>(
              label: 'Type',
              items: PromotionType.values.map((t) => PosDropdownItem(value: t.value, label: t.label)).toList(),
              selectedValue: _typeFilter,
              onChanged: (v) => setState(() => _typeFilter = v),
              showSearch: false,
              clearable: true,
            ),
            const SizedBox(height: 12),
            PosSearchableDropdown<bool>(
              label: 'Status',
              items: const [
                PosDropdownItem(value: true, label: 'Active'),
                PosDropdownItem(value: false, label: 'Inactive'),
              ],
              selectedValue: _activeFilter,
              onChanged: (v) => setState(() => _activeFilter = v),
              showSearch: false,
              clearable: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _applyFilters();
                },
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPromotionForm(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PromotionFormPage()));
  }
}

// ─── Promotion Card Widget ──────────────────────────────────────

class _PromotionCard extends ConsumerWidget {
  final Promotion promotion;
  const _PromotionCard({required this.promotion});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isActive = promotion.isActive ?? false;
    final isCoupon = promotion.isCoupon ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionFormPage(promotionId: promotion.id))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Icon
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isCoupon ? Icons.confirmation_number_outlined : Icons.local_offer_outlined,
                  color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline,
                ),
              ),
              const SizedBox(width: 12),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(promotion.name, style: theme.textTheme.titleSmall),
                    const SizedBox(height: 2),
                    Text(_promoSummary(promotion), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline)),
                    if (promotion.validTo != null)
                      Text(
                        'Expires: ${_formatDate(promotion.validTo!)}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outline),
                      ),
                  ],
                ),
              ),
              // Toggle + Actions
              Column(
                children: [
                  Switch(value: isActive, onChanged: (_) => ref.read(promotionsProvider.notifier).togglePromotion(promotion.id)),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onSelected: (action) => _handleAction(context, ref, action),
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'analytics', child: Text('Analytics')),
                      if (isCoupon) const PopupMenuItem(value: 'generate', child: Text('Generate Coupons')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _promoSummary(Promotion p) {
    return switch (p.type) {
      PromotionType.percentage => '${p.discountValue?.toStringAsFixed(0) ?? '?'}% off',
      PromotionType.fixedAmount => '${p.discountValue?.toStringAsFixed(2)} off',
      PromotionType.bogo => 'Buy ${p.buyQuantity} Get ${p.getQuantity}',
      PromotionType.bundle => 'Bundle @ ${p.bundlePrice?.toStringAsFixed(2)}',
      PromotionType.happyHour => 'Happy Hour ${p.discountValue?.toStringAsFixed(0) ?? '?'}%',
    };
  }

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'edit':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionFormPage(promotionId: promotion.id)));
      case 'analytics':
        Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionAnalyticsPage(promotionId: promotion.id)));
      case 'generate':
        _showGenerateCouponsDialog(context, ref);
      case 'delete':
        _confirmDelete(context, ref);
    }
  }

  void _showGenerateCouponsDialog(BuildContext context, WidgetRef ref) {
    final countController = TextEditingController(text: '10');
    final prefixController = TextEditingController();
    final maxUsesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Generate Coupons'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: countController,
              decoration: const InputDecoration(labelText: 'Count *', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: prefixController,
              decoration: const InputDecoration(labelText: 'Prefix (optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: maxUsesController,
              decoration: const InputDecoration(labelText: 'Max Uses Per Coupon (optional)', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final count = int.tryParse(countController.text) ?? 10;
              final prefix = prefixController.text.isNotEmpty ? prefixController.text : null;
              final maxUses = maxUsesController.text.isNotEmpty ? int.tryParse(maxUsesController.text) : null;
              ref.read(promotionRepositoryProvider).generateCoupons(promotion.id, count: count, prefix: prefix, maxUses: maxUses);
              Navigator.pop(ctx);
              showPosInfoSnackbar(context, AppLocalizations.of(context)!.generatingCoupons(count.toString()));
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Delete Promotion',
      message: 'Delete "${promotion.name}"? This action cannot be undone.',
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(promotionsProvider.notifier).deletePromotion(promotion.id);
    }
  }
}

// ─── Promotion Form Page ────────────────────────────────────────

class PromotionFormPage extends ConsumerStatefulWidget {
  final String? promotionId;
  const PromotionFormPage({super.key, this.promotionId});

  @override
  ConsumerState<PromotionFormPage> createState() => _PromotionFormPageState();
}

class _PromotionFormPageState extends ConsumerState<PromotionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _discountValueController = TextEditingController();
  final _buyQtyController = TextEditingController();
  final _getQtyController = TextEditingController();
  final _getDiscountController = TextEditingController();
  final _bundlePriceController = TextEditingController();
  final _maxUsesController = TextEditingController();
  final _maxUsesPerCustomerController = TextEditingController();
  final _minOrderTotalController = TextEditingController();

  PromotionType _selectedType = PromotionType.percentage;
  bool _isActive = true;
  bool _isCoupon = false;
  bool _isStackable = false;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.promotionId != null;
    if (_isEditing) {
      Future.microtask(() {
        ref.read(promotionDetailProvider(widget.promotionId).notifier).load();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _discountValueController.dispose();
    _buyQtyController.dispose();
    _getQtyController.dispose();
    _getDiscountController.dispose();
    _bundlePriceController.dispose();
    _maxUsesController.dispose();
    _maxUsesPerCustomerController.dispose();
    _minOrderTotalController.dispose();
    super.dispose();
  }

  void _populateFromPromotion(Promotion p) {
    _nameController.text = p.name;
    _descriptionController.text = p.description ?? '';
    _selectedType = p.type;
    _discountValueController.text = p.discountValue?.toString() ?? '';
    _buyQtyController.text = p.buyQuantity?.toString() ?? '';
    _getQtyController.text = p.getQuantity?.toString() ?? '';
    _getDiscountController.text = p.getDiscountPercent?.toString() ?? '';
    _bundlePriceController.text = p.bundlePrice?.toString() ?? '';
    _maxUsesController.text = p.maxUses?.toString() ?? '';
    _maxUsesPerCustomerController.text = p.maxUsesPerCustomer?.toString() ?? '';
    _minOrderTotalController.text = p.minOrderTotal?.toString() ?? '';
    _isActive = p.isActive ?? true;
    _isCoupon = p.isCoupon ?? false;
    _isStackable = p.isStackable ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isEditing) {
      final detailState = ref.watch(promotionDetailProvider(widget.promotionId));
      if (detailState is PromotionDetailLoading) {
        return Scaffold(
          appBar: AppBar(title: const Text('Edit Promotion')),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      if (detailState is PromotionDetailLoaded && _nameController.text.isEmpty) {
        _populateFromPromotion(detailState.promotion);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit Promotion' : 'New Promotion')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Promotion Name *', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            PosSearchableDropdown<PromotionType>(
              label: 'Type *',
              items: PromotionType.values.map((t) => PosDropdownItem(value: t, label: t.label)).toList(),
              selectedValue: _selectedType,
              onChanged: (v) => setState(() => _selectedType = v!),
              showSearch: false,
              clearable: false,
            ),
            const SizedBox(height: 14),

            // Conditional fields based on type
            if (_selectedType == PromotionType.percentage ||
                _selectedType == PromotionType.fixedAmount ||
                _selectedType == PromotionType.happyHour)
              TextFormField(
                controller: _discountValueController,
                decoration: InputDecoration(
                  labelText: _selectedType == PromotionType.percentage ? 'Discount %' : 'Discount Amount',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            if (_selectedType == PromotionType.bogo) ...[
              TextFormField(
                controller: _buyQtyController,
                decoration: const InputDecoration(labelText: 'Buy Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _getQtyController,
                decoration: const InputDecoration(labelText: 'Get Quantity', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _getDiscountController,
                decoration: const InputDecoration(labelText: 'Get Discount %', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ],
            if (_selectedType == PromotionType.bundle)
              TextFormField(
                controller: _bundlePriceController,
                decoration: const InputDecoration(labelText: 'Bundle Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),

            const SizedBox(height: 14),
            TextFormField(
              controller: _minOrderTotalController,
              decoration: const InputDecoration(labelText: 'Min Order Total', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _maxUsesController,
                    decoration: const InputDecoration(labelText: 'Max Uses', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _maxUsesPerCustomerController,
                    decoration: const InputDecoration(labelText: 'Max Per Customer', border: OutlineInputBorder()),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),
            SwitchListTile(title: const Text('Active'), value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
            SwitchListTile(
              title: const Text('Requires Coupon Code'),
              value: _isCoupon,
              onChanged: (v) => setState(() => _isCoupon = v),
            ),
            SwitchListTile(
              title: const Text('Stackable'),
              value: _isStackable,
              onChanged: (v) => setState(() => _isStackable = v),
            ),

            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton(onPressed: _submit, child: Text(_isEditing ? 'Update Promotion' : 'Create Promotion')),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final data = <String, dynamic>{
      'name': _nameController.text,
      'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      'type': _selectedType.value,
      'is_active': _isActive,
      'is_coupon': _isCoupon,
      'is_stackable': _isStackable,
    };

    if (_discountValueController.text.isNotEmpty) {
      data['discount_value'] = double.tryParse(_discountValueController.text);
    }
    if (_buyQtyController.text.isNotEmpty) data['buy_quantity'] = int.tryParse(_buyQtyController.text);
    if (_getQtyController.text.isNotEmpty) data['get_quantity'] = int.tryParse(_getQtyController.text);
    if (_getDiscountController.text.isNotEmpty) data['get_discount_percent'] = double.tryParse(_getDiscountController.text);
    if (_bundlePriceController.text.isNotEmpty) data['bundle_price'] = double.tryParse(_bundlePriceController.text);
    if (_maxUsesController.text.isNotEmpty) data['max_uses'] = int.tryParse(_maxUsesController.text);
    if (_maxUsesPerCustomerController.text.isNotEmpty)
      data['max_uses_per_customer'] = int.tryParse(_maxUsesPerCustomerController.text);
    if (_minOrderTotalController.text.isNotEmpty) data['min_order_total'] = double.tryParse(_minOrderTotalController.text);

    ref.read(promotionDetailProvider(widget.promotionId).notifier).save(data).then((_) {
      ref.read(promotionsProvider.notifier).load();
      if (mounted) Navigator.pop(context);
    });
  }
}
