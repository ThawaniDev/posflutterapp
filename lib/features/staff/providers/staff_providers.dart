import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/auth/enums/auth_method.dart';
import 'package:wameedpos/features/staff/data/remote/role_api_service.dart';
import 'package:wameedpos/features/staff/data/remote/staff_api_service.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_document.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/models/training_session.dart';
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

// ═══════════════════════════════════════════════════════════════
// Staff Documents Provider (by staff ID)
// ═══════════════════════════════════════════════════════════════

final staffDocumentsProvider = StateNotifierProvider.family<StaffDocumentsNotifier, AsyncValue<List<StaffDocument>>, String>((
  ref,
  staffId,
) {
  return StaffDocumentsNotifier(ref.watch(staffApiServiceProvider), staffId);
});

class StaffDocumentsNotifier extends StateNotifier<AsyncValue<List<StaffDocument>>> {
  StaffDocumentsNotifier(this._api, this._staffId) : super(const AsyncValue.loading()) {
    load();
  }
  final StaffApiService _api;
  final String _staffId;

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final docs = await _api.listDocuments(_staffId);
      state = AsyncValue.data(docs);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> add({required String documentType, required String fileUrl, String? expiryDate}) async {
    try {
      final doc = await _api.addDocument(_staffId, documentType: documentType, fileUrl: fileUrl, expiryDate: expiryDate);
      state = AsyncValue.data([...state.value ?? [], doc]);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  Future<void> remove(String docId) async {
    await _api.deleteDocument(_staffId, docId);
    state = AsyncValue.data((state.value ?? []).where((d) => d.id != docId).toList());
  }
}

// ═══════════════════════════════════════════════════════════════
// Training Sessions Provider (by staff ID)
// ═══════════════════════════════════════════════════════════════

final trainingSessionsProvider = StateNotifierProvider.family<TrainingSessionsNotifier, TrainingSessionsState, String>((
  ref,
  staffId,
) {
  return TrainingSessionsNotifier(ref.watch(staffApiServiceProvider), staffId);
});

class TrainingSessionsState {
  const TrainingSessionsState({
    this.sessions = const [],
    this.isLoading = false,
    this.error,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
  });
  final List<TrainingSession> sessions;
  final bool isLoading;
  final String? error;
  final int total;
  final int currentPage;
  final int lastPage;

  bool get hasMore => currentPage < lastPage;

  TrainingSessionsState copyWith({
    List<TrainingSession>? sessions,
    bool? isLoading,
    String? error,
    int? total,
    int? currentPage,
    int? lastPage,
  }) {
    return TrainingSessionsState(
      sessions: sessions ?? this.sessions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
    );
  }
}

class TrainingSessionsNotifier extends StateNotifier<TrainingSessionsState> {
  TrainingSessionsNotifier(this._api, this._staffId) : super(const TrainingSessionsState(isLoading: true)) {
    load();
  }
  final StaffApiService _api;
  final String _staffId;

  Future<void> load({int page = 1}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _api.listTrainingSessions(_staffId, page: page, perPage: 20);
      final sessions = result['sessions'] as List<TrainingSession>;
      state = state.copyWith(
        sessions: page == 1 ? sessions : [...state.sessions, ...sessions],
        isLoading: false,
        total: result['total'] as int,
        currentPage: result['current_page'] as int,
        lastPage: result['last_page'] as int,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<TrainingSession?> start({String? notes}) async {
    try {
      final session = await _api.startTrainingSession(_staffId, notes: notes);
      state = state.copyWith(sessions: [session, ...state.sessions], total: state.total + 1);
      return session;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<bool> end(String sessionId, {int? transactionsCount, String? notes}) async {
    try {
      final updated = await _api.endTrainingSession(_staffId, sessionId, transactionsCount: transactionsCount, notes: notes);
      state = state.copyWith(sessions: state.sessions.map((s) => s.id == sessionId ? updated : s).toList());
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> remove(String sessionId) async {
    try {
      await _api.deleteTrainingSession(_staffId, sessionId);
      state = state.copyWith(sessions: state.sessions.where((s) => s.id != sessionId).toList(), total: state.total - 1);
      return true;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// Role Audit Log Provider
// ═══════════════════════════════════════════════════════════════

final roleAuditLogProvider = StateNotifierProvider<RoleAuditLogNotifier, RoleAuditLogState>((ref) {
  return RoleAuditLogNotifier(ref.watch(roleApiServiceProvider));
});

class RoleAuditLogState {
  const RoleAuditLogState({
    this.entries = const [],
    this.isLoading = false,
    this.error,
    this.total = 0,
    this.currentPage = 1,
    this.lastPage = 1,
    this.filterAction,
    this.filterDateFrom,
    this.filterDateTo,
  });
  final List<Map<String, dynamic>> entries;
  final bool isLoading;
  final String? error;
  final int total;
  final int currentPage;
  final int lastPage;
  final String? filterAction;
  final String? filterDateFrom;
  final String? filterDateTo;

  bool get hasMore => currentPage < lastPage;

  RoleAuditLogState copyWith({
    List<Map<String, dynamic>>? entries,
    bool? isLoading,
    String? error,
    int? total,
    int? currentPage,
    int? lastPage,
    String? filterAction,
    String? filterDateFrom,
    String? filterDateTo,
  }) {
    return RoleAuditLogState(
      entries: entries ?? this.entries,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      total: total ?? this.total,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      filterAction: filterAction ?? this.filterAction,
      filterDateFrom: filterDateFrom ?? this.filterDateFrom,
      filterDateTo: filterDateTo ?? this.filterDateTo,
    );
  }
}

class RoleAuditLogNotifier extends StateNotifier<RoleAuditLogState> {
  RoleAuditLogNotifier(this._api) : super(const RoleAuditLogState(isLoading: true)) {
    load();
  }
  final RoleApiService _api;

  Future<void> load({int page = 1, bool refresh = false}) async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await _api.getRoleAuditLog(
        action: state.filterAction,
        dateFrom: state.filterDateFrom,
        dateTo: state.filterDateTo,
        page: page,
        perPage: 25,
      );
      final entries = result['entries'] as List<Map<String, dynamic>>;
      state = state.copyWith(
        entries: (page == 1 || refresh) ? entries : [...state.entries, ...entries],
        isLoading: false,
        total: result['total'] as int,
        currentPage: result['current_page'] as int,
        lastPage: result['last_page'] as int,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void applyFilters({String? action, String? dateFrom, String? dateTo}) {
    state = RoleAuditLogState(isLoading: true, filterAction: action, filterDateFrom: dateFrom, filterDateTo: dateTo);
    load(page: 1, refresh: true);
  }

  void clearFilters() {
    state = const RoleAuditLogState(isLoading: true);
    load(page: 1, refresh: true);
  }
}
