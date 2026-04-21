import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class ActiveOrdersWidget extends ConsumerStatefulWidget {
  const ActiveOrdersWidget({super.key});

  @override
  ConsumerState<ActiveOrdersWidget> createState() => _ActiveOrdersWidgetState();
}

class _ActiveOrdersWidgetState extends ConsumerState<ActiveOrdersWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeOrdersProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activeOrdersProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      ActiveOrdersInitial() || ActiveOrdersLoading() => const PosLoading(),
      ActiveOrdersError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
            AppSpacing.gapH8,
            PosButton(
              onPressed: () => ref.read(activeOrdersProvider.notifier).load(),
              variant: PosButtonVariant.ghost,
              label: l10n.companionRetry,
            ),
          ],
        ),
      ),
      ActiveOrdersLoaded(:final orders, :final total) =>
        orders.isEmpty
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline, size: 48, color: AppColors.success),
                    AppSpacing.gapH8,
                    Text(l10n.companionNoActiveOrders, style: theme.textTheme.titleMedium),
                  ],
                ),
              )
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: orders.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_cart, size: 20, color: AppColors.primary),
                          AppSpacing.gapW8,
                          Text('${l10n.companionActiveOrdersTitle} ($total)', style: theme.textTheme.titleMedium),
                        ],
                      ),
                    );
                  }
                  final order = orders[index - 1];
                  return _OrderCard(order: order, isDark: isDark);
                },
              ),
    };
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.isDark});

  final Map<String, dynamic> order;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final status = order['status'] as String? ?? 'pending';
    final statusColor = switch (status) {
      'pending' => AppColors.warning,
      'processing' => AppColors.info,
      'ready' => AppColors.success,
      _ => AppColors.mutedFor(context),
    };

    return PosCard(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: AppSpacing.paddingAll12,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '#${order['order_number'] ?? order['id'] ?? '-'}',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.15), borderRadius: AppRadius.borderLg),
                  child: Text(
                    status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH8,
            if (order['customer_name'] != null)
              Text('${l10n.companionCustomer}: ${order['customer_name']}', style: theme.textTheme.bodySmall),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.companionItems}: ${order['items_count'] ?? '-'}', style: theme.textTheme.bodySmall),
                Text(
                  '${order['total'] ?? '0.00'}',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            if (order['created_at'] != null) ...[
              AppSpacing.gapH4,
              Text(
                order['created_at'] as String,
                style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mutedFor(context)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
