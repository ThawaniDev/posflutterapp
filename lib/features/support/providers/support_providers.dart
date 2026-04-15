import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/support/models/knowledge_base_article.dart';
import 'package:wameedpos/features/support/models/support_ticket.dart';
import 'package:wameedpos/features/support/models/support_ticket_message.dart';
import 'package:wameedpos/features/support/repositories/support_repository.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';

// ─── Support Stats Provider ─────────────────────────────
class SupportStatsNotifier extends StateNotifier<SupportStatsState> {
  final SupportRepository _repository;
  SupportStatsNotifier(this._repository) : super(const SupportStatsInitial());

  Future<void> load() async {
    if (state is! SupportStatsLoaded) state = const SupportStatsLoading();
    try {
      final result = await _repository.getStats();
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = SupportStatsLoaded(
        total: data['total'] as int? ?? 0,
        open: data['open'] as int? ?? 0,
        inProgress: data['in_progress'] as int? ?? 0,
        resolved: data['resolved'] as int? ?? 0,
        closed: data['closed'] as int? ?? 0,
      );
    } catch (e) {
      if (state is! SupportStatsLoaded) state = SupportStatsError(e.toString());
    }
  }
}

final supportStatsProvider = StateNotifierProvider<SupportStatsNotifier, SupportStatsState>((ref) {
  return SupportStatsNotifier(ref.watch(supportRepositoryProvider));
});

// ─── Ticket List Provider ───────────────────────────────
class TicketListNotifier extends StateNotifier<TicketListState> {
  final SupportRepository _repository;
  TicketListNotifier(this._repository) : super(const TicketListInitial());

  String? _status;
  String? _category;
  String? _priority;
  String? _search;

  Future<void> load({String? status, String? category, String? priority, String? search, int page = 1}) async {
    _status = status;
    _category = category;
    _priority = priority;
    _search = search;

    if (state is! TicketListLoaded) state = const TicketListLoading();
    try {
      final result = await _repository.listTickets(
        status: _status,
        category: _category,
        priority: _priority,
        search: _search,
        page: page,
      );
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = (data['data'] as List<dynamic>? ?? []).map((e) => SupportTicket.fromJson(e as Map<String, dynamic>)).toList();
      state = TicketListLoaded(
        tickets: items,
        currentPage: data['current_page'] as int? ?? 1,
        lastPage: data['last_page'] as int? ?? 1,
        total: data['total'] as int? ?? 0,
      );
    } catch (e) {
      if (state is! TicketListLoaded) state = TicketListError(e.toString());
    }
  }

  Future<void> nextPage() async {
    final current = state;
    if (current is TicketListLoaded && current.hasMore) {
      await load(status: _status, category: _category, priority: _priority, search: _search, page: current.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    final current = state;
    if (current is TicketListLoaded && current.currentPage > 1) {
      await load(status: _status, category: _category, priority: _priority, search: _search, page: current.currentPage - 1);
    }
  }
}

final ticketListProvider = StateNotifierProvider<TicketListNotifier, TicketListState>((ref) {
  return TicketListNotifier(ref.watch(supportRepositoryProvider));
});

// ─── Ticket Detail Provider ─────────────────────────────
class TicketDetailNotifier extends StateNotifier<TicketDetailState> {
  final SupportRepository _repository;
  TicketDetailNotifier(this._repository) : super(const TicketDetailInitial());

  Future<void> load(String id) async {
    if (state is! TicketDetailLoaded) state = const TicketDetailLoading();
    try {
      final result = await _repository.getTicket(id);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final ticket = SupportTicket.fromJson(data);
      final rawMessages = data['messages'] as List<dynamic>? ?? [];
      final messages = rawMessages.map((e) => SupportTicketMessage.fromJson(e as Map<String, dynamic>)).toList();
      state = TicketDetailLoaded(ticket: ticket, messages: messages);
    } catch (e) {
      if (state is! TicketDetailLoaded) state = TicketDetailError(e.toString());
    }
  }
}

final ticketDetailProvider = StateNotifierProvider<TicketDetailNotifier, TicketDetailState>((ref) {
  return TicketDetailNotifier(ref.watch(supportRepositoryProvider));
});

// ─── Ticket Action Provider ─────────────────────────────
class TicketActionNotifier extends StateNotifier<TicketActionState> {
  final SupportRepository _repository;
  TicketActionNotifier(this._repository) : super(const TicketActionInitial());

  Future<void> createTicket({
    required String category,
    required String subject,
    required String description,
    String? priority,
  }) async {
    state = const TicketActionLoading();
    try {
      await _repository.createTicket(category: category, subject: subject, description: description, priority: priority);
      state = const TicketActionSuccess('Ticket created successfully');
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  Future<void> addMessage(String ticketId, {required String message}) async {
    state = const TicketActionLoading();
    try {
      await _repository.addMessage(ticketId, message: message);
      state = const TicketActionSuccess('Message sent');
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  Future<void> closeTicket(String id) async {
    state = const TicketActionLoading();
    try {
      await _repository.closeTicket(id);
      state = const TicketActionSuccess('Ticket closed');
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  void reset() => state = const TicketActionInitial();
}

final ticketActionProvider = StateNotifierProvider<TicketActionNotifier, TicketActionState>((ref) {
  return TicketActionNotifier(ref.watch(supportRepositoryProvider));
});

// ─── Knowledge Base List Provider ───────────────────────
class KbListNotifier extends StateNotifier<KbListState> {
  final SupportRepository _repository;
  KbListNotifier(this._repository) : super(const KbListInitial());

  Future<void> load({String? category, String? search}) async {
    if (state is! KbListLoaded) state = const KbListLoading();
    try {
      final result = await _repository.getKbArticles(category: category, search: search);
      final data = result['data'] as List<dynamic>? ?? [];
      final articles = data.map((e) => KnowledgeBaseArticle.fromJson(e as Map<String, dynamic>)).toList();
      state = KbListLoaded(articles);
    } catch (e) {
      if (state is! KbListLoaded) state = KbListError(e.toString());
    }
  }
}

final kbListProvider = StateNotifierProvider<KbListNotifier, KbListState>((ref) {
  return KbListNotifier(ref.watch(supportRepositoryProvider));
});

// ─── Knowledge Base Article Detail Provider ─────────────
class KbArticleNotifier extends StateNotifier<KbArticleState> {
  final SupportRepository _repository;
  KbArticleNotifier(this._repository) : super(const KbArticleInitial());

  Future<void> load(String slug) async {
    if (state is! KbArticleLoaded) state = const KbArticleLoading();
    try {
      final result = await _repository.getKbArticle(slug);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      state = KbArticleLoaded(KnowledgeBaseArticle.fromJson(data));
    } catch (e) {
      if (state is! KbArticleLoaded) state = KbArticleError(e.toString());
    }
  }
}

final kbArticleProvider = StateNotifierProvider<KbArticleNotifier, KbArticleState>((ref) {
  return KbArticleNotifier(ref.watch(supportRepositoryProvider));
});
