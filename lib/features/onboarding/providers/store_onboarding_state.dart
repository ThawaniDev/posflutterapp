import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/onboarding/models/business_type_template.dart';
import 'package:wameedpos/features/onboarding/models/onboarding_progress.dart';
import 'package:wameedpos/features/onboarding/models/store_settings.dart';
import 'package:wameedpos/features/onboarding/models/store_working_hour.dart';

// ─── Store State ─────────────────────────────────────────────────

sealed class StoreState {
  const StoreState();
}

class StoreInitial extends StoreState {
  const StoreInitial();
}

class StoreLoading extends StoreState {
  const StoreLoading();
}

class StoreLoaded extends StoreState {
  const StoreLoaded(this.store);
  final Store store;
}

class StoreError extends StoreState {
  const StoreError(this.message);
  final String message;
}

// ─── Store Settings State ────────────────────────────────────────

sealed class StoreSettingsState {
  const StoreSettingsState();
}

class StoreSettingsInitial extends StoreSettingsState {
  const StoreSettingsInitial();
}

class StoreSettingsLoading extends StoreSettingsState {
  const StoreSettingsLoading();
}

class StoreSettingsLoaded extends StoreSettingsState {
  const StoreSettingsLoaded(this.settings);
  final StoreSettings settings;
}

class StoreSettingsError extends StoreSettingsState {
  const StoreSettingsError(this.message);
  final String message;
}

// ─── Working Hours State ─────────────────────────────────────────

sealed class WorkingHoursState {
  const WorkingHoursState();
}

class WorkingHoursInitial extends WorkingHoursState {
  const WorkingHoursInitial();
}

class WorkingHoursLoading extends WorkingHoursState {
  const WorkingHoursLoading();
}

class WorkingHoursLoaded extends WorkingHoursState {
  const WorkingHoursLoaded(this.hours);
  final List<StoreWorkingHour> hours;
}

class WorkingHoursError extends WorkingHoursState {
  const WorkingHoursError(this.message);
  final String message;
}

// ─── Business Types State ────────────────────────────────────────

sealed class BusinessTypesState {
  const BusinessTypesState();
}

class BusinessTypesInitial extends BusinessTypesState {
  const BusinessTypesInitial();
}

class BusinessTypesLoading extends BusinessTypesState {
  const BusinessTypesLoading();
}

class BusinessTypesLoaded extends BusinessTypesState {
  const BusinessTypesLoaded(this.templates);
  final List<BusinessTypeTemplate> templates;
}

class BusinessTypesError extends BusinessTypesState {
  const BusinessTypesError(this.message);
  final String message;
}

// ─── Onboarding State ────────────────────────────────────────────

sealed class OnboardingState {
  const OnboardingState();
}

class OnboardingInitial extends OnboardingState {
  const OnboardingInitial();
}

class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

class OnboardingLoaded extends OnboardingState {
  const OnboardingLoaded(this.progress);
  final OnboardingProgress progress;
}

class OnboardingError extends OnboardingState {
  const OnboardingError(this.message);
  final String message;
}
