import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/router/route_names.dart';
import 'package:wameedpos/core/widgets/pos_dialog.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/settings/providers/settings_providers.dart';

/// Wraps the app shell to enforce `StoreSettings.sessionTimeoutMinutes`.
///
/// Any pointer or keyboard event resets the inactivity timer. When the
/// timer fires we sign the cashier out and route them back to the PIN
/// login page. A value of 0 disables the timeout.
class SessionIdleWrapper extends ConsumerStatefulWidget {
  const SessionIdleWrapper({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<SessionIdleWrapper> createState() => _SessionIdleWrapperState();
}

class _SessionIdleWrapperState extends ConsumerState<SessionIdleWrapper> {
  Timer? _timer;
  int _minutes = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final settings = ref.watch(currentStoreSettingsProvider);
    final next = settings?.sessionTimeoutMinutes ?? 0;
    if (next != _minutes) {
      _minutes = next;
      _restart();
    }
  }

  void _restart() {
    _timer?.cancel();
    if (_minutes <= 0) return;
    _timer = Timer(Duration(minutes: _minutes), _onTimeout);
  }

  Future<void> _onTimeout() async {
    final auth = ref.read(authProvider);
    if (auth is! AuthAuthenticated) return;
    if (!mounted) return;
    showPosWarningSnackbar(context, AppLocalizations.of(context)!.posSessionTimedOut);
    await ref.read(authProvider.notifier).logout(AppLocalizations.of(context)!);
    if (mounted) context.go(Routes.loginPin);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _restart(),
      onPointerMove: (_) => _restart(),
      onPointerSignal: (_) => _restart(),
      child: widget.child,
    );
  }
}
