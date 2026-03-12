import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/app_constants.dart';
import 'package:thawani_pos/features/auth/data/local/auth_local_storage.dart';

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

  // Auth interceptor — attaches Bearer token to every request
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await localStorage.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
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
