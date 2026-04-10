import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_usage.dart';

final wameedAIApiServiceProvider = Provider<WameedAIApiService>((ref) {
  return WameedAIApiService(ref.watch(dioClientProvider));
});

class WameedAIApiService {
  final Dio _dio;

  WameedAIApiService(this._dio);

  // ─── Features & Config ────────────────────────────────────────

  Future<List<AIFeatureDefinition>> getFeatures() async {
    final response = await _dio.get(ApiEndpoints.wameedAIFeatures);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => AIFeatureDefinition.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<List<AIStoreFeatureConfig>> getStoreConfig() async {
    final response = await _dio.get(ApiEndpoints.wameedAIStoreConfig);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => AIStoreFeatureConfig.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<AIStoreFeatureConfig> updateStoreConfig(String featureId, Map<String, dynamic> data) async {
    final response = await _dio.put('${ApiEndpoints.wameedAIStoreConfig}/$featureId', data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIStoreFeatureConfig.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Suggestions ──────────────────────────────────────────────

  Future<PaginatedResult<AISuggestion>> getSuggestions({int page = 1, int perPage = 20, String? featureSlug, String? status}) async {
    final response = await _dio.get(
      ApiEndpoints.wameedAISuggestions,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (featureSlug != null) 'feature': featureSlug,
        if (status != null) 'status': status,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => AISuggestion.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<AISuggestion> updateSuggestionStatus(String suggestionId, String status) async {
    final response = await _dio.patch(
      '${ApiEndpoints.wameedAISuggestions}/$suggestionId/status',
      data: {'status': status},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AISuggestion.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Feedback ─────────────────────────────────────────────────

  Future<AIFeedback> submitFeedback(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.wameedAIFeedback, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (d) => d);
    return AIFeedback.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Usage ────────────────────────────────────────────────────

  Future<AIUsageSummary> getUsage() async {
    final response = await _dio.get(ApiEndpoints.wameedAIUsage);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AIUsageSummary.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<AIDailyUsage>> getUsageHistory({String? featureSlug, String? from, String? to}) async {
    final response = await _dio.get(
      '${ApiEndpoints.wameedAIUsage}/history',
      queryParameters: {
        if (featureSlug != null) 'feature': featureSlug,
        if (from != null) 'from': from,
        if (to != null) 'to': to,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => AIDailyUsage.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── AI Features ──────────────────────────────────────────────

  Future<AIFeatureResult> invokeFeature(String endpoint, {Map<String, dynamic>? data, Map<String, dynamic>? queryParams}) async {
    final response = await _dio.post(
      endpoint,
      data: data ?? {},
      queryParameters: queryParams,
    );
    return AIFeatureResult.fromJson(response.data as Map<String, dynamic>);
  }

  // ── Inventory
  Future<AIFeatureResult> smartReorder() => invokeFeature(ApiEndpoints.wameedAISmartReorder);
  Future<AIFeatureResult> expiryManager() => invokeFeature(ApiEndpoints.wameedAIExpiryManager);
  Future<AIFeatureResult> deadStock() => invokeFeature(ApiEndpoints.wameedAIDeadStock);
  Future<AIFeatureResult> shrinkageDetection() => invokeFeature(ApiEndpoints.wameedAIShrinkageDetection);
  Future<AIFeatureResult> supplierAnalysis() => invokeFeature(ApiEndpoints.wameedAISupplierAnalysis);
  Future<AIFeatureResult> seasonalPlanning() => invokeFeature(ApiEndpoints.wameedAISeasonalPlanning);

  // ── Sales
  Future<AIFeatureResult> dailySummary() => invokeFeature(ApiEndpoints.wameedAIDailySummary);
  Future<AIFeatureResult> salesForecast({int days = 7}) => invokeFeature(ApiEndpoints.wameedAISalesForecast, queryParams: {'days': days});
  Future<AIFeatureResult> peakHours() => invokeFeature(ApiEndpoints.wameedAIPeakHours);
  Future<AIFeatureResult> pricingOptimization() => invokeFeature(ApiEndpoints.wameedAIPricingOptimization);
  Future<AIFeatureResult> bundleSuggestions() => invokeFeature(ApiEndpoints.wameedAIBundleSuggestions);
  Future<AIFeatureResult> revenueAnomaly() => invokeFeature(ApiEndpoints.wameedAIRevenueAnomaly);

  // ── Catalog
  Future<AIFeatureResult> productCategorization() => invokeFeature(ApiEndpoints.wameedAIProductCategorization);
  Future<AIFeatureResult> invoiceOCR(String imageBase64) => invokeFeature(ApiEndpoints.wameedAIInvoiceOCR, data: {'image': imageBase64});
  Future<AIFeatureResult> productDescription(String productId, {String tone = 'professional', String language = 'both'}) =>
      invokeFeature(ApiEndpoints.wameedAIProductDescription, data: {'product_id': productId, 'tone': tone, 'language': language});
  Future<AIFeatureResult> barcodeEnrichment(String barcode) => invokeFeature(ApiEndpoints.wameedAIBarcodeEnrichment, data: {'barcode': barcode});

  // ── Customer Intelligence
  Future<AIFeatureResult> customerSegmentation() => invokeFeature(ApiEndpoints.wameedAICustomerSegmentation);
  Future<AIFeatureResult> churnPrediction() => invokeFeature(ApiEndpoints.wameedAIChurnPrediction);
  Future<AIFeatureResult> personalizedPromotions({String? segment}) =>
      invokeFeature(ApiEndpoints.wameedAIPersonalizedPromotions, queryParams: segment != null ? {'segment': segment} : null);
  Future<AIFeatureResult> spendingPatterns(String customerId) =>
      invokeFeature(ApiEndpoints.wameedAISpendingPatterns, data: {'customer_id': customerId});
  Future<AIFeatureResult> sentimentAnalysis() => invokeFeature(ApiEndpoints.wameedAISentimentAnalysis);

  // ── Operations
  Future<AIFeatureResult> smartSearch(String query) => invokeFeature(ApiEndpoints.wameedAISmartSearch, data: {'query': query});
  Future<AIFeatureResult> staffPerformance() => invokeFeature(ApiEndpoints.wameedAIStaffPerformance);
  Future<AIFeatureResult> cashierErrors() => invokeFeature(ApiEndpoints.wameedAICashierErrors);
  Future<AIFeatureResult> efficiencyScore() => invokeFeature(ApiEndpoints.wameedAIEfficiencyScore);

  // ── Communication
  Future<AIFeatureResult> marketingGenerator(String type, Map<String, dynamic> context) =>
      invokeFeature(ApiEndpoints.wameedAIMarketingGenerator, data: {'type': type, 'context': context});
  Future<AIFeatureResult> socialContent(String platform, String topic, {List<String>? productIds}) =>
      invokeFeature(ApiEndpoints.wameedAISocialContent, data: {'platform': platform, 'topic': topic, if (productIds != null) 'product_ids': productIds});
  Future<AIFeatureResult> translate(List<String> texts, {String from = 'ar', String to = 'en'}) =>
      invokeFeature(ApiEndpoints.wameedAITranslation, data: {'texts': texts, 'from': from, 'to': to});

  // ── Financial
  Future<AIFeatureResult> marginAnalyzer() => invokeFeature(ApiEndpoints.wameedAIMarginAnalyzer);
  Future<AIFeatureResult> expenseAnalysis() => invokeFeature(ApiEndpoints.wameedAIExpenseAnalysis);
  Future<AIFeatureResult> cashFlowPrediction({int days = 30}) =>
      invokeFeature(ApiEndpoints.wameedAICashFlowPrediction, queryParams: {'days': days});
}
