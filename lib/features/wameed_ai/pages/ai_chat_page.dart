import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_params.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_feature_input_panel.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_message_bubble.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_model_selector.dart';

/// ChatGPT-inspired chat page for Wameed AI.
///
/// Layout:
///   - Mobile: minimal top bar (menu, Upgrade pill, profile, new chat),
///     centered welcome area, suggestion chips above input, pill-shaped
///     input with "+" attachment menu (camera/photos/files + features
///     bottom sheet).
///   - Desktop: persistent left sidebar with new-chat, search, chat
///     history grouped by date; main pane with breadcrumb, Upgrade pill,
///     and full-width pill input.
class AIChatPage extends ConsumerStatefulWidget {

  const AIChatPage({super.key, this.chatId});
  final String? chatId;

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  final _searchController = TextEditingController();

  String? _imageBase64;
  String? _imageName;
  bool _showScrollToBottom = false;
  String _sidebarSearch = '';

  // Feature input panel state
  String? _pendingFeatureSlug;
  String? _pendingFeatureName;
  FeatureInputConfig? _pendingFeatureConfig;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollChanged);
    Future.microtask(() {
      ref.read(aiModelsProvider.notifier).load();
      ref.read(aiFeatureCardsProvider.notifier).load();
      ref.read(aiChatListProvider.notifier).load();
      if (widget.chatId != null && widget.chatId != 'new') {
        ref.read(aiActiveChatProvider.notifier).loadChat(widget.chatId!);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_onScrollChanged);
    _scrollController.dispose();
    _focusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ─── Scroll helpers ────────────────────────────────────────────

  void _onScrollChanged() {
    if (!_scrollController.hasClients) return;
    final distance = _scrollController.position.maxScrollExtent - _scrollController.offset;
    final shouldShow = distance > 200;
    if (shouldShow != _showScrollToBottom) {
      setState(() => _showScrollToBottom = shouldShow);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ─── Actions ───────────────────────────────────────────────────

  Future<void> _sendMessage({String? overrideText}) async {
    final text = (overrideText ?? _controller.text).trim();
    if (text.isEmpty) return;

    final chatState = ref.read(aiActiveChatProvider);

    if (chatState is AIChatLoaded) {
      _controller.clear();
      final img = _imageBase64;
      setState(() {
        _imageBase64 = null;
        _imageName = null;
      });
      await ref.read(aiActiveChatProvider.notifier).sendMessage(message: text, imageBase64: img);
      _scrollToBottom();
    } else {
      final chat = await ref.read(aiChatListProvider.notifier).createChat();
      if (chat != null) {
        ref.read(aiActiveChatProvider.notifier).setChat(chat);
        _controller.clear();
        final img = _imageBase64;
        setState(() {
          _imageBase64 = null;
          _imageName = null;
        });
        await ref.read(aiActiveChatProvider.notifier).sendMessage(message: text, imageBase64: img);
        _scrollToBottom();
      }
    }
  }

  Future<void> _pickImage({ImageSource source = ImageSource.gallery}) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, maxWidth: 1024);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
        _imageName = image.name;
      });
    }
  }

  Future<void> _startNewChat() async {
    ref.read(aiActiveChatProvider.notifier).reset();
    _controller.clear();
    setState(() {
      _imageBase64 = null;
      _imageName = null;
      _pendingFeatureSlug = null;
      _pendingFeatureName = null;
      _pendingFeatureConfig = null;
    });
  }

  void _openChat(String chatId) {
    Navigator.of(context).maybePop(); // close drawer if open
    ref.read(aiActiveChatProvider.notifier).loadChat(chatId);
  }

  // ─── Build ─────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = context.isPhone;

    // Snackbar errors
    ref.listen<AIChatState>(aiActiveChatProvider, (prev, next) {
      if (next is AIChatLoaded && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error));
      }
    });

    // Auto-scroll only when a new message arrives or sending toggles —
    // NOT on every rebuild (which would steal control while the user scrolls).
    ref.listen<AIChatState>(aiActiveChatProvider, (prev, next) {
      final prevCount = (prev is AIChatLoaded) ? prev.chat.messages.length : 0;
      final nextCount = (next is AIChatLoaded) ? next.chat.messages.length : 0;
      final prevSending = (prev is AIChatLoaded) ? prev.isSending : false;
      final nextSending = (next is AIChatLoaded) ? next.isSending : false;
      final chatChanged = (prev is AIChatLoaded ? prev.chat.id : null) != (next is AIChatLoaded ? next.chat.id : null);
      if (nextCount > prevCount || nextSending != prevSending || chatChanged) {
        _scrollToBottom();
      }
    });

    if (isMobile) {
      return _buildMobile(theme);
    }
    return _buildDesktop(theme);
  }

  // ─── Mobile layout ─────────────────────────────────────────────

  Widget _buildMobile(ThemeData theme) {
    final chatState = ref.watch(aiActiveChatProvider);
    final isNewChat = chatState is! AIChatLoaded || chatState.chat.messages.isEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: SafeArea(child: _buildSidebar(theme, isMobile: true)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildMobileTopBar(theme),
            Expanded(
              child: Stack(
                children: [
                  isNewChat ? _buildEmptyCenter(theme) : _buildMessageList(chatState, theme),
                  if (_showScrollToBottom && !isNewChat)
                    Positioned(
                      right: 16,
                      bottom: 8,
                      child: FloatingActionButton.small(
                        onPressed: _scrollToBottom,
                        backgroundColor: theme.cardColor,
                        elevation: 4,
                        child: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                      ),
                    ),
                ],
              ),
            ),
            if (_pendingFeatureConfig != null)
              AIFeatureInputPanel(
                featureSlug: _pendingFeatureSlug!,
                featureName: _pendingFeatureName!,
                config: _pendingFeatureConfig!,
                onSubmit: _submitFeature,
                onDismiss: _clearPendingFeature,
              )
            else ...[
              if (isNewChat) _buildSuggestionChips(theme),
              if (_imageBase64 != null) _buildImagePreview(theme),
              _buildPillInput(theme, isMobile: true),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMobileTopBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(ctx).openDrawer(),
              tooltip: AppLocalizations.of(context)!.wameedAIMenu,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: _startNewChat,
            tooltip: AppLocalizations.of(context)!.wameedAINewChat,
          ),
        ],
      ),
    );
  }

  // ─── Desktop layout ────────────────────────────────────────────

  Widget _buildDesktop(ThemeData theme) {
    final chatState = ref.watch(aiActiveChatProvider);
    final isNewChat = chatState is! AIChatLoaded || chatState.chat.messages.isEmpty;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Row(
        children: [
          SizedBox(
            width: 280,
            child: Container(
              decoration: BoxDecoration(
                color: _sidebarColor(theme),
                border: Border(right: BorderSide(color: theme.dividerColor)),
              ),
              child: SafeArea(child: _buildSidebar(theme, isMobile: false)),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                _buildDesktopTopBar(theme, chatState),
                Expanded(
                  child: Stack(
                    children: [
                      isNewChat ? _buildEmptyCenter(theme) : _buildMessageList(chatState, theme),
                      if (_showScrollToBottom && !isNewChat)
                        Positioned(
                          right: 24,
                          bottom: 16,
                          child: FloatingActionButton.small(
                            onPressed: _scrollToBottom,
                            backgroundColor: theme.cardColor,
                            elevation: 4,
                            child: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_pendingFeatureConfig != null)
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 820),
                    child: AIFeatureInputPanel(
                      featureSlug: _pendingFeatureSlug!,
                      featureName: _pendingFeatureName!,
                      config: _pendingFeatureConfig!,
                      onSubmit: _submitFeature,
                      onDismiss: _clearPendingFeature,
                    ),
                  )
                else ...[
                  if (isNewChat) _buildSuggestionChips(theme),
                  if (_imageBase64 != null) _buildImagePreview(theme),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 820),
                      child: _buildPillInput(theme, isMobile: false),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopTopBar(ThemeData theme, AIChatState chatState) {
    final l10n = AppLocalizations.of(context)!;
    final title = chatState is AIChatLoaded ? chatState.chat.title : l10n.wameedAI;
    final modelsState = ref.watch(aiModelsProvider);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          // Breadcrumb-style title
          InkWell(
            onTap: chatState is AIChatLoaded ? () => _showRenameDialog(chatState.chat.title) : null,
            borderRadius: AppRadius.borderMd,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(l10n.wameedAI, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  if (chatState is AIChatLoaded) ...[
                    const SizedBox(width: 6),
                    Icon(Icons.chevron_right, size: 18, color: theme.hintColor),
                    const SizedBox(width: 6),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const Spacer(),
          if (modelsState is AIModelsLoaded)
            AIModelSelector(
              models: modelsState.models,
              selectedModel: chatState is AIChatLoaded ? chatState.chat.llmModel : null,
              onSelected: (model) {
                if (chatState is AIChatLoaded) {
                  ref.read(aiActiveChatProvider.notifier).changeModel(model.id);
                }
              },
            ),
        ],
      ),
    );
  }

  // ─── Sidebar (mobile drawer + desktop pane) ────────────────────

  Widget _buildSidebar(ThemeData theme, {required bool isMobile}) {
    final l10n = AppLocalizations.of(context)!;
    final chatListState = ref.watch(aiChatListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Top row: collapse + new chat
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
          child: Row(
            children: [
              if (isMobile)
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).maybePop())
              else
                const SizedBox(width: 8),
              const Spacer(),
              IconButton(icon: const Icon(Icons.edit_square), tooltip: l10n.wameedAINewChat, onPressed: _startNewChat),
            ],
          ),
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _sidebarSearch = v.trim().toLowerCase()),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.wameedAISearch,
              prefixIcon: Icon(Icons.search, size: 18, color: theme.hintColor),
              isDense: true,
              filled: true,
              fillColor: theme.cardColor,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // "Wameed AI" pinned entry
        _SidebarTile(icon: Icons.auto_awesome, label: l10n.wameedAI, selected: true, onTap: _startNewChat),
        _SidebarTile(
          icon: Icons.apps_outlined,
          label: l10n.wameedAIFeatures,
          trailing: Icon(Icons.chevron_right, size: 18, color: theme.hintColor),
          onTap: _showFeaturesSheet,
        ),
        Divider(color: theme.dividerColor, height: 24),
        // Chat history
        Expanded(child: _buildChatHistoryList(chatListState, theme)),
      ],
    );
  }

  Widget _buildChatHistoryList(AIChatListState state, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    if (state is AIChatListLoading || state is AIChatListInitial) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    if (state is AIChatListError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            state.message,
            style: TextStyle(color: theme.hintColor),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (state is! AIChatListLoaded) return const SizedBox.shrink();

    final chats = state.chats.where((c) {
      if (_sidebarSearch.isEmpty) return true;
      return c.title.toLowerCase().contains(_sidebarSearch);
    }).toList();

    if (chats.isEmpty) {
      return Center(
        child: Text(l10n.wameedAINoChats, style: TextStyle(color: theme.hintColor)),
      );
    }

    final activeId = (ref.watch(aiActiveChatProvider) is AIChatLoaded)
        ? (ref.watch(aiActiveChatProvider) as AIChatLoaded).chat.id
        : null;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: chats.length,
      itemBuilder: (ctx, i) {
        final chat = chats[i];
        return InkWell(
          onTap: () => _openChat(chat.id),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: chat.id == activeId ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
            ),
            child: Text(
              chat.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: chat.id == activeId ? FontWeight.w600 : FontWeight.w400),
            ),
          ),
        );
      },
    );
  }

  // ─── Empty / message views ─────────────────────────────────────

  Widget _buildEmptyCenter(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/wameedlogowhite.png', width: 80, height: 80),
            const SizedBox(height: 20),
            Text(
              l10n.wameedAI,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              l10n.wameedAITagline,
              style: theme.textTheme.titleSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Text(
                l10n.wameedAIWelcomeSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(AIChatLoaded chatState, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final messages = chatState.chat.messages;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length + (chatState.isSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && chatState.isSending) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderXl),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                      ),
                      AppSpacing.gapW8,
                      Text(l10n.wameedAIThinking, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return AIMessageBubble(message: messages[index]);
      },
    );
  }

  // ─── Suggestion chips above input ──────────────────────────────

  Widget _buildSuggestionChips(ThemeData theme) {
    final suggestions = _quickSuggestions(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: SizedBox(
        height: 80,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: suggestions.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (ctx, i) {
            final s = suggestions[i];
            return InkWell(
              onTap: () => _sendMessage(overrideText: s.fullPrompt),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: 220,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      s.title,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<_Suggestion> _quickSuggestions(BuildContext ctx) {
    final l10n = AppLocalizations.of(ctx)!;
    return [
      _Suggestion(
        title: l10n.wameedAISuggTodaySalesTitle,
        subtitle: l10n.wameedAISuggTodaySalesSubtitle,
        fullPrompt: l10n.wameedAISuggTodaySalesPrompt,
      ),
      _Suggestion(
        title: l10n.wameedAISuggReorderTitle,
        subtitle: l10n.wameedAISuggReorderSubtitle,
        fullPrompt: l10n.wameedAISuggReorderPrompt,
      ),
      _Suggestion(
        title: l10n.wameedAISuggSlowMoversTitle,
        subtitle: l10n.wameedAISuggSlowMoversSubtitle,
        fullPrompt: l10n.wameedAISuggSlowMoversPrompt,
      ),
      _Suggestion(
        title: l10n.wameedAISuggSegmentsTitle,
        subtitle: l10n.wameedAISuggSegmentsSubtitle,
        fullPrompt: l10n.wameedAISuggSegmentsPrompt,
      ),
    ];
  }

  // ─── Image preview (above input) ───────────────────────────────

  Widget _buildImagePreview(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.borderMd),
            child: const Icon(Icons.image, color: AppColors.primary),
          ),
          AppSpacing.gapW8,
          Expanded(
            child: Text(
              _imageName ?? l10n.wameedAIImageAttached,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => setState(() {
              _imageBase64 = null;
              _imageName = null;
            }),
          ),
        ],
      ),
    );
  }

  // ─── Pill input ────────────────────────────────────────────────

  Widget _buildPillInput(ThemeData theme, {required bool isMobile}) {
    final l10n = AppLocalizations.of(context)!;
    final chatState = ref.watch(aiActiveChatProvider);
    final isSending = chatState is AIChatLoaded && chatState.isSending;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final hasText = _controller.text.trim().isNotEmpty;

    return Padding(
      padding: EdgeInsets.fromLTRB(12, 8, 12, keyboardVisible ? 8 : (isMobile ? 8 : 16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // "+" button
          _CircleIconButton(
            icon: Icons.add,
            onPressed: _showAttachmentSheet,
            backgroundColor: theme.cardColor,
            iconColor: theme.iconTheme.color,
          ),
          const SizedBox(width: 8),
          // Pill text field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120, minHeight: 48),
              // padding: const EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(28)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  maxLines: null,

                  textInputAction: isMobile ? TextInputAction.newline : TextInputAction.newline,
                  onChanged: (_) => setState(() {}),
                  onSubmitted: isMobile ? (_) => _sendMessage() : null,
                  onTapOutside: (_) => _focusNode.unfocus(),

                  decoration: InputDecoration(
                    hintText: isMobile ? l10n.wameedAIChatHint : l10n.wameedAIChatHintDesktop,
                    border: InputBorder.none,
                    isCollapsed: true,
                    // contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Send button
          _CircleIconButton(
            icon: Icons.arrow_upward,
            onPressed: (isSending || !hasText) ? null : _sendMessage,
            backgroundColor: hasText ? AppColors.primary : theme.cardColor,
            iconColor: hasText ? Colors.white : theme.hintColor,
            size: 44,
          ),
        ],
      ),
    );
  }

  // ─── "+" attachment bottom sheet ───────────────────────────────

  void _showAttachmentSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        final theme = Theme.of(ctx);
        final l10n = AppLocalizations.of(ctx)!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: theme.hintColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Camera / Photos / Files
                Row(
                  children: [
                    Expanded(
                      child: _AttachmentTile(
                        icon: Icons.photo_camera_outlined,
                        label: l10n.wameedAICamera,
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(source: ImageSource.camera);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AttachmentTile(
                        icon: Icons.image_outlined,
                        label: l10n.wameedAIPhotos,
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(source: ImageSource.gallery);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AttachmentTile(
                        icon: Icons.attach_file_outlined,
                        label: l10n.wameedAIFiles,
                        onTap: () {
                          Navigator.pop(ctx);
                          _pickImage(source: ImageSource.gallery);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Divider(color: theme.dividerColor, height: 1),
                const SizedBox(height: 8),
                // Wameed AI feature rows
                _ActionRow(
                  icon: Icons.auto_awesome,
                  title: l10n.wameedAIFeatures,
                  subtitle: l10n.wameedAIBrowseCapabilities,
                  onTap: () {
                    Navigator.pop(ctx);
                    _showFeaturesSheet();
                  },
                ),
                _ActionRow(
                  icon: Icons.summarize_outlined,
                  title: l10n.wameedAITodaySummary,
                  subtitle: l10n.wameedAITodaySummarySubtitle,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.wameedAIDailySummary);
                  },
                ),
                _ActionRow(
                  icon: Icons.shopping_cart_outlined,
                  title: l10n.wameedAISmartReorder,
                  subtitle: l10n.wameedAISmartReorderSubtitle,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.wameedAISmartReorder);
                  },
                ),
                _ActionRow(
                  icon: Icons.groups_outlined,
                  title: l10n.wameedAICustomerSegments,
                  subtitle: l10n.wameedAICustomerSegmentsSubtitle,
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.wameedAICustomerSegments);
                  },
                ),
                _ActionRow(
                  icon: Icons.receipt_long_outlined,
                  title: l10n.wameedAIInvoiceOCR,
                  subtitle: l10n.wameedAIInvoiceOCRSubtitle,
                  trailing: Icon(Icons.chevron_right, color: theme.hintColor),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.wameedAIInvoiceOCR);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Features bottom sheet (full feature catalog) ──────────────

  void _showFeaturesSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return _FeaturesBottomSheet(
          onFeatureSelected: (slug, name) {
            Navigator.pop(ctx);
            _onFeatureSelected(slug, name);
          },
        );
      },
    );
  }

  // ─── Feature flow ──────────────────────────────────────────────

  void _onFeatureSelected(String slug, String name) {
    final config = FeatureInputConfig.featureInputConfigs[slug];
    if (config != null && config.fields.isNotEmpty) {
      setState(() {
        _pendingFeatureSlug = slug;
        _pendingFeatureName = name;
        _pendingFeatureConfig = config;
      });
    } else {
      _invokeFeatureDirectly(slug, name);
    }
  }

  Future<void> _invokeFeatureDirectly(String slug, String name) async {
    final chatState = ref.read(aiActiveChatProvider);
    if (chatState is! AIChatLoaded) {
      final chat = await ref.read(aiChatListProvider.notifier).createChat(title: name);
      if (chat != null) {
        ref.read(aiActiveChatProvider.notifier).setChat(chat);
        await ref.read(aiActiveChatProvider.notifier).sendMessage(message: 'Run $name analysis for my store', featureSlug: slug);
      }
    } else {
      await ref.read(aiActiveChatProvider.notifier).sendMessage(message: 'Run $name analysis for my store', featureSlug: slug);
    }
    _scrollToBottom();
  }

  Future<void> _submitFeature(Map<String, dynamic> params, String prompt, String? imageBase64) async {
    final slug = _pendingFeatureSlug!;
    final name = _pendingFeatureName!;
    _clearPendingFeature();

    final chatState = ref.read(aiActiveChatProvider);
    if (chatState is! AIChatLoaded) {
      final chat = await ref.read(aiChatListProvider.notifier).createChat(title: name);
      if (chat != null) {
        ref.read(aiActiveChatProvider.notifier).setChat(chat);
        await ref
            .read(aiActiveChatProvider.notifier)
            .sendMessage(message: prompt, featureSlug: slug, featureData: params, imageBase64: imageBase64);
      }
    } else {
      await ref
          .read(aiActiveChatProvider.notifier)
          .sendMessage(message: prompt, featureSlug: slug, featureData: params, imageBase64: imageBase64);
    }
    _scrollToBottom();
  }

  void _clearPendingFeature() {
    setState(() {
      _pendingFeatureSlug = null;
      _pendingFeatureName = null;
      _pendingFeatureConfig = null;
    });
  }

  // ─── Rename dialog (preserved from previous design) ────────────

  void _showRenameDialog(String currentTitle) {
    final l10n = AppLocalizations.of(context)!;
    final renameController = TextEditingController(text: currentTitle);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.wameedAIRenameChat),
        content: TextField(
          controller: renameController,
          autofocus: true,
          maxLength: 255,
          decoration: InputDecoration(hintText: l10n.wameedAIEnterChatTitle),
          onSubmitted: (value) {
            final title = value.trim();
            if (title.isNotEmpty) {
              ref.read(aiActiveChatProvider.notifier).renameChat(title);
              ref.read(aiChatListProvider.notifier).load();
            }
            Navigator.of(ctx).pop();
          },
        ),
        actions: [
          PosButton(onPressed: () => Navigator.of(ctx).pop(), variant: PosButtonVariant.ghost, label: l10n.commonCancel),
          PosButton(
            onPressed: () {
              final title = renameController.text.trim();
              if (title.isNotEmpty) {
                ref.read(aiActiveChatProvider.notifier).renameChat(title);
                ref.read(aiChatListProvider.notifier).load();
              }
              Navigator.of(ctx).pop();
            },
            variant: PosButtonVariant.ghost,
            label: l10n.commonRename,
          ),
        ],
      ),
    ).then((_) => renameController.dispose());
  }

  // ─── Sidebar background tint ───────────────────────────────────

  Color _sidebarColor(ThemeData theme) {
    return theme.brightness == Brightness.dark ? theme.scaffoldBackgroundColor : theme.cardColor.withValues(alpha: 0.5);
  }
}

