import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/models/notification_delivery_log.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(deliveryLogsProvider);

    return PosListPage(
      title: l10n.notifDeliveryLogsTitle,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.refresh_rounded, onPressed: _reload)],
      child: Column(
        children: [
          _buildFilters(isDark),
          const PosDivider(),
          Expanded(
            child: switch (state) {
              DeliveryLogsInitial() || DeliveryLogsLoading() => const Center(child: PosLoading()),
              DeliveryLogsError(:final message) => PosErrorState(message: message, onRetry: _reload),
              DeliveryLogsLoaded(:final logs) =>
                logs.isEmpty
                    ? PosEmptyState(title: l10n.notifDeliveryLogsEmpty, icon: Icons.local_shipping_outlined)
                    : RefreshIndicator(
                        onRefresh: () async => _reload(),
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                          itemCount: logs.length,
                          separatorBuilder: (_, __) => AppSpacing.gapH8,
                          itemBuilder: (context, index) => _buildLogCard(logs[index], isDark),
                        ),
                      ),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  l10n.notifDeliveryLogsChannel,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.ordersAll,
                  onPressed: () {
                    setState(() => _channelFilter = null);
                    _reload();
                  },
                  isSelected: _channelFilter == null,
                ),
                AppSpacing.gapW4,
                ...['in_app', 'push', 'email', 'sms'].map(
                  (ch) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                    child: PosButton.pill(
                      label: _localizedChannel(l10n, ch),
                      icon: _channelIcon(ch),
                      onPressed: () {
                        setState(() => _channelFilter = ch);
                        _reload();
                      },
                      isSelected: _channelFilter == ch,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.gapH8,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  l10n.notifDeliveryLogsStatus,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.ordersAll,
                  onPressed: () {
                    setState(() => _statusFilter = null);
                    _reload();
                  },
                  isSelected: _statusFilter == null,
                ),
                AppSpacing.gapW4,
                ...['sent', 'delivered', 'failed', 'pending'].map(
                  (st) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                    child: PosButton.pill(
                      label: _localizedStatus(l10n, st),
                      onPressed: () {
                        setState(() => _statusFilter = st);
                        _reload();
                      },
                      isSelected: _statusFilter == st,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard(NotificationDeliveryLog log, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final status = log.status.value;

    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
                child: Icon(_channelIcon(log.channel.value), size: 16, color: AppColors.info),
              ),
              AppSpacing.gapW8,
              Expanded(child: Text(_localizedChannel(l10n, log.channel.value), style: AppTypography.titleMedium)),
              PosBadge(label: _localizedStatus(l10n, status), variant: _statusBadgeVariant(status), isSmall: true),
            ],
          ),
          AppSpacing.gapH8,
          if (log.notificationId != null)
            Text(
              '${l10n.notifDeliveryLogsNotifId}: ${log.notificationId}',
              style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
            ),
          if (log.retryCount != null && log.retryCount! > 0)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Row(
                children: [
                  const Icon(Icons.refresh_rounded, size: 14, color: AppColors.warning),
                  AppSpacing.gapW4,
                  Text(
                    '${l10n.notifDeliveryLogsRetries}: ${log.retryCount}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ),
          if (log.createdAt != null) ...[
            AppSpacing.gapH4,
            Text(
              _formatDateTime(log.createdAt!),
              style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context)),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  IconData _channelIcon(String channel) {
    return switch (channel) {
      'push' => Icons.notifications_active_rounded,
      'email' => Icons.email_rounded,
      'sms' => Icons.sms_rounded,
      'in_app' => Icons.app_shortcut_rounded,
      _ => Icons.send_rounded,
    };
  }

  String _localizedChannel(AppLocalizations l10n, String channel) {
    return switch (channel) {
      'in_app' => l10n.notificationsInApp,
      'push' => l10n.notificationsPush,
      'email' => l10n.notifPrefEmail,
      'sms' => l10n.notifPrefSms,
      _ => channel,
    };
  }

  String _localizedStatus(AppLocalizations l10n, String status) {
    return switch (status) {
      'delivered' => l10n.notifLogDelivered,
      'sent' => l10n.notifLogSent,
      'failed' => l10n.notifLogFailed,
      'pending' => l10n.notifSchedulePending,
      _ => status,
    };
  }

  PosBadgeVariant _statusBadgeVariant(String status) {
    return switch (status) {
      'delivered' => PosBadgeVariant.success,
      'sent' => PosBadgeVariant.info,
      'failed' => PosBadgeVariant.error,
      'pending' => PosBadgeVariant.warning,
      _ => PosBadgeVariant.neutral,
    };
  }
}
