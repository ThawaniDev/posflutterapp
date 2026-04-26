import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/models/announcement_summary.dart';
import 'package:wameedpos/features/notifications/models/app_release_info.dart';
import 'package:wameedpos/features/notifications/pages/notifications_list_page.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/repositories/notification_repository.dart';

/// Notification Centre — 4 tabs (Inbox, Announcements, Payment Reminders, App Updates).
class NotificationCentrePage extends ConsumerStatefulWidget {
  const NotificationCentrePage({super.key});

  @override
  ConsumerState<NotificationCentrePage> createState() => _NotificationCentrePageState();
}

class _NotificationCentrePageState extends ConsumerState<NotificationCentrePage> with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifCentreTitle),
        bottom: TabBar(
          controller: _tab,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.mutedFor(context),
          indicatorColor: AppColors.primary,
          labelStyle: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
          tabs: [
            Tab(icon: const Icon(Icons.inbox_rounded), text: l10n.notifTabInbox),
            Tab(icon: const Icon(Icons.campaign_rounded), text: l10n.notifTabAnnouncements),
            Tab(icon: const Icon(Icons.payments_rounded), text: l10n.notifTabPaymentReminders),
            Tab(icon: const Icon(Icons.system_update_rounded), text: l10n.notifTabAppUpdates),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: const [NotificationsListPage(), _AnnouncementsTab(), _PaymentRemindersTab(), _AppReleasesTab()],
      ),
    );
  }
}

// ─── Announcements Tab ───────────────────────────────────────

class _AnnouncementsTab extends ConsumerWidget {
  const _AnnouncementsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(announcementsProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final muted = AppColors.mutedFor(context);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(announcementsProvider),
      child: async.when(
        loading: () => const PosLoading(),
        error: (e, _) => PosErrorState(message: e.toString(), onRetry: () => ref.invalidate(announcementsProvider)),
        data: (rows) {
          if (rows.isEmpty) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: PosEmptyState(title: l10n.announcementsEmpty, icon: Icons.campaign_outlined),
                ),
              ],
            );
          }
          final items = rows.map(AnnouncementSummary.fromJson).toList();
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) {
              final a = items[i];
              return PosCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_iconForType(a.type), color: _colorForType(a.type), size: 20),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            a.localizedTitle(locale),
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        PosBadge(label: a.type, variant: _badgeVariantFor(a.type)),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(a.localizedBody(locale), style: AppTypography.bodyMedium.copyWith(color: muted)),
                    if (a.createdAt != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        DateFormat.yMMMd(locale).add_jm().format(a.createdAt!.toLocal()),
                        style: AppTypography.bodySmall.copyWith(color: muted),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: TextButton.icon(
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: Text(l10n.announcementsDismiss),
                        onPressed: () => _dismiss(context, ref, a.id, l10n),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'maintenance':
        return Icons.build_rounded;
      case 'feature':
        return Icons.new_releases_rounded;
      case 'warning':
        return Icons.warning_rounded;
      case 'critical':
        return Icons.error_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'maintenance':
      case 'warning':
        return AppColors.warning;
      case 'critical':
        return AppColors.error;
      case 'feature':
        return AppColors.primary;
      default:
        return AppColors.info;
    }
  }

  PosBadgeVariant _badgeVariantFor(String type) {
    switch (type) {
      case 'critical':
        return PosBadgeVariant.error;
      case 'maintenance':
      case 'warning':
        return PosBadgeVariant.warning;
      case 'feature':
        return PosBadgeVariant.primary;
      default:
        return PosBadgeVariant.info;
    }
  }

  Future<void> _dismiss(BuildContext context, WidgetRef ref, String id, AppLocalizations l10n) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(notificationRepositoryProvider).dismissAnnouncement(id);
      ref.invalidate(announcementsProvider);
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.announcementsDismissed)));
      }
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}

// ─── Payment Reminders Tab ───────────────────────────────────

