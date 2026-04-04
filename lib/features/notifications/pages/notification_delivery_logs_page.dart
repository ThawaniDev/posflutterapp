import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/notifications/models/notification_delivery_log.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

class NotificationDeliveryLogsPage extends ConsumerStatefulWidget {
  const NotificationDeliveryLogsPage({super.key});

  @override
  ConsumerState<NotificationDeliveryLogsPage> createState() => _NotificationDeliveryLogsPageState();
}

class _NotificationDeliveryLogsPageState extends ConsumerState<NotificationDeliveryLogsPage> {
  String? _channelFilter;
  String? _statusFilter;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(deliveryLogsProvider.notifier).load());
  }

  void _reload() {
    ref.read(deliveryLogsProvider.notifier).load(channel: _channelFilter, status: _statusFilter);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifDeliveryLogsTitle),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _reload)],
      ),
      body: Column(
        children: [
          _buildFilters(),
          const Divider(height: 1),
          Expanded(
            child: switch (state) {
              DeliveryLogsInitial() || DeliveryLogsLoading() => Center(child: PosLoadingSkeleton.list()),
              DeliveryLogsError(:final message) => PosErrorState(message: message, onRetry: _reload),
              DeliveryLogsLoaded(:final logs) =>
                logs.isEmpty
                    ? PosEmptyState(title: l10n.notifDeliveryLogsEmpty, icon: Icons.local_shipping_outlined)
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: logs.length,
                        itemBuilder: (context, index) => _buildLogCard(logs[index]),
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(l10n.notifDeliveryLogsChannel, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          AppSpacing.gapW8,
          FilterChip(
            label: Text(l10n.ordersAll),
            selected: _channelFilter == null,
            onSelected: (_) {
              setState(() => _channelFilter = null);
              _reload();
            },
          ),
          AppSpacing.gapW4,
          ...['in_app', 'push', 'email', 'sms'].map(
            (ch) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilterChip(
                label: Text(ch),
                selected: _channelFilter == ch,
                onSelected: (_) {
                  setState(() => _channelFilter = ch);
                  _reload();
                },
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
          AppSpacing.gapW16,
          Text(l10n.notifDeliveryLogsStatus, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          AppSpacing.gapW8,
          FilterChip(
            label: Text(l10n.ordersAll),
            selected: _statusFilter == null,
            onSelected: (_) {
              setState(() => _statusFilter = null);
              _reload();
            },
          ),
          AppSpacing.gapW4,
          ...['sent', 'delivered', 'failed', 'pending'].map(
            (st) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilterChip(
                label: Text(st),
                selected: _statusFilter == st,
                onSelected: (_) {
                  setState(() => _statusFilter = st);
                  _reload();
                },
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(NotificationDeliveryLog log) {
    final l10n = AppLocalizations.of(context)!;
    final status = log.status.value;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_channelIcon(log.channel.value), size: 18, color: AppColors.textSecondary),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(log.channel.value.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _statusColor(status)),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH4,
            if (log.notificationId != null)
              Text(
                '${l10n.notifDeliveryLogsNotifId}: ${log.notificationId}',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            if (log.retryCount != null && log.retryCount! > 0)
              Text(
                '${l10n.notifDeliveryLogsRetries}: ${log.retryCount}',
                style: TextStyle(fontSize: 12, color: AppColors.warning),
              ),
            AppSpacing.gapH4,
            if (log.createdAt != null)
              Text(
                '${log.createdAt!.day}/${log.createdAt!.month}/${log.createdAt!.year} ${log.createdAt!.hour}:${log.createdAt!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
    );
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

  Color _statusColor(String status) {
    return switch (status) {
      'delivered' => AppColors.success,
      'sent' => AppColors.info,
      'failed' => AppColors.error,
      'pending' => AppColors.warning,
      _ => AppColors.textSecondary,
    };
  }
}
