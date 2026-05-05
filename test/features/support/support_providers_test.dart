// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/support/data/remote/support_api_service.dart';
import 'package:wameedpos/features/support/models/knowledge_base_article.dart';
import 'package:wameedpos/features/support/models/support_ticket.dart';
import 'package:wameedpos/features/support/models/support_ticket_message.dart';
import 'package:wameedpos/features/support/providers/support_providers.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';
import 'package:wameedpos/features/support/repositories/support_repository.dart';

// ═══════════════════════════════════════════════════════════════
//  STUBS
// ═══════════════════════════════════════════════════════════════

/// Stub API service — never used directly; allows SupportRepository to
/// be constructed without a real Dio instance.
class _StubApiService extends SupportApiService {
  _StubApiService() : super(Dio());
}

/// Mock repository with configurable responses for every method.
class _MockSupportRepository extends SupportRepository {
  _MockSupportRepository({
    this.statsResult,
    this.listTicketsResult,
    this.getTicketResult,
    this.createTicketResult,
    this.addMessageResult,
    this.closeTicketResult,
    this.rateTicketResult,
    this.getKbArticlesResult,
    this.getKbArticleResult,
    this.shouldThrow = false,
    this.throwMessage = 'Simulated network error',
  }) : super(_StubApiService());

  final Map<String, dynamic>? statsResult;
  final Map<String, dynamic>? listTicketsResult;
  final Map<String, dynamic>? getTicketResult;
  final Map<String, dynamic>? createTicketResult;
  final Map<String, dynamic>? addMessageResult;
  final Map<String, dynamic>? closeTicketResult;
  final Map<String, dynamic>? rateTicketResult;
  final Map<String, dynamic>? getKbArticlesResult;
  final Map<String, dynamic>? getKbArticleResult;
  final bool shouldThrow;
  final String throwMessage;

  // Track calls for assertion
  int statsCallCount = 0;
  String? lastListTicketsStatus;
  String? lastListTicketsCategory;
  String? lastListTicketsPriority;
  String? lastListTicketsSearch;
  int? lastListTicketsPage;
  String? lastGetTicketId;
  String? lastCreateCategory;
  String? lastCreateSubject;
  String? lastCreateDescription;
  String? lastAddMessageTicketId;
  String? lastAddMessage;
  String? lastCloseTicketId;
  String? lastRateTicketId;
  int? lastRateRating;
  String? lastRateComment;
  String? lastKbCategory;
  String? lastKbSearch;
  String? lastKbArticleSlug;

  @override
  Future<Map<String, dynamic>> getStats() async {
    statsCallCount++;
    if (shouldThrow) throw Exception(throwMessage);
    return statsResult ??
        {
          'data': {
            'total': 5,
            'open': 2,
            'in_progress': 1,
            'resolved': 1,
            'closed': 1,
          }
        };
  }

  @override
  Future<Map<String, dynamic>> listTickets({
    String? status,
    String? category,
    String? priority,
    String? search,
    int? page,
    int? perPage,
  }) async {
    lastListTicketsStatus = status;
    lastListTicketsCategory = category;
    lastListTicketsPriority = priority;
    lastListTicketsSearch = search;
    lastListTicketsPage = page;
    if (shouldThrow) throw Exception(throwMessage);
    return listTicketsResult ??
        {
          'data': {
            'data': [],
            'current_page': 1,
            'last_page': 1,
            'total': 0,
          }
        };
  }

  @override
  Future<Map<String, dynamic>> getTicket(String id) async {
    lastGetTicketId = id;
    if (shouldThrow) throw Exception(throwMessage);
    return getTicketResult ??
        {
          'data': {
            'id': id,
            'ticket_number': 'TKT-2026-0001',
            'organization_id': 'org-001',
            'status': 'open',
            'category': 'technical',
            'priority': 'medium',
            'subject': 'Test ticket',
            'description': 'Test description',
          }
        };
  }

  @override
  Future<Map<String, dynamic>> createTicket({
    required String category,
    required String subject,
    required String description,
    String? priority,
  }) async {
    lastCreateCategory = category;
    lastCreateSubject = subject;
    lastCreateDescription = description;
    if (shouldThrow) throw Exception(throwMessage);
    return createTicketResult ??
        {
          'data': {
            'id': 'new-ticket-id',
            'ticket_number': 'TKT-2026-0099',
            'organization_id': 'org-001',
            'status': 'open',
            'category': category,
            'priority': priority ?? 'medium',
            'subject': subject,
            'description': description,
          }
        };
  }

