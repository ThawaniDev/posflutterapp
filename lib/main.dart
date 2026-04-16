import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/app.dart';
import 'package:wameedpos/core/providers/app_settings_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wameedpos/core/services/push_notification_service.dart';
import 'package:wameedpos/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([initAppSettings(), Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)]);

  // Register the top-level background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  runApp(const ProviderScope(child: WameedPosApp()));
}
