import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/promotions/models/coupon_code.dart';
import 'package:wameedpos/features/promotions/repositories/promotion_repository.dart';

class CouponManagementPage extends ConsumerStatefulWidget {
  const CouponManagementPage({super.key, required this.promotionId, required this.promotionName});
  final String promotionId;
  final String promotionName;

  @override
  ConsumerState<CouponManagementPage> createState() => _CouponManagementPageState();
}

class _CouponManagementPageState extends ConsumerState<CouponManagementPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;

  final _searchController = TextEditingController();
  bool _loading = false;
  String? _error;
  List<CouponCode> _coupons = const [];
  int _currentPage = 1;
  int _lastPage = 1;
  int _total = 0;
  bool? _activeFilter; // null = all, true = active, false = inactive

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({int page = 1}) async {
    setState(() { _loading = true; _error = null; });
    try {
      final repo = ref.read(promotionRepositoryProvider);
      final result = await repo.listPromotionCoupons(
        widget.promotionId,
        page: page,
        perPage: 20,
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
        isActive: _activeFilter,
      );
      setState(() {
        _coupons = result.items;
        _currentPage = result.currentPage;
        _lastPage = result.lastPage;
        _total = result.total;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PermissionGuardPage(
      permission: Permissions.promotionsManage,
      child: PosListPage(
        title: '${l10n.promoManageCoupons} — ${widget.promotionName}',
        searchController: _searchController,
        onSearchChanged: (_) => _load(),
        isLoading: _loading && _coupons.isEmpty,
        hasError: _error != null,
        errorMessage: _error,
        onRetry: _load,
        actions: [
          // Active filter toggle
          _FilterChip(
            label: l10n.allStatuses,
            activeLabel: l10n.active,
            inactiveLabel: l10n.inactive,
            value: _activeFilter,
            onChanged: (v) { setState(() => _activeFilter = v); _load(); },
          ),
          AppSpacing.gapW8,
          PosButton(
            label: l10n.generateCoupons,
            icon: Icons.add_rounded,
            variant: PosButtonVariant.primary,
            size: PosButtonSize.sm,
            onPressed: _showGenerateDialog,
          ),
        ],
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_coupons.isEmpty && !_loading) {
      return PosEmptyState(
        icon: Icons.confirmation_number_outlined,
        title: l10n.promoCouponsEmpty,
        subtitle: l10n.promoCouponsEmptySubtitle,
        actionLabel: l10n.generateCoupons,
        onAction: _showGenerateDialog,
      );
    }

    return Column(
      children: [
        // Total indicator
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Text(
                l10n.showingOf(_coupons.length.toString(), _total.toString()),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
              ),
            ],
          ),
        ),
        // Table
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _coupons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _CouponCard(
              coupon: _coupons[i],
              onDelete: () => _confirmDelete(_coupons[i]),
            ),
          ),
        ),
        // Pagination
        if (_lastPage > 1) _PaginationBar(
          currentPage: _currentPage,
          lastPage: _lastPage,
          onPageChange: (p) => _load(page: p),
          isLoading: _loading,
        ),
      ],
    );
  }

  Future<void> _confirmDelete(CouponCode c) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.commonDelete,
      message: l10n.promoCouponDeleteConfirm(c.code),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed != true) return;
    try {
      await ref.read(promotionRepositoryProvider).deleteCoupon(c.id);
      if (!mounted) return;
      showPosInfoSnackbar(context, l10n.promoCouponDeleted);
      await _load(page: _currentPage);
    } catch (e) {
      if (!mounted) return;
      showPosErrorSnackbar(context, e.toString());
    }
  }

  void _showGenerateDialog() {
    final countCtrl = TextEditingController(text: '10');
    final prefixCtrl = TextEditingController();
    final maxUsesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.generateCoupons),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(controller: countCtrl, label: l10n.count, keyboardType: TextInputType.number),
            AppSpacing.gapH12,
            PosTextField(controller: prefixCtrl, label: l10n.prefixOptional),
            AppSpacing.gapH12,
            PosTextField(controller: maxUsesCtrl, label: l10n.maxUsesPerCouponOptional, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          PosButton(variant: PosButtonVariant.ghost, label: l10n.commonCancel, onPressed: () => Navigator.pop(ctx)),
          PosButton(
            variant: PosButtonVariant.primary,
            label: l10n.generate,
            onPressed: () async {
              final count = int.tryParse(countCtrl.text) ?? 10;
              final prefix = prefixCtrl.text.isEmpty ? null : prefixCtrl.text;
              final maxUses = maxUsesCtrl.text.isEmpty ? null : int.tryParse(maxUsesCtrl.text);
              Navigator.pop(ctx);
              try {
                await ref.read(promotionRepositoryProvider).batchGenerateCoupons(
                  promotionId: widget.promotionId,
                  count: count,
                  prefix: prefix,
                  maxUses: maxUses,
                );
                if (!mounted) return;
                showPosInfoSnackbar(context, l10n.generatingCoupons(count.toString()));
                await _load(page: 1);
              } catch (e) {
                if (!mounted) return;
                showPosErrorSnackbar(context, e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}

// ─── Coupon Card ─────────────────────────────────────────────────

class _CouponCard extends StatelessWidget {
  const _CouponCard({required this.coupon, required this.onDelete});
  final CouponCode coupon;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = coupon.isActive ?? true;
    final used = coupon.usageCount ?? 0;
    final max = coupon.maxUses;
    final pct = max != null && max > 0 ? (used / max).clamp(0.0, 1.0) : null;

    return PosCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Status dot
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8, top: 2),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success : AppColors.neutral300,
                    shape: BoxShape.circle,
                  ),
                ),
                // Code
                Expanded(
                  child: Text(
                    coupon.code,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFamily: 'monospace',
                      letterSpacing: 1.2,
                      color: isActive ? theme.colorScheme.onSurface : AppColors.neutral400,
                    ),
                  ),
                ),
                // Copy button
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: l10n.copyCode,
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: coupon.code));
                    showPosInfoSnackbar(context, l10n.codeCopied);
                  },
                ),
                // Status badge
                PosStatusBadge(
                  label: isActive ? l10n.active : l10n.inactive,
                  color: isActive ? AppColors.success : AppColors.neutral400,
                ),
                AppSpacing.gapW8,
                // Delete
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                  tooltip: l10n.delete,
                  visualDensity: VisualDensity.compact,
                  onPressed: onDelete,
                ),
              ],
            ),
            AppSpacing.gapH8,
            // Usage row
            Row(
              children: [
                Icon(Icons.show_chart_rounded, size: 14, color: AppColors.neutral400),
                AppSpacing.gapW4,
                Text(
                  max != null
                      ? '${l10n.used}: $used / $max'
                      : '${l10n.used}: $used',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral500),
                ),
                if (coupon.createdAt != null) ...[
                  AppSpacing.gapW16,
                  Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.neutral400),
                  AppSpacing.gapW4,
                  Text(
                    _formatDate(coupon.createdAt!),
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                  ),
                ],
              ],
            ),
            // Usage progress bar
            if (pct != null) ...[
              AppSpacing.gapH8,
              ClipRRect(
                borderRadius: AppRadius.borderSm,
                child: LinearProgressIndicator(
                  value: pct,
                  minHeight: 5,
                  backgroundColor: AppColors.neutral200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    pct >= 1.0 ? AppColors.neutral400 : pct >= 0.8 ? AppColors.error : pct >= 0.5 ? AppColors.warning : AppColors.success,
                  ),
                ),
              ),
              AppSpacing.gapH4,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${(pct * 100).toInt()}%',
                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.neutral400),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

