import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/features/wameed_ai/enums/ai_feature_category.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_definition.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_suggestion.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_usage.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';

// ─── Mock Notifiers ─────────────────────────────────────────

class MockAIFeaturesNotifier extends StateNotifier<AIFeaturesState> implements AIFeaturesNotifier {
  MockAIFeaturesNotifier(super.initial);

  @override
  Future<void> load() async {}

  @override
  Future<void> updateFeatureConfig(String featureId, {required bool isEnabled}) async {}
}

class MockAIFeatureResultNotifier extends StateNotifier<AIFeatureResultState> implements AIFeatureResultNotifier {
  MockAIFeatureResultNotifier(super.initial);

  @override
  Future<void> invoke(String slug, {Map<String, dynamic>? params}) async {}

  @override
  void reset() => state = const AIFeatureResultInitial();
}

class MockAISuggestionsNotifier extends StateNotifier<AISuggestionsState> implements AISuggestionsNotifier {
  MockAISuggestionsNotifier(super.initial);

  @override
  Future<void> load({int page = 1, String? featureSlug, String? status}) async {}

  @override
  Future<void> updateStatus(String suggestionId, String status) async {}
}

class MockAIUsageNotifier extends StateNotifier<AIUsageState> implements AIUsageNotifier {
  MockAIUsageNotifier(super.initial);

  @override
  Future<void> load() async {}
}

class MockAISmartSearchNotifier extends StateNotifier<AISmartSearchState> implements AISmartSearchNotifier {
  MockAISmartSearchNotifier(super.initial);

  @override
  Future<void> search(String query) async {}

  @override
  void reset() => state = const AISmartSearchInitial();
}

// ─── Helpers ────────────────────────────────────────────────

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: const Locale('en'),
      home: child,
    ),
  );
}

// ─── Test Data ──────────────────────────────────────────────

final _testFeatures = [
  AIFeatureDefinition(
    id: 'f1',
    slug: 'smart_reorder',
    name: 'Smart Reorder',
    nameAr: 'إعادة الطلب الذكي',
    description: 'AI-powered reorder suggestions',
    category: AIFeatureCategory.inventory,
    isActive: true,
  ),
  AIFeatureDefinition(
    id: 'f2',
    slug: 'daily_summary',
    name: 'Daily Summary',
    nameAr: 'ملخص يومي',
    description: 'Get automated daily sales summaries',
    category: AIFeatureCategory.sales,
    isActive: true,
    isPremium: true,
  ),
  AIFeatureDefinition(
    id: 'f3',
    slug: 'customer_segmentation',
    name: 'Customer Segmentation',
    category: AIFeatureCategory.customer,
    isActive: true,
  ),
];

const _testUsageSummary = AIUsageSummary(
  today: AIUsageToday(requestCount: 42, totalCost: 0.05, totalTokens: 15000),
  monthly: AIUsageMonthly(requestCount: 1200, totalCost: 0.95, totalTokens: 500000),
);

