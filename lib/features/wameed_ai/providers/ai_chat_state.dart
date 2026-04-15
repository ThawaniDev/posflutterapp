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
  final List<AIChat> chats;
  const AIChatListLoaded({required this.chats});
}

class AIChatListError extends AIChatListState {
  final String message;
  const AIChatListError({required this.message});
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
  final AIChat chat;
  final bool isSending;
  final String? errorMessage;
  const AIChatLoaded({required this.chat, this.isSending = false, this.errorMessage});
}

class AIChatError extends AIChatState {
  final String message;
  const AIChatError({required this.message});
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
  final List<LlmModel> models;
  const AIModelsLoaded({required this.models});
}

class AIModelsError extends AIModelsState {
  final String message;
  const AIModelsError({required this.message});
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
  final List<Map<String, dynamic>> categories;
  const AIFeatureCardsLoaded({required this.categories});
}

class AIFeatureCardsError extends AIFeatureCardsState {
  final String message;
  const AIFeatureCardsError({required this.message});
}
