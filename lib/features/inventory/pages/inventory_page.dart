import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';

/// Hub page for inventory management, listing all sub-sections.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory Management')),
      body: GridView.count(
        crossAxisCount: MediaQuery.of(context).size.width > 800 ? 3 : 2,
        padding: const EdgeInsets.all(AppSpacing.lg),
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 1.4,
        children: [
          _InventoryTile(
            icon: Icons.inventory_2_outlined,
            title: 'Stock Levels',
            subtitle: 'View current stock and set reorder points',
            onTap: () => context.push(Routes.stockLevels),
          ),
          _InventoryTile(
            icon: Icons.history,
            title: 'Stock Movements',
            subtitle: 'Track all stock changes',
            onTap: () => context.push(Routes.stockMovements),
          ),
          _InventoryTile(
            icon: Icons.receipt_long_outlined,
            title: 'Goods Receipts',
            subtitle: 'Receive goods from suppliers',
            onTap: () => context.push(Routes.goodsReceipts),
          ),
          _InventoryTile(
            icon: Icons.tune,
            title: 'Stock Adjustments',
            subtitle: 'Manually adjust stock quantities',
            onTap: () => context.push(Routes.stockAdjustments),
          ),
          _InventoryTile(
            icon: Icons.swap_horiz,
            title: 'Stock Transfers',
            subtitle: 'Transfer stock between stores',
            onTap: () => context.push(Routes.stockTransfers),
          ),
          _InventoryTile(
            icon: Icons.shopping_cart_outlined,
            title: 'Purchase Orders',
            subtitle: 'Manage supplier purchase orders',
            onTap: () => context.push(Routes.purchaseOrders),
          ),
          _InventoryTile(
            icon: Icons.restaurant_menu,
            title: 'Recipes',
            subtitle: 'Define ingredient lists for products',
            onTap: () => context.push(Routes.recipes),
          ),
        ],
      ),
    );
  }
}

class _InventoryTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _InventoryTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PosCard(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: AppColors.primary),
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