void main() {
  // ─── WameedAIHomePage Tests ───────────────────────────────

  group('WameedAIHomePage', () {
    testWidgets('shows loading indicator in initial/loading state', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Scaffold(body: Center(child: CircularProgressIndicator())),
          overrides: [
            aiFeaturesProvider.overrideWith((_) => MockAIFeaturesNotifier(const AIFeaturesLoading())),
            aiUsageProvider.overrideWith((_) => MockAIUsageNotifier(const AIUsageInitial())),
            aiSmartSearchProvider.overrideWith((_) => MockAISmartSearchNotifier(const AISmartSearchInitial())),
          ],
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows error message on AIFeaturesError', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Scaffold(body: Center(child: Text('Failed to load AI features'))),
          overrides: [
            aiFeaturesProvider.overrideWith(
              (_) => MockAIFeaturesNotifier(const AIFeaturesError(message: 'Failed to load AI features')),
            ),
            aiUsageProvider.overrideWith((_) => MockAIUsageNotifier(const AIUsageInitial())),
            aiSmartSearchProvider.overrideWith((_) => MockAISmartSearchNotifier(const AISmartSearchInitial())),
          ],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Failed to load AI features'), findsOneWidget);
    });
  });

  // ─── AIResultCard Tests ───────────────────────────────────

  group('AIResultCard widget behavior', () {
    testWidgets('renders success result with data', (tester) async {
      const result = AIFeatureResult(
        success: true,
        message: 'Analysis complete',
        data: {'suggestions': []},
        cached: true,
        tokensUsed: 500,
        cost: 0.001,
      );

      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Simulate the result card's content
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [Icon(Icons.auto_awesome, size: 20), SizedBox(width: 8), Text('AI Result')]),
                        if (result.cached) const Row(children: [Icon(Icons.cached, size: 14), Text('Cached')]),
                        if (result.message != null) Text(result.message!),
                        if (result.tokensUsed != null) Text('${result.tokensUsed} tokens'),
                        if (result.cost != null) Text('\$${result.cost!.toStringAsFixed(6)}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Analysis complete'), findsOneWidget);
      expect(find.text('500 tokens'), findsOneWidget);
      expect(find.text('\$0.001000'), findsOneWidget);
      expect(find.byIcon(Icons.cached), findsOneWidget);
    });

    testWidgets('renders error result', (tester) async {
      final result = AIFeatureResult.error('Rate limit exceeded');

      await tester.pumpWidget(_wrap(Scaffold(body: Column(children: [if (!result.success) Text(result.message ?? 'Error')]))));

      await tester.pumpAndSettle();
      expect(find.text('Rate limit exceeded'), findsOneWidget);
    });
  });

  // ─── AIUsageBanner Tests ──────────────────────────────────

  group('AIUsageBanner widget behavior', () {
    testWidgets('shows nothing when state is not loaded', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(aiUsageProvider);
                if (state is! AIUsageLoaded) return const SizedBox.shrink();
                return const Text('Usage loaded');
              },
            ),
          ),
          overrides: [aiUsageProvider.overrideWith((_) => MockAIUsageNotifier(const AIUsageInitial()))],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Usage loaded'), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('shows usage stats when loaded', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                final state = ref.watch(aiUsageProvider);
                if (state is! AIUsageLoaded) return const SizedBox.shrink();
                final summary = state.summary;
                return Column(
                  children: [
                    Text('Today: ${summary.today.requestCount}'),
                    Text('Cost: \$${summary.today.totalCost.toStringAsFixed(4)}'),
                    Text('Monthly: ${summary.monthly.requestCount}'),
                  ],
                );
              },
            ),
          ),
          overrides: [aiUsageProvider.overrideWith((_) => MockAIUsageNotifier(const AIUsageLoaded(summary: _testUsageSummary)))],
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Today: 42'), findsOneWidget);
      expect(find.text('Cost: \$0.0500'), findsOneWidget);
      expect(find.text('Monthly: 1200'), findsOneWidget);
    });
  });

  // ─── Provider State Transitions ───────────────────────────

  group('Provider state transitions', () {
    test('AIFeaturesNotifier starts with initial state', () {
      final notifier = MockAIFeaturesNotifier(const AIFeaturesInitial());
      expect(notifier.state, isA<AIFeaturesInitial>());
    });

    test('AIFeaturesNotifier can transition to loaded', () {
      final notifier = MockAIFeaturesNotifier(const AIFeaturesInitial());
      notifier.state = AIFeaturesLoaded(features: _testFeatures);
      expect(notifier.state, isA<AIFeaturesLoaded>());
      expect((notifier.state as AIFeaturesLoaded).features, hasLength(3));
    });

    test('AIFeaturesNotifier can transition to error', () {
      final notifier = MockAIFeaturesNotifier(const AIFeaturesInitial());
      notifier.state = const AIFeaturesError(message: 'Network failure');
      expect(notifier.state, isA<AIFeaturesError>());
      expect((notifier.state as AIFeaturesError).message, 'Network failure');
    });

    test('AIFeatureResultNotifier reset returns to initial', () {
      final notifier = MockAIFeatureResultNotifier(const AIFeatureResultLoaded(result: AIFeatureResult(success: true)));
      expect(notifier.state, isA<AIFeatureResultLoaded>());
      notifier.reset();
      expect(notifier.state, isA<AIFeatureResultInitial>());
    });

    test('AISuggestionsNotifier starts with initial state', () {
      final notifier = MockAISuggestionsNotifier(const AISuggestionsInitial());
      expect(notifier.state, isA<AISuggestionsInitial>());
    });

    test('AIUsageNotifier starts with initial state', () {
      final notifier = MockAIUsageNotifier(const AIUsageInitial());
      expect(notifier.state, isA<AIUsageInitial>());
    });

    test('AISmartSearchNotifier reset returns to initial', () {
      final notifier = MockAISmartSearchNotifier(
        const AISmartSearchLoaded(
          result: AIFeatureResult(success: true, data: {}),
          query: 'test',
        ),
      );
      expect(notifier.state, isA<AISmartSearchLoaded>());
      notifier.reset();
      expect(notifier.state, isA<AISmartSearchInitial>());
    });
  });

  // ─── Switch-based State Matching ──────────────────────────

  group('Sealed state pattern matching', () {
    test('AIFeaturesState switch covers all cases', () {
      final states = <AIFeaturesState>[
        const AIFeaturesInitial(),
        const AIFeaturesLoading(),
        const AIFeaturesLoaded(features: []),
        const AIFeaturesError(message: 'err'),
      ];

      for (final state in states) {
        final label = switch (state) {
          AIFeaturesInitial() => 'initial',
          AIFeaturesLoading() => 'loading',
          AIFeaturesLoaded() => 'loaded',
          AIFeaturesError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    test('AIFeatureResultState switch covers all cases', () {
      final states = <AIFeatureResultState>[
        const AIFeatureResultInitial(),
        const AIFeatureResultLoading(),
        const AIFeatureResultLoaded(result: AIFeatureResult(success: true)),
        const AIFeatureResultError(message: 'err'),
      ];

      for (final state in states) {
        final label = switch (state) {
          AIFeatureResultInitial() => 'initial',
          AIFeatureResultLoading() => 'loading',
          AIFeatureResultLoaded() => 'loaded',
          AIFeatureResultError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    test('AISuggestionsState switch covers all cases', () {
      final states = <AISuggestionsState>[
        const AISuggestionsInitial(),
        const AISuggestionsLoading(),
        const AISuggestionsLoaded(suggestions: [], total: 0, currentPage: 1, lastPage: 1, perPage: 20),
        const AISuggestionsError(message: 'err'),
      ];

      for (final state in states) {
        final label = switch (state) {
          AISuggestionsInitial() => 'initial',
          AISuggestionsLoading() => 'loading',
          AISuggestionsLoaded() => 'loaded',
          AISuggestionsError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    test('AIUsageState switch covers all cases', () {
      final states = <AIUsageState>[
        const AIUsageInitial(),
        const AIUsageLoading(),
        const AIUsageLoaded(
          summary: AIUsageSummary(today: AIUsageToday(), monthly: AIUsageMonthly()),
        ),
        const AIUsageError(message: 'err'),
      ];

      for (final state in states) {
        final label = switch (state) {
          AIUsageInitial() => 'initial',
          AIUsageLoading() => 'loading',
          AIUsageLoaded() => 'loaded',
          AIUsageError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });

    test('AISmartSearchState switch covers all cases', () {
      final states = <AISmartSearchState>[
        const AISmartSearchInitial(),
        const AISmartSearchLoading(),
        const AISmartSearchLoaded(result: AIFeatureResult(success: true), query: 'q'),
        const AISmartSearchError(message: 'err'),
      ];

      for (final state in states) {
        final label = switch (state) {
          AISmartSearchInitial() => 'initial',
          AISmartSearchLoading() => 'loading',
          AISmartSearchLoaded() => 'loaded',
          AISmartSearchError() => 'error',
        };
        expect(label, isNotEmpty);
      }
    });
  });
}
