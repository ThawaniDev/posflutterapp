import 'package:thawani_pos/features/staff/models/attendance_record.dart';
import 'package:thawani_pos/features/staff/models/shift_schedule.dart';
import 'package:thawani_pos/features/staff/models/shift_template.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';

// ═══════════════════════════════════════════════════════════════
// Staff List State
// ═══════════════════════════════════════════════════════════════

sealed class StaffListState {
  const StaffListState();
}

class StaffListInitial extends StaffListState {
  const StaffListInitial();
}

class StaffListLoading extends StaffListState {
  const StaffListLoading();
}

class StaffListLoaded extends StaffListState {
  final List<StaffUser> staff;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const StaffListLoaded({
    required this.staff,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });

  StaffListLoaded copyWith({List<StaffUser>? staff, int? total, int? currentPage, int? lastPage, bool? hasMore}) =>
      StaffListLoaded(
        staff: staff ?? this.staff,
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        hasMore: hasMore ?? this.hasMore,
      );
}

class StaffListError extends StaffListState {
  final String message;

  const StaffListError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Staff Detail State
// ═══════════════════════════════════════════════════════════════

sealed class StaffDetailState {
  const StaffDetailState();
}

class StaffDetailInitial extends StaffDetailState {
  const StaffDetailInitial();
}

class StaffDetailLoading extends StaffDetailState {
  const StaffDetailLoading();
}

class StaffDetailLoaded extends StaffDetailState {
  final StaffUser staff;

  const StaffDetailLoaded({required this.staff});
}

class StaffDetailSaving extends StaffDetailState {
  const StaffDetailSaving();
}

class StaffDetailSaved extends StaffDetailState {
  final StaffUser staff;

  const StaffDetailSaved({required this.staff});
}

class StaffDetailError extends StaffDetailState {
  final String message;

  const StaffDetailError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Attendance State
// ═══════════════════════════════════════════════════════════════

sealed class AttendanceState {
  const AttendanceState();
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceLoaded extends AttendanceState {
  final List<AttendanceRecord> records;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const AttendanceLoaded({
    required this.records,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });

  AttendanceLoaded copyWith({List<AttendanceRecord>? records, int? total, int? currentPage, int? lastPage, bool? hasMore}) =>
      AttendanceLoaded(
        records: records ?? this.records,
        total: total ?? this.total,
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
        hasMore: hasMore ?? this.hasMore,
      );
}

class AttendanceError extends AttendanceState {
  final String message;

  const AttendanceError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Clock Action State (for clock in/out/break operations)
// ═══════════════════════════════════════════════════════════════

sealed class ClockActionState {
  const ClockActionState();
}

class ClockActionIdle extends ClockActionState {
  const ClockActionIdle();
}

class ClockActionLoading extends ClockActionState {
  const ClockActionLoading();
}

class ClockActionSuccess extends ClockActionState {
  final AttendanceRecord record;
  final String message;

  const ClockActionSuccess({required this.record, required this.message});
}

class ClockActionError extends ClockActionState {
  final String message;

  const ClockActionError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Shift State
// ═══════════════════════════════════════════════════════════════

sealed class ShiftState {
  const ShiftState();
}

class ShiftInitial extends ShiftState {
  const ShiftInitial();
}

class ShiftLoading extends ShiftState {
  const ShiftLoading();
}

class ShiftLoaded extends ShiftState {
  final List<ShiftSchedule> shifts;
  final List<ShiftTemplate> templates;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

  const ShiftLoaded({
    required this.shifts,
    this.templates = const [],
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });

  ShiftLoaded copyWith({
    List<ShiftSchedule>? shifts,
    List<ShiftTemplate>? templates,
    int? total,
    int? currentPage,
    int? lastPage,
    bool? hasMore,
  }) => ShiftLoaded(
    shifts: shifts ?? this.shifts,
    templates: templates ?? this.templates,
    total: total ?? this.total,
    currentPage: currentPage ?? this.currentPage,
    lastPage: lastPage ?? this.lastPage,
    hasMore: hasMore ?? this.hasMore,
  );
}

class ShiftError extends ShiftState {
  final String message;

  const ShiftError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Commission State
// ═══════════════════════════════════════════════════════════════

sealed class CommissionState {
  const CommissionState();
}

class CommissionInitial extends CommissionState {
  const CommissionInitial();
}

class CommissionLoading extends CommissionState {
  const CommissionLoading();
}

class CommissionLoaded extends CommissionState {
  final Map<String, dynamic> summary;

  const CommissionLoaded({required this.summary});
}

class CommissionError extends CommissionState {
  final String message;

  const CommissionError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Staff Stats State
// ═══════════════════════════════════════════════════════════════

sealed class StaffStatsState {
  const StaffStatsState();
}

class StaffStatsInitial extends StaffStatsState {
  const StaffStatsInitial();
}

class StaffStatsLoading extends StaffStatsState {
  const StaffStatsLoading();
}

class StaffStatsLoaded extends StaffStatsState {
  final int totalStaff;
  final int activeStaff;
  final int inactiveStaff;
  final int onLeaveStaff;
  final int clockedInNow;
  final int todayAttendance;

  const StaffStatsLoaded({
    required this.totalStaff,
    required this.activeStaff,
    required this.inactiveStaff,
    required this.onLeaveStaff,
    required this.clockedInNow,
    required this.todayAttendance,
  });
}

class StaffStatsError extends StaffStatsState {
  final String message;

  const StaffStatsError({required this.message});
}

// ═══════════════════════════════════════════════════════════════
// Staff Form State (Create / Update)
// ═══════════════════════════════════════════════════════════════

sealed class StaffFormState {
  const StaffFormState();
}

class StaffFormIdle extends StaffFormState {
  const StaffFormIdle();
}

class StaffFormSaving extends StaffFormState {
  const StaffFormSaving();
}

class StaffFormSuccess extends StaffFormState {
  final StaffUser staff;

  const StaffFormSuccess({required this.staff});
}

class StaffFormError extends StaffFormState {
  final String message;

  const StaffFormError({required this.message});
}
