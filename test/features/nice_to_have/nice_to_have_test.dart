import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/nice_to_have_state.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/nice_to_have_providers.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/nice_to_have_dashboard_page.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/wishlist_widget.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/appointments_widget.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/cfd_config_widget.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/gift_registry_widget.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/signage_widget.dart';
import 'package:thawani_pos/features/nice_to_have/presentation/widgets/gamification_widget.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/router/route_names.dart';
import 'package:thawani_pos/features/nice_to_have/data/nice_to_have_repository.dart';

// ─── Mock Notifiers ──────────────────────────────────────────
class MockWishlistNotifier extends StateNotifier<WishlistState> implements WishlistNotifier {
  MockWishlistNotifier(super.state);
  @override
  Future<void> load(String customerId) async {}
}

class MockAppointmentNotifier extends StateNotifier<AppointmentState> implements AppointmentNotifier {
  MockAppointmentNotifier(super.state);
  @override
  Future<void> load() async {}
}

class MockCfdConfigNotifier extends StateNotifier<CfdConfigState> implements CfdConfigNotifier {
  MockCfdConfigNotifier(super.state);
  @override
  Future<void> load() async {}
}

class MockGiftRegistryNotifier extends StateNotifier<GiftRegistryState> implements GiftRegistryNotifier {
  MockGiftRegistryNotifier(super.state);
  @override
  Future<void> load() async {}
}

class MockSignageNotifier extends StateNotifier<SignageState> implements SignageNotifier {
  MockSignageNotifier(super.state);
  @override
  Future<void> load() async {}
}

class MockGamificationNotifier extends StateNotifier<GamificationState> implements GamificationNotifier {
  MockGamificationNotifier(super.state);
  @override
  Future<void> load() async {}
}

Widget _wrap(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(home: child),
  );
}

