import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/companion/providers/companion_providers.dart';
import 'package:wameedpos/features/companion/providers/companion_state.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class CompanionHomeDashboard extends ConsumerStatefulWidget {
  const CompanionHomeDashboard({super.key});

  @override
  ConsumerState<CompanionHomeDashboard> createState() => _CompanionHomeDashboardState();
}

class _CompanionHomeDashboardState extends ConsumerState<CompanionHomeDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companionDashboardProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(companionDashboardProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return switch (state) {
      CompanionDashboardInitial() || CompanionDashboardLoading() => const PosLoading(),
      CompanionDashboardError(:final message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: TextStyle(color: theme.colorScheme.error)),
            AppSpacing.gapH8,
            PosButton(
              onPressed: () => ref.read(companionDashboardProvider.notifier).load(),
              variant: PosButtonVariant.ghost,
              label: l10n.companionRetry,
            ),
          ],
        ),
      ),
      CompanionDashboardLoaded(
        :final todayRevenue,
        :final yesterdayRevenue,
        :final todayOrders,
        :final yesterdayOrders,
        :final activeStaff,
        :final lowStockItems,
        :final pendingOrders,
        :final storeIsOpen,
        :final currency,
      ) =>
        ListView(
          padding: AppSpacing.paddingAll16,
          children: [
            // Store status toggle
            PosCard(
              child: SwitchListTile(
                secondary: Icon(
                  storeIsOpen ? Icons.storefront : Icons.store,
                  color: storeIsOpen ? AppColors.success : AppColors.error,
                ),
                title: Text(l10n.companionStoreStatus),
                subtitle: Text(
                  storeIsOpen ? l10n.companionStoreOpen : l10n.companionStoreClosed,
                  style: TextStyle(color: storeIsOpen ? AppColors.success : AppColors.error),
                ),
                value: storeIsOpen,
                onChanged: (value) {
                  ref.read(companionDashboardProvider.notifier).toggleStoreAvailability(value);
                },
              ),
            ),
            AppSpacing.gapH16,
            // Revenue comparison
            _ComparisonCard(
              title: l10n.companionRevenue,
              icon: Icons.attach_money,
              todayValue: '$currency ${todayRevenue.toStringAsFixed(2)}',
              yesterdayValue: '$currency ${yesterdayRevenue.toStringAsFixed(2)}',
              todayLabel: l10n.companionToday,
              yesterdayLabel: l10n.companionYesterday,
              changePercent: yesterdayRevenue > 0 ? ((todayRevenue - yesterdayRevenue) / yesterdayRevenue * 100) : null,
            ),
            AppSpacing.gapH12,
            // Orders comparison
            _ComparisonCard(
              title: l10n.companionOrders,
              icon: Icons.receipt_long,
              todayValue: '$todayOrders',
              yesterdayValue: '$yesterdayOrders',
              todayLabel: l10n.companionToday,
              yesterdayLabel: l10n.companionYesterday,
              changePercent: yesterdayOrders > 0 ? ((todayOrders - yesterdayOrders) / yesterdayOrders * 100) : null,
            ),
            AppSpacing.gapH16,
            // Quick info cards
            PosKpiGrid(
              desktopCols: 3,
              mobileCols: 2,
              cards: [
                PosKpiCard(
                  icon: Icons.people,
                  label: l10n.companionActiveStaff,
                  value: '$activeStaff',
                  iconColor: AppColors.info,
                ),
                PosKpiCard(
                  icon: Icons.pending_actions,
                  label: l10n.companionPendingOrders,
                  value: '$pendingOrders',
                  iconColor: pendingOrders > 0 ? AppColors.warning : AppColors.success,
                ),
                PosKpiCard(
                  icon: Icons.inventory_2,
                  label: l10n.companionLowStock,
                  value: '$lowStockItems',
                  iconColor: lowStockItems > 0 ? AppColors.error : AppColors.success,
                ),
              ],
            ),
          ],
        ),
    };
  }
}

class _ComparisonCard extends StatelessWidget {
  const _ComparisonCard({
    required this.title,
    required this.icon,
    required this.todayValue,
    required this.yesterdayValue,
    required this.todayLabel,
    required this.yesterdayLabel,
    this.changePercent,
  });

  final String title;
  final IconData icon;
  final String todayValue;
  final String yesterdayValue;
  final String todayLabel;
  final String yesterdayLabel;
  final double? changePercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUp = (changePercent ?? 0) >= 0;

    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                AppSpacing.gapW8,
                Text(title, style: theme.textTheme.titleSmall),
                const Spacer(),
                if (changePercent != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: (isUp ? AppColors.success : AppColors.error).withValues(alpha: 0.12),
                      borderRadius: AppRadius.borderLg,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isUp ? Icons.trending_up : Icons.trending_down,
                          size: 14,
                          color: isUp ? AppColors.success : AppColors.error,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${changePercent!.abs().toStringAsFixed(1)}%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: isUp ? AppColors.success : AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            AppSpacing.gapH12,
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todayLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.mutedFor(context),
                        ),
                      ),
                      AppSpacing.gapH4,
                      Text(todayValue, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Container(width: 1, height: 40, color: theme.dividerColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          yesterdayLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.mutedFor(context),
                          ),
                        ),
                        AppSpacing.gapH4,
                        Text(yesterdayValue, style: theme.textTheme.titleMedium),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
