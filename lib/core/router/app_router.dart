import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login Page — TODO')),
        ),
      ),
      GoRoute(
        path: Routes.dashboard,
        name: 'dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Dashboard — TODO')),
        ),
      ),
      GoRoute(
        path: Routes.pos,
        name: 'pos',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('POS Terminal — TODO')),
        ),
      ),
    ],
  );
});
