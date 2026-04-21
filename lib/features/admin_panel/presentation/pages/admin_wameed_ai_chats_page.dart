import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_providers.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class AdminWameedAIChatsPage extends ConsumerStatefulWidget {
  const AdminWameedAIChatsPage({super.key});

  @override
  ConsumerState<AdminWameedAIChatsPage> createState() => _State();
}

class _State extends ConsumerState<AdminWameedAIChatsPage> {
  String? _search;
  String? _from;
  String? _to;
  int _page = 1;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _from = DateTime(now.year, now.month - 1, now.day).toIso8601String().substring(0, 10);
    _to = now.toIso8601String().substring(0, 10);
    Future.microtask(_load);
  }

  void _load() {
    ref
        .read(wameedAIAdminChatsProvider.notifier)
        .load(
          params: {
            'page': _page,
            'per_page': 25,
            if (_search != null && _search!.isNotEmpty) 'search': _search!,
            if (_from != null && _from!.isNotEmpty) 'from': _from!,
            if (_to != null && _to!.isNotEmpty) 'to': _to!,
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wameedAIAdminChatsProvider);

    return PosListPage(
  title: l10n.adminWameedAIChats,
  showSearch: false,
    child: Column(
        children: [
          _buildFilters(l10n),
          const Divider(height: 1),
          Expanded(
            child: switch (state) {
              WameedAIAdminListLoading() => const Center(child: PosLoading()),
              WameedAIAdminListLoaded(data: final resp) => _buildContent(resp, l10n),
              WameedAIAdminListError(message: final msg) => PosErrorState(message: msg, onRetry: _load),
              _ => Center(child: Text(l10n.loading)),
            },
          ),
        ],
      ),
);
  }

  Widget _buildFilters(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: PosSearchField(hint: l10n.searchChats, onChanged: (v) => _search = v),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 140,
            child: PosTextField(label: l10n.from, hint: _from ?? 'YYYY-MM-DD', onChanged: (v) => _from = v),
          ),
          const SizedBox(width: AppSpacing.sm),
          SizedBox(
            width: 140,
            child: PosTextField(label: l10n.to, hint: _to ?? 'YYYY-MM-DD', onChanged: (v) => _to = v),
          ),
          const SizedBox(width: AppSpacing.sm),
          PosButton(
            label: l10n.apply,
            onPressed: () {
              _page = 1;
              _load();
            },
            size: PosButtonSize.sm,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final chats = (data['chats'] as List?)?.cast<Map<String, dynamic>>() ?? [];
    final total = data['total'] as int? ?? 0;
    final currentPage = data['current_page'] as int? ?? 1;
    final lastPage = data['last_page'] as int? ?? 1;

    // Compute stats from visible data
    int totalMessages = 0;
    double totalCost = 0;
    int totalTokens = 0;
    for (final c in chats) {
      totalMessages += (c['message_count'] as num?)?.toInt() ?? (c['messages_count'] as num?)?.toInt() ?? 0;
      totalCost += (c['total_cost_usd'] as num?)?.toDouble() ?? 0;
      totalTokens += (c['total_tokens'] as num?)?.toInt() ?? 0;
    }

    return Column(
      children: [
        // ── KPI Cards ──
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: GridView.count(
            crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.md,
            mainAxisSpacing: AppSpacing.md,
            childAspectRatio: 2.5,
            children: [
              PosKpiCard(
                label: l10n.adminWameedAITotalChats,
                value: '$total',
                subtitle: l10n.adminWameedAIAllConversations,
                icon: Icons.chat_bubble_rounded,
                iconColor: AppColors.primary,
              ),
              PosKpiCard(
                label: l10n.adminWameedAITotalMessages,
                value: '$totalMessages',
                subtitle: '${l10n.adminWameedAIInPage} ${chats.length} ${l10n.adminWameedAIChats}',
                icon: Icons.message_rounded,
                iconColor: AppColors.info,
              ),
              PosKpiCard(
                label: l10n.adminWameedAIChatCost,
                value: '\$${totalCost.toStringAsFixed(4)}',
                subtitle: '${_fmtLargeNumber(totalTokens)} ${l10n.tokens}',
                icon: Icons.attach_money_rounded,
                iconColor: AppColors.warning,
              ),
              PosKpiCard(
                label: l10n.adminWameedAIAvgMessages,
                value: chats.isNotEmpty ? (totalMessages / chats.length).toStringAsFixed(1) : '0',
                subtitle: l10n.adminWameedAIPerChat,
                icon: Icons.analytics_rounded,
                iconColor: AppColors.success,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        // ── Chat List ──
        Expanded(
          child: chats.isEmpty
              ? PosEmptyState(title: l10n.noChatsFound, subtitle: l10n.adjustFilters, icon: Icons.chat_rounded)
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) => _chatCard(chats[i], l10n),
                ),
        ),
        // ── Pagination ──
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n.showing} ${chats.length} ${l10n.of_} $total', style: AppTypography.bodySmall),
              Row(
                children: [
                  IconButton(
                    onPressed: currentPage > 1
                        ? () {
                            _page = currentPage - 1;
                            _load();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('$currentPage / $lastPage', style: AppTypography.bodySmall),
                  IconButton(
                    onPressed: currentPage < lastPage
                        ? () {
                            _page = currentPage + 1;
                            _load();
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _chatCard(Map<String, dynamic> chat, AppLocalizations l10n) {
    final title = chat['title']?.toString() ?? l10n.untitledChat;
    final messageCount = (chat['message_count'] ?? chat['messages_count'] ?? 0) as num;
    final model = chat['llm_model'] as Map<String, dynamic>?;
    final modelName = model?['display_name']?.toString() ?? model?['model_id']?.toString() ?? '-';
    final cost = (chat['total_cost_usd'] as num?)?.toDouble() ?? 0;
    final createdAt = chat['created_at']?.toString() ?? '';
    final lastMsg = chat['last_message_at']?.toString() ?? '';

    return PosCard(
      onTap: () => _showChatDetail(chat['id']?.toString() ?? '', title, l10n),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
              child: const Icon(Icons.chat_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleSmall.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$modelName • ${messageCount.toInt()} ${l10n.messages} • \$${cost.toStringAsFixed(4)}',
                    style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            Text(
              _fmtDate(lastMsg.isNotEmpty ? lastMsg : createdAt),
              style: AppTypography.bodySmall.copyWith(color: AppColors.mutedFor(context)),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatDetail(String chatId, String title, AppLocalizations l10n) {
    ref.read(wameedAIAdminChatDetailProvider.notifier).load(chatId);
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final detailState = ref.watch(wameedAIAdminChatDetailProvider);
          return AlertDialog(
            title: Text(title, style: AppTypography.titleMedium),
            content: SizedBox(
              width: 600,
              height: 500,
              child: switch (detailState) {
                WameedAIAdminDetailLoading() => const Center(child: PosLoading()),
                WameedAIAdminDetailLoaded(data: final resp) => _buildChatMessages(resp, l10n),
                WameedAIAdminDetailError(message: final msg) => Center(child: Text(msg)),
                _ => const Center(child: PosLoading()),
              },
            ),
            actions: [PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.close)],
          );
        },
      ),
    );
  }

  Widget _buildChatMessages(Map<String, dynamic> resp, AppLocalizations l10n) {
    final data = resp['data'] as Map<String, dynamic>? ?? resp;
    final messages = (data['messages'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return ListView.separated(
      itemCount: messages.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, i) {
        final msg = messages[i];
        final role = msg['role']?.toString() ?? '';
        final content = msg['content']?.toString() ?? '';
        final isUser = role == 'user';

        return Align(
          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: isUser ? AppColors.primary.withValues(alpha: 0.1) : AppColors.surfaceFor(context),
              borderRadius: AppRadius.borderLg,
              border: Border.all(color: isUser ? AppColors.primary.withValues(alpha: 0.3) : AppColors.borderFor(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.toUpperCase(),
                  style: AppTypography.micro.copyWith(color: AppColors.mutedFor(context), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                SelectableText(content, style: AppTypography.bodySmall),
              ],
            ),
          ),
        );
      },
    );
  }

  String _fmtDate(String v) => v.length >= 16 ? v.substring(0, 16).replaceAll('T', ' ') : v;
  String _fmtLargeNumber(dynamic v) {
    final n = (v as num?)?.toInt() ?? 0;
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}
