import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/auth/enums/auth_method.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/providers/staff_state.dart';
import 'package:wameedpos/features/staff/repositories/staff_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Staff List Provider
// ═══════════════════════════════════════════════════════════════

final staffListProvider = StateNotifierProvider<StaffListNotifier, StaffListState>((ref) {
  return StaffListNotifier(ref.watch(staffRepositoryProvider));
});

class StaffListNotifier extends StateNotifier<StaffListState> {
  StaffListNotifier(this._repo) : super(const StaffListInitial());
  final StaffRepository _repo;

  Future<void> load({String? search, String? status, String? employmentType, String? storeId}) async {
    state = const StaffListLoading();
    try {
      final result = await _repo.listStaff(search: search, status: status, employmentType: employmentType, storeId: storeId);
      state = StaffListLoaded(
        staff: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasMore: result.currentPage < result.lastPage,
      );
    } catch (e) {
      state = StaffListError(message: e.toString());
    }
  }

  Future<void> loadMore({String? search, String? status, String? employmentType, String? storeId}) async {
    final current = state;
    if (current is! StaffListLoaded || !current.hasMore) return;

    try {
      final result = await _repo.listStaff(
        page: current.currentPage + 1,
        search: search,
        status: status,
        employmentType: employmentType,
        storeId: storeId,
      );
      state = current.copyWith(
        staff: [...current.staff, ...result.items],
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasMore: result.currentPage < result.lastPage,
        total: result.total,
      );
    } catch (e) {
      // Keep current state on load-more failure
    }
  }

