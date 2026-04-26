import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';

/// App-bar bell that shows the unread count and a quick-peek dropdown
/// of the 5 most recent notifications.
class NotificationBell extends ConsumerStatefulWidget {
  const NotificationBell({super.key});

  @override
  ConsumerState<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends ConsumerState<NotificationBell> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(unreadCountProvider.notifier).load();
      ref.read(notificationListProvider.notifier).load(limit: 5);
    });
  }

  Future<void> _showPanel() async {
    // Refresh latest 5 right before opening.
    await ref.read(notificationListProvider.notifier).load(limit: 5);
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final overlayBox = overlay.context.findRenderObject() as RenderBox?;
    if (renderBox == null || overlayBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final size = renderBox.size;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final muted = AppColors.mutedFor(context);

    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.18),
      barrierDismissible: true,
      builder: (ctx) {
        return Stack(
          children: [
            Positioned(
              top: position.dy + size.height + 4,
              left: isRtl ? AppSpacing.md : null,
              right: isRtl ? null : AppSpacing.md,
              child: Material(
                color: Colors.transparent,
                child: SizedBox(
                  width: 360,
                  child: PosCard(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          child: Row(
                            children: [
                              const Icon(Icons.notifications_active_rounded, color: AppColors.primary, size: 20),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  l10n.notifications,
                                  style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 360),
                          child: _buildList(ctx, l10n, isDark, muted),
                        ),
                        const Divider(height: 1),
                        InkWell(
                          onTap: () {
                            Navigator.of(ctx).pop();
                            context.go(Routes.notifications);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  l10n.notifViewAll,
                                  style: AppTypography.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  isRtl ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                                  color: AppColors.primary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    // After closing the panel, refresh the unread count in case the user
    // navigated and read items elsewhere.
    if (mounted) {
      ref.read(unreadCountProvider.notifier).load();
    }
  }

  Widget _buildList(BuildContext context, AppLocalizations l10n, bool isDark, Color muted) {
    final state = ref.watch(notificationListProvider);
    if (state is NotificationListLoading || state is NotificationListInitial) {
      return const Padding(padding: EdgeInsets.all(AppSpacing.lg), child: PosLoading());
    }
    if (state is NotificationListError) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: PosErrorState(message: state.message),
      );
    }
    if (state is NotificationListLoaded) {
      final items = state.notifications.take(5).toList();
      if (items.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: PosEmptyState(title: l10n.notifNoRecent, icon: Icons.notifications_off_outlined),
        );
      }
      return ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: items.length,
        separatorBuilder: (_, _) => const Divider(height: 1),
        itemBuilder: (_, i) {
          final n = items[i];
          final title = (n['title'] as String?) ?? '';
          final message = (n['message'] as String?) ?? '';
          final isRead = (n['is_read'] as bool?) ?? false;
          return ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: isRead ? muted.withValues(alpha: 0.4) : AppColors.primary.withValues(alpha: 0.15),
              child: Icon(Icons.notifications_rounded, size: 14, color: isRead ? muted : AppColors.primary),
            ),
            title: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(fontWeight: isRead ? FontWeight.w500 : FontWeight.w700),
            ),
            subtitle: Text(
              message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodySmall.copyWith(color: muted),
            ),
            onTap: () {
              Navigator.of(context).pop();
              GoRouter.of(context).go(Routes.notifications);
            },
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final unread = ref.watch(unreadCountProvider);
    final count = unread is UnreadCountLoaded ? unread.count : 0;

    return PosCountBadge(
      count: count,
      child: IconButton(tooltip: l10n.notifBellTooltip, icon: const Icon(Icons.notifications_outlined), onPressed: _showPanel),
    );
  }
}
