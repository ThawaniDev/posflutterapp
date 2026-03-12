import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/onboarding/providers/store_onboarding_state.dart';
import 'package:thawani_pos/features/onboarding/repositories/store_repository.dart';

// ─── My Store Provider ───────────────────────────────────────────

final myStoreProvider = StateNotifierProvider<MyStoreNotifier, StoreState>((ref) {
  return MyStoreNotifier(ref.watch(storeRepositoryProvider));
});

class MyStoreNotifier extends StateNotifier<StoreState> {
  final StoreRepository _repo;

  MyStoreNotifier(this._repo) : super(const StoreInitial());

  Future<void> load() async {
    state = const StoreLoading();
    try {
      final store = await _repo.getMyStore();
      state = StoreLoaded(store);
    } catch (e) {
      state = StoreError(e.toString());
    }
  }

  Future<void> update(String storeId, Map<String, dynamic> data) async {
    try {
      final store = await _repo.updateStore(storeId, data);
      state = StoreLoaded(store);
    } catch (e) {
      state = StoreError(e.toString());
    }
  }
}

// ─── Store Settings Provider ─────────────────────────────────────

final storeSettingsProvider = StateNotifierProvider.family<StoreSettingsNotifier, StoreSettingsState, String>((ref, storeId) {
  return StoreSettingsNotifier(ref.watch(storeRepositoryProvider), storeId);
});

class StoreSettingsNotifier extends StateNotifier<StoreSettingsState> {
  final StoreRepository _repo;
  final String _storeId;

  StoreSettingsNotifier(this._repo, this._storeId) : super(const StoreSettingsInitial());

  Future<void> load() async {
    state = const StoreSettingsLoading();
    try {
      final settings = await _repo.getSettings(_storeId);
      state = StoreSettingsLoaded(settings);
    } catch (e) {
      state = StoreSettingsError(e.toString());
    }
  }

  Future<void> update(Map<String, dynamic> data) async {
    try {
      final settings = await _repo.updateSettings(_storeId, data);
      state = StoreSettingsLoaded(settings);
    } catch (e) {
      state = StoreSettingsError(e.toString());
    }
  }
}

// ─── Working Hours Provider ──────────────────────────────────────

final workingHoursProvider = StateNotifierProvider.family<WorkingHoursNotifier, WorkingHoursState, String>((ref, storeId) {
  return WorkingHoursNotifier(ref.watch(storeRepositoryProvider), storeId);
});

class WorkingHoursNotifier extends StateNotifier<WorkingHoursState> {
  final StoreRepository _repo;
  final String _storeId;

  WorkingHoursNotifier(this._repo, this._storeId) : super(const WorkingHoursInitial());

  Future<void> load() async {
    state = const WorkingHoursLoading();
    try {
      final hours = await _repo.getWorkingHours(_storeId);
      state = WorkingHoursLoaded(hours);
    } catch (e) {
      state = WorkingHoursError(e.toString());
    }
  }

  Future<void> update(List<Map<String, dynamic>> days) async {
    try {
      final hours = await _repo.updateWorkingHours(_storeId, days);
      state = WorkingHoursLoaded(hours);
    } catch (e) {
      state = WorkingHoursError(e.toString());
    }
  }
}

// ─── Business Types Provider ─────────────────────────────────────

final businessTypesProvider = StateNotifierProvider<BusinessTypesNotifier, BusinessTypesState>((ref) {
  return BusinessTypesNotifier(ref.watch(storeRepositoryProvider));
});

class BusinessTypesNotifier extends StateNotifier<BusinessTypesState> {
  final StoreRepository _repo;

  BusinessTypesNotifier(this._repo) : super(const BusinessTypesInitial());

  Future<void> load() async {
    state = const BusinessTypesLoading();
    try {
      final templates = await _repo.getBusinessTypes();
      state = BusinessTypesLoaded(templates);
    } catch (e) {
      state = BusinessTypesError(e.toString());
    }
  }
}

// ─── Onboarding Provider ─────────────────────────────────────────

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier(ref.watch(storeRepositoryProvider));
});

class OnboardingNotifier extends StateNotifier<OnboardingState> {
  final StoreRepository _repo;

  OnboardingNotifier(this._repo) : super(const OnboardingInitial());

  Future<void> load({String? storeId}) async {
    state = const OnboardingLoading();
    try {
      final progress = await _repo.getOnboardingProgress(storeId: storeId);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }

  Future<void> completeStep(String step, {String? storeId, Map<String, dynamic> data = const {}}) async {
    try {
      final progress = await _repo.completeOnboardingStep(storeId: storeId, step: step, data: data);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }

  Future<void> skip({String? storeId}) async {
    try {
      final progress = await _repo.skipOnboarding(storeId: storeId);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }

  Future<void> updateChecklistItem(String itemKey, bool completed, {String? storeId}) async {
    try {
      final progress = await _repo.updateChecklistItem(storeId: storeId, itemKey: itemKey, completed: completed);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }

  Future<void> dismissChecklist({String? storeId}) async {
    try {
      final progress = await _repo.dismissChecklist(storeId: storeId);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }

  Future<void> reset({String? storeId}) async {
    try {
      final progress = await _repo.resetOnboarding(storeId: storeId);
      state = OnboardingLoaded(progress);
    } catch (e) {
      state = OnboardingError(e.toString());
    }
  }
}
