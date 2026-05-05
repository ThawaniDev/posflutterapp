// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/features/notifications/data/remote/notification_api_service.dart';
import 'package:wameedpos/features/notifications/pages/notification_centre_page.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';
import 'package:wameedpos/features/notifications/repositories/notification_repository.dart';
import 'package:wameedpos/features/notifications/widgets/maintenance_banner.dart';
import 'package:wameedpos/features/notifications/widgets/notification_bell.dart';

// ─── Shared l10n delegates ───────────────────────────────

const _kL10nDelegates = [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate];

// ─── Minimal fake repository ────────────────────────────

class _MinimalFakeRepo extends NotificationRepository {
  _MinimalFakeRepo() : super(NotificationApiService(Dio()));

  @override
  Future<Map<String, dynamic>> listNotifications({
    String? category,
    bool? isRead,
    int? limit,
    String? priority,
    String? dateFrom,
    String? dateTo,
  }) async => {'success': true, 'data': <Map<String, dynamic>>[]};

  @override
  Future<Map<String, dynamic>> getUnreadCount() async => {
    'success': true,
    'data': <String, dynamic>{'unread_count': 0},
  };

  @override
  Future<Map<String, dynamic>> listAnnouncements() async => {
    'success': true,
    'data': <String, dynamic>{'announcements': []},
  };

  @override
  Future<Map<String, dynamic>> listPaymentReminders({String? type, String? channel, int? perPage}) async => {
    'success': true,
    'data': <String, dynamic>{},
  };

  @override
  Future<Map<String, dynamic>> listAppReleases({String? platform, String? channel}) async => {
    'success': true,
    'data': <String, dynamic>{'releases': []},
  };

  @override
  Future<Map<String, dynamic>> getMaintenanceStatus() async => {
    'success': true,
    'data': <String, dynamic>{'is_enabled': false, 'is_ip_allowed': false},
  };

  @override
  Future<Map<String, dynamic>> getStats() async => {
    'success': true,
    'data': <String, dynamic>{'total': 0, 'read': 0, 'unread': 0},
  };
}

// ─── Fake StateNotifiers ─────────────────────────────────

class _FakeUnreadCountNotifier extends UnreadCountNotifier {
  _FakeUnreadCountNotifier(int count) : super(_MinimalFakeRepo()) {
    state = UnreadCountLoaded(count);
  }

  // Prevent actual network calls during tests.
  @override
  Future<void> load() async {}
  @override
  Future<void> loadByCategory() async {}
}

class _FakeNotificationListNotifier extends NotificationListNotifier {
  _FakeNotificationListNotifier(List<Map<String, dynamic>> notifications) : super(_MinimalFakeRepo()) {
    state = NotificationListLoaded(notifications);
  }

  @override
  Future<void> load({String? category, bool? isRead, int? limit, String? priority}) async {}
}

// ─── Helper to build a minimal app under test ────────────

Widget buildWithProviders({required Widget widget, required List<Override> overrides}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: _kL10nDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: widget),
    ),
  );
}

