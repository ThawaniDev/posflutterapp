import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/shift_schedule.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';

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

  const StaffListLoaded({
    required this.staff,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });
  final List<StaffUser> staff;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

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

  const StaffListError({required this.message});
  final String message;
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

  const StaffDetailLoaded({required this.staff});
  final StaffUser staff;
}

class StaffDetailSaving extends StaffDetailState {
  const StaffDetailSaving();
}

class StaffDetailSaved extends StaffDetailState {

  const StaffDetailSaved({required this.staff});
  final StaffUser staff;
}

class StaffDetailError extends StaffDetailState {

  const StaffDetailError({required this.message});
  final String message;
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

  const AttendanceLoaded({
    required this.records,
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });
  final List<AttendanceRecord> records;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

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

  const AttendanceError({required this.message});
  final String message;
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

  const ClockActionSuccess({required this.record, required this.message});
  final AttendanceRecord record;
  final String message;
}

class ClockActionError extends ClockActionState {

  const ClockActionError({required this.message});
  final String message;
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

  const ShiftLoaded({
    required this.shifts,
    this.templates = const [],
    required this.total,
    required this.currentPage,
    required this.lastPage,
    this.hasMore = false,
  });
  final List<ShiftSchedule> shifts;
  final List<ShiftTemplate> templates;
  final int total;
  final int currentPage;
  final int lastPage;
  final bool hasMore;

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

  const ShiftError({required this.message});
  final String message;
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

  const CommissionLoaded({required this.summary});
  final Map<String, dynamic> summary;
}

class CommissionError extends CommissionState {

  const CommissionError({required this.message});
  final String message;
}

// ═══════════════════════════════════════════════════════════════
// Attendance Summary State
// ═══════════════════════════════════════════════════════════════

class AttendanceSummary {

  const AttendanceSummary({
    this.totalRecords = 0,
    this.completedRecords = 0,
    this.currentlyClockedIn = 0,
    this.totalWorkHours = 0,
    this.totalBreakHours = 0,
    this.totalOvertimeHours = 0,
    this.avgWorkHours = 0,
    this.onTimeCount = 0,
    this.lateCount = 0,
    this.earlyDepartureCount = 0,
  });

  factory AttendanceSummary.fromJson(Map<String, dynamic> json) {
    return AttendanceSummary(
      totalRecords: (json['total_records'] as num?)?.toInt() ?? 0,
      completedRecords: (json['completed_records'] as num?)?.toInt() ?? 0,
      currentlyClockedIn: (json['currently_clocked_in'] as num?)?.toInt() ?? 0,
      totalWorkHours: (json['total_work_hours'] as num?)?.toDouble() ?? 0,
      totalBreakHours: (json['total_break_hours'] as num?)?.toDouble() ?? 0,
      totalOvertimeHours: (json['total_overtime_hours'] as num?)?.toDouble() ?? 0,
      avgWorkHours: (json['avg_work_hours'] as num?)?.toDouble() ?? 0,
      onTimeCount: (json['on_time_count'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      earlyDepartureCount: (json['early_departure_count'] as num?)?.toInt() ?? 0,
    );
  }
  final int totalRecords;
  final int completedRecords;
  final int currentlyClockedIn;
  final double totalWorkHours;
  final double totalBreakHours;
  final double totalOvertimeHours;
  final double avgWorkHours;
  final int onTimeCount;
  final int lateCount;
  final int earlyDepartureCount;
}

sealed class AttendanceSummaryState {
  const AttendanceSummaryState();
}

class AttendanceSummaryInitial extends AttendanceSummaryState {
  const AttendanceSummaryInitial();
}

class AttendanceSummaryLoading extends AttendanceSummaryState {
  const AttendanceSummaryLoading();
}

class AttendanceSummaryLoaded extends AttendanceSummaryState {

  const AttendanceSummaryLoaded({required this.summary});
  final AttendanceSummary summary;
}

class AttendanceSummaryError extends AttendanceSummaryState {

  const AttendanceSummaryError({required this.message});
  final String message;
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

  const StaffStatsLoaded({
    required this.totalStaff,
    required this.activeStaff,
    required this.inactiveStaff,
    required this.onLeaveStaff,
    required this.clockedInNow,
    required this.todayAttendance,
  });
  final int totalStaff;
  final int activeStaff;
  final int inactiveStaff;
  final int onLeaveStaff;
  final int clockedInNow;
  final int todayAttendance;
}

class StaffStatsError extends StaffStatsState {

  const StaffStatsError({required this.message});
  final String message;
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

  const StaffFormSuccess({required this.staff});
  final StaffUser staff;
}

class StaffFormError extends StaffFormState {

  const StaffFormError({required this.message});
  final String message;
}
