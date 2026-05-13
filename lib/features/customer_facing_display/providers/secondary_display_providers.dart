// Riverpod provider for the singleton SecondaryDisplayController.
//
// Only available on Android (the only platform where Landi-style dual screens
// are supported by `presentation_displays`). On other platforms the provider
// still resolves to a controller, but `init()` will simply find no secondary
// display and become a no-op.

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/customer_facing_display/services/secondary_display_controller.dart';

final secondaryDisplayControllerProvider = Provider<SecondaryDisplayController>((ref) {
  final controller = SecondaryDisplayController();
  ref.onDispose(controller.dispose);
  return controller;
});

/// True when running on a platform that can drive a physical secondary
/// display via the Android `Presentation` API.
bool get isSecondaryDisplaySupported {
  if (kIsWeb) return false;
  try {
    return Platform.isAndroid;
  } catch (_) {
    return false;
  }
}
