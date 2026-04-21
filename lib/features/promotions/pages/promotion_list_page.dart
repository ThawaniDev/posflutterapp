import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/promotions/enums/promotion_type.dart';
import 'package:wameedpos/features/promotions/models/promotion.dart';
import 'package:wameedpos/features/promotions/providers/promotion_providers.dart';
import 'package:wameedpos/features/promotions/pages/promotion_analytics_page.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';
import 'package:wameedpos/features/promotions/repositories/promotion_repository.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class PromotionListPage extends ConsumerStatefulWidget {
  const PromotionListPage({super.key});

  @override
  ConsumerState<PromotionListPage> createState() => _PromotionListPageState();
}

class _PromotionListPageState extends ConsumerState<PromotionListPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(promotionsProvider);
    final theme = Theme.of(context);

    return PosListPage(
      title: l10n.featureInfoPromotionsTitle,
      searchController: _searchController,
      onSearchChanged: (_) => _applyFilters(),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showPromotionListInfo(context),
        ),
        IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterSheet),
        PosButton(label: l10n.add, icon: Icons.add, onPressed: () => _openPromotionForm(context)),
      ],
      filters: [
        if (_typeFilter != null)
          Chip(
            label: Text(_typeFilter!),
            onDeleted: () => setState(() {
              _typeFilter = null;
              _applyFilters();
            }),
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
      child: switch (state) {
        PromotionsInitial() || PromotionsLoading() => const PosLoading(),
        PromotionsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
              const SizedBox(height: 12),
              Text(message, style: TextStyle(color: theme.colorScheme.error)),
              const SizedBox(height: 16),
              PosButton(onPressed: _applyFilters, icon: Icons.refresh, label: l10n.retry),
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
                      Text(AppLocalizations.of(context)!.promoNoFound, style: theme.textTheme.bodyLarge),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(promotionsProvider.notifier).load(),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: promotions.length,
                    itemBuilder: (context, index) => _PromotionCard(promotion: promotions[index]),
                  ),
                ),
      },
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
              hint: l10n.allTypes,
              label: l10n.txColType,
              items: PromotionType.values.map((t) => PosDropdownItem(value: t.value, label: t.label)).toList(),
              selectedValue: _typeFilter,
              onChanged: (v) => setState(() => _typeFilter = v),
              showSearch: false,
              clearable: true,
            ),
            const SizedBox(height: 12),
            PosSearchableDropdown<bool>(
              hint: l10n.allStatuses,
              label: l10n.status,
              items: [
                PosDropdownItem(value: true, label: l10n.active),
                PosDropdownItem(value: false, label: l10n.inactive),
              ],
              selectedValue: _activeFilter,
              onChanged: (v) => setState(() => _activeFilter = v),
              showSearch: false,
              clearable: true,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: PosButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _applyFilters();
                },
                variant: PosButtonVariant.soft,
                label: l10n.apply,
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
  const _PromotionCard({required this.promotion});
  final Promotion promotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = promotion.isActive ?? false;
    final isCoupon = promotion.isCoupon ?? false;

    return PosCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: AppRadius.borderLg,
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
                  borderRadius: AppRadius.borderLg,
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
                      PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                      PopupMenuItem(value: 'analytics', child: Text(l10n.analytics)),
                      if (isCoupon) PopupMenuItem(value: 'generate', child: Text(l10n.generateCoupons)),
                      PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
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
    final l10n = AppLocalizations.of(context)!;
    final countController = TextEditingController(text: '10');
    final prefixController = TextEditingController();
    final maxUsesController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.generateCoupons),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(
              controller: countController,
              decoration: InputDecoration(labelText: l10n.count, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            PosTextField(
              controller: prefixController,
              decoration: InputDecoration(labelText: l10n.prefixOptional, border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            PosTextField(
              controller: maxUsesController,
              decoration: InputDecoration(labelText: l10n.maxUsesPerCouponOptional, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.cancel),
          PosButton(
            onPressed: () {
              final count = int.tryParse(countController.text) ?? 10;
              final prefix = prefixController.text.isNotEmpty ? prefixController.text : null;
              final maxUses = maxUsesController.text.isNotEmpty ? int.tryParse(maxUsesController.text) : null;
              ref.read(promotionRepositoryProvider).generateCoupons(promotion.id, count: count, prefix: prefix, maxUses: maxUses);
              Navigator.pop(ctx);
              showPosInfoSnackbar(context, AppLocalizations.of(context)!.generatingCoupons(count.toString()));
            },
            variant: PosButtonVariant.soft,
            label: l10n.generate,
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.promotionsDeletePromotion,
      message: l10n.promoDeleteConfirm(promotion.name),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(promotionsProvider.notifier).deletePromotion(promotion.id);
    }
  }
}

// ─── Promotion Form Page ────────────────────────────────────────

class PromotionFormPage extends ConsumerStatefulWidget {
  const PromotionFormPage({super.key, this.promotionId});
  final String? promotionId;

  @override
  ConsumerState<PromotionFormPage> createState() => _PromotionFormPageState();
}

class _PromotionFormPageState extends ConsumerState<PromotionFormPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    if (_isEditing) {
      final detailState = ref.watch(promotionDetailProvider(widget.promotionId));
      if (detailState is PromotionDetailLoading) {
        return PosFormPage(title: l10n.promoEdit, isLoading: true, child: const SizedBox.shrink());
      }
      if (detailState is PromotionDetailLoaded && _nameController.text.isEmpty) {
        _populateFromPromotion(detailState.promotion);
      }
    }

    return PosFormPage(
      title: _isEditing ? 'Edit Promotion' : 'New Promotion',
      bottomBar: PosButton(label: _isEditing ? 'Update Promotion' : 'Create Promotion', onPressed: _submit, isFullWidth: true),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PosTextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.promotionName, border: const OutlineInputBorder()),
              validator: (v) => (v == null || v.isEmpty) ? 'Name is required' : null,
            ),
            const SizedBox(height: 14),
            PosTextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: l10n.description, border: const OutlineInputBorder()),
              maxLines: 2,
            ),
            const SizedBox(height: 14),
            PosSearchableDropdown<PromotionType>(
              hint: l10n.selectType,
              label: l10n.promoTypeRequired,
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
              PosTextField(
                controller: _discountValueController,
                decoration: InputDecoration(
                  labelText: _selectedType == PromotionType.percentage ? 'Discount %' : 'Discount Amount',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
            if (_selectedType == PromotionType.bogo) ...[
              PosTextField(
                controller: _buyQtyController,
                decoration: InputDecoration(labelText: l10n.buyQuantity, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
              PosTextField(
                controller: _getQtyController,
                decoration: InputDecoration(labelText: l10n.getQuantity, border: const OutlineInputBorder()),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),
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

            const SizedBox(height: 14),
            PosTextField(
              controller: _minOrderTotalController,
              decoration: InputDecoration(labelText: l10n.minOrderTotal, border: const OutlineInputBorder()),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 14),
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

            const SizedBox(height: 14),
            SwitchListTile(title: Text(l10n.active), value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
            SwitchListTile(
              title: Text(l10n.requiresCouponCode),
              value: _isCoupon,
              onChanged: (v) => setState(() => _isCoupon = v),
            ),
            SwitchListTile(title: Text(l10n.stackable), value: _isStackable, onChanged: (v) => setState(() => _isStackable = v)),
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
    if (_maxUsesPerCustomerController.text.isNotEmpty) {
      data['max_uses_per_customer'] = int.tryParse(_maxUsesPerCustomerController.text);
    }
    if (_minOrderTotalController.text.isNotEmpty) data['min_order_total'] = double.tryParse(_minOrderTotalController.text);

    ref.read(promotionDetailProvider(widget.promotionId).notifier).save(data).then((_) {
      ref.read(promotionsProvider.notifier).load();
      if (mounted) Navigator.pop(context);
    });
  }
}
