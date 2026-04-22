import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/features/wameed_ai/data/ai_chat_repository.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_state.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_usage_banner.dart';

class WameedAIHomePage extends ConsumerStatefulWidget {
  const WameedAIHomePage({super.key});

  @override
  ConsumerState<WameedAIHomePage> createState() => _WameedAIHomePageState();
}

class _WameedAIHomePageState extends ConsumerState<WameedAIHomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(aiChatListProvider.notifier).load();
      ref.read(aiUsageProvider.notifier).load();
    });
  }

  void _openNewChat() {
    context.push('${Routes.wameedAIChat}/new');
  }

  void _openChat(String chatId) {
    context.push('${Routes.wameedAIChat}/$chatId');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chatListState = ref.watch(aiChatListProvider);
    final isMobile = context.isPhone;
    final quickActions = <_QuickActionItem>[
      _QuickActionItem(
        icon: Icons.add_comment_outlined,
        label: l10n.wameedAINewChat,
        onTap: _openNewChat,
        iconColor: AppColors.primary,
      ),
      _QuickActionItem(
        icon: Icons.receipt_outlined,
        label: l10n.wameedAIBilling,
        onTap: () => context.push(Routes.wameedAIBilling),
      ),
      _QuickActionItem(
        icon: Icons.bar_chart_outlined,
        label: l10n.wameedAIUsage,
        onTap: () => context.push(Routes.wameedAIUsage),
      ),
      _QuickActionItem(
        icon: Icons.settings_outlined,
        label: l10n.wameedAISettings,
        onTap: () => context.push(Routes.wameedAISettings),
      ),
      _QuickActionItem(
        icon: Icons.refresh,
        label: l10n.commonRefresh,
        onTap: () {
          ref.read(aiChatListProvider.notifier).load();
          ref.read(aiUsageProvider.notifier).load();
        },
      ),
    ];

    return PosListPage(
      title: l10n.wameedAI,
      showSearch: false,
      child: SingleChildScrollView(
        padding: context.responsivePagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActionGrid(quickActions, isMobile),
            AppSpacing.gapH16,

            // Welcome card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.03)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: AppRadius.borderLg,
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 36, color: AppColors.primary),
                  AppSpacing.gapW16,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.wameedAIAssistant,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                        AppSpacing.gapH4,
                        Text(
                          l10n.wameedAIWelcomeSubtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AppSpacing.gapH16,
            const AIUsageBanner(),
            AppSpacing.gapH16,

            // Chat history
            Text(l10n.wameedAIRecentChats, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            AppSpacing.gapH12,
            switch (chatListState) {
              AIChatListInitial() || AIChatListLoading() => const PosLoading(),
              AIChatListError(:final message) => PosErrorState(
                message: message,
                onRetry: () => ref.read(aiChatListProvider.notifier).load(),
              ),
              AIChatListLoaded(:final chats) => chats.isEmpty ? _buildEmptyState() : _buildChatList(chats, isMobile),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionGrid(List<_QuickActionItem> actions, bool isMobile) {
    final theme = Theme.of(context);
    final fallbackIconColor = theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 12.0;
        final crossAxisCount = switch (constraints.maxWidth) {
          >= 1200 => 5,
          >= 900 => 4,
          >= 650 => 3,
          _ => isMobile ? 2 : 3,
        };
        final itemWidth = (constraints.maxWidth - ((crossAxisCount - 1) * spacing)) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: actions
              .map((action) {
                final iconColor = action.iconColor ?? fallbackIconColor;
                return SizedBox(
                  width: itemWidth,
                  child: PosCard(
                    onTap: action.onTap,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(action.icon, size: 18, color: iconColor),
                        ),
                        AppSpacing.gapW8,
                        Expanded(
                          child: Text(
                            action.label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
              .toList(growable: false),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final l10n = AppLocalizations.of(context)!;
    return PosEmptyState(title: l10n.wameedAINoChats, subtitle: l10n.wameedAINoChatsSubtitle, icon: Icons.chat_bubble_outline);
  }

  Widget _buildChatList(List<AIChat> chats, bool isMobile) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chats.length,
      separatorBuilder: (_, __) => AppSpacing.gapH8,
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatTile(chat);
      },
    );
  }

  Widget _buildChatTile(AIChat chat) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final timeAgo = chat.lastMessageAt != null ? _formatTimeAgo(l10n, chat.lastMessageAt!) : '';

    return PosCard(
      onTap: () => _openChat(chat.id),
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onLongPress: () => _showChatOptionsSheet(chat),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.chat_outlined, color: AppColors.primary, size: 20),
            ),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.title,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppSpacing.gapH4,
                  Row(
                    children: [
                      if (chat.llmModel != null) ...[
                        Text(chat.llmModel!.displayName, style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
                        AppSpacing.gapW8,
                        Text('•', style: TextStyle(color: theme.hintColor)),
                        AppSpacing.gapW8,
                      ],
                      Text(
                        '${chat.messageCount} ${l10n.wameedAIMessages}',
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(timeAgo, style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor)),
                AppSpacing.gapH4,
                Icon(Icons.chevron_right, color: theme.hintColor, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(AppLocalizations l10n, DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return l10n.wameedAIJustNow;
    if (diff.inMinutes < 60) return l10n.wameedAIMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return l10n.wameedAIHoursAgo(diff.inHours);
    if (diff.inDays < 7) return l10n.wameedAIDaysAgo(diff.inDays);
    return '${dateTime.month}/${dateTime.day}';
  }

  void _showChatOptionsSheet(AIChat chat) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: Text(l10n.commonRename),
              onTap: () {
                Navigator.of(ctx).pop();
                _showRenameChatDialog(chat);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: AppColors.error),
              title: Text(l10n.commonDelete, style: const TextStyle(color: AppColors.error)),
              onTap: () {
                Navigator.of(ctx).pop();
                ref.read(aiChatListProvider.notifier).deleteChat(chat.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showRenameChatDialog(AIChat chat) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: chat.title);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.wameedAIRenameChat),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLength: 255,
          decoration: InputDecoration(hintText: l10n.wameedAIEnterChatTitle),
          onSubmitted: (value) {
            final title = value.trim();
            if (title.isNotEmpty) {
              ref.read(aiActiveChatProvider.notifier).loadChat(chat.id);
              Future.delayed(const Duration(milliseconds: 200), () {
                ref.read(aiActiveChatProvider.notifier).renameChat(title);
                ref.read(aiChatListProvider.notifier).load();
              });
            }
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
          PosButton(
            onPressed: () {
              final title = controller.text.trim();
              if (title.isNotEmpty) {
                // Use repository directly to rename without loading chat
                ref.read(aiChatRepositoryProvider).renameChat(chatId: chat.id, title: title).then((_) {
                  ref.read(aiChatListProvider.notifier).load();
                });
              }
              Navigator.of(ctx).pop();
            },
            variant: PosButtonVariant.ghost,
            label: l10n.commonRename,
          ),
        ],
      ),
    ).then((_) => controller.dispose());
  }
}

class _QuickActionItem {
  const _QuickActionItem({required this.icon, required this.label, required this.onTap, this.iconColor});

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
}
