import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/widgets/responsive_layout.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_state.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_params.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_feature_input_panel.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_feature_overlay.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_model_selector.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_message_bubble.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';

class AIChatPage extends ConsumerStatefulWidget {
  final String? chatId;

  const AIChatPage({super.key, this.chatId});

  @override
  ConsumerState<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends ConsumerState<AIChatPage> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  String? _imageBase64;
  String? _imageName;
  bool _showScrollToBottom = false;

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
    super.dispose();
  }

  void _onScrollChanged() {
    if (!_scrollController.hasClients) return;
    final distanceFromBottom = _scrollController.position.maxScrollExtent - _scrollController.offset;
    final shouldShow = distanceFromBottom > 200;
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

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
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
      // Create a new chat first, then send message
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
        _imageName = image.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiActiveChatProvider);
    final modelsState = ref.watch(aiModelsProvider);
    final theme = Theme.of(context);
    final isNewChat = chatState is! AIChatLoaded || (chatState).chat.messages.isEmpty;

    // Show error message as snackbar when present
    ref.listen<AIChatState>(aiActiveChatProvider, (prev, next) {
      if (next is AIChatLoaded && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next.errorMessage!), backgroundColor: AppColors.error));
      }
    });

    // Auto-scroll when messages change
    if (chatState is AIChatLoaded) {
      _scrollToBottom();
    }

    final l10n = AppLocalizations.of(context)!;

    return PosListPage(
      title: chatState is AIChatLoaded ? chatState.chat.title : l10n.wameedAI,
      showSearch: false,
      actions: [
        if (chatState is AIChatLoaded)
          PosButton.icon(
            icon: Icons.edit_outlined,
            tooltip: l10n.commonEdit,
            onPressed: () => _showRenameDialog(chatState.chat.title),
          ),
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
      child: Column(
        children: [
          // ─── Messages Area ───
          Expanded(
            child: Stack(
              children: [
                isNewChat ? _buildWelcomeView(theme) : _buildMessageList(chatState, theme),
                // Scroll-to-bottom FAB
                if (_showScrollToBottom && !isNewChat)
                  Positioned(
                    right: 16,
                    bottom: 8,
                    child: FloatingActionButton.small(
                      onPressed: _scrollToBottom,
                      backgroundColor: theme.cardColor,
                      elevation: 4,
                      child: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
                    ),
                  ),
              ],
            ),
          ),

          // ─── Feature Input Panel ───
          if (_pendingFeatureConfig != null)
            AIFeatureInputPanel(
              featureSlug: _pendingFeatureSlug!,
              featureName: _pendingFeatureName!,
              config: _pendingFeatureConfig!,
              onSubmit: (params, prompt, imageBase64) => _submitFeature(params, prompt, imageBase64),
              onDismiss: _clearPendingFeature,
            ),

          // ─── Image Preview ───
          if (_imageBase64 != null && _pendingFeatureConfig == null) _buildImagePreview(theme),

          // ─── Input Area ───
          if (_pendingFeatureConfig == null) _buildInputBar(chatState, theme),
        ],
      ),
    );
  }

  Widget _buildWelcomeView(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withValues(alpha: 0.1), AppColors.primary.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, size: 48, color: AppColors.primary),
            ),
            AppSpacing.gapH24,
            Text(
              l10n.wameedAI,
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
            AppSpacing.gapH8,
            Text(l10n.wameedAITagline, style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor)),
            AppSpacing.gapH32,
            _buildFeatureCardsGrid(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCardsGrid(ThemeData theme) {
    final cardsState = ref.watch(aiFeatureCardsProvider);

    if (cardsState is! AIFeatureCardsLoaded) {
      return const SizedBox.shrink();
    }

    // Flatten all features into a single list for the initial view cards
    final allFeatures = <AIFeatureCard>[];
    for (final category in cardsState.categories) {
      final features = category['features'] as List<dynamic>? ?? [];
      for (final f in features) {
        allFeatures.add(AIFeatureCard.fromJson(f as Map<String, dynamic>));
      }
    }

    // Show first 8 features as quick-start cards
    final displayFeatures = allFeatures.take(8).toList();

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: displayFeatures.map((feature) {
        return _buildQuickStartCard(feature, theme);
      }).toList(),
    );
  }

  Widget _buildQuickStartCard(AIFeatureCard feature, ThemeData theme) {
    final isMobile = context.isPhone;
    return InkWell(
      onTap: () => _onFeatureSelected(feature.slug, feature.displayName),
      borderRadius: AppRadius.borderLg,
      child: Container(
        width: isMobile ? (MediaQuery.sizeOf(context).width - 68) / 2 : 180,
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 14, vertical: isMobile ? 10 : 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: AppRadius.borderLg,
          // border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon(_categoryIcon(feature.category), size: 20, color: AppColors.primary),
            // AppSpacing.gapH8,
            Text(
              feature.displayName + '\n',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
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
          // Typing indicator
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: AppRadius.borderXl,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
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

  Widget _buildImagePreview(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
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

  Widget _buildInputBar(AIChatState chatState, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final isSending = chatState is AIChatLoaded && chatState.isSending;

    final isMobile = context.isPhone;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      padding: EdgeInsets.only(
        left: isMobile ? AppSpacing.sm : AppSpacing.md,
        right: AppSpacing.sm,
        top: AppSpacing.sm,
        bottom: keyboardVisible ? AppSpacing.sm : bottomPad + (isMobile ? AppSpacing.sm : AppSpacing.lg),
      ),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Feature overlay button
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: isMobile ? 24 : 26),
            color: AppColors.primary,
            onPressed: () => _showFeatureOverlay(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          // Image button
          if (!isMobile)
            IconButton(icon: const Icon(Icons.image_outlined, size: 24), color: theme.hintColor, onPressed: _pickImage),
          SizedBox(width: isMobile ? AppSpacing.xs : 10),
          // Input field
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: isMobile ? 100 : 120),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(isMobile ? 20 : 8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isMobile)
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 4),
                      child: IconButton(
                        icon: const Icon(Icons.image_outlined, size: 20),
                        color: theme.hintColor,
                        onPressed: _pickImage,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      maxLines: null,
                      textInputAction: isMobile ? TextInputAction.send : TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: isMobile ? l10n.wameedAIChatHint : l10n.wameedAIChatHintDesktop,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.md : AppSpacing.base, vertical: 10),
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                      ),
                      onSubmitted: isMobile ? (_) => _sendMessage() : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapW8,
          // Send button
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Container(
              decoration: BoxDecoration(
                color: isSending ? Theme.of(context).disabledColor : AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(isSending ? Icons.hourglass_top : Icons.arrow_upward, color: Colors.white, size: isMobile ? 20 : 22),
                onPressed: isSending ? null : _sendMessage,
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(minWidth: isMobile ? 36 : 44, minHeight: isMobile ? 36 : 44),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFeatureOverlay() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => AIFeatureOverlay(
        onFeatureSelected: (slug, name) {
          Navigator.of(ctx).pop();
          _onFeatureSelected(slug, name);
        },
      ),
    );
  }

  /// Central handler for feature selection — shows input panel if feature has params,
  /// otherwise invokes immediately.
  void _onFeatureSelected(String slug, String name) {
    final config = FeatureInputConfig.featureInputConfigs[slug];
    if (config != null && config.fields.isNotEmpty) {
      // Show the input panel
      setState(() {
        _pendingFeatureSlug = slug;
        _pendingFeatureName = name;
        _pendingFeatureConfig = config;
      });
    } else {
      // No inputs needed — invoke immediately
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
}
