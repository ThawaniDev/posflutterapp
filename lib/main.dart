import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/app.dart';
import 'package:thawani_pos/core/providers/app_settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppSettings();

  runApp(const ProviderScope(child: ThawaniPosApp()));
}
