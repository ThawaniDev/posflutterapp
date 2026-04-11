import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/ai_chat_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_feature_overlay.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_model_selector.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_message_bubble.dart';

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

  @override
  void initState() {
    super.initState();
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
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
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
      await ref.read(aiActiveChatProvider.notifier).sendMessage(
            message: text,
            imageBase64: img,
          );
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
        await ref.read(aiActiveChatProvider.notifier).sendMessage(
              message: text,
              imageBase64: img,
            );
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

    // Auto-scroll when messages change
    if (chatState is AIChatLoaded) {
      _scrollToBottom();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                chatState is AIChatLoaded ? chatState.chat.title : 'Wameed AI',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          // Model selector
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
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ─── Messages Area ───
          Expanded(
            child: isNewChat ? _buildWelcomeView(theme) : _buildMessageList(chatState, theme),
          ),

          // ─── Image Preview ───
          if (_imageBase64 != null) _buildImagePreview(theme),

          // ─── Input Area ───
          _buildInputBar(chatState, theme),
        ],
      ),
    );
  }

  Widget _buildWelcomeView(ThemeData theme) {
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
            const SizedBox(height: 24),
            Text(
              'Wameed AI',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your intelligent business assistant',
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 32),
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
    return InkWell(
      onTap: () async {
        // Create chat and invoke feature
        final chatState = ref.read(aiActiveChatProvider);
        if (chatState is! AIChatLoaded) {
          final chat = await ref.read(aiChatListProvider.notifier).createChat(
                title: feature.displayName,
              );
          if (chat != null) {
            ref.read(aiActiveChatProvider.notifier).setChat(chat);
            await ref.read(aiActiveChatProvider.notifier).sendMessage(
                  message: 'Run ${feature.displayName} analysis for my store',
                  featureSlug: feature.slug,
                );
          }
        } else {
          await ref.read(aiActiveChatProvider.notifier).sendMessage(
                message: 'Run ${feature.displayName} analysis for my store',
                featureSlug: feature.slug,
              );
        }
        _scrollToBottom();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 160,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(_categoryIcon(feature.category), size: 20, color: AppColors.primary),
            const SizedBox(height: 8),
            Text(
              feature.displayName,
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(AIChatLoaded chatState, ThemeData theme) {
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
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Thinking...', style: theme.textTheme.bodySmall?.copyWith(color: AppColors.primary)),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: theme.scaffoldBackgroundColor,
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.image, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _imageName ?? 'Image attached',
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
    final isSending = chatState is AIChatLoaded && chatState.isSending;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
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
            icon: const Icon(Icons.add_circle_outline, size: 26),
            color: AppColors.primary,
            onPressed: () => _showFeatureOverlay(),
          ),
          // Image button
          IconButton(
            icon: const Icon(Icons.image_outlined, size: 24),
            color: theme.hintColor,
            onPressed: _pickImage,
          ),
          // Input field
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Ask Wameed AI anything...',
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 4),
          // Send button
          Container(
            decoration: BoxDecoration(
              color: isSending ? Colors.grey : AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(isSending ? Icons.hourglass_top : Icons.arrow_upward, color: Colors.white, size: 22),
              onPressed: isSending ? null : _sendMessage,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => AIFeatureOverlay(
        onFeatureSelected: (slug, name) async {
          Navigator.of(ctx).pop();
          final chatState = ref.read(aiActiveChatProvider);
          if (chatState is! AIChatLoaded) {
            final chat = await ref.read(aiChatListProvider.notifier).createChat(title: name);
            if (chat != null) {
              ref.read(aiActiveChatProvider.notifier).setChat(chat);
              await ref.read(aiActiveChatProvider.notifier).sendMessage(
                    message: 'Run $name analysis for my store',
                    featureSlug: slug,
                  );
            }
          } else {
            await ref.read(aiActiveChatProvider.notifier).sendMessage(
                  message: 'Run $name analysis for my store',
                  featureSlug: slug,
                );
          }
          _scrollToBottom();
        },
      ),
    );
  }

  IconData _categoryIcon(String category) {
    return switch (category) {
      'inventory' => Icons.inventory_2_outlined,
      'sales' => Icons.trending_up_rounded,
      'operations' => Icons.settings_outlined,
      'catalog' => Icons.category_outlined,
      'customer' => Icons.people_outline,
      'communication' => Icons.campaign_outlined,
      'financial' => Icons.account_balance_wallet_outlined,
      'platform' => Icons.dashboard_outlined,
      _ => Icons.auto_awesome,
    };
  }
}
