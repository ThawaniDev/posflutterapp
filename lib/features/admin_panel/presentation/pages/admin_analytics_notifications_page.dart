import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/features/reports/widgets/report_charts.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminAnalyticsNotificationsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsNotificationsPage({super.key});
  @override
  ConsumerState<AdminAnalyticsNotificationsPage> createState() => _State();
}

class _State extends ConsumerState<AdminAnalyticsNotificationsPage> {
  late String _dateFrom;
  late String _dateTo;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateTo = now.toIso8601String().substring(0, 10);
    _dateFrom = now.subtract(const Duration(days: 30)).toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() => ref.read(analyticsNotificationsProvider.notifier).load(dateFrom: _dateFrom, dateTo: _dateTo);

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final r = await showPosDateRangePicker(context, firstDate: DateTime(now.year - 2), lastDate: now);
    if (r != null && mounted) {
      setState(() {
        _dateFrom = r.start.toIso8601String().substring(0, 10);
        _dateTo = r.end.toIso8601String().substring(0, 10);
      });
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(analyticsNotificationsProvider);

    return PosListPage(
      title: l10n.analyticsNotificationsDashboard,
      showSearch: false,
      actions: [
        IconButton(icon: const Icon(Icons.date_range_outlined), onPressed: _pickRange, tooltip: l10n.analyticsSelectDateRange),
      ],
      child: switch (state) {
        AnalyticsNotificationsLoading() => PosLoadingSkeleton.list(),
        AnalyticsNotificationsLoaded(
          totalSent: final totalSent,
          totalDelivered: final delivered,
          totalFailed: final failed,
          totalOpened: final opened,
          deliveryRate: final deliveryRate,
          openRate: final openRate,
          avgLatencyMs: final latency,
          byChannel: final byChannel,
          batchStats: final batchStats,
        ) =>
          RefreshIndicator(
            onRefresh: () async => _load(),
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                Chip(
                  avatar: const Icon(Icons.date_range, size: 14),
                  label: Text('$_dateFrom → $_dateTo', style: const TextStyle(fontSize: 12)),
                ),
                const SizedBox(height: AppSpacing.md),
                // KPIs
                PosKpiGrid(
                  desktopCols: 4,
                  mobileCols: 2,
                  cards: [
                    PosKpiCard(
                      label: l10n.analyticsTotalSent,
                      value: '$totalSent',
                      icon: Icons.send_outlined,
                      iconColor: AppColors.info,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsTotalDelivered,
                      value: '$delivered',
                      icon: Icons.mark_email_read_outlined,
                      iconColor: AppColors.success,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsTotalFailed,
                      value: '$failed',
                      icon: Icons.cancel_outlined,
                      iconColor: AppColors.error,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsTotalOpened,
                      value: '$opened',
                      icon: Icons.visibility_outlined,
                      iconColor: AppColors.purple,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                PosKpiGrid(
                  desktopCols: 3,
                  mobileCols: 2,
                  cards: [
                    PosKpiCard(
                      label: l10n.analyticsDeliveryRate,
                      value: '${deliveryRate.toStringAsFixed(1)}%',
                      icon: Icons.trending_up,
                      iconColor: AppColors.success,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsOpenRate,
                      value: '${openRate.toStringAsFixed(1)}%',
                      icon: Icons.open_in_new,
                      iconColor: AppColors.primary,
                    ),
                    PosKpiCard(
                      label: l10n.analyticsAvgLatency,
                      value: '${latency.toStringAsFixed(0)}ms',
                      icon: Icons.speed_outlined,
                      iconColor: AppColors.warning,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // By Channel bar chart
                Text(l10n.analyticsByChannel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                PosCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: byChannel.isEmpty
                        ? PosEmptyState(title: l10n.adminNoDataAvailable)
                        : ReportBarChart(
                            data: byChannel,
                            labelKey: 'channel',
                            valueKey: 'total_sent',
                            secondaryValueKey: 'total_delivered',
                            barColor: AppColors.info,
                            secondaryBarColor: AppColors.success,
                            height: 240,
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                // Channel details list
                if (byChannel.isNotEmpty)
                  ...byChannel.map((ch) {
                    final channel = ch['channel'] as String? ?? 'Unknown';
                    final sent = (ch['total_sent'] as num? ?? 0).toInt();
                    final delvd = (ch['total_delivered'] as num? ?? 0).toInt();
                    final rate = sent > 0 ? (delvd / sent * 100) : 0.0;
                    return PosCard(
                      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                          child: Icon(_channelIcon(channel), color: AppColors.primary, size: 18),
                        ),
                        title: Text(channel.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text('$sent sent • $delvd delivered'),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                (rate >= 90
                                        ? AppColors.success
                                        : rate >= 70
                                        ? AppColors.warning
                                        : AppColors.error)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${(rate).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: rate >= 90
                                  ? AppColors.success
                                  : rate >= 70
                                  ? AppColors.warning
                                  : AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: AppSpacing.xl),
                // Batch stats
                Text(l10n.analyticsBatchStats, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.sm),
                PosCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${batchStats['total_batches'] ?? 0}',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                              const SizedBox(height: 4),
                              Text(l10n.adminTotalBatches, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 60, color: AppColors.borderLight),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '${batchStats['total_recipients'] ?? 0}',
                                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.success),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.adminTotalRecipients,
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        AnalyticsNotificationsError(message: final msg) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PosErrorState(message: msg),
              const SizedBox(height: AppSpacing.sm),
              PosButton(onPressed: _load, label: l10n.retry),
            ],
          ),
        ),
        _ => PosLoadingSkeleton.list(),
      },
    );
  }

  IconData _channelIcon(String channel) {
    switch (channel.toLowerCase()) {
      case 'fcm':
      case 'push':
        return Icons.notifications_outlined;
      case 'sms':
        return Icons.sms_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'whatsapp':
        return Icons.chat_outlined;
      default:
        return Icons.broadcast_on_personal;
    }
  }
}
