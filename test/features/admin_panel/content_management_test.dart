import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════
  //  P8 API Endpoints - CMS Pages
  // ═══════════════════════════════════════════════════════════════

  group('P8 API Endpoints - CMS Pages', () {
    test('adminCmsPages endpoint is correct', () {
      expect(ApiEndpoints.adminCmsPages, '/admin/content/pages');
    });

    test('adminCmsPageById returns correct path', () {
      expect(ApiEndpoints.adminCmsPageById('page-1'), '/admin/content/pages/page-1');
    });

    test('adminCmsPagePublish returns correct path', () {
      expect(ApiEndpoints.adminCmsPagePublish('page-1'), '/admin/content/pages/page-1/publish');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 API Endpoints - Articles
  // ═══════════════════════════════════════════════════════════════

  group('P8 API Endpoints - Articles', () {
    test('adminArticles endpoint is correct', () {
      expect(ApiEndpoints.adminArticles, '/admin/content/articles');
    });

    test('adminArticleById returns correct path', () {
      expect(ApiEndpoints.adminArticleById('art-1'), '/admin/content/articles/art-1');
    });

    test('adminArticlePublish returns correct path', () {
      expect(ApiEndpoints.adminArticlePublish('art-1'), '/admin/content/articles/art-1/publish');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 API Endpoints - Announcements
  // ═══════════════════════════════════════════════════════════════

  group('P8 API Endpoints - Announcements', () {
    test('adminAnnouncements endpoint is correct', () {
      expect(ApiEndpoints.adminAnnouncements, '/admin/content/announcements');
    });

    test('adminAnnouncementById returns correct path', () {
      expect(ApiEndpoints.adminAnnouncementById('ann-1'), '/admin/content/announcements/ann-1');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 API Endpoints - Notification Templates
  // ═══════════════════════════════════════════════════════════════

  group('P8 API Endpoints - Notification Templates', () {
    test('adminNotificationTemplates endpoint is correct', () {
      expect(ApiEndpoints.adminNotificationTemplates, '/admin/content/templates');
    });

    test('adminNotificationTemplateById returns correct path', () {
      expect(ApiEndpoints.adminNotificationTemplateById('tpl-1'), '/admin/content/templates/tpl-1');
    });

    test('adminNotificationTemplateToggle returns correct path', () {
      expect(ApiEndpoints.adminNotificationTemplateToggle('tpl-1'), '/admin/content/templates/tpl-1/toggle');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - CmsPageListState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - CmsPageListState', () {
    test('CmsPageListInitial is correct type', () {
      expect(const CmsPageListInitial(), isA<CmsPageListState>());
    });

    test('CmsPageListLoading is correct type', () {
      expect(const CmsPageListLoading(), isA<CmsPageListState>());
    });

    test('CmsPageListLoaded holds pages and total', () {
      const state = CmsPageListLoaded(
        pages: [
          {'title': 'Terms', 'slug': 'terms', 'page_type': 'legal'},
          {'title': 'Privacy', 'slug': 'privacy', 'page_type': 'legal'},
        ],
        total: 2,
      );
      expect(state.pages.length, 2);
      expect(state.total, 2);
      expect(state.pages[0]['slug'], 'terms');
    });

    test('CmsPageListError holds message', () {
      const state = CmsPageListError('Server error');
      expect(state.message, 'Server error');
    });

    test('CmsPageListState sealed pattern matching', () {
      const CmsPageListState state = CmsPageListLoaded(pages: [], total: 0);
      final result = switch (state) {
        CmsPageListInitial() => 'initial',
        CmsPageListLoading() => 'loading',
        CmsPageListLoaded() => 'loaded',
        CmsPageListError() => 'error',
      };
      expect(result, 'loaded');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - CmsPageDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - CmsPageDetailState', () {
    test('CmsPageDetailLoaded holds page data', () {
      const state = CmsPageDetailLoaded(page: {'title': 'About Us', 'body': 'We are Thawani.', 'meta_title': 'About | Thawani'});
      expect(state.page['title'], 'About Us');
      expect(state.page['meta_title'], 'About | Thawani');
    });

    test('CmsPageDetailState sealed pattern matching', () {
      const CmsPageDetailState state = CmsPageDetailError('Not found');
      final result = switch (state) {
        CmsPageDetailInitial() => 'initial',
        CmsPageDetailLoading() => 'loading',
        CmsPageDetailLoaded() => 'loaded',
        CmsPageDetailError() => 'error',
      };
      expect(result, 'error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - CmsPageActionState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - CmsPageActionState', () {
    test('CmsPageActionSuccess holds message', () {
      const state = CmsPageActionSuccess('Created');
      expect(state.message, 'Created');
    });

    test('CmsPageActionState sealed pattern matching', () {
      const CmsPageActionState state = CmsPageActionLoading();
      final result = switch (state) {
        CmsPageActionInitial() => 'initial',
        CmsPageActionLoading() => 'loading',
        CmsPageActionSuccess() => 'success',
        CmsPageActionError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - ArticleListState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - ArticleListState', () {
    test('ArticleListInitial is correct type', () {
      expect(const ArticleListInitial(), isA<ArticleListState>());
    });

    test('ArticleListLoaded holds all fields', () {
      const state = ArticleListLoaded(
        articles: [
          {'title': 'Getting Started', 'category': 'getting_started'},
        ],
        total: 15,
        currentPage: 1,
        lastPage: 3,
      );
      expect(state.articles.length, 1);
      expect(state.total, 15);
      expect(state.currentPage, 1);
      expect(state.lastPage, 3);
    });

    test('ArticleListState sealed pattern matching', () {
      const ArticleListState state = ArticleListLoading();
      final result = switch (state) {
        ArticleListInitial() => 'initial',
        ArticleListLoading() => 'loading',
        ArticleListLoaded() => 'loaded',
        ArticleListError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - ArticleDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - ArticleDetailState', () {
    test('ArticleDetailLoaded holds article data', () {
      const state = ArticleDetailLoaded(
        article: {'title': 'How to Use POS', 'body': 'Step-by-step guide', 'category': 'pos_usage', 'is_published': true},
      );
      expect(state.article['category'], 'pos_usage');
    });

    test('ArticleDetailState sealed pattern matching', () {
      const ArticleDetailState state = ArticleDetailInitial();
      final result = switch (state) {
        ArticleDetailInitial() => 'initial',
        ArticleDetailLoading() => 'loading',
        ArticleDetailLoaded() => 'loaded',
        ArticleDetailError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - ArticleActionState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - ArticleActionState', () {
    test('ArticleActionSuccess and Error have messages', () {
      const success = ArticleActionSuccess('ok');
      const error = ArticleActionError('fail');
      expect(success.message, isNotEmpty);
      expect(error.message, isNotEmpty);
    });

    test('ArticleActionState pattern matching', () {
      const ArticleActionState state = ArticleActionSuccess('done');
      final result = switch (state) {
        ArticleActionInitial() => 'initial',
        ArticleActionLoading() => 'loading',
        ArticleActionSuccess() => 'success',
        ArticleActionError() => 'error',
      };
      expect(result, 'success');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - AnnouncementListState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - AnnouncementListState', () {
    test('AnnouncementListLoaded holds all fields', () {
      const state = AnnouncementListLoaded(
        announcements: [
          {'title': 'Maintenance', 'type': 'maintenance', 'is_banner': true},
          {'title': 'Update', 'type': 'update', 'send_push': true},
        ],
        total: 20,
        currentPage: 2,
        lastPage: 4,
      );
      expect(state.announcements.length, 2);
      expect(state.total, 20);
      expect(state.announcements[0]['type'], 'maintenance');
    });

    test('AnnouncementListState sealed pattern matching', () {
      const AnnouncementListState state = AnnouncementListError('fail');
      final result = switch (state) {
        AnnouncementListInitial() => 'initial',
        AnnouncementListLoading() => 'loading',
        AnnouncementListLoaded() => 'loaded',
        AnnouncementListError() => 'error',
      };
      expect(result, 'error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - AnnouncementDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - AnnouncementDetailState', () {
    test('AnnouncementDetailLoaded holds announcement', () {
      const state = AnnouncementDetailLoaded(
        announcement: {
          'title': 'System Update',
          'type': 'update',
          'target_filter': {
            'plan_ids': ['plan-1'],
          },
        },
      );
      expect(state.announcement['type'], 'update');
    });

    test('AnnouncementDetailState pattern matching', () {
      const AnnouncementDetailState state = AnnouncementDetailLoading();
      final result = switch (state) {
        AnnouncementDetailInitial() => 'initial',
        AnnouncementDetailLoading() => 'loading',
        AnnouncementDetailLoaded() => 'loaded',
        AnnouncementDetailError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - AnnouncementActionState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - AnnouncementActionState', () {
    test('AnnouncementActionState pattern matching covers all', () {
      const AnnouncementActionState state = AnnouncementActionSuccess('deleted');
      final result = switch (state) {
        AnnouncementActionInitial() => 'initial',
        AnnouncementActionLoading() => 'loading',
        AnnouncementActionSuccess() => 'success',
        AnnouncementActionError() => 'error',
      };
      expect(result, 'success');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - NotificationTemplateListState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - NotificationTemplateListState', () {
    test('NotificationTemplateListLoaded holds templates and total', () {
      const state = NotificationTemplateListLoaded(
        templates: [
          {'event_key': 'order_placed', 'channel': 'push', 'is_active': true},
          {'event_key': 'payment_received', 'channel': 'email', 'is_active': false},
        ],
        total: 2,
      );
      expect(state.templates.length, 2);
      expect(state.total, 2);
      expect(state.templates[0]['channel'], 'push');
    });

    test('NotificationTemplateListState sealed pattern matching', () {
      const NotificationTemplateListState state = NotificationTemplateListInitial();
      final result = switch (state) {
        NotificationTemplateListInitial() => 'initial',
        NotificationTemplateListLoading() => 'loading',
        NotificationTemplateListLoaded() => 'loaded',
        NotificationTemplateListError() => 'error',
      };
      expect(result, 'initial');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - NotificationTemplateDetailState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - NotificationTemplateDetailState', () {
    test('NotificationTemplateDetailLoaded holds template', () {
      const state = NotificationTemplateDetailLoaded(
        template: {
          'event_key': 'payment_received',
          'channel': 'sms',
          'title': 'Payment {{amount}}',
          'available_variables': ['amount', 'store_name'],
        },
      );
      expect(state.template['event_key'], 'payment_received');
      expect(state.template['available_variables'], isA<List>());
    });

    test('NotificationTemplateDetailState pattern matching', () {
      const NotificationTemplateDetailState state = NotificationTemplateDetailError('err');
      final result = switch (state) {
        NotificationTemplateDetailInitial() => 'initial',
        NotificationTemplateDetailLoading() => 'loading',
        NotificationTemplateDetailLoaded() => 'loaded',
        NotificationTemplateDetailError() => 'error',
      };
      expect(result, 'error');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 State - NotificationTemplateActionState
  // ═══════════════════════════════════════════════════════════════

  group('P8 State - NotificationTemplateActionState', () {
    test('NotificationTemplateActionState pattern matching covers all', () {
      const NotificationTemplateActionState state = NotificationTemplateActionLoading();
      final result = switch (state) {
        NotificationTemplateActionInitial() => 'initial',
        NotificationTemplateActionLoading() => 'loading',
        NotificationTemplateActionSuccess() => 'success',
        NotificationTemplateActionError() => 'error',
      };
      expect(result, 'loading');
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 Endpoint Integrity
  // ═══════════════════════════════════════════════════════════════

  group('P8 Endpoint Integrity', () {
    test('all CMS endpoints start with /admin/content/pages', () {
      expect(ApiEndpoints.adminCmsPages, startsWith('/admin/content/pages'));
      expect(ApiEndpoints.adminCmsPageById('x'), startsWith('/admin/content/pages'));
      expect(ApiEndpoints.adminCmsPagePublish('x'), startsWith('/admin/content/pages'));
    });

    test('all article endpoints start with /admin/content/articles', () {
      expect(ApiEndpoints.adminArticles, startsWith('/admin/content/articles'));
      expect(ApiEndpoints.adminArticleById('x'), startsWith('/admin/content/articles'));
      expect(ApiEndpoints.adminArticlePublish('x'), startsWith('/admin/content/articles'));
    });

    test('all announcement endpoints start with /admin/content/announcements', () {
      expect(ApiEndpoints.adminAnnouncements, startsWith('/admin/content/announcements'));
      expect(ApiEndpoints.adminAnnouncementById('x'), startsWith('/admin/content/announcements'));
    });

    test('all template endpoints start with /admin/content/templates', () {
      expect(ApiEndpoints.adminNotificationTemplates, startsWith('/admin/content/templates'));
      expect(ApiEndpoints.adminNotificationTemplateById('x'), startsWith('/admin/content/templates'));
      expect(ApiEndpoints.adminNotificationTemplateToggle('x'), startsWith('/admin/content/templates'));
    });

    test('dynamic endpoints include provided IDs', () {
      expect(ApiEndpoints.adminCmsPageById('page-uuid'), contains('page-uuid'));
      expect(ApiEndpoints.adminArticleById('art-uuid'), contains('art-uuid'));
      expect(ApiEndpoints.adminAnnouncementById('ann-uuid'), contains('ann-uuid'));
      expect(ApiEndpoints.adminNotificationTemplateById('tpl-uuid'), contains('tpl-uuid'));
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 Data Shape Validation
  // ═══════════════════════════════════════════════════════════════

  group('P8 Data Shape Validation', () {
    test('CmsPageListLoaded with empty pages', () {
      const state = CmsPageListLoaded(pages: [], total: 0);
      expect(state.pages, isEmpty);
    });

    test('ArticleListLoaded single page result', () {
      const state = ArticleListLoaded(
        articles: [
          {'title': 'Only'},
        ],
        total: 1,
        currentPage: 1,
        lastPage: 1,
      );
      expect(state.currentPage, state.lastPage);
    });

    test('AnnouncementListLoaded with many pages', () {
      const state = AnnouncementListLoaded(
        announcements: [
          {'title': 'A'},
          {'title': 'B'},
        ],
        total: 50,
        currentPage: 5,
        lastPage: 10,
      );
      expect(state.currentPage, lessThanOrEqualTo(state.lastPage));
    });

    test('NotificationTemplateListLoaded with rich template data', () {
      const state = NotificationTemplateListLoaded(
        templates: [
          {
            'event_key': 'order_placed',
            'channel': 'push',
            'title': 'New Order #{order_id}',
            'title_ar': 'طلب جديد #{order_id}',
            'body': 'Order from {customer}',
            'available_variables': ['order_id', 'customer'],
            'is_active': true,
          },
        ],
        total: 1,
      );
      final tpl = state.templates[0];
      expect(tpl.containsKey('event_key'), true);
      expect(tpl.containsKey('channel'), true);
      expect(tpl.containsKey('available_variables'), true);
      expect(tpl['available_variables'], isA<List>());
    });

    test('CmsPage with full SEO metadata', () {
      const state = CmsPageDetailLoaded(
        page: {
          'title': 'About',
          'title_ar': 'حول',
          'slug': 'about',
          'body': '<h1>About</h1>',
          'body_ar': '<h1>حول</h1>',
          'page_type': 'marketing',
          'is_published': true,
          'meta_title': 'About Us | Wameed POS',
          'meta_description': 'Learn about Wameed POS platform.',
          'sort_order': 3,
        },
      );
      expect(state.page.containsKey('meta_title'), true);
      expect(state.page.containsKey('meta_description'), true);
      expect(state.page['sort_order'], 3);
    });
  });

  // ═══════════════════════════════════════════════════════════════
  //  P8 Edge Cases
  // ═══════════════════════════════════════════════════════════════

  group('P8 Edge Cases', () {
    test('announcement with target filter data', () {
      const state = AnnouncementDetailLoaded(
        announcement: {
          'title': 'Targeted',
          'target_filter': {
            'plan_ids': ['plan-1', 'plan-2'],
            'region': 'Muscat',
          },
          'is_banner': true,
          'send_push': true,
          'send_email': false,
        },
      );
      final filter = state.announcement['target_filter'] as Map;
      expect(filter['region'], 'Muscat');
      expect((filter['plan_ids'] as List).length, 2);
    });

    test('template with all variable types', () {
      const state = NotificationTemplateDetailLoaded(
        template: {
          'event_key': 'complex',
          'channel': 'email',
          'title': '{store_name} - Order #{order_id}',
          'body': 'Hi {user_name}, your order of {amount} is confirmed.',
          'available_variables': ['store_name', 'order_id', 'user_name', 'amount'],
          'is_active': true,
        },
      );
      expect((state.template['available_variables'] as List).length, 4);
    });

    test('multiple content types consistency', () {
      // All action states follow same pattern
      const cmsAction = CmsPageActionSuccess('ok');
      const artAction = ArticleActionSuccess('ok');
      const annAction = AnnouncementActionSuccess('ok');
      const tplAction = NotificationTemplateActionSuccess('ok');
      expect(cmsAction.message, 'ok');
      expect(artAction.message, 'ok');
      expect(annAction.message, 'ok');
      expect(tplAction.message, 'ok');
    });

    test('bilingual article data', () {
      const state = ArticleDetailLoaded(
        article: {
          'title': 'Getting Started',
          'title_ar': 'البداية',
          'body': 'English content here',
          'body_ar': 'المحتوى بالعربية',
          'slug': 'getting-started',
          'category': 'getting_started',
        },
      );
      expect(state.article['title'], isNotEmpty);
      expect(state.article['title_ar'], isNotEmpty);
      expect(state.article['body'], isNotEmpty);
      expect(state.article['body_ar'], isNotEmpty);
    });
  });
}
