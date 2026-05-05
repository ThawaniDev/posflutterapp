import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/onboarding/data/remote/onboarding_api_service.dart';
import 'package:wameedpos/features/onboarding/models/business_type.dart';
import 'package:wameedpos/features/onboarding/models/business_type_category_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_loyalty_config.dart';
import 'package:wameedpos/features/onboarding/models/business_type_shift_template.dart';
import 'package:wameedpos/features/onboarding/models/knowledge_base_article.dart';
import 'package:wameedpos/features/pos_customization/enums/knowledge_base_category.dart';

// ── Custom mock adapter ──────────────────────────────────────────────────────

/// Routes-based HTTP mock that intercepts Dio requests and returns preset fixtures.
class _RouteMockAdapter implements HttpClientAdapter {
  _RouteMockAdapter(this._routes);

  final Map<String, dynamic Function(RequestOptions)> _routes;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    // Strip base-url prefix for routing
    final path = options.path.replaceFirst(RegExp(r'^https?://[^/]+'), '');

    final handler = _routes[path];
    if (handler == null) {
      // Try prefix matching for dynamic routes
      final entry = _routes.entries.firstWhere(
        (e) => path.startsWith(e.key.replaceAll('{slug}', '')) || e.key == path,
        orElse: () => MapEntry(path, (_) => <String, dynamic>{'error': 'not found'}),
      );
      final body = json.encode(entry.value(options));
      return ResponseBody.fromString(body, 200,
          headers: {'content-type': ['application/json']});
    }

    final responseData = handler(options);
    final statusCode = responseData['_status'] as int? ?? 200;
    final bodyMap = Map<String, dynamic>.from(responseData)..remove('_status');

    return ResponseBody.fromString(
      json.encode(bodyMap),
      statusCode,
      headers: {'content-type': ['application/json']},
    );
  }

  @override
  void close({bool force = false}) {}
}

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Creates a Dio instance with a mock adapter and the api service on top.
OnboardingApiService _makeService(Map<String, dynamic Function(RequestOptions)> routes) {
  final dio = Dio(BaseOptions(baseUrl: 'https://mock.local'));
  dio.httpClientAdapter = _RouteMockAdapter(routes);
  return OnboardingApiService(dio);
}

Map<String, dynamic> _businessTypeJson({
  String id = 'bt-1',
  String name = 'Retail',
  String nameAr = 'التجزئة',
  String slug = 'retail',
  bool isActive = true,
  int sortOrder = 1,
}) =>
    {
      'id': id,
      'name': name,
      'name_ar': nameAr,
      'slug': slug,
      'icon': '🛍️',
      'is_active': isActive,
      'sort_order': sortOrder,
      'created_at': '2024-01-01T00:00:00.000Z',
      'updated_at': '2024-06-15T10:30:00.000Z',
    };

