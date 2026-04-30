import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/support/enums/knowledge_base_category.dart';
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

  // ════════════════════════════════════════════════════════
  // SUPPORT TICKET MODEL SERIALIZATION
  // ════════════════════════════════════════════════════════

  group('SupportTicket.fromJson', () {
    final baseJson = <String, dynamic>{
      'id': 'ticket-1',
      'ticket_number': 'TKT-2024-0001',
      'organization_id': 'org-1',
      'store_id': 'store-1',
      'user_id': 'user-1',
      'category': 'technical',
      'priority': 'high',
      'status': 'open',
      'subject': 'Printer not working',
      'description': 'Printer stops after 5 receipts',
      'created_at': '2024-06-01T10:00:00Z',
      'updated_at': '2024-06-01T11:00:00Z',
      'sla_deadline_at': '2024-06-01T18:00:00Z',
      'sla_badge': 'on_track',
      'messages_count': 3,
      'satisfaction_rating': 4,
      'satisfaction_comment': 'Good support, thanks!',
    };

    test('parses all base fields correctly', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.id, 'ticket-1');
      expect(ticket.ticketNumber, 'TKT-2024-0001');
      expect(ticket.category, TicketCategory.technical);
      expect(ticket.priority, TicketPriority.high);
      expect(ticket.status, TicketStatus.open);
      expect(ticket.subject, 'Printer not working');
      expect(ticket.description, 'Printer stops after 5 receipts');
    });

    test('parses new sla_badge field', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.slaBadge, 'on_track');
    });

    test('parses messages_count field', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.messagesCount, 3);
    });

    test('parses satisfaction_rating field', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.satisfactionRating, 4);
    });

    test('parses satisfaction_comment field', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.satisfactionComment, 'Good support, thanks!');
    });

    test('isRated returns true when satisfactionRating is set', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.isRated, isTrue);
    });

    test('isRated returns false when satisfactionRating is null', () {
      final json = Map<String, dynamic>.from(baseJson)..remove('satisfaction_rating');
      final ticket = SupportTicket.fromJson(json);
      expect(ticket.isRated, isFalse);
    });

    test('isSlaBreached returns true when slaBadge is breached', () {
      final json = Map<String, dynamic>.from(baseJson)..[('sla_badge')] = 'breached';
      final ticket = SupportTicket.fromJson(json);
      expect(ticket.isSlaBreached, isTrue);
    });

    test('isSlaBreached returns false when slaBadge is on_track', () {
      final ticket = SupportTicket.fromJson(baseJson);
      expect(ticket.isSlaBreached, isFalse);
    });

    test('handles null optional fields gracefully', () {
      final minimalJson = <String, dynamic>{
        'id': 'ticket-2',
        'ticket_number': 'TKT-2024-0002',
        'organization_id': 'org-1',
        'category': 'general',
        'priority': 'low',
        'status': 'open',
        'subject': 'Minimal',
        'description': 'Desc',
      };
      final ticket = SupportTicket.fromJson(minimalJson);
      expect(ticket.slaBadge, isNull);
      expect(ticket.messagesCount, isNull);
      expect(ticket.satisfactionRating, isNull);
      expect(ticket.satisfactionComment, isNull);
      expect(ticket.isRated, isFalse);
    });

    test('toJson round-trip preserves new fields', () {
      final ticket = SupportTicket.fromJson(baseJson);
      final json = ticket.toJson();
      expect(json['sla_badge'], 'on_track');
      expect(json['messages_count'], 3);
      expect(json['satisfaction_rating'], 4);
      expect(json['satisfaction_comment'], 'Good support, thanks!');
    });

    test('copyWith updates new fields', () {
      final original = SupportTicket.fromJson(baseJson);
      final updated = original.copyWith(satisfactionRating: 5, satisfactionComment: 'Excellent!');
      expect(updated.satisfactionRating, 5);
      expect(updated.satisfactionComment, 'Excellent!');
      // Other fields unchanged
      expect(updated.id, original.id);
      expect(updated.subject, original.subject);
    });
  });

  // ════════════════════════════════════════════════════════
  // KNOWLEDGE BASE CATEGORY ENUM
  // ════════════════════════════════════════════════════════

  group('KnowledgeBaseCategory', () {
    test('has general value', () {
      expect(KnowledgeBaseCategory.general.value, 'general');
    });

    test('includes all expected categories', () {
      final values = KnowledgeBaseCategory.values.map((c) => c.value).toList();
      expect(
        values,
        containsAll(['general', 'getting_started', 'pos_usage', 'inventory', 'delivery', 'billing', 'troubleshooting']),
      );
    });

    test('fromValue works for general', () {
      final cat = KnowledgeBaseCategory.values.firstWhere((c) => c.value == 'general');
      expect(cat, KnowledgeBaseCategory.general);
    });
  });
}
