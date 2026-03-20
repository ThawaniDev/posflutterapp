import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/support/repositories/support_repository.dart';
import 'package:thawani_pos/features/support/providers/support_state.dart';

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

  Future<void> load({String? status, String? category, String? priority}) async {
    if (state is! TicketListLoaded) state = const TicketListLoading();
    try {
      final result = await _repository.listTickets(status: status, category: category, priority: priority);
      final data = result['data'] as Map<String, dynamic>? ?? {};
      final items = data['data'] as List<dynamic>? ?? [];
      state = TicketListLoaded(items.cast<Map<String, dynamic>>());
    } catch (e) {
      if (state is! TicketListLoaded) state = TicketListError(e.toString());
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
      state = TicketDetailLoaded(data);
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
