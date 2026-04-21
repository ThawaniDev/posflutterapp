import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';

// ─── Chat List State ────────────────────────────────────────────

sealed class AIChatListState {
  const AIChatListState();
}

class AIChatListInitial extends AIChatListState {
  const AIChatListInitial();
}

class AIChatListLoading extends AIChatListState {
  const AIChatListLoading();
}

class AIChatListLoaded extends AIChatListState {
  const AIChatListLoaded({required this.chats});
  final List<AIChat> chats;
}

class AIChatListError extends AIChatListState {
  const AIChatListError({required this.message});
  final String message;
}

// ─── Active Chat State ──────────────────────────────────────────

sealed class AIChatState {
  const AIChatState();
}

class AIChatInitial extends AIChatState {
  const AIChatInitial();
}

class AIChatLoading extends AIChatState {
  const AIChatLoading();
}

class AIChatLoaded extends AIChatState {
  const AIChatLoaded({required this.chat, this.isSending = false, this.errorMessage});
  final AIChat chat;
  final bool isSending;
  final String? errorMessage;
}

class AIChatError extends AIChatState {
  const AIChatError({required this.message});
  final String message;
}

// ─── LLM Models State ──────────────────────────────────────────

sealed class AIModelsState {
  const AIModelsState();
}

class AIModelsInitial extends AIModelsState {
  const AIModelsInitial();
}

class AIModelsLoading extends AIModelsState {
  const AIModelsLoading();
}

class AIModelsLoaded extends AIModelsState {
  const AIModelsLoaded({required this.models});
  final List<LlmModel> models;
}

class AIModelsError extends AIModelsState {
  const AIModelsError({required this.message});
  final String message;
}

// ─── Feature Cards State ────────────────────────────────────────

sealed class AIFeatureCardsState {
  const AIFeatureCardsState();
}

class AIFeatureCardsInitial extends AIFeatureCardsState {
  const AIFeatureCardsInitial();
}

class AIFeatureCardsLoading extends AIFeatureCardsState {
  const AIFeatureCardsLoading();
}

class AIFeatureCardsLoaded extends AIFeatureCardsState {
  const AIFeatureCardsLoaded({required this.categories});
  final List<Map<String, dynamic>> categories;
}

class AIFeatureCardsError extends AIFeatureCardsState {
  const AIFeatureCardsError({required this.message});
  final String message;
}
