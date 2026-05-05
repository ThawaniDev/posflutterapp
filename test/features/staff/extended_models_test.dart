// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/staff/enums/staff_document_type.dart';
import 'package:wameedpos/features/staff/models/break_record.dart';
import 'package:wameedpos/features/staff/models/commission_earning.dart';
import 'package:wameedpos/features/staff/models/staff_document.dart';
import 'package:wameedpos/features/staff/models/training_session.dart';

void main() {
  // ═══════════════════════════════════════════════════════════
  // TrainingSession model
  // ═══════════════════════════════════════════════════════════

  group('TrainingSession', () {
    final baseJson = {
      'id': 'ts-001',
      'staff_user_id': 'su-001',
      'store_id': 'store-001',
      'started_at': '2025-01-01T08:00:00.000Z',
      'ended_at': '2025-01-01T10:00:00.000Z',
      'transactions_count': 15,
      'notes': 'Cashier onboarding',
      'duration_minutes': 120,
      'is_active': false,
    };

    test('fromJson parses all fields correctly', () {
      final session = TrainingSession.fromJson(baseJson);

      expect(session.id, 'ts-001');
      expect(session.staffUserId, 'su-001');
      expect(session.storeId, 'store-001');
      expect(session.startedAt, DateTime.parse('2025-01-01T08:00:00.000Z'));
      expect(session.endedAt, DateTime.parse('2025-01-01T10:00:00.000Z'));
      expect(session.transactionsCount, 15);
      expect(session.notes, 'Cashier onboarding');
      expect(session.durationMinutes, 120);
      expect(session.isActive, false);
    });

    test('fromJson handles null optional fields', () {
      final session = TrainingSession.fromJson({
        'id': 'ts-002',
        'staff_user_id': 'su-002',
        'store_id': 'store-001',
        'started_at': '2025-01-01T08:00:00.000Z',
      });

      expect(session.endedAt, isNull);
      expect(session.transactionsCount, isNull);
      expect(session.notes, isNull);
      expect(session.durationMinutes, isNull);
      expect(session.isActive, false); // default
    });

    test('fromJson marks active session when is_active is true', () {
      final json = {...baseJson, 'ended_at': null, 'is_active': true};
      final session = TrainingSession.fromJson(json);

      expect(session.isActive, true);
      expect(session.endedAt, isNull);
    });

    test('toJson roundtrip preserves all fields', () {
      final session = TrainingSession.fromJson(baseJson);
      final encoded = session.toJson();

      expect(encoded['id'], 'ts-001');
      expect(encoded['staff_user_id'], 'su-001');
      expect(encoded['store_id'], 'store-001');
      expect(encoded['transactions_count'], 15);
      expect(encoded['notes'], 'Cashier onboarding');
      expect(encoded['duration_minutes'], 120);
      expect(encoded['is_active'], false);
    });

    test('toJson with null fields emits null values', () {
      final session = TrainingSession(
        id: 'ts-003',
        staffUserId: 'su-003',
        storeId: 'store-001',
        startedAt: DateTime(2025, 1, 1, 8),
      );

      final encoded = session.toJson();
      expect(encoded['ended_at'], isNull);
      expect(encoded['transactions_count'], isNull);
      expect(encoded['notes'], isNull);
      expect(encoded['duration_minutes'], isNull);
    });

    test('copyWith creates new instance with updated fields', () {
      final original = TrainingSession.fromJson(baseJson);
      final updated = original.copyWith(notes: 'Updated notes', isActive: true);

      expect(updated.notes, 'Updated notes');
      expect(updated.isActive, true);
      // Unchanged fields preserved
      expect(updated.id, original.id);
      expect(updated.staffUserId, original.staffUserId);
      expect(updated.transactionsCount, original.transactionsCount);
    });

    test('equality is based on id', () {
      final a = TrainingSession.fromJson(baseJson);
      final b = TrainingSession.fromJson({...baseJson, 'notes': 'Different'});

      expect(a, equals(b)); // same id
    });

    test('different ids are not equal', () {
      final a = TrainingSession.fromJson(baseJson);
      final b = TrainingSession.fromJson({...baseJson, 'id': 'ts-999'});

      expect(a, isNot(equals(b)));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // StaffDocument model
  // ═══════════════════════════════════════════════════════════

  group('StaffDocument', () {
    final baseJson = {
      'id': 'doc-001',
      'staff_user_id': 'su-001',
      'document_type': 'national_id',
      'file_url': 'https://cdn.example.com/docs/id.pdf',
      'expiry_date': '2026-12-31T00:00:00.000Z',
      'uploaded_at': '2025-01-15T10:00:00.000Z',
      'days_until_expiry': 609,
      'is_expired': false,
      'expiring_soon': false,
    };

    test('fromJson parses all fields correctly', () {
      final doc = StaffDocument.fromJson(baseJson);

      expect(doc.id, 'doc-001');
      expect(doc.staffUserId, 'su-001');
      expect(doc.documentType, StaffDocumentType.nationalId);
      expect(doc.fileUrl, 'https://cdn.example.com/docs/id.pdf');
      expect(doc.daysUntilExpiry, 609);
      expect(doc.isExpired, false);
      expect(doc.expiringSoon, false);
    });

    test('fromJson parses all document types', () {
      for (final type in StaffDocumentType.values) {
        final doc = StaffDocument.fromJson({...baseJson, 'id': 'doc-${type.value}', 'document_type': type.value});
        expect(doc.documentType, type);
      }
    });

    test('fromJson handles null optional fields', () {
      final doc = StaffDocument.fromJson({
        'id': 'doc-002',
        'staff_user_id': 'su-002',
        'document_type': 'contract',
        'file_url': 'https://cdn.example.com/docs/contract.pdf',
      });

      expect(doc.expiryDate, isNull);
      expect(doc.uploadedAt, isNull);
      expect(doc.daysUntilExpiry, isNull);
      expect(doc.isExpired, false);
      expect(doc.expiringSoon, false);
    });

    test('fromJson marks expired document', () {
      final doc = StaffDocument.fromJson({...baseJson, 'is_expired': true, 'days_until_expiry': -5, 'expiring_soon': false});

      expect(doc.isExpired, true);
      expect(doc.daysUntilExpiry, -5);
    });

    test('fromJson marks expiring_soon document', () {
      final doc = StaffDocument.fromJson({...baseJson, 'expiring_soon': true, 'days_until_expiry': 14});

      expect(doc.expiringSoon, true);
    });

    test('toJson roundtrip preserves document_type as string', () {
      final doc = StaffDocument.fromJson(baseJson);
      final encoded = doc.toJson();

      expect(encoded['document_type'], 'national_id');
      expect(encoded['file_url'], 'https://cdn.example.com/docs/id.pdf');
    });

    test('copyWith replaces document type', () {
      final original = StaffDocument.fromJson(baseJson);
      final updated = original.copyWith(documentType: StaffDocumentType.visa);

      expect(updated.documentType, StaffDocumentType.visa);
      expect(updated.id, original.id);
    });

    test('equality is based on id', () {
      final a = StaffDocument.fromJson(baseJson);
      final b = StaffDocument.fromJson({...baseJson, 'file_url': 'https://other.url'});

      expect(a, equals(b));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // BreakRecord model
  // ═══════════════════════════════════════════════════════════

  group('BreakRecord', () {
    final baseJson = {
      'id': 'br-001',
      'attendance_record_id': 'att-001',
      'break_start': '2025-01-01T12:00:00.000Z',
      'break_end': '2025-01-01T12:30:00.000Z',
    };

    test('fromJson parses all fields', () {
      final record = BreakRecord.fromJson(baseJson);

      expect(record.id, 'br-001');
      expect(record.attendanceRecordId, 'att-001');
      expect(record.breakStart, DateTime.parse('2025-01-01T12:00:00.000Z'));
      expect(record.breakEnd, DateTime.parse('2025-01-01T12:30:00.000Z'));
    });

    test('fromJson handles active break (null break_end)', () {
      final record = BreakRecord.fromJson({...baseJson, 'break_end': null});

      expect(record.breakEnd, isNull);
    });

    test('toJson roundtrip preserves all fields', () {
      final record = BreakRecord.fromJson(baseJson);
      final encoded = record.toJson();

      expect(encoded['id'], 'br-001');
      expect(encoded['attendance_record_id'], 'att-001');
      expect(encoded['break_end'], isNotNull);
    });

    test('toJson with null break_end emits null', () {
      final record = BreakRecord.fromJson({...baseJson, 'break_end': null});
      final encoded = record.toJson();

      expect(encoded['break_end'], isNull);
    });

    test('copyWith updates fields correctly', () {
      final original = BreakRecord.fromJson(baseJson);
      final breakEnd = DateTime(2025, 1, 1, 13);
      final updated = original.copyWith(breakEnd: breakEnd);

      expect(updated.breakEnd, breakEnd);
      expect(updated.id, original.id);
      expect(updated.attendanceRecordId, original.attendanceRecordId);
    });

    test('equality is based on id', () {
      final a = BreakRecord.fromJson(baseJson);
      final b = BreakRecord.fromJson({...baseJson, 'break_end': null});

      expect(a, equals(b)); // same id
    });

    test('different break records are not equal', () {
      final a = BreakRecord.fromJson(baseJson);
      final b = BreakRecord.fromJson({...baseJson, 'id': 'br-002'});

      expect(a, isNot(equals(b)));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // CommissionEarning model
  // ═══════════════════════════════════════════════════════════

  group('CommissionEarning', () {
    final baseJson = {
      'id': 'ce-001',
      'staff_user_id': 'su-001',
      'order_id': 'ord-001',
      'commission_rule_id': 'cr-001',
      'order_total': '500.00',
      'commission_amount': '25.00',
      'created_at': '2025-01-01T15:00:00.000Z',
    };

    test('fromJson parses all fields', () {
      final earning = CommissionEarning.fromJson(baseJson);

      expect(earning.id, 'ce-001');
      expect(earning.staffUserId, 'su-001');
      expect(earning.orderId, 'ord-001');
      expect(earning.commissionRuleId, 'cr-001');
      expect(earning.orderTotal, 500.0);
      expect(earning.commissionAmount, 25.0);
      expect(earning.createdAt, DateTime.parse('2025-01-01T15:00:00.000Z'));
    });

    test('fromJson parses numeric order_total as double', () {
      final earning = CommissionEarning.fromJson({...baseJson, 'order_total': 750.5, 'commission_amount': 37.525});

      expect(earning.orderTotal, 750.5);
      expect(earning.commissionAmount, 37.525);
    });

    test('fromJson handles null created_at', () {
      final earning = CommissionEarning.fromJson({...baseJson, 'created_at': null});

      expect(earning.createdAt, isNull);
    });

    test('fromJson handles zero commission (complimentary)', () {
      final earning = CommissionEarning.fromJson({...baseJson, 'order_total': '0.00', 'commission_amount': '0.00'});

      expect(earning.orderTotal, 0.0);
      expect(earning.commissionAmount, 0.0);
    });

    test('toJson roundtrip preserves numeric values', () {
      final earning = CommissionEarning.fromJson(baseJson);
      final encoded = earning.toJson();

      expect(encoded['order_total'], 500.0);
      expect(encoded['commission_amount'], 25.0);
    });

    test('copyWith updates commission amount', () {
      final original = CommissionEarning.fromJson(baseJson);
      final updated = original.copyWith(commissionAmount: 30.0);

      expect(updated.commissionAmount, 30.0);
      expect(updated.id, original.id);
      expect(updated.orderTotal, original.orderTotal);
    });

    test('equality is based on id', () {
      final a = CommissionEarning.fromJson(baseJson);
      final b = CommissionEarning.fromJson({...baseJson, 'commission_amount': '99.00'});

      expect(a, equals(b));
    });
  });

  // ═══════════════════════════════════════════════════════════
  // StaffDocumentType enum
  // ═══════════════════════════════════════════════════════════

  group('StaffDocumentType', () {
    test('has the expected values', () {
      expect(
        StaffDocumentType.values.map((e) => e.value).toList(),
        containsAll(['national_id', 'contract', 'certificate', 'visa']),
      );
    });

    test('fromValue parses known values', () {
      expect(StaffDocumentType.fromValue('national_id'), StaffDocumentType.nationalId);
      expect(StaffDocumentType.fromValue('contract'), StaffDocumentType.contract);
      expect(StaffDocumentType.fromValue('certificate'), StaffDocumentType.certificate);
      expect(StaffDocumentType.fromValue('visa'), StaffDocumentType.visa);
    });

    test('fromValue throws on unknown value', () {
      expect(() => StaffDocumentType.fromValue('unknown_doc'), throwsArgumentError);
    });

    test('tryFromValue returns null on unknown', () {
      expect(StaffDocumentType.tryFromValue('unknown'), isNull);
    });

    test('tryFromValue returns null when input is null', () {
      expect(StaffDocumentType.tryFromValue(null), isNull);
    });
  });
}
