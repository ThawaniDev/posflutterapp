import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/onboarding/models/business_type.dart';
import 'package:wameedpos/features/onboarding/models/knowledge_base_article.dart';
import 'package:wameedpos/features/onboarding/models/onboarding_progress.dart';

final onboardingApiServiceProvider = Provider<OnboardingApiService>((ref) {
  return OnboardingApiService(ref.watch(dioClientProvider));
});

class OnboardingApiService {
  OnboardingApiService(this._dio);
  final Dio _dio;

  /// GET /core/onboarding/steps
  Future<List<Map<String, dynamic>>> getSteps() async {
    final response = await _dio.get(ApiEndpoints.onboardingSteps);
    final List data = response.data['data'] as List;
    return data.map((j) => Map<String, dynamic>.from(j as Map)).toList();
  }

  /// GET /core/onboarding/progress?store_id=xxx
  Future<OnboardingProgress> getProgress({String? storeId}) async {
    final response = await _dio.get(ApiEndpoints.onboardingProgress, queryParameters: {'store_id': ?storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/complete-step
  Future<OnboardingProgress> completeStep({
    required String storeId,
    required String step,
    Map<String, dynamic> data = const {},
  }) async {
    final response = await _dio.post(
      ApiEndpoints.onboardingCompleteStep,
      data: {'store_id': storeId, 'step': step, 'data': data},
    );
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/skip
  Future<OnboardingProgress> skipWizard(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingSkip, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/checklist
  Future<OnboardingProgress> updateChecklistItem({
    required String storeId,
    required String itemKey,
    required bool completed,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.onboardingChecklist,
      data: {'store_id': storeId, 'item_key': itemKey, 'completed': completed},
    );
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/dismiss-checklist
  Future<OnboardingProgress> dismissChecklist(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingDismissChecklist, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/reset
  Future<OnboardingProgress> resetOnboarding(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingReset, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  // ── Business Type Defaults (public) ─────────────────────────────────────

  /// GET /onboarding/business-types — List active business types for picker
  Future<List<BusinessType>> getBusinessTypesPublic() async {
    final response = await _dio.get(ApiEndpoints.businessTypesPublic);
    final List data = response.data['data'] as List;
    return data.map((j) => BusinessType.fromJson(Map<String, dynamic>.from(j as Map))).toList();
  }

  /// GET /onboarding/business-types/{slug}/defaults — Full defaults bundle
  Future<Map<String, dynamic>> getBusinessTypeDefaults(String slug) async {
    final response = await _dio.get(ApiEndpoints.businessTypeDefaults(slug));
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  /// GET /onboarding/business-types/{slug}/category-templates
  Future<List<Map<String, dynamic>>> getBusinessTypeCategoryTemplates(String slug) async {
    final response = await _dio.get(ApiEndpoints.businessTypeCategoryTemplates(slug));
    final List data = response.data['data'] as List;
    return data.map((j) => Map<String, dynamic>.from(j as Map)).toList();
  }

  /// GET /onboarding/business-types/{slug}/shift-templates
  Future<List<Map<String, dynamic>>> getBusinessTypeShiftTemplates(String slug) async {
    final response = await _dio.get(ApiEndpoints.businessTypeShiftTemplates(slug));
    final List data = response.data['data'] as List;
    return data.map((j) => Map<String, dynamic>.from(j as Map)).toList();
  }

  /// GET /onboarding/business-types/{slug}/loyalty-config
  Future<Map<String, dynamic>?> getBusinessTypeLoyaltyConfig(String slug) async {
    final response = await _dio.get(ApiEndpoints.businessTypeLoyaltyConfig(slug));
    final data = response.data['data'];
    return data != null ? Map<String, dynamic>.from(data as Map) : null;
  }

  /// GET /onboarding/business-types/{slug}/gamification-templates
  Future<Map<String, dynamic>> getBusinessTypeGamificationTemplates(String slug) async {
    final response = await _dio.get(ApiEndpoints.businessTypeGamificationTemplates(slug));
    return Map<String, dynamic>.from(response.data['data'] as Map);
  }

  // ── Help Articles (public) ────────────────────────────────────────────────

  /// GET /help-articles?category=xxx&per_page=N
  Future<Map<String, dynamic>> getHelpArticles({
    String? category,
    String? deliveryPlatformId,
    int perPage = 20,
    int page = 1,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.helpArticles,
      queryParameters: {
        if (category != null) 'category': category,
        if (deliveryPlatformId != null) 'delivery_platform_id': deliveryPlatformId,
        'per_page': perPage,
        'page': page,
      },
    );
    return Map<String, dynamic>.from(response.data as Map);
  }

  /// GET /help-articles/{slug}
  Future<KnowledgeBaseArticle> getHelpArticle(String slug) async {
    final response = await _dio.get(ApiEndpoints.helpArticle(slug));
    return KnowledgeBaseArticle.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
