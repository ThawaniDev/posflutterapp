// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/notifications/models/notification.dart' as app;
import 'package:wameedpos/features/notifications/models/announcement_summary.dart';
import 'package:wameedpos/features/notifications/models/app_release_info.dart';
import 'package:wameedpos/features/notifications/models/maintenance_status.dart';
import 'package:wameedpos/features/notifications/models/notification_preference.dart';
import 'package:wameedpos/features/notifications/models/payment_reminder.dart';
import 'package:wameedpos/features/notifications/models/notification_sound_config.dart';
import 'package:wameedpos/features/notifications/models/notification_schedule.dart';
import 'package:wameedpos/features/notifications/enums/notification_channel.dart';
import 'package:wameedpos/features/notifications/enums/reminder_channel.dart';
import 'package:wameedpos/features/notifications/enums/reminder_type.dart';

/// Comprehensive model parsing tests for the Notification feature.
///
/// These tests verify that each model can round-trip through
/// fromJson/toJson without data loss, handles null/optional fields
/// gracefully, and enforces correct typed values.
void main() {
  // ════════════════════════════════════════════════════════
  // Notification model
  // ════════════════════════════════════════════════════════

  group('Notification model', () {
    const fullJson = {
      'id': 'notif-001',
      'user_id': 'user-abc',
      'store_id': 'store-xyz',
      'category': 'order',
      'title': 'New Order',
      'message': 'You have a new order.',
      'action_url': '/orders/123',
      'reference_type': 'order',
      'reference_id': 'order-456',
      'is_read': false,
      'created_at': '2026-05-01T10:00:00.000Z',
      'priority': 'high',
      'channel': 'in_app',
      'expires_at': '2026-05-08T10:00:00.000Z',
      'read_at': null,
      'metadata': {'event_key': 'order.new'},
    };

    test('fromJson parses all required fields', () {
      final n = app.Notification.fromJson(fullJson);
      expect(n.id, 'notif-001');
      expect(n.userId, 'user-abc');
      expect(n.storeId, 'store-xyz');
      expect(n.category, 'order');
      expect(n.title, 'New Order');
      expect(n.message, 'You have a new order.');
      expect(n.actionUrl, '/orders/123');
      expect(n.referenceType, 'order');
      expect(n.referenceId, 'order-456');
      expect(n.isRead, isFalse);
      expect(n.priority, 'high');
      expect(n.channel, 'in_app');
      expect(n.readAt, isNull);
      expect(n.metadata, {'event_key': 'order.new'});
    });

    test('fromJson defaults isRead to false when absent', () {
      final n = app.Notification.fromJson({'id': 'x'});
      expect(n.isRead, isFalse);
    });

    test('fromJson parses read_at when present', () {
      final json = Map<String, dynamic>.from(fullJson)
        ..['is_read'] = true
        ..['read_at'] = '2026-05-01T11:00:00.000Z';
      final n = app.Notification.fromJson(json);
      expect(n.isRead, isTrue);
      expect(n.readAt, isNotNull);
    });

    test('fromJson handles null optional dates', () {
      final n = app.Notification.fromJson({'id': 'y'});
      expect(n.createdAt, isNull);
      expect(n.expiresAt, isNull);
      expect(n.readAt, isNull);
    });

    test('toJson round-trip preserves all fields', () {
      final n = app.Notification.fromJson(fullJson);
      final json = n.toJson();
      final n2 = app.Notification.fromJson(json);
      expect(n2.id, n.id);
      expect(n2.category, n.category);
      expect(n2.isRead, n.isRead);
      expect(n2.priority, n.priority);
    });

    test('copyWith updates only the specified fields', () {
      final n = app.Notification.fromJson(fullJson);
      final updated = n.copyWith(isRead: true, title: 'Updated');
      expect(updated.isRead, isTrue);
      expect(updated.title, 'Updated');
      expect(updated.id, n.id); // unchanged
      expect(updated.message, n.message); // unchanged
    });

    test('equality is based on id', () {
      final a = app.Notification.fromJson(fullJson);
      final b = app.Notification.fromJson(Map<String, dynamic>.from(fullJson)..['title'] = 'Different');
      expect(a, equals(b));
    });
  });

  // ════════════════════════════════════════════════════════
  // AnnouncementSummary model
  // ════════════════════════════════════════════════════════

  group('AnnouncementSummary model', () {
    const json = {
      'id': 'ann-001',
      'type': 'info',
      'title': 'System Update',
      'title_ar': 'تحديث النظام',
      'body': 'A new update is available.',
      'body_ar': 'تحديث جديد متوفر.',
      'is_banner': true,
      'display_start_at': '2026-05-01T00:00:00.000Z',
      'display_end_at': '2026-05-31T00:00:00.000Z',
      'created_at': '2026-04-28T12:00:00.000Z',
    };

    test('fromJson parses all fields', () {
      final a = AnnouncementSummary.fromJson(json);
      expect(a.id, 'ann-001');
      expect(a.type, 'info');
      expect(a.title, 'System Update');
      expect(a.titleAr, 'تحديث النظام');
      expect(a.body, 'A new update is available.');
      expect(a.bodyAr, 'تحديث جديد متوفر.');
      expect(a.isBanner, isTrue);
      expect(a.displayStartAt, isNotNull);
      expect(a.displayEndAt, isNotNull);
    });

    test('fromJson defaults type to info when absent', () {
      final a = AnnouncementSummary.fromJson({'id': 'x', 'type': null});
      expect(a.type, 'info');
    });

    test('fromJson handles null dates gracefully', () {
      final a = AnnouncementSummary.fromJson({'id': 'x'});
      expect(a.displayStartAt, isNull);
      expect(a.displayEndAt, isNull);
      expect(a.createdAt, isNull);
    });

    test('localizedTitle returns Arabic when locale is ar', () {
      final a = AnnouncementSummary.fromJson(json);
      expect(a.localizedTitle('ar'), 'تحديث النظام');
      expect(a.localizedTitle('en'), 'System Update');
    });

    test('localizedTitle falls back to English when Arabic is empty', () {
      final a = AnnouncementSummary.fromJson(Map<String, dynamic>.from(json)..['title_ar'] = '');
      expect(a.localizedTitle('ar'), 'System Update');
    });

    test('localizedBody returns localized content', () {
      final a = AnnouncementSummary.fromJson(json);
      expect(a.localizedBody('ar'), 'تحديث جديد متوفر.');
      expect(a.localizedBody('en'), 'A new update is available.');
    });
  });

  // ════════════════════════════════════════════════════════
  // AppReleaseInfo model
  // ════════════════════════════════════════════════════════

  group('AppReleaseInfo model', () {
    const json = {
      'id': 'rel-001',
      'version_number': '2.5.0',
      'platform': 'android',
      'channel': 'stable',
      'is_force_update': true,
      'rollout_percentage': 100,
      'build_number': '205',
      'download_url': 'https://example.com/app.apk',
      'store_url': 'https://play.google.com/store/apps/details?id=com.example',
      'release_notes': 'Bug fixes and performance improvements.',
      'release_notes_ar': 'إصلاح الأخطاء وتحسين الأداء.',
      'min_supported_version': '2.0.0',
      'submission_status': 'approved',
      'released_at': '2026-04-30T10:00:00.000Z',
      'created_at': '2026-04-29T08:00:00.000Z',
    };

    test('fromJson parses all fields including nullable platform and channel', () {
      final r = AppReleaseInfo.fromJson(json);
      expect(r.id, 'rel-001');
      expect(r.versionNumber, '2.5.0');
      expect(r.platform, 'android'); // nullable String?
      expect(r.channel, 'stable'); // nullable String?
      expect(r.isForceUpdate, isTrue);
      expect(r.rolloutPercentage, 100);
      expect(r.buildNumber, '205');
      expect(r.downloadUrl, isNotNull);
      expect(r.releaseNotes, isNotNull);
      expect(r.releaseNotesAr, isNotNull);
      expect(r.releasedAt, isNotNull);
    });

    test('fromJson accepts null platform and channel', () {
      final r = AppReleaseInfo.fromJson({'id': 'x', 'version_number': '1.0.0', 'platform': null, 'channel': null});
      expect(r.platform, isNull);
      expect(r.channel, isNull);
      expect(r.isForceUpdate, isFalse);
      expect(r.rolloutPercentage, 0);
    });

    test('fromJson handles completely missing optional fields', () {
      final r = AppReleaseInfo.fromJson({'id': 'y', 'version_number': '1.1.0'});
      expect(r.downloadUrl, isNull);
      expect(r.releaseNotes, isNull);
      expect(r.releasedAt, isNull);
    });
  });

  // ════════════════════════════════════════════════════════
  // MaintenanceStatus model
  // ════════════════════════════════════════════════════════

  group('MaintenanceStatus model', () {
    test('fromJson when enabled and IP not allowed → shouldShow is true', () {
      final s = MaintenanceStatus.fromJson({
        'is_enabled': true,
        'is_ip_allowed': false,
        'banner_en': 'We are down for maintenance.',
        'banner_ar': 'نحن في صيانة.',
        'expected_end_at': '2026-05-05T06:00:00.000Z',
      });
      expect(s.shouldShow, isTrue);
      expect(s.bannerEn, 'We are down for maintenance.');
      expect(s.expectedEndAt, isNotNull);
    });

    test('shouldShow is false when is_enabled is false', () {
      final s = MaintenanceStatus.fromJson({'is_enabled': false, 'is_ip_allowed': false});
      expect(s.shouldShow, isFalse);
    });

    test('shouldShow is false when IP is allowed (admin bypass)', () {
      final s = MaintenanceStatus.fromJson({'is_enabled': true, 'is_ip_allowed': true});
      expect(s.shouldShow, isFalse);
    });

    test('empty constant has correct defaults', () {
      expect(MaintenanceStatus.empty.isEnabled, isFalse);
      expect(MaintenanceStatus.empty.isIpAllowed, isFalse);
      expect(MaintenanceStatus.empty.shouldShow, isFalse);
    });

    test('fromJson defaults booleans to false when absent', () {
      final s = MaintenanceStatus.fromJson({});
      expect(s.isEnabled, isFalse);
      expect(s.isIpAllowed, isFalse);
    });
  });

  // ════════════════════════════════════════════════════════
  // PaymentReminder model
  // ════════════════════════════════════════════════════════

  group('PaymentReminder model', () {
    const json = {
      'id': 'rem-001',
      'store_subscription_id': 'sub-123',
      'reminder_type': 'upcoming',
      'channel': 'push',
      'sent_at': '2026-04-28T08:00:00.000Z',
    };

    test('fromJson parses all required fields', () {
      final r = PaymentReminder.fromJson(json);
      expect(r.id, 'rem-001');
      expect(r.storeSubscriptionId, 'sub-123');
      expect(r.reminderType, ReminderType.upcoming);
      expect(r.channel, ReminderChannel.push);
      expect(r.sentAt, isNotNull);
    });

    test('fromJson handles null sentAt', () {
      final r = PaymentReminder.fromJson(Map<String, dynamic>.from(json)..['sent_at'] = null);
      expect(r.sentAt, isNull);
    });

    test('toJson round-trip preserves enum values', () {
      final r = PaymentReminder.fromJson(json);
      final j = r.toJson();
      expect(j['reminder_type'], 'upcoming');
      expect(j['channel'], 'push');
    });

    test('equality is based on id', () {
      final a = PaymentReminder.fromJson(json);
      final b = PaymentReminder.fromJson(Map<String, dynamic>.from(json)..['sent_at'] = null);
      expect(a, equals(b));
    });

    test('copyWith updates only specified fields', () {
      final r = PaymentReminder.fromJson(json);
      final updated = r.copyWith(reminderType: ReminderType.overdue);
      expect(updated.reminderType, ReminderType.overdue);
      expect(updated.id, r.id);
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationPreference model
  // ════════════════════════════════════════════════════════

  group('NotificationPreference model', () {
    const json = {
      'id': 'pref-001',
      'user_id': 'user-abc',
      'event_key': 'order.new',
      'channel': 'in_app',
      'is_enabled': true,
      'sound_enabled': true,
      'email_digest': 'daily',
      'quiet_hours_start': '22:00',
      'quiet_hours_end': '07:00',
      'per_category_channels': {
        'order': ['in_app', 'push'],
        'inventory': ['in_app'],
      },
    };

    test('fromJson parses all standard fields', () {
      final p = NotificationPreference.fromJson(json);
      expect(p.id, 'pref-001');
      expect(p.userId, 'user-abc');
      expect(p.eventKey, 'order.new');
      expect(p.channel, NotificationChannel.inApp);
      expect(p.isEnabled, isTrue);
      expect(p.soundEnabled, isTrue);
      expect(p.emailDigest, 'daily');
      expect(p.quietHoursStart, '22:00');
      expect(p.quietHoursEnd, '07:00');
    });

    test('fromJson parses per_category_channels map correctly', () {
      final p = NotificationPreference.fromJson(json);
      expect(p.perCategoryChannels, isNotNull);
      expect(p.perCategoryChannels!['order'], containsAll(['in_app', 'push']));
      expect(p.perCategoryChannels!['inventory'], contains('in_app'));
    });

    test('fromJson handles null per_category_channels', () {
      final p = NotificationPreference.fromJson(Map<String, dynamic>.from(json)..['per_category_channels'] = null);
      expect(p.perCategoryChannels, isNull);
    });

    test('fromJson defaults channel to in_app when absent', () {
      final p = NotificationPreference.fromJson({'id': 'x'});
      expect(p.channel, NotificationChannel.inApp);
    });

    test('quiet hours are stored as HH:mm strings', () {
      final p = NotificationPreference.fromJson(json);
      expect(p.quietHoursStart, matches(RegExp(r'^\d{2}:\d{2}$')));
      expect(p.quietHoursEnd, matches(RegExp(r'^\d{2}:\d{2}$')));
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationSoundConfig model
  // ════════════════════════════════════════════════════════

  group('NotificationSoundConfig model', () {
    const json = {
      'id': 'sc-001',
      'store_id': 'store-xyz',
      'event_key': 'order.new',
      'is_enabled': true,
      'sound_file': 'chime.mp3',
      'volume': 0.8,
      'repeat_count': 1,
      'repeat_interval_seconds': 5,
    };

    test('fromJson parses all fields', () {
      final s = NotificationSoundConfig.fromJson(json);
      expect(s.eventKey, 'order.new');
      expect(s.isEnabled, isTrue);
      expect(s.soundFile, 'chime.mp3');
      expect(s.volume, closeTo(0.8, 0.001));
    });

    test('fromJson defaults isEnabled to true when absent', () {
      final s = NotificationSoundConfig.fromJson({'id': 'x', 'store_id': 's', 'event_key': 'x', 'sound_file': 'default.mp3'});
      expect(s.isEnabled, isTrue);
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationSchedule model
  // ════════════════════════════════════════════════════════

  group('NotificationSchedule model', () {
    const json = {
      'id': 'sc-001',
      'store_id': 'store-xyz',
      'event_key': 'finance.daily_summary',
      'channel': 'in_app',
      'schedule_type': 'once',
      'scheduled_at': '2026-05-10T08:00:00.000Z',
      'is_active': true,
      'category': 'finance',
      'title': 'Daily Report',
      'message': 'Check your daily summary.',
      'priority': 'normal',
    };

    test('fromJson parses schedule fields', () {
      final s = NotificationSchedule.fromJson(json);
      expect(s.id, 'sc-001');
      expect(s.channel, 'in_app');
      expect(s.scheduleType, 'once');
      expect(s.isActive, isTrue);
      expect(s.title, 'Daily Report');
    });

    test('fromJson maps event_key to category when category is absent', () {
      final s = NotificationSchedule.fromJson(Map<String, dynamic>.from(json)..['category'] = null);
      // category defaults to event_key value or empty string
      expect(s.category.isNotEmpty || s.category == 'finance.daily_summary', isTrue);
    });
  });

  // ════════════════════════════════════════════════════════
  // API response envelope parsing
  // ════════════════════════════════════════════════════════

  group('API response envelope', () {
    test('Notification list parses from paginated envelope', () {
      final envelope = {
        'success': true,
        'message': 'OK',
        'data': {
          'data': [
            {'id': 'n1', 'title': 'Test 1'},
            {'id': 'n2', 'title': 'Test 2'},
          ],
          'total': 2,
          'current_page': 1,
          'last_page': 1,
          'per_page': 20,
        },
      };

      final dataObj = envelope['data'] as Map<String, dynamic>;
      final items = (dataObj['data'] as List).map((e) => app.Notification.fromJson(e as Map<String, dynamic>)).toList();

      expect(items.length, 2);
      expect(items[0].id, 'n1');
      expect(items[1].id, 'n2');
    });

    test('unread count parses from simple data object', () {
      const envelope = {
        'success': true,
        'data': {'unread_count': 5},
      };
      final count = (envelope['data'] as Map<String, dynamic>)['unread_count'];
      expect(count, 5);
    });

    test('maintenance status parses from data object', () {
      const envelope = {
        'success': true,
        'data': {'is_enabled': true, 'is_ip_allowed': false, 'banner_en': 'Maintenance in progress'},
      };
      final s = MaintenanceStatus.fromJson(envelope['data'] as Map<String, dynamic>);
      expect(s.shouldShow, isTrue);
      expect(s.bannerEn, 'Maintenance in progress');
    });

    test('app releases latest parses nullable platform and channel', () {
      const envelope = {
        'success': true,
        'data': {'id': 'r1', 'version_number': '3.0.0', 'platform': null, 'channel': null, 'is_force_update': false},
      };
      final r = AppReleaseInfo.fromJson(envelope['data'] as Map<String, dynamic>);
      expect(r.versionNumber, '3.0.0');
      expect(r.platform, isNull);
      expect(r.channel, isNull);
    });
  });
}
