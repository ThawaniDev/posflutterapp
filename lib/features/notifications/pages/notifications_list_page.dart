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
    ref.read(notificationListProvider.notifier).load(category: category);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final listState = ref.watch(notificationListProvider);
    final unreadState = ref.watch(unreadCountProvider);
    final actionState = ref.watch(notificationActionProvider);

    // Listen for action results
    ref.listen<NotificationActionState>(notificationActionProvider, (prev, next) {
      if (next is NotificationActionSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.message)));
        ref.read(notificationListProvider.notifier).load(category: _selectedCategory);
        ref.read(unreadCountProvider.notifier).load();
        ref.read(notificationActionProvider.notifier).reset();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationsTitle),
        actions: [
          // Unread badge
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
          // Mark all as read
          IconButton(
            icon: const Icon(Icons.done_all),
            tooltip: l10n.notificationsMarkAllAsRead,
            onPressed: actionState is NotificationActionLoading
                ? null
                : () => ref.read(notificationActionProvider.notifier).markAllAsRead(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter chips
          _buildCategoryFilter(),
          const Divider(height: 1),
          // Notification list
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
                label: Text(cat[0].toUpperCase() + cat.substring(1)),
                selected: _selectedCategory == cat,
                onSelected: (_) => _filterByCategory(cat),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(NotificationListState state) {
    return switch (state) {
      NotificationListInitial() || NotificationListLoading() => Center(child: PosLoadingSkeleton.list()),
      NotificationListError(:final message) => PosErrorState(
        message: message,
        onRetry: () => ref.read(notificationListProvider.notifier).load(category: _selectedCategory),
      ),
      NotificationListLoaded(:final notifications) =>
        notifications.isEmpty
            ? PosEmptyState(title: l10n.notificationsNoNotifications, icon: Icons.notifications_none)
            : RefreshIndicator(
                onRefresh: () => ref.read(notificationListProvider.notifier).load(category: _selectedCategory),
                child: ListView.separated(
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _buildNotificationTile(notifications[index]),
                ),
              ),
    };
  }

  Widget _buildNotificationTile(Map<String, dynamic> notification) {
    final isRead = notification['is_read'] as bool? ?? false;
    final category = notification['category'] as String? ?? '';
    final title = notification['title'] as String? ?? '';
    final message = notification['message'] as String? ?? '';
    final createdAt = notification['created_at'] as String?;
    final id = notification['id'] as String;

    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => ref.read(notificationActionProvider.notifier).delete(id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isRead ? AppColors.borderLight : _categoryColor(category),
          child: Icon(_categoryIcon(category), color: isRead ? AppColors.textSecondary : Colors.white, size: 20),
        ),
        title: Text(title, style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold)),
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
        trailing: !isRead
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

  String _formatTime(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }
}
