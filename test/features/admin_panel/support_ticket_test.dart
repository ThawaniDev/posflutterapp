import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/features/admin_panel/providers/admin_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════════
  //  P10 — SUPPORT TICKET SYSTEM  Tests
  // ═══════════════════════════════════════════════════════════════════════════

  group('P10 Endpoints', () {
    test('adminSupportTickets is correct', () {
      expect(ApiEndpoints.adminSupportTickets, '/admin/support/tickets');
    });

    test('adminSupportTicketById returns correct path', () {
      expect(ApiEndpoints.adminSupportTicketById('abc'), '/admin/support/tickets/abc');
    });

    test('adminSupportTicketAssign returns correct path', () {
      expect(ApiEndpoints.adminSupportTicketAssign('t1'), '/admin/support/tickets/t1/assign');
    });

    test('adminSupportTicketStatus returns correct path', () {
      expect(ApiEndpoints.adminSupportTicketStatus('t1'), '/admin/support/tickets/t1/status');
    });

    test('adminTicketMessages returns correct path', () {
      expect(ApiEndpoints.adminTicketMessages('t1'), '/admin/support/tickets/t1/messages');
    });

    test('adminCannedResponses is correct', () {
      expect(ApiEndpoints.adminCannedResponses, '/admin/support/canned-responses');
    });

    test('adminCannedResponseById returns correct path', () {
      expect(ApiEndpoints.adminCannedResponseById('r1'), '/admin/support/canned-responses/r1');
    });

    test('adminCannedResponseToggle returns correct path', () {
      expect(ApiEndpoints.adminCannedResponseToggle('r1'), '/admin/support/canned-responses/r1/toggle');
    });
  });

  // ─── Ticket State Classes ─────────────────────────────────────

  group('P10 TicketListState', () {
    test('TicketListInitial is default', () {
      const state = TicketListInitial();
      expect(state, isA<TicketListState>());
    });
    test('TicketListLoading', () {
      expect(const TicketListLoading(), isA<TicketListState>());
    });
    test('TicketListLoaded holds data', () {
      const state = TicketListLoaded({'total': 5});
      expect(state.data['total'], 5);
    });
    test('TicketListError holds message', () {
      const state = TicketListError('fail');
      expect(state.message, 'fail');
    });
  });

  group('P10 TicketDetailState', () {
    test('TicketDetailInitial', () {
      expect(const TicketDetailInitial(), isA<TicketDetailState>());
    });
    test('TicketDetailLoading', () {
      expect(const TicketDetailLoading(), isA<TicketDetailState>());
    });
    test('TicketDetailLoaded holds data', () {
      const state = TicketDetailLoaded({'id': '1'});
      expect(state.data['id'], '1');
    });
    test('TicketDetailError holds message', () {
      const state = TicketDetailError('not found');
      expect(state.message, 'not found');
    });
  });

  group('P10 TicketActionState', () {
    test('TicketActionInitial', () {
      expect(const TicketActionInitial(), isA<TicketActionState>());
    });
    test('TicketActionLoading', () {
      expect(const TicketActionLoading(), isA<TicketActionState>());
    });
    test('TicketActionSuccess holds data', () {
      const state = TicketActionSuccess({'status': 'open'});
      expect(state.data['status'], 'open');
    });
    test('TicketActionError holds message', () {
      const state = TicketActionError('err');
      expect(state.message, 'err');
    });
  });

  group('P10 TicketMessageListState', () {
    test('TicketMessageListInitial', () {
      expect(const TicketMessageListInitial(), isA<TicketMessageListState>());
    });
    test('TicketMessageListLoading', () {
      expect(const TicketMessageListLoading(), isA<TicketMessageListState>());
    });
    test('TicketMessageListLoaded holds data', () {
      const state = TicketMessageListLoaded({'data': []});
      expect(state.data['data'], isEmpty);
    });
    test('TicketMessageListError holds message', () {
      const state = TicketMessageListError('err');
      expect(state.message, 'err');
    });
  });

  group('P10 TicketMessageActionState', () {
    test('TicketMessageActionInitial', () {
      expect(const TicketMessageActionInitial(), isA<TicketMessageActionState>());
    });
    test('TicketMessageActionLoading', () {
      expect(const TicketMessageActionLoading(), isA<TicketMessageActionState>());
    });
    test('TicketMessageActionSuccess holds data', () {
      const state = TicketMessageActionSuccess({'id': 'm1'});
      expect(state.data['id'], 'm1');
    });
    test('TicketMessageActionError holds message', () {
      const state = TicketMessageActionError('x');
      expect(state.message, 'x');
    });
  });

  // ─── Canned Response State Classes ─────────────────────────────

  group('P10 CannedResponseListState', () {
    test('CannedResponseListInitial', () {
      expect(const CannedResponseListInitial(), isA<CannedResponseListState>());
    });
    test('CannedResponseListLoading', () {
      expect(const CannedResponseListLoading(), isA<CannedResponseListState>());
    });
    test('CannedResponseListLoaded holds data', () {
      const state = CannedResponseListLoaded({'data': []});
      expect(state.data['data'], isEmpty);
    });
    test('CannedResponseListError holds message', () {
      const state = CannedResponseListError('err');
      expect(state.message, 'err');
    });
  });

  group('P10 CannedResponseDetailState', () {
    test('CannedResponseDetailInitial', () {
      expect(const CannedResponseDetailInitial(), isA<CannedResponseDetailState>());
    });
    test('CannedResponseDetailLoading', () {
      expect(const CannedResponseDetailLoading(), isA<CannedResponseDetailState>());
    });
    test('CannedResponseDetailLoaded holds data', () {
      const state = CannedResponseDetailLoaded({'title': 'Hi'});
      expect(state.data['title'], 'Hi');
    });
    test('CannedResponseDetailError holds message', () {
      const state = CannedResponseDetailError('nf');
      expect(state.message, 'nf');
    });
  });

  group('P10 CannedResponseActionState', () {
    test('CannedResponseActionInitial', () {
      expect(const CannedResponseActionInitial(), isA<CannedResponseActionState>());
    });
    test('CannedResponseActionLoading', () {
      expect(const CannedResponseActionLoading(), isA<CannedResponseActionState>());
    });
    test('CannedResponseActionSuccess holds data', () {
      const state = CannedResponseActionSuccess({'is_active': false});
      expect(state.data['is_active'], false);
    });
    test('CannedResponseActionError holds message', () {
      const state = CannedResponseActionError('err');
      expect(state.message, 'err');
    });
  });

  // ─── Endpoint Integrity ─────────────────────────────────────

  group('P10 Endpoint Integrity', () {
    test('all ticket endpoints start with /admin/support/tickets', () {
      expect(ApiEndpoints.adminSupportTickets, startsWith('/admin/support/tickets'));
      expect(ApiEndpoints.adminSupportTicketById('x'), startsWith('/admin/support/tickets'));
      expect(ApiEndpoints.adminSupportTicketAssign('x'), startsWith('/admin/support/tickets'));
      expect(ApiEndpoints.adminSupportTicketStatus('x'), startsWith('/admin/support/tickets'));
      expect(ApiEndpoints.adminTicketMessages('x'), startsWith('/admin/support/tickets'));
    });

    test('all canned response endpoints start with /admin/support/canned-responses', () {
      expect(ApiEndpoints.adminCannedResponses, startsWith('/admin/support/canned-responses'));
      expect(ApiEndpoints.adminCannedResponseById('x'), startsWith('/admin/support/canned-responses'));
      expect(ApiEndpoints.adminCannedResponseToggle('x'), startsWith('/admin/support/canned-responses'));
    });

    test('ticket id paths contain the id', () {
      expect(ApiEndpoints.adminSupportTicketById('abc123'), contains('abc123'));
      expect(ApiEndpoints.adminSupportTicketAssign('abc123'), contains('abc123'));
      expect(ApiEndpoints.adminSupportTicketStatus('abc123'), contains('abc123'));
      expect(ApiEndpoints.adminTicketMessages('abc123'), contains('abc123'));
    });

    test('canned response id paths contain the id', () {
      expect(ApiEndpoints.adminCannedResponseById('cr1'), contains('cr1'));
      expect(ApiEndpoints.adminCannedResponseToggle('cr1'), contains('cr1'));
    });
  });

  // ─── Edge Cases ─────────────────────────────────────

  group('P10 Edge Cases', () {
    test('TicketListLoaded with empty list', () {
      const state = TicketListLoaded({'data': [], 'total': 0});
      expect((state.data['data'] as List).isEmpty, true);
    });

    test('CannedResponseListLoaded with multiple items', () {
      const state = CannedResponseListLoaded({
        'data': [
          {'id': '1', 'title': 'A'},
          {'id': '2', 'title': 'B'},
        ],
      });
      expect((state.data['data'] as List).length, 2);
    });

    test('endpoints with special characters in id', () {
      final path = ApiEndpoints.adminSupportTicketById('ticket-with-dash');
      expect(path, '/admin/support/tickets/ticket-with-dash');
    });
  });
}
