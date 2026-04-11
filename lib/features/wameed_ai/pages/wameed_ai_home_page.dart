import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_state.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_usage_banner.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(l10n.wameedAI),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: l10n.wameedAIUsage,
            onPressed: () => context.push(Routes.wameedAIUsage),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.wameedAISettings,
            onPressed: () => context.push(Routes.wameedAISettings),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.commonRefresh,
            onPressed: () {
              ref.read(aiChatListProvider.notifier).load();
              ref.read(aiUsageProvider.notifier).load();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewChat,
        icon: const Icon(Icons.add),
        label: const Text('New Chat'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 36, color: AppColors.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wameed AI Assistant',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ask anything about your business — sales, inventory, customers, and more.',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 16 : AppSpacing.lg),
            const AIUsageBanner(),
            SizedBox(height: isMobile ? 16 : AppSpacing.lg),

            // Chat history
            Text(
              'Recent Chats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            switch (chatListState) {
              AIChatListInitial() || AIChatListLoading() => const Center(child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              )),
              AIChatListError(:final message) => Center(
                child: Column(
                  children: [
                    Text(message),
                    const SizedBox(height: 12),
                    PosButton(label: l10n.commonRetry, onPressed: () => ref.read(aiChatListProvider.notifier).load()),
                  ],
                ),
              ),
              AIChatListLoaded(:final chats) => chats.isEmpty
                  ? _buildEmptyState()
                  : _buildChatList(chats, isMobile),
            },
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: Theme.of(context).hintColor.withValues(alpha: 0.4)),
            const SizedBox(height: 16),
            Text(
              'No conversations yet',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).hintColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap "New Chat" to start a conversation with Wameed AI',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(List<AIChat> chats, bool isMobile) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: chats.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final chat = chats[index];
        return _buildChatTile(chat);
      },
    );
  }

  Widget _buildChatTile(AIChat chat) {
    final theme = Theme.of(context);
    final timeAgo = chat.lastMessageAt != null
        ? _formatTimeAgo(chat.lastMessageAt!)
        : '';

    return InkWell(
      onTap: () => _openChat(chat.id),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.chat_outlined, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
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
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (chat.llmModel != null) ...[
                        Text(
                          chat.llmModel!.displayName,
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.hintColor),
                        ),
                        const SizedBox(width: 8),
                        Text('•', style: TextStyle(color: theme.hintColor)),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        '${chat.messageCount} messages',
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
                const SizedBox(height: 4),
                Icon(Icons.chevron_right, color: theme.hintColor, size: 18),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.month}/${dateTime.day}';
  }
}
