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
  final List<Map<String, dynamic>> tickets;
  const TicketListLoaded(this.tickets);
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
  final Map<String, dynamic> ticket;
  const TicketDetailLoaded(this.ticket);
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
