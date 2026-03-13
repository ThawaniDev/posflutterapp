import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/constants/api_endpoints.dart';
import 'package:thawani_pos/core/network/api_response.dart';
import 'package:thawani_pos/core/network/dio_client.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/staff/models/attendance_record.dart';
import 'package:thawani_pos/features/staff/models/commission_rule.dart';
import 'package:thawani_pos/features/staff/models/shift_schedule.dart';
import 'package:thawani_pos/features/staff/models/shift_template.dart';
import 'package:thawani_pos/features/staff/models/staff_activity_log.dart';
import 'package:thawani_pos/features/staff/models/staff_user.dart';

final staffApiServiceProvider = Provider<StaffApiService>((ref) {
  return StaffApiService(ref.watch(dioClientProvider));
});

class StaffApiService {
  final Dio _dio;

  StaffApiService(this._dio);

  // ─── Staff Members CRUD ───────────────────────────────────

  Future<PaginatedResult<StaffUser>> listStaff({
    int page = 1,
    int perPage = 20,
    String? search,
    String? status,
    String? employmentType,
  }) async {
    final response = await _dio.get(
      ApiEndpoints.staffMembers,
      queryParameters: {
        'page': page,
        'per_page': perPage,
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null) 'status': status,
        if (employmentType != null) 'employment_type': employmentType,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StaffUser.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
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
        if (staffUserId != null) 'staff_user_id': staffUserId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => AttendanceRecord.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }

  Future<AttendanceRecord> clockIn({required String staffUserId, required String storeId, String? notes}) async {
    final response = await _dio.post(
      ApiEndpoints.attendanceClock,
      data: {'action': 'clock_in', 'staff_user_id': staffUserId, 'store_id': storeId, if (notes != null) 'notes': notes},
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return AttendanceRecord.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  Future<AttendanceRecord> clockOut({required String staffUserId, required String storeId, String? notes}) async {
    final response = await _dio.post(
      ApiEndpoints.attendanceClock,
      data: {'action': 'clock_out', 'staff_user_id': staffUserId, 'store_id': storeId, if (notes != null) 'notes': notes},
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
        if (staffUserId != null) 'staff_user_id': staffUserId,
        if (dateFrom != null) 'date_from': dateFrom,
        if (dateTo != null) 'date_to': dateTo,
        if (status != null) 'status': status,
      },
    );
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => ShiftSchedule.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
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
    final list = apiResponse.data as List;
    return list.map((j) => ShiftTemplate.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<ShiftTemplate> createShiftTemplate(Map<String, dynamic> data) async {
    final response = await _dio.post(ApiEndpoints.shiftTemplates, data: data);
    final apiResponse = ApiResponse.fromJson(response.data, (data) => data);
    return ShiftTemplate.fromJson(apiResponse.data as Map<String, dynamic>);
  }

  // ─── Commissions ──────────────────────────────────────────

  Future<Map<String, dynamic>> getCommissionSummary(String staffId, {String? dateFrom, String? dateTo}) async {
    final response = await _dio.get(
      ApiEndpoints.staffMemberCommissions(staffId),
      queryParameters: {if (dateFrom != null) 'date_from': dateFrom, if (dateTo != null) 'date_to': dateTo},
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
    final map = apiResponse.data as Map<String, dynamic>;
    final items = (map['data'] as List).map((j) => StaffActivityLog.fromJson(j as Map<String, dynamic>)).toList();
    return PaginatedResult(
      items: items,
      total: map['total'] as int? ?? items.length,
      currentPage: map['current_page'] as int? ?? page,
      lastPage: map['last_page'] as int? ?? 1,
      perPage: map['per_page'] as int? ?? perPage,
    );
  }
}
