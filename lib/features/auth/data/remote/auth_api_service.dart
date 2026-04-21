import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/auth/models/auth_response.dart';
import 'package:wameedpos/features/auth/models/user.dart';

final authApiServiceProvider = Provider<AuthApiService>((ref) {
  return AuthApiService(ref.watch(dioClientProvider));
});

/// Remote API service for auth endpoints.
class AuthApiService {

  AuthApiService(this._dio);
  final Dio _dio;

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
    String currency = '',
    String locale = 'ar',
    String? businessType,
  }) async {
    final response = await _dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone': phone,
        'organization_name': organizationName,
        'organization_name_ar': organizationNameAr,
        'store_name': storeName,
        'store_name_ar': storeNameAr,
        'country': country,
        'currency': currency,
        'locale': locale,
        'business_type': businessType,
      }..removeWhere((_, v) => v == null),
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AuthResponse.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Login ─────────────────────────────────────────────────────

  Future<AuthResponse> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceName,
    String? platform,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password, 'device_id': deviceId, 'device_name': deviceName, 'platform': platform}
        ..removeWhere((_, v) => v == null),
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AuthResponse.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── PIN Login ─────────────────────────────────────────────────

  Future<AuthResponse> loginByPin({required String storeId, required String pin}) async {
    final response = await _dio.post(ApiEndpoints.loginPin, data: {'store_id': storeId, 'pin': pin});

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AuthResponse.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Profile ───────────────────────────────────────────────────

  Future<User> getMe() async {
    final response = await _dio.get(ApiEndpoints.me);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return User.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<User> updateProfile({String? name, String? phone, String? locale}) async {
    final response = await _dio.put(
      '/auth/profile',
      data: {'name': name, 'phone': phone, 'locale': locale}..removeWhere((_, v) => v == null),
    );

    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return User.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Password & PIN ────────────────────────────────────────────

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    await _dio.put(
      '/auth/password',
      data: {'current_password': currentPassword, 'password': newPassword, 'password_confirmation': newPassword},
    );
  }

  Future<void> setPin({required String pin, required String currentPassword}) async {
    await _dio.put('/auth/pin', data: {'pin': pin, 'pin_confirmation': pin, 'current_password': currentPassword});
  }

  // ─── Token ─────────────────────────────────────────────────────

  Future<String> refreshToken() async {
    final response = await _dio.post(ApiEndpoints.refreshToken);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return (apiResponse.data as Map<String, dynamic>)['token'] as String;
  }

  // ─── Logout ────────────────────────────────────────────────────

  Future<void> logout() async {
    await _dio.post(ApiEndpoints.logout);
  }

  Future<void> logoutAll() async {
    await _dio.post('/auth/logout-all');
  }
}
