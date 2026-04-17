import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/wameed_ai/data/ai_chat_repository.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';
import 'package:wameedpos/features/wameed_ai/providers/ai_chat_state.dart';

String _extractError(DioException e) {
  final data = e.response?.data;
  if (data is Map<String, dynamic>) {
    return data['message'] as String? ?? e.message ?? 'Unknown error';
  }
  return e.message ?? 'Unknown error';
}

// ─── Chat List Provider ─────────────────────────────────────────

final aiChatListProvider = StateNotifierProvider<AIChatListNotifier, AIChatListState>((ref) {
  return AIChatListNotifier(ref.watch(aiChatRepositoryProvider));
});

class AIChatListNotifier extends StateNotifier<AIChatListState> {
  final AIChatRepository _repo;

  AIChatListNotifier(this._repo) : super(const AIChatListInitial());

  Future<void> load() async {
    state = const AIChatListLoading();
    try {
      final chats = await _repo.listChats();
      state = AIChatListLoaded(chats: chats);
    } on DioException catch (e) {
      state = AIChatListError(message: _extractError(e));
    } catch (e) {
      state = AIChatListError(message: e.toString());
    }
  }

  Future<AIChat?> createChat({String? llmModelId, String? title}) async {
    try {
      final chat = await _repo.createChat(llmModelId: llmModelId, title: title);
      // Reload list to include new chat
      await load();
      return chat;
    } on DioException catch (e) {
      state = AIChatListError(message: _extractError(e));
      return null;
    }
  }

  Future<void> deleteChat(String chatId) async {
    try {
      await _repo.deleteChat(chatId);
      await load();
    } on DioException catch (e) {
      state = AIChatListError(message: _extractError(e));
    }
  }
}

// ─── Active Chat Provider ───────────────────────────────────────

final aiActiveChatProvider = StateNotifierProvider<AIChatNotifier, AIChatState>((ref) {
  return AIChatNotifier(ref.watch(aiChatRepositoryProvider));
});

class AIChatNotifier extends StateNotifier<AIChatState> {
  final AIChatRepository _repo;

  AIChatNotifier(this._repo) : super(const AIChatInitial());

  Future<void> loadChat(String chatId) async {
    state = const AIChatLoading();
    try {
      final chat = await _repo.getChat(chatId);
      state = AIChatLoaded(chat: chat);
    } on DioException catch (e) {
      state = AIChatError(message: _extractError(e));
    } catch (e) {
      state = AIChatError(message: e.toString());
    }
  }

  void setChat(AIChat chat) {
    state = AIChatLoaded(chat: chat);
  }

  /// Reset to the initial empty state — used when starting a fresh chat
  /// from the sidebar / new-chat button before any message is sent.
  void reset() {
    state = const AIChatInitial();
  }

  Future<void> sendMessage({
    required String message,
    String? featureSlug,
    Map<String, dynamic>? featureData,
    String? imageBase64,
  }) async {
    final currentState = state;
    if (currentState is! AIChatLoaded) return;

    // Optimistically add user message to UI
    final tempUserMsg = AIChatMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      chatId: currentState.chat.id,
      role: 'user',
      content: message,
      featureSlug: featureSlug,
      createdAt: DateTime.now(),
    );

    final updatedMessages = [...currentState.chat.messages, tempUserMsg];
    state = AIChatLoaded(chat: currentState.chat.copyWith(messages: updatedMessages), isSending: true);

