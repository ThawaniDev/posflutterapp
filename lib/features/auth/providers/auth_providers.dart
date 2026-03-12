import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/auth/models/user.dart';
import 'package:thawani_pos/features/auth/providers/auth_state.dart';
import 'package:thawani_pos/features/auth/repositories/auth_repository.dart';

/// The main auth state notifier — manages login, register, logout.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

/// Convenience provider for the current user (null if not authenticated).
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});

/// Whether the user is currently authenticated.
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider) is AuthAuthenticated;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthInitial()) {
    checkStoredSession();
  }

  // ─── Session Recovery ──────────────────────────────────────────

  Future<void> checkStoredSession() async {
    try {
      final hasSession = await _repository.hasStoredSession();
      if (!hasSession) {
        state = const AuthUnauthenticated();
        return;
      }

      // Try to fetch user with stored token
      final user = await _repository.getMe();
      final token = await _repository.getStoredToken();

      state = AuthAuthenticated(user: user, token: token ?? '');
    } catch (e) {
      // Token expired or invalid — clear and go to login
      await _repository.logout();
      state = const AuthUnauthenticated();
    }
  }

  // ─── Register ──────────────────────────────────────────────────

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? organizationName,
    String? organizationNameAr,
    String? storeName,
    String? storeNameAr,
    String country = 'OM',
    String currency = 'OMR',
    String locale = 'ar',
    String? businessType,
  }) async {
    state = const AuthLoading();
    try {
      final response = await _repository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        organizationName: organizationName,
        organizationNameAr: organizationNameAr,
        storeName: storeName,
        storeNameAr: storeNameAr,
        country: country,
        currency: currency,
        locale: locale,
        businessType: businessType,
      );

      state = AuthAuthenticated(user: response.user, token: response.token.token);
    } on DioException catch (e) {
      state = AuthError(message: _extractErrorMessage(e), code: e.response?.statusCode?.toString());
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  // ─── Login ─────────────────────────────────────────────────────

  Future<void> login({required String email, required String password, String? deviceId, String? platform}) async {
    state = const AuthLoading();
    try {
      final response = await _repository.login(email: email, password: password, deviceId: deviceId, platform: platform);

      state = AuthAuthenticated(user: response.user, token: response.token.token);
    } on DioException catch (e) {
      state = AuthError(message: _extractErrorMessage(e), code: e.response?.statusCode?.toString());
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  // ─── PIN Login ─────────────────────────────────────────────────

  Future<void> loginByPin({required String storeId, required String pin}) async {
    state = const AuthLoading();
    try {
      final response = await _repository.loginByPin(storeId: storeId, pin: pin);

      state = AuthAuthenticated(user: response.user, token: response.token.token);
    } on DioException catch (e) {
      state = AuthError(message: _extractErrorMessage(e), code: e.response?.statusCode?.toString());
    } catch (e) {
      state = AuthError(message: e.toString());
    }
  }

  // ─── Profile Update ────────────────────────────────────────────

  Future<void> updateProfile({String? name, String? phone, String? locale}) async {
    final currentState = state;
    if (currentState is! AuthAuthenticated) return;

    try {
      final updatedUser = await _repository.updateProfile(name: name, phone: phone, locale: locale);

      state = currentState.copyWith(user: updatedUser);
    } catch (e) {
      // Don't change auth state on profile update failure
    }
  }

  // ─── Logout ────────────────────────────────────────────────────

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthUnauthenticated(message: 'Logged out successfully.');
  }

  Future<void> logoutAll() async {
    await _repository.logoutAll();
    state = const AuthUnauthenticated(message: 'Logged out from all devices.');
  }

  // ─── Helpers ───────────────────────────────────────────────────

  String _extractErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      // Laravel validation error format
      if (data.containsKey('message')) {
        return data['message'] as String;
      }
      if (data.containsKey('errors')) {
        final errors = data['errors'] as Map<String, dynamic>;
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
      }
    }
    return e.message ?? 'An unexpected error occurred.';
  }
}
