import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/catalog/providers/catalog_providers.dart';
import 'package:wameedpos/features/catalog/providers/catalog_state.dart';
import 'package:wameedpos/features/customers/providers/customer_providers.dart';
import 'package:wameedpos/features/customers/providers/customer_state.dart';
import 'package:wameedpos/features/promotions/enums/promotion_type.dart';
import 'package:wameedpos/features/promotions/models/promotion.dart';
import 'package:wameedpos/features/promotions/providers/promotion_providers.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';

const _weekdayKeys = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];

class PromotionFormPage extends ConsumerStatefulWidget {
  const PromotionFormPage({super.key, this.promotionId});
  final String? promotionId;

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
  final _minItemQuantityController = TextEditingController();

  PromotionType _selectedType = PromotionType.percentage;
  bool _isActive = true;
  bool _isCoupon = false;
  bool _isStackable = false;
  bool _isEditing = false;
  bool _hydrated = false;
  bool _submitting = false;

  DateTime? _validFrom;
  DateTime? _validTo;
  TimeOfDay? _activeTimeFrom;
  TimeOfDay? _activeTimeTo;
  final Set<String> _activeDays = {};
  final Set<String> _productIds = {};
  final Set<String> _categoryIds = {};
  final Set<String> _customerGroupIds = {};
  final List<BundleProductEntry> _bundleProducts = [];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.promotionId != null;
    Future.microtask(() {
      ref.read(productsProvider.notifier).load();
      ref.read(categoriesProvider.notifier).load();
      ref.read(customerGroupsProvider.notifier).load();
      if (_isEditing) {
        ref.read(promotionDetailProvider(widget.promotionId).notifier).load();
      }
    });
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
    _minItemQuantityController.dispose();
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
    _minItemQuantityController.text = p.minItemQuantity?.toString() ?? '';
    _isActive = p.isActive ?? true;
    _isCoupon = p.isCoupon ?? false;
    _isStackable = p.isStackable ?? false;
    _validFrom = p.validFrom;
    _validTo = p.validTo;
    _activeTimeFrom = _parseTimeOfDay(p.activeTimeFrom);
    _activeTimeTo = _parseTimeOfDay(p.activeTimeTo);
    _activeDays
      ..clear()
      ..addAll(p.activeDays);
    _productIds
      ..clear()
      ..addAll(p.productIds);
    _categoryIds
      ..clear()
      ..addAll(p.categoryIds);
    _customerGroupIds
      ..clear()
      ..addAll(p.customerGroupIds);
    _bundleProducts
      ..clear()
      ..addAll(p.bundleProducts);
  }

  TimeOfDay? _parseTimeOfDay(String? s) {
    if (s == null || s.isEmpty) return null;
    final parts = s.split(':');
    if (parts.length < 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTimeOfDay(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_isEditing && !_hydrated) {
      final detailState = ref.watch(promotionDetailProvider(widget.promotionId));
      if (detailState is PromotionDetailLoading) {
        return PosFormPage(title: l10n.promoEdit, isLoading: true, child: const SizedBox.shrink());
      }
      if (detailState is PromotionDetailLoaded) {
        _populateFromPromotion(detailState.promotion);
        _hydrated = true;
      }
    }

    return PosFormPage(
      title: _isEditing ? l10n.promoEdit : l10n.promoNew,
      bottomBar: PosButton(
        label: _isEditing ? l10n.promoUpdate : l10n.promoCreate,
        onPressed: _submitting ? null : _submit,
        isLoading: _submitting,
        isFullWidth: true,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section(l10n.promoBasicInfo, [
              PosTextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: l10n.promotionName, border: const OutlineInputBorder()),
                validator: (v) => (v == null || v.isEmpty) ? l10n.fieldRequired : null,
              ),
              const SizedBox(height: 12),
              PosTextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: l10n.description, border: const OutlineInputBorder()),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              PosSearchableDropdown<PromotionType>(
                hint: l10n.selectType,
                label: l10n.promoTypeRequired,
                items: PromotionType.values.map((t) => PosDropdownItem(value: t, label: t.label)).toList(),
                selectedValue: _selectedType,
                onChanged: (v) => setState(() => _selectedType = v!),
                showSearch: false,
                clearable: false,
              ),
            ]),
            _buildDiscountSection(l10n),
            _buildValiditySection(l10n),
            _buildTargetingSection(l10n),
            _buildLimitsSection(l10n),
            _buildFlagsSection(l10n),
            if (_selectedType == PromotionType.bundle) _buildBundleSection(l10n),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: PosCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscountSection(AppLocalizations l10n) {
    return _section(l10n.promoDiscountSection, [
      if (_selectedType == PromotionType.percentage ||
          _selectedType == PromotionType.fixedAmount ||
          _selectedType == PromotionType.happyHour)
        PosTextField(
          controller: _discountValueController,
          decoration: InputDecoration(
            labelText: _selectedType == PromotionType.percentage ? l10n.discountPercentage : l10n.discountAmount,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
      if (_selectedType == PromotionType.bogo) ...[
        Row(
          children: [
            Expanded(
              child: PosTextField(
                controller: _buyQtyController,
                decoration: InputDecoration(labelText: l10n.buyQuantity, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: PosTextField(
                controller: _getQtyController,
                decoration: InputDecoration(labelText: l10n.getQuantity, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        PosTextField(
          controller: _getDiscountController,
          decoration: InputDecoration(labelText: l10n.getDiscount, border: const OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
      ],
      if (_selectedType == PromotionType.bundle)
        PosTextField(
          controller: _bundlePriceController,
          decoration: InputDecoration(labelText: l10n.bundlePrice, border: const OutlineInputBorder()),
          keyboardType: TextInputType.number,
        ),
    ]);
  }

  Widget _buildValiditySection(AppLocalizations l10n) {
    return _section(l10n.promoValiditySection, [
      Row(
        children: [
          Expanded(child: _dateField(l10n.validFrom, _validFrom, (d) => setState(() => _validFrom = d))),
          const SizedBox(width: 12),
          Expanded(child: _dateField(l10n.validTo, _validTo, (d) => setState(() => _validTo = d))),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(child: _timeField(l10n.activeTimeFrom, _activeTimeFrom, (t) => setState(() => _activeTimeFrom = t))),
          const SizedBox(width: 12),
          Expanded(child: _timeField(l10n.activeTimeTo, _activeTimeTo, (t) => setState(() => _activeTimeTo = t))),
        ],
      ),
      const SizedBox(height: 12),
      Text(l10n.activeDays, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 6),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: _weekdayKeys.map((k) {
          final selected = _activeDays.contains(k);
          return FilterChip(
            label: Text(_weekdayLabel(l10n, k)),
            selected: selected,
            onSelected: (v) => setState(() => v ? _activeDays.add(k) : _activeDays.remove(k)),
          );
        }).toList(),
      ),
    ]);
  }

  String _weekdayLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'monday':
        return l10n.monday;
      case 'tuesday':
        return l10n.tuesday;
      case 'wednesday':
        return l10n.wednesday;
      case 'thursday':
        return l10n.thursday;
      case 'friday':
        return l10n.friday;
      case 'saturday':
        return l10n.saturday;
      case 'sunday':
        return l10n.sunday;
    }
    return key;
  }

  Widget _dateField(String label, DateTime? value, ValueChanged<DateTime?> onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: value == null
              ? const Icon(Icons.calendar_today)
              : IconButton(icon: const Icon(Icons.clear), onPressed: () => onChanged(null)),
        ),
        child: Text(
          value == null ? '—' : '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}',
        ),
      ),
    );
  }

  Widget _timeField(String label, TimeOfDay? value, ValueChanged<TimeOfDay?> onChanged) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: value ?? TimeOfDay.now());
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: value == null
              ? const Icon(Icons.access_time)
              : IconButton(icon: const Icon(Icons.clear), onPressed: () => onChanged(null)),
        ),
        child: Text(value == null ? '—' : _formatTimeOfDay(value)),
      ),
    );
  }

  Widget _buildTargetingSection(AppLocalizations l10n) {
    final productsState = ref.watch(productsProvider);
    final categoriesState = ref.watch(categoriesProvider);
    final groupsState = ref.watch(customerGroupsProvider);

    return _section(l10n.promoTargetingSection, [
      _multiSelectField<String>(
        label: l10n.products,
        selected: _productIds,
        options: productsState is ProductsLoaded
            ? productsState.products.map((p) => _Opt(id: p.id, label: p.name)).toList()
            : const [],
      ),
      const SizedBox(height: 12),
      _multiSelectField<String>(
        label: l10n.categories,
        selected: _categoryIds,
        options: categoriesState is CategoriesLoaded
            ? categoriesState.categories.map((c) => _Opt(id: c.id, label: c.name)).toList()
            : const [],
      ),
      const SizedBox(height: 12),
      _multiSelectField<String>(
        label: l10n.customerGroups,
        selected: _customerGroupIds,
        options: groupsState is CustomerGroupsLoaded
            ? groupsState.groups.map((g) => _Opt(id: g.id, label: g.name)).toList()
            : const [],
      ),
    ]);
  }

  Widget _multiSelectField<T>({required String label, required Set<String> selected, required List<_Opt> options}) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          ...options
              .take(40)
              .map(
                (o) => FilterChip(
                  label: Text(o.label, overflow: TextOverflow.ellipsis),
                  selected: selected.contains(o.id),
                  onSelected: (v) => setState(() => v ? selected.add(o.id) : selected.remove(o.id)),
                ),
              ),
          if (options.length > 40)
            TextButton.icon(
              icon: const Icon(Icons.search),
              label: Text(AppLocalizations.of(context)!.seeAll),
              onPressed: () => _openMultiSelectSheet(label, selected, options),
            ),
        ],
      ),
    );
  }

  Future<void> _openMultiSelectSheet(String title, Set<String> selected, List<_Opt> options) async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            final q = controller.text.toLowerCase();
            final filtered = q.isEmpty ? options : options.where((o) => o.label.toLowerCase().contains(q)).toList();
            return SafeArea(
              child: SizedBox(
                height: MediaQuery.of(ctx).size.height * 0.7,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(child: Text(title, style: Theme.of(ctx).textTheme.titleMedium)),
                          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PosTextField(
                        controller: controller,
                        decoration: const InputDecoration(prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                        onChanged: (_) => setSheet(() {}),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final o = filtered[i];
                          final isSel = selected.contains(o.id);
                          return CheckboxListTile(
                            title: Text(o.label),
                            value: isSel,
                            onChanged: (v) {
                              setState(() => (v ?? false) ? selected.add(o.id) : selected.remove(o.id));
                              setSheet(() {});
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLimitsSection(AppLocalizations l10n) {
    return _section(l10n.promoLimitsSection, [
      Row(
        children: [
          Expanded(
            child: PosTextField(
              controller: _minOrderTotalController,
              decoration: InputDecoration(labelText: l10n.minOrderTotal, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PosTextField(
              controller: _minItemQuantityController,
              decoration: InputDecoration(labelText: l10n.minItemQuantity, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: PosTextField(
              controller: _maxUsesController,
              decoration: InputDecoration(labelText: l10n.maxUses, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PosTextField(
              controller: _maxUsesPerCustomerController,
              decoration: InputDecoration(labelText: l10n.maxPerCustomer, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    ]);
  }

  Widget _buildFlagsSection(AppLocalizations l10n) {
    return _section(l10n.promoFlagsSection, [
      SwitchListTile(title: Text(l10n.active), value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
      SwitchListTile(title: Text(l10n.requiresCouponCode), value: _isCoupon, onChanged: (v) => setState(() => _isCoupon = v)),
      SwitchListTile(title: Text(l10n.stackable), value: _isStackable, onChanged: (v) => setState(() => _isStackable = v)),
    ]);
  }

  Widget _buildBundleSection(AppLocalizations l10n) {
    final productsState = ref.watch(productsProvider);
    final products = productsState is ProductsLoaded ? productsState.products : [];
    return _section(l10n.promoBundleSection, [
      ...List.generate(_bundleProducts.length, (i) {
        final entry = _bundleProducts[i];
        final product = products.cast<dynamic>().firstWhere((p) => p.id == entry.productId, orElse: () => null);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(flex: 3, child: Text(product?.name ?? entry.productId)),
              const SizedBox(width: 8),
              SizedBox(
                width: 80,
                child: TextFormField(
                  initialValue: entry.quantity.toString(),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
                  onChanged: (v) {
                    final q = int.tryParse(v) ?? 1;
                    _bundleProducts[i] = BundleProductEntry(productId: entry.productId, quantity: q);
                  },
                ),
              ),
              IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => setState(() => _bundleProducts.removeAt(i))),
            ],
          ),
        );
      }),
      OutlinedButton.icon(
        icon: const Icon(Icons.add),
        label: Text(l10n.promoAddBundleProduct),
        onPressed: () async {
          final opts = products.map((p) => _Opt(id: p.id as String, label: p.name as String)).toList();
          final picked = await _pickOne(l10n.products, opts);
          if (picked != null) {
            setState(() => _bundleProducts.add(BundleProductEntry(productId: picked, quantity: 1)));
          }
        },
      ),
    ]);
  }

  Future<String?> _pickOne(String title, List<_Opt> options) async {
    final controller = TextEditingController();
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) {
          final q = controller.text.toLowerCase();
          final filtered = q.isEmpty ? options : options.where((o) => o.label.toLowerCase().contains(q)).toList();
          return SafeArea(
            child: SizedBox(
              height: MediaQuery.of(ctx).size.height * 0.7,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: PosTextField(
                      controller: controller,
                      decoration: const InputDecoration(prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                      onChanged: (_) => setSheet(() {}),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          ListTile(title: Text(filtered[i].label), onTap: () => Navigator.pop(ctx, filtered[i].id)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    final data = <String, dynamic>{
      'name': _nameController.text,
      'description': _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
      'type': _selectedType.value,
      'is_active': _isActive,
      'is_coupon': _isCoupon,
      'is_stackable': _isStackable,
      'active_days': _activeDays.toList(),
    };

    if (_discountValueController.text.isNotEmpty) data['discount_value'] = double.tryParse(_discountValueController.text);
    if (_buyQtyController.text.isNotEmpty) data['buy_quantity'] = int.tryParse(_buyQtyController.text);
    if (_getQtyController.text.isNotEmpty) data['get_quantity'] = int.tryParse(_getQtyController.text);
    if (_getDiscountController.text.isNotEmpty) data['get_discount_percent'] = double.tryParse(_getDiscountController.text);
    if (_bundlePriceController.text.isNotEmpty) data['bundle_price'] = double.tryParse(_bundlePriceController.text);
    if (_maxUsesController.text.isNotEmpty) data['max_uses'] = int.tryParse(_maxUsesController.text);
    if (_maxUsesPerCustomerController.text.isNotEmpty) {
      data['max_uses_per_customer'] = int.tryParse(_maxUsesPerCustomerController.text);
    }
    if (_minOrderTotalController.text.isNotEmpty) data['min_order_total'] = double.tryParse(_minOrderTotalController.text);
    if (_minItemQuantityController.text.isNotEmpty) data['min_item_quantity'] = int.tryParse(_minItemQuantityController.text);
    if (_validFrom != null) data['valid_from'] = _validFrom!.toIso8601String();
    if (_validTo != null) data['valid_to'] = _validTo!.toIso8601String();
    if (_activeTimeFrom != null) data['active_time_from'] = _formatTimeOfDay(_activeTimeFrom!);
    if (_activeTimeTo != null) data['active_time_to'] = _formatTimeOfDay(_activeTimeTo!);
    if (_productIds.isNotEmpty) data['product_ids'] = _productIds.toList();
    if (_categoryIds.isNotEmpty) data['category_ids'] = _categoryIds.toList();
    if (_customerGroupIds.isNotEmpty) data['customer_group_ids'] = _customerGroupIds.toList();
    if (_bundleProducts.isNotEmpty) data['bundle_products'] = _bundleProducts.map((b) => b.toJson()).toList();

    try {
      await ref.read(promotionDetailProvider(widget.promotionId).notifier).save(data);
      ref.read(promotionsProvider.notifier).load();
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      showPosErrorSnackbar(context, e.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}

class _Opt {
  const _Opt({required this.id, required this.label});
  final String id;
  final String label;
}
