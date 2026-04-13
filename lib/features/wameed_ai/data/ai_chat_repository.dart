import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/wameed_ai/data/ai_chat_api_service.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_chat.dart';

final aiChatRepositoryProvider = Provider<AIChatRepository>((ref) {
  return AIChatRepository(ref.watch(aiChatApiServiceProvider));
});

class AIChatRepository {
  final AIChatApiService _api;

  AIChatRepository(this._api);

  Future<List<LlmModel>> getAvailableModels() => _api.getAvailableModels();

  Future<List<Map<String, dynamic>>> getFeatureCards() => _api.getFeatureCards();

  Future<List<AIChat>> listChats({int page = 1, int perPage = 20}) => _api.listChats(page: page, perPage: perPage);

  Future<AIChat> createChat({String? llmModelId, String? title}) => _api.createChat(llmModelId: llmModelId, title: title);

  Future<AIChat> getChat(String chatId) => _api.getChat(chatId);

  Future<void> deleteChat(String chatId) => _api.deleteChat(chatId);

  Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String message,
    String? featureSlug,
    Map<String, dynamic>? featureData,
    String? imageBase64,
  }) => _api.sendMessage(
    chatId: chatId,
    message: message,
    featureSlug: featureSlug,
    featureData: featureData,
    imageBase64: imageBase64,
  );

  Future<Map<String, dynamic>> invokeFeatureInChat({
    required String chatId,
    required String featureSlug,
    Map<String, dynamic>? params,
  }) => _api.invokeFeatureInChat(chatId: chatId, featureSlug: featureSlug, params: params);

  Future<AIChat> changeModel({required String chatId, required String llmModelId}) =>
      _api.changeModel(chatId: chatId, llmModelId: llmModelId);

  Future<AIChat> renameChat({required String chatId, required String title}) => _api.renameChat(chatId: chatId, title: title);
}
