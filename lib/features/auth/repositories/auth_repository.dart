import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/errors/app_exception.dart';
import 'package:thawani_pos/features/auth/data/local/auth_local_storage.dart';
import 'package:thawani_pos/features/auth/data/remote/auth_api_service.dart';
import 'package:thawani_pos/features/auth/models/auth_response.dart';
import 'package:thawani_pos/features/auth/models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(apiService: ref.watch(authApiServiceProvider), localStorage: ref.watch(authLocalStorageProvider));
});

/// Repository that orchestrates auth API calls and local storage.
class AuthRepository {
  final AuthApiService _apiService;
  final AuthLocalStorage _localStorage;

  AuthRepository({required AuthApiService apiService, required AuthLocalStorage localStorage})
    : _apiService = apiService,
      _localStorage = localStorage;

  // ─── Registration ──────────────────────────────────────────────

  Future<AuthResponse> register({
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
    try {
      final response = await _apiService.register(
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

      await _persistSession(response);
      return response;
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Login ─────────────────────────────────────────────────────

  Future<AuthResponse> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceName,
    String? platform,
  }) async {
    try {
      final response = await _apiService.login(
        email: email,
        password: password,
        deviceId: deviceId,
        deviceName: deviceName,
        platform: platform,
      );

      await _persistSession(response);
      return response;
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── PIN Login ─────────────────────────────────────────────────

  Future<AuthResponse> loginByPin({required String storeId, required String pin}) async {
    try {
      final response = await _apiService.loginByPin(storeId: storeId, pin: pin);

      await _persistSession(response);
      return response;
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Profile ───────────────────────────────────────────────────

  Future<User> getMe() async {
    try {
      return await _apiService.getMe();
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<User> updateProfile({String? name, String? phone, String? locale}) async {
    try {
      final user = await _apiService.updateProfile(name: name, phone: phone, locale: locale);
      if (locale != null) {
        await _localStorage.saveLocale(locale);
      }
      return user;
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await _apiService.changePassword(currentPassword: currentPassword, newPassword: newPassword);
    } catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> setPin({required String pin, required String currentPassword}) async {
    try {
      await _apiService.setPin(pin: pin, currentPassword: currentPassword);
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Token ─────────────────────────────────────────────────────

  Future<String?> getStoredToken() => _localStorage.getToken();

  Future<String> refreshToken() async {
    try {
      final newToken = await _apiService.refreshToken();
      await _localStorage.saveToken(newToken);
      return newToken;
    } catch (e) {
      throw _mapError(e);
    }
  }

  // ─── Logout ────────────────────────────────────────────────────

  Future<void> logout() async {
    try {
      await _apiService.logout();
    } catch (_) {
      // Ignore network errors on logout
    } finally {
      await _localStorage.clearAll();
    }
  }

  Future<void> logoutAll() async {
    try {
      await _apiService.logoutAll();
    } catch (_) {
      // Ignore network errors
    } finally {
      await _localStorage.clearAll();
    }
  }

  // ─── Session Check ─────────────────────────────────────────────

  Future<bool> hasStoredSession() async {
    final token = await _localStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getStoredStoreId() => _localStorage.getStoreId();

  // ─── Private ───────────────────────────────────────────────────

  Future<void> _persistSession(AuthResponse response) async {
    await _localStorage.saveSession(
      token: response.token.token,
      userId: response.user.id,
      storeId: response.user.storeId,
      organizationId: response.user.organizationId,
      locale: response.user.locale,
    );
  }

  AppException _mapError(dynamic error) {
    if (error is AppException) return error;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        // Laravel validation: {"message": "...", "errors": {...}}
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map<String, dynamic>) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return AuthException(
                message: firstError.first.toString(),
                code: error.response?.statusCode?.toString(),
                originalError: error,
              );
            }
          }
        }
        if (data.containsKey('message') && data['message'] != null) {
          return AuthException(
            message: data['message'] as String,
            code: error.response?.statusCode?.toString(),
            originalError: error,
          );
        }
      }
      return AuthException(
        message: error.message ?? 'An unexpected error occurred.',
        code: error.response?.statusCode?.toString(),
        originalError: error,
      );
    }
    return AuthException(message: error.toString(), originalError: error);
  }
}