// ─────────────────────────────────────────────────────────────────
// ─── Helper widgets ──────────────────────────────────────────────
// ─────────────────────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
    required this.backgroundColor,
    this.iconColor,
    this.size = 44,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? iconColor;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: 22),
        ),
      ),
    );
  }
}

class _SidebarTile extends StatelessWidget {

  const _SidebarTile({required this.icon, required this.label, required this.onTap, this.trailing, this.selected = false});
  final IconData icon;
  final String label;
  final Widget? trailing;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(color: selected ? AppColors.primary.withValues(alpha: 0.10) : Colors.transparent),
        child: Row(
          children: [
            Icon(icon, size: 18, color: selected ? AppColors.primary : theme.iconTheme.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: selected ? FontWeight.w600 : FontWeight.w500),
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {

  const _AttachmentTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 96,
        decoration: BoxDecoration(color: theme.cardColor, borderRadius: BorderRadius.circular(14)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: theme.iconTheme.color),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {

  const _ActionRow({required this.icon, required this.title, required this.subtitle, required this.onTap, this.trailing});
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        child: Row(
          children: [
            SizedBox(width: 36, child: Icon(icon, size: 24, color: theme.iconTheme.color)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

class _Suggestion {
  const _Suggestion({required this.title, required this.subtitle, required this.fullPrompt});
  final String title;
  final String subtitle;
  final String fullPrompt;
}

// ─────────────────────────────────────────────────────────────────
// Features bottom sheet — full catalog from API
// ─────────────────────────────────────────────────────────────────

class _FeaturesBottomSheet extends ConsumerWidget {

  const _FeaturesBottomSheet({required this.onFeatureSelected});
  final void Function(String slug, String displayName) onFeatureSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsState = ref.watch(aiFeatureCardsProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (ctx, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: theme.hintColor.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text(l10n.wameedAIFeatures, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(color: theme.dividerColor, height: 1),
          Expanded(
            child: switch (cardsState) {
              AIFeatureCardsInitial() || AIFeatureCardsLoading() => const Center(child: CircularProgressIndicator()),
              AIFeatureCardsError(:final message) => Center(child: Text(message)),
              AIFeatureCardsLoaded(:final categories) => ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                itemCount: categories.length,
                itemBuilder: (ctx, i) {
                  final category = categories[i];
                  final categoryName = category['name'] as String? ?? '';
                  final features = (category['features'] as List<dynamic>? ?? [])
                      .map((f) => AIFeatureCard.fromJson(f as Map<String, dynamic>))
                      .toList();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                        child: Text(
                          categoryName,
                          style: theme.textTheme.labelLarge?.copyWith(color: theme.hintColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                      ...features.map(
                        (f) => InkWell(
                          onTap: () => onFeatureSelected(f.slug, f.displayName),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.auto_awesome, size: 20, color: AppColors.primary),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.displayName,
                                        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      if (f.description != null) ...[
                                        const SizedBox(height: 2),
                                        Text(f.description!, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}
