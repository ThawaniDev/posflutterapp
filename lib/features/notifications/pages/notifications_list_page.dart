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
import 'package:wameedpos/features/notifications/widgets/notification_stats_widget.dart';

class NotificationsListPage extends ConsumerStatefulWidget {
  const NotificationsListPage({super.key});

  @override
  ConsumerState<NotificationsListPage> createState() => _NotificationsListPageState();
}

class _NotificationsListPageState extends ConsumerState<NotificationsListPage> {
  String? _selectedCategory;
  String? _selectedPriority;
  final Set<String> _selectedIds = {};
  bool _isSelectionMode = false;
  bool _showStats = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationListProvider.notifier).load();
      ref.read(unreadCountProvider.notifier).load();
      ref.read(notificationStatsProvider.notifier).load();
    });
  }

  void _filterByCategory(String? category) {
    setState(() => _selectedCategory = category);
    _reload();
  }

  void _filterByPriority(String? priority) {
    setState(() => _selectedPriority = priority);
    _reload();
  }

  void _reload() {
    ref.read(notificationListProvider.notifier).load(category: _selectedCategory, priority: _selectedPriority);
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
      _isSelectionMode = _selectedIds.isNotEmpty;
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
      _isSelectionMode = false;
    });
  }

  Future<void> _bulkDelete() async {
    if (_selectedIds.isEmpty) return;
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showPosConfirmDialog(
      context,
      title: l10n.notifDeleteConfirmTitle,
      message: l10n.notifDeleteConfirmMessage(_selectedIds.length),
      confirmLabel: l10n.delete,
      isDanger: true,
    );
    if (confirmed == true) {
      ref.read(notificationActionProvider.notifier).bulkDelete(_selectedIds.toList());
      _clearSelection();
    }
  }

  String _translateAction(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    if (key.startsWith('bulk_deleted:')) {
      final count = int.tryParse(key.split(':').last) ?? 0;
      return l10n.notifActionBulkDeleted(count);
    }
    switch (key) {
      case 'marked_as_read':
        return l10n.notifActionMarkedAsRead;
      case 'all_marked_as_read':
        return l10n.notifActionAllMarkedAsRead;
      case 'deleted':
        return l10n.notifActionDeleted;
      case 'batch_created':
        return l10n.notifActionBatchCreated;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final listState = ref.watch(notificationListProvider);
    final unreadState = ref.watch(unreadCountProvider);
    final actionState = ref.watch(notificationActionProvider);

    ref.listen<NotificationActionState>(notificationActionProvider, (prev, next) {
      if (next is NotificationActionSuccess) {
        showPosSuccessSnackbar(context, _translateAction(context, next.message));
        _reload();
        ref.read(unreadCountProvider.notifier).load();
        ref.read(notificationStatsProvider.notifier).load();
        ref.read(notificationActionProvider.notifier).reset();
      } else if (next is NotificationActionError) {
        showPosErrorSnackbar(context, next.message);
        ref.read(notificationActionProvider.notifier).reset();
      }
    });

    return PosListPage(
      title: _isSelectionMode ? l10n.notificationsSelected(_selectedIds.length) : l10n.notificationsTitle,
      showSearch: false,
      onBack: _isSelectionMode ? _clearSelection : null,
      actions: [
        if (_isSelectionMode) ...[
          PosButton.icon(
            icon: Icons.delete_outline,
            tooltip: l10n.notificationsBulkDelete,
            onPressed: actionState is NotificationActionLoading ? null : _bulkDelete,
          ),
        ] else ...[
          if (unreadState is UnreadCountLoaded && unreadState.count > 0)
            PosCountBadge(
              count: unreadState.count,
              child: PosButton.icon(
                icon: Icons.notifications_active_outlined,
                tooltip: l10n.notificationsUnread(unreadState.count),
                onPressed: () {},
              ),
            ),
          PosButton.icon(
            icon: Icons.done_all_rounded,
            tooltip: l10n.notificationsMarkAllAsRead,
            onPressed: actionState is NotificationActionLoading
                ? null
                : () => ref.read(notificationActionProvider.notifier).markAllAsRead(),
          ),
          PosButton.icon(
            icon: _showStats ? Icons.bar_chart_rounded : Icons.bar_chart_outlined,
            tooltip: l10n.notifStatsTitle,
            onPressed: () => setState(() => _showStats = !_showStats),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: l10n.notifMoreActions,
            onSelected: (value) {
              switch (value) {
                case 'preferences':
                  context.go(Routes.notificationPreferences);
                case 'schedules':
                  context.go(Routes.notificationSchedules);
                case 'delivery_logs':
                  context.go(Routes.notificationDeliveryLogs);
                case 'sound_configs':
                  context.go(Routes.notificationSoundConfigs);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'preferences',
                child: ListTile(
                  leading: const Icon(Icons.tune_rounded, size: 20),
                  title: Text(l10n.notificationsPreferences, style: AppTypography.bodyMedium),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'schedules',
                child: ListTile(
                  leading: const Icon(Icons.schedule_rounded, size: 20),
                  title: Text(l10n.notifSchedulesTitle, style: AppTypography.bodyMedium),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delivery_logs',
                child: ListTile(
                  leading: const Icon(Icons.local_shipping_outlined, size: 20),
                  title: Text(l10n.notifDeliveryLogsTitle, style: AppTypography.bodyMedium),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'sound_configs',
                child: ListTile(
                  leading: const Icon(Icons.volume_up_outlined, size: 20),
                  title: Text(l10n.notifSoundConfigsTitle, style: AppTypography.bodyMedium),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ],
      child: Column(
        children: [
          if (_showStats) ...[const NotificationStatsWidget(), const PosDivider()],
          _buildToolbar(isDark),
          const PosDivider(),
          Expanded(child: _buildList(listState, isDark)),
        ],
      ),
    );
  }

  Widget _buildToolbar(bool isDark) {
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
                PosButton.pill(
                  label: l10n.ordersAll,
                  onPressed: () => _filterByCategory(null),
                  isSelected: _selectedCategory == null,
                ),
                AppSpacing.gapW8,
                ..._categories.map(
                  (cat) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                    child: PosButton.pill(
                      label: _localizedCategory(l10n, cat),
                      icon: _categoryIcon(cat),
                      onPressed: () => _filterByCategory(cat),
                      isSelected: _selectedCategory == cat,
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
                  l10n.notificationsPriority,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                AppSpacing.gapW8,
                PosButton.pill(
                  label: l10n.ordersAll,
                  onPressed: () => _filterByPriority(null),
                  isSelected: _selectedPriority == null,
                ),
                AppSpacing.gapW4,
                ..._priorities.map(
                  (p) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
                    child: PosButton.pill(
                      label: _localizedPriority(l10n, p),
                      icon: _priorityIcon(p),
                      onPressed: () => _filterByPriority(p),
                      isSelected: _selectedPriority == p,
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

  Widget _buildList(NotificationListState state, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return switch (state) {
      NotificationListInitial() || NotificationListLoading() => const Center(child: PosLoading()),
      NotificationListError(:final message) => PosErrorState(message: message, onRetry: _reload),
      NotificationListLoaded(:final notifications) =>
        notifications.isEmpty
            ? PosEmptyState(
                title: l10n.notificationsNoNotifications,
                subtitle: l10n.notifEmptySubtitle,
                icon: Icons.notifications_none_rounded,
              )
            : RefreshIndicator(
                onRefresh: () async => _reload(),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                  itemCount: notifications.length,
                  separatorBuilder: (_, _) => AppSpacing.gapH8,
                  itemBuilder: (context, index) => _buildNotificationCard(notifications[index], isDark),
                ),
              ),
    };
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final isRead = notification['is_read'] as bool? ?? false;
    final category = notification['category'] as String? ?? '';
    final title = notification['title'] as String? ?? '';
    final message = notification['message'] as String? ?? '';
    final createdAt = notification['created_at'] as String?;
    final id = notification['id'] as String;
    final priority = notification['priority'] as String?;
    final isSelected = _selectedIds.contains(id);

    return PosCard(
      onTap: _isSelectionMode
          ? () => _toggleSelection(id)
          : () {
              if (!isRead) {
                ref.read(notificationActionProvider.notifier).markAsRead(id);
              }
            },
      padding: AppSpacing.paddingAll16,
      color: isSelected
          ? (isDark ? AppColors.primary.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.08))
          : !isRead
          ? (isDark ? AppColors.surfaceDark : AppColors.primary.withValues(alpha: 0.03))
          : null,
      child: Dismissible(
        key: Key(id),
        direction: _isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
        background: Container(
          alignment: AlignmentDirectional.centerEnd,
          padding: const EdgeInsetsDirectional.only(end: AppSpacing.base),
          decoration: BoxDecoration(color: AppColors.error, borderRadius: AppRadius.borderLg),
          child: const Icon(Icons.delete_rounded, color: Colors.white),
        ),
        confirmDismiss: (_) async {
          final confirmed = await showPosConfirmDialog(
            context,
            title: l10n.notifDeleteSingleTitle,
            message: l10n.notifDeleteSingleMessage,
            confirmLabel: l10n.delete,
            isDanger: true,
          );
          return confirmed == true;
        },
        onDismissed: (_) => ref.read(notificationActionProvider.notifier).delete(id),
        child: InkWell(
          onLongPress: () => _toggleSelection(id),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isSelectionMode)
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                  child: Checkbox(value: isSelected, onChanged: (_) => _toggleSelection(id)),
                )
              else
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: isRead
                        ? (isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight)
                        : _categoryColor(category).withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderMd,
                  ),
                  child: Icon(
                    _categoryIcon(category),
                    size: AppSizes.iconMd,
                    color: isRead ? (AppColors.mutedFor(context)) : _categoryColor(category),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: isRead ? FontWeight.w400 : FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (priority != null && priority != 'normal') ...[
                          AppSpacing.gapW8,
                          PosBadge(
                            label: _localizedPriority(l10n, priority),
                            variant: _priorityBadgeVariant(priority),
                            isSmall: true,
                          ),
                        ],
                      ],
                    ),
                    AppSpacing.gapH4,
                    Text(
                      message,
                      style: AppTypography.bodySmall.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapH8,
                    Row(
                      children: [
                        PosBadge(label: _localizedCategory(l10n, category), variant: PosBadgeVariant.neutral, isSmall: true),
                        AppSpacing.gapW8,
                        if (createdAt != null)
                          Text(
                            _formatTime(createdAt),
                            style: AppTypography.micro.copyWith(
                              color: AppColors.mutedFor(context),
                            ),
                          ),
                        const Spacer(),
                        if (!isRead && !_isSelectionMode)
                          InkWell(
                            onTap: () => ref.read(notificationActionProvider.notifier).markAsRead(id),
                            borderRadius: AppRadius.borderFull,
                            child: Tooltip(
                              message: l10n.notificationsMarkRead,
                              child: Padding(
                                padding: AppSpacing.paddingAll4,
                                child: Container(
                                  width: AppSizes.dotMd,
                                  height: AppSizes.dotMd,
                                  decoration: const BoxDecoration(color: AppColors.info, shape: BoxShape.circle),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _categories = ['order', 'inventory', 'promotion', 'system', 'payment', 'staff'];
  static const _priorities = ['low', 'normal', 'high', 'urgent'];

  IconData _categoryIcon(String category) {
    return switch (category) {
      'order' => Icons.receipt_long_rounded,
      'inventory' => Icons.inventory_2_rounded,
      'promotion' => Icons.local_offer_rounded,
      'system' => Icons.settings_rounded,
      'payment' => Icons.payment_rounded,
      'staff' => Icons.people_rounded,
      _ => Icons.notifications_rounded,
    };
  }

  Color _categoryColor(String category) {
    return switch (category) {
      'order' => AppColors.info,
      'inventory' => AppColors.warning,
      'promotion' => AppColors.purple,
      'system' => AppColors.textSecondaryLight,
      'payment' => AppColors.success,
      'staff' => AppColors.rose,
      _ => AppColors.textSecondaryLight,
    };
  }

  IconData _priorityIcon(String priority) {
    return switch (priority) {
      'urgent' => Icons.priority_high_rounded,
      'high' => Icons.arrow_upward_rounded,
      'low' => Icons.arrow_downward_rounded,
      _ => Icons.remove_rounded,
    };
  }

  PosBadgeVariant _priorityBadgeVariant(String priority) {
    return switch (priority) {
      'urgent' => PosBadgeVariant.error,
      'high' => PosBadgeVariant.warning,
      'low' => PosBadgeVariant.neutral,
      _ => PosBadgeVariant.info,
    };
  }

  String _formatTime(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt);
      final loc = AppLocalizations.of(context)!;
      if (diff.inMinutes < 1) return loc.notifJustNow;
      if (diff.inMinutes < 60) return loc.posMinutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return loc.posHoursAgo(diff.inHours);
      if (diff.inDays < 7) return loc.posDaysAgo(diff.inDays);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  String _localizedCategory(AppLocalizations l10n, String cat) {
    return switch (cat) {
      'order' => l10n.notifCategoryOrder,
      'inventory' => l10n.notifCategoryInventory,
      'promotion' => l10n.notifCategoryPromotion,
      'system' => l10n.notifCategorySystem,
      'payment' => l10n.notifCategoryPayment,
      'staff' => l10n.notifCategoryStaff,
      _ => cat.isNotEmpty ? '${cat[0].toUpperCase()}${cat.substring(1)}' : cat,
    };
  }

  String _localizedPriority(AppLocalizations l10n, String priority) {
    return switch (priority) {
      'urgent' => l10n.notifPriorityUrgent,
      'high' => l10n.notifPriorityHigh,
      'low' => l10n.notifPriorityLow,
      _ => l10n.notifPriorityNormal,
    };
  }
}
