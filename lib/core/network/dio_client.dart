import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/app_constants.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';

/// Provider for the active branch store ID. Updated by branch context system.
/// Dio reads this to attach X-Store-Id header to all API requests.
final activeBranchStoreIdProvider = StateProvider<String?>((ref) => null);

final dioClientProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.connectTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    ),
  );

  final localStorage = ref.watch(authLocalStorageProvider);

  // Auth + Branch interceptor — attaches Bearer token and X-Store-Id to every request
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await localStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        // Attach branch context — the active store ID
        final storeId = ref.read(activeBranchStoreIdProvider);
        if (storeId != null && storeId.isNotEmpty) {
          options.headers['X-Store-Id'] = storeId;
        }

        return handler.next(options);
      },
      onError: (error, handler) async {
        // 401 Unauthorized — clear local session so UI redirects to login
        if (error.response?.statusCode == 401) {
          await localStorage.clearAll();
          // Don't retry — let the auth state listener handle navigation
        }
        return handler.next(error);
      },
    ),
  );

  // Logging interceptor (debug builds only)
  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true, logPrint: (obj) => debugPrint(obj.toString())),
    );
  }

  return dio;
});