  Future<void> deleteStaff(String id) async {
    try {
      await _repo.deleteStaff(id);
      final current = state;
      if (current is StaffListLoaded) {
        state = current.copyWith(staff: current.staff.where((s) => s.id != id).toList(), total: current.total - 1);
      }
    } catch (e) {
      // Rethrow so UI can show error
      rethrow;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Staff Detail Provider (by ID)
// ═══════════════════════════════════════════════════════════════

final staffDetailProvider = StateNotifierProvider.family<StaffDetailNotifier, StaffDetailState, String>((ref, staffId) {
  return StaffDetailNotifier(ref.watch(staffRepositoryProvider), staffId);
});

class StaffDetailNotifier extends StateNotifier<StaffDetailState> {
  StaffDetailNotifier(this._repo, this._staffId) : super(const StaffDetailInitial());
  final StaffRepository _repo;
  final String _staffId;

  Future<void> load() async {
    state = const StaffDetailLoading();
    try {
      final staff = await _repo.getStaff(_staffId);
      state = StaffDetailLoaded(staff: staff);
    } catch (e) {
      state = StaffDetailError(message: e.toString());
    }
  }

  Future<void> save(Map<String, dynamic> data) async {
    state = const StaffDetailSaving();
    try {
      final updated = await _repo.updateStaff(_staffId, data);
      state = StaffDetailSaved(staff: updated);
    } catch (e) {
      state = StaffDetailError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Attendance Provider
// ═══════════════════════════════════════════════════════════════

final attendanceProvider = StateNotifierProvider<AttendanceNotifier, AttendanceState>((ref) {
  return AttendanceNotifier(ref.watch(staffRepositoryProvider));
});

class AttendanceNotifier extends StateNotifier<AttendanceState> {
  AttendanceNotifier(this._repo) : super(const AttendanceInitial());
  final StaffRepository _repo;

  Future<void> load({String? staffUserId, String? dateFrom, String? dateTo, int page = 1}) async {
    state = const AttendanceLoading();
    try {
      final result = await _repo.listAttendance(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo, page: page);
      state = AttendanceLoaded(
        records: result.items,
        total: result.total,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasMore: result.currentPage < result.lastPage,
      );
    } catch (e) {
      state = AttendanceError(message: e.toString());
    }
  }

  Future<void> loadMore({String? staffUserId, String? dateFrom, String? dateTo}) async {
    final current = state;
    if (current is! AttendanceLoaded || !current.hasMore) return;

    try {
      final result = await _repo.listAttendance(
        staffUserId: staffUserId,
        dateFrom: dateFrom,
        dateTo: dateTo,
        page: current.currentPage + 1,
      );
      state = current.copyWith(
        records: [...current.records, ...result.items],
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        hasMore: result.currentPage < result.lastPage,
        total: result.total,
      );
    } catch (_) {}
  }
}

// ═══════════════════════════════════════════════════════════════
// Clock Action Provider
// ═══════════════════════════════════════════════════════════════

final clockActionProvider = StateNotifierProvider<ClockActionNotifier, ClockActionState>((ref) {
  return ClockActionNotifier(ref.watch(staffRepositoryProvider));
});

class ClockActionNotifier extends StateNotifier<ClockActionState> {
  ClockActionNotifier(this._repo) : super(const ClockActionIdle());
  final StaffRepository _repo;

  Future<void> clockIn(AppLocalizations l10n, {required String staffUserId, required String storeId, String? notes}) async {
    state = const ClockActionLoading();
    try {
      final record = await _repo.clockIn(staffUserId: staffUserId, storeId: storeId, notes: notes);
      state = ClockActionSuccess(record: record, message: l10n.staffClockedIn);
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> clockOut(AppLocalizations l10n, {required String staffUserId, required String storeId, String? notes}) async {
    state = const ClockActionLoading();
    try {
      final record = await _repo.clockOut(staffUserId: staffUserId, storeId: storeId, notes: notes);
      state = ClockActionSuccess(record: record, message: l10n.staffClockedOut);
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> startBreak(AppLocalizations l10n, {required String attendanceRecordId}) async {
    state = const ClockActionLoading();
    try {
      await _repo.startBreak(attendanceRecordId: attendanceRecordId);
      state = ClockActionSuccess(
        record: AttendanceRecord(
          id: attendanceRecordId,
          staffUserId: '',
          storeId: '',
          clockInAt: DateTime.now(),
          authMethod: AuthMethod.fromValue('pin'),
        ),
        message: l10n.staffStartBreak,
      );
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> endBreak(AppLocalizations l10n, {required String attendanceRecordId}) async {
    state = const ClockActionLoading();
    try {
      await _repo.endBreak(attendanceRecordId: attendanceRecordId);
      state = ClockActionSuccess(
        record: AttendanceRecord(
          id: attendanceRecordId,
          staffUserId: '',
          storeId: '',
          clockInAt: DateTime.now(),
          authMethod: AuthMethod.fromValue('pin'),
        ),
        message: l10n.staffEndBreak,
      );
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  void reset() => state = const ClockActionIdle();
}

// ═══════════════════════════════════════════════════════════════
// Shift Provider
// ═══════════════════════════════════════════════════════════════

final shiftProvider = StateNotifierProvider<ShiftNotifier, ShiftState>((ref) {
  return ShiftNotifier(ref.watch(staffRepositoryProvider));
});

class ShiftNotifier extends StateNotifier<ShiftState> {
  ShiftNotifier(this._repo) : super(const ShiftInitial());
  final StaffRepository _repo;

  Future<void> load({String? staffUserId, String? dateFrom, String? dateTo, String? status}) async {
    state = const ShiftLoading();
    try {
      final results = await Future.wait([
        _repo.listShifts(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo, status: status),
        _repo.listShiftTemplates(),
      ]);

      final shiftResult = results[0] as dynamic;
      final templates = results[1] as dynamic;

      state = ShiftLoaded(
        shifts: shiftResult.items,
        templates: templates,
        total: shiftResult.total,
        currentPage: shiftResult.currentPage,
        lastPage: shiftResult.lastPage,
        hasMore: shiftResult.currentPage < shiftResult.lastPage,
      );
    } catch (e) {
      state = ShiftError(message: e.toString());
    }
  }

  Future<void> createShift(Map<String, dynamic> data) async {
    try {
      await _repo.createShift(data);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateShift(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateShift(id, data);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> bulkCreateShifts(Map<String, dynamic> data) async {
    try {
      await _repo.bulkCreateShifts(data);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteShift(String id) async {
    try {
      await _repo.deleteShift(id);
      final current = state;
      if (current is ShiftLoaded) {
        state = current.copyWith(shifts: current.shifts.where((s) => s.id != id).toList(), total: current.total - 1);
      }
    } catch (e) {
      rethrow;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Attendance Summary Provider
// ═══════════════════════════════════════════════════════════════

final attendanceSummaryProvider = StateNotifierProvider<AttendanceSummaryNotifier, AttendanceSummaryState>((ref) {
  return AttendanceSummaryNotifier(ref.watch(staffRepositoryProvider));
});

class AttendanceSummaryNotifier extends StateNotifier<AttendanceSummaryState> {
  AttendanceSummaryNotifier(this._repo) : super(const AttendanceSummaryInitial());
  final StaffRepository _repo;

  Future<void> load({String? staffUserId, String? dateFrom, String? dateTo}) async {
    state = const AttendanceSummaryLoading();
    try {
      final data = await _repo.getAttendanceSummary(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo);
      state = AttendanceSummaryLoaded(summary: AttendanceSummary.fromJson(data));
    } catch (e) {
      state = AttendanceSummaryError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Shift Template Provider
// ═══════════════════════════════════════════════════════════════

final shiftTemplateProvider = StateNotifierProvider<ShiftTemplateNotifier, ShiftTemplateState>((ref) {
  return ShiftTemplateNotifier(ref.watch(staffRepositoryProvider));
});

sealed class ShiftTemplateState {
  const ShiftTemplateState();
}

class ShiftTemplateInitial extends ShiftTemplateState {
  const ShiftTemplateInitial();
}

class ShiftTemplateLoading extends ShiftTemplateState {
  const ShiftTemplateLoading();
}

class ShiftTemplateLoaded extends ShiftTemplateState {
  const ShiftTemplateLoaded({required this.templates});
  final List<ShiftTemplate> templates;
}

class ShiftTemplateError extends ShiftTemplateState {
  const ShiftTemplateError({required this.message});
  final String message;
}

class ShiftTemplateNotifier extends StateNotifier<ShiftTemplateState> {
  ShiftTemplateNotifier(this._repo) : super(const ShiftTemplateInitial());
  final StaffRepository _repo;

  Future<void> load() async {
    state = const ShiftTemplateLoading();
    try {
      final templates = await _repo.listShiftTemplates();
      state = ShiftTemplateLoaded(templates: templates);
    } catch (e) {
      state = ShiftTemplateError(message: e.toString());
    }
  }

  Future<void> create(Map<String, dynamic> data) async {
    try {
      await _repo.createShiftTemplate(data);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _repo.updateShiftTemplate(id, data);
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.deleteShiftTemplate(id);
      await load();
    } catch (e) {
      rethrow;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Commission Provider (by staff ID)
// ═══════════════════════════════════════════════════════════════

final commissionProvider = StateNotifierProvider.family<CommissionNotifier, CommissionState, String>((ref, staffId) {
  return CommissionNotifier(ref.watch(staffRepositoryProvider), staffId);
});

class CommissionNotifier extends StateNotifier<CommissionState> {
  CommissionNotifier(this._repo, this._staffId) : super(const CommissionInitial());
  final StaffRepository _repo;
  final String _staffId;

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const CommissionLoading();
    try {
      final summary = await _repo.getCommissionSummary(_staffId, dateFrom: dateFrom, dateTo: dateTo);
      state = CommissionLoaded(summary: summary);
    } catch (e) {
      state = CommissionError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Staff Stats Provider
// ═══════════════════════════════════════════════════════════════

final staffStatsProvider = StateNotifierProvider<StaffStatsNotifier, StaffStatsState>((ref) {
  return StaffStatsNotifier(ref.watch(staffRepositoryProvider));
});

class StaffStatsNotifier extends StateNotifier<StaffStatsState> {
  StaffStatsNotifier(this._repo) : super(const StaffStatsInitial());
  final StaffRepository _repo;

  Future<void> load() async {
    state = const StaffStatsLoading();
    try {
      final data = await _repo.getStats();
      state = StaffStatsLoaded(
        totalStaff: data['total_staff'] as int? ?? 0,
        activeStaff: data['active_staff'] as int? ?? 0,
        inactiveStaff: data['inactive_staff'] as int? ?? 0,
        onLeaveStaff: data['on_leave_staff'] as int? ?? 0,
        clockedInNow: data['clocked_in_now'] as int? ?? 0,
        todayAttendance: data['today_attendance'] as int? ?? 0,
      );
    } catch (e) {
      state = StaffStatsError(message: e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Staff Form Provider (Create / Update)
// ═══════════════════════════════════════════════════════════════

final staffFormProvider = StateNotifierProvider<StaffFormNotifier, StaffFormState>((ref) {
  return StaffFormNotifier(ref.watch(staffRepositoryProvider));
});

class StaffFormNotifier extends StateNotifier<StaffFormState> {
  StaffFormNotifier(this._repo) : super(const StaffFormIdle());
  final StaffRepository _repo;

  Future<void> create(Map<String, dynamic> data) async {
    state = const StaffFormSaving();
    try {
      final staff = await _repo.createStaff(data);
      state = StaffFormSuccess(staff: staff);
    } catch (e) {
      state = StaffFormError(message: e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const StaffFormSaving();
    try {
      final staff = await _repo.updateStaff(id, data);
      state = StaffFormSuccess(staff: staff);
    } catch (e) {
      state = StaffFormError(message: e.toString());
    }
  }

  void reset() => state = const StaffFormIdle();
}

// ═══════════════════════════════════════════════════════════════
// Branch Assignments Provider (by staff ID)
// ═══════════════════════════════════════════════════════════════

final branchAssignmentsProvider = FutureProvider.family<List<BranchAssignment>, String>((ref, staffId) async {
  return ref.watch(staffRepositoryProvider).listBranchAssignments(staffId);
});
