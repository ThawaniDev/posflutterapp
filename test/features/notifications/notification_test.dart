import 'package:flutter_test/flutter_test.dart';
import 'package:thawani_pos/features/notifications/enums/fcm_device_type.dart';
import 'package:thawani_pos/features/notifications/enums/notification_channel.dart';
import 'package:thawani_pos/features/notifications/enums/notification_delivery_status.dart';
import 'package:thawani_pos/features/notifications/enums/notification_provider.dart';
import 'package:thawani_pos/features/notifications/enums/announcement_type.dart';
import 'package:thawani_pos/features/notifications/enums/reminder_channel.dart';
import 'package:thawani_pos/features/notifications/enums/reminder_type.dart';
import 'package:thawani_pos/features/notifications/models/notification.dart';
import 'package:thawani_pos/features/notifications/models/fcm_token.dart';
import 'package:thawani_pos/features/notifications/models/notification_preference.dart';
import 'package:thawani_pos/features/notifications/models/notification_event_log.dart';
import 'package:thawani_pos/features/notifications/providers/notification_state.dart';

void main() {
  // ════════════════════════════════════════════════════════
  // ENUMS
  // ════════════════════════════════════════════════════════

  group('FcmDeviceType', () {
    test('has correct values', () {
      expect(FcmDeviceType.android.value, 'android');
      expect(FcmDeviceType.ios.value, 'ios');
    });

    test('fromValue returns correct enum', () {
      expect(FcmDeviceType.fromValue('android'), FcmDeviceType.android);
      expect(FcmDeviceType.fromValue('ios'), FcmDeviceType.ios);
    });

    test('fromValue throws for invalid value', () {
      expect(() => FcmDeviceType.fromValue('windows'), throwsA(isA<ArgumentError>()));
    });

    test('tryFromValue returns null for invalid', () {
      expect(FcmDeviceType.tryFromValue('windows'), isNull);
      expect(FcmDeviceType.tryFromValue(null), isNull);
      expect(FcmDeviceType.tryFromValue('ios'), FcmDeviceType.ios);
    });
  });

  group('NotificationChannel', () {
    test('has all expected values', () {
      expect(NotificationChannel.values.length, 6);
      expect(NotificationChannel.inApp.value, 'in_app');
      expect(NotificationChannel.push.value, 'push');
      expect(NotificationChannel.sms.value, 'sms');
      expect(NotificationChannel.email.value, 'email');
      expect(NotificationChannel.whatsapp.value, 'whatsapp');
      expect(NotificationChannel.sound.value, 'sound');
    });

    test('fromValue works for all values', () {
      for (final ch in NotificationChannel.values) {
        expect(NotificationChannel.fromValue(ch.value), ch);
      }
    });

    test('tryFromValue returns null for invalid', () {
      expect(NotificationChannel.tryFromValue('telegram'), isNull);
    });
  });

  group('NotificationDeliveryStatus', () {
    test('has all expected values', () {
      expect(NotificationDeliveryStatus.values.length, 4);
      expect(NotificationDeliveryStatus.pending.value, 'pending');
      expect(NotificationDeliveryStatus.sent.value, 'sent');
      expect(NotificationDeliveryStatus.delivered.value, 'delivered');
      expect(NotificationDeliveryStatus.failed.value, 'failed');
    });
  });

  group('NotificationProvider', () {
    test('has all expected values', () {
      expect(NotificationProvider.values.length, 6);
      expect(NotificationProvider.unifonic.value, 'unifonic');
      expect(NotificationProvider.taqnyat.value, 'taqnyat');
      expect(NotificationProvider.msegat.value, 'msegat');
      expect(NotificationProvider.mailgun.value, 'mailgun');
      expect(NotificationProvider.ses.value, 'ses');
      expect(NotificationProvider.smtp.value, 'smtp');
    });
  });

  group('AnnouncementType', () {
    test('has correct values', () {
      expect(AnnouncementType.info.value, 'info');
      expect(AnnouncementType.warning.value, 'warning');
      expect(AnnouncementType.maintenance.value, 'maintenance');
      expect(AnnouncementType.update.value, 'update');
    });
  });

  group('ReminderChannel', () {
    test('has correct values', () {
      expect(ReminderChannel.email.value, 'email');
      expect(ReminderChannel.sms.value, 'sms');
      expect(ReminderChannel.push.value, 'push');
    });
  });

  group('ReminderType', () {
    test('has correct values', () {
      expect(ReminderType.upcoming.value, 'upcoming');
      expect(ReminderType.overdue.value, 'overdue');
    });
  });

  // ════════════════════════════════════════════════════════
  // MODELS
  // ════════════════════════════════════════════════════════

  group('Notification model', () {
    final json = {
      'id': 'notif-1',
      'type': 'order_created',
      'notifiable_type': 'App\\Models\\User',
      'notifiable_id': 'user-1',
      'data': {'order_id': '123', 'amount': 45.5},
      'read_at': '2024-01-15T10:30:00.000Z',
      'created_at': '2024-01-15T10:00:00.000Z',
    };

    test('fromJson', () {
      final notif = Notification.fromJson(json);
      expect(notif.id, 'notif-1');
      expect(notif.type, 'order_created');
      expect(notif.notifiableType, 'App\\Models\\User');
      expect(notif.notifiableId, 'user-1');
      expect(notif.data['order_id'], '123');
      expect(notif.readAt, isNotNull);
      expect(notif.createdAt, isNotNull);
    });

    test('toJson round-trip', () {
      final notif = Notification.fromJson(json);
      final output = notif.toJson();
      expect(output['id'], 'notif-1');
      expect(output['type'], 'order_created');
      expect(output['notifiable_type'], 'App\\Models\\User');
      expect(output['data'], isA<Map>());
    });

    test('fromJson with null dates', () {
      final partial = {
        'id': 'notif-2',
        'type': 'test',
        'notifiable_type': 'User',
        'notifiable_id': 'u1',
        'data': <String, dynamic>{},
        'read_at': null,
        'created_at': null,
      };
      final notif = Notification.fromJson(partial);
      expect(notif.readAt, isNull);
      expect(notif.createdAt, isNull);
    });

    test('equality is by id', () {
      final a = Notification.fromJson(json);
      final b = Notification.fromJson({...json, 'type': 'different'});
      expect(a, equals(b)); // same id
    });

    test('copyWith', () {
      final notif = Notification.fromJson(json);
      final copy = notif.copyWith(type: 'updated');
      expect(copy.type, 'updated');
      expect(copy.id, notif.id);
    });
  });

  group('FcmToken model', () {
    final json = {
      'id': 'token-1',
      'user_id': 'user-1',
      'token': 'fcm_abc123xyz',
      'device_type': 'ios',
      'created_at': '2024-01-15T10:00:00.000Z',
      'updated_at': '2024-01-15T12:00:00.000Z',
    };

    test('fromJson', () {
      final token = FcmToken.fromJson(json);
      expect(token.id, 'token-1');
      expect(token.userId, 'user-1');
      expect(token.token, 'fcm_abc123xyz');
      expect(token.deviceType, FcmDeviceType.ios);
      expect(token.createdAt, isNotNull);
    });

    test('toJson round-trip', () {
      final token = FcmToken.fromJson(json);
      final output = token.toJson();
      expect(output['token'], 'fcm_abc123xyz');
      expect(output['device_type'], 'ios');
    });

    test('equality is by id', () {
      final a = FcmToken.fromJson(json);
      final b = FcmToken.fromJson({...json, 'token': 'different'});
      expect(a, equals(b));
    });

    test('copyWith device type', () {
      final token = FcmToken.fromJson(json);
      final copy = token.copyWith(deviceType: FcmDeviceType.android);
      expect(copy.deviceType, FcmDeviceType.android);
      expect(copy.token, 'fcm_abc123xyz');
    });
  });

  group('NotificationPreference model', () {
    final json = {'id': 'pref-1', 'user_id': 'user-1', 'event_key': 'order_updates', 'channel': 'push', 'is_enabled': true};

    test('fromJson', () {
      final pref = NotificationPreference.fromJson(json);
      expect(pref.id, 'pref-1');
      expect(pref.userId, 'user-1');
      expect(pref.eventKey, 'order_updates');
      expect(pref.channel, NotificationChannel.push);
      expect(pref.isEnabled, true);
    });

    test('toJson round-trip', () {
      final pref = NotificationPreference.fromJson(json);
      final output = pref.toJson();
      expect(output['event_key'], 'order_updates');
      expect(output['channel'], 'push');
      expect(output['is_enabled'], true);
    });

    test('nullable isEnabled', () {
      final partial = {'id': 'pref-2', 'user_id': 'u1', 'event_key': 'test', 'channel': 'in_app', 'is_enabled': null};
      final pref = NotificationPreference.fromJson(partial);
      expect(pref.isEnabled, isNull);
    });

    test('copyWith', () {
      final pref = NotificationPreference.fromJson(json);
      final copy = pref.copyWith(isEnabled: false);
      expect(copy.isEnabled, false);
      expect(copy.eventKey, 'order_updates');
    });
  });

  group('NotificationEventLog model', () {
    final json = {
      'id': 'log-1',
      'notification_id': 'notif-1',
      'channel': 'push',
      'status': 'sent',
      'error_message': null,
      'sent_at': '2024-01-15T10:00:00.000Z',
    };

    test('fromJson', () {
      final log = NotificationEventLog.fromJson(json);
      expect(log.id, 'log-1');
      expect(log.notificationId, 'notif-1');
      expect(log.channel, NotificationChannel.push);
      expect(log.status, NotificationDeliveryStatus.sent);
      expect(log.errorMessage, isNull);
      expect(log.sentAt, isNotNull);
    });

    test('toJson round-trip', () {
      final log = NotificationEventLog.fromJson(json);
      final output = log.toJson();
      expect(output['notification_id'], 'notif-1');
      expect(output['status'], 'sent');
    });

    test('with error message', () {
      final errorJson = {...json, 'status': 'failed', 'error_message': 'Connection timeout'};
      final log = NotificationEventLog.fromJson(errorJson);
      expect(log.status, NotificationDeliveryStatus.failed);
      expect(log.errorMessage, 'Connection timeout');
    });
  });

  // ════════════════════════════════════════════════════════
  // STATES
  // ════════════════════════════════════════════════════════

  group('NotificationListState', () {
    test('initial state', () {
      const state = NotificationListInitial();
      expect(state, isA<NotificationListState>());
    });

    test('loading state', () {
      const state = NotificationListLoading();
      expect(state, isA<NotificationListState>());
    });

    test('loaded state with data', () {
      const state = NotificationListLoaded([
        {'id': '1', 'title': 'Test'},
        {'id': '2', 'title': 'Test 2'},
      ]);
      expect(state.notifications.length, 2);
    });

    test('loaded state empty', () {
      const state = NotificationListLoaded([]);
      expect(state.notifications, isEmpty);
    });

    test('error state', () {
      const state = NotificationListError('Network error');
      expect(state.message, 'Network error');
    });
  });

  group('UnreadCountState', () {
    test('initial state', () {
      const state = UnreadCountInitial();
      expect(state, isA<UnreadCountState>());
    });

    test('loaded with count', () {
      const state = UnreadCountLoaded(5);
      expect(state.count, 5);
    });

    test('loaded with zero', () {
      const state = UnreadCountLoaded(0);
      expect(state.count, 0);
    });

    test('error state', () {
      const state = UnreadCountError('Failed');
      expect(state.message, 'Failed');
    });
  });

  group('NotificationActionState', () {
    test('initial state', () {
      const state = NotificationActionInitial();
      expect(state, isA<NotificationActionState>());
    });

    test('loading state', () {
      const state = NotificationActionLoading();
      expect(state, isA<NotificationActionState>());
    });

    test('success state', () {
      const state = NotificationActionSuccess('Marked as read');
      expect(state.message, 'Marked as read');
    });

    test('error state', () {
      const state = NotificationActionError('Not found');
      expect(state.message, 'Not found');
    });
  });

  group('NotificationPreferencesState', () {
    test('initial state', () {
      const state = NotificationPreferencesInitial();
      expect(state, isA<NotificationPreferencesState>());
    });

    test('loaded with preferences', () {
      const state = NotificationPreferencesLoaded(
        preferences: {
          'order_updates': {'in_app': true, 'push': true},
        },
        quietHoursStart: '22:00',
        quietHoursEnd: '07:00',
      );
      expect(state.preferences['order_updates'], isNotNull);
      expect(state.quietHoursStart, '22:00');
      expect(state.quietHoursEnd, '07:00');
    });

    test('loaded without quiet hours', () {
      const state = NotificationPreferencesLoaded(preferences: {});
      expect(state.quietHoursStart, isNull);
      expect(state.quietHoursEnd, isNull);
    });

    test('error state', () {
      const state = NotificationPreferencesError('Server error');
      expect(state.message, 'Server error');
    });
  });

  group('FcmTokenState', () {
    test('initial state', () {
      const state = FcmTokenInitial();
      expect(state, isA<FcmTokenState>());
    });

    test('loading state', () {
      const state = FcmTokenLoading();
      expect(state, isA<FcmTokenState>());
    });

    test('registered state', () {
      const state = FcmTokenRegistered(token: 'abc123', deviceType: 'ios');
      expect(state.token, 'abc123');
      expect(state.deviceType, 'ios');
    });

    test('removed state', () {
      const state = FcmTokenRemoved();
      expect(state, isA<FcmTokenState>());
    });

    test('error state', () {
      const state = FcmTokenError('Registration failed');
      expect(state.message, 'Registration failed');
    });
  });
}
