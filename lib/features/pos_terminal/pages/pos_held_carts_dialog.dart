import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/theme/app_typography.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/pos_terminal/models/held_cart.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_cashier_state.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_state.dart';

class PosHeldCartsDialog extends ConsumerStatefulWidget {
  const PosHeldCartsDialog({super.key});

  @override
  ConsumerState<PosHeldCartsDialog> createState() => _PosHeldCartsDialogState();
}

class _PosHeldCartsDialogState extends ConsumerState<PosHeldCartsDialog> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(heldCartsProvider.notifier).load());
  }

  Future<void> _recallCart(HeldCart cart) async {
    // Get currently loaded products to restore cart items
    final productsState = ref.read(posProductsProvider);
    final products = productsState is PosProductsLoaded ? productsState.products : <dynamic>[];
    ref.read(cartProvider.notifier).restoreFromHeldCart(cart.cartData, products.cast());
    await ref.read(heldCartsProvider.notifier).recallCart(cart.id);
    if (mounted) {
      showPosSuccessSnackbar(context, 'Cart restored: ${cart.label ?? 'Held Cart'}');
      Navigator.pop(context);
    }
  }

  Future<void> _deleteCart(HeldCart cart) async {
    final confirmed = await showPosConfirmDialog(
      context,
      title: 'Delete Held Cart?',
      message: 'This will permanently remove "${cart.label ?? 'Held Cart'}".',
      confirmLabel: 'Delete',
      isDanger: true,
    );
    if (confirmed == true) {
      await ref.read(heldCartsProvider.notifier).deleteCart(cart.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartsState = ref.watch(heldCartsProvider);
    final mutedColor = isDark ? AppColors.textMutedDark : AppColors.textMutedLight;

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 600),
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.10), shape: BoxShape.circle),
                    child: const Icon(Icons.pause_circle_outline, color: AppColors.info, size: 22),
                  ),
                  AppSpacing.gapW12,
                  Expanded(child: Text('Held Carts', style: AppTypography.headlineSmall)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              AppSpacing.gapH16,

              // Body
              Expanded(child: _buildBody(cartsState, isDark, mutedColor)),

              AppSpacing.gapH16,
              PosButton(
                label: 'Close',
                variant: PosButtonVariant.outline,
                isFullWidth: true,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(HeldCartsState cartsState, bool isDark, Color mutedColor) {
    if (cartsState is HeldCartsLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (cartsState is HeldCartsError) {
      return PosErrorState(message: cartsState.message, onRetry: () => ref.read(heldCartsProvider.notifier).load());
    }

    final carts = cartsState is HeldCartsLoaded ? cartsState.carts : <HeldCart>[];

    if (carts.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_rounded, size: 48, color: isDark ? AppColors.textDisabledDark : AppColors.textDisabledLight),
            AppSpacing.gapH8,
            Text('No held carts', style: AppTypography.bodyMedium.copyWith(color: mutedColor)),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      itemCount: carts.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) => _HeldCartCard(
        cart: carts[index],
        isDark: isDark,
        mutedColor: mutedColor,
        onRecall: () => _recallCart(carts[index]),
        onDelete: () => _deleteCart(carts[index]),
      ),
    );
  }
}

class _HeldCartCard extends StatelessWidget {
  const _HeldCartCard({
    required this.cart,
    required this.isDark,
    required this.mutedColor,
    required this.onRecall,
    required this.onDelete,
  });

  final HeldCart cart;
  final bool isDark;
  final Color mutedColor;
  final VoidCallback onRecall;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final itemCount = (cart.cartData['items'] as List?)?.length ?? 0;
    final heldTime = cart.heldAt != null ? _timeAgo(cart.heldAt!) : '';

    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Row(
        children: [
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cart.label ?? 'Held Cart', style: AppTypography.titleSmall),
                AppSpacing.gapH4,
                Text(
                  '$itemCount item${itemCount == 1 ? '' : 's'} • $heldTime',
                  style: AppTypography.bodySmall.copyWith(color: mutedColor),
                ),
              ],
            ),
          ),
          // Actions
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            tooltip: 'Delete',
          ),
          AppSpacing.gapW4,
          PosButton(label: 'Recall', icon: Icons.play_arrow_rounded, size: PosButtonSize.sm, onPressed: onRecall),
        ],
      ),
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
