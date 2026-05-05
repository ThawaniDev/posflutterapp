// ignore_for_file: lines_longer_than_80_chars

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';
import 'package:wameedpos/features/notifications/repositories/notification_repository.dart';
import 'package:wameedpos/features/notifications/data/remote/notification_api_service.dart';

// ─── Manual fake for NotificationRepository ──────────────
//
// Overrides only the methods called by each provider under test.
// All other methods throw [UnimplementedError] by default.
class FakeNotificationRepository extends NotificationRepository {
  FakeNotificationRepository() : super(_noopApiService());

  // Callable overrides — configure before each test.
  Future<Map<String, dynamic>> Function()? onListNotifications;
  Future<Map<String, dynamic>> Function()? onGetUnreadCount;
  Future<Map<String, dynamic>> Function()? onGetUnreadCountByCategory;
  Future<Map<String, dynamic>> Function(String id)? onMarkAsRead;
  Future<Map<String, dynamic>> Function()? onMarkAllAsRead;
  Future<Map<String, dynamic>> Function(String id)? onDeleteNotification;
  Future<Map<String, dynamic>> Function()? onGetPreferences;
  Future<Map<String, dynamic>> Function({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
    String? emailDigest,
  })? onUpdatePreferences;
  Future<Map<String, dynamic>> Function({
    required String token,
    required String deviceType,
  })? onRegisterFcmToken;
  Future<Map<String, dynamic>> Function(String token)? onRemoveFcmToken;
  Future<Map<String, dynamic>> Function()? onGetDeliveryLogs;
  Future<Map<String, dynamic>> Function()? onGetSoundConfigs;
  Future<Map<String, dynamic>> Function()? onGetSchedules;
  Future<Map<String, dynamic>> Function()? onGetStats;

