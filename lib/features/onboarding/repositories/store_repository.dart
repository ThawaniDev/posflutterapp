import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/auth/data/local/auth_local_storage.dart';
import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/onboarding/data/remote/onboarding_api_service.dart';
import 'package:wameedpos/features/onboarding/data/remote/store_api_service.dart';
import 'package:wameedpos/features/onboarding/models/business_type_template.dart';
import 'package:wameedpos/features/onboarding/models/onboarding_progress.dart';
import 'package:wameedpos/features/onboarding/models/store_settings.dart';
import 'package:wameedpos/features/onboarding/models/store_working_hour.dart';

final storeRepositoryProvider = Provider<StoreRepository>((ref) {
  return StoreRepository(
    storeApi: ref.watch(storeApiServiceProvider),
    onboardingApi: ref.watch(onboardingApiServiceProvider),
    localStorage: ref.watch(authLocalStorageProvider),
  );
});

/// Orchestrates store, settings, working hours, and onboarding APIs.
class StoreRepository {
  final StoreApiService storeApi;
  final OnboardingApiService onboardingApi;
  final AuthLocalStorage localStorage;

  StoreRepository({required this.storeApi, required this.onboardingApi, required this.localStorage});

  /// Resolves the current user's store ID from local storage.
  Future<String> _resolveStoreId() async {
    final storeId = await localStorage.getStoreId();
    if (storeId == null || storeId.isEmpty) {
      throw Exception('No store ID found. Please log in again.');
    }
    return storeId;
  }

  // ─── Store ─────────────────────────────────────────────────────

  Future<Store> getMyStore() => storeApi.getMyStore();

  Future<List<Store>> listStores() => storeApi.listStores();

  Future<Store> getStore(String storeId) => storeApi.getStore(storeId);

  Future<Store> updateStore(String storeId, Map<String, dynamic> data) => storeApi.updateStore(storeId, data);

  // ─── Settings ──────────────────────────────────────────────────

  Future<StoreSettings> getSettings(String storeId) => storeApi.getSettings(storeId);

  Future<StoreSettings> updateSettings(String storeId, Map<String, dynamic> data) => storeApi.updateSettings(storeId, data);

  // ─── Working Hours ─────────────────────────────────────────────

  Future<List<StoreWorkingHour>> getWorkingHours(String storeId) => storeApi.getWorkingHours(storeId);

  Future<List<StoreWorkingHour>> updateWorkingHours(String storeId, List<Map<String, dynamic>> days) =>
      storeApi.updateWorkingHours(storeId, days);

  // ─── Business Types ────────────────────────────────────────────

  Future<List<BusinessTypeTemplate>> getBusinessTypes() => storeApi.getBusinessTypes();

  Future<Store> applyBusinessType(String storeId, String code) => storeApi.applyBusinessType(storeId, code);

  // ─── Onboarding ────────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getOnboardingSteps() => onboardingApi.getSteps();

  Future<OnboardingProgress> getOnboardingProgress({String? storeId}) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.getProgress(storeId: storeId);
  }

  Future<OnboardingProgress> completeOnboardingStep({
    String? storeId,
    required String step,
    Map<String, dynamic> data = const {},
  }) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.completeStep(storeId: storeId, step: step, data: data);
  }

  Future<OnboardingProgress> skipOnboarding({String? storeId}) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.skipWizard(storeId);
  }

  Future<OnboardingProgress> updateChecklistItem({String? storeId, required String itemKey, required bool completed}) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.updateChecklistItem(storeId: storeId, itemKey: itemKey, completed: completed);
  }

  Future<OnboardingProgress> dismissChecklist({String? storeId}) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.dismissChecklist(storeId);
  }

  Future<OnboardingProgress> resetOnboarding({String? storeId}) async {
    storeId ??= await _resolveStoreId();
    return onboardingApi.resetOnboarding(storeId);
  }
}