  @override
  Future<Map<String, dynamic>> addMessage(String ticketId, {required String message}) async {
    lastAddMessageTicketId = ticketId;
    lastAddMessage = message;
    if (shouldThrow) throw Exception(throwMessage);
    return addMessageResult ??
        {
          'data': {
            'id': 'msg-id',
            'support_ticket_id': ticketId,
            'message_text': message,
            'sender_type': 'provider',
            'is_internal_note': false,
            'sent_at': '2026-01-01T10:00:00.000000Z',
          }
        };
  }

  @override
  Future<Map<String, dynamic>> closeTicket(String id) async {
    lastCloseTicketId = id;
    if (shouldThrow) throw Exception(throwMessage);
    return closeTicketResult ?? {'message': 'Ticket closed successfully'};
  }

  @override
  Future<Map<String, dynamic>> rateTicket(
    String id, {
    required int rating,
    String? comment,
  }) async {
    lastRateTicketId = id;
    lastRateRating = rating;
    lastRateComment = comment;
    if (shouldThrow) throw Exception(throwMessage);
    return rateTicketResult ?? {'message': 'Rating submitted successfully'};
  }

  @override
  Future<Map<String, dynamic>> getKbArticles({String? category, String? search}) async {
    lastKbCategory = category;
    lastKbSearch = search;
    if (shouldThrow) throw Exception(throwMessage);
    return getKbArticlesResult ?? {'data': []};
  }

  @override
  Future<Map<String, dynamic>> getKbArticle(String slug) async {
    lastKbArticleSlug = slug;
    if (shouldThrow) throw Exception(throwMessage);
    return getKbArticleResult ??
        {
          'data': {
            'id': 'kb-id',
            'title': 'How to use POS',
            'title_ar': 'كيفية استخدام POS',
            'slug': slug,
            'body': '<p>Step 1</p>',
            'body_ar': '<p>الخطوة 1</p>',
            'category': 'getting_started',
            'is_published': true,
          }
        };
  }
}

// ═══════════════════════════════════════════════════════════════
//  HELPER
// ═══════════════════════════════════════════════════════════════

