import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/settings/models/store_settings.dart';
import 'package:thawani_pos/features/settings/models/working_hour.dart';
import 'package:thawani_pos/features/settings/repositories/settings_repository.dart';

// ─── States ──────────────────────────────────────────────────

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

class StoreSettingsSaving extends StoreSettingsState {
  final StoreSettings settings;
  const StoreSettingsSaving(this.settings);
}

class StoreSettingsSaved extends StoreSettingsState {
  final StoreSettings settings;
  const StoreSettingsSaved(this.settings);
}

// ─── Working Hours States ────────────────────────────────────

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
  final List<WorkingHour> hours;
  const WorkingHoursLoaded(this.hours);
}

class WorkingHoursError extends WorkingHoursState {
  final String message;
  const WorkingHoursError(this.message);
}

class WorkingHoursSaving extends WorkingHoursState {
  final List<WorkingHour> hours;
  const WorkingHoursSaving(this.hours);
}

class WorkingHoursSaved extends WorkingHoursState {
  final List<WorkingHour> hours;
  const WorkingHoursSaved(this.hours);
}

// ─── Store Settings Notifier ─────────────────────────────────

final storeSettingsProvider = StateNotifierProvider<StoreSettingsNotifier, StoreSettingsState>(
  (ref) => StoreSettingsNotifier(ref.watch(settingsRepositoryProvider)),
);

class StoreSettingsNotifier extends StateNotifier<StoreSettingsState> {
  final SettingsRepository _repo;

  StoreSettingsNotifier(this._repo) : super(const StoreSettingsInitial());

  Future<void> load(String storeId) async {
    state = const StoreSettingsLoading();
    try {
      final res = await _repo.getSettings(storeId: storeId);
      final data = res['data'] as Map<String, dynamic>;
      state = StoreSettingsLoaded(StoreSettings.fromJson(data));
    } catch (e) {
      state = StoreSettingsError(e.toString());
    }
  }

  Future<void> update(String storeId, Map<String, dynamic> data) async {
    final current = state;
    final settings = current is StoreSettingsLoaded
        ? current.settings
        : current is StoreSettingsSaved
        ? current.settings
        : null;
    if (settings != null) {
      state = StoreSettingsSaving(settings);
    }
    try {
      final res = await _repo.updateSettings(storeId: storeId, data: data);
      final updated = res['data'] as Map<String, dynamic>;
      state = StoreSettingsSaved(StoreSettings.fromJson(updated));
    } catch (e) {
      if (settings != null) {
        state = StoreSettingsLoaded(settings);
      }
      rethrow;
    }
  }
}

// ─── Working Hours Notifier ──────────────────────────────────

final workingHoursProvider = StateNotifierProvider<WorkingHoursNotifier, WorkingHoursState>(
  (ref) => WorkingHoursNotifier(ref.watch(settingsRepositoryProvider)),
);

class WorkingHoursNotifier extends StateNotifier<WorkingHoursState> {
  final SettingsRepository _repo;

  WorkingHoursNotifier(this._repo) : super(const WorkingHoursInitial());

  Future<void> load(String storeId) async {
    state = const WorkingHoursLoading();
    try {
      final res = await _repo.getWorkingHours(storeId: storeId);
      final list = res['data'] as List? ?? [];
      final hours = list.map((e) => WorkingHour.fromJson(e as Map<String, dynamic>)).toList()
        ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
      state = WorkingHoursLoaded(hours);
    } catch (e) {
      state = WorkingHoursError(e.toString());
    }
  }

  Future<void> update(String storeId, List<WorkingHour> hours) async {
    state = WorkingHoursSaving(hours);
    try {
      final days = hours.map((h) => h.toJson()).toList();
      final res = await _repo.updateWorkingHours(storeId: storeId, days: days);
      final list = res['data'] as List? ?? [];
      final updated = list.map((e) => WorkingHour.fromJson(e as Map<String, dynamic>)).toList()
        ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
      state = WorkingHoursSaved(updated);
    } catch (e) {
      if (hours.isNotEmpty) {
        state = WorkingHoursLoaded(hours);
      }
      rethrow;
    }
  }
}
