import 'package:wameedpos/features/auth/models/user.dart';

/// Represents the authentication state of the app.
sealed class AuthState {
  const AuthState();
}

/// Initial state — checking stored session.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Currently loading (login, register, etc.).
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated with user data.
class AuthAuthenticated extends AuthState {

  const AuthAuthenticated({required this.user, required this.token});
  final User user;
  final String token;

  AuthAuthenticated copyWith({User? user, String? token}) {
    return AuthAuthenticated(user: user ?? this.user, token: token ?? this.token);
  }
}

/// Not authenticated.
class AuthUnauthenticated extends AuthState {

  const AuthUnauthenticated({this.message});
  final String? message;
}

/// Auth error occurred.
class AuthError extends AuthState {

  const AuthError({required this.message, this.code});
  final String message;
  final String? code;
}