// ─── Filter Chip Widget ──────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String activeLabel;
  final String inactiveLabel;
  final bool? value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String displayLabel;
    if (value == true) displayLabel = activeLabel;
    else if (value == false) displayLabel = inactiveLabel;
    else displayLabel = label;

    return GestureDetector(
      onTap: () {
        if (value == null) onChanged(true);
        else if (value == true) onChanged(false);
        else onChanged(null);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: value != null ? AppColors.primary.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
          borderRadius: AppRadius.borderLg,
          border: Border.all(
            color: value != null ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value == true ? Icons.check_circle_outline : value == false ? Icons.cancel_outlined : Icons.filter_list_rounded,
              size: 14,
              color: value != null ? AppColors.primary : AppColors.neutral500,
            ),
            AppSpacing.gapW4,
            Text(
              displayLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: value != null ? AppColors.primary : AppColors.neutral500,
                fontWeight: value != null ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Pagination Bar ──────────────────────────────────────────────

class _PaginationBar extends StatelessWidget {
  const _PaginationBar({
    required this.currentPage,
    required this.lastPage,
    required this.onPageChange,
    required this.isLoading,
  });
  final int currentPage;
  final int lastPage;
  final ValueChanged<int> onPageChange;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: currentPage > 1 && !isLoading ? () => onPageChange(currentPage - 1) : null,
          ),
          AppSpacing.gapW8,
          Text(
            l10n.pageOf(currentPage.toString(), lastPage.toString()),
            style: theme.textTheme.bodyMedium,
          ),
          AppSpacing.gapW8,
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: currentPage < lastPage && !isLoading ? () => onPageChange(currentPage + 1) : null,
          ),
        ],
      ),
    );
  }
}

