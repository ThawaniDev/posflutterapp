import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/auth/enums/auth_method.dart';
import 'package:wameedpos/core/enums/activity_entity_type.dart';
import 'package:wameedpos/features/staff/enums/commission_rule_type.dart';
import 'package:wameedpos/features/staff/enums/employment_type.dart';
import 'package:wameedpos/features/staff/enums/salary_type.dart';
import 'package:wameedpos/features/staff/enums/shift_schedule_status.dart';
import 'package:wameedpos/features/staff/enums/staff_status.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/commission_rule.dart';
import 'package:wameedpos/features/staff/models/shift_schedule.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_activity_log.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // Enums
  // ═══════════════════════════════════════════════════════════

  group('StaffStatus enum', () {
    test('has correct values', () {
      expect(StaffStatus.values.length, 3);
      expect(StaffStatus.active.value, 'active');
      expect(StaffStatus.inactive.value, 'inactive');
      expect(StaffStatus.onLeave.value, 'on_leave');
    });

    test('fromValue parses correctly', () {
      expect(StaffStatus.fromValue('active'), StaffStatus.active);
      expect(StaffStatus.fromValue('on_leave'), StaffStatus.onLeave);
    });

    test('fromValue throws on invalid', () {
      expect(() => StaffStatus.fromValue('invalid'), throwsArgumentError);
    });

    test('tryFromValue returns null on invalid', () {
      expect(StaffStatus.tryFromValue('invalid'), isNull);
      expect(StaffStatus.tryFromValue(null), isNull);
    });
  });

  group('EmploymentType enum', () {
    test('has correct values', () {
      expect(EmploymentType.values.length, 3);
      expect(EmploymentType.fullTime.value, 'full_time');
      expect(EmploymentType.partTime.value, 'part_time');
      expect(EmploymentType.contractor.value, 'contractor');
    });

    test('fromValue parses correctly', () {
      expect(EmploymentType.fromValue('full_time'), EmploymentType.fullTime);
    });
  });

  group('SalaryType enum', () {
    test('has correct values', () {
      expect(SalaryType.values.length, 3);
      expect(SalaryType.hourly.value, 'hourly');
      expect(SalaryType.monthly.value, 'monthly');
      expect(SalaryType.commissionOnly.value, 'commission_only');
    });
  });

  group('ShiftScheduleStatus enum', () {
    test('has correct values', () {
      expect(ShiftScheduleStatus.values.length, 4);
      expect(ShiftScheduleStatus.scheduled.value, 'scheduled');
      expect(ShiftScheduleStatus.completed.value, 'completed');
      expect(ShiftScheduleStatus.missed.value, 'missed');
      expect(ShiftScheduleStatus.swapped.value, 'swapped');
    });
  });

  group('CommissionRuleType enum', () {
    test('has correct values', () {
      expect(CommissionRuleType.values.length, 3);
      expect(CommissionRuleType.flatPercentage.value, 'flat_percentage');
      expect(CommissionRuleType.tiered.value, 'tiered');
      expect(CommissionRuleType.perItem.value, 'per_item');
    });
  });

  group('AuthMethod enum', () {
    test('has correct values', () {
      expect(AuthMethod.pin.value, 'pin');
      expect(AuthMethod.nfc.value, 'nfc');
      expect(AuthMethod.biometric.value, 'biometric');
    });

    test('fromValue works', () {
      expect(AuthMethod.fromValue('pin'), AuthMethod.pin);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // Models
  // ═══════════════════════════════════════════════════════════

  group('StaffUser model', () {
    final json = {
      'id': 'staff-1',
      'store_id': 'store-1',
      'first_name': 'John',
      'last_name': 'Doe',
      'email': 'john@example.com',
      'phone': '+968 91234567',
      'photo_url': null,
      'national_id': 'ID123',
      'pin_hash': null,
      'nfc_badge_uid': 'NFC-001',
      'biometric_enabled': true,
      'employment_type': 'full_time',
      'salary_type': 'monthly',
      'hourly_rate': null,
      'hire_date': '2024-01-15',
      'termination_date': null,
      'status': 'active',
      'language_preference': 'en',
      'created_at': '2024-01-15T10:00:00.000Z',
      'updated_at': '2024-06-01T08:00:00.000Z',
    };

    test('fromJson parses correctly', () {
      final staff = StaffUser.fromJson(json);
      expect(staff.id, 'staff-1');
      expect(staff.storeId, 'store-1');
      expect(staff.firstName, 'John');
      expect(staff.lastName, 'Doe');
      expect(staff.email, 'john@example.com');
      expect(staff.employmentType, EmploymentType.fullTime);
      expect(staff.salaryType, SalaryType.monthly);
      expect(staff.status, StaffStatus.active);
      expect(staff.nfcBadgeUid, 'NFC-001');
      expect(staff.biometricEnabled, true);
    });

    test('toJson roundtrip', () {
      final staff = StaffUser.fromJson(json);
      final output = staff.toJson();
      expect(output['id'], 'staff-1');
      expect(output['first_name'], 'John');
      expect(output['employment_type'], 'full_time');
      expect(output['status'], 'active');
    });

    test('fromJson handles null optional fields', () {
      final minimal = {
        'id': 'staff-2',
        'store_id': 'store-1',
        'first_name': 'Jane',
        'last_name': 'Smith',
        'pin_hash': null,
        'employment_type': 'part_time',
        'salary_type': 'hourly',
        'hourly_rate': 15.50,
        'hire_date': '2024-03-01',
      };
      final staff = StaffUser.fromJson(minimal);
      expect(staff.firstName, 'Jane');
      expect(staff.email, isNull);
      expect(staff.status, isNull);
      expect(staff.hourlyRate, 15.50);
    });

    test('copyWith creates new instance', () {
      final staff = StaffUser.fromJson(json);
      final updated = staff.copyWith(firstName: 'Jane', status: StaffStatus.onLeave);
      expect(updated.firstName, 'Jane');
      expect(updated.status, StaffStatus.onLeave);
      expect(updated.lastName, 'Doe'); // unchanged
    });

    test('equality', () {
      final a = StaffUser.fromJson(json);
      final b = StaffUser.fromJson(json);
      expect(a, equals(b));
    });
  });

  group('AttendanceRecord model', () {
    final json = {
      'id': 'att-1',
      'staff_user_id': 'staff-1',
      'store_id': 'store-1',
      'clock_in_at': '2024-06-01T08:00:00.000Z',
      'clock_out_at': '2024-06-01T16:30:00.000Z',
      'break_minutes': 30,
      'scheduled_shift_id': 'shift-1',
      'overtime_minutes': 30,
      'notes': 'Normal day',
      'auth_method': 'pin',
      'created_at': '2024-06-01T08:00:00.000Z',
    };

    test('fromJson parses correctly', () {
      final record = AttendanceRecord.fromJson(json);
      expect(record.id, 'att-1');
      expect(record.staffUserId, 'staff-1');
      expect(record.breakMinutes, 30);
      expect(record.overtimeMinutes, 30);
      expect(record.authMethod, AuthMethod.pin);
      expect(record.clockOutAt, isNotNull);
    });

    test('fromJson with null clock_out (active session)', () {
      final active = Map<String, dynamic>.from(json);
      active['clock_out_at'] = null;
      active['break_minutes'] = null;
      active['overtime_minutes'] = null;
      final record = AttendanceRecord.fromJson(active);
      expect(record.clockOutAt, isNull);
      expect(record.breakMinutes, isNull);
    });

    test('toJson roundtrip', () {
      final record = AttendanceRecord.fromJson(json);
      final output = record.toJson();
      expect(output['staff_user_id'], 'staff-1');
      expect(output['auth_method'], 'pin');
    });
  });

  group('ShiftSchedule model', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'shift-1',
        'store_id': 'store-1',
        'staff_user_id': 'staff-1',
        'shift_template_id': 'template-1',
        'date': '2024-06-01',
        'actual_start': '2024-06-01T08:05:00.000Z',
        'actual_end': '2024-06-01T16:00:00.000Z',
        'status': 'completed',
        'swapped_with_id': null,
      };
      final shift = ShiftSchedule.fromJson(json);
      expect(shift.id, 'shift-1');
      expect(shift.status, ShiftScheduleStatus.completed);
      expect(shift.actualStart, isNotNull);
      expect(shift.swappedWithId, isNull);
    });

    test('fromJson parses scheduled status', () {
      final json = {
        'id': 'shift-2',
        'store_id': 'store-1',
        'staff_user_id': 'staff-1',
        'shift_template_id': 'template-1',
        'date': '2024-06-02',
        'status': 'scheduled',
      };
      final shift = ShiftSchedule.fromJson(json);
      expect(shift.status, ShiftScheduleStatus.scheduled);
      expect(shift.actualStart, isNull);
    });

    test('toJson roundtrip', () {
      final json = {
        'id': 'shift-1',
        'store_id': 'store-1',
        'staff_user_id': 'staff-1',
        'shift_template_id': 'template-1',
        'date': '2024-06-01',
        'status': 'completed',
      };
      final shift = ShiftSchedule.fromJson(json);
      final output = shift.toJson();
      expect(output['status'], 'completed');
      expect(output['shift_template_id'], 'template-1');
    });
  });

  group('ShiftTemplate model', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'tmpl-1',
        'store_id': 'store-1',
        'name': 'Morning Shift',
        'start_time': '08:00',
        'end_time': '16:00',
        'color': '#FF5733',
      };
      final template = ShiftTemplate.fromJson(json);
      expect(template.id, 'tmpl-1');
      expect(template.name, 'Morning Shift');
      expect(template.startTime, '08:00');
      expect(template.endTime, '16:00');
      expect(template.color, '#FF5733');
    });

    test('fromJson with null color', () {
      final json = {'id': 'tmpl-2', 'store_id': 'store-1', 'name': 'Night Shift', 'start_time': '22:00', 'end_time': '06:00'};
      final template = ShiftTemplate.fromJson(json);
      expect(template.color, isNull);
    });
  });

  group('CommissionRule model', () {
    test('fromJson parses flat_percentage', () {
      final json = {
        'id': 'rule-1',
        'store_id': 'store-1',
        'staff_user_id': 'staff-1',
        'type': 'flat_percentage',
        'percentage': 5.0,
        'tiers_json': null,
        'product_category_id': null,
        'is_active': true,
      };
      final rule = CommissionRule.fromJson(json);
      expect(rule.type, CommissionRuleType.flatPercentage);
      expect(rule.percentage, 5.0);
      expect(rule.isActive, true);
    });

    test('fromJson parses tiered type', () {
      final json = {
        'id': 'rule-2',
        'store_id': 'store-1',
        'type': 'tiered',
        'percentage': 0.0,
        'tiers_json': {'tier1': 5, 'tier2': 10},
        'is_active': true,
      };
      final rule = CommissionRule.fromJson(json);
      expect(rule.type, CommissionRuleType.tiered);
      expect(rule.tiersJson, isNotNull);
    });
  });

  group('StaffActivityLog model', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 'log-1',
        'staff_user_id': 'staff-1',
        'store_id': 'store-1',
        'action': 'created_order',
        'entity_type': 'order',
        'entity_id': 'order-1',
        'details': {'order_total': 150.0},
        'ip_address': '192.168.1.1',
        'created_at': '2024-06-01T10:00:00.000Z',
      };
      final log = StaffActivityLog.fromJson(json);
      expect(log.id, 'log-1');
      expect(log.action, 'created_order');
      expect(log.entityType, ActivityEntityType.order);
      expect(log.details?['order_total'], 150.0);
    });

    test('fromJson handles null optionals', () {
      final json = {'id': 'log-2', 'staff_user_id': 'staff-1', 'store_id': 'store-1', 'action': 'login'};
      final log = StaffActivityLog.fromJson(json);
      expect(log.entityType, isNull);
      expect(log.entityId, isNull);
      expect(log.details, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════
  // States
  // ═══════════════════════════════════════════════════════════

  group('StaffListState', () {
    test('initial state', () {
      const state = StaffListInitial();
      expect(state, isA<StaffListState>());
    });

    test('loading state', () {
      const state = StaffListLoading();
      expect(state, isA<StaffListState>());
    });

    test('loaded state', () {
      const state = StaffListLoaded(staff: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.staff, isEmpty);
      expect(state.hasMore, false);
    });

    test('loaded state with hasMore', () {
      const state = StaffListLoaded(staff: [], total: 50, currentPage: 1, lastPage: 3, hasMore: true);
      expect(state.hasMore, true);
    });

    test('copyWith', () {
      const state = StaffListLoaded(staff: [], total: 10, currentPage: 1, lastPage: 2);
      final updated = state.copyWith(currentPage: 2, hasMore: false);
      expect(updated.currentPage, 2);
      expect(updated.total, 10); // unchanged
    });

    test('error state', () {
      const state = StaffListError(message: 'Network error');
      expect(state.message, 'Network error');
    });
  });

  group('StaffDetailState', () {
    test('initial state', () {
      expect(const StaffDetailInitial(), isA<StaffDetailState>());
    });

    test('loading state', () {
      expect(const StaffDetailLoading(), isA<StaffDetailState>());
    });

    test('saving state', () {
      expect(const StaffDetailSaving(), isA<StaffDetailState>());
    });

    test('error state', () {
      const state = StaffDetailError(message: 'Not found');
      expect(state.message, 'Not found');
    });
  });

  group('AttendanceState', () {
    test('initial state', () {
      expect(const AttendanceInitial(), isA<AttendanceState>());
    });

    test('loaded state', () {
      const state = AttendanceLoaded(records: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.records, isEmpty);
    });

    test('copyWith', () {
      const state = AttendanceLoaded(records: [], total: 5, currentPage: 1, lastPage: 1);
      final updated = state.copyWith(total: 10);
      expect(updated.total, 10);
      expect(updated.currentPage, 1);
    });
  });

  group('ClockActionState', () {
    test('idle state', () {
      expect(const ClockActionIdle(), isA<ClockActionState>());
    });

    test('loading state', () {
      expect(const ClockActionLoading(), isA<ClockActionState>());
    });

    test('error state', () {
      const state = ClockActionError(message: 'Already clocked in');
      expect(state.message, 'Already clocked in');
    });
  });

  group('ShiftState', () {
    test('initial state', () {
      expect(const ShiftInitial(), isA<ShiftState>());
    });

    test('loaded state with templates', () {
      const state = ShiftLoaded(shifts: [], templates: [], total: 0, currentPage: 1, lastPage: 1);
      expect(state.shifts, isEmpty);
      expect(state.templates, isEmpty);
    });

    test('copyWith', () {
      const state = ShiftLoaded(shifts: [], templates: [], total: 5, currentPage: 1, lastPage: 2, hasMore: true);
      final updated = state.copyWith(total: 3, hasMore: false);
      expect(updated.total, 3);
      expect(updated.hasMore, false);
    });

    test('error state', () {
      const state = ShiftError(message: 'Conflict');
      expect(state.message, 'Conflict');
    });
  });

  group('CommissionState', () {
    test('initial state', () {
      expect(const CommissionInitial(), isA<CommissionState>());
    });

    test('loaded state', () {
      const state = CommissionLoaded(summary: {'total_earnings': 500.0, 'total_orders': 10, 'avg_per_order': 50.0});
      expect(state.summary['total_earnings'], 500.0);
      expect(state.summary['total_orders'], 10);
    });

    test('error state', () {
      const state = CommissionError(message: 'Access denied');
      expect(state.message, 'Access denied');
    });
  });
}
