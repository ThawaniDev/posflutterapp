import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Tracks whether the sidebar is collapsed (icon-only mode).
final sidebarCollapsedProvider = StateProvider<bool>((ref) => false);
