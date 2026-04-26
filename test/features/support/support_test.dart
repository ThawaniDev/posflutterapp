import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/support/enums/ticket_status.dart';
import 'package:wameedpos/features/support/enums/ticket_category.dart';
import 'package:wameedpos/features/support/enums/ticket_priority.dart';
import 'package:wameedpos/features/support/enums/ticket_sender_type.dart';
import 'package:wameedpos/features/support/models/support_ticket.dart';
import 'package:wameedpos/features/support/models/support_ticket_message.dart';
import 'package:wameedpos/features/support/providers/support_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('TicketStatus', () {
    test('has correct values', () {
      expect(TicketStatus.open.value, 'open');
      expect(TicketStatus.inProgress.value, 'in_progress');
      expect(TicketStatus.resolved.value, 'resolved');
      expect(TicketStatus.closed.value, 'closed');
    });

    test('has 4 values', () {
      expect(TicketStatus.values.length, 4);
    });

    test('fromValue returns correct enum', () {
      expect(TicketStatus.fromValue('open'), TicketStatus.open);
      expect(TicketStatus.fromValue('in_progress'), TicketStatus.inProgress);
      expect(TicketStatus.fromValue('resolved'), TicketStatus.resolved);
      expect(TicketStatus.fromValue('closed'), TicketStatus.closed);
    });

    test('fromValue throws for invalid value', () {
      expect(() => TicketStatus.fromValue('unknown'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(TicketStatus.tryFromValue('unknown'), isNull);
      expect(TicketStatus.tryFromValue(null), isNull);
    });

    test('tryFromValue returns enum for valid', () {
      expect(TicketStatus.tryFromValue('open'), TicketStatus.open);
    });
  });

  group('TicketCategory', () {
    test('has correct values', () {
      expect(TicketCategory.billing.value, 'billing');
      expect(TicketCategory.technical.value, 'technical');
      expect(TicketCategory.zatca.value, 'zatca');
      expect(TicketCategory.featureRequest.value, 'feature_request');
      expect(TicketCategory.general.value, 'general');
    });

    test('has 5 values', () {
      expect(TicketCategory.values.length, 6);
    });

    test('fromValue works for all values', () {
      for (final c in TicketCategory.values) {
        expect(TicketCategory.fromValue(c.value), c);
      }
    });

    test('fromValue throws for invalid', () {
      expect(() => TicketCategory.fromValue('invalid'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(TicketCategory.tryFromValue('nope'), isNull);
      expect(TicketCategory.tryFromValue(null), isNull);
    });
  });

  group('TicketPriority', () {
    test('has correct values', () {
      expect(TicketPriority.low.value, 'low');
      expect(TicketPriority.medium.value, 'medium');
      expect(TicketPriority.high.value, 'high');
      expect(TicketPriority.critical.value, 'critical');
    });

    test('has 4 values', () {
      expect(TicketPriority.values.length, 4);
    });

    test('fromValue works for all values', () {
      for (final p in TicketPriority.values) {
        expect(TicketPriority.fromValue(p.value), p);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(TicketPriority.tryFromValue('urgent'), isNull);
    });
  });

  group('TicketSenderType', () {
    test('fromValue works for valid values', () {
      for (final s in TicketSenderType.values) {
        expect(TicketSenderType.fromValue(s.value), s);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(TicketSenderType.tryFromValue('bot'), isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // STATE CLASSES
  // ════════════════════════════════════════════════════════

  group('SupportStatsState', () {
    test('SupportStatsInitial is a SupportStatsState', () {
      const state = SupportStatsInitial();
      expect(state, isA<SupportStatsState>());
    });

    test('SupportStatsLoading is a SupportStatsState', () {
      const state = SupportStatsLoading();
      expect(state, isA<SupportStatsState>());
    });

    test('SupportStatsLoaded holds data', () {
      const state = SupportStatsLoaded(total: 10, open: 3, inProgress: 2, resolved: 4, closed: 1);
      expect(state.total, 10);
      expect(state.open, 3);
      expect(state.inProgress, 2);
      expect(state.resolved, 4);
      expect(state.closed, 1);
    });

    test('SupportStatsError holds message', () {
      const state = SupportStatsError('Network error');
      expect(state.message, 'Network error');
    });
  });

  group('TicketListState', () {
    test('TicketListLoaded holds tickets', () {
      const ticket = SupportTicket(
        id: '1',
        ticketNumber: 'TK-001',
        organizationId: 'org-1',
        category: TicketCategory.general,
        priority: TicketPriority.medium,
        status: TicketStatus.open,
        subject: 'Test',
        description: 'Test description',
      );
      const state = TicketListLoaded(tickets: [ticket], currentPage: 1, lastPage: 1, total: 1);
      expect(state.tickets.length, 1);
      expect(state.tickets.first.subject, 'Test');
    });

    test('TicketListError holds message', () {
      const state = TicketListError('Failed to load');
      expect(state.message, 'Failed to load');
    });
  });

  group('TicketDetailState', () {
    test('TicketDetailLoaded holds ticket data', () {
      const ticket = SupportTicket(
        id: 'abc',
        ticketNumber: 'TK-002',
        organizationId: 'org-1',
        category: TicketCategory.general,
        priority: TicketPriority.medium,
        status: TicketStatus.open,
        subject: 'Help',
        description: 'Need help',
      );
      const state = TicketDetailLoaded(ticket: ticket, messages: <SupportTicketMessage>[]);
      expect(state.ticket.id, 'abc');
    });

    test('TicketDetailError holds message', () {
      const state = TicketDetailError('Not found');
      expect(state.message, 'Not found');
    });
  });

  group('TicketActionState', () {
    test('TicketActionSuccess holds message', () {
      const state = TicketActionSuccess('Ticket created');
      expect(state.message, 'Ticket created');
    });

    test('TicketActionError holds message', () {
      const state = TicketActionError('Failed');
      expect(state.message, 'Failed');
    });

    test('all states extend TicketActionState', () {
      expect(const TicketActionInitial(), isA<TicketActionState>());
      expect(const TicketActionLoading(), isA<TicketActionState>());
      expect(const TicketActionSuccess('ok'), isA<TicketActionState>());
      expect(const TicketActionError('err'), isA<TicketActionState>());
    });
  });
}