class _PaymentRemindersTab extends ConsumerWidget {
  const _PaymentRemindersTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(paymentRemindersProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final muted = AppColors.mutedFor(context);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(paymentRemindersProvider),
      child: async.when(
        loading: () => const PosLoading(),
        error: (e, _) => PosErrorState(message: e.toString(), onRetry: () => ref.invalidate(paymentRemindersProvider)),
        data: (data) {
          final reminders = (data['reminders'] as List<dynamic>? ?? const []).cast<Map<String, dynamic>>();
          final summary = (data['summary'] as Map<String, dynamic>? ?? const {});
          final total = (summary['total'] as num?)?.toInt() ?? reminders.length;
          final upcoming = (summary['upcoming'] as num?)?.toInt() ?? 0;
          final overdue = (summary['overdue'] as num?)?.toInt() ?? 0;

          if (reminders.isEmpty) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: PosEmptyState(title: l10n.paymentRemindersEmpty, icon: Icons.payments_outlined),
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppSpacing.md),
            children: [
              PosCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  l10n.paymentRemindersSummary(total, upcoming, overdue),
                  style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...reminders.map((r) {
                final type = (r['reminder_type'] as String?) ?? '';
                final channel = (r['channel'] as String?) ?? '';
                final sentAt = r['sent_at'] != null ? DateTime.tryParse(r['sent_at'] as String) : null;
                final isOverdue = type == 'overdue';
                final sub = r['subscription'] as Map<String, dynamic>?;
                final planName = sub?['plan_name'] as String?;
                final dueAtRaw = sub?['current_period_end'] as String?;
                final dueAt = dueAtRaw != null ? DateTime.tryParse(dueAtRaw) : null;
                final subStatus = sub?['status'] as String?;

                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: PosCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: (isOverdue ? AppColors.error : AppColors.warning).withValues(alpha: 0.15),
                          child: Icon(
                            isOverdue ? Icons.warning_rounded : Icons.schedule_rounded,
                            color: isOverdue ? AppColors.error : AppColors.warning,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      isOverdue ? l10n.paymentRemindersOverdue : l10n.paymentRemindersUpcoming,
                                      style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  if (subStatus != null && subStatus.isNotEmpty)
                                    PosBadge(
                                      label: subStatus.toUpperCase(),
                                      variant: subStatus == 'expired' || subStatus == 'cancelled'
                                          ? PosBadgeVariant.error
                                          : (subStatus == 'grace' ? PosBadgeVariant.warning : PosBadgeVariant.success),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              if (planName != null && planName.isNotEmpty)
                                Text(planName, style: AppTypography.bodyMedium.copyWith(color: muted)),
                              if (dueAt != null)
                                Text(
                                  '${l10n.paymentReminderDue}: ${DateFormat.yMMMd(locale).format(dueAt.toLocal())}',
                                  style: AppTypography.bodySmall.copyWith(
                                    color: isOverdue ? AppColors.error : muted,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              if (channel.isNotEmpty)
                                Text(
                                  '${l10n.paymentRemindersChannel}: ${channel.toUpperCase()}',
                                  style: AppTypography.bodySmall.copyWith(color: muted),
                                ),
                              if (sentAt != null)
                                Text(
                                  '${l10n.paymentRemindersSentAt}: ${DateFormat.yMMMd(locale).add_jm().format(sentAt.toLocal())}',
                                  style: AppTypography.bodySmall.copyWith(color: muted),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

// ─── App Releases Tab ────────────────────────────────────────

class _AppReleasesTab extends ConsumerWidget {
  const _AppReleasesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(appReleasesProvider);
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final isAr = Localizations.localeOf(context).languageCode.startsWith('ar');
    final muted = AppColors.mutedFor(context);

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(appReleasesProvider),
      child: async.when(
        loading: () => const PosLoading(),
        error: (e, _) => PosErrorState(message: e.toString(), onRetry: () => ref.invalidate(appReleasesProvider)),
        data: (rows) {
          if (rows.isEmpty) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: PosEmptyState(title: l10n.appReleasesEmpty, icon: Icons.system_update_outlined),
                ),
              ],
            );
          }
          final items = rows.map(AppReleaseInfo.fromJson).toList();
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: items.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) {
              final r = items[i];
              final notes = isAr && (r.releaseNotesAr?.isNotEmpty ?? false) ? r.releaseNotesAr : r.releaseNotes;

              return PosCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          r.platform == 'ios' || r.platform == 'macos'
                              ? Icons.phone_iphone_rounded
                              : (r.platform == 'windows' ? Icons.desktop_windows_rounded : Icons.phone_android_rounded),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.appReleaseVersion(r.versionNumber),
                            style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        if (i == 0) PosBadge(label: l10n.appReleaseLatest, variant: PosBadgeVariant.success),
                        if (r.isForceUpdate) ...[
                          const SizedBox(width: 4),
                          PosBadge(label: l10n.appReleaseForceUpdate, variant: PosBadgeVariant.error),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: 4,
                      children: [
                        if (r.platform != null && r.platform!.isNotEmpty)
                          _meta(l10n.appReleasePlatform, r.platform!.toUpperCase(), muted),
                        if (r.channel != null && r.channel!.isNotEmpty)
                          _meta(l10n.appReleaseChannel, r.channel!.toUpperCase(), muted),
                        if (r.releasedAt != null)
                          _meta('', l10n.appReleaseReleasedAt(DateFormat.yMMMd(locale).format(r.releasedAt!.toLocal())), muted),
                      ],
                    ),
                    if (notes != null && notes.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(l10n.appReleaseChangelog, style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(notes, style: AppTypography.bodySmall.copyWith(color: muted)),
                    ],
                    if (r.downloadUrl != null && r.downloadUrl!.isNotEmpty) ...[
                      const SizedBox(height: AppSpacing.md),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: PosButton(
                          label: l10n.appReleaseDownload,
                          icon: Icons.download_rounded,
                          onPressed: () => _open(r.downloadUrl!),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _meta(String label, String value, Color muted) {
    return Text(label.isEmpty ? value : '$label: $value', style: AppTypography.bodySmall.copyWith(color: muted));
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
