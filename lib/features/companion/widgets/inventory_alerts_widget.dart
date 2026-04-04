import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/companion/providers/companion_providers.dart';
import 'package:thawani_pos/features/companion/providers/companion_state.dart';

class InventoryAlertsWidget extends ConsumerStatefulWidget {
  const InventoryAlertsWidget({super.key});

  @override
  ConsumerState<InventoryAlertsWidget> createState() => _InventoryAlertsWidgetState();
}

class _InventoryAlertsWidgetState extends ConsumerState<InventoryAlertsWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(inventoryAlertsProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(inventoryAlertsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      InventoryAlertsInitial() || InventoryAlertsLoading() => const Center(child: CircularProgressIndicator()),
      InventoryAlertsError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
            AppSpacing.gapH8,
            TextButton(onPressed: () => ref.read(inventoryAlertsProvider.notifier).load(), child: Text(l10n.companionRetry)),
          ],
        ),
      ),
      InventoryAlertsLoaded(:final alerts, :final lowStockCount, :final outOfStockCount) => ListView(
        padding: AppSpacing.paddingAll16,
        children: [
          // Summary cards
          Row(
            children: [
              Expanded(
                child: Card(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  child: Padding(
                    padding: AppSpacing.paddingAll12,
                    child: Column(
                      children: [
                        const Icon(Icons.warning_amber, color: AppColors.warning, size: 28),
                        AppSpacing.gapH4,
                        Text('$lowStockCount', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(l10n.companionLowStock, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
              AppSpacing.gapW12,
              Expanded(
                child: Card(
                  color: AppColors.error.withValues(alpha: 0.1),
                  child: Padding(
                    padding: AppSpacing.paddingAll12,
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.error, size: 28),
                        AppSpacing.gapH4,
                        Text('$outOfStockCount', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                        Text(l10n.companionOutOfStock, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          AppSpacing.gapH16,
          // Alert list
          if (alerts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                    AppSpacing.gapH8,
                    Text(l10n.companionNoAlerts, style: theme.textTheme.titleMedium),
                  ],
                ),
              ),
            )
          else
            ...alerts.map((alert) => _AlertTile(alert: alert)),
        ],
      ),
    };
  }
}

class _AlertTile extends StatelessWidget {
  const _AlertTile({required this.alert});

  final Map<String, dynamic> alert;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentStock = alert['current_stock'] as int? ?? 0;
    final minStock = alert['min_stock'] as int? ?? 0;
    final isOutOfStock = currentStock == 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isOutOfStock ? AppColors.error.withValues(alpha: 0.15) : AppColors.warning.withValues(alpha: 0.15),
          child: Icon(
            isOutOfStock ? Icons.error : Icons.warning_amber,
            color: isOutOfStock ? AppColors.error : AppColors.warning,
            size: 20,
          ),
        ),
        title: Text(alert['product_name'] as String? ?? '-', style: theme.textTheme.titleSmall),
        subtitle: Text(
          '${l10n.companionStock}: $currentStock / ${l10n.companionMinStock}: $minStock',
          style: theme.textTheme.bodySmall,
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: (isOutOfStock ? AppColors.error : AppColors.warning).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            isOutOfStock ? l10n.companionOutOfStock : l10n.companionLowStock,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isOutOfStock ? AppColors.error : AppColors.warning,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