    try {
      final result = await _repo.sendMessage(
        chatId: currentState.chat.id,
        message: message,
        featureSlug: featureSlug,
        featureData: featureData,
        imageBase64: imageBase64,
      );

      final newMessages = result['messages'] as List<AIChatMessage>;
      final updatedChat = result['chat'] as AIChat;

      // Replace temp message with real messages and add assistant response
      final allMessages = [...currentState.chat.messages, ...newMessages];

      state = AIChatLoaded(chat: updatedChat.copyWith(messages: allMessages), isSending: false);
    } on DioException catch (e) {
      // Keep state as AIChatLoaded to avoid page navigation issues — surface error inline
      state = AIChatLoaded(chat: currentState.chat, isSending: false, errorMessage: _extractError(e));
    } catch (e) {
      state = AIChatLoaded(chat: currentState.chat, isSending: false, errorMessage: e.toString());
    }
  }

  Future<void> invokeFeature({required String featureSlug, Map<String, dynamic>? params}) async {
    final currentState = state;
    if (currentState is! AIChatLoaded) return;

    state = AIChatLoaded(chat: currentState.chat, isSending: true);

    try {
      final result = await _repo.invokeFeatureInChat(chatId: currentState.chat.id, featureSlug: featureSlug, params: params);

      final newMessages = result['messages'] as List<AIChatMessage>;
      final updatedChat = result['chat'] as AIChat;

      final allMessages = [...currentState.chat.messages, ...newMessages];

      state = AIChatLoaded(chat: updatedChat.copyWith(messages: allMessages), isSending: false);
    } on DioException catch (e) {
      state = AIChatLoaded(chat: currentState.chat, isSending: false, errorMessage: _extractError(e));
    }
  }

  Future<void> changeModel(String llmModelId) async {
    final currentState = state;
    if (currentState is! AIChatLoaded) return;

    try {
      final updatedChat = await _repo.changeModel(chatId: currentState.chat.id, llmModelId: llmModelId);
      state = AIChatLoaded(chat: updatedChat.copyWith(messages: currentState.chat.messages));
    } on DioException catch (e) {
      state = AIChatLoaded(chat: currentState.chat, errorMessage: _extractError(e));
    }
  }

  Future<void> renameChat(String title) async {
    final currentState = state;
    if (currentState is! AIChatLoaded) return;

    // Optimistic update
    state = AIChatLoaded(chat: currentState.chat.copyWith(title: title));

    try {
      final updatedChat = await _repo.renameChat(chatId: currentState.chat.id, title: title);
      state = AIChatLoaded(chat: updatedChat.copyWith(messages: currentState.chat.messages));
    } on DioException {
      // Revert on failure
      state = AIChatLoaded(chat: currentState.chat);
    }
  }
}

// ─── LLM Models Provider ───────────────────────────────────────

final aiModelsProvider = StateNotifierProvider<AIModelsNotifier, AIModelsState>((ref) {
  return AIModelsNotifier(ref.watch(aiChatRepositoryProvider));
});

class AIModelsNotifier extends StateNotifier<AIModelsState> {
  final AIChatRepository _repo;

  AIModelsNotifier(this._repo) : super(const AIModelsInitial());

  Future<void> load() async {
    state = const AIModelsLoading();
    try {
      final models = await _repo.getAvailableModels();
      state = AIModelsLoaded(models: models);
    } on DioException catch (e) {
      state = AIModelsError(message: _extractError(e));
    } catch (e) {
      state = AIModelsError(message: e.toString());
    }
  }
}

// ─── Feature Cards Provider ─────────────────────────────────────

final aiFeatureCardsProvider = StateNotifierProvider<AIFeatureCardsNotifier, AIFeatureCardsState>((ref) {
  return AIFeatureCardsNotifier(ref.watch(aiChatRepositoryProvider));
});

class AIFeatureCardsNotifier extends StateNotifier<AIFeatureCardsState> {
  final AIChatRepository _repo;

  AIFeatureCardsNotifier(this._repo) : super(const AIFeatureCardsInitial());

  Future<void> load() async {
    state = const AIFeatureCardsLoading();
    try {
      final categories = await _repo.getFeatureCards();
      state = AIFeatureCardsLoaded(categories: categories);
    } on DioException catch (e) {
      state = AIFeatureCardsError(message: _extractError(e));
    } catch (e) {
      state = AIFeatureCardsError(message: e.toString());
    }
  }
}
