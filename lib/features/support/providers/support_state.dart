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

  const SupportStatsLoaded({
    required this.total,
    required this.open,
    required this.inProgress,
    required this.resolved,
    required this.closed,
  });
  final int total;
  final int open;
  final int inProgress;
  final int resolved;
  final int closed;
}

class SupportStatsError extends SupportStatsState {
  const SupportStatsError(this.message);
  final String message;
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

  const TicketListLoaded({required this.tickets, required this.currentPage, required this.lastPage, required this.total});
  final List<SupportTicket> tickets;
  final int currentPage;
  final int lastPage;
  final int total;

  bool get hasMore => currentPage < lastPage;
}

class TicketListError extends TicketListState {
  const TicketListError(this.message);
  final String message;
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

  const TicketDetailLoaded({required this.ticket, required this.messages});
  final SupportTicket ticket;
  final List<SupportTicketMessage> messages;
}

class TicketDetailError extends TicketDetailState {
  const TicketDetailError(this.message);
  final String message;
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
  const TicketActionSuccess(this.message);
  final String message;
}

class TicketActionError extends TicketActionState {
  const TicketActionError(this.message);
  final String message;
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
  const KbListLoaded(this.articles);
  final List<KnowledgeBaseArticle> articles;
}

class KbListError extends KbListState {
  const KbListError(this.message);
  final String message;
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
  const KbArticleLoaded(this.article);
  final KnowledgeBaseArticle article;
}

class KbArticleError extends KbArticleState {
  const KbArticleError(this.message);
  final String message;
}
