import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/wameed_ai/data/wameed_ai_api_service.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_billing.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_usage.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';

final wameedAIRepositoryProvider = Provider<WameedAIRepository>((ref) {
  return WameedAIRepository(ref.watch(wameedAIApiServiceProvider));
});

class WameedAIRepository {
  final WameedAIApiService _api;

  WameedAIRepository(this._api);

  // ─── Features & Config ────────────────────────────────────────
  Future<List<AIFeatureDefinition>> getFeatures() => _api.getFeatures();
  Future<List<AIStoreFeatureConfig>> getStoreConfig() => _api.getStoreConfig();
  Future<AIStoreFeatureConfig> updateStoreConfig(String featureId, Map<String, dynamic> data) =>
      _api.updateStoreConfig(featureId, data);

  // ─── Suggestions ──────────────────────────────────────────────
  Future<PaginatedResult<AISuggestion>> getSuggestions({int page = 1, int perPage = 20, String? featureSlug, String? status}) =>
      _api.getSuggestions(page: page, perPage: perPage, featureSlug: featureSlug, status: status);
  Future<AISuggestion> updateSuggestionStatus(String suggestionId, String status) =>
      _api.updateSuggestionStatus(suggestionId, status);

  // ─── Feedback ─────────────────────────────────────────────────
  Future<AIFeedback> submitFeedback(Map<String, dynamic> data) => _api.submitFeedback(data);

  // ─── Usage ────────────────────────────────────────────────────
  Future<AIUsageSummary> getUsage() => _api.getUsage();
  Future<List<AIDailyUsage>> getUsageHistory({String? featureSlug, String? from, String? to}) =>
      _api.getUsageHistory(featureSlug: featureSlug, from: from, to: to);

  // ─── AI Features (grouped by category) ────────────────────────
  Future<AIFeatureResult> invokeFeature(String slug, {Map<String, dynamic>? params}) async {
    switch (slug) {
      // Inventory
      case 'smart_reorder':
        return _api.smartReorder();
      case 'expiry_manager':
        return _api.expiryManager();
      case 'dead_stock':
        return _api.deadStock();
      case 'shrinkage_detection':
        return _api.shrinkageDetection();
      case 'supplier_analysis':
        return _api.supplierAnalysis();
      case 'seasonal_planning':
        return _api.seasonalPlanning();
      // Sales
      case 'daily_summary':
        return _api.dailySummary();
      case 'sales_forecast':
        return _api.salesForecast(days: params?['days'] as int? ?? 7);
      case 'peak_hours':
        return _api.peakHours();
      case 'pricing_optimization':
        return _api.pricingOptimization();
      case 'bundle_suggestions':
        return _api.bundleSuggestions();
      case 'revenue_anomaly':
        return _api.revenueAnomaly();
      // Catalog
      case 'product_categorization':
        return _api.productCategorization();
      case 'invoice_ocr':
        return _api.invoiceOCR(params!['image'] as String);
      case 'product_description':
        return _api.productDescription(
          params!['product_id'] as String,
          tone: params['tone'] as String? ?? 'professional',
          language: params['language'] as String? ?? 'both',
        );
      case 'barcode_enrichment':
        return _api.barcodeEnrichment(params!['barcode'] as String);
      // Customer
      case 'customer_segmentation':
        return _api.customerSegmentation();
      case 'churn_prediction':
        return _api.churnPrediction();
      case 'personalized_promotions':
        return _api.personalizedPromotions(segment: params?['segment'] as String?);
      case 'spending_patterns':
        return _api.spendingPatterns(params!['customer_id'] as String);
      case 'sentiment_analysis':
        return _api.sentimentAnalysis();
      // Operations
      case 'smart_search':
        return _api.smartSearch(params!['query'] as String);
      case 'staff_performance':
        return _api.staffPerformance();
      case 'cashier_errors':
        return _api.cashierErrors();
      case 'efficiency_score':
        return _api.efficiencyScore();
      // Communication
      case 'marketing_generator':
        return _api.marketingGenerator(params!['type'] as String, params['context'] as Map<String, dynamic>);
      case 'social_content':
        return _api.socialContent(
          params!['platform'] as String,
          params['topic'] as String,
          productIds: (params['product_ids'] as List?)?.cast<String>(),
        );
      case 'translation':
        return _api.translate(
          params!['texts'] as List<String>,
          from: params['from'] as String? ?? 'ar',
          to: params['to'] as String? ?? 'en',
        );
      // Financial
      case 'margin_analyzer':
        return _api.marginAnalyzer();
      case 'expense_analysis':
        return _api.expenseAnalysis();
      case 'cashflow_prediction':
        return _api.cashFlowPrediction(days: params?['days'] as int? ?? 30);
      default:
        return AIFeatureResult.error('Unknown feature: $slug');
    }
  }

  // ─── Billing ──────────────────────────────────────────────────
  Future<AIBillingSummary> getBillingSummary() => _api.getBillingSummary();
  Future<PaginatedResult<AIBillingInvoicePreview>> getBillingInvoices({int page = 1, int perPage = 20}) =>
      _api.getBillingInvoices(page: page, perPage: perPage);
  Future<AIBillingInvoiceDetail> getBillingInvoiceDetail(String invoiceId) => _api.getBillingInvoiceDetail(invoiceId);
}
