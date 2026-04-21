import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/staff/data/remote/staff_api_service.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/commission_rule.dart';
import 'package:wameedpos/features/staff/models/shift_schedule.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_activity_log.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';

final staffRepositoryProvider = Provider<StaffRepository>((ref) {
  return StaffRepository(ref.watch(staffApiServiceProvider));
});

class StaffRepository {

  StaffRepository(this._api);
  final StaffApiService _api;

  // ─── Staff CRUD ────────────────────────────────────────────

  Future<PaginatedResult<StaffUser>> listStaff({
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
    String? employmentType,
    String? storeId,
  }) => _api.listStaff(
    page: page,
    perPage: perPage,
    search: search,
    status: status,
    employmentType: employmentType,
    storeId: storeId,
  );

  Future<StaffUser> getStaff(String id) => _api.getStaff(id);

  Future<StaffUser> createStaff(Map<String, dynamic> data) => _api.createStaff(data);

  Future<StaffUser> updateStaff(String id, Map<String, dynamic> data) => _api.updateStaff(id, data);

  Future<void> deleteStaff(String id) => _api.deleteStaff(id);

  Future<void> setPin(String staffId, String pin) => _api.setPin(staffId, pin);

  Future<StaffUser> registerNfc(String staffId, String nfcBadgeUid) => _api.registerNfc(staffId, nfcBadgeUid);

  // ─── Attendance ────────────────────────────────────────────

  Future<PaginatedResult<AttendanceRecord>> listAttendance({
    int page = 1,
    int perPage = 20,
    String? staffUserId,
    String? dateFrom,
    String? dateTo,
  }) => _api.listAttendance(page: page, perPage: perPage, staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo);

  Future<AttendanceRecord> clockIn({required String staffUserId, required String storeId, String? notes}) =>
      _api.clockIn(staffUserId: staffUserId, storeId: storeId, notes: notes);

  Future<AttendanceRecord> clockOut({required String staffUserId, required String storeId, String? notes}) =>
      _api.clockOut(staffUserId: staffUserId, storeId: storeId, notes: notes);

  Future<void> startBreak({required String attendanceRecordId}) => _api.startBreak(attendanceRecordId: attendanceRecordId);

  Future<void> endBreak({required String attendanceRecordId}) => _api.endBreak(attendanceRecordId: attendanceRecordId);

  // ─── Shifts ────────────────────────────────────────────────

  Future<PaginatedResult<ShiftSchedule>> listShifts({
    int page = 1,
    int perPage = 20,
    String? staffUserId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) =>
      _api.listShifts(page: page, perPage: perPage, staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo, status: status);

  Future<ShiftSchedule> createShift(Map<String, dynamic> data) => _api.createShift(data);

  Future<ShiftSchedule> updateShift(String id, Map<String, dynamic> data) => _api.updateShift(id, data);

  Future<void> deleteShift(String id) => _api.deleteShift(id);

  // ─── Shift Templates ──────────────────────────────────────

  Future<List<ShiftTemplate>> listShiftTemplates() => _api.listShiftTemplates();

  Future<ShiftTemplate> createShiftTemplate(Map<String, dynamic> data) => _api.createShiftTemplate(data);

  Future<ShiftTemplate> updateShiftTemplate(String id, Map<String, dynamic> data) => _api.updateShiftTemplate(id, data);

  Future<void> deleteShiftTemplate(String id) => _api.deleteShiftTemplate(id);

  // ─── Attendance Summary ───────────────────────────────────

  Future<Map<String, dynamic>> getAttendanceSummary({String? staffUserId, String? dateFrom, String? dateTo}) =>
      _api.getAttendanceSummary(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo);

  // ─── Bulk Shifts ──────────────────────────────────────────

  Future<List<ShiftSchedule>> bulkCreateShifts(Map<String, dynamic> data) => _api.bulkCreateShifts(data);

  // ─── Commissions ──────────────────────────────────────────

  Future<Map<String, dynamic>> getCommissionSummary(String staffId, {String? dateFrom, String? dateTo}) =>
      _api.getCommissionSummary(staffId, dateFrom: dateFrom, dateTo: dateTo);

  Future<CommissionRule> setCommissionConfig(String staffId, Map<String, dynamic> data) =>
      _api.setCommissionConfig(staffId, data);

  // ─── Activity Log ─────────────────────────────────────────

  Future<PaginatedResult<StaffActivityLog>> getActivityLog(String staffId, {int page = 1, int perPage = 20}) =>
      _api.getActivityLog(staffId, page: page, perPage: perPage);

  // ─── Stats ────────────────────────────────────────────────

  Future<Map<String, dynamic>> getStats() => _api.getStats();

  // ─── Branch Assignments ───────────────────────────────────

  Future<List<BranchAssignment>> listBranchAssignments(String staffId) => _api.listBranchAssignments(staffId);

  Future<BranchAssignment> assignBranch(String staffId, Map<String, dynamic> data) => _api.assignBranch(staffId, data);

  Future<void> unassignBranch(String staffId, String branchId) => _api.unassignBranch(staffId, branchId);

  // ─── Attendance Export ────────────────────────────────────

  Future<Map<String, dynamic>> exportAttendance({String? staffUserId, String? dateFrom, String? dateTo}) =>
      _api.exportAttendance(staffUserId: staffUserId, dateFrom: dateFrom, dateTo: dateTo);

  // ─── User Account Linking ─────────────────────────────────

  Future<StaffUser> linkUser(String staffId, String userId) => _api.linkUser(staffId, userId);

  Future<StaffUser> unlinkUser(String staffId) => _api.unlinkUser(staffId);

  Future<List<Map<String, dynamic>>> getLinkableUsers() => _api.getLinkableUsers();
}
