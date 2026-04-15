import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_chat.dart';

final aiChatApiServiceProvider = Provider<AIChatApiService>((ref) {
  return AIChatApiService(ref.watch(dioClientProvider));
});

class AIChatApiService {
  final Dio _dio;

  AIChatApiService(this._dio);

  // ─── LLM Models ─────────────────────────────────────────────

  Future<List<LlmModel>> getAvailableModels() async {
    final response = await _dio.get(ApiEndpoints.wameedAIModels);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final modelsData = (apiResponse.data as Map<String, dynamic>)['models'] as List;
    return modelsData.map((j) => LlmModel.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Feature Cards ──────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getFeatureCards() async {
    final response = await _dio.get(ApiEndpoints.wameedAIFeatureCards);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final categories = (apiResponse.data as Map<String, dynamic>)['categories'] as List;
    return categories.cast<Map<String, dynamic>>();
  }

  // ─── Chats ──────────────────────────────────────────────────

  Future<List<AIChat>> listChats({int page = 1, int perPage = 20}) async {
    final response = await _dio.get(ApiEndpoints.wameedAIChats, queryParameters: {'page': page, 'per_page': perPage});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final chatsData = (apiResponse.data as Map<String, dynamic>)['chats'] as List;
    return chatsData.map((j) => AIChat.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<AIChat> createChat({String? llmModelId, String? title}) async {
    final response = await _dio.post(
      ApiEndpoints.wameedAIChats,
      data: {if (llmModelId != null) 'llm_model_id': llmModelId, if (title != null) 'title': title},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIChat.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<AIChat> getChat(String chatId) async {
    final response = await _dio.get(ApiEndpoints.wameedAIChat(chatId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIChat.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteChat(String chatId) async {
    await _dio.delete(ApiEndpoints.wameedAIChat(chatId));
  }

  // ─── Messages ───────────────────────────────────────────────

  Future<Map<String, dynamic>> sendMessage({
    required String chatId,
    required String message,
    String? featureSlug,
    Map<String, dynamic>? featureData,
    String? imageBase64,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.wameedAIChatMessages(chatId),
      data: {
        'message': message,
        if (featureSlug != null) 'feature_slug': featureSlug,
        if (featureData != null) 'feature_data': featureData,
        if (imageBase64 != null) 'image': imageBase64,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return {
      'messages': (data['messages'] as List).map((m) => AIChatMessage.fromJson(m as Map<String, dynamic>)).toList(),
      'chat': AIChat.fromJson(data['chat'] as Map<String, dynamic>),
    };
  }

  Future<Map<String, dynamic>> invokeFeatureInChat({
    required String chatId,
    required String featureSlug,
    Map<String, dynamic>? params,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.wameedAIChatFeature(chatId),
      data: {'feature_slug': featureSlug, if (params != null) 'params': params},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final data = apiResponse.data as Map<String, dynamic>;
    return {
      'messages': (data['messages'] as List).map((m) => AIChatMessage.fromJson(m as Map<String, dynamic>)).toList(),
      'chat': AIChat.fromJson(data['chat'] as Map<String, dynamic>),
    };
  }

  // ─── Model Change ──────────────────────────────────────────

  Future<AIChat> changeModel({required String chatId, required String llmModelId}) async {
    final response = await _dio.put(ApiEndpoints.wameedAIChatModel(chatId), data: {'llm_model_id': llmModelId});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIChat.fromJson(apiResponse.data as Map<String, dynamic>);
  }
  // ─── Rename Chat ───────────────────────────────────────

  Future<AIChat> renameChat({required String chatId, required String title}) async {
    final response = await _dio.put(ApiEndpoints.wameedAIChatTitle(chatId), data: {'title': title});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIChat.fromJson(apiResponse.data as Map<String, dynamic>);
  }
}
