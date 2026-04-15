import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/wameed_ai/enums/ai_feature_category.dart';
import 'package:wameedpos/features/wameed_ai/enums/ai_suggestion_priority.dart';
import 'package:wameedpos/features/wameed_ai/enums/ai_suggestion_status.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:wameedpos/features/wameed_ai/models/ai_usage.dart';

void main() {
  // ─── AIFeatureDefinition ───────────────────────────────────

  group('AIFeatureDefinition', () {
    final json = {
      'id': 'feat-1',
      'slug': 'smart_reorder',
      'name': 'Smart Reorder',
      'name_ar': 'إعادة الطلب الذكي',
      'description': 'AI-powered reorder suggestions',
      'description_ar': 'اقتراحات إعادة الطلب',
      'category': 'inventory',
      'icon': 'inventory_2',
      'default_model': 'gpt-4o-mini',
      'is_enabled': true,
      'is_premium': false,
      'daily_limit': 50,
      'monthly_limit': 500,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson parses all fields', () {
      final feature = AIFeatureDefinition.fromJson(json);
      expect(feature.id, 'feat-1');
      expect(feature.slug, 'smart_reorder');
      expect(feature.name, 'Smart Reorder');
      expect(feature.nameAr, 'إعادة الطلب الذكي');
      expect(feature.description, 'AI-powered reorder suggestions');
      expect(feature.descriptionAr, 'اقتراحات إعادة الطلب');
      expect(feature.category, AIFeatureCategory.inventory);
      expect(feature.icon, 'inventory_2');
      expect(feature.defaultModel, 'gpt-4o-mini');
      expect(feature.isActive, true);
      expect(feature.isPremium, false);
      expect(feature.dailyLimit, 50);
      expect(feature.monthlyLimit, 500);
      expect(feature.createdAt, isNotNull);
      expect(feature.storeConfigs, isNull);
    });

    test('fromJson uses defaults for missing fields', () {
      final minimal = AIFeatureDefinition.fromJson({'id': 'f1', 'slug': 'test', 'name': 'Test', 'category': 'sales'});
      expect(minimal.isActive, true);
      expect(minimal.isPremium, false);
      expect(minimal.dailyLimit, 50);
      expect(minimal.monthlyLimit, 500);
      expect(minimal.sortOrder, 0);
      expect(minimal.nameAr, isNull);
      expect(minimal.description, isNull);
      expect(minimal.icon, isNull);
      expect(minimal.defaultModel, isNull);
    });

    test('fromJson parses store_configs when present', () {
      final withConfig = Map<String, dynamic>.from(json);
      withConfig['store_configs'] = [
        {
          'id': 'cfg-1',
          'store_id': 'store-1',
          'feature_id': 'feat-1',
          'is_enabled': true,
          'daily_limit': 100,
          'monthly_limit': 3000,
        },
      ];
      final feature = AIFeatureDefinition.fromJson(withConfig);
      expect(feature.storeConfigs, isNotNull);
      expect(feature.storeConfigs!.first.isEnabled, true);
      expect(feature.storeConfigs!.first.dailyLimit, 100);
    });

    test('toJson serializes correctly', () {
      final feature = AIFeatureDefinition.fromJson(json);
      final output = feature.toJson();
      expect(output['id'], 'feat-1');
      expect(output['slug'], 'smart_reorder');
      expect(output['category'], 'inventory');
      expect(output['is_enabled'], true);
      expect(output['daily_limit'], 50);
    });

    test('copyWith overrides specific fields', () {
      final feature = AIFeatureDefinition.fromJson(json);
      final copy = feature.copyWith(name: 'Updated', isPremium: true);
      expect(copy.name, 'Updated');
      expect(copy.isPremium, true);
      expect(copy.slug, 'smart_reorder'); // unchanged
      expect(copy.id, 'feat-1'); // unchanged
    });

    test('equality based on id', () {
      final a = AIFeatureDefinition.fromJson(json);
      final b = AIFeatureDefinition.fromJson(json);
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });

    test('all categories parse correctly', () {
      for (final cat in AIFeatureCategory.values) {
        final parsed = AIFeatureCategory.fromValue(cat.value);
        expect(parsed, cat);
      }
    });

    test('invalid category throws', () {
      expect(() => AIFeatureCategory.fromValue('nonexistent'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(AIFeatureCategory.tryFromValue('nonexistent'), isNull);
      expect(AIFeatureCategory.tryFromValue(null), isNull);
    });
  });

  // ─── AIStoreFeatureConfig ─────────────────────────────────

  group('AIStoreFeatureConfig', () {
    test('fromJson parses all fields', () {
      final config = AIStoreFeatureConfig.fromJson({
        'id': 'cfg-1',
        'store_id': 'store-1',
        'feature_id': 'feat-1',
        'is_enabled': false,
        'daily_limit': 200,
        'monthly_limit': 5000,
        'custom_config': {'key': 'value'},
      });
      expect(config.id, 'cfg-1');
      expect(config.storeId, 'store-1');
      expect(config.featureId, 'feat-1');
      expect(config.isEnabled, false);
      expect(config.dailyLimit, 200);
      expect(config.monthlyLimit, 5000);
      expect(config.customConfig, {'key': 'value'});
    });

    test('toJson only includes configurable fields', () {
      final config = AIStoreFeatureConfig(id: 'cfg-1', storeId: 'store-1', featureId: 'feat-1', isEnabled: true, dailyLimit: 100);
      final output = config.toJson();
      expect(output['is_enabled'], true);
      expect(output['daily_limit'], 100);
      expect(output.containsKey('id'), false);
      expect(output.containsKey('store_id'), false);
    });

    test('equality based on id', () {
      final a = AIStoreFeatureConfig(id: 'cfg-1', storeId: 's1', featureId: 'f1');
      final b = AIStoreFeatureConfig(id: 'cfg-1', storeId: 's2', featureId: 'f2');
      expect(a, equals(b));
    });
  });

  // ─── AIFeatureResult ──────────────────────────────────────

  group('AIFeatureResult', () {
    test('fromJson parses success response', () {
      final result = AIFeatureResult.fromJson({
        'success': true,
        'message': 'Analysis complete',
        'data': {
          'suggestions': [
            {'product': 'Rice', 'qty': 100},
          ],
          'cached': true,
          'tokens_used': 500,
          'cost': 0.001,
        },
      });
      expect(result.success, true);
      expect(result.message, 'Analysis complete');
      expect(result.data, isNotNull);
      expect(result.cached, true);
      expect(result.tokensUsed, 500);
      expect(result.cost, 0.001);
    });

    test('fromJson handles missing data', () {
      final result = AIFeatureResult.fromJson({'success': false, 'message': 'Rate limited'});
      expect(result.success, false);
      expect(result.data, isNull);
      expect(result.cached, false);
      expect(result.tokensUsed, isNull);
      expect(result.cost, isNull);
    });

    test('error factory creates error result', () {
      final result = AIFeatureResult.error('Something went wrong');
      expect(result.success, false);
      expect(result.message, 'Something went wrong');
      expect(result.data, isNull);
    });

    test('fromJson with missing cached/tokens defaults', () {
      final result = AIFeatureResult.fromJson({
        'success': true,
        'data': {'items': []},
      });
      expect(result.cached, false);
      expect(result.tokensUsed, isNull);
      expect(result.cost, isNull);
    });

    test('fromJson handles integer cost as double', () {
      final result = AIFeatureResult.fromJson({
        'success': true,
        'data': {'cost': 1, 'tokens_used': 100},
      });
      expect(result.cost, 1.0);
      expect(result.cost, isA<double>());
    });
  });

  // ─── AISuggestion ─────────────────────────────────────────

  group('AISuggestion', () {
    final json = {
      'id': 'sug-1',
      'store_id': 'store-1',
      'feature_slug': 'smart_reorder',
      'suggestion_type': 'reorder',
      'title': 'Reorder Rice',
      'title_ar': 'إعادة طلب الأرز',
      'content_json': {'product': 'Rice', 'quantity': 100},
      'priority': 'high',
      'status': 'pending',
      'accepted_at': null,
      'dismissed_at': null,
      'expires_at': '2024-12-31T00:00:00.000Z',
      'created_at': '2024-01-01T00:00:00.000Z',
    };

    test('fromJson parses all fields', () {
      final suggestion = AISuggestion.fromJson(json);
      expect(suggestion.id, 'sug-1');
      expect(suggestion.storeId, 'store-1');
      expect(suggestion.featureSlug, 'smart_reorder');
      expect(suggestion.suggestionType, 'reorder');
      expect(suggestion.title, 'Reorder Rice');
      expect(suggestion.titleAr, 'إعادة طلب الأرز');
      expect(suggestion.contentJson, isNotNull);
      expect(suggestion.contentJson!['product'], 'Rice');
      expect(suggestion.priority, AISuggestionPriority.high);
      expect(suggestion.status, AISuggestionStatus.pending);
      expect(suggestion.acceptedAt, isNull);
      expect(suggestion.expiresAt, isNotNull);
    });

    test('fromJson uses defaults for missing priority/status', () {
      final minimal = AISuggestion.fromJson({'id': 's1', 'store_id': 'st1', 'feature_slug': 'test'});
      expect(minimal.priority, AISuggestionPriority.medium);
      expect(minimal.status, AISuggestionStatus.pending);
    });

    test('priority enum values', () {
      expect(AISuggestionPriority.fromValue('high'), AISuggestionPriority.high);
      expect(AISuggestionPriority.fromValue('medium'), AISuggestionPriority.medium);
      expect(AISuggestionPriority.fromValue('low'), AISuggestionPriority.low);
    });

    test('status enum values', () {
      expect(AISuggestionStatus.fromValue('pending'), AISuggestionStatus.pending);
      expect(AISuggestionStatus.fromValue('viewed'), AISuggestionStatus.viewed);
      expect(AISuggestionStatus.fromValue('accepted'), AISuggestionStatus.accepted);
      expect(AISuggestionStatus.fromValue('dismissed'), AISuggestionStatus.dismissed);
      expect(AISuggestionStatus.fromValue('expired'), AISuggestionStatus.expired);
    });

    test('invalid priority tryFromValue returns null', () {
      expect(AISuggestionPriority.tryFromValue('critical'), isNull);
      expect(AISuggestionPriority.tryFromValue(null), isNull);
    });

    test('invalid status tryFromValue returns null', () {
      expect(AISuggestionStatus.tryFromValue('archived'), isNull);
      expect(AISuggestionStatus.tryFromValue(null), isNull);
    });
  });

  // ─── AIFeedback ───────────────────────────────────────────

  group('AIFeedback', () {
    test('fromJson parses all fields', () {
      final feedback = AIFeedback.fromJson({
        'id': 'fb-1',
        'ai_usage_log_id': 'log-1',
        'store_id': 'store-1',
        'user_id': 'user-1',
        'rating': 5,
        'is_helpful': true,
        'feedback_text': 'Great suggestion!',
        'created_at': '2024-01-01T00:00:00.000Z',
      });
      expect(feedback.id, 'fb-1');
      expect(feedback.aiUsageLogId, 'log-1');
      expect(feedback.storeId, 'store-1');
      expect(feedback.userId, 'user-1');
      expect(feedback.rating, 5);
      expect(feedback.isHelpful, true);
      expect(feedback.feedbackText, 'Great suggestion!');
    });

    test('fromJson with nullable fields', () {
      final feedback = AIFeedback.fromJson({'id': 'fb-2', 'ai_usage_log_id': 'log-2', 'store_id': 'store-2', 'rating': 3});
      expect(feedback.isHelpful, isNull);
      expect(feedback.feedbackText, isNull);
      expect(feedback.userId, isNull);
    });
  });

  // ─── AIUsageSummary ───────────────────────────────────────

  group('AIUsageSummary', () {
    test('fromJson parses complete summary', () {
      final summary = AIUsageSummary.fromJson({
        'today': {'request_count': 42, 'total_cost': 0.0315, 'total_tokens': 15000},
        'monthly': {'request_count': 1200, 'total_cost': 0.95, 'total_tokens': 500000},
        'by_feature': [
          {'feature_slug': 'smart_reorder', 'request_count': 20, 'total_cost': 0.015},
          {'feature_slug': 'daily_summary', 'request_count': 22, 'total_cost': 0.016},
        ],
      });

      expect(summary.today.requestCount, 42);
      expect(summary.today.totalCost, 0.0315);
      expect(summary.today.totalTokens, 15000);
      expect(summary.monthly.requestCount, 1200);
      expect(summary.monthly.totalCost, 0.95);
      expect(summary.byFeature, hasLength(2));
      expect(summary.byFeature[0].featureSlug, 'smart_reorder');
    });

    test('fromJson handles missing by_feature', () {
      final summary = AIUsageSummary.fromJson({
        'today': {'request_count': 0},
        'monthly': {'request_count': 0},
      });
      expect(summary.byFeature, isEmpty);
    });
  });

  // ─── AIUsageToday ─────────────────────────────────────────

  group('AIUsageToday', () {
    test('fromJson handles zero/missing values', () {
      final today = AIUsageToday.fromJson({});
      expect(today.requestCount, 0);
      expect(today.totalCost, 0);
      expect(today.totalTokens, 0);
    });

    test('fromJson handles integer cost as double', () {
      final today = AIUsageToday.fromJson({'request_count': 10, 'total_cost': 1, 'total_tokens': 5000});
      expect(today.totalCost, 1.0);
      expect(today.totalCost, isA<double>());
    });
  });

  // ─── AIDailyUsage ─────────────────────────────────────────

  group('AIDailyUsage', () {
    test('fromJson parses all fields', () {
      final daily = AIDailyUsage.fromJson({
        'date': '2024-01-15',
        'feature_slug': 'smart_reorder',
        'request_count': 25,
        'cached_count': 10,
        'error_count': 2,
        'total_tokens': 12000,
        'total_cost': 0.012,
        'avg_response_ms': 850,
      });
      expect(daily.date, '2024-01-15');
      expect(daily.featureSlug, 'smart_reorder');
      expect(daily.requestCount, 25);
      expect(daily.cachedCount, 10);
      expect(daily.errorCount, 2);
      expect(daily.totalTokens, 12000);
      expect(daily.totalCost, 0.012);
      expect(daily.avgResponseMs, 850);
    });

    test('fromJson uses defaults for missing counts', () {
      final daily = AIDailyUsage.fromJson({'date': '2024-01-15', 'feature_slug': 'test'});
      expect(daily.requestCount, 0);
      expect(daily.cachedCount, 0);
      expect(daily.errorCount, 0);
      expect(daily.totalTokens, 0);
      expect(daily.totalCost, 0);
      expect(daily.avgResponseMs, 0);
    });
  });
}