  @override
  Future<Map<String, dynamic>> listNotifications({
    String? category,
    bool? isRead,
    int? limit,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) =>
      onListNotifications?.call() ??
          (throw UnimplementedError('listNotifications not configured'));

  @override
  Future<Map<String, dynamic>> getUnreadCount() =>
      onGetUnreadCount?.call() ??
          (throw UnimplementedError('getUnreadCount not configured'));

  @override
  Future<Map<String, dynamic>> getUnreadCountByCategory() =>
      onGetUnreadCountByCategory?.call() ??
          (throw UnimplementedError('getUnreadCountByCategory not configured'));

  @override
  Future<Map<String, dynamic>> markAsRead(String id) =>
      onMarkAsRead?.call(id) ??
          (throw UnimplementedError('markAsRead not configured'));

  @override
  Future<Map<String, dynamic>> markAllAsRead() =>
      onMarkAllAsRead?.call() ??
          (throw UnimplementedError('markAllAsRead not configured'));

  @override
  Future<Map<String, dynamic>> deleteNotification(String id) =>
      onDeleteNotification?.call(id) ??
          (throw UnimplementedError('deleteNotification not configured'));

  @override
  Future<Map<String, dynamic>> getPreferences() =>
      onGetPreferences?.call() ??
          (throw UnimplementedError('getPreferences not configured'));

  @override
  Future<Map<String, dynamic>> updatePreferences({
    Map<String, dynamic>? preferences,
    String? quietHoursStart,
    String? quietHoursEnd,
    bool? soundEnabled,
    String? emailDigest,
  }) =>
      onUpdatePreferences?.call(
        preferences: preferences,
        quietHoursStart: quietHoursStart,
        quietHoursEnd: quietHoursEnd,
        soundEnabled: soundEnabled,
        emailDigest: emailDigest,
      ) ??
          (throw UnimplementedError('updatePreferences not configured'));

  @override
  Future<Map<String, dynamic>> registerFcmToken({
    required String token,
    required String deviceType,
  }) =>
      onRegisterFcmToken?.call(token: token, deviceType: deviceType) ??
          (throw UnimplementedError('registerFcmToken not configured'));

  @override
  Future<Map<String, dynamic>> removeFcmToken(String token) =>
      onRemoveFcmToken?.call(token) ??
          (throw UnimplementedError('removeFcmToken not configured'));

  @override
  Future<Map<String, dynamic>> getDeliveryLogs({
    String? channel,
    String? status,
    int? perPage,
  }) =>
      onGetDeliveryLogs?.call() ??
          (throw UnimplementedError('getDeliveryLogs not configured'));

  @override
  Future<Map<String, dynamic>> getSoundConfigs() =>
      onGetSoundConfigs?.call() ??
          (throw UnimplementedError('getSoundConfigs not configured'));

  @override
  Future<Map<String, dynamic>> getSchedules() =>
      onGetSchedules?.call() ??
          (throw UnimplementedError('getSchedules not configured'));

  @override
  Future<Map<String, dynamic>> getStats() =>
      onGetStats?.call() ??
          (throw UnimplementedError('getStats not configured'));

  // ProviderContainer requires a concrete NotificationRepository.
  // We pass a real (but never-invoked) NotificationApiService(Dio())
  // to satisfy the super constructor — our overrides never reach it.
  static NotificationApiService _noopApiService() {
    return NotificationApiService(Dio());
  }
}

// Helper: build an isolated ProviderContainer with the fake repo.
ProviderContainer makeContainer(FakeNotificationRepository fakeRepo) {
  return ProviderContainer(
    overrides: [
      notificationRepositoryProvider.overrideWithValue(fakeRepo),
    ],
  );
}

void main() {
  // ════════════════════════════════════════════════════════
  // NotificationListNotifier
  // ════════════════════════════════════════════════════════

  group('NotificationListNotifier', () {
    test('initial state is NotificationListInitial', () {
      final fake = FakeNotificationRepository();
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      expect(
        container.read(notificationListProvider),
        isA<NotificationListInitial>(),
      );
    });

    test('load → NotificationListLoaded with data', () async {
      final fake = FakeNotificationRepository();
      fake.onListNotifications = () async => {
            'success': true,
            'data': [
              {'id': 'n1', 'title': 'A'},
              {'id': 'n2', 'title': 'B'},
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationListProvider.notifier).load();

      final state = container.read(notificationListProvider);
      expect(state, isA<NotificationListLoaded>());
      final loaded = state as NotificationListLoaded;
      expect(loaded.notifications.length, 2);
      expect(loaded.notifications[0]['id'], 'n1');
    });

    test('load → NotificationListLoaded with empty list', () async {
      final fake = FakeNotificationRepository();
      fake.onListNotifications = () async =>
          {'success': true, 'data': <Map<String, dynamic>>[]};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationListProvider.notifier).load();

      final state = container.read(notificationListProvider);
      expect(state, isA<NotificationListLoaded>());
      expect((state as NotificationListLoaded).notifications, isEmpty);
    });

    test('load → NotificationListError on exception', () async {
      final fake = FakeNotificationRepository();
      fake.onListNotifications =
          () async => throw Exception('Network error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationListProvider.notifier).load();

      final state = container.read(notificationListProvider);
      expect(state, isA<NotificationListError>());
      expect((state as NotificationListError).message,
          contains('Network error'));
    });
  });

  // ════════════════════════════════════════════════════════
  // UnreadCountNotifier
  // ════════════════════════════════════════════════════════

  group('UnreadCountNotifier', () {
    test('initial state is UnreadCountInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(unreadCountProvider), isA<UnreadCountInitial>());
    });

    test('load returns correct total count', () async {
      final fake = FakeNotificationRepository();
      fake.onGetUnreadCount = () async =>
          {'success': true, 'data': {'unread_count': 7}};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(unreadCountProvider.notifier).load();

      final state = container.read(unreadCountProvider);
      expect(state, isA<UnreadCountLoaded>());
      expect((state as UnreadCountLoaded).count, 7);
    });

    test('loadByCategory builds per-category map and sums total', () async {
      final fake = FakeNotificationRepository();
      fake.onGetUnreadCountByCategory = () async => {
            'success': true,
            'data': {'order': 3, 'inventory': 2},
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(unreadCountProvider.notifier).loadByCategory();

      final state = container.read(unreadCountProvider);
      expect(state, isA<UnreadCountLoaded>());
      final loaded = state as UnreadCountLoaded;
      expect(loaded.count, 5);
      expect(loaded.byCategory, {'order': 3, 'inventory': 2});
    });

    test('load → UnreadCountError on exception', () async {
      final fake = FakeNotificationRepository();
      fake.onGetUnreadCount =
          () async => throw Exception('Timeout');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(unreadCountProvider.notifier).load();

      final state = container.read(unreadCountProvider);
      expect(state, isA<UnreadCountError>());
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationActionNotifier
  // ════════════════════════════════════════════════════════

  group('NotificationActionNotifier', () {
    test('initial state is NotificationActionInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(notificationActionProvider),
          isA<NotificationActionInitial>());
    });

    test('markAsRead → NotificationActionSuccess', () async {
      final fake = FakeNotificationRepository();
      fake.onMarkAsRead = (_) async =>
          {'success': true, 'message': 'Marked as read'};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(notificationActionProvider.notifier)
          .markAsRead('notif-001');

      final state = container.read(notificationActionProvider);
      expect(state, isA<NotificationActionSuccess>());
      expect(
        (state as NotificationActionSuccess).message,
        'marked_as_read',
      );
    });

    test('markAllAsRead → NotificationActionSuccess', () async {
      final fake = FakeNotificationRepository();
      fake.onMarkAllAsRead = () async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(notificationActionProvider.notifier)
          .markAllAsRead();

      final state = container.read(notificationActionProvider);
      expect(state, isA<NotificationActionSuccess>());
      expect((state as NotificationActionSuccess).message, 'all_marked_as_read');
    });

    test('delete → NotificationActionSuccess', () async {
      final fake = FakeNotificationRepository();
      fake.onDeleteNotification = (_) async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(notificationActionProvider.notifier)
          .delete('notif-001');

      final state = container.read(notificationActionProvider);
      expect(state, isA<NotificationActionSuccess>());
    });

    test('markAsRead → NotificationActionError on failure', () async {
      final fake = FakeNotificationRepository();
      fake.onMarkAsRead = (_) async => throw Exception('Server error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(notificationActionProvider.notifier)
          .markAsRead('notif-001');

      final state = container.read(notificationActionProvider);
      expect(state, isA<NotificationActionError>());
    });

    test('reset returns state to NotificationActionInitial', () async {
      final fake = FakeNotificationRepository();
      fake.onMarkAsRead = (_) async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(notificationActionProvider.notifier)
          .markAsRead('notif-001');
      container.read(notificationActionProvider.notifier).reset();

      expect(container.read(notificationActionProvider),
          isA<NotificationActionInitial>());
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationPreferencesNotifier
  // ════════════════════════════════════════════════════════

  group('NotificationPreferencesNotifier', () {
    test('initial state is NotificationPreferencesInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(notificationPreferencesProvider),
          isA<NotificationPreferencesInitial>());
    });

    test('load → NotificationPreferencesLoaded with quiet hours', () async {
      final fake = FakeNotificationRepository();
      fake.onGetPreferences = () async => {
            'success': true,
            'data': {
              'preferences': {'order': true},
              'quiet_hours_start': '22:00',
              'quiet_hours_end': '07:00',
              'sound_enabled': true,
              'email_digest': 'daily',
            },
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationPreferencesProvider.notifier).load();

      final state = container.read(notificationPreferencesProvider);
      expect(state, isA<NotificationPreferencesLoaded>());
      final loaded = state as NotificationPreferencesLoaded;
      expect(loaded.quietHoursStart, '22:00');
      expect(loaded.quietHoursEnd, '07:00');
      expect(loaded.soundEnabled, isTrue);
      expect(loaded.emailDigest, 'daily');
    });

    test('update → NotificationPreferencesLoaded with updated data', () async {
      final fake = FakeNotificationRepository();
      fake.onUpdatePreferences = ({
        Map<String, dynamic>? preferences,
        String? quietHoursStart,
        String? quietHoursEnd,
        bool? soundEnabled,
        String? emailDigest,
      }) async =>
          <String, dynamic>{
            'success': true,
            'data': <String, dynamic>{
              'preferences': <String, dynamic>{},
              'quiet_hours_start': quietHoursStart,
              'quiet_hours_end': quietHoursEnd,
              'sound_enabled': soundEnabled,
            },
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationPreferencesProvider.notifier).update(
            quietHoursStart: '23:00',
            quietHoursEnd: '06:00',
            soundEnabled: false,
          );

      final state = container.read(notificationPreferencesProvider);
      expect(state, isA<NotificationPreferencesLoaded>());
      final loaded = state as NotificationPreferencesLoaded;
      expect(loaded.quietHoursStart, '23:00');
      expect(loaded.soundEnabled, isFalse);
    });

    test('load → NotificationPreferencesError on failure', () async {
      final fake = FakeNotificationRepository();
      fake.onGetPreferences =
          () async => throw Exception('Unauthorized');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationPreferencesProvider.notifier).load();

      final state = container.read(notificationPreferencesProvider);
      expect(state, isA<NotificationPreferencesError>());
    });
  });

  // ════════════════════════════════════════════════════════
  // FcmTokenNotifier
  // ════════════════════════════════════════════════════════

  group('FcmTokenNotifier', () {
    test('initial state is FcmTokenInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(fcmTokenProvider), isA<FcmTokenInitial>());
    });

    test('register → FcmTokenRegistered', () async {
      final fake = FakeNotificationRepository();
      fake.onRegisterFcmToken = ({required token, required deviceType}) async =>
          {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(fcmTokenProvider.notifier).register(
            token: 'fcm-token-abc',
            deviceType: 'android',
          );

      final state = container.read(fcmTokenProvider);
      expect(state, isA<FcmTokenRegistered>());
      final registered = state as FcmTokenRegistered;
      expect(registered.token, 'fcm-token-abc');
      expect(registered.deviceType, 'android');
    });

    test('remove → FcmTokenRemoved', () async {
      final fake = FakeNotificationRepository();
      fake.onRemoveFcmToken = (_) async => {'success': true};
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container
          .read(fcmTokenProvider.notifier)
          .remove('fcm-token-abc');

      final state = container.read(fcmTokenProvider);
      expect(state, isA<FcmTokenRemoved>());
    });

    test('register → FcmTokenError on failure', () async {
      final fake = FakeNotificationRepository();
      fake.onRegisterFcmToken =
          ({required token, required deviceType}) async =>
              throw Exception('FCM error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(fcmTokenProvider.notifier).register(
            token: 'bad-token',
            deviceType: 'ios',
          );

      final state = container.read(fcmTokenProvider);
      expect(state, isA<FcmTokenError>());
    });
  });

  // ════════════════════════════════════════════════════════
  // SoundConfigsNotifier
  // ════════════════════════════════════════════════════════

  group('SoundConfigsNotifier', () {
    test('initial state is SoundConfigsInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(soundConfigsProvider), isA<SoundConfigsInitial>());
    });

    test('load → SoundConfigsLoaded with parsed models', () async {
      final fake = FakeNotificationRepository();
      fake.onGetSoundConfigs = () async => {
            'success': true,
            'data': [
              {
                'id': 'sc-1',
                'store_id': 's1',
                'event_key': 'order.new',
                'sound_file': 'chime.mp3',
                'volume': 0.8,
                'is_enabled': true,
              },
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(soundConfigsProvider.notifier).load();

      final state = container.read(soundConfigsProvider);
      expect(state, isA<SoundConfigsLoaded>());
      final loaded = state as SoundConfigsLoaded;
      expect(loaded.configs.length, 1);
      expect(loaded.configs[0].eventKey, 'order.new');
      expect(loaded.configs[0].isEnabled, isTrue);
    });

    test('load → SoundConfigsError on failure', () async {
      final fake = FakeNotificationRepository();
      fake.onGetSoundConfigs =
          () async => throw Exception('Server error');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(soundConfigsProvider.notifier).load();

      final state = container.read(soundConfigsProvider);
      expect(state, isA<SoundConfigsError>());
    });
  });

  // ════════════════════════════════════════════════════════
  // SchedulesNotifier
  // ════════════════════════════════════════════════════════

  group('SchedulesNotifier', () {
    test('initial state is SchedulesInitial', () {
      final container = makeContainer(FakeNotificationRepository());
      addTearDown(container.dispose);

      expect(container.read(schedulesProvider), isA<SchedulesInitial>());
    });

    test('load → SchedulesLoaded with parsed schedule models', () async {
      final fake = FakeNotificationRepository();
      fake.onGetSchedules = () async => {
            'success': true,
            'data': [
              {
                'id': 'sch-1',
                'store_id': 'store-1',
                'category': 'finance',
                'title': 'Daily Report',
                'message': 'Your daily summary.',
                'channel': 'in_app',
                'scheduled_at': '2026-06-01T08:00:00.000Z',
                'is_active': true,
              },
            ],
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(schedulesProvider.notifier).load();

      final state = container.read(schedulesProvider);
      expect(state, isA<SchedulesLoaded>());
      final loaded = state as SchedulesLoaded;
      expect(loaded.schedules.length, 1);
      expect(loaded.schedules[0].title, 'Daily Report');
      expect(loaded.schedules[0].isActive, isTrue);
    });

    test('load → SchedulesError on failure', () async {
      final fake = FakeNotificationRepository();
      fake.onGetSchedules = () async => throw Exception('Forbidden');
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(schedulesProvider.notifier).load();

      final state = container.read(schedulesProvider);
      expect(state, isA<SchedulesError>());
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationStatsNotifier
  // ════════════════════════════════════════════════════════

  group('NotificationStatsNotifier', () {
    test('load → NotificationStatsLoaded with stats map', () async {
      final fake = FakeNotificationRepository();
      fake.onGetStats = () async => {
            'success': true,
            'data': {
              'total': 50,
              'read': 30,
              'unread': 20,
              'by_category': {'order': 10, 'inventory': 5},
            },
          };
      final container = makeContainer(fake);
      addTearDown(container.dispose);

      await container.read(notificationStatsProvider.notifier).load();

      final state = container.read(notificationStatsProvider);
      expect(state, isA<NotificationStatsLoaded>());
      final loaded = state as NotificationStatsLoaded;
      expect(loaded.stats['total'], 50);
      expect(loaded.stats['unread'], 20);
    });
  });
}
