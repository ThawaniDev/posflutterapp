import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/promotions/enums/promotion_type.dart';
import 'package:wameedpos/features/promotions/models/promotion.dart';
import 'package:wameedpos/features/promotions/pages/coupon_management_page.dart';
import 'package:wameedpos/features/promotions/pages/promotion_analytics_page.dart';
import 'package:wameedpos/features/promotions/pages/promotion_form_page.dart';
import 'package:wameedpos/features/promotions/providers/promotion_providers.dart';
import 'package:wameedpos/features/promotions/providers/promotion_state.dart';
import 'package:wameedpos/features/promotions/repositories/promotion_repository.dart';

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
    final state = ref.watch(promotionsProvider);
    final promotions = state is PromotionsLoaded ? state.promotions : <Promotion>[];
    final isLoading = state is PromotionsLoading || state is PromotionsInitial;
    final error = state is PromotionsError ? state.message : null;

    return PermissionGuardPage(
      permission: Permissions.promotionsManage,
      child: PosListPage(
        title: l10n.featureInfoPromotionsTitle,
        searchController: _searchController,
        onSearchChanged: (_) => _applyFilters(),
        actions: [
          PosButton.icon(
            icon: Icons.info_outline,
            tooltip: l10n.featureInfoTooltip,
            onPressed: () => showPromotionListInfo(context),
          ),
          PosButton.icon(icon: Icons.filter_list, tooltip: l10n.promoFilter, onPressed: _showFilterSheet),
          PosButton(
            label: l10n.promoNew,
            icon: Icons.add,
            variant: PosButtonVariant.primary,
            size: PosButtonSize.sm,
            onPressed: () => _openPromotionForm(context),
          ),
        ],
        filters: [
          if (_typeFilter != null)
            Chip(
              label: Text(_typeFilter!),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () {
                setState(() => _typeFilter = null);
                _applyFilters();
              },
            ),
          if (_activeFilter != null)
            Chip(
              label: Text(_activeFilter! ? l10n.active : l10n.inactive),
              deleteIcon: const Icon(Icons.close, size: 14),
              onDeleted: () {
                setState(() => _activeFilter = null);
                _applyFilters();
              },
            ),
        ],
        child: PosDataTable<Promotion>(
          columns: [
            PosTableColumn(title: l10n.name),
            PosTableColumn(title: l10n.txColType),
            PosTableColumn(title: l10n.status),
            PosTableColumn(title: l10n.validityPeriod),
            PosTableColumn(title: l10n.usage),
          ],
          items: promotions,
          isLoading: isLoading,
          error: error,
          onRetry: _applyFilters,
          emptyConfig: PosTableEmptyConfig(
            icon: Icons.local_offer_outlined,
            title: l10n.promoNoFound,
            subtitle: l10n.promoNoFoundSubtitle,
            actionLabel: l10n.promoNew,
            action: () => _openPromotionForm(context),
          ),
          actions: [
            PosTableRowAction<Promotion>(
              label: l10n.edit,
              icon: Icons.edit_outlined,
              onTap: (p) => _openPromotionForm(context, promotionId: p.id),
            ),
            PosTableRowAction<Promotion>(
              label: l10n.promotionsAnalytics,
              icon: Icons.bar_chart_rounded,
              onTap: (p) => Navigator.push(context, MaterialPageRoute(builder: (_) => PromotionAnalyticsPage(promotionId: p.id))),
            ),
            PosTableRowAction<Promotion>(
              label: l10n.promoDuplicate,
              icon: Icons.copy_outlined,
              onTap: (p) => _duplicatePromotion(p),
            ),
            PosTableRowAction<Promotion>(
              label: l10n.generateCoupons,
              icon: Icons.confirmation_number_outlined,
              isVisible: (p) => p.isCoupon == true,
              onTap: (p) => _showGenerateCouponsDialog(p),
            ),
            PosTableRowAction<Promotion>(
              label: l10n.promoManageCoupons,
              icon: Icons.list_alt_rounded,
              isVisible: (p) => p.isCoupon == true,
              onTap: (p) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CouponManagementPage(promotionId: p.id, promotionName: p.name),
                ),
              ),
            ),
            PosTableRowAction<Promotion>(
              label: l10n.delete,
              icon: Icons.delete_outline,
              isDestructive: true,
              onTap: (p) => _confirmDelete(p),
            ),
          ],
          cellBuilder: (promo, colIndex, col) {
            switch (colIndex) {
              case 0: // Name
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (promo.isActive ?? false) ? AppColors.primary.withValues(alpha: 0.12) : Colors.grey.shade200,
                        borderRadius: AppRadius.borderMd,
                      ),
                      child: Icon(
                        (promo.isCoupon ?? false) ? Icons.confirmation_number_outlined : Icons.local_offer_outlined,
                        size: 16,
                        color: (promo.isActive ?? false) ? AppColors.primary : Colors.grey.shade400,
                      ),
                    ),
                    AppSpacing.gapW8,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(promo.name, style: Theme.of(context).textTheme.labelMedium, overflow: TextOverflow.ellipsis),
                          if (promo.description != null && promo.description!.isNotEmpty)
                            Text(
                              promo.description!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                );

              case 1: // Type
                return PosBadge(label: promo.type.label, customColor: _typeColor(promo.type), isSmall: true);

              case 2: // Status
                return GestureDetector(
                  onTap: () => ref.read(promotionsProvider.notifier).togglePromotion(promo.id),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PosStatusBadge(
                        label: (promo.isActive ?? false) ? l10n.active : l10n.inactive,
                        variant: (promo.isActive ?? false) ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.neutral,
                      ),
                      AppSpacing.gapW4,
                      Icon(Icons.swap_horiz_rounded, size: 14, color: Colors.grey.shade400),
                    ],
                  ),
                );

              case 3: // Valid Period
                final from = promo.validFrom;
                final to = promo.validTo;
                final now = DateTime.now();
                final isExpired = to != null && to.isBefore(now);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (from != null) Text(_formatDate(from), style: Theme.of(context).textTheme.bodySmall),
                    if (to != null) ...[
                      Text(
                        '→ ${_formatDate(to)}',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: isExpired ? AppColors.error : Colors.grey.shade400),
                      ),
                    ] else
                      Text(l10n.noExpiry, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400)),
                  ],
                );

              case 4: // Usage
                final used = promo.usageCount ?? 0;
                final max = promo.maxUses;
                final pct = max != null && max > 0 ? (used / max).clamp(0.0, 1.0) : null;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(max != null ? '$used / $max' : '$used', style: Theme.of(context).textTheme.labelSmall),
                    if (pct != null) ...[
                      AppSpacing.gapH4,
                      SizedBox(
                        width: 80,
                        child: ClipRRect(
                          borderRadius: AppRadius.borderSm,
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 4,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              pct >= 0.9
                                  ? AppColors.error
                                  : pct >= 0.6
                                  ? AppColors.warning
                                  : AppColors.success,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                );

              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Color _typeColor(PromotionType type) => switch (type) {
    PromotionType.percentage => AppColors.primary,
    PromotionType.fixedAmount => AppColors.info,
    PromotionType.bogo => AppColors.success,
    PromotionType.bundle => AppColors.warning,
    PromotionType.happyHour => const Color(0xFF8B5CF6),
  };

  String _formatDate(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(l10n.promoFilter, style: Theme.of(ctx).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            AppSpacing.gapH16,
            PosSearchableDropdown<String>(
              hint: l10n.allTypes,
              label: l10n.txColType,
              items: PromotionType.values.map((t) => PosDropdownItem(value: t.value, label: t.label)).toList(),
              selectedValue: _typeFilter,
              onChanged: (v) => setState(() => _typeFilter = v),
              showSearch: false,
              clearable: true,
            ),
            AppSpacing.gapH12,
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
            AppSpacing.gapH20,
            Row(
              children: [
                Expanded(
                  child: PosButton(
                    onPressed: () {
                      setState(() {
                        _typeFilter = null;
                        _activeFilter = null;
                      });
                      Navigator.pop(ctx);
                      _applyFilters();
                    },
                    variant: PosButtonVariant.ghost,
                    label: l10n.clearFilters,
                  ),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: PosButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _applyFilters();
                    },
                    variant: PosButtonVariant.primary,
                    label: l10n.apply,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openPromotionForm(BuildContext context, {String? promotionId}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PromotionFormPage(promotionId: promotionId)),
    ).then((_) => _applyFilters());
  }

  Future<void> _duplicatePromotion(Promotion promo) async {
    try {
      await ref.read(promotionRepositoryProvider).duplicatePromotion(promo.id);
      await ref.read(promotionsProvider.notifier).load();
      if (!mounted) return;
      showPosInfoSnackbar(context, l10n.promoDuplicated);
    } catch (e) {
      if (!mounted) return;
      showPosErrorSnackbar(context, e.toString());
    }
  }

  void _showGenerateCouponsDialog(Promotion promo) {
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
            AppSpacing.gapH12,
            PosTextField(
              controller: prefixController,
              decoration: InputDecoration(labelText: l10n.prefixOptional, border: const OutlineInputBorder()),
            ),
            AppSpacing.gapH12,
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
            onPressed: () async {
              final count = int.tryParse(countController.text) ?? 10;
              final prefix = prefixController.text.isNotEmpty ? prefixController.text : null;
              final maxUses = maxUsesController.text.isNotEmpty ? int.tryParse(maxUsesController.text) : null;
              Navigator.pop(ctx);
              try {
                await ref
                    .read(promotionRepositoryProvider)
                    .generateCoupons(promo.id, count: count, prefix: prefix, maxUses: maxUses);
                if (!mounted) return;
                showPosInfoSnackbar(context, l10n.generatingCoupons(count.toString()));
              } catch (e) {
                if (!mounted) return;
                showPosErrorSnackbar(context, e.toString());
              }
            },
            variant: PosButtonVariant.primary,
            label: l10n.generate,
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(Promotion promo) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.promotionsDeletePromotion,
      message: l10n.promoDeleteConfirm(promo.name),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed == true && mounted) {
      ref.read(promotionsProvider.notifier).deletePromotion(promo.id);
    }
  }
}