void main() {
  // ═══════════════════════════════════════════════════════════
  // State Tests
  // ═══════════════════════════════════════════════════════════

  group('WishlistState', () {
    test('Initial', () {
      const s = WishlistInitial();
      expect(s, isA<WishlistState>());
    });
    test('Loading', () {
      const s = WishlistLoading();
      expect(s, isA<WishlistState>());
    });
    test('Loaded holds items', () {
      const s = WishlistLoaded([
        {'product_id': 'p1'},
      ]);
      expect(s.items.length, 1);
    });
    test('Error holds message', () {
      const s = WishlistError('fail');
      expect(s.message, 'fail');
    });
  });

  group('AppointmentState', () {
    test('Initial', () => expect(const AppointmentInitial(), isA<AppointmentState>()));
    test('Loading', () => expect(const AppointmentLoading(), isA<AppointmentState>()));
    test('Loaded', () {
      const s = AppointmentLoaded([
        {'id': 'a1', 'status': 'scheduled'},
      ]);
      expect(s.appointments.length, 1);
    });
    test('Error', () => expect(const AppointmentError('e').message, 'e'));
  });

  group('CfdConfigState', () {
    test('Initial', () => expect(const CfdConfigInitial(), isA<CfdConfigState>()));
    test('Loaded', () {
      const s = CfdConfigLoaded({'is_enabled': false, 'idle_rotation_seconds': 10});
      expect(s.config['is_enabled'], false);
      expect(s.config['idle_rotation_seconds'], 10);
    });
    test('Error', () => expect(const CfdConfigError('e').message, 'e'));
  });

  group('GiftRegistryState', () {
    test('Initial', () => expect(const GiftRegistryInitial(), isA<GiftRegistryState>()));
    test('Loaded', () {
      const s = GiftRegistryLoaded([
        {'name': 'Wedding', 'share_code': 'ABC'},
      ]);
      expect(s.registries.length, 1);
    });
    test('Error', () => expect(const GiftRegistryError('e').message, 'e'));
  });

  group('SignageState', () {
    test('Initial', () => expect(const SignageInitial(), isA<SignageState>()));
    test('Loaded', () {
      const s = SignageLoaded([
        {'name': 'Promos', 'slides': []},
      ]);
      expect(s.playlists.length, 1);
    });
    test('Error', () => expect(const SignageError('e').message, 'e'));
  });

  group('GamificationState', () {
    test('Initial', () => expect(const GamificationInitial(), isA<GamificationState>()));
    test('Loaded holds challenges, badges, tiers', () {
      const s = GamificationLoaded(
        challenges: [
          {'name_en': 'Spend 50'},
        ],
        badges: [
          {'name_en': 'First Purchase'},
        ],
        tiers: [
          {'tier_name_en': 'Gold'},
        ],
      );
      expect(s.challenges.length, 1);
      expect(s.badges.length, 1);
      expect(s.tiers.length, 1);
    });
    test('Error', () => expect(const GamificationError('e').message, 'e'));
  });

  group('NiceToHaveOperationState', () {
    test('Idle', () => expect(const NthOpIdle(), isA<NiceToHaveOperationState>()));
    test('Loading', () => expect(const NthOpLoading(), isA<NiceToHaveOperationState>()));
    test('Success', () => expect(const NthOpSuccess('done').message, 'done'));
    test('Error', () => expect(const NthOpError('err').message, 'err'));
  });

  // ═══════════════════════════════════════════════════════════
  // Endpoint Tests
  // ═══════════════════════════════════════════════════════════

  group('ApiEndpoints –', () {
    test('wishlist', () => expect(ApiEndpoints.wishlist, '/wishlist'));
    test('appointments', () => expect(ApiEndpoints.appointments, '/appointments'));
    test('appointmentUpdate', () => expect(ApiEndpoints.appointmentUpdate('a1'), '/appointments/a1'));
    test('appointmentCancel', () => expect(ApiEndpoints.appointmentCancel('a1'), '/appointments/a1/cancel'));
    test('cfdConfig', () => expect(ApiEndpoints.cfdConfig, '/cfd/config'));
    test('giftRegistry', () => expect(ApiEndpoints.giftRegistry, '/gift-registry'));
    test('giftRegistryShare', () => expect(ApiEndpoints.giftRegistryShare('XYZ'), '/gift-registry/share/XYZ'));
    test('giftRegistryItems', () => expect(ApiEndpoints.giftRegistryItems('r1'), '/gift-registry/r1/items'));
    test('signagePlaylists', () => expect(ApiEndpoints.signagePlaylists, '/signage/playlists'));
    test('signagePlaylist', () => expect(ApiEndpoints.signagePlaylist('s1'), '/signage/playlists/s1'));
    test('gamificationChallenges', () => expect(ApiEndpoints.gamificationChallenges, '/gamification/challenges'));
    test('gamificationBadges', () => expect(ApiEndpoints.gamificationBadges, '/gamification/badges'));
    test('gamificationTiers', () => expect(ApiEndpoints.gamificationTiers, '/gamification/tiers'));
    test(
      'gamificationCustomerProgress',
      () => expect(ApiEndpoints.gamificationCustomerProgress('c1'), '/gamification/customer/c1/progress'),
    );
    test(
      'gamificationCustomerBadges',
      () => expect(ApiEndpoints.gamificationCustomerBadges('c1'), '/gamification/customer/c1/badges'),
    );
  });

  // ═══════════════════════════════════════════════════════════
  // Route Tests
  // ═══════════════════════════════════════════════════════════

  group('Routes –', () {
    test('niceToHaveDashboard', () => expect(Routes.niceToHaveDashboard, '/nice-to-have'));
  });

  // ═══════════════════════════════════════════════════════════
  // Widget Tests
  // ═══════════════════════════════════════════════════════════

  group('NiceToHaveDashboardPage –', () {
    testWidgets('renders 6 tabs', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith((_) => MockCfdConfigNotifier(const CfdConfigLoaded({'is_enabled': false}))),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(const GamificationLoaded(challenges: [], badges: [], tiers: [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Appointments'), findsOneWidget);
      expect(find.text('CFD'), findsOneWidget);
      expect(find.text('Gift Registry'), findsOneWidget);
      expect(find.text('Signage'), findsOneWidget);
      expect(find.text('Gamification'), findsOneWidget);
    });

    testWidgets('Appointments tab shows empty message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith((_) => MockCfdConfigNotifier(const CfdConfigLoaded({'is_enabled': false}))),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(const GamificationLoaded(challenges: [], badges: [], tiers: [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Appointments'));
      await tester.pumpAndSettle();
      expect(find.text('No appointments'), findsOneWidget);
    });

    testWidgets('CFD tab shows config', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith(
              (_) => MockCfdConfigNotifier(
                const CfdConfigLoaded({'is_enabled': false, 'target_monitor': 'secondary', 'idle_rotation_seconds': 10}),
              ),
            ),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(const GamificationLoaded(challenges: [], badges: [], tiers: [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('CFD'));
      await tester.pumpAndSettle();
      expect(find.text('CFD Enabled'), findsOneWidget);
      expect(find.text('Target Monitor'), findsOneWidget);
    });

    testWidgets('Gift Registry tab shows empty message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith((_) => MockCfdConfigNotifier(const CfdConfigLoaded({'is_enabled': false}))),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(const GamificationLoaded(challenges: [], badges: [], tiers: [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gift Registry'));
      await tester.pumpAndSettle();
      expect(find.text('No gift registries'), findsOneWidget);
    });

    testWidgets('Signage tab shows empty message', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith((_) => MockCfdConfigNotifier(const CfdConfigLoaded({'is_enabled': false}))),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(const GamificationLoaded(challenges: [], badges: [], tiers: [])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Signage'));
      await tester.pumpAndSettle();
      expect(find.text('No signage playlists'), findsOneWidget);
    });

    testWidgets('Gamification tab shows loaded data', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const NiceToHaveDashboardPage(),
          overrides: [
            wishlistProvider.overrideWith((_) => MockWishlistNotifier(const WishlistInitial())),
            appointmentProvider.overrideWith((_) => MockAppointmentNotifier(const AppointmentLoaded([]))),
            cfdConfigProvider.overrideWith((_) => MockCfdConfigNotifier(const CfdConfigLoaded({'is_enabled': false}))),
            giftRegistryProvider.overrideWith((_) => MockGiftRegistryNotifier(const GiftRegistryLoaded([]))),
            signageProvider.overrideWith((_) => MockSignageNotifier(const SignageLoaded([]))),
            gamificationProvider.overrideWith(
              (_) => MockGamificationNotifier(
                const GamificationLoaded(
                  challenges: [
                    {'name_en': 'Spend 100', 'challenge_type': 'spend_amount', 'target_value': 100},
                  ],
                  badges: [
                    {'name_en': 'Super Shopper'},
                  ],
                  tiers: [
                    {'tier_name_en': 'Gold', 'min_points': 1000},
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
      // Scroll the tab bar to bring Gamification into view
      await tester.ensureVisible(find.text('Gamification'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Gamification'));
      await tester.pumpAndSettle();
      expect(find.text('Challenges (1)'), findsOneWidget);
      expect(find.text('Badges (1)'), findsOneWidget);
      expect(find.text('Tiers (1)'), findsOneWidget);
    });
  });
}
