import 'package:wameedpos/features/support/models/knowledge_base_article.dart';
import 'package:wameedpos/features/support/models/support_ticket.dart';
import 'package:wameedpos/features/support/models/support_ticket_message.dart';

// ─── Support Stats State ────────────────────────────────
sealed class SupportStatsState {
  const SupportStatsState();
}

class SupportStatsInitial extends SupportStatsState {
  const SupportStatsInitial();
}

class SupportStatsLoading extends SupportStatsState {
  const SupportStatsLoading();
}

class SupportStatsLoaded extends SupportStatsState {
  final int total;
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;

  const SupportStatsLoaded({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });
}

class SupportStatsError extends SupportStatsState {
  final String message;
  const SupportStatsError(this.message);
}

// ─── Ticket List State ──────────────────────────────────
sealed class TicketListState {
  const TicketListState();
}

class TicketListInitial extends TicketListState {
  const TicketListInitial();
}

class TicketListLoading extends TicketListState {
  const TicketListLoading();
}

class TicketListLoaded extends TicketListState {
  final List<SupportTicket> tickets;
  final int currentPage;
  final int lastPage;
  final int total;

  const TicketListLoaded({required this.tickets, required this.currentPage, required this.lastPage, required this.total});

  bool get hasMore => currentPage < lastPage;
}

class TicketListError extends TicketListState {
  final String message;
  const TicketListError(this.message);
}

// ─── Ticket Detail State ────────────────────────────────
sealed class TicketDetailState {
  const TicketDetailState();
}

class TicketDetailInitial extends TicketDetailState {
  const TicketDetailInitial();
}

class TicketDetailLoading extends TicketDetailState {
  const TicketDetailLoading();
}

class TicketDetailLoaded extends TicketDetailState {
  final SupportTicket ticket;
  final List<SupportTicketMessage> messages;

  const TicketDetailLoaded({required this.ticket, required this.messages});
}

class TicketDetailError extends TicketDetailState {
  final String message;
  const TicketDetailError(this.message);
}

// ─── Ticket Action State ────────────────────────────────
sealed class TicketActionState {
  const TicketActionState();
}

class TicketActionInitial extends TicketActionState {
  const TicketActionInitial();
}

class TicketActionLoading extends TicketActionState {
  const TicketActionLoading();
}

class TicketActionSuccess extends TicketActionState {
  final String message;
  const TicketActionSuccess(this.message);
}

class TicketActionError extends TicketActionState {
  final String message;
  const TicketActionError(this.message);
}

// ─── Knowledge Base List State ──────────────────────────
sealed class KbListState {
  const KbListState();
}

class KbListInitial extends KbListState {
  const KbListInitial();
}

class KbListLoading extends KbListState {
  const KbListLoading();
}

class KbListLoaded extends KbListState {
  final List<KnowledgeBaseArticle> articles;
  const KbListLoaded(this.articles);
}

class KbListError extends KbListState {
  final String message;
  const KbListError(this.message);
}

// ─── Knowledge Base Article Detail State ────────────────
sealed class KbArticleState {
  const KbArticleState();
}

class KbArticleInitial extends KbArticleState {
  const KbArticleInitial();
}

class KbArticleLoading extends KbArticleState {
  const KbArticleLoading();
}

class KbArticleLoaded extends KbArticleState {
  final KnowledgeBaseArticle article;
  const KbArticleLoaded(this.article);
}

class KbArticleError extends KbArticleState {
  final String message;
  const KbArticleError(this.message);
}
