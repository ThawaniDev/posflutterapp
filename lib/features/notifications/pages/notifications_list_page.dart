import 'package:flutter/material.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/notifications/providers/notification_providers.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationListProvider.notifier).load();
      ref.read(unreadCountProvider.notifier).load();
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

  void _bulkDelete() {
    if (_selectedIds.isEmpty) return;
    ref.read(notificationActionProvider.notifier).bulkDelete(_selectedIds.toList());
    _clearSelection();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(notificationListProvider);
    final unreadState = ref.watch(unreadCountProvider);
    final actionState = ref.watch(notificationActionProvider);

    ref.listen<NotificationActionState>(notificationActionProvider, (prev, next) {
      if (next is NotificationActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        _reload();
        ref.read(unreadCountProvider.notifier).load();
        ref.read(notificationActionProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: _isSelectionMode ? Text(l10n.notificationsSelected(_selectedIds.length)) : Text(l10n.notificationsTitle),
        leading: _isSelectionMode ? IconButton(icon: const Icon(Icons.close), onPressed: _clearSelection) : null,
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n.notificationsBulkDelete,
              onPressed: actionState is NotificationActionLoading ? null : _bulkDelete,
            ),
          ] else ...[
            if (unreadState is UnreadCountLoaded && unreadState.count > 0)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(
                    l10n.notificationsUnread(unreadState.count),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: AppColors.error,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: l10n.notificationsMarkAllAsRead,
              onPressed: actionState is NotificationActionLoading
                  ? null
                  : () => ref.read(notificationActionProvider.notifier).markAllAsRead(),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          _buildPriorityFilter(),
          const Divider(height: 1),
          Expanded(child: _buildList(listState)),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    final l10n = AppLocalizations.of(context)!;
    const categories = ['order', 'inventory', 'promotion', 'system', 'payment', 'staff'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          FilterChip(
            label: Text(l10n.ordersAll),
            selected: _selectedCategory == null,
            onSelected: (_) => _filterByCategory(null),
          ),
          AppSpacing.gapW8,
          ...categories.map(
            (cat) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_localizedCategory(l10n, cat)),
                selected: _selectedCategory == cat,
                onSelected: (_) => _filterByCategory(cat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityFilter() {
    final l10n = AppLocalizations.of(context)!;
    const priorities = ['low', 'normal', 'high', 'urgent'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Text(l10n.notificationsPriority, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          AppSpacing.gapW8,
          FilterChip(
            label: Text(l10n.ordersAll),
            selected: _selectedPriority == null,
            onSelected: (_) => _filterByPriority(null),
            visualDensity: VisualDensity.compact,
          ),
          AppSpacing.gapW4,
          ...priorities.map(
            (p) => Padding(
              padding: const EdgeInsets.only(right: 4),
              child: FilterChip(
                label: Text(_localizedPriority(l10n, p)),
                selected: _selectedPriority == p,
                onSelected: (_) => _filterByPriority(p),
                visualDensity: VisualDensity.compact,
                avatar: Icon(_priorityIcon(p), size: 14, color: _priorityColor(p)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(NotificationListState state) {
    final l10n = AppLocalizations.of(context)!;
    return switch (state) {
      NotificationListInitial() || NotificationListLoading() => Center(child: PosLoadingSkeleton.list()),
      NotificationListError(:final message) => PosErrorState(message: message, onRetry: _reload),
      NotificationListLoaded(:final notifications) =>
        notifications.isEmpty
            ? PosEmptyState(title: l10n.notificationsNoNotifications, icon: Icons.notifications_none)
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(notificationListProvider.notifier).load(category: _selectedCategory, priority: _selectedPriority),
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _buildNotificationTile(notifications[index]),
                ),
              ),
    };
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final l10n = AppLocalizations.of(context)!;
    final isRead = notification['is_read'] as bool? ?? false;
    final category = notification['category'] as String? ?? '';
    final title = notification['title'] as String? ?? '';
    final message = notification['message'] as String? ?? '';
    final createdAt = notification['created_at'] as String?;
    final id = notification['id'] as String;
    final priority = notification['priority'] as String?;
    final isSelected = _selectedIds.contains(id);

    return Dismissible(
      key: Key(id),
      direction: _isSelectionMode ? DismissDirection.none : DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => ref.read(notificationActionProvider.notifier).delete(id),
      child: ListTile(
        selected: isSelected,
        selectedTileColor: AppColors.primary.withValues(alpha: 0.08),
        onLongPress: () => _toggleSelection(id),
        onTap: _isSelectionMode ? () => _toggleSelection(id) : null,
        leading: _isSelectionMode
            ? Checkbox(value: isSelected, onChanged: (_) => _toggleSelection(id))
            : CircleAvatar(
                backgroundColor: isRead ? AppColors.borderLight : _categoryColor(category),
                child: Icon(_categoryIcon(category), color: isRead ? AppColors.textSecondary : Colors.white, size: 20),
              ),
        title: Row(
          children: [
            Expanded(
              child: Text(title, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
            ),
            if (priority != null && priority != 'normal')
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: _priorityColor(priority).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _localizedPriority(l10n, priority),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: _priorityColor(priority)),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
            if (createdAt != null) ...[
              AppSpacing.gapH4,
              Text(_formatTime(createdAt), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ],
        ),
        trailing: !isRead && !_isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.circle, size: 12, color: AppColors.info),
                tooltip: l10n.notificationsMarkRead,
                onPressed: () => ref.read(notificationActionProvider.notifier).markAsRead(id),
              )
            : null,
        isThreeLine: true,
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

  IconData _priorityIcon(String priority) {
    return switch (priority) {
      'urgent' => Icons.priority_high,
      'high' => Icons.arrow_upward,
      'low' => Icons.arrow_downward,
      _ => Icons.remove,
    };
  }

  Color _priorityColor(String priority) {
    return switch (priority) {
      'urgent' => AppColors.error,
      'high' => AppColors.warning,
      'low' => AppColors.textSecondary,
      _ => AppColors.info,
    };
  }

  String _formatTime(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt);
      final loc = AppLocalizations.of(context)!;
      if (diff.inMinutes < 60) return loc.posMinutesAgo(diff.inMinutes);
      if (diff.inHours < 24) return loc.posHoursAgo(diff.inHours);
      if (diff.inDays < 7) return loc.posDaysAgo(diff.inDays);
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  String _localizedCategory(AppLocalizations l10n, String cat) {
    switch (cat) {
      case 'order':
        return l10n.notifCategoryOrder;
      case 'inventory':
        return l10n.notifCategoryInventory;
      case 'promotion':
        return l10n.notifCategoryPromotion;
      case 'system':
        return l10n.notifCategorySystem;
      case 'payment':
        return l10n.notifCategoryPayment;
      case 'staff':
        return l10n.notifCategoryStaff;
      default:
        return cat[0].toUpperCase() + cat.substring(1);
    }
  }

  String _localizedPriority(AppLocalizations l10n, String priority) {
    switch (priority) {
      case 'urgent':
        return l10n.notifPriorityUrgent;
      case 'high':
        return l10n.notifPriorityHigh;
      case 'low':
        return l10n.notifPriorityLow;
      default:
        return l10n.notifPriorityNormal;
    }
  }
}
