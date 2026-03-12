import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/onboarding/models/business_type_template.dart';
import 'package:thawani_pos/features/onboarding/models/onboarding_progress.dart';
import 'package:thawani_pos/features/onboarding/models/store_settings.dart';
import 'package:thawani_pos/features/onboarding/models/store_working_hour.dart';

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
  final Store store;
  const StoreLoaded(this.store);
}

class StoreError extends StoreState {
  final String message;
  const StoreError(this.message);
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
  final StoreSettings settings;
  const StoreSettingsLoaded(this.settings);
}

class StoreSettingsError extends StoreSettingsState {
  final String message;
  const StoreSettingsError(this.message);
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
  final List<StoreWorkingHour> hours;
  const WorkingHoursLoaded(this.hours);
}

class WorkingHoursError extends WorkingHoursState {
  final String message;
  const WorkingHoursError(this.message);
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
  final List<BusinessTypeTemplate> templates;
  const BusinessTypesLoaded(this.templates);
}

class BusinessTypesError extends BusinessTypesState {
  final String message;
  const BusinessTypesError(this.message);
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
  final OnboardingProgress progress;
  const OnboardingLoaded(this.progress);
}

class OnboardingError extends OnboardingState {
  final String message;
  const OnboardingError(this.message);
}