// ════════════════════════════════════════════════════════════════════════════
//  Tests
// ════════════════════════════════════════════════════════════════════════════

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypesPublic
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypesPublic', () {
    test('parses list of BusinessType objects', () async {
      final service = _makeService({
        '/onboarding/business-types': (_) => {
              'data': [
                _businessTypeJson(id: 'bt-1', slug: 'retail'),
                _businessTypeJson(id: 'bt-2', name: 'Restaurant', nameAr: 'مطعم', slug: 'restaurant'),
              ],
            },
      });

      final result = await service.getBusinessTypesPublic();

      expect(result, isA<List<BusinessType>>());
      expect(result.length, 2);
      expect(result[0].slug, 'retail');
      expect(result[1].slug, 'restaurant');
    });

    test('returns empty list when no business types', () async {
      final service = _makeService({
        '/onboarding/business-types': (_) => {'data': <dynamic>[]},
      });

      final result = await service.getBusinessTypesPublic();
      expect(result, isEmpty);
    });

    test('each item is fully parsed BusinessType', () async {
      final service = _makeService({
        '/onboarding/business-types': (_) => {
              'data': [_businessTypeJson()],
            },
      });

      final result = await service.getBusinessTypesPublic();

      expect(result.first.id, 'bt-1');
      expect(result.first.name, 'Retail');
      expect(result.first.isActive, true);
      expect(result.first.sortOrder, 1);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypeDefaults
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypeDefaults', () {
    test('returns raw defaults bundle as Map', () async {
      final service = _makeService({
        '/onboarding/business-types/retail/defaults': (_) => {
              'data': {
                'business_type': _businessTypeJson(),
                'category_templates': <dynamic>[],
                'shift_templates': <dynamic>[],
                'loyalty_config': null,
                'gamification_templates': {'badges': [], 'challenges': [], 'milestones': []},
              },
            },
      });

      final result = await service.getBusinessTypeDefaults('retail');

      expect(result, isA<Map<String, dynamic>>());
      expect(result['business_type'], isNotNull);
      expect(result['category_templates'], isA<List>());
      expect(result['gamification_templates'], isA<Map>());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypeCategoryTemplates
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypeCategoryTemplates', () {
    test('returns raw list of category template maps', () async {
      final service = _makeService({
        '/onboarding/business-types/retail/category-templates': (_) => {
              'data': [
                {
                  'id': 'cat-1',
                  'business_type_id': 'bt-1',
                  'category_name': 'Electronics',
                  'category_name_ar': 'إلكترونيات',
                  'sort_order': 0,
                },
              ],
            },
      });

      final result = await service.getBusinessTypeCategoryTemplates('retail');

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result.length, 1);
      expect(result.first['category_name'], 'Electronics');

      // Verify the map can be parsed into the model
      final tpl = BusinessTypeCategoryTemplate.fromJson(result.first);
      expect(tpl.categoryName, 'Electronics');
      expect(tpl.categoryNameAr, 'إلكترونيات');
    });

    test('returns empty list when no categories', () async {
      final service = _makeService({
        '/onboarding/business-types/new-type/category-templates': (_) => {'data': <dynamic>[]},
      });

      final result = await service.getBusinessTypeCategoryTemplates('new-type');
      expect(result, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypeShiftTemplates
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypeShiftTemplates', () {
    test('returns shift templates with HH:MM time format', () async {
      final service = _makeService({
        '/onboarding/business-types/retail/shift-templates': (_) => {
              'data': [
                {
                  'id': 'shift-1',
                  'business_type_id': 'bt-1',
                  'name': 'Morning',
                  'name_ar': 'صباح',
                  'start_time': '08:00',
                  'end_time': '16:00',
                  'days_of_week': [1, 2, 3, 4, 5],
                  'break_duration_minutes': 30,
                  'is_default': true,
                  'sort_order': 0,
                },
              ],
            },
      });

      final result = await service.getBusinessTypeShiftTemplates('retail');

      expect(result.length, 1);
      final shift = BusinessTypeShiftTemplate.fromJson(result.first);
      expect(shift.startTime, '08:00');
      expect(shift.endTime, '16:00');
      // daysOfWeek must be List<int>
      expect(shift.daysOfWeek, isA<List<int>>());
      expect(shift.daysOfWeek, [1, 2, 3, 4, 5]);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypeLoyaltyConfig
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypeLoyaltyConfig', () {
    test('returns null when no loyalty config configured', () async {
      final service = _makeService({
        '/onboarding/business-types/simple/loyalty-config': (_) => {'data': null},
      });

      final result = await service.getBusinessTypeLoyaltyConfig('simple');
      expect(result, isNull);
    });

    test('returns Map when loyalty config exists', () async {
      final service = _makeService({
        '/onboarding/business-types/retail/loyalty-config': (_) => {
              'data': {
                'id': 'loyalty-1',
                'business_type_id': 'bt-1',
                'program_type': 'points',
                'earning_rate': 1.5,
                'redemption_value': 0.01,
                'min_redemption_points': 100,
                'tier_definitions': <dynamic>[],
                'is_active': false,
              },
            },
      });

      final result = await service.getBusinessTypeLoyaltyConfig('retail');
      expect(result, isNotNull);
      expect(result, isA<Map<String, dynamic>>());

      // Verify parseable into model
      final config = BusinessTypeLoyaltyConfig.fromJson(result!);
      expect(config.earningRate, 1.5);
      expect(config.isActive, false);
      // Tier definitions must be List
      expect(config.tierDefinitions, isA<List<Map<String, dynamic>>>());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getBusinessTypeGamificationTemplates
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getBusinessTypeGamificationTemplates', () {
    test('returns bundle with badges/challenges/milestones arrays', () async {
      final service = _makeService({
        '/onboarding/business-types/retail/gamification-templates': (_) => {
              'data': {
                'badges': [
                  {
                    'id': 'badge-1',
                    'business_type_id': 'bt-1',
                    'name': 'First Purchase',
                    'name_ar': 'أول شراء',
                    'trigger_type': 'purchase_count',
                    'trigger_threshold': 1,
                    'points_reward': 50,
                  },
                ],
                'challenges': <dynamic>[],
                'milestones': <dynamic>[],
              },
            },
      });

      final result = await service.getBusinessTypeGamificationTemplates('retail');

      expect(result['badges'], isA<List>());
      expect(result['challenges'], isA<List>());
      expect(result['milestones'], isA<List>());
      expect((result['badges'] as List).length, 1);
    });

    test('returns empty arrays when no gamification configured', () async {
      final service = _makeService({
        '/onboarding/business-types/simple/gamification-templates': (_) => {
              'data': {
                'badges': <dynamic>[],
                'challenges': <dynamic>[],
                'milestones': <dynamic>[],
              },
            },
      });

      final result = await service.getBusinessTypeGamificationTemplates('simple');

      expect(result['badges'], isEmpty);
      expect(result['challenges'], isEmpty);
      expect(result['milestones'], isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getHelpArticles
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getHelpArticles', () {
    Map<String, dynamic> _articleJson({String id = 'article-1'}) => {
          'id': id,
          'slug': 'article-$id',
          'title': 'Article $id',
          'title_ar': 'مقالة $id',
          'body': null, // list endpoint — no body
          'body_ar': null,
          'category': 'general',
          'is_published': true,
          'sort_order': 0,
          'created_at': '2024-01-01T00:00:00.000Z',
          'updated_at': '2024-06-15T10:30:00.000Z',
        };

    test('returns paginated response map', () async {
      final service = _makeService({
        '/help-articles': (_) => {
              'data': [_articleJson()],
              'meta': {'total': 1, 'per_page': 20, 'current_page': 1, 'last_page': 1},
              'links': {'first': null, 'last': null, 'prev': null, 'next': null},
            },
      });

      final result = await service.getHelpArticles();

      expect(result, isA<Map<String, dynamic>>());
      expect(result['data'], isA<List>());
      expect((result['data'] as List).length, 1);
      expect(result['meta'], isNotNull);
    });

    test('articles in list can be parsed by KnowledgeBaseArticle.fromJson', () async {
      final service = _makeService({
        '/help-articles': (_) => {
              'data': [_articleJson(id: 'article-1')],
              'meta': {'total': 1, 'per_page': 20, 'current_page': 1, 'last_page': 1},
            },
      });

      final result = await service.getHelpArticles();
      final articles = (result['data'] as List)
          .map((j) => KnowledgeBaseArticle.fromJson(Map<String, dynamic>.from(j as Map)))
          .toList();

      expect(articles.first.slug, 'article-article-1');
      // body is empty in list context (API returns null)
      expect(articles.first.body, '');
    });

    test('sends category query param when provided', () async {
      String? capturedCategory;
      final service = _makeService({
        '/help-articles': (opts) {
          capturedCategory = opts.queryParameters['category'] as String?;
          return {
            'data': <dynamic>[],
            'meta': {'total': 0, 'per_page': 20, 'current_page': 1, 'last_page': 1},
          };
        },
      });

      await service.getHelpArticles(category: 'inventory');
      expect(capturedCategory, 'inventory');
    });

    test('sends delivery_platform_id query param when provided', () async {
      String? capturedPlatformId;
      final service = _makeService({
        '/help-articles': (opts) {
          capturedPlatformId = opts.queryParameters['delivery_platform_id'] as String?;
          return {
            'data': <dynamic>[],
            'meta': {'total': 0, 'per_page': 20, 'current_page': 1, 'last_page': 1},
          };
        },
      });

      await service.getHelpArticles(deliveryPlatformId: 'platform-uuid');
      expect(capturedPlatformId, 'platform-uuid');
    });

    test('does not send category param when not provided', () async {
      bool categoryIncluded = false;
      final service = _makeService({
        '/help-articles': (opts) {
          categoryIncluded = opts.queryParameters.containsKey('category');
          return {
            'data': <dynamic>[],
            'meta': {'total': 0, 'per_page': 20, 'current_page': 1, 'last_page': 1},
          };
        },
      });

      await service.getHelpArticles();
      expect(categoryIncluded, false);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getHelpArticle (single)
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getHelpArticle', () {
    test('returns KnowledgeBaseArticle with body', () async {
      final service = _makeService({
        '/help-articles/getting-started': (_) => {
              'data': {
                'id': 'article-gs',
                'slug': 'getting-started',
                'title': 'Getting Started',
                'title_ar': 'البداية',
                'body': '<h1>Welcome</h1>',
                'body_ar': '<h1>أهلاً</h1>',
                'category': 'getting_started',
                'delivery_platform_id': null,
                'is_published': true,
                'sort_order': 1,
                'created_at': '2024-01-01T00:00:00.000Z',
                'updated_at': '2024-06-15T10:30:00.000Z',
              },
            },
      });

      final article = await service.getHelpArticle('getting-started');

      expect(article, isA<KnowledgeBaseArticle>());
      expect(article.slug, 'getting-started');
      expect(article.body, '<h1>Welcome</h1>');
      expect(article.bodyAr, '<h1>أهلاً</h1>');
      expect(article.category, KnowledgeBaseCategory.gettingStarted);
    });

    test('throws DioException for 404', () async {
      final dio = Dio(BaseOptions(baseUrl: 'https://mock.local'));
      dio.httpClientAdapter = _RouteMockAdapter({
        '/help-articles/missing': (_) => {
              '_status': 404,
              'message': 'Not Found',
            },
      });
      final service = OnboardingApiService(dio);

      // Dio should throw DioException with status 404
      // (unless your service catches it, which this one doesn't)
      expect(
        () async => await service.getHelpArticle('missing'),
        throwsA(isA<DioException>()),
      );
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  getSteps
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingApiService.getSteps', () {
    test('returns list of step maps', () async {
      final service = _makeService({
        '/core/onboarding/steps': (_) => {
              'data': [
                {
                  'id': 'step-1',
                  'step_number': 1,
                  'title': 'Welcome',
                  'title_ar': 'مرحباً',
                  'is_required': true,
                  'sort_order': 0,
                },
                {
                  'id': 'step-2',
                  'step_number': 2,
                  'title': 'Business Type',
                  'title_ar': 'نوع النشاط',
                  'is_required': true,
                  'sort_order': 1,
                },
              ],
            },
      });

      final steps = await service.getSteps();

      expect(steps, isA<List<Map<String, dynamic>>>());
      expect(steps.length, 2);
      expect(steps[0]['title'], 'Welcome');
      expect(steps[1]['title'], 'Business Type');
    });

    test('step_number is an integer in response', () async {
      final service = _makeService({
        '/core/onboarding/steps': (_) => {
              'data': [
                {
                  'id': 'step-1',
                  'step_number': 1,
                  'title': 'Welcome',
                  'title_ar': 'مرحباً',
                },
              ],
            },
      });

      final steps = await service.getSteps();
      expect(steps.first['step_number'], isA<int>());
    });
  });
}
