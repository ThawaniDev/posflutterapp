import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/onboarding/models/onboarding_progress.dart';

final onboardingApiServiceProvider = Provider<OnboardingApiService>((ref) {
  return OnboardingApiService(ref.watch(dioClientProvider));
});

class OnboardingApiService {
  final Dio _dio;

  OnboardingApiService(this._dio);

  /// GET /core/onboarding/steps
  Future<List<Map<String, dynamic>>> getSteps() async {
    final response = await _dio.get(ApiEndpoints.onboardingSteps);
    final List data = response.data['data'] as List;
    return data.map((j) => Map<String, dynamic>.from(j as Map)).toList();
  }

  /// GET /core/onboarding/progress?store_id=xxx
  Future<OnboardingProgress> getProgress({String? storeId}) async {
    final response = await _dio.get(ApiEndpoints.onboardingProgress, queryParameters: {if (storeId != null) 'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/complete-step
  Future<OnboardingProgress> completeStep({
    required String storeId,
    required String step,
    Map<String, dynamic> data = const {},
  }) async {
    final response = await _dio.post(
      ApiEndpoints.onboardingCompleteStep,
      data: {'store_id': storeId, 'step': step, 'data': data},
    );
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/skip
  Future<OnboardingProgress> skipWizard(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingSkip, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/checklist
  Future<OnboardingProgress> updateChecklistItem({
    required String storeId,
    required String itemKey,
    required bool completed,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.onboardingChecklist,
      data: {'store_id': storeId, 'item_key': itemKey, 'completed': completed},
    );
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/dismiss-checklist
  Future<OnboardingProgress> dismissChecklist(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingDismissChecklist, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// POST /core/onboarding/reset
  Future<OnboardingProgress> resetOnboarding(String storeId) async {
    final response = await _dio.post(ApiEndpoints.onboardingReset, data: {'store_id': storeId});
    return OnboardingProgress.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
