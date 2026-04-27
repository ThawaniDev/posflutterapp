import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/constants/api_endpoints.dart';
import 'package:wameedpos/core/network/api_response.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:wameedpos/features/staff/models/attendance_record.dart';
import 'package:wameedpos/features/staff/models/commission_rule.dart';
import 'package:wameedpos/features/staff/models/shift_schedule.dart';
import 'package:wameedpos/features/staff/models/shift_template.dart';
import 'package:wameedpos/features/staff/models/staff_activity_log.dart';
import 'package:wameedpos/features/staff/models/staff_document.dart';
import 'package:wameedpos/features/staff/models/staff_user.dart';
import 'package:wameedpos/features/staff/models/training_session.dart';

final staffApiServiceProvider = Provider<StaffApiService>((ref) {
  return StaffApiService(ref.watch(dioClientProvider));
});

class StaffApiService {
  StaffApiService(this._dio);
  final Dio _dio;

  /// Parses a paginated API response that may be a Map (with pagination meta) or a flat List.
  PaginatedResult<T> _parsePaginated<T>(
    dynamic raw,
    T Function(Map<String, dynamic>) fromJson, {
    int page = 1,
    int perPage = 20,
  }) {
    if (raw is List) {
      final items = raw.map((j) => fromJson(j as Map<String, dynamic>)).toList();
      return PaginatedResult(items: items, total: items.length, currentPage: 1, lastPage: 1, perPage: items.length);
    }
    final map = raw as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  // ─── Staff Members CRUD ───────────────────────────────────

  Future<PaginatedResult<StaffUser>> listStaff({
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
    String? employmentType,
    String? storeId,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.staffMembers,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        'status': ?status,
        'employment_type': ?employmentType,
        'store_id': ?storeId,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return _parsePaginated(apiResponse.data, (j) => StaffUser.fromJson(j), page: page, perPage: perPage);
  }

  Future<StaffUser> getStaff(String staffId) async {
    final response = await _dio.get(ApiEndpoints.staffMemberById(staffId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StaffUser> createStaff(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.staffMembers, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StaffUser> updateStaff(String staffId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.staffMemberById(staffId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteStaff(String staffId) async {
    await _dio.delete(ApiEndpoints.staffMemberById(staffId));
  }

  Future<void> setPin(String staffId, String pin) async {
    await _dio.post(ApiEndpoints.staffMemberPin(staffId), data: {'pin': pin});
  }

  Future<StaffUser> registerNfc(String staffId, String nfcBadgeUid) async {
    final response = await _dio.post(ApiEndpoints.staffMemberNfc(staffId), data: {'nfc_badge_uid': nfcBadgeUid});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Attendance ───────────────────────────────────────────

  Future<PaginatedResult<AttendanceRecord>> listAttendance({
    int page = 1,
    int perPage = 20,
    String? staffUserId,
    String? dateFrom,
    String? dateTo,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.attendance,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'staff_user_id': ?staffUserId,
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return _parsePaginated(apiResponse.data, (j) => AttendanceRecord.fromJson(j), page: page, perPage: perPage);
  }

  Future<AttendanceRecord> clockIn({required String staffUserId, required String storeId, String? notes}) async {
    final response = await _dio.post(
      ApiEndpoints.attendanceClock,
      data: {'action': 'clock_in', 'staff_user_id': staffUserId, 'store_id': storeId, 'notes': ?notes},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AttendanceRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<AttendanceRecord> clockOut({required String staffUserId, required String storeId, String? notes}) async {
    final response = await _dio.post(
      ApiEndpoints.attendanceClock,
      data: {'action': 'clock_out', 'staff_user_id': staffUserId, 'store_id': storeId, 'notes': ?notes},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AttendanceRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> startBreak({required String attendanceRecordId}) async {
    await _dio.post(ApiEndpoints.attendanceClock, data: {'action': 'start_break', 'attendance_record_id': attendanceRecordId});
  }

  Future<void> endBreak({required String attendanceRecordId}) async {
    await _dio.post(ApiEndpoints.attendanceClock, data: {'action': 'end_break', 'attendance_record_id': attendanceRecordId});
  }

  // ─── Shifts ───────────────────────────────────────────────

  Future<PaginatedResult<ShiftSchedule>> listShifts({
    int page = 1,
    int perPage = 20,
    String? staffUserId,
    String? dateFrom,
    String? dateTo,
    String? status,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.shifts,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        'staff_user_id': ?staffUserId,
        'date_from': ?dateFrom,
        'date_to': ?dateTo,
        'status': ?status,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return _parsePaginated(apiResponse.data, (j) => ShiftSchedule.fromJson(j), page: page, perPage: perPage);
  }

  Future<ShiftSchedule> createShift(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.shifts, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ShiftSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<ShiftSchedule> updateShift(String shiftId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.shiftById(shiftId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ShiftSchedule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteShift(String shiftId) async {
    await _dio.delete(ApiEndpoints.shiftById(shiftId));
  }

  // ─── Shift Templates ─────────────────────────────────────

  Future<List<ShiftTemplate>> listShiftTemplates() async {
    final response = await _dio.get(ApiEndpoints.shiftTemplates);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ShiftTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ShiftTemplate> createShiftTemplate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.shiftTemplates, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ShiftTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<ShiftTemplate> updateShiftTemplate(String templateId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.shiftTemplateById(templateId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ShiftTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteShiftTemplate(String templateId) async {
    await _dio.delete(ApiEndpoints.shiftTemplateById(templateId));
  }

  // ─── Attendance Summary ───────────────────────────────────

  Future<Map<String, dynamic>> getAttendanceSummary({String? staffUserId, String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.attendanceSummary,
      queryParameters: {'staff_user_id': ?staffUserId, 'date_from': ?dateFrom, 'date_to': ?dateTo},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Bulk Shifts ──────────────────────────────────────────

  Future<List<ShiftSchedule>> bulkCreateShifts(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.shiftsBulk, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => ShiftSchedule.fromJson(j as Map<String, dynamic>)).toList();
  }

  // ─── Commissions ──────────────────────────────────────────

  Future<Map<String, dynamic>> getCommissionSummary(String staffId, {String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.staffMemberCommissions(staffId),
      queryParameters: {'date_from': ?dateFrom, 'date_to': ?dateTo},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  Future<CommissionRule> setCommissionConfig(String staffId, Map<String, dynamic> data) async {
    final response = await _dio.put(ApiEndpoints.staffMemberCommissionConfig(staffId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return CommissionRule.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Activity Log ─────────────────────────────────────────

  Future<PaginatedResult<StaffActivityLog>> getActivityLog(String staffId, {int page = 1, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.staffMemberActivityLog(staffId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return _parsePaginated(apiResponse.data, (j) => StaffActivityLog.fromJson(j), page: page, perPage: perPage);
  }

  // ─── Staff Stats ──────────────────────────────────────────

  Future<Map<String, dynamic>> getStats() async {
    final response = await _dio.get(ApiEndpoints.staffStats);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── Branch Assignments ───────────────────────────────────

  Future<List<BranchAssignment>> listBranchAssignments(String staffId) async {
    final response = await _dio.get(ApiEndpoints.staffMemberBranchAssignments(staffId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final list = apiResponse.dataList;
    return list.map((j) => BranchAssignment.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<BranchAssignment> assignBranch(String staffId, Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.staffMemberBranchAssignments(staffId), data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return BranchAssignment.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> unassignBranch(String staffId, String branchId) async {
    await _dio.delete(ApiEndpoints.staffMemberBranchAssignments(staffId), data: {'branch_id': branchId});
  }

  // ─── Attendance Export ────────────────────────────────────

  Future<Map<String, dynamic>> exportAttendance({String? staffUserId, String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.attendanceExport,
      queryParameters: {'staff_user_id': ?staffUserId, 'date_from': ?dateFrom, 'date_to': ?dateTo},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.data as Map<String, dynamic>;
  }

  // ─── User Account Linking ─────────────────────────────────

  Future<StaffUser> linkUser(String staffId, String userId) async {
    final response = await _dio.post(ApiEndpoints.staffMemberLinkUser(staffId), data: {'user_id': userId});
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<StaffUser> unlinkUser(String staffId) async {
    final response = await _dio.delete(ApiEndpoints.staffMemberLinkUser(staffId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffUser.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<List<Map<String, dynamic>>> getLinkableUsers() async {
    final response = await _dio.get(ApiEndpoints.staffLinkableUsers);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.dataList.map((j) => j as Map<String, dynamic>).toList();
  }

  // ─── Staff Documents ──────────────────────────────────────

  Future<List<StaffDocument>> listDocuments(String staffId) async {
    final response = await _dio.get(ApiEndpoints.staffMemberDocuments(staffId));
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return apiResponse.dataList.map((j) => StaffDocument.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<StaffDocument> addDocument(
    String staffId, {
    required String documentType,
    required String fileUrl,
    String? expiryDate,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.staffMemberDocuments(staffId),
      data: {'document_type': documentType, 'file_url': fileUrl, if (expiryDate != null) 'expiry_date': expiryDate},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return StaffDocument.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteDocument(String staffId, String docId) async {
    await _dio.delete(ApiEndpoints.staffMemberDocumentById(staffId, docId));
  }

  // ─── Training Sessions ────────────────────────────────────

  Future<Map<String, dynamic>> listTrainingSessions(String staffId, {int page = 1, int perPage = 20}) async {
    final response = await _dio.get(
      ApiEndpoints.staffMemberTrainingSessions(staffId),
      queryParameters: {'page': page, 'per_page': perPage},
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return {
      'sessions': (data['data'] as List).map((j) => TrainingSession.fromJson(j as Map<String, dynamic>)).toList(),
      'total': data['total'] as int,
      'per_page': data['per_page'] as int,
      'current_page': data['current_page'] as int,
      'last_page': data['last_page'] as int,
    };
  }

  Future<TrainingSession> startTrainingSession(String staffId, {String? notes}) async {
    final response = await _dio.post(
      ApiEndpoints.staffMemberTrainingSessions(staffId),
      data: {if (notes != null) 'notes': notes},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TrainingSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<TrainingSession> endTrainingSession(String staffId, String sessionId, {int? transactionsCount, String? notes}) async {
    final response = await _dio.put(
      ApiEndpoints.staffMemberTrainingSessionEnd(staffId, sessionId),
      data: {if (transactionsCount != null) 'transactions_count': transactionsCount, if (notes != null) 'notes': notes},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return TrainingSession.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<void> deleteTrainingSession(String staffId, String sessionId) async {
    await _dio.delete(ApiEndpoints.staffMemberTrainingSessionById(staffId, sessionId));
  }
}
