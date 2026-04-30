import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

/// Hub page for inventory management, listing all sub-sections.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.inventoryManagement,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: l10n.featureInfoTooltip,
          onPressed: () => showInventoryInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      child: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
        padding: const EdgeInsets.all(AppSpacing.lg),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1,
        children: [
          _InventoryTile(
            icon: Icons.inventory_2_outlined,
            title: l10n.inventoryStockLevels,
            subtitle: l10n.inventoryStockLevelsSubtitle,
            onTap: () => context.push(Routes.stockLevels),
          ),
          _InventoryTile(
            icon: Icons.history,
            title: l10n.inventoryStockMovements,
            subtitle: l10n.inventoryStockMovementsSubtitle,
            onTap: () => context.push(Routes.stockMovements),
          ),
          _InventoryTile(
            icon: Icons.receipt_long_outlined,
            title: l10n.inventoryGoodsReceipts,
            subtitle: l10n.inventoryGoodsReceiptsSubtitle,
            onTap: () => context.push(Routes.goodsReceipts),
          ),
          _InventoryTile(
            icon: Icons.tune,
            title: l10n.inventoryStockAdjustments,
            subtitle: l10n.inventoryStockAdjustmentsSubtitle,
            onTap: () => context.push(Routes.stockAdjustments),
          ),
          _InventoryTile(
            icon: Icons.swap_horiz,
            title: l10n.inventoryStockTransfers,
            subtitle: l10n.inventoryStockTransfersSubtitle,
            onTap: () => context.push(Routes.stockTransfers),
          ),
          _InventoryTile(
            icon: Icons.shopping_cart_outlined,
            title: l10n.inventoryPurchaseOrders,
            subtitle: l10n.inventoryPurchaseOrdersSubtitle,
            onTap: () => context.push(Routes.purchaseOrders),
          ),
          _InventoryTile(
            icon: Icons.restaurant_menu,
            title: l10n.inventoryRecipes,
            subtitle: l10n.inventoryRecipesSubtitle,
            onTap: () => context.push(Routes.recipes),
          ),
          _InventoryTile(
            icon: Icons.assignment_return_outlined,
            title: l10n.supplierReturnsTitle,
            subtitle: l10n.supplierReturnsSubtitle,
            onTap: () => context.push(Routes.supplierReturns),
          ),
          _InventoryTile(
            icon: Icons.fact_check_outlined,
            title: l10n.inventoryStocktakes,
            subtitle: l10n.inventoryStocktakesSubtitle,
            onTap: () => context.push(Routes.stocktakes),
          ),
          _InventoryTile(
            icon: Icons.delete_sweep_outlined,
            title: l10n.inventoryWasteRecords,
            subtitle: l10n.inventoryWasteRecordsSubtitle,
            onTap: () => context.push(Routes.wasteRecords),
          ),
          _InventoryTile(
            icon: Icons.timer_off_outlined,
            title: l10n.inventoryExpiryDashboard,
            subtitle: l10n.inventoryExpiryDashboardSubtitle,
            color: AppColors.warning,
            onTap: () => context.push(Routes.expiryDashboard),
          ),
        ],
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {

  const _InventoryTile({required this.icon, required this.title, required this.subtitle, required this.onTap, this.color});
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tileColor = color ?? AppColors.primary;
    return PosCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: tileColor),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: Theme.of(context).textTheme.titleSmall, textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.xs),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