class CouponManagementPage extends ConsumerStatefulWidget {
  const CouponManagementPage({super.key, required this.promotionId, required this.promotionName});
  final String promotionId;
  final String promotionName;

  @override
  ConsumerState<CouponManagementPage> createState() => _CouponManagementPageState();
}

class _CouponManagementPageState extends ConsumerState<CouponManagementPage> {
  final _searchController = TextEditingController();
  bool _loading = false;
  String? _error;
  List<CouponCode> _coupons = const [];
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    Future.microtask(_load);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({int page = 1}) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final repo = ref.read(promotionRepositoryProvider);
      final result = await repo.listPromotionCoupons(
        widget.promotionId,
        page: page,
        search: _searchController.text.isNotEmpty ? _searchController.text : null,
      );
      setState(() {
        _coupons = result.items;
        _currentPage = result.currentPage;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: '${l10n.promoManageCoupons} — ${widget.promotionName}',
      searchController: _searchController,
      onSearchChanged: (_) => _load(),
      isLoading: _loading && _coupons.isEmpty,
      hasError: _error != null,
      errorMessage: _error,
      onRetry: _load,
      actions: [IconButton(icon: const Icon(Icons.add), tooltip: l10n.generateCoupons, onPressed: () => _showGenerateDialog())],
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (_coupons.isEmpty && !_loading) {
      return PosEmptyState(icon: Icons.confirmation_number_outlined, title: l10n.promoCouponsEmpty);
    }
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: _coupons.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _buildCouponRow(_coupons[i]),
    );
  }

  Widget _buildCouponRow(CouponCode c) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isActive = c.isActive ?? true;
    return PosCard(
      child: ListTile(
        leading: Icon(
          Icons.confirmation_number_outlined,
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.outline,
        ),
        title: Text(c.code, style: theme.textTheme.titleMedium),
        subtitle: Text('${l10n.maxUses}: ${c.maxUses ?? "∞"}  •  ${c.usageCount ?? 0}'),
        trailing: IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _confirmDelete(c)),
      ),
    );
  }

  Future<void> _confirmDelete(CouponCode c) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.commonDelete,
      message: l10n.promoCouponDeleteConfirm(c.code),
      confirmLabel: l10n.commonDelete,
      cancelLabel: l10n.commonCancel,
      isDanger: true,
    );
    if (confirmed != true) return;
    try {
      await ref.read(promotionRepositoryProvider).deleteCoupon(c.id);
      if (!mounted) return;
      showPosInfoSnackbar(context, l10n.promoCouponDeleted);
      await _load(page: _currentPage);
    } catch (e) {
      if (!mounted) return;
      showPosErrorSnackbar(context, e.toString());
    }
  }

  void _showGenerateDialog() {
    final l10n = AppLocalizations.of(context)!;
    final countCtrl = TextEditingController(text: '10');
    final prefixCtrl = TextEditingController();
    final maxUsesCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.generateCoupons),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PosTextField(controller: countCtrl, label: l10n.count, keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            PosTextField(controller: prefixCtrl, label: l10n.prefixOptional),
            const SizedBox(height: 12),
            PosTextField(controller: maxUsesCtrl, label: l10n.maxUsesPerCouponOptional, keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          PosButton(variant: PosButtonVariant.ghost, label: l10n.commonCancel, onPressed: () => Navigator.pop(ctx)),
          PosButton(
            variant: PosButtonVariant.soft,
            label: l10n.generate,
            onPressed: () async {
              final count = int.tryParse(countCtrl.text) ?? 10;
              final prefix = prefixCtrl.text.isEmpty ? null : prefixCtrl.text;
              final maxUses = maxUsesCtrl.text.isEmpty ? null : int.tryParse(maxUsesCtrl.text);
              Navigator.pop(ctx);
              try {
                await ref
                    .read(promotionRepositoryProvider)
                    .batchGenerateCoupons(promotionId: widget.promotionId, count: count, prefix: prefix, maxUses: maxUses);
                if (!mounted) return;
                showPosInfoSnackbar(context, l10n.generatingCoupons(count.toString()));
                await _load(page: 1);
              } catch (e) {
                if (!mounted) return;
                showPosErrorSnackbar(context, e.toString());
              }
            },
          ),
        ],
      ),
    );
  }
}
