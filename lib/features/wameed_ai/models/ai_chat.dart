double _toDouble(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0;
}

int _toInt(dynamic v) {
  if (v == null) return 0;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

class LlmModel {
  const LlmModel({
    required this.id,
    required this.provider,
    required this.modelId,
    required this.displayName,
    this.description,
    this.supportsVision = false,
    this.supportsJsonMode = false,
    this.maxContextTokens = 128000,
    this.maxOutputTokens = 4096,
    this.isDefault = false,
  });

  factory LlmModel.fromJson(Map<String, dynamic> json) => LlmModel(
    id: json['id'] as String,
    provider: json['provider'] as String,
    modelId: json['model_id'] as String,
    displayName: json['display_name'] as String,
    description: json['description'] as String?,
    supportsVision: json['supports_vision'] == true,
    supportsJsonMode: json['supports_json_mode'] == true,
    maxContextTokens: json['max_context_tokens'] as int? ?? 128000,
    maxOutputTokens: json['max_output_tokens'] as int? ?? 4096,
    isDefault: json['is_default'] == true,
  );
  final String id;
  final String provider;
  final String modelId;
  final String displayName;
  final String? description;
  final bool supportsVision;
  final bool supportsJsonMode;
  final int maxContextTokens;
  final int maxOutputTokens;
  final bool isDefault;

  String get providerLabel {
    switch (provider) {
      case 'openai':
        return 'OpenAI';
      case 'anthropic':
        return 'Anthropic';
      case 'google':
        return 'Google';
      default:
        return provider;
    }
  }
}

class AIChat {
  const AIChat({
    required this.id,
    required this.organizationId,
    this.storeId,
    required this.userId,
    required this.title,
    this.llmModelId,
    this.llmModel,
    this.messageCount = 0,
    this.totalTokens = 0,
    this.totalCostUsd = 0,
    this.lastMessageAt,
    this.messages = const [],
  });

  factory AIChat.fromJson(Map<String, dynamic> json) => AIChat(
    id: json['id'] as String,
    organizationId: json['organization_id'] as String,
    storeId: json['store_id'] as String?,
    userId: json['user_id'] as String,
    title: json['title'] as String? ?? 'New Chat',
    llmModelId: json['llm_model_id'] as String?,
    llmModel: json['llm_model'] != null ? LlmModel.fromJson(json['llm_model'] as Map<String, dynamic>) : null,
    messageCount: _toInt(json['message_count']),
    totalTokens: _toInt(json['total_tokens']),
    totalCostUsd: _toDouble(json['total_cost_usd']),
    lastMessageAt: json['last_message_at'] != null ? DateTime.tryParse(json['last_message_at'] as String) : null,
    messages: (json['messages'] as List<dynamic>?)?.map((m) => AIChatMessage.fromJson(m as Map<String, dynamic>)).toList() ?? [],
  );
  final String id;
  final String organizationId;
  final String? storeId;
  final String userId;
  final String title;
  final String? llmModelId;
  final LlmModel? llmModel;
  final int messageCount;
  final int totalTokens;
  final double totalCostUsd;
  final DateTime? lastMessageAt;
  final List<AIChatMessage> messages;

  AIChat copyWith({String? title, LlmModel? llmModel, int? messageCount, List<AIChatMessage>? messages}) => AIChat(
    id: id,
    organizationId: organizationId,
    storeId: storeId,
    userId: userId,
    title: title ?? this.title,
    llmModelId: llmModelId,
    llmModel: llmModel ?? this.llmModel,
    messageCount: messageCount ?? this.messageCount,
    totalTokens: totalTokens,
    totalCostUsd: totalCostUsd,
    lastMessageAt: lastMessageAt,
    messages: messages ?? this.messages,
  );
}

class AIChatMessage {
  const AIChatMessage({
    required this.id,
    required this.chatId,
    required this.role,
    required this.content,
    this.featureSlug,
    this.featureData,
    this.attachments,
    this.modelUsed,
    this.inputTokens = 0,
    this.outputTokens = 0,
    this.costUsd = 0,
    this.latencyMs = 0,
    this.createdAt,
  });

  factory AIChatMessage.fromJson(Map<String, dynamic> json) => AIChatMessage(
    id: json['id'] as String,
    chatId: json['chat_id'] as String? ?? '',
    role: json['role'] as String,
    content: json['content'] as String? ?? '',
    featureSlug: json['feature_slug'] as String?,
    featureData: json['feature_data'] as Map<String, dynamic>?,
    attachments: json['attachments'] as List<dynamic>?,
    modelUsed: json['model_used'] as String?,
    inputTokens: _toInt(json['input_tokens']),
    outputTokens: _toInt(json['output_tokens']),
    costUsd: _toDouble(json['cost_usd']),
    latencyMs: _toInt(json['latency_ms']),
    createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'] as String) : null,
  );
  final String id;
  final String chatId;
  final String role; // 'user' | 'assistant'
  final String content;
  final String? featureSlug;
  final Map<String, dynamic>? featureData;
  final List<dynamic>? attachments;
  final String? modelUsed;
  final int inputTokens;
  final int outputTokens;
  final double costUsd;
  final int latencyMs;
  final DateTime? createdAt;

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
}

class AIFeatureCard {
  const AIFeatureCard({
    required this.id,
    required this.slug,
    required this.displayName,
    this.description,
    required this.category,
    this.icon,
  });

  factory AIFeatureCard.fromJson(Map<String, dynamic> json) => AIFeatureCard(
    id: json['id'] as String,
    slug: json['slug'] as String,
    displayName: json['display_name'] as String,
    description: json['description'] as String?,
    category: json['category'] as String,
    icon: json['icon'] as String?,
  );
  final String id;
  final String slug;
  final String displayName;
  final String? description;
  final String category;
  final String? icon;
}
