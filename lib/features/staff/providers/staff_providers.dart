import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';
import 'package:thawani_pos/features/staff/providers/staff_state.dart';
import 'package:thawani_pos/features/staff/repositories/staff_repository.dart';

// ═══════════════════════════════════════════════════════════════
// Staff List Provider
// ═══════════════════════════════════════════════════════════════

final staffListProvider = StateNotifierProvider<StaffListNotifier, StaffListState>((ref) {
  return StaffListNotifier(ref.watch(staffRepositoryProvider));
});

class StaffListNotifier extends StateNotifier<StaffListState> {
  final StaffRepository _repo;

  StaffListNotifier(this._repo) : super(const StaffListInitial());

  Future<void> load({String? search, String? status, String? employmentType}) async {
    state = const StaffListLoading();
    try {
      final result = await _repo.listStaff(search: search, status: status, employmentType: employmentType);
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

  Future<void> loadMore({String? search, String? status, String? employmentType}) async {
    final current = state;
    if (current is! StaffListLoaded || !current.hasMore) return;

    try {
      final result = await _repo.listStaff(
        page: current.currentPage + 1,
        search: search,
        status: status,
        employmentType: employmentType,
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
  final StaffRepository _repo;
  final String _staffId;

  StaffDetailNotifier(this._repo, this._staffId) : super(const StaffDetailInitial());

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
  final StaffRepository _repo;

  AttendanceNotifier(this._repo) : super(const AttendanceInitial());

  Future<void> load({String? staffUserId, String? dateFrom, String? dateTo}) async {
    state = const AttendanceLoading();
    try {
      final result = await _repo.listAttendance(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo);
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
}

// ═══════════════════════════════════════════════════════════════
// Clock Action Provider
// ═══════════════════════════════════════════════════════════════

final clockActionProvider = StateNotifierProvider<ClockActionNotifier, ClockActionState>((ref) {
  return ClockActionNotifier(ref.watch(staffRepositoryProvider));
});

class ClockActionNotifier extends StateNotifier<ClockActionState> {
  final StaffRepository _repo;

  ClockActionNotifier(this._repo) : super(const ClockActionIdle());

  Future<void> clockIn({required String staffUserId, required String storeId, String? notes}) async {
    state = const ClockActionLoading();
    try {
      final record = await _repo.clockIn(staffUserId: staffUserId, storeId: storeId, notes: notes);
      state = ClockActionSuccess(record: record, message: 'Clocked in');
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> clockOut({required String staffUserId, required String storeId, String? notes}) async {
    state = const ClockActionLoading();
    try {
      final record = await _repo.clockOut(staffUserId: staffUserId, storeId: storeId, notes: notes);
      state = ClockActionSuccess(record: record, message: 'Clocked out');
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> startBreak({required String attendanceRecordId}) async {
    state = const ClockActionLoading();
    try {
      await _repo.startBreak(attendanceRecordId: attendanceRecordId);
      // Return idle since break actions don't return a full record
      state = const ClockActionIdle();
    } catch (e) {
      state = ClockActionError(message: e.toString());
    }
  }

  Future<void> endBreak({required String attendanceRecordId}) async {
    state = const ClockActionLoading();
    try {
      await _repo.endBreak(attendanceRecordId: attendanceRecordId);
      state = const ClockActionIdle();
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
  final StaffRepository _repo;

  ShiftNotifier(this._repo) : super(const ShiftInitial());

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
      // Reload to reflect changes
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
// Commission Provider (by staff ID)
// ═══════════════════════════════════════════════════════════════

final commissionProvider = StateNotifierProvider.family<CommissionNotifier, CommissionState, String>((ref, staffId) {
  return CommissionNotifier(ref.watch(staffRepositoryProvider), staffId);
});

class CommissionNotifier extends StateNotifier<CommissionState> {
  final StaffRepository _repo;
  final String _staffId;

  CommissionNotifier(this._repo, this._staffId) : super(const CommissionInitial());

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
  final StaffRepository _repo;

  StaffStatsNotifier(this._repo) : super(const StaffStatsInitial());

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
  final StaffRepository _repo;

  StaffFormNotifier(this._repo) : super(const StaffFormIdle());

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
