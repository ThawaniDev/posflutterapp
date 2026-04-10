import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/wameed_ai/enums/ai_feature_category.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_usage.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

void main() {
  // ─── AIFeaturesState ──────────────────────────────────────

  group('AIFeaturesState', () {
    test('AIFeaturesInitial is default', () {
      const state = AIFeaturesInitial();
      expect(state, isA<AIFeaturesState>());
    });

    test('AIFeaturesLoading indicates loading', () {
      const state = AIFeaturesLoading();
      expect(state, isA<AIFeaturesState>());
    });

    test('AIFeaturesLoaded holds features list', () {
      final features = [
        AIFeatureDefinition(
          id: 'f1',
          slug: 'smart_reorder',
          name: 'Smart Reorder',
          category: AIFeatureCategory.inventory,
        ),
        AIFeatureDefinition(
          id: 'f2',
          slug: 'daily_summary',
          name: 'Daily Summary',
          category: AIFeatureCategory.sales,
        ),
      ];
      final state = AIFeaturesLoaded(features: features);
      expect(state.features, hasLength(2));
      expect(state.features[0].slug, 'smart_reorder');
      expect(state.features[1].slug, 'daily_summary');
    });

    test('AIFeaturesLoaded with empty list', () {
      const state = AIFeaturesLoaded(features: []);
      expect(state.features, isEmpty);
    });

    test('AIFeaturesError holds message', () {
      const state = AIFeaturesError(message: 'Network error');
      expect(state.message, 'Network error');
    });
  });

  // ─── AIFeatureResultState ─────────────────────────────────

  group('AIFeatureResultState', () {
    test('AIFeatureResultInitial is default', () {
      const state = AIFeatureResultInitial();
      expect(state, isA<AIFeatureResultState>());
    });

    test('AIFeatureResultLoading indicates loading', () {
      const state = AIFeatureResultLoading();
      expect(state, isA<AIFeatureResultState>());
    });

    test('AIFeatureResultLoaded holds result', () {
      const result = AIFeatureResult(
        success: true,
        message: 'Done',
        data: {'items': []},
        cached: true,
        tokensUsed: 500,
        cost: 0.001,
      );
      const state = AIFeatureResultLoaded(result: result);
      expect(state.result.success, true);
      expect(state.result.cached, true);
      expect(state.result.tokensUsed, 500);
    });

    test('AIFeatureResultError holds message', () {
      const state = AIFeatureResultError(message: 'API failed');
      expect(state.message, 'API failed');
    });
  });

  // ─── AISuggestionsState ───────────────────────────────────

  group('AISuggestionsState', () {
    test('AISuggestionsInitial is default', () {
      const state = AISuggestionsInitial();
      expect(state, isA<AISuggestionsState>());
    });

    test('AISuggestionsLoading indicates loading', () {
      const state = AISuggestionsLoading();
      expect(state, isA<AISuggestionsState>());
    });

    test('AISuggestionsLoaded holds paginated data', () {
      final state = AISuggestionsLoaded(
        suggestions: [
          AISuggestion(id: 's1', storeId: 'st1', featureSlug: 'smart_reorder'),
        ],
        total: 50,
        currentPage: 1,
        lastPage: 3,
        perPage: 20,
        featureFilter: 'smart_reorder',
      );
      expect(state.suggestions, hasLength(1));
      expect(state.total, 50);
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
      expect(state.perPage, 20);
      expect(state.featureFilter, 'smart_reorder');
      expect(state.hasMore, true);
    });

    test('AISuggestionsLoaded hasMore false on last page', () {
      const state = AISuggestionsLoaded(
        suggestions: [],
        total: 10,
        currentPage: 1,
        lastPage: 1,
        perPage: 20,
      );
      expect(state.hasMore, false);
      expect(state.featureFilter, isNull);
    });

    test('AISuggestionsError holds message', () {
      const state = AISuggestionsError(message: 'Connection timeout');
      expect(state.message, 'Connection timeout');
    });
  });

  // ─── AIUsageState ─────────────────────────────────────────

  group('AIUsageState', () {
    test('AIUsageInitial is default', () {
      const state = AIUsageInitial();
      expect(state, isA<AIUsageState>());
    });

    test('AIUsageLoading indicates loading', () {
      const state = AIUsageLoading();
      expect(state, isA<AIUsageState>());
    });

    test('AIUsageLoaded holds summary', () {
      const summary = AIUsageSummary(
        today: AIUsageToday(requestCount: 42, totalCost: 0.05, totalTokens: 15000),
        monthly: AIUsageMonthly(requestCount: 1200, totalCost: 0.95, totalTokens: 500000),
      );
      const state = AIUsageLoaded(summary: summary);
      expect(state.summary.today.requestCount, 42);
      expect(state.summary.monthly.requestCount, 1200);
    });

    test('AIUsageError holds message', () {
      const state = AIUsageError(message: 'Server error');
      expect(state.message, 'Server error');
    });
  });

  // ─── AISmartSearchState ───────────────────────────────────

  group('AISmartSearchState', () {
    test('AISmartSearchInitial is default', () {
      const state = AISmartSearchInitial();
      expect(state, isA<AISmartSearchState>());
    });

    test('AISmartSearchLoading indicates loading', () {
      const state = AISmartSearchLoading();
      expect(state, isA<AISmartSearchState>());
    });

    test('AISmartSearchLoaded holds result and query', () {
      const result = AIFeatureResult(success: true, data: {'products': []});
      const state = AISmartSearchLoaded(result: result, query: 'low stock items');
      expect(state.result.success, true);
      expect(state.query, 'low stock items');
    });

    test('AISmartSearchError holds message', () {
      const state = AISmartSearchError(message: 'Search failed');
      expect(state.message, 'Search failed');
    });
  });
}