void main() {
  // ════════════════════════════════════════════════════════
  // MaintenanceBanner
  // ════════════════════════════════════════════════════════

  group('MaintenanceBanner widget', () {
    testWidgets('renders nothing (SizedBox) when shouldShow is false', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const MaintenanceBanner(),
          overrides: [
            maintenanceStatusProvider.overrideWith((_) async => <String, dynamic>{'is_enabled': false, 'is_ip_allowed': false}),
          ],
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.build_rounded), findsNothing);
    });

    testWidgets('renders nothing when IP is allowed (admin bypass)', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const MaintenanceBanner(),
          overrides: [
            maintenanceStatusProvider.overrideWith((_) async => <String, dynamic>{'is_enabled': true, 'is_ip_allowed': true}),
          ],
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.build_rounded), findsNothing);
    });

    testWidgets('renders banner text when shouldShow is true', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const MaintenanceBanner(),
          overrides: [
            maintenanceStatusProvider.overrideWith(
              (_) async => <String, dynamic>{
                'is_enabled': true,
                'is_ip_allowed': false,
                'banner_en': 'We are performing maintenance.',
              },
            ),
          ],
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.build_rounded), findsOneWidget);
      expect(find.text('We are performing maintenance.'), findsOneWidget);
    });

    testWidgets('falls back to l10n default title "Scheduled maintenance" when banners are null', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const MaintenanceBanner(),
          overrides: [
            maintenanceStatusProvider.overrideWith((_) async => <String, dynamic>{'is_enabled': true, 'is_ip_allowed': false}),
          ],
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.build_rounded), findsOneWidget);
      expect(find.text('Scheduled maintenance'), findsOneWidget);
    });

    testWidgets('renders nothing while future is loading', (tester) async {
      // Use a Completer so we can complete it at teardown to avoid
      // leaving pending timers after the test.
      final completer = Completer<Map<String, dynamic>>();
      addTearDown(() => completer.complete(<String, dynamic>{}));

      await tester.pumpWidget(
        buildWithProviders(
          widget: const MaintenanceBanner(),
          overrides: [maintenanceStatusProvider.overrideWith((_) => completer.future)],
        ),
      );
      // Single pump — async still pending
      await tester.pump();

      expect(find.byIcon(Icons.build_rounded), findsNothing);
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationBell
  // ════════════════════════════════════════════════════════

  group('NotificationBell widget', () {
    List<Override> _bellOverrides({required int unread, required List<Map<String, dynamic>> notifications}) => [
      unreadCountProvider.overrideWith((ref) => _FakeUnreadCountNotifier(unread)),
      notificationListProvider.overrideWith((ref) => _FakeNotificationListNotifier(notifications)),
    ];

    testWidgets('renders bell icon', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(unread: 0, notifications: []),
        ),
      );
      await tester.pump();

      expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
    });

    testWidgets('shows badge count when unread > 0', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(unread: 5, notifications: []),
        ),
      );
      await tester.pump();

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('hides badge text when unread count is 0', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(unread: 0, notifications: []),
        ),
      );
      await tester.pump();

      expect(find.text('0'), findsNothing);
    });

    testWidgets('tapping bell opens dropdown with notification list', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(
            unread: 2,
            notifications: [
              {'id': 'n1', 'title': 'New Order', 'message': 'Order #42 received.', 'is_read': false},
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('New Order'), findsOneWidget);
      expect(find.text('Order #42 received.'), findsOneWidget);
    });

    testWidgets('dropdown shows "Notifications" panel title', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(
            unread: 1,
            notifications: [
              {'id': 'n1', 'title': 'Test', 'message': 'msg', 'is_read': false},
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Notifications'), findsOneWidget);
    });

    testWidgets('dropdown shows "View all" link', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(
            unread: 1,
            notifications: [
              {'id': 'n1', 'title': 'Test', 'message': 'msg', 'is_read': false},
            ],
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('View all'), findsOneWidget);
    });

    testWidgets('dropdown shows empty-state text when no notifications', (tester) async {
      await tester.pumpWidget(
        buildWithProviders(
          widget: const NotificationBell(),
          overrides: _bellOverrides(unread: 0, notifications: []),
        ),
      );
      await tester.pump();

      await tester.tap(find.byIcon(Icons.notifications_outlined));
      await tester.pumpAndSettle();

      expect(find.text('No recent notifications'), findsOneWidget);
    });
  });

  // ════════════════════════════════════════════════════════
  // NotificationCentrePage
  // ════════════════════════════════════════════════════════

  group('NotificationCentrePage widget', () {
    Widget _centreApp() {
      final router = GoRouter(
        initialLocation: Routes.notifications,
        routes: [GoRoute(path: Routes.notifications, builder: (_, __) => const NotificationCentrePage())],
      );

      return ProviderScope(
        overrides: [
          notificationRepositoryProvider.overrideWithValue(_MinimalFakeRepo()),
          notificationListProvider.overrideWith((ref) => _FakeNotificationListNotifier([])),
          unreadCountProvider.overrideWith((ref) => _FakeUnreadCountNotifier(0)),
          announcementsProvider.overrideWith((_) async => []),
          paymentRemindersProvider.overrideWith((_) async => <String, dynamic>{}),
          appReleasesProvider.overrideWith((_) async => []),
          maintenanceStatusProvider.overrideWith((_) async => <String, dynamic>{}),
          notificationStatsProvider.overrideWith(
            (ref) => NotificationStatsNotifier(_MinimalFakeRepo())..state = const NotificationStatsLoaded(<String, dynamic>{}),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: _kL10nDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
    }

    testWidgets('renders app bar title "Notification Centre"', (tester) async {
      await tester.pumpWidget(_centreApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Notification Centre'), findsOneWidget);
    });

    testWidgets('renders all 4 tab labels', (tester) async {
      await tester.pumpWidget(_centreApp());
      await tester.pump();
      await tester.pump();

      expect(find.text('Inbox'), findsOneWidget);
      expect(find.text('Announcements'), findsOneWidget);
      expect(find.text('Payment Reminders'), findsOneWidget);
      expect(find.text('App Updates'), findsOneWidget);
    });

    testWidgets('tapping Announcements tab switches to that tab', (tester) async {
      await tester.pumpWidget(_centreApp());
      await tester.pump();
      await tester.pump();

      await tester.tap(find.text('Announcements'));
      await tester.pumpAndSettle();

      // Tab controller now at index 1 — Announcements tab is active
      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.controller?.index, 1);
    });
  });
}
