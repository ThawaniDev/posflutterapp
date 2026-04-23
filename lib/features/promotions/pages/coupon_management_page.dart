import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
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