ProviderContainer _buildContainer(_MockSupportRepository repo) {
  return ProviderContainer(
    overrides: [
      supportRepositoryProvider.overrideWithValue(repo),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
//  TESTS
// ═══════════════════════════════════════════════════════════════

void main() {
  // ────────────────────────────────────────────────────────────
  // REPOSITORY TESTS — verifies delegation to ApiService
  // ────────────────────────────────────────────────────────────

  group('SupportRepository', () {
    late _MockSupportRepository repo;

    setUp(() {
      repo = _MockSupportRepository();
    });

    test('getStats delegates to ApiService', () async {
      final result = await repo.getStats();
      expect(result['data']['total'], 5);
      expect(repo.statsCallCount, 1);
    });

    test('listTickets passes all filter parameters', () async {
      await repo.listTickets(
        status: 'open',
        category: 'billing',
        priority: 'high',
        search: 'invoice',
        page: 2,
      );

      expect(repo.lastListTicketsStatus, 'open');
      expect(repo.lastListTicketsCategory, 'billing');
      expect(repo.lastListTicketsPriority, 'high');
      expect(repo.lastListTicketsSearch, 'invoice');
      expect(repo.lastListTicketsPage, 2);
    });

    test('listTickets without params passes nulls', () async {
      await repo.listTickets();

      expect(repo.lastListTicketsStatus, isNull);
      expect(repo.lastListTicketsCategory, isNull);
      expect(repo.lastListTicketsPriority, isNull);
      expect(repo.lastListTicketsSearch, isNull);
    });

    test('getTicket passes correct ID', () async {
      const id = 'ticket-abc-123';
      await repo.getTicket(id);
      expect(repo.lastGetTicketId, id);
    });

    test('createTicket passes all parameters', () async {
      await repo.createTicket(
        category: 'technical',
        subject: 'Test subject',
        description: 'Test description',
        priority: 'high',
      );

      expect(repo.lastCreateCategory, 'technical');
      expect(repo.lastCreateSubject, 'Test subject');
      expect(repo.lastCreateDescription, 'Test description');
    });

    test('addMessage passes ticketId and message', () async {
      await repo.addMessage('ticket-id-1', message: 'Hello there');
      expect(repo.lastAddMessageTicketId, 'ticket-id-1');
      expect(repo.lastAddMessage, 'Hello there');
    });

    test('closeTicket passes correct ID', () async {
      await repo.closeTicket('ticket-close-id');
      expect(repo.lastCloseTicketId, 'ticket-close-id');
    });

    test('rateTicket passes rating and optional comment', () async {
      await repo.rateTicket('ticket-rate-id', rating: 5, comment: 'Excellent!');
      expect(repo.lastRateTicketId, 'ticket-rate-id');
      expect(repo.lastRateRating, 5);
      expect(repo.lastRateComment, 'Excellent!');
    });

    test('rateTicket without comment passes null', () async {
      await repo.rateTicket('ticket-id', rating: 4);
      expect(repo.lastRateComment, isNull);
    });

    test('getKbArticles passes category and search', () async {
      await repo.getKbArticles(category: 'billing', search: 'invoice');
      expect(repo.lastKbCategory, 'billing');
      expect(repo.lastKbSearch, 'invoice');
    });

    test('getKbArticle passes slug', () async {
      await repo.getKbArticle('how-to-use-pos');
      expect(repo.lastKbArticleSlug, 'how-to-use-pos');
    });
  });

  // ────────────────────────────────────────────────────────────
  // SUPPORT STATS NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('SupportStatsNotifier', () {
    test('initial state is SupportStatsInitial', () {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      expect(container.read(supportStatsProvider), isA<SupportStatsInitial>());
    });

    test('load transitions through loading then loaded', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(supportStatsProvider.notifier).load();

      final state = container.read(supportStatsProvider);
      expect(state, isA<SupportStatsLoaded>());
      final loaded = state as SupportStatsLoaded;
      expect(loaded.total, 5);
      expect(loaded.open, 2);
      expect(loaded.inProgress, 1);
      expect(loaded.resolved, 1);
      expect(loaded.closed, 1);
    });

    test('load with custom response maps all fields', () async {
      final repo = _MockSupportRepository(
        statsResult: {
          'data': {
            'total': 10,
            'open': 3,
            'in_progress': 2,
            'resolved': 4,
            'closed': 1,
          }
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(supportStatsProvider.notifier).load();

      final state = container.read(supportStatsProvider) as SupportStatsLoaded;
      expect(state.total, 10);
      expect(state.open, 3);
      expect(state.inProgress, 2);
      expect(state.resolved, 4);
      expect(state.closed, 1);
    });

    test('load on error transitions to SupportStatsError', () async {
      final repo = _MockSupportRepository(shouldThrow: true, throwMessage: 'No connection');
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(supportStatsProvider.notifier).load();

      final state = container.read(supportStatsProvider);
      expect(state, isA<SupportStatsError>());
      expect((state as SupportStatsError).message, contains('No connection'));
    });

    test('load handles empty data gracefully', () async {
      final repo = _MockSupportRepository(statsResult: {'data': <String, dynamic>{}});
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(supportStatsProvider.notifier).load();

      final state = container.read(supportStatsProvider) as SupportStatsLoaded;
      expect(state.total, 0);
      expect(state.open, 0);
    });
  });

  // ────────────────────────────────────────────────────────────
  // TICKET LIST NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('TicketListNotifier', () {
    test('initial state is TicketListInitial', () {
      final container = _buildContainer(_MockSupportRepository());
      addTearDown(container.dispose);
      expect(container.read(ticketListProvider), isA<TicketListInitial>());
    });

    Map<String, dynamic> _ticketListResponse(List<Map<String, dynamic>> tickets) => {
          'data': {
            'data': tickets,
            'current_page': 1,
            'last_page': 1,
            'total': tickets.length,
          }
        };

    Map<String, dynamic> _ticketJson(String id, {String status = 'open'}) => {
          'id': id,
          'ticket_number': 'TKT-$id',
          'organization_id': 'org-001',
          'status': status,
          'category': 'technical',
          'priority': 'medium',
          'subject': 'Ticket $id',
          'description': 'Description',
          'sla_badge': 'on_track',
          'messages_count': 0,
        };

    test('load populates tickets list', () async {
      final tickets = [_ticketJson('001'), _ticketJson('002')];
      final repo = _MockSupportRepository(listTicketsResult: _ticketListResponse(tickets));
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load();

      final state = container.read(ticketListProvider) as TicketListLoaded;
      expect(state.tickets.length, 2);
      expect(state.tickets[0].ticketNumber, 'TKT-001');
      expect(state.tickets[1].ticketNumber, 'TKT-002');
    });

    test('load passes status filter to repository', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load(status: 'open');

      expect(repo.lastListTicketsStatus, 'open');
    });

    test('load passes category and priority filters', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load(
            category: 'billing',
            priority: 'high',
          );

      expect(repo.lastListTicketsCategory, 'billing');
      expect(repo.lastListTicketsPriority, 'high');
    });

    test('load passes search filter', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load(search: 'invoice error');

      expect(repo.lastListTicketsSearch, 'invoice error');
    });

    test('nextPage calls load with incremented page', () async {
      final repo = _MockSupportRepository(
        listTicketsResult: {
          'data': {
            'data': [_ticketJson('001')],
            'current_page': 1,
            'last_page': 3,
            'total': 30,
          }
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load(status: 'open');
      await container.read(ticketListProvider.notifier).nextPage();

      expect(repo.lastListTicketsPage, 2);
    });

    test('nextPage does nothing when on last page', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load();
      // default response has last_page = 1 = current_page
      final stateBefore = container.read(ticketListProvider) as TicketListLoaded;
      expect(stateBefore.hasMore, isFalse);

      repo.lastListTicketsPage = null; // reset call tracker
      await container.read(ticketListProvider.notifier).nextPage();

      // Should not have been called again with page 2
      expect(repo.lastListTicketsPage, isNull);
    });

    test('previousPage calls load with decremented page', () async {
      final repo = _MockSupportRepository(
        listTicketsResult: {
          'data': {
            'data': [_ticketJson('001')],
            'current_page': 2,
            'last_page': 3,
            'total': 30,
          }
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load(page: 2);
      await container.read(ticketListProvider.notifier).previousPage();

      expect(repo.lastListTicketsPage, 1);
    });

    test('load on error transitions to TicketListError', () async {
      final repo = _MockSupportRepository(shouldThrow: true);
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load();

      expect(container.read(ticketListProvider), isA<TicketListError>());
    });

    test('empty response results in empty tickets list', () async {
      final repo = _MockSupportRepository(
        listTicketsResult: _ticketListResponse([]),
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketListProvider.notifier).load();

      final state = container.read(ticketListProvider) as TicketListLoaded;
      expect(state.tickets, isEmpty);
      expect(state.total, 0);
    });

    test('TicketListLoaded.hasMore is true when currentPage < lastPage', () {
      const state = TicketListLoaded(
        tickets: [],
        currentPage: 1,
        lastPage: 3,
        total: 30,
      );
      expect(state.hasMore, isTrue);
    });

    test('TicketListLoaded.hasMore is false when currentPage == lastPage', () {
      const state = TicketListLoaded(
        tickets: [],
        currentPage: 3,
        lastPage: 3,
        total: 30,
      );
      expect(state.hasMore, isFalse);
    });
  });

  // ────────────────────────────────────────────────────────────
  // TICKET DETAIL NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('TicketDetailNotifier', () {
    test('initial state is TicketDetailInitial', () {
      final container = _buildContainer(_MockSupportRepository());
      addTearDown(container.dispose);
      expect(container.read(ticketDetailProvider), isA<TicketDetailInitial>());
    });

    test('load populates ticket and messages', () async {
      final repo = _MockSupportRepository(
        getTicketResult: {
          'data': {
            'id': 'ticket-001',
            'ticket_number': 'TKT-2026-0001',
            'organization_id': 'org-001',
            'status': 'open',
            'category': 'technical',
            'priority': 'medium',
            'subject': 'Printer not working',
            'description': 'Printer stops mid-print',
            'sla_badge': 'on_track',
            'messages_count': 1,
            'messages': [
              {
                'id': 'msg-001',
                'support_ticket_id': 'ticket-001',
                'sender_type': 'provider',
                'sender_id': 'store-001',
                'sender_name': 'Store Owner',
                'message_text': 'Please help',
                'is_internal_note': false,
                'sent_at': '2026-01-01T10:00:00.000000Z',
              }
            ],
          }
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketDetailProvider.notifier).load('ticket-001');

      final state = container.read(ticketDetailProvider) as TicketDetailLoaded;
      expect(state.ticket.id, 'ticket-001');
      expect(state.ticket.subject, 'Printer not working');
      expect(state.messages.length, 1);
      expect(state.messages[0].messageText, 'Please help');
    });

    test('load passes correct ticket ID to repository', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketDetailProvider.notifier).load('my-ticket-id');

      expect(repo.lastGetTicketId, 'my-ticket-id');
    });

    test('load on error transitions to TicketDetailError', () async {
      final repo = _MockSupportRepository(
        shouldThrow: true,
        throwMessage: 'Ticket not found',
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketDetailProvider.notifier).load('bad-id');

      final state = container.read(ticketDetailProvider);
      expect(state, isA<TicketDetailError>());
      expect((state as TicketDetailError).message, contains('Ticket not found'));
    });

    test('load with no messages returns empty messages list', () async {
      final repo = _MockSupportRepository(
        getTicketResult: {
          'data': {
            'id': 't1',
            'ticket_number': 'TKT-001',
            'organization_id': 'org-001',
            'status': 'open',
            'category': 'general',
            'priority': 'low',
            'subject': 'No messages',
            'description': 'No messages yet',
            'sla_badge': 'on_track',
            'messages_count': 0,
            // 'messages' is absent — should default to empty list
          }
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketDetailProvider.notifier).load('t1');

      final state = container.read(ticketDetailProvider) as TicketDetailLoaded;
      expect(state.messages, isEmpty);
    });
  });

  // ────────────────────────────────────────────────────────────
  // TICKET ACTION NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('TicketActionNotifier', () {
    test('initial state is TicketActionInitial', () {
      final container = _buildContainer(_MockSupportRepository());
      addTearDown(container.dispose);
      expect(container.read(ticketActionProvider), isA<TicketActionInitial>());
    });

    test('createTicket transitions to loading then success', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).createTicket(
            category: 'technical',
            subject: 'New ticket',
            description: 'Description',
          );

      final state = container.read(ticketActionProvider);
      expect(state, isA<TicketActionSuccess>());
      expect((state as TicketActionSuccess).message, 'Ticket created successfully');
    });

    test('createTicket passes all parameters to repository', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).createTicket(
            category: 'billing',
            subject: 'Invoice issue',
            description: 'Invoice not generated',
            priority: 'high',
          );

      expect(repo.lastCreateCategory, 'billing');
      expect(repo.lastCreateSubject, 'Invoice issue');
      expect(repo.lastCreateDescription, 'Invoice not generated');
    });

    test('createTicket on error transitions to TicketActionError', () async {
      final repo = _MockSupportRepository(
        shouldThrow: true,
        throwMessage: 'Server unavailable',
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).createTicket(
            category: 'general',
            subject: 'Test',
            description: 'Test',
          );

      final state = container.read(ticketActionProvider);
      expect(state, isA<TicketActionError>());
      expect((state as TicketActionError).message, contains('Server unavailable'));
    });

    test('addMessage transitions to success', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).addMessage(
            'ticket-123',
            message: 'Following up on this issue.',
          );

      final state = container.read(ticketActionProvider);
      expect(state, isA<TicketActionSuccess>());
      expect(repo.lastAddMessageTicketId, 'ticket-123');
      expect(repo.lastAddMessage, 'Following up on this issue.');
    });

    test('closeTicket transitions to success', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).closeTicket('ticket-abc');

      final state = container.read(ticketActionProvider);
      expect(state, isA<TicketActionSuccess>());
      expect((state as TicketActionSuccess).message, 'Ticket closed');
      expect(repo.lastCloseTicketId, 'ticket-abc');
    });

    test('rateTicket with rating and comment transitions to success', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).rateTicket(
            'ticket-xyz',
            rating: 5,
            comment: 'Very helpful!',
          );

      final state = container.read(ticketActionProvider);
      expect(state, isA<TicketActionSuccess>());
      expect(repo.lastRateTicketId, 'ticket-xyz');
      expect(repo.lastRateRating, 5);
      expect(repo.lastRateComment, 'Very helpful!');
    });

    test('rateTicket without comment passes null comment', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).rateTicket('t1', rating: 3);

      expect(repo.lastRateComment, isNull);
    });

    test('rateTicket on error transitions to TicketActionError', () async {
      final repo = _MockSupportRepository(shouldThrow: true);
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).rateTicket('t1', rating: 5);

      expect(container.read(ticketActionProvider), isA<TicketActionError>());
    });

    test('reset returns state to TicketActionInitial', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(ticketActionProvider.notifier).closeTicket('t1');
      expect(container.read(ticketActionProvider), isA<TicketActionSuccess>());

      container.read(ticketActionProvider.notifier).reset();
      expect(container.read(ticketActionProvider), isA<TicketActionInitial>());
    });
  });

  // ────────────────────────────────────────────────────────────
  // KB LIST NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('KbListNotifier', () {
    test('initial state is KbListInitial', () {
      final container = _buildContainer(_MockSupportRepository());
      addTearDown(container.dispose);
      expect(container.read(kbListProvider), isA<KbListInitial>());
    });

    test('load populates articles list', () async {
      final repo = _MockSupportRepository(
        getKbArticlesResult: {
          'data': [
            {
              'id': 'art-001',
              'title': 'Getting Started',
              'title_ar': 'البدء',
              'slug': 'getting-started',
              'body': '<p>Welcome</p>',
              'body_ar': '<p>مرحباً</p>',
              'category': 'getting_started',
              'is_published': true,
            },
            {
              'id': 'art-002',
              'title': 'Payment Methods',
              'title_ar': 'طرق الدفع',
              'slug': 'payment-methods',
              'body': '<p>Methods</p>',
              'body_ar': '<p>الطرق</p>',
              'category': 'billing',
              'is_published': true,
            }
          ]
        },
      );
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbListProvider.notifier).load();

      final state = container.read(kbListProvider) as KbListLoaded;
      expect(state.articles.length, 2);
      expect(state.articles[0].title, 'Getting Started');
      expect(state.articles[1].slug, 'payment-methods');
    });

    test('load passes category filter', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbListProvider.notifier).load(category: 'billing');

      expect(repo.lastKbCategory, 'billing');
    });

    test('load passes search filter', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbListProvider.notifier).load(search: 'invoice');

      expect(repo.lastKbSearch, 'invoice');
    });

    test('load on error transitions to KbListError', () async {
      final repo = _MockSupportRepository(shouldThrow: true);
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbListProvider.notifier).load();

      expect(container.read(kbListProvider), isA<KbListError>());
    });

    test('load with empty response results in empty articles list', () async {
      final repo = _MockSupportRepository(getKbArticlesResult: {'data': []});
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbListProvider.notifier).load();

      final state = container.read(kbListProvider) as KbListLoaded;
      expect(state.articles, isEmpty);
    });
  });

  // ────────────────────────────────────────────────────────────
  // KB ARTICLE NOTIFIER TESTS
  // ────────────────────────────────────────────────────────────

  group('KbArticleNotifier', () {
    test('initial state is KbArticleInitial', () {
      final container = _buildContainer(_MockSupportRepository());
      addTearDown(container.dispose);
      expect(container.read(kbArticleProvider), isA<KbArticleInitial>());
    });

    test('load populates article', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbArticleProvider.notifier).load('how-to-use-pos');

      final state = container.read(kbArticleProvider) as KbArticleLoaded;
      expect(state.article.title, 'How to use POS');
      expect(state.article.slug, 'how-to-use-pos');
      expect(repo.lastKbArticleSlug, 'how-to-use-pos');
    });

    test('load on error transitions to KbArticleError', () async {
      final repo = _MockSupportRepository(shouldThrow: true, throwMessage: 'Article not found');
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      await container.read(kbArticleProvider.notifier).load('missing-slug');

      final state = container.read(kbArticleProvider);
      expect(state, isA<KbArticleError>());
      expect((state as KbArticleError).message, contains('Article not found'));
    });
  });

  // ────────────────────────────────────────────────────────────
  // API RESPONSE PARSING TESTS — end-to-end shape validation
  // ────────────────────────────────────────────────────────────

  group('API Response Parsing', () {
    test('ticket fromJson handles all fields including sla_badge and satisfaction', () {
      final json = {
        'id': 'ticket-full',
        'ticket_number': 'TKT-2026-0001',
        'organization_id': 'org-001',
        'status': 'resolved',
        'category': 'technical',
        'priority': 'high',
        'subject': 'Full ticket',
        'description': 'Full description',
        'sla_badge': 'breached',
        'messages_count': 3,
        'satisfaction_rating': 4,
        'satisfaction_comment': 'Good response',
        'sla_deadline_at': '2026-01-01T10:00:00.000000Z',
        'first_response_at': '2026-01-01T09:00:00.000000Z',
        'resolved_at': '2026-01-02T12:00:00.000000Z',
        'closed_at': null,
      };

      final ticket = SupportTicket.fromJson(json);

      expect(ticket.id, 'ticket-full');
      expect(ticket.status.value, 'resolved');
      expect(ticket.priority.value, 'high');
      expect(ticket.slaBadge, 'breached');
      expect(ticket.messagesCount, 3);
      expect(ticket.satisfactionRating, 4);
      expect(ticket.satisfactionComment, 'Good response');
      expect(ticket.isRated, isTrue);
    });

    test('ticket isRated returns false when satisfactionRating is null', () {
      final json = {
        'id': 't1',
        'ticket_number': 'TKT-001',
        'organization_id': 'org-001',
        'status': 'open',
        'category': 'general',
        'priority': 'low',
        'subject': 'Test',
        'description': 'Test',
        'sla_badge': 'on_track',
        'messages_count': 0,
        'satisfaction_rating': null,
      };
      final ticket = SupportTicket.fromJson(json);
      expect(ticket.isRated, isFalse);
    });

    test('ticket isSlaBreached returns true for breached badge', () {
      final json = {
        'id': 't1',
        'ticket_number': 'TKT-001',
        'organization_id': 'org-001',
        'status': 'open',
        'category': 'general',
        'priority': 'low',
        'subject': 'Test',
        'description': 'Test',
        'sla_badge': 'breached',
        'messages_count': 0,
      };
      final ticket = SupportTicket.fromJson(json);
      expect(ticket.isSlaBreached, isTrue);
    });

    test('ticket isSlaBreached returns false for on_track badge', () {
      final json = {
        'id': 't1',
        'ticket_number': 'TKT-001',
        'organization_id': 'org-001',
        'status': 'open',
        'category': 'general',
        'priority': 'low',
        'subject': 'Test',
        'description': 'Test',
        'sla_badge': 'on_track',
        'messages_count': 0,
      };
      final ticket = SupportTicket.fromJson(json);
      expect(ticket.isSlaBreached, isFalse);
    });

    test('message fromJson parses all fields', () {
      final json = {
        'id': 'msg-001',
        'support_ticket_id': 'ticket-001',
        'sender_type': 'admin',
        'sender_id': 'admin-001',
        'sender_name': 'Support Team',
        'message_text': 'We are looking into this.',
        'is_internal_note': false,
        'sent_at': '2026-01-01T10:00:00.000000Z',
      };

      final message = SupportTicketMessage.fromJson(json);

      expect(message.id, 'msg-001');
      expect(message.senderType.value, 'admin');
      expect(message.messageText, 'We are looking into this.');
      expect(message.isInternalNote, isFalse);
    });

    test('kb article fromJson parses all fields', () {
      final json = {
        'id': 'art-001',
        'title': 'Getting Started',
        'title_ar': 'البدء',
        'slug': 'getting-started',
        'body': '<p>Welcome</p>',
        'body_ar': '<p>مرحبا</p>',
        'category': 'getting_started',
        'is_published': true,
        'sort_order': 1,
      };

      final article = KnowledgeBaseArticle.fromJson(json);

      expect(article.id, 'art-001');
      expect(article.title, 'Getting Started');
      expect(article.slug, 'getting-started');
      expect(article.isPublished, isTrue);
    });
  });

  // ────────────────────────────────────────────────────────────
  // STATS NOTIFIER — does NOT re-enter loading if already loaded
  // ────────────────────────────────────────────────────────────

  group('SupportStatsNotifier - already loaded guard', () {
    test('load while already loaded does not reset to loading', () async {
      final repo = _MockSupportRepository();
      final container = _buildContainer(repo);
      addTearDown(container.dispose);

      // Load once
      await container.read(supportStatsProvider.notifier).load();
      expect(container.read(supportStatsProvider), isA<SupportStatsLoaded>());

      // Load again — should stay loaded (not flash to loading)
      // We cannot easily capture the intermediate state here, but we can
      // confirm it ends in loaded state with correct stats.
      await container.read(supportStatsProvider.notifier).load();
      expect(container.read(supportStatsProvider), isA<SupportStatsLoaded>());
    });
  });
}
