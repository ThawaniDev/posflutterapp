import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/app.dart';
import 'package:wameedpos/core/providers/app_settings_providers.dart';
import 'package:wameedpos/core/widgets/pos_app_error_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wameedpos/core/services/push_notification_service.dart';
import 'package:wameedpos/features/customer_facing_display/secondary_screen/secondary_display_app.dart';
import 'package:wameedpos/features/delivery_integration/services/delivery_alert_service.dart';
import 'package:wameedpos/features/delivery_integration/services/production_delivery_alert_sink.dart';
import 'package:wameedpos/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([initAppSettings(), Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)]);

  // Replace Flutter's default red error screen with a styled widget
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // In debug mode, also log the full error to console
    if (kDebugMode) FlutterError.dumpErrorToConsole(details);
    return PosAppErrorWidget(details: details);
  };

  // Register the top-level background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(
    ProviderScope(
      overrides: [deliveryAlertSinkProvider.overrideWithValue(ProductionDeliveryAlertSink())],
      child: const WameedPosApp(),
    ),
  );
}

/// Entry-point for the customer-facing secondary display (Landi C20 PRO etc).
///
/// Spawned in a separate Flutter engine by `presentation_displays` when the
/// main app calls `DisplayManager.showSecondaryDisplay(...)`. Must NOT touch
/// any plugin that would conflict with main-engine plugin registration
/// (Firebase, Sentry, etc. are NOT initialized here).
@pragma('vm:entry-point')
void secondaryDisplayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SecondaryDisplayApp());
}
