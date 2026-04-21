import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/app_constants.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
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

  // Track whether a token refresh is already in progress to avoid loops
  bool isRefreshing = false;

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
        // 401 Unauthorized — attempt token refresh before giving up
        if (error.response?.statusCode == 401 && !isRefreshing) {
          // Don't refresh if the failing request was itself the refresh call
          final isRefreshRequest = error.requestOptions.path == ApiEndpoints.refreshToken;
          if (!isRefreshRequest) {
            isRefreshing = true;
            try {
              // Call the refresh endpoint using a fresh Dio to avoid interceptor loop
              final currentToken = await localStorage.getToken();
              if (currentToken != null && currentToken.isNotEmpty) {
                final refreshDio = Dio(
                  BaseOptions(
                    baseUrl: AppConstants.apiBaseUrl,
                    headers: {
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                      'Authorization': 'Bearer $currentToken',
                    },
                  ),
                );
                final response = await refreshDio.post(ApiEndpoints.refreshToken);
                final newToken = (response.data['data'] as Map<String, dynamic>?)?['token'] as String?;

                if (newToken != null && newToken.isNotEmpty) {
                  await localStorage.saveToken(newToken);

                  // Retry the original request with the new token
                  final opts = error.requestOptions;
                  opts.headers['Authorization'] = 'Bearer $newToken';
                  final retryResponse = await dio.fetch(opts);
                  isRefreshing = false;
                  return handler.resolve(retryResponse);
                }
              }
            } catch (_) {
              // Refresh failed — fall through to clear session
            }
            isRefreshing = false;
          }

          // If refresh failed or wasn't possible, clear session
          await localStorage.clearAll();
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
