import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

class NotificationStatsWidget extends ConsumerStatefulWidget {
  const NotificationStatsWidget({super.key});

  @override
  ConsumerState<NotificationStatsWidget> createState() => _NotificationStatsWidgetState();
}

class _NotificationStatsWidgetState extends ConsumerState<NotificationStatsWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(notificationStatsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationStatsProvider);

    return switch (state) {
      NotificationStatsInitial() || NotificationStatsLoading() => Center(child: PosLoadingSkeleton.list()),
      NotificationStatsError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(notificationStatsProvider.notifier).load(),
      ),
      NotificationStatsLoaded(:final stats) => _buildStats(stats),
    };
  }

  Widget _buildStats(Map<String, dynamic> stats) {
    final l10n = AppLocalizations.of(context)!;
    final total = stats['total'] ?? 0;
    final unread = stats['unread'] ?? 0;
    final read = stats['read'] ?? 0;
    final byCategory = stats['by_category'] as Map<String, dynamic>? ?? {};
    final byChannel = stats['by_channel'] as Map<String, dynamic>? ?? {};
    final deliveryRate = stats['delivery_rate'] as num? ?? 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KPI Cards
          PosKpiGrid(
            desktopCols: 4,
            mobileCols: 2,
            cards: [
              PosKpiCard(label: l10n.notifStatsTotal, value: '$total', icon: Icons.notifications, iconColor: AppColors.info),
              PosKpiCard(label: l10n.notifStatsUnread, value: '$unread', icon: Icons.markunread, iconColor: AppColors.warning),
              PosKpiCard(label: l10n.notifStatsRead, value: '$read', icon: Icons.done_all, iconColor: AppColors.success),
              PosKpiCard(
                label: l10n.notifStatsDeliveryRate,
                value: '${deliveryRate.toStringAsFixed(1)}%',
                icon: Icons.local_shipping,
                iconColor: AppColors.purple,
              ),
            ],
          ),
          AppSpacing.gapH16,

          // By Category
          Text(l10n.notifStatsByCategory, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          AppSpacing.gapH8,
          ...byCategory.entries.map((e) => _buildStatRow(e.key, e.value.toString(), _categoryIcon(e.key), _categoryColor(e.key))),

          AppSpacing.gapH16,

          // By Channel
          Text(l10n.notifStatsByChannel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          AppSpacing.gapH8,
          ...byChannel.entries.map((e) => _buildStatRow(e.key, e.value.toString(), _channelIcon(e.key), AppColors.info)),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          AppSpacing.gapW8,
          Expanded(child: Text(label[0].toUpperCase() + label.substring(1).replaceAll('_', ' '))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'order' => Icons.receipt_long,
      'inventory' => Icons.inventory_2,
      'promotion' => Icons.local_offer,
      'system' => Icons.settings,
      'payment' => Icons.payment,
      'staff' => Icons.people,
      _ => Icons.notifications,
    };
  }

  Color _categoryColor(String category) {
    return switch (category) {
      'order' => AppColors.info,
      'inventory' => AppColors.warning,
      'promotion' => AppColors.purple,
      'system' => AppColors.textSecondary,
      'payment' => AppColors.success,
      'staff' => AppColors.info,
      _ => AppColors.textSecondary,
    };
  }

  IconData _channelIcon(String channel) {
    return switch (channel) {
      'push' => Icons.notifications_active,
      'email' => Icons.email,
      'sms' => Icons.sms,
      'in_app' => Icons.app_shortcut,
      _ => Icons.send,
    };
  }
}
