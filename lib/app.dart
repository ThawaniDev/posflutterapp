import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/providers/app_settings_providers.dart';
import 'package:wameedpos/core/router/app_router.dart';
import 'package:wameedpos/core/services/app_update_service.dart';
import 'package:wameedpos/core/services/push_notification_service.dart';
import 'package:wameedpos/core/theme/app_theme.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/pos_terminal/data/local/pos_offline_sync_service.dart';
import 'package:wameedpos/features/subscription/services/feature_gate_service.dart';
import 'package:wameedpos/features/subscription/services/subscription_sync_service.dart';
import 'package:wameedpos/features/promotions/services/promotion_sync_service.dart';
import 'package:wameedpos/features/accessibility/services/accessibility_service.dart';

/// Global key so we can show dialogs (e.g. force-update) from services.
final rootNavigatorKey = GlobalKey<NavigatorState>();

class WameedPosApp extends ConsumerWidget {
  const WameedPosApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final highContrastTheme = ref.watch(highContrastThemeProvider);
    final fontScale = ref.watch(fontScaleProvider);

    // Initialize FCM + subscription sync when the user becomes authenticated
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        ref.read(pushNotificationServiceProvider).initialize();
        ref.read(featureGateServiceProvider).initialize();
        ref.read(subscriptionSyncServiceProvider).startSync();
        ref.read(posOfflineSyncServiceProvider)
          ..startPeriodicDrain()
          ..drain();
        // Best-effort promotion pull for offline evaluator
        Future.microtask(
          () => ref
              .read(promotionSyncServiceProvider)
              .syncFromServer()
              .catchError((_) => const PromotionSyncResult(syncedCount: 0, serverTime: null)),
        );
        _checkForUpdate(ref);
      }
    });

    // Also handle already-authenticated state (e.g. session restored before build)
    final authState = ref.read(authProvider);
    if (authState is AuthAuthenticated) {
      Future.microtask(() {
        ref.read(pushNotificationServiceProvider).initialize();
        ref.read(featureGateServiceProvider).initialize();
        ref.read(subscriptionSyncServiceProvider).startSync();
        ref.read(posOfflineSyncServiceProvider)
          ..startPeriodicDrain()
          ..drain();
        ref
            .read(promotionSyncServiceProvider)
            .syncFromServer()
            .catchError((_) => const PromotionSyncResult(syncedCount: 0, serverTime: null));
        _checkForUpdate(ref);
      });
    }

    return MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(fontScale)),
      child: MaterialApp.router(
        title: 'Wameed POS',
        debugShowCheckedModeBanner: false,
        theme: highContrastTheme ?? AppTheme.light(),
        darkTheme: highContrastTheme ?? AppTheme.dark(),
        themeMode: themeMode,
        locale: locale,
        routerConfig: router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  void _checkForUpdate(WidgetRef ref) {
    // Delay slightly so the router/navigator context is available.
    // rootNavigatorKey.currentContext is a GlobalKey access (not a Widget BuildContext),
    // so use_build_context_synchronously does not apply here.
    Future.delayed(const Duration(seconds: 2), () {
      final ctx = rootNavigatorKey.currentContext;
      if (ctx != null) {
        // ignore: use_build_context_synchronously
        ref.read(appUpdateServiceProvider).checkOnLogin(ctx);
      }
    });
  }
}
